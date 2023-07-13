/**
@description
<pre>
Creación diaria de objetivos</br>
DATE       	AUTHOR     	DESCRIPTION<br/>                 
20/01/2021 	LCS - BCF   Created.                         
</pre>
@author Leadclic Solutions
@date 20/01/2021
*/
global class BatchCalculoComisiones implements Database.Batchable<sObject>, Schedulable{
    
    Map<Id, Set<RelacionVendedorProductoOportunidad__c>> mProductos = new Map<Id, Set<RelacionVendedorProductoOportunidad__c>>(); //Mapa Promocion, lista de productos 
    Map<DefinicionComision__c, Set<RelacionVendedorProductoOportunidad__c>> mProductosVendedor = new Map<DefinicionComision__c, Set<RelacionVendedorProductoOportunidad__c>>(); //Mapa Definicion Comision, lista de Productos
    Map<RelacionVendedorProductoOportunidad__c, DetalleComision__c> mComisiones = new Map<RelacionVendedorProductoOportunidad__c, DetalleComision__c>(); //Mapa Producto, Definicion Comision
    Map<Id, Comision__c> mComisionVendedor = new Map<Id, Comision__c>(); //Mapa Vendedor, Comision
    
    global void execute(SchedulableContext sc){
        BatchCalculoComisiones b = new BatchCalculoComisiones();
        Database.executebatch(b, 2000);
    }
    
    global List<sObject> start(Database.BatchableContext bc) {
        List<sObject> lScope = new List<sObject>();
        String mesActual = Date.today().month().format();
        String yearActual = Date.today().year().format();
        
        //Añadimos Productos Relacionados
        lScope.addAll([SELECT id, Titular__c, PorcentajeComision__c, vendedor__c, ProductoOportunidad__r.Product2.Estado__c, ProductoOportunidad__r.Product2.Tipologia_Vivienda_Garaje_Trastero_Local__c, 
                       ProductoOportunidad__r.Product2.Precio__c, ProductoOportunidad__r.Product2.Promocion__c, ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Reserva__c, ProductoOportunidad__r.UnitPrice,
                       ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Compraventa__c, ProductoOportunidad__r.Opportunity.FechaEscrituracionReal__c, ProductoOportunidad__r.Opportunity.FechaPosventa__c, ProductoOportunidad__r.Opportunity.Promocion__r.DiasPosventa__c, ProductoOportunidad__r.Opportunity.StageName
                       FROM RelacionVendedorProductoOportunidad__c                       
                       WHERE vendedor__c != null AND ((ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Reserva__c = THIS_MONTH AND ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Reserva__c = THIS_YEAR) OR (ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Compraventa__c = THIS_MONTH 
                             AND ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Compraventa__c = THIS_YEAR) OR (ProductoOportunidad__r.Opportunity.FechaEscrituracionReal__c = THIS_MONTH AND ProductoOportunidad__r.Opportunity.FechaEscrituracionReal__c = THIS_YEAR) 
                             OR (ProductoOportunidad__r.Opportunity.FechaPosventa__c = THIS_MONTH AND ProductoOportunidad__r.Opportunity.FechaPosventa__c = THIS_YEAR))]);
        
        //Añadimos Definicion de Comisiones
        lScope.addAll([SELECT Id, PorcentajeReserva__c, PorcentajeContrato__c, PorcentajeEscrituracion__c, PorcentajePosventa__c, Vendedor__c, Promocion__c, Mes__c, Year__c
                       FROM DefinicionComision__c 
                       WHERE Mes__c = :mesActual AND Year__c = :yearActual AND Activo__c = true AND Vendedor__c != null AND Promocion__c != null AND Mes__c != null AND Year__c != null]);
        
        //Añadimos Detalle Comision
        lScope.addAll([SELECT id, Name, Vendedor__c, Mes__c, Year__c, Importe__c, ProductoOportunidad__c, Promocion__c, ImporteContrato__c, ImporteEscrituracion__c, ImportePosventa__c, ImporteReserva__c
                       FROM DetalleComision__c 
                       WHERE Mes__c = :mesActual AND Year__c = :yearActual AND Tipo__c = 'Fija' AND Vendedor__c != null AND Promocion__c != null AND Mes__c != null AND Year__c != null]);
        
        //Añadimos Comision
        lScope.addAll([SELECT id, Name, Vendedor__c, Mes__c, Year__c
                       FROM Comision__c 
                       WHERE Mes__c = :mesActual AND Year__c = :yearActual AND Vendedor__c != null AND Mes__c != null AND Year__c != null]);
        
        return lScope;
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        
        Set<DefinicionComision__c> sDefinicionCom = new Set<DefinicionComision__c>();
        Set<DetalleComision__c> sDetalleCom = new Set<DetalleComision__c>();
        Set<Comision__c> sComisiones = new Set<Comision__c>();
        Set<RelacionVendedorProductoOportunidad__c> sProducto = new Set<RelacionVendedorProductoOportunidad__c>();
        
        for(sObject sco : scope){
            switch on sco{
                when RelacionVendedorProductoOportunidad__c prod{
                    sProducto.add(prod);
                }
                when DefinicionComision__c def{
                    sDefinicionCom.add(def);
                }
                when DetalleComision__c det{
                	sDetalleCom.add(det);
                }
                when Comision__c com{
                    sComisiones.add(com);
                }
            }
        }
        
        //Crear mapa <Promocion, lista de productos>
        for(RelacionVendedorProductoOportunidad__c producto : sProducto){
            
            if(mProductos.containsKey(producto.ProductoOportunidad__r.Product2.Promocion__c)){
                Set<RelacionVendedorProductoOportunidad__c> sProductos = mProductos.get(producto.ProductoOportunidad__r.Product2.Promocion__c);
                sProductos.add(producto);
                mProductos.put(producto.ProductoOportunidad__r.Product2.Promocion__c, sProductos);
                
            }else{
                Set<RelacionVendedorProductoOportunidad__c> sProductos = new Set<RelacionVendedorProductoOportunidad__c>();
                sProductos.add(producto);
                mProductos.put(producto.ProductoOportunidad__r.Product2.Promocion__c, sProductos);
            }
        }
        
        //Crear mapa <Definicion Comision, Lista de productos>
        for(DefinicionComision__c definicion : sDefinicionCom){
            
            if(mProductos.containsKey(definicion.Promocion__c)){
                for(RelacionVendedorProductoOportunidad__c producto : mProductos.get(definicion.Promocion__c)){
                    
                    if(producto.vendedor__c == definicion.vendedor__c){
                        
                        if(mProductosVendedor.containsKey(definicion)){
                            Set<RelacionVendedorProductoOportunidad__c> sProductosVendedor = mProductosVendedor.get(definicion);
                        	sProductosVendedor.add(producto);
                        	mProductosVendedor.put(definicion, sProductosVendedor);
                            
                        }else{
                            Set<RelacionVendedorProductoOportunidad__c> sProductosVendedor = new Set<RelacionVendedorProductoOportunidad__c>();
                        	sProductosVendedor.add(producto);
                        	mProductosVendedor.put(definicion, sProductosVendedor);
                        }
                    }
                }
                
            }else{ //No hay productos de la promocion de la comisión
                Set<RelacionVendedorProductoOportunidad__c> sProductosVendedor = new Set<RelacionVendedorProductoOportunidad__c>();
                mProductosVendedor.put(definicion, sProductosVendedor);
            }
        }
        
        //Crear mapa Vendedor, Comision
        for(Comision__c comision : sComisiones){
            mComisionVendedor.put(comision.Vendedor__c, comision);
        }
        
        //Crear mapa <Producto, Detalle de Comision>
        for(DetalleComision__c detalle : sDetalleCom){
            for(RelacionVendedorProductoOportunidad__c producto : sProducto){
                if(detalle.ProductoOportunidad__c == producto.ProductoOportunidad__c){
                    mComisiones.put(producto, detalle);
                }
            }
        }
        
        //Calculo Detalles de comisiones
        Set<DetalleComision__c> sNuevosDetallesComision = new Set<DetalleComision__c>(); //Nuevos Detalles
        
        for(DefinicionComision__c def : sDefinicionCom){
            
            if(mProductosVendedor.get(def) != null){
                for(RelacionVendedorProductoOportunidad__c producto : mProductosVendedor.get(def)){
                    
                    DetalleComision__c detalle = mComisiones.get(producto); 
                    
                    if(detalle == null){ //Si no existe un Detalle para ese producto se inicializa
                        DetalleComision__c nuevoDetalle = new DetalleComision__c();
                        nuevoDetalle.Vendedor__c = def.Vendedor__c;
                        nuevoDetalle.Promocion__c = def.Promocion__c;
                        nuevoDetalle.Mes__c = Date.today().month().format();
                        nuevoDetalle.Year__c = Date.today().year().format();
                        nuevoDetalle.Tipo__c = 'Fija';
                        nuevoDetalle.Comision__c = mComisionVendedor.get(producto.Vendedor__c).Id;
                        nuevoDetalle.ProductoOportunidad__c = producto.ProductoOportunidad__c;
                        
                        sNuevosDetallesComision.add(nuevoDetalle);
                        detalle = nuevoDetalle;
                    }
                    
                    detalle.ImporteReserva__c = 0;
                    detalle.ImporteContrato__c = 0;
                    detalle.ImporteEscrituracion__c = 0;
                    detalle.ImportePosventa__c = 0;
                    
                    //Recalculo para productos que no tengan la opp cancelada
                    if(producto.ProductoOportunidad__r.Opportunity.StageName != 'Cancelada'){
                        //Calculo para opp con fechas (reserva, contrato, escritura, posventa) en el mes actual
                        if(producto.ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Reserva__c != null && producto.ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Reserva__c.month() == Date.today().month() && producto.ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Reserva__c.year() == Date.today().year()){
                            detalle.ImporteReserva__c = calculoImporte(producto.ProductoOportunidad__r.UnitPrice, producto.PorcentajeComision__c, def.PorcentajeReserva__c);
                            
                        }if(producto.ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Compraventa__c != null && producto.ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Compraventa__c.month() == Date.today().month() && producto.ProductoOportunidad__r.Opportunity.Fecha_firma_Contrato_Compraventa__c.year() == Date.today().year()){
                            detalle.ImporteContrato__c = calculoImporte(producto.ProductoOportunidad__r.UnitPrice, producto.PorcentajeComision__c, def.PorcentajeContrato__c);
                            
                        }if(producto.ProductoOportunidad__r.Opportunity.FechaEscrituracionReal__c != null && producto.ProductoOportunidad__r.Opportunity.FechaEscrituracionReal__c.month() == Date.today().month() && producto.ProductoOportunidad__r.Opportunity.FechaEscrituracionReal__c.year() == Date.today().year()){
                            detalle.ImporteEscrituracion__c = calculoImporte(producto.ProductoOportunidad__r.UnitPrice, producto.PorcentajeComision__c, def.PorcentajeEscrituracion__c);
                            
                        }if(producto.ProductoOportunidad__r.Opportunity.Promocion__r.DiasPosventa__c != null && producto.ProductoOportunidad__r.Opportunity.Promocion__r.DiasPosventa__c != 0 && 
                            producto.ProductoOportunidad__r.Opportunity.FechaPosventa__c != null && producto.ProductoOportunidad__r.Opportunity.FechaPosventa__c.month() == Date.today().month() && producto.ProductoOportunidad__r.Opportunity.FechaPosventa__c.year() == Date.today().year()){
                                
							detalle.ImportePosventa__c = calculoImporte(producto.ProductoOportunidad__r.UnitPrice, producto.PorcentajeComision__c, def.PorcentajePosventa__c);
                            
                        }
                    }
                    
                }
            }
        }
        
        List<DetalleComision__c> lUpdateDetalles = new List<DetalleComision__c>();
        lUpdateDetalles.addAll(sDetalleCom);
        
        List<DetalleComision__c> lInsertDetalles = new List<DetalleComision__c>();
        lInsertDetalles.addAll(sNuevosDetallesComision);
        
        insert lInsertDetalles;
        update lUpdateDetalles;
        
    }
    
    private Decimal calculoImporte(Decimal precio, Decimal porcentajeProductoOpp, Decimal porcentajeDefinicion){
        //Multiplicacion = precio del producto de opp * porcentaje comisión de RVPO * porcentaje Definicion de comision
        return precio * (porcentajeProductoOpp/100) * (porcentajeDefinicion/100);
    }
 
    global void finish(Database.BatchableContext bc){}
    
}