public class HL_Opportunity extends TriggerHandler {

    protected override void before() {
        for (Opportunity opportunity : (List<Opportunity>) Trigger.New) {
            //Realizamos la validacion de la cuenta bancaria
            if (opportunity.Cuenta_Bancaria_de_mandato__c != null && !String.isBlank(opportunity.Cuenta_Bancaria_de_mandato__c)) {
                if (opportunity.Cuenta_Bancaria_de_mandato__c.substring(0, 1).isAlpha()) {
                    //Si el IBAN introducido cuenta con guiones o espacios en blanco, estos se suprimen
                        opportunity.Cuenta_Bancaria_de_mandato__c=opportunity.Cuenta_Bancaria_de_mandato__c.replace(' ' ,'');
    					opportunity.Cuenta_Bancaria_de_mandato__c=opportunity.Cuenta_Bancaria_de_mandato__c.replace('-' ,'');
                    if (opportunity.Cuenta_Bancaria_de_mandato__c.substring(0, 2).equals('ES')) {
                        boolean validacion = ValidadorUtil.esCuentaBancaria(opportunity.Cuenta_Bancaria_de_mandato__c);
                        if (!validacion) {
                            if (!System.Test.isRunningTest()) {
                                opportunity.addError('El Nº de cuenta o no es válido, por favor revíselo');
                            }
                        }
                    }
                } else {
                    opportunity.addError('El Nº de cuenta no tiene el IBAN correctamente informado, por favor revíselo');
                }

            }
        }
    }
	
    
    protected override void beforeUpdate() {
        Map<Id, Opportunity> olds = (Map<Id, Opportunity>) Trigger.oldMap;
        Map<Id, Opportunity> news = (Map<Id, Opportunity>) Trigger.newMap;
        
        for(Opportunity o : news.values()) {
            if(olds.get(o.Id).StageName != o.StageName)
                o.LastStageName__c = olds.get(o.Id).StageName;
        }
        
        List <Participante__c> parts = [SELECT Porcentaje_de_participacion__c, Opportunity__c FROM Participante__c WHERE Opportunity__c = :(List<Opportunity>) Trigger.New];
        Map<Id, List<Participante__c>> participantesMap = new Map<Id, List<Participante__c>>();
        for(Participante__c p : parts) {
            if(!participantesMap.containsKey(p.Opportunity__c)) participantesMap.put(p.Opportunity__c, new List<Participante__c>());
            participantesMap.get(p.Opportunity__c).add(p);
        }
        
        for (Opportunity opportunity : (List<Opportunity>) Trigger.New) {
            //JNM 18/07/2019. Introducimos validación para que el porcentaje de asignación de participantes sea del 100%
            decimal sumaPart = 0.0;

            //Buscamos los participantes de la promoción
            List<Participante__c> participantes = participantesMap.get(opportunity.Id);
            if(participantes != null && !participantes.isEmpty()){
                //Recorremos los participantes y recogemos el valor del porcentaje de asignación
                for (Participante__c p : participantes) {
                    sumaPart = sumaPart + p.Porcentaje_de_participacion__c;
                }
                
                if(!participantes.isEmpty() && olds.get(opportunity.Id).StageName != opportunity.StageName)
                    if(sumaPart < 100 || sumaPart > 100)
                        opportunity.addError('El porcentaje de asignación de los participantes debe ser del 100%');

                //Actualizamos el valor de la suma en el campo que tiene el recuento
                opportunity.Asignacion_participantes__c = sumaPart;
            }
        }
    }

    public static void afterUpdate(list<Opportunity> lNewOpp, map<Id, Opportunity> mOldOpp) {
        system.debug('OPORTUNIDAD -- Entra en after update ');
        /*actualizarEstado((Map<id, Opportunity>) Trigger.NewMap, (Map<id, Opportunity>) Trigger.OldMap);*/
        
        recalculoComisiones(lNewOpp, mOldOpp);

        // SI EL ESTADO ES RESERVA PENDIENTE DE COBRO LLAMAR A AML
        /*Map<Id, Opportunity> opps = (Map<Id, Opportunity>) Trigger.NewMap;
        Map<Id, Opportunity> oldOpps = (Map<Id, Opportunity>) Trigger.OldMap;
        if(!Test.isRunningTest()) {
            for(Id oppId : opps.keySet()) {
                Opportunity opp = opps.get(oppId);
                Opportunity oldOpp = oldOpps.get(oppId);
                if (opp.StageName != oldOpp.StageName && opp.StageName == 'Reserva Pdte. Cobro') {
                    sendAmlRequest(opp.Id);
                }
            }
        }*/
    }

    /********************* Métodos auxiliares *****************/

    /*private void actualizarEstado(Map<id, Opportunity> newMap, Map<id, Opportunity> oldMap) {
        system.debug('Entre metodo actualizar estados');
        Set<id> setOportunidades = new Set<id>();
        Set<id> setProductosOportunidad = new Set<id>();

        //Obtener los IDs de las oportunidades modificadas
        for (id opp : newMap.keySet())
            setOportunidades.add(opp);
        

        //Obtener los productos de oportunidad de las oportunidades modificadas
        Map<id, OpportunityLineItem> productosOportunidad = new Map<id, OpportunityLineItem>([
                SELECT id,name, Product2Id
                FROM OpportunityLineItem
                WHERE OpportunityId IN :setOportunidades
        ]);

        //Obtener los Ids de los inmuebles asociados
        for (id popp : productosOportunidad.keySet())
            setProductosOportunidad.add(productosOportunidad.get(popp).Product2Id);
        

        //Obtener los inmuebles relacionados con las oportunidades modificadas
        Map<id, Product2> mapInmuebles = new Map<id, Product2>([SELECT id, estado__c FROM Product2 WHERE id IN :setProductosOportunidad]);
        List<Product2> inmueblesToUpdate = new List<Product2>();
        //Recorrer oportunidades
        for (id opp : newMap.keySet()) {
            if (newMap.get(opp).StageName == 'Cancelada' && newMap.get(opp).StageName != oldMap.get(opp).StageName) {
                for (id inm : mapInmuebles.keySet()) {
                    Product2 inmueble = new Product2();
                    inmueble.id = inm;
                    inmueble.Estado__c = 'Libre';
                    inmueblesToUpdate.add(inmueble);

                    /*
                    if (mapInmuebles.get(inm).Estado__c == 'Apalabrado') {
                        System.debug('Estado inmueble --> Apalabrado -- Libre');
                        Product2 inmueble = new Product2();

                        inmueble.id = inm;
                        inmueble.Estado__c = 'Libre';

                        mapInmueblesUpdate.put(inm, inmueble);

                    } else if (mapInmuebles.get(inm).Estado__c == 'Bloqueado') {
                        System.debug('Estado inmueble --> Bloqueado -- Cancelado');
                        Product2 inmueble = new Product2();

                        inmueble.id = inm;
                        inmueble.Estado__c = 'Cancelado';

                        mapInmueblesUpdate.put(inm, inmueble);
                    }
                    */

               /* }

            }

        }//Fin for oportunidades

        update inmueblesToUpdate;
    }*/

    /*@Future(callout=true)
    private static void sendAmlRequest(Id oppId) {
        AmlCheckOportunidadWSV1 amlClient = new AmlCheckOportunidadWSV1();
        amlClient.authentication();
        amlClient.createProposal(oppId);
    }*/
    
    //Creado BCF 04-02-2022
    public static void recalculoComisiones(List<Opportunity> lNewOpp, Map<Id, Opportunity> oldMap){
        
        Set<Opportunity> sOportunidades = new Set<Opportunity>();
        Map<Id, Opportunity> mOportunidades = new Map<Id, Opportunity>();
        Set<OpportunityLineItem> sProductosOportunidad = new Set<OpportunityLineItem>();

        //Obtener los IDs de las oportunidades modificadas con fechas anteoriores al mes y año actual
        for (Opportunity opp : lNewOpp){
            
            if(opp.StageName == 'Cancelada' && opp.StageName != oldMap.get(opp.Id).StageName && 
               ((opp.Fecha_firma_Contrato_Reserva__c != null && opp.Fecha_firma_Contrato_Reserva__c.month() < Date.today().month() && opp.Fecha_firma_Contrato_Reserva__c.year() == Date.today().year()) ||
                (opp.Fecha_firma_Contrato_Reserva__c != null && opp.Fecha_firma_Contrato_Reserva__c.year() < Date.today().year()) || (opp.Fecha_firma_Contrato_Compraventa__c != null && opp.Fecha_firma_Contrato_Compraventa__c.year() < Date.today().year()) ||
                (opp.Fecha_firma_Contrato_Compraventa__c != null && opp.Fecha_firma_Contrato_Compraventa__c.month() < Date.today().month() && opp.Fecha_firma_Contrato_Compraventa__c.year() == Date.today().year()) || 
                (opp.FechaEscrituracionReal__c != null && opp.FechaEscrituracionReal__c.month() < Date.today().month() && opp.FechaEscrituracionReal__c.year() == Date.today().year()) ||
                (opp.FechaEscrituracionReal__c != null && opp.FechaEscrituracionReal__c.year() < Date.today().year()) || (opp.FechaPosventa__c != null && opp.FechaPosventa__c.year() < Date.today().year()) ||
                (opp.FechaPosventa__c != null && opp.FechaPosventa__c.month() < Date.today().month() && opp.FechaPosventa__c.year() == Date.today().year()) )){
                    
                sOportunidades.add(opp);
                mOportunidades.put(opp.Id, opp);
            }
        }
        
        if(sOportunidades != null && !sOportunidades.isEmpty()){
            
            //Puede haber 2 vendedores con el mismo producto
            Map<Id, OpportunityLineItem> mProductosOportunidad = new Map<Id, OpportunityLineItem>([SELECT Id, name, Product2Id, OpportunityId, UnitPrice
                                                                                                   FROM OpportunityLineItem
                                                                                                   WHERE OpportunityId IN :sOportunidades]);
    
            List<RelacionVendedorProductoOportunidad__c> lRelacionVendedor = ([SELECT id, Vendedor__c, ProductoOportunidad__c, PorcentajeComision__c
                                                                               FROM RelacionVendedorProductoOportunidad__c
                                                                               WHERE ProductoOportunidad__c IN :mProductosOportunidad.keySet()]); //sProductosOportunidad
            
            Map<Id,List<OpportunityLineItem>> mProductosVendedor = new Map<id, List<OpportunityLineItem>>(); //Vendedor, lista productos Opp
            
            for(RelacionVendedorProductoOportunidad__c relacion : lRelacionVendedor){
                if(mProductosVendedor.containsKey(relacion.Vendedor__c)){
                    List<OpportunityLineItem> lProductoOpp = mProductosVendedor.get(relacion.Vendedor__c);
                    lProductoOpp.add(mProductosOportunidad.get(relacion.ProductoOportunidad__c));
                    mProductosVendedor.put(relacion.Vendedor__c, lProductoOpp);

                }else{
                    List<OpportunityLineItem> lProductoOpp = new List<OpportunityLineItem>();
                    lProductoOpp.add(mProductosOportunidad.get(relacion.ProductoOportunidad__c));
                    mProductosVendedor.put(relacion.Vendedor__c, lProductoOpp);
                }
            }
            
            String mesActual = Date.today().month().format();
            String yearActual = Date.today().year().format();
            
            List<DetalleComision__c> lDetalles = ([SELECT Vendedor__c, ProductoOportunidad__c, Promocion__c, ImporteContrato__c, ImporteReserva__c,  ImporteEscrituracion__c, ImportePosventa__c, Comision__c, Mes__c
                                                   FROM DetalleComision__c
                                                   WHERE ProductoOportunidad__c IN :mProductosOportunidad.keySet() AND ((Mes__c != :mesActual AND Year__C = :yearActual) OR Year__c != :yearActual)]);
            
            Set<Id> SVendedores = new Set<Id>();
            for(DetalleComision__c det : lDetalles){
                if(!SVendedores.contains(det.Vendedor__c))
                	SVendedores.add(det.Vendedor__c);
            }
                     
            Map<DetalleComision__c, OpportunityLineItem> mProductosDetalle = new Map<DetalleComision__c, OpportunityLineItem>();// Mapa detalle, producto
            
            //Puede haber 2 vendedores con el mismo producto
            for(DetalleComision__c det : lDetalles){
                if(mProductosVendedor.containsKey(det.Vendedor__c)){
                    for(OpportunityLineItem prod : mProductosVendedor.get(det.Vendedor__c)){
                        if(prod.Id == det.ProductoOportunidad__c){
                            mProductosDetalle.put(det, prod);
                        }
                    }
                }
            }
            
            for(DetalleComision__c det : lDetalles){
                if(!mProductosDetalle.containsKey(det)){
                    mProductosDetalle.put(det, mProductosOportunidad.get(det.ProductoOportunidad__c));
                }
            }
           
            //Mapa vendedor lista de detalles
            Map<Id, List<DetalleComision__c>> mVendedorDetalle = new Map<Id, List<DetalleComision__c>>();
            
            for(DetalleComision__c det : lDetalles){
                if(mVendedorDetalle.containsKey(det.Vendedor__c)){
                    List<DetalleComision__c> lDetalleComision = mVendedorDetalle.get(det.Vendedor__c);
                    lDetalleComision.add(det);
                    mVendedorDetalle.put(det.Vendedor__c, lDetalleComision);

                }else{
                    List<DetalleComision__c> lDetalleComision = new List<DetalleComision__c>();
                    lDetalleComision.add(det);
                    mVendedorDetalle.put(det.Vendedor__c, lDetalleComision);
                }
            }
            
            //comisiones
            List<Comision__c> lComisiones = ([SELECT Id, Mes__c, Year__c, Vendedor__c 
                                              FROM Comision__c 
                                              WHERE Mes__c = :Date.today().month().format() AND Year__c = :Date.today().year().format() AND Vendedor__c IN :SVendedores]);
            
            //Mapa Vendedor, Comision Actual
            Map<Id, Comision__c> mVendedorComisionActual = new Map<Id, Comision__c>(); 
            
            for(Comision__c com : lComisiones){
                if(!mVendedorComisionActual.containsKey(com.Vendedor__c)){
                    mVendedorComisionActual.put(com.Vendedor__c, com);
                }
            }
            
            Set<DetalleComision__c> sDetallesNuevos = new Set<DetalleComision__c>(); //Sumar importes de todos los productos x vendedor sin producto
            
            for(Id vendedor : mVendedorDetalle.KeySet()){
                double total = 0; //Inicializar precio total de la suma de los productos de un mismo vendedor
                
                DetalleComision__c nuevo = new DetalleComision__c();
                nuevo.Vendedor__c = vendedor;
                nuevo.Mes__c = Date.today().month().format();
                nuevo.Year__c = Date.today().year().format();
                nuevo.Tipo__c = 'Extra';
                nuevo.Comision__c = mVendedorComisionActual.get(vendedor).Id;
                
                for(DetalleComision__c det : mVendedorDetalle.get(vendedor)){
                        
                    total += det.ImporteReserva__c;
                    total += det.ImporteContrato__c;
                    total += det.ImporteEscrituracion__c;
                    total += det.ImportePosventa__c;
                        
                    nuevo.Concepto__c = 'Cancelación de la oportunidad ' + mOportunidades.get(mProductosOportunidad.get(det.ProductoOportunidad__c).OpportunityId).Name; //Mirar nombre de opp
                    nuevo.Importe__c = -total;
                    nuevo.Promocion__c = det.Promocion__c; 
                    
                }
                sDetallesNuevos.add(nuevo);
            }
            
            List<DetalleComision__c> lUpdateDetalles = new List<DetalleComision__c>();
        	lUpdateDetalles.addAll(sDetallesNuevos);
            insert lUpdateDetalles;
            
        }
    }

}