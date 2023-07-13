/**
 * Clase test de la clase HL_Opportunity
 *
 * Historial
 * ------------------------------------------------------------------------------------------------------
 *
 *	v1.0		
 */
@isTest
public class TEST_Opportunity {
    
     
    /*@isTest
    static void cambiarEstadoOportunidadInmuebleApartado(){
        TestUtil.getProductoOportunidad();
        Product2 inmueble = [SELECT id, estado__c FROM Product2 WHERE name = 'Inmueble Test' LIMIT 1];
        inmueble.estado__c = 'Apalabrado';
        update inmueble;
        
        //obtener oportunidad
        Test.startTest();
        Opportunity oportunidad = [SELECT Id, StageName, Promocion__r.Socio_Empresa_Promotora__c, Promocion__r.Socio_Empresa_Promotora__r.Codigo_de_sociedad__c FROM Opportunity WHERE name = 'Oportunidad Test' LIMIT 1];
        oportunidad.StageName = 'Cancelada';
		oportunidad.Loss_Reason__c = 'Other';
        update oportunidad;
        
        Product2 inmuebleCambiado = [SELECT id, estado__c FROM Product2 WHERE name = 'Inmueble Test' LIMIT 1];
        System.assertEquals('Libre', inmuebleCambiado.estado__c); 
  		Test.stopTest();
    }*/ //Comentado el metodo
    
    /*
    @isTest
    static void cambiarEstadoOportunidadInmuebleBloqueado(){
        
        Opportunity oportunidad = new Opportunity();
        
        //Generar datos
        TestUtil.getProductoOportunidad();
        
        Product2 inmueble = [SELECT id, estado__c FROM Product2 WHERE name = 'Inmueble Test' LIMIT 1];
        
        inmueble.estado__c = 'Bloqueado';

        update inmueble;
        
        //obtener oportunidad
        Oportunidad = [SELECT id FROM Opportunity WHERE name = 'Oportunidad Test' LIMIT 1];
        
        oportunidad.StageName = 'Cancelada';
		oportunidad.Loss_Reason__c = 'Other';
        
        update oportunidad;
        
        Product2 inmuebleCambiado = [SELECT id, estado__c FROM Product2 WHERE name = 'Inmueble Test' LIMIT 1];
        
        System.assertEquals('Cancelado', inmuebleCambiado.estado__c); 
 
    }
    */
    
    @isTest
    static void recalculoComisionesOpp1(){
        //Promocion
        Promocion__c promocion = TestUtil.getPromocion(date.today(), date.today()+30);
        promocion.DiasPosventa__c = 2;

        //Prodcuto de oportunidad
        OpportunityLineItem producto1 = TestUtil.getProductoOportunidad();
        Product2 prod1 = [SELECT Id, Promocion__c FROM Product2 WHERE Id = :producto1.Product2Id];
        Id opp1 = producto1.OpportunityId;
        prod1.Promocion__c = promocion.Id;
        update prod1;
        
        //Vendedores
        Vendedor__c vendedor = new Vendedor__c();
        vendedor.Name = 'Test';
        vendedor.Apellidos__c = 'Test';
        
        insert vendedor;
        
        //Relacion Vendedor ProductoOportunidad
        RelacionVendedorProductoOportunidad__c productoVendedor = new RelacionVendedorProductoOportunidad__c();
        productoVendedor.Vendedor__c = vendedor.Id;
        productoVendedor.ProductoOportunidad__c = producto1.Id;
        productoVendedor.PorcentajeComision__c = 10;
        productoVendedor.Titular__c = true;
    
        insert productoVendedor;
        
        //comisiones
        Comision__c comision = new Comision__c();
        comision.Vendedor__c = vendedor.Id;
        comision.Mes__c = Date.today().month().format();
        comision.Year__c = '2.021';
        
        insert comision;
        
        Comision__c comision2 = new Comision__c();
        comision2.Vendedor__c = vendedor.Id;
        comision2.Mes__c = Date.today().month().format();
        comision2.Year__c = Date.today().year().format();
        
        insert comision2;
        
        //Detalle comision
        DetalleComision__c detalle1 = new DetalleComision__c();
        detalle1.Vendedor__c = vendedor.Id;
        detalle1.Promocion__c = promocion.Id;
        detalle1.Mes__c = Date.today().month().format();
        detalle1.Year__c = '2.021';
        detalle1.Tipo__c = 'Fija';
        detalle1.ProductoOportunidad__c = producto1.Id;
        detalle1.Comision__c = comision.Id;
        detalle1.ImporteReserva__c = 1000;
        detalle1.ImporteContrato__c = 1000;
        detalle1.ImporteEscrituracion__c = 1000;
        detalle1.ImportePosventa__c = 1000;
        
        insert detalle1;
        
        //Oportunidades
        Opportunity oportunidad1 = [SELECT Id, Name, StageName, Promocion__c, Loss_Reason__c, Fecha_firma_Contrato_Reserva__c, Fecha_firma_Contrato_Compraventa__c, FechaEscrituracionReal__c FROM Opportunity WHERE Id = :opp1 LIMIT 1];
        oportunidad1.Promocion__c = promocion.Id;
        oportunidad1.Fecha_firma_Contrato_Reserva__c = Date.today() - 365;
        oportunidad1.Fecha_firma_Contrato_Compraventa__c = Date.today() - 365;
        oportunidad1.FechaEscrituracionReal__c = Date.today() - 365;
        update oportunidad1;
        
        Test.startTest();
        oportunidad1.StageName = 'Cancelada';
		oportunidad1.Loss_Reason__c = 'Other';
        update oportunidad1;
        Test.stopTest();
        
        List<DetalleComision__c> lDetallesPromo1 = [SELECT Id, Vendedor__c, Promocion__c, Importe__C, Concepto__c, Tipo__c, Mes__c, Year__c, Comision__c 
                                                    FROM DetalleComision__c 
                                                    WHERE Importe__c < 0 AND Mes__c = :Date.today().month().format() AND Year__c = :Date.today().year().format()];
        
        for(DetalleComision__c det : lDetallesPromo1){
            if(det.Vendedor__c == vendedor.Id){
                System.assertEquals(det.Importe__c, -4000);
                System.assertEquals(det.Tipo__c, 'Extra');
                System.assertEquals(det.Concepto__c, 'Cancelación de la oportunidad ' + oportunidad1.Name);
                System.assertEquals(det.Vendedor__c, vendedor.Id);
                System.assertEquals(det.Promocion__c, promocion.Id);
                System.assertEquals(det.Comision__c, comision2.Id);
            }
        }        
           
    }
    
    @isTest
    static void recalculoComisionesOpp2(){
        //Promocion
        Promocion__c promocion = TestUtil.getPromocion(date.today(), date.today()+30);
        
        //Producto de oportunidad
        OpportunityLineItem producto = TestUtil.getProductoOportunidad();
        Product2 prod = [SELECT Id, Promocion__c FROM Product2 WHERE Id = :producto.Product2Id];
        Id opp = producto.OpportunityId;
        prod.Promocion__c = promocion.Id;
		update prod;  
        
        //Vendedores
        Vendedor__c vendedor = new Vendedor__c();
        vendedor.Name = 'Test';
        vendedor.Apellidos__c = 'Test';
        
        insert vendedor;
        
        Vendedor__c vendedor2 = new Vendedor__c();
        vendedor2.Name = 'Test';
        vendedor2.Apellidos__c = 'Test';
        
        insert vendedor2;
        
        //Relacion Vendedor ProductoOportunidad
        RelacionVendedorProductoOportunidad__c productoVendedor1 = new RelacionVendedorProductoOportunidad__c();
        productoVendedor1.Vendedor__c = vendedor.Id;
        productoVendedor1.ProductoOportunidad__c = producto.Id;
        productoVendedor1.PorcentajeComision__c = 10;
        productoVendedor1.Titular__c = true;
        
        insert productoVendedor1;
        
        RelacionVendedorProductoOportunidad__c productoVendedor2 = new RelacionVendedorProductoOportunidad__c();
        productoVendedor2.Vendedor__c = vendedor2.Id;
        productoVendedor2.ProductoOportunidad__c = producto.Id;
        productoVendedor2.PorcentajeComision__c = 10;
        productoVendedor2.Titular__c = true;
        
        insert productoVendedor2;

        //comisiones
        Comision__c comision = new Comision__c();
        comision.Vendedor__c = vendedor.Id;
        comision.Mes__c = Date.today().month().format();
        comision.Year__c = '2.021';
        
        insert comision;
        
        Comision__c comision2 = new Comision__c();
        comision2.Vendedor__c = vendedor2.Id;
        comision2.Mes__c = Date.today().month().format();
        comision2.Year__c = '2.021';
        
        insert comision2;
        
        Comision__c comision3 = new Comision__c();
        comision3.Vendedor__c = vendedor.Id;
        comision3.Mes__c = Date.today().month().format();
        comision3.Year__c = Date.today().year().format();
        
        insert comision3;
        
        Comision__c comision4 = new Comision__c();
        comision4.Vendedor__c = vendedor2.Id;
        comision4.Mes__c = Date.today().month().format();
        comision4.Year__c = Date.today().year().format();
        
        insert comision4;
        
        //Detalles Comision
        DetalleComision__c detalle1 = new DetalleComision__c();
        detalle1.Vendedor__c = vendedor.Id;
        detalle1.Promocion__c = promocion.Id;
        detalle1.Mes__c = Date.today().month().format();
        detalle1.Year__c = '2.021';
        detalle1.Tipo__c = 'Fija';
        detalle1.ProductoOportunidad__c = producto.Id;
        detalle1.Comision__c = comision.Id;
        detalle1.ImporteReserva__c = 1000;
        detalle1.ImporteContrato__c = 1000;
        detalle1.ImporteEscrituracion__c = 0;
        detalle1.ImportePosventa__c = 0;
        
        insert detalle1;  
        
        DetalleComision__c detalle2 = new DetalleComision__c();
        detalle2.Vendedor__c = vendedor2.Id;
        detalle2.Promocion__c = promocion.Id;
        detalle2.Mes__c = Date.today().month().format();
        detalle2.Year__c = '2.021';
        detalle2.Tipo__c = 'Fija';
        detalle2.ProductoOportunidad__c = producto.Id;
        detalle2.Comision__c = comision2.Id;
        detalle2.ImporteReserva__c = 1000;
        detalle2.ImporteContrato__c = 1000;
        detalle2.ImporteEscrituracion__c = 0;
        detalle2.ImportePosventa__c = 0;
        
        insert detalle2;    
        
        //oportunidad
        Opportunity oportunidad= [SELECT Id, Name, StageName, Promocion__c, Loss_Reason__c, Fecha_firma_Contrato_Reserva__c, Fecha_firma_Contrato_Compraventa__c, FechaEscrituracionReal__c FROM Opportunity WHERE Id = :opp LIMIT 1];
        oportunidad.Promocion__c = promocion.Id;
        oportunidad.Fecha_firma_Contrato_Reserva__c = Date.today() - 365;
        oportunidad.Fecha_firma_Contrato_Compraventa__c = Date.today() - 365;
        update oportunidad;
        
        Test.startTest();
        oportunidad.StageName = 'Cancelada';
		oportunidad.Loss_Reason__c = 'Other';
        update oportunidad;
        Test.stopTest();
        
        List<DetalleComision__c> lDetallesPromo2 = [SELECT Id, Vendedor__c, Promocion__c, Importe__C, Concepto__c, Tipo__c, Mes__c, Year__c, Comision__c
                                                    FROM DetalleComision__c 
                                                    WHERE Importe__c < 0 AND Mes__c = :Date.today().month().format() AND Year__c = :Date.today().year().format()];
        
        for(DetalleComision__c det : lDetallesPromo2){
            if(det.Vendedor__c == vendedor.Id){
                System.assertEquals(det.Importe__c, -2000);
                System.assertEquals(det.Tipo__c, 'Extra');
                System.assertEquals(det.Concepto__c, 'Cancelación de la oportunidad ' + oportunidad.Name);
                System.assertEquals(det.Vendedor__c, vendedor.Id);
                System.assertEquals(det.Promocion__c, promocion.Id);
                System.assertEquals(det.Comision__c, comision3.Id);
            
            }else if(det.Vendedor__c == vendedor2.Id){
                System.assertEquals(det.Importe__c, -2000);
                System.assertEquals(det.Tipo__c, 'Extra');
                System.assertEquals(det.Concepto__c, 'Cancelación de la oportunidad ' + oportunidad.Name);
                System.assertEquals(det.Vendedor__c, vendedor2.Id);
                System.assertEquals(det.Promocion__c, promocion.Id);
                System.assertEquals(det.Comision__c, comision4.Id);
            }
        }
    }
}