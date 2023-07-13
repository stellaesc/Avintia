public class Documento_Adenda_Controller {

        //Variables accesibles
    
    public static Opportunity oportunidad {get; set;}
    public static Promocion__c promocion {get; set;}
    public Hitos_de_Promocion__c hitoPromocion {get; set;}
    public Product2 inmueble {get; set;} 
    public Account cliente {get; set;}
    public Account promotora {get; set;}//O SOCIEDAD
    public Tipo_de_inmueble__c tipoInmueble {get; set;}
    public AccountRecordType__c AccountRecordType {get;set;}
    public static OpportunityLineItem prodOportunidadLocal {get; set;}
    public Contact Apoderado {get; set;}
    //public Contact representanteLegal {get; set;}
    public Decimal precioTrasteros {get; set;}
    public Decimal precioGarajes {get; set;}
    
    
    //Listas
    public List<Account> Titulares {get; set;}
    public List<Product2> listGarajes {get; set;}
    public List<Product2> listTrasteros {get; set;}
    public List<Contact> listRepresentatesLegales {get; set;}
    public List<String> fechaPrimeraCuotaList {get; set;}
    public List<Decimal> cuotasExtraList {get; set;}
    public List<Factura__c> facturasUnificadasList {get; set;}
    public List<Factura__c> facturasNoCuotasList {get; set;}
    
    //mapas
    public Map <id, Contact> mapRepresentantesLegales {get; set;}
    public Map <id, String> mapRepresentantesFechas {get; set;}
    public Map <id, Municipio__c> maplocalidadTitulares {get; set;}
    public Map <Id, Decimal> clientePorcPart {get; set;}
    
    
    public Integer numInmueblesVPO {get; set;}
    public Integer numInmueblesVPT {get; set;}
    
    public Decimal ImporteOportunidadMenosPenalizacionContrato {get; set;}
    public Decimal complementarioPenalContrato {get; set;}
   

    //fechas
    public String fechaEscrituracionPromocion {get; set;}
    public String fechaCreacion {get; set;}
    public String fechaContratoReservaLocal {get; set;}
    public String fechaPrimeraCuota {get; set;}
    public String fechaAprobacionLicencia {get; set;}
    public String fechaFirmaContratoCompraventa {get; set;}
    public String fechaFirmaContratoReserva {get; set;}
    public String fechaFirmaContratoReservaMayuscula {get; set;}
    public String fechaEscrituraPromotora {get; set;}
    	//public String fechaEscrituraApoderado {get; set;}
    
    
    //Variable globales internas
    Private Set<id> setParticipantes = new Set<id>();
    Private Set<id> setLocalidades = new Set<id>();
    
    
    //Variables importe formateadas
    public String StrInmuSuperConstTot {get;set;}
    public Map<Id, List<String>> MapGarajes {get;set;}
    public Map<Id, List<String>> MapTrasteros {get;set;}
    public String StrGarajeName {get;set;}
    public String StrGarajePlanta {get;set;}
    public String StrGarajeSupTotal {get;set;}
    public String StrTrasteroName {get;set;}
    public String StrTrasteroPlanta {get;set;}
    public String StrTrasteroSupTotal {get;set;}
    public Map <Id, String> MapFacturaNoCuota {get;set;}
    public String StrOpporAmount {get;set;}
    public String StrOpporAmountSinIVA {get;set;}
    public Map <Id, String> MapFacturaUnificada {get;set;}
    public String StrOpporImpEsc {get;set;}
    public String StrOpporImpCuota {get;set;}
    public String StrOpporImpPlanPagos {get;set;}
    public String StrOpporImpPlanPagosSinIVA {get;set;}
    public String StrOpporImpReserva {get;set;}
    public String StrOpporImpReservaSinIVA {get;set;}
    public String idEspanha {get;set;}
    public String StrPorPagar {get; set;}
    public String StrPagado {get; set;}
    public String StrEstadoEscrituracion {get; set;}

//-----------------------------------------------------------------------------------------------------------------------//
        
   //Constructor
   public Documento_Adenda_Controller(){
        
       Id idPlanPagos = ApexPages.currentPage().getParameters().get('id');
       //Id idOportunidad = '006n0000007YKNtAAO';
        
        			system.debug('Id planPagos '+idPlanPagos);
		
       Plan_de_pagos__c planPagos = [SELECT Id, Oportunidad__c FROM Plan_de_pagos__c WHERE Id =: idPlanPagos];
       
       Oportunidad = [SELECT id, promocion__c, accountId, Amount, Reserva__c, Tipo_de_Reserva__c, Porcentaje_IVA__c, Pago_Contrato__c,
                        N_Cuotas__c, Importe_de_Cuota__c, Fecha_de_primera_cuota__c, pago_Escritura__c, Penalizacion_Contrato__c, 
                      Fecha_firma_Contrato_Reserva__c, Fecha_firma_Contrato_Compraventa__c, Numero_Cuotas_Extra__c, Importe_Cuota_Extra__c,
                      Cuenta_Bancaria_de_mandato__c, Pago_Contrato_al_contado__c, Fecha_de_Escrituracion__c, Penalizacion_Reserva__c, Importe_de_Entrada__c,
                      Importe_plan_de_pagos__c, Importe_escritura__c, Pago_Reserva_p__c
                       FROM Opportunity WHERE id =: planPagos.Oportunidad__c];
       
       system.debug('Oportunidad CONTROLLER '+oportunidad);
       
       getPromocion();
       			system.debug('Promocion controller '+promocion);
       //getLocalidadPromocion();
       getInmuebles();
       			System.debug('inmueble '+inmueble);
       getRecordTypeIdCustomSetting();
       getCliente();
       //getRepresentanteLegal();
       getTitulares();
       getLocalidadTitulares();
       getRepresentantesLegales();
       getPromotora();
       //getTipoInmueble();
       getNumViviendas();
       getApoderado();
       getLocales();
       getHitoPromocion();
       getPrecioGarajes();
       getPrecioTrasteros();
       getCuotas();
       
       
       
       //Para transformar fechas al formato correcto, asignar a una variable pública el resultado de pasar al método general getFechaString la fecha necesaria
       if(promocion.Fecha_de_Escritura__c != null){
       		fechaEscrituracionPromocion = getFechaString(promocion.Fecha_de_Escritura__c);           
       }
       fechaCreacion = getFechaString(Date.today());
       if(promotora.Fecha_de_Escritura__c != null){
       		fechaEscrituraPromotora = getFechaString(promotora.Fecha_de_Escritura__c);    
       }
       if(oportunidad.Fecha_firma_Contrato_Compraventa__c != null){
       		fechaFirmaContratoCompraventa = getFechaString(oportunidad.Fecha_firma_Contrato_Compraventa__c); 
       }
       if(oportunidad.Fecha_firma_Contrato_Reserva__c != null){
            fechaFirmaContratoReserva = getFechaString(oportunidad.Fecha_firma_Contrato_Reserva__c);
            fechaFirmaContratoReservaMayuscula = fechaFirmaContratoReserva.toUpperCase();
       }
       if(oportunidad.Fecha_de_primera_cuota__c != null){
            fechaPrimeraCuota =   '10 de '+
            						getMesEscrito(oportunidad.Fecha_de_primera_cuota__c.month()) +' de '+
        							String.valueOf(oportunidad.Fecha_de_primera_cuota__c.year());
   
       }
       /*if(Apoderado.Fecha_de_Escritura__c != null){
            fechaEscrituraApoderado = getFechaString(Apoderado.Fecha_de_Escritura__c);    
       }*/
       
       //Para obtener la otra parte del porcentaje de penalización
       if(oportunidad.Penalizacion_Contrato__c != null){
           complementarioPenalContrato = 100 - oportunidad.Penalizacion_Contrato__c;
       }
       
       List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
       //Formateamos campos de importe
       if(oportunidad.Amount != null) {
       		StrOpporAmount = String.format(oportunidad.Amount.format(), formateo).contains(',')?String.format(oportunidad.Amount.format(), formateo):String.format(oportunidad.Amount.format(), formateo)+',00';           
       }
       if(oportunidad.Porcentaje_IVA__c != null){
           Decimal factor = 1 - oportunidad.Porcentaje_IVA__c/100;
           StrOpporAmountSinIVA = String.format((oportunidad.Amount*factor).format(), formateo).contains(',')?String.format((oportunidad.Amount*factor).format(), formateo):String.format((oportunidad.Amount*factor).format(), formateo)+',00';          
       }
       if(oportunidad.Importe_escritura__c != null) {
           	StrOpporImpEsc = String.format(oportunidad.Importe_escritura__c.format(), formateo).contains(',')?String.format(oportunidad.Importe_escritura__c.format(), formateo):String.format(oportunidad.Importe_escritura__c.format(), formateo)+',00';           
       }
       if(oportunidad.Importe_de_Cuota__c != null) {
           StrOpporImpCuota = String.format(oportunidad.Importe_de_Cuota__c.format(), formateo).contains(',')?String.format((oportunidad.Importe_plan_de_pagos__c).format(), formateo):String.format((oportunidad.Importe_plan_de_pagos__c).format(), formateo)+',00';
       }
       if(oportunidad.Importe_plan_de_pagos__c != null && oportunidad.Pago_Contrato__c!= null) {
           Decimal factor = 1 - oportunidad.Pago_Contrato__c/100;
           System.debug('Factor: ' + factor);
           StrOpporImpPlanPagos = String.format(oportunidad.Importe_plan_de_pagos__c.format(), formateo).contains(',')?String.format((oportunidad.Importe_plan_de_pagos__c).format(), formateo):String.format((oportunidad.Importe_plan_de_pagos__c).format(), formateo)+',00';
           StrOpporImpPlanPagosSinIVA = String.format((oportunidad.Importe_plan_de_pagos__c*factor).format(), formateo).contains(',')?String.format((oportunidad.Importe_plan_de_pagos__c*factor).format(), formateo):String.format((oportunidad.Importe_plan_de_pagos__c*factor).format(), formateo)+',00';
       }
       if(oportunidad.Tipo_de_Reserva__c != null && oportunidad.Tipo_de_Reserva__c.equals('Reserva con IVA') 
         && oportunidad.Reserva__c != null && oportunidad.Pago_Reserva_p__c!=null){
             StrOpporImpReserva = String.format(oportunidad.Reserva__c.format(), formateo).contains(',')?String.format(oportunidad.Reserva__c.format(), formateo):String.format(oportunidad.Reserva__c.format(), formateo)+',00';           
             Decimal factor = 1 - oportunidad.Pago_Reserva_p__c/100;
             System.debug('Factor: ' + factor);
             StrOpporImpReservaSinIVA = String.format((oportunidad.Reserva__c*factor).format(), formateo).contains(',')?String.format((oportunidad.Reserva__c*factor).format(), formateo):String.format((oportunidad.Reserva__c*factor).format(), formateo)+',00';
       }       
       
   }
    
    
    //Métodos
     public void getPromocion(){
        
        promocion = [SELECT id, name, Tipo_via__c, Nombre_via__c, N_Via__c, Socio_Empresa_Promotora__c,
                     		Codigo_postal__c, Localidad__c, Superficie_total_de_parcela__c, Descricion_pequena__c, 
                     		Semestre_de_escrituracion__c, Inicio_de_escrituraciones__c, N_Viviendas_totales_promocion__c,
                     		Lugar_del_registro__c, Tomo__c, Libro__c, Folio__c, Finca__c, Fecha_de_Escritura__c, Nombre_notario__c, Numero_de_protocolo__c,
                     		Contact__r.Name, Contact__r.N_Documento__c, Contact__r.Tipo_de_documento__c,
                     		Contact__r.Nacionalidad__c, Contact__r.Nombre_via__c, Contact__r.Numero_via__c, Contact__r.N_Piso__c ,
                     		Contact__r.Puerta__c, Contact__r.Localidad__r.Name, Contact__r.Estado_Civil__c, Contact__r.Fecha_de_Escritura__c,
                     		Contact__r.Nombre_notario__c, Contact__r.Numero_de_protocolo__c, 
                     		Informacion_de_arquitectos_de_obra__c, Cuenta_Activa_1__c, Cuenta_Activa_2__c, Numero_de_cuenta_bancaria_1__c, Numero_de_cuenta_bancaria_2__c, 
                     		Entidad_Bancaria1__c, Entidad_Bancaria2__c, Contact__c, Referencia_catastral__c, N_Garages_totales_promocion__c,
                     		N_Trasteros_totales_promocion__c, N_Locales_totales_promocion__c, Lugar_de_la_notaria__c, Condicion__c, descripcion_suelo__c, Socio_Empresa_Comercializadora__r.Name,
                     		Periodo_de_Reserva__c, Promocion__c.Localidad__r.name, Constructora__r.Name, Constructora__r.Tipo_de_via_FISCAL__c, Constructora__r.Nombre_de_via_FISCAL__c,
                     		Constructora__r.N_via_FISCAL__c, Constructora__r.Codigo_postal_FISCAL__c, Constructora__r.Localidad_FISCAL__r.Name, Constructora__r.Pais_FISCAL__r.Name,
                     		Constructora__r.Tipo_de_documento__c, Constructora__r.N_Documento__c
                            FROM Promocion__c WHERE Id =: Oportunidad.promocion__c];
        
    }
    

    public void getHitoPromocion(){

        List<Hitos_de_Promocion__c> hitosPromocionList = [SELECT Aprobacion_de_la_licencia_de_obras__c FROM Hitos_de_Promocion__c ORDER BY CreatedDate];
        if(hitosPromocionList.size() > 0){
			hitoPromocion = hitosPromocionList[0];            
        }

    }
     
    public static void getLocales(){
        //Obtener producto de oportunidad - inmueble asociado a la oportunidad
        
        List<OpportunityLineItem> prodOportunidadLocalList = [SELECT id, Product2Id, Product2.Superficie_Construida_total_con_ZZCC_m2__c, Product2.Superficie_Util_m2__c, Product2.Tipo_de_inmueble__r.Tipo__c,
                                                    Product2.Letra_N_Puerta__c, Product2.Precio__c
                                                    FROM OpportunityLineItem 
                                                    WHERE OpportunityId =: oportunidad.id AND Product2.Tipo_de_inmueble__r.Tipo__c =: 'Local']; 
        
        if(prodOportunidadLocalList.size() > 0){
            prodOportunidadLocal = prodOportunidadLocalList[0];
        }        

    }
     
    public void getInmuebles(){
        
        //Inicialización de listas
         listGarajes = new List<Product2>();
         listTrasteros = new List<Product2>();
        
        //Obtener producto de oportunidad - inmueble asociado a la oportunidad
        List<OpportunityLineItem> listProductoOportunidad = [SELECT id, Product2Id
                                                        FROM OpportunityLineItem WHERE OpportunityId =: oportunidad.id];
        
        system.debug('Productos de oportunidad '+listProductoOportunidad);
        
        //Almacena las id de los inmuebles (Product2) de los productos de oportunidad
        Set<id> setProductoOportunidad = new Set<id>();
        
        for(integer j = 0; j < listProductoOportunidad.size() ; j++){
            
            setProductoOportunidad.add(listProductoOportunidad[j].Product2Id);
        }
        
        system.debug('SET Productos de oportunidad '+setProductoOportunidad);
        
        //Obtener inmueble e inmuebles asociados
        List<Product2> listaInmuebles = [SELECT id, name, planta__c, Letra_N_Puerta__c, Inmueble_asociado__c, 
                                         Tipo_de_inmueble__c, Precio__c, Tipo_de_via__c, nombre_via__c, piso__c, portal__c, 
                                         N_habitaciones__c, N_banos__c, Superficie_Construida_total_con_ZZCC_m2__c, 
                                         N_Vivienda_Garaje_Trastero_Local__c, Superficie_Util_Trastero_con_pasillos_m2__c,
                                         sup_Cocina__c, sup_Salon__c, Superficie_Terrazas_Descubiertas__c, Superficie_Terrazas_Cubiertas__c,
                                         Bloque__c, Superficie_Util_Garaje_con_calles_m2__c, Superficie_Util_m2__c, Tipo_de_inmueble__r.Tipo__c,
                                         N_Via__c, Tipo_de_vivienda__c 
                                         FROM Product2 WHERE (id IN: setProductoOportunidad AND    (Tipo_de_inmueble__r.tipo__c = 'Vivienda' 
                                                                                                OR Tipo_de_inmueble__r.tipo__c = 'Garaje'
                                                                                                OR Tipo_de_inmueble__r.tipo__c = 'Trastero'
                                                                                                OR Tipo_de_inmueble__r.tipo__c = 'Local'))];
        
        
        system.debug('listaInmuebles:::'+listaInmuebles);
        system.debug('listaInmuebles.size():::'+listaInmuebles.size());
       
        List<String> listaTipoInmueble = new List<String>();
        for(Product2 inmueble : listaInmuebles){
            listaTipoInmueble.add(inmueble.Tipo_de_inmueble__r.tipo__c);
        }
        //Se asignan los inmuebles dependiendo de su tipo de vivienda
        for(integer i = 0; i < listaInmuebles.size() ; i++){
            
            if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Vivienda'){
                inmueble = listaInmuebles[i];
            }else if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Local'){
                inmueble = listaInmuebles[i];
            }
            else{  
                if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Garaje'){
                     if(!listaTipoInmueble.contains('Vivienda')){
                        inmueble = listaInmuebles[i];
                     }
                     listGarajes.add(listaInmuebles[i]);
                     system.debug('GARAJE ');
                     system.debug('listGarajes:::'+listGarajes);
                 }
                else if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Trastero'){
                     if(!listaTipoInmueble.contains('Vivienda')){
                        inmueble = listaInmuebles[i];
                     }
                    listTrasteros.add(listaInmuebles[i]); 
                    system.debug('TRASTERO ');
                    system.debug('listTrasteros:::'+listTrasteros);
                }
            }
        }
        
        List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
        //Formateamos campos de importe
        if(inmueble.Superficie_Construida_total_con_ZZCC_m2__c !=null){
        	StrInmuSuperConstTot = String.format(inmueble.Superficie_Construida_total_con_ZZCC_m2__c.format(), formateo);
        }
        
        List<String> GarajeAux= new List <String>();
        MapGarajes = new Map<Id, List<String>>();
        
        for(integer i = 0; i < listGarajes.size() ; i++){
            StrGarajeName =  '#@#VACIO#@#';
            StrGarajePlanta = '#@#VACIO#@#';
            StrGarajeSupTotal = '#@#VACIO#@#';
            
            GarajeAux = new List <String>();
            if(listGarajes[i].Name!=null){
            	StrGarajeName = listGarajes[i].Name;
            }
            if(listGarajes[i].Planta__c!=null){
            	StrGarajePlanta = listGarajes[i].Planta__c;
            }
            System.debug(StrGarajePlanta);
            if(listGarajes[i].Superficie_Construida_total_con_ZZCC_m2__c!=null){
            	StrGarajeSupTotal = String.format(listGarajes[i].Superficie_Construida_total_con_ZZCC_m2__c.format(), formateo);
            }
            
           	GarajeAux.add(StrGarajeName);
            GarajeAux.add(StrGarajePlanta);
            GarajeAux.add(StrGarajeSupTotal);
            MapGarajes.put(listGarajes[i].Id, GarajeAux);
        }
        
        
         List<String> TrasteroAux= new List <String>();
        MapTrasteros = new Map<Id, List<String>>();
        
        for(integer i = 0; i < listTrasteros.size() ; i++){
            TrasteroAux = new List <String>();
            StrTrasteroName = '#@#VACIO#@#';
            StrTrasteroPlanta = '#@#VACIO#@#';
            StrTrasteroSupTotal = '#@#VACIO#@#';
                
                
            if(listGarajes[i].Name!=null){
            	StrTrasteroName = listTrasteros[i].Name;
            }
            if(listGarajes[i].Planta__c!=null){
            	StrTrasteroPlanta = listTrasteros[i].Planta__c;
            }
            if(listTrasteros[i].Superficie_Construida_total_con_ZZCC_m2__c !=null){
            	StrTrasteroSupTotal = String.format(listTrasteros[i].Superficie_Construida_total_con_ZZCC_m2__c.format(), formateo);
            }
            
           	TrasteroAux.add(StrTrasteroName);
            TrasteroAux.add(StrTrasteroPlanta);
            TrasteroAux.add(StrTrasteroSupTotal);
            MapTrasteros.put(listTrasteros[i].Id, TrasteroAux);
        }
        
        
        
        

    }
    
    public void getNumViviendas(){
    	List<Product2> listaInmuebles = [SELECT Id, Tipo_de_vivienda__c  FROM Product2];
        
        numInmueblesVPO = 0;
        numInmueblesVPT = 0;
        for(Product2 inmueble : listaInmuebles){
            if(inmueble.Tipo_de_vivienda__c == 'VPO'){
                numInmueblesVPO += 1;
            }
            if(inmueble.Tipo_de_vivienda__c == 'VPT'){
                numInmueblesVPT += 1;
            }
        }
        system.debug('numInmueblesVPO:::'+numInmueblesVPO);
        system.debug('numInmueblesVPT:::'+numInmueblesVPT);
    }
    
    public void getCliente(){
        
//DP o DF???
//SI CLIENTE NO ES CUENTA PERSONAL??
        cliente = [SELECT id, name, 
                   Estado_Civil__pc, DP_Localidad__c, DP_Tipo_de_vIa__c, DP_Nombre_via__c, DP_N_via__c, DP_Codigo_postal__c,
                   Tipo_de_documento__c, N_Documento__c,Nacionalidad__r.Name, DP_Localidad__r.Name, tomo__c, Seccion__c, Folio__c,
                   N_Hoja__c, Lugar_de_notaria__pc, RecordTypeId, RecordType.DeveloperName, N_cuenta_corriente__c, Fecha_de_Escritura__c,
                   Nombre_del_notario__c, Numero_de_protocolo__c
                   FROM Account 
                   WHERE Id =: oportunidad.AccountId];
        
    }
        
    public void getPromotora(){
        
        promotora = [SELECT id, name, DF_Comunidad_autonoma__c, DF_Provincia__c,  DF_Localidad__r.Name, 
                     DF_Tipo_de_via__c, DF_Nombre_via__c, DF_N_piso__c, DF_Codigo_postal__c,
                     DF_N_via__c, tomo__c, Seccion__c, Folio__c, N_Hoja__c, Nombre_del_notario__c,
                     Lugar_de_notaria__pc, Fecha_de_Escritura__c, Numero_de_protocolo__c,
                     Lugar_del_registro__c, Tipo_de_documento__c, N_Documento__c, 
                     Nombre_notario__pc, N_cuenta_corriente__c, DF_Escalera__c, DF_Puerta__c  
                            FROM Account WHERE Id =: promocion.Socio_Empresa_Promotora__c];
        
    }
    
    
    public void getTitulares(){
        
        
        List<Participante__c> listParticipantes = [SELECT id, Cliente__c, Porcentaje_de_participacion__c 
                                      FROM Participante__c WHERE Opportunity__c =: oportunidad.id];
        
        for(Integer i = 0; i < listParticipantes.size(); i++){
            
            setParticipantes.add(listParticipantes[i].cliente__c);
        }
        
        idEspanha = [SELECT id FROM Pais__c WHERE Name='España' LIMIT 1].Id;
        
        Titulares = [SELECT id, name, Estado_Civil__pc, DF_Localidad__c, DP_Tipo_de_vIa__c, Sexo__pc, DP_Pais__c,
                            DP_Nombre_via__c, DP_N_via__c, DP_Codigo_postal__c,Tipo_de_documento__c, DP_Localidad__c, Localidad_Extranjera_P__c,
                            N_Documento__c, Lugar_del_registro__c, Tomo__c, seccion__c, folio__c, N_Hoja__c, Direccion_Extranjera_P__c,
                     		Nombre_del_notario__c, Numero_de_protocolo__c, Fecha_de_Escritura__c, DP_Localidad__r.name, Regimen__c,
                     		Nacionalidad__r.name, nacionalidad__c, Lugar_de_notaria__pc 
                            FROM Account WHERE id IN: setParticipantes];
        
        for(integer j = 0; j < Titulares.size(); j++){
            
            setLocalidades.add(Titulares[j].DP_Localidad__c);
        }
        System.debug('Titulares: ' + titulares);
        System.debug('listParticipantes: ' + listParticipantes);
        
        clientePorcPart = new Map<Id, Decimal>();
        for(Account acc: titulares){
            for(Participante__c part : listParticipantes){
                if(acc.Id == part.Cliente__c){
                    clientePorcPart.put(acc.id, part.Porcentaje_de_participacion__c);
                }
            }
        }
        System.debug('clientePorcPart '+ clientePorcPart);
        
    }
    
    //Obtener representantesLegales de Sociedades Participantes (1 por sociedad)
    public void getRepresentantesLegales(){
        
        system.debug('OBTENER REPRESENTANTES LEGALES');
        
        listRepresentatesLegales = [SELECT id, name, Tipo_de_documento__c, N_Documento__c, Lugar_de_notaria__c,
                                    Nombre_notario__c, Fecha_de_Escritura__c, Numero_de_protocolo__c, Condicion__c,
                                    Account.name, Account.Lugar_de_notaria__pc, Account.Nombre_del_notario__c, Account.Numero_de_protocolo__c,
                                    Account.N_documento__c, Account.Fecha_de_Escritura__c
                                    
                                    FROM Contact WHERE AccountId =: setParticipantes And Representante_legal__c = true];
        
        mapRepresentantesLegales = new Map <id, Contact>();
        
        mapRepresentantesFechas = new Map <id, String>();
        
        
        for(integer i = 0; i < listRepresentatesLegales.size(); i++){
            
            mapRepresentantesLegales.put(listRepresentatesLegales[i].AccountId, listRepresentatesLegales[i]);
            if(mapRepresentantesLegales.get(listRepresentatesLegales[i].AccountId).Fecha_de_Escritura__c != null){
                            mapRepresentantesFechas.put(listRepresentatesLegales[i].AccountId, 
                                        getFechaString(mapRepresentantesLegales.get(listRepresentatesLegales[i].AccountId).Fecha_de_Escritura__c));
            }

        }
        
        system.debug('mapRepresentantesFechas '+mapRepresentantesFechas);
        system.debug('mapRepresentantesLegales '+mapRepresentantesLegales);
        
    }
    
    //Comprobar ----------------------------------------------------
    public void getLocalidadTitulares(){
        
        maplocalidadTitulares = new Map <id, Municipio__C> ([SELECT id, name
                            FROM Municipio__c WHERE Id =: setLocalidades]);
        
    }
    //Comprobar ----------------------------------------------------
    
    public void getTipoInmueble(){
        
        TipoInmueble = [SELECT id, name, tipo__c FROM Tipo_de_inmueble__c WHERE id =: inmueble.Tipo_de_inmueble__c];
        
        System.debug('GET RESERVA CON IVA '+oportunidad.reserva__c+ ' iva '+oportunidad.Porcentaje_IVA__c);
         System.debug('Tipo de reserva '+oportunidad.Tipo_de_Reserva__c+ ' amount '+oportunidad.amount);
        
    }
    
     public void getRecordTypeIdCustomSetting(){
        
         AccountRecordType  = AccountRecordType__c.getOrgDefaults();
		 system.debug('AccountRecordType'+AccountRecordType);
    }
    
    public void getApoderado(){
        
        List<Contact> apoderadoList = [SELECT id, name, tipo_de_documento__c, N_documento__c, Sexo__c,
                     					Lugar_de_notaria__c, Nombre_notario__c, Numero_de_protocolo__c,
                     					Tipo_via__c, Nombre_via__c, N_piso__c, Localidad__r.Name, Dc_Provincia__c, escalera__c, Puerta__c, Numero_via__c,
                     					Account.name
                     					FROM Contact Where id =: promocion.Contact__c LIMIT 1]; 
        
        if(apoderadoList.size() > 0){
            Apoderado = apoderadoList[0];
        }
        
        
        
    }
    
    public void getPrecioGarajes(){
        
        precioGarajes = 0;
        system.debug('listGarajes:::'+listGarajes);
        if(listGarajes != null && listGarajes.size() > 0){
            
        
            for(integer i = 0; i < listGarajes.size(); i++){
                
                if(listGarajes[i].precio__c != null){
                    
                     precioGarajes += listGarajes[i].precio__c;
                }   
            }
        }
        system.debug('precioGarajes:::'+precioGarajes);
    } 
    
    public void getPrecioTrasteros(){
        
        precioTrasteros = 0;
        system.debug('listTrasteros:::'+listTrasteros);
        if(listTrasteros != null && listTrasteros.size() > 0){
            
        
            for(integer i = 0; i < listTrasteros.size(); i++){
                
                if(listTrasteros[i].precio__c != null){
                    
                     precioTrasteros += listTrasteros[i].precio__c;
                }   
            }
        }
        system.debug('precioTrasteros:::'+precioTrasteros);
    } 
    
    //Metodos internos de la clase    
    private String getFechaString(Date fecha){
        
        String fechaNew =  string.valueOf(fecha.day()) +' de '+
            						getMesEscrito(fecha.month()) +' de '+
        							String.valueOf(fecha.year());
        return fechaNew;
    }
       
    private String getMesEscrito(Integer mes){
        
		String mesEscrito;
        
         if(mes == 1){
                mesEscrito = 'enero';
         }
        else if(mes == 2){
            mesEscrito = 'febrero';
        }
        else if(mes == 3){
            mesEscrito = 'marzo';
        }
        else if(mes == 4){
            mesEscrito = 'abril';
        }
        else if(mes == 5){
            mesEscrito = 'mayo';
        }
        else if(mes == 6){
            mesEscrito = 'junio';
        }
        else if(mes == 7){
            mesEscrito = 'julio';
        }
        else if(mes == 8){
            mesEscrito = 'agosto';
        }
        else if(mes == 9){
            mesEscrito = 'septiembre';
        }
        else if(mes == 10){
            mesEscrito = 'octubre';
        }
        else if(mes == 11){
            mesEscrito = 'noviembre';
        }
        else if(mes == 12){
            mesEscrito = 'diciembre';
        }
        
		return mesEscrito;
    }
    
    // LO HE COGIDO DE OTRO CONTROLADOR ¿SE PODRIA METER EN UNA CLASE UTILS?
    public void getCuotas(){
        
        Opportunity oportunidad = [SELECT Id, Facturacion_por_separado__c FROM Opportunity WHERE Id =: oportunidad.Id];
        
        //Estado_de_la_factura__c si Pdt de envío a Oracle, entonces se puede modificar
        List<Factura__c> facturasPendientesList = [SELECT Id, Name, Tipo_de_factura__c, Tipologia__c, Referencia__c, Obra__c, Descripcion__c, Sociedad__c,
                                         Fecha_de_emision__c, Fecha_Contable__c, Condicion_Cobro__c, Metodo_de_cobro__c, 	Codigo_Impuesto__c, 
                                         Importe__c, Pago_o_Cuota__c, Estado_de_la_factura__c, Estado_plan_de_pagos__c, Cliente__r.Name, Origen__c
                                         FROM Factura__c
                                         WHERE Oportunidad__c =:oportunidad.Id AND (Pago_o_Cuota__c =: 'Cuota' OR Pago_o_Cuota__c =: 'Cuota Extra') AND Estado_plan_de_pagos__c = 'Activo' AND Estado_de_la_factura__c != 'Cancelada'];
        
        
        List<Factura__c> facturasList = [SELECT Id, Name, Tipo_de_factura__c, Tipologia__c, Referencia__c, Obra__c, Descripcion__c, Sociedad__c,
                                                 Fecha_de_emision__c, Fecha_Contable__c, Condicion_Cobro__c, Metodo_de_cobro__c, 	Codigo_Impuesto__c, 
                                                 Importe__c, Pago_o_Cuota__c, Estado_de_la_factura__c, Estado_plan_de_pagos__c, Cliente__r.Name, Origen__c
                                                 FROM Factura__c
                                        		 WHERE Oportunidad__c =: oportunidad.Id AND (Pago_o_Cuota__c =: 'Cuota' OR Pago_o_Cuota__c =: 'Cuota Extra') AND Estado_plan_de_pagos__c = 'Inactivo' AND Estado_de_la_factura__c != 'Cancelada' AND Estado_de_la_factura__c != 'Pendiente de emisión'
                                                 ORDER BY Fecha_de_emision__c ASC];
        
        //Recuperamos las facturas de Reserva, Entrada y Escritura
        facturasNoCuotasList = [SELECT Id, Name, Tipo_de_factura__c, Tipologia__c, Referencia__c, Obra__c, Descripcion__c, Sociedad__c,
                                                 Fecha_de_emision__c, Fecha_Contable__c, Condicion_Cobro__c, Metodo_de_cobro__c, 	Codigo_Impuesto__c, 
                                                 Importe__c, Pago_o_Cuota__c, Estado_de_la_factura__c, Estado_plan_de_pagos__c, Cliente__r.Name, Origen__c
                                                 FROM Factura__c
                                        		 WHERE Oportunidad__c =: oportunidad.Id AND Pago_o_Cuota__c =: 'Proforma' 
                                         				AND Estado_de_la_factura__c != 'Cancelada' AND (Origen__c = 'Reserva' OR Origen__c = 'Entrada' OR Origen__c = 'Escritura') 
                                                ];

        
        List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
            
        system.debug('facturasNoCuotasList:::'+facturasNoCuotasList);
        
        facturasList.addAll(facturasPendientesList);
        
        system.debug('facturasList:::'+facturasList);
        //Creamos un map que nos permita sumar para fechas iguales, los importes de las facturas
        Map<Date,Decimal> cuotasMap = new Map<Date,Decimal>(); 
        for(Factura__c factura : facturasList){
        	if(!cuotasMap.keySet().contains(factura.Fecha_de_emision__c) && factura.Importe__c != null){
            	cuotasMap.put(factura.Fecha_de_emision__c, factura.Importe__c);
             }else if(factura.Importe__c != null){
                Decimal importeViejo = cuotasMap.get(factura.Fecha_de_emision__c);
             	cuotasMap.put(factura.Fecha_de_emision__c, importeViejo + factura.Importe__c);
             }
        }
        
        system.debug('cuotasMap:::'+cuotasMap);
        
        //Como no se puede acceder a maps en lightning, utilizamos un objeto de tipo factura para guardar las facturas unificadas y poder iterarlas en la componente,
        //como las cuotas extra no tienen Fecha, se uniran todas en null, por eso necesitamos saber antes cuantas cuotas extra quedan por pagar, para dividir
        //el valor guardado para la clave null entre el numero de cuotas
        
        
        List<String> clientesList = new List<String>();
        Integer cuotasExtraContador = 0;
        for(Factura__c factura : facturasList){
        	if(factura.Pago_o_Cuota__c == 'Cuota Extra'){
            	if(!clientesList.contains(factura.Cliente__r.Name)){
                	clientesList.add(factura.Cliente__r.Name);
                }if(!(factura.Estado_de_la_factura__c == 'Cobrada') && factura.Fecha_de_emision__c == null){
                	cuotasExtraContador += 1;
                }                    
         	}
         }
    
        
        
		Set<Date> fechaFacturaSet = cuotasMap.keySet();
        facturasUnificadasList = new List<Factura__c>();
        for(Date fechaFactura : fechaFacturaSet){
            //Si alguna factura tenia fecha nula, habra una clave que sea null
            if(fechaFactura != null){
                Factura__c facturaUnificada = new Factura__c(Fecha_de_emision__c = fechaFactura, Importe__c = cuotasMap.get(fechaFactura));
                facturasUnificadasList.add(facturaUnificada);
            }else if(cuotasExtraContador > 0){
                for(Integer i=0; i < cuotasExtraContador/clientesList.size(); i++) {
					Factura__c facturaUnificada = new Factura__c(Fecha_de_emision__c = fechaFactura, Importe__c = cuotasMap.get(fechaFactura)/(cuotasExtraContador/clientesList.size()));
					facturasUnificadasList.add(facturaUnificada);
				}
            }
        }
        
        for(Factura__c factura : facturasList){
            for(Factura__c facturaUnificada : facturasUnificadasList){
                if(factura.Fecha_de_emision__c == facturaUnificada.Fecha_de_emision__c){
                    facturaUnificada.Estado_de_la_factura__c = factura.Estado_de_la_factura__c;
                    facturaUnificada.Name = factura.Name;
                    facturaUnificada.Tipo_de_factura__c = factura.Tipo_de_factura__c;
                    facturaUnificada.Tipologia__c = factura.Tipologia__c;
                    facturaUnificada.Referencia__c = factura.Referencia__c;
                    //facturaParticipante.Obra__c = factura.Obra__c;
                    facturaUnificada.Descripcion__c = factura.Descripcion__c;
                    facturaUnificada.Sociedad__c = factura.Sociedad__c;
                    facturaUnificada.Fecha_Contable__c = factura.Fecha_Contable__c;
                    facturaUnificada.Condicion_Cobro__c = factura.Condicion_Cobro__c;
                    facturaUnificada.Metodo_de_cobro__c = factura.Metodo_de_cobro__c;
                    facturaUnificada.Pago_o_Cuota__c = factura.Pago_o_Cuota__c;
                    facturaUnificada.Origen__c = factura.Origen__c;
                    facturaUnificada.Oportunidad__c = oportunidad.Id;

                }
            }
        }

        system.debug('facturasUnificadasList:::'+facturasUnificadasList);
        
        
        //Formateamos campos de importe
        
        MapFacturaNoCuota = new Map <Id, String>();
        
        for(factura__c facturaNoCuota : facturasNoCuotasList){
            String StrFacturaImpNC = '';
            if(facturaNoCuota.Importe__c != null){
        		StrFacturaImpNC = String.format(facturaNoCuota.Importe__c.format(),formateo);
            }
            if(facturaNoCuota.Origen__c=='Escritura') StrEstadoEscrituracion = facturaNoCuota.Estado_de_la_factura__c!='Cobrada'?'Pendiente':'Cobrada';
            MapFacturaNoCuota.put(facturaNoCuota.Id, StrFacturaImpNC);
        
        }
        
        MapFacturaUnificada = new Map <Id, String>();
        
        for(factura__c facturasUnificadas : facturasUnificadasList){
            String StrFacturaImpUni = '';
            if(facturasUnificadas.Importe__c != null){
                StrFacturaImpUni = String.format(facturasUnificadas.Importe__c.format(),formateo);
            }
            MapFacturaUnificada.put(facturasUnificadas.Id, StrFacturaImpUni);
        
        }
        Decimal porPagar = 0;
        Decimal pagado = 0;
        for(Factura__c f: facturasUnificadasList){
            if(f.Estado_de_la_factura__c != 'Cobrada'){
                porPagar +=  f.Importe__c ;                
            }
            else{
                pagado +=  f.Importe__c ;
            }
        }
        StrPorPagar = String.format(porPagar.format(), formateo).contains(',')?String.format(porPagar.format(), formateo):String.format(porPagar.format(), formateo)+',00';
   		StrPagado = String.format(pagado.format(), formateo).contains(',')?String.format(pagado.format(), formateo):String.format(pagado.format(), formateo)+',00';
   		
    }
    
}