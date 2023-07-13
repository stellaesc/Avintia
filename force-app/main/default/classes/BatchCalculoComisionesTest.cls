/**
@description
<pre>
Clase Test para la clase BatchCalculoObjetivos</br>
DATE       	AUTHOR     	DESCRIPTION<br/>                 
02/02/2021 	LCS - BCF   Created.                         
</pre>
@author Leadclic Solutions
@date 02/02/2021
*/
@isTest
public class BatchCalculoComisionesTest {
	@isTest
    public static void testCrearDetalle(){
        //Vendedor
        Vendedor__c vendedor = new Vendedor__c();
        vendedor.Name = 'Test';
        vendedor.Apellidos__c = 'Test';
        
        insert vendedor;
        
        Vendedor__c vendedor2 = new Vendedor__c();
        vendedor2.Name = 'Test';
        vendedor2.Apellidos__c = 'Test';
        
        insert vendedor2;
        
        //Promociones
        Promocion__c promocion2 = TestUtil.getPromocion(date.today(), date.today()+30);
                
        //Pricebook
        PriceBook2 pb = new PriceBook2();
        pb.Name = 'Pricebook Test';
        pb.IsActive = true;
        
        insert pb;
                
        //Oportunidad
        Opportunity oportunidad = new Opportunity();
        oportunidad.Name = 'Test';
        oportunidad.StageName = 'Reserva';
        oportunidad.Promocion__c = promocion2.Id;
        oportunidad.CloseDate = Date.today()+30;
        oportunidad.Pricebook2Id = pb.Id;
        oportunidad.Fecha_firma_Contrato_Reserva__c = Date.today();
        oportunidad.Fecha_firma_Contrato_Compraventa__c = Date.today();
        oportunidad.FechaEscrituracionReal__c = Date.today();
        
        insert oportunidad;
        
        //Productos
        Tipo_de_inmueble__c tipoInmueble1 = new Tipo_de_inmueble__c(Name = 'Tipo de Inmueble Vivienda Test', Tipo__c = 'Vivienda');
        Tipo_de_inmueble__c tipoInmueble2 = new Tipo_de_inmueble__c(Name = 'Tipo de Inmueble Garaje Test', Tipo__c = 'Garaje');
        Tipo_de_inmueble__c tipoInmueble3 = new Tipo_de_inmueble__c(Name = 'Tipo de Inmueble Trastero Test', Tipo__c = 'Trastero');
        Tipo_de_inmueble__c tipoInmueble4 = new Tipo_de_inmueble__c(Name = 'Tipo de Inmueble Local Test', Tipo__c = 'Local');
        
        List<Tipo_de_inmueble__c> lTipoInmueble = new List<Tipo_de_inmueble__c>{tipoInmueble1, tipoInmueble2, tipoInmueble3, tipoInmueble4};
        insert lTipoInmueble;
        
        Product2 producto = new Product2();
        producto.Name = 'Vivienda Test';
        producto.Estado__c = 'Libre';
        producto.Tipo_de_inmueble__c = tipoInmueble1.Id;
        producto.Precio__c = 45000;
        producto.Promocion__c = promocion2.Id;
        producto.Oportunidad__c = oportunidad.Id;
        
        Product2 producto2 = new Product2();
        producto2.Name = 'Garaje Test';
        producto2.Estado__c = 'Libre';
        producto2.Tipo_de_inmueble__c = tipoInmueble2.Id;
        producto2.Precio__c = 15000;
        producto2.Promocion__c = promocion2.Id;
        producto2.Oportunidad__c = oportunidad.Id;
        
        Product2 producto3 = new Product2();
        producto3.Name = 'Trastero Test';
        producto3.Estado__c = 'Libre';
        producto3.Tipo_de_inmueble__c = tipoInmueble3.Id;
        producto3.Precio__c = 25000;
        producto3.Promocion__c = promocion2.Id;
        producto3.Oportunidad__c = oportunidad.Id;
    
        Product2 producto4 = new Product2();
        producto4.Name = 'Local Test';
        producto4.Estado__c = 'Libre';
        producto4.Tipo_de_inmueble__c = tipoInmueble4.Id;
        producto4.Precio__c = 35000;
        producto4.Promocion__c = promocion2.Id;
        producto4.Oportunidad__c = oportunidad.Id;
        
        List<Product2> lProductos = new List<Product2>{producto, producto2, producto3, producto4};
        insert lProductos;
        
        //PriceBookEntry
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.IsActive = true;
        pbe1.Pricebook2Id = pb.Id;
        pbe1.Product2Id = producto.Id;
        pbe1.UnitPrice = 1000;
        
        PriceBookEntry pbe2 = new PriceBookEntry();
        pbe2.IsActive = true;
        pbe2.Pricebook2Id = pb.Id;
        pbe2.Product2Id = producto2.Id;
        pbe2.UnitPrice = 1000;
        
        PriceBookEntry pbe3 = new PriceBookEntry();
        pbe3.IsActive = true;
        pbe3.Pricebook2Id = pb.Id;
        pbe3.Product2Id = producto3.Id;
        pbe3.UnitPrice = 1000;
        
        PriceBookEntry pbe4 = new PriceBookEntry();
        pbe4.IsActive = true;
        pbe4.Pricebook2Id = pb.Id;
        pbe4.Product2Id = producto4.Id;
        pbe4.UnitPrice = 1000;
        
        List<PriceBookEntry> lPbe = new List<PriceBookEntry>{pbe1, pbe2, pbe3, pbe4};
        insert lPbe;
        
		//Productos de oportunidad
		OpportunityLineItem productoOpp = new OpportunityLineItem();
        productoOpp.OpportunityId = oportunidad.Id;
        productoOpp.Product2Id = producto.Id;
        productoOpp.UnitPrice = 4500;
        productoOpp.Quantity = 1;
        productoOpp.Description = 'Producto 1';
        
        insert productoOpp;

        OpportunityLineItem productoOpp2 = new OpportunityLineItem();
        productoOpp2.OpportunityId = oportunidad.Id;
        productoOpp2.Product2Id = producto2.Id;
        productoOpp2.UnitPrice = 1500;
        productoOpp2.Quantity = 1;
        productoOpp.Description = 'Producto 2';
        
        insert productoOpp2;
        
        OpportunityLineItem productoOpp3 = new OpportunityLineItem();
        productoOpp3.OpportunityId = oportunidad.Id;
        productoOpp3.Product2Id = producto3.Id;
        productoOpp3.UnitPrice = 2500;
        productoOpp3.Quantity = 1;
        productoOpp.Description = 'Producto 3';
        
        insert productoOpp3;
    
        OpportunityLineItem productoOpp4 = new OpportunityLineItem();
        productoOpp4.OpportunityId = oportunidad.Id;
        productoOpp4.Product2Id = producto4.Id;
        productoOpp4.UnitPrice = 3500;  
        productoOpp4.Quantity = 1;
        productoOpp.Description = 'Producto 4';
        
        insert productoOpp4;
        
        //Realcion Vendedor Producto Oportunidad
        RelacionVendedorProductoOportunidad__c productoVendedor = new RelacionVendedorProductoOportunidad__c();
        productoVendedor.Vendedor__c = vendedor.Id;
        productoVendedor.ProductoOportunidad__c = productoOpp.Id;
        productoVendedor.PorcentajeComision__c = 10;
        productoVendedor.Titular__c = true;
    
        insert productoVendedor;
        
        RelacionVendedorProductoOportunidad__c productoVendedor2 = new RelacionVendedorProductoOportunidad__c();
        productoVendedor2.Vendedor__c = vendedor.Id;
        productoVendedor2.ProductoOportunidad__c = productoOpp2.Id;
        productoVendedor2.PorcentajeComision__c = 10;
        productoVendedor2.Titular__c = true;
        
        insert productoVendedor2;
        
        RelacionVendedorProductoOportunidad__c productoVendedor3 = new RelacionVendedorProductoOportunidad__c();
        productoVendedor3.Vendedor__c = vendedor2.Id;
        productoVendedor3.ProductoOportunidad__c = productoOpp3.Id;
        productoVendedor3.PorcentajeComision__c = 10;
        productoVendedor3.Titular__c = true;
        
        insert productoVendedor3;
        
        RelacionVendedorProductoOportunidad__c productoVendedor4 = new RelacionVendedorProductoOportunidad__c();
        productoVendedor4.Vendedor__c = vendedor2.Id;
        productoVendedor4.ProductoOportunidad__c = productoOpp4.Id;
        productoVendedor4.PorcentajeComision__c = 10;
        productoVendedor4.Titular__c = true;
        
        insert productoVendedor4;
        
        //Definicion de Comisiones
        DefinicionComision__c definicion1 = new DefinicionComision__c();
        definicion1.Vendedor__c = vendedor.Id;
        definicion1.Promocion__c = promocion2.Id;
        definicion1.Mes__c = Date.today().month().format();
        definicion1.Year__c = Date.today().year().format();
        definicion1.Activo__c = true;
        definicion1.PorcentajeReserva__c = 5;
        definicion1.PorcentajeContrato__c = 5;
        definicion1.PorcentajeEscrituracion__c = 5;
        definicion1.PorcentajePosventa__c = 5;
        
        insert definicion1;
        
        DefinicionComision__c definicion2 = new DefinicionComision__c();
        definicion2.Vendedor__c = vendedor2.Id;
        definicion2.Promocion__c = promocion2.Id;
        definicion2.Mes__c = Date.today().month().format();
        definicion2.Year__c = Date.today().year().format();
        definicion2.Activo__c = true;
        definicion2.PorcentajeReserva__c = 5;
        definicion2.PorcentajeContrato__c = 5;
        definicion2.PorcentajeEscrituracion__c = 5;
        definicion2.PorcentajePosventa__c = 5;
        
        insert definicion2;
        
        //Comisiones
        Comision__c comision = new Comision__c();
        comision.Vendedor__c = vendedor.Id;
        comision.Mes__c = Date.today().month().format();
        comision.Year__c = Date.today().year().format();
        
        insert comision;
        
        Comision__c comision2 = new Comision__c();
        comision2.Vendedor__c = vendedor2.Id;
        comision2.Mes__c = Date.today().month().format();
        comision2.Year__c = Date.today().year().format();
        
        insert comision2;
        
        //Detalle de Comisiones
        DetalleComision__c detalle1 = new DetalleComision__c();
        detalle1.Vendedor__c = vendedor.Id;
        detalle1.Promocion__c = promocion2.Id;
        detalle1.Mes__c = Date.today().month().format();
        detalle1.Year__c = Date.today().year().format();
        detalle1.Tipo__c = 'Fija';
        detalle1.ProductoOportunidad__c = productoOpp.Id;
        detalle1.Comision__c = comision.Id;
        detalle1.ImporteReserva__c = 0;
        detalle1.ImporteContrato__c = 0;
        detalle1.ImporteEscrituracion__c = 0;
        detalle1.ImportePosventa__c = 0;
        
        insert detalle1;
        
        DetalleComision__c detalle2 = new DetalleComision__c();
        detalle2.Vendedor__c = vendedor2.Id;
        detalle2.Promocion__c = promocion2.Id;
        detalle2.Mes__c = Date.today().month().format();
        detalle2.Year__c = Date.today().year().format();
        detalle2.Tipo__c = 'Fija';
        detalle2.ProductoOportunidad__c = productoOpp3.Id;
        detalle2.Comision__c = comision2.Id;
        detalle2.ImporteReserva__c = 0;
        detalle2.ImporteContrato__c = 0;
        detalle2.ImporteEscrituracion__c = 0;
        detalle2.ImportePosventa__c = 0;
        
        insert detalle2;        
        
        Test.startTest();
            BatchCalculoComisiones b = new BatchCalculoComisiones();
            Database.executebatch(b, 50);
        Test.stopTest();
        
        String mesActual = Date.today().month().format();
        String yearActual = Date.today().year().format();
        
        List<DetalleComision__c> lDetalles = [SELECT id, Name, Vendedor__c, Mes__c, Year__c, Importe__c, ProductoOportunidad__c, Promocion__c, ImporteContrato__c, ImporteEscrituracion__c, ImportePosventa__c, ImporteReserva__c
                                              FROM DetalleComision__c 
                                              WHERE Mes__c = :mesActual AND Year__c = :yearActual AND Tipo__c = 'Fija' AND Vendedor__c != null AND Promocion__c != null];
        
        for(DetalleComision__c det : lDetalles){
            if(det.ProductoOportunidad__c == productoOpp.Id){
                System.assertEquals(22.5, det.ImporteReserva__c);
                System.assertEquals(22.5, det.ImporteContrato__c);
                System.assertEquals(22.5, det.ImporteEscrituracion__c);
                System.assertEquals(0, det.ImportePosventa__c);
                
            } else if(det.ProductoOportunidad__c == productoOpp2.Id){
                System.assertEquals(7.5, det.ImporteReserva__c);
                System.assertEquals(7.5, det.ImporteContrato__c);
                System.assertEquals(7.5, det.ImporteEscrituracion__c);
                System.assertEquals(0, det.ImportePosventa__c);
                
            } else if(det.ProductoOportunidad__c == productoOpp3.Id){
                System.assertEquals(12.5, det.ImporteReserva__c);
                System.assertEquals(12.5, det.ImporteContrato__c);
                System.assertEquals(12.5, det.ImporteEscrituracion__c);
                System.assertEquals(0, det.ImportePosventa__c);
                
            } else if(det.ProductoOportunidad__c == productoOpp4.Id){
                System.assertEquals(17.5, det.ImporteReserva__c);
                System.assertEquals(17.5, det.ImporteContrato__c);
                System.assertEquals(17.5, det.ImporteEscrituracion__c);
                System.assertEquals(0, det.ImportePosventa__c);
            }
        }
        
    }
   
}