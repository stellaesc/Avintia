@isTest
public class Test_contrato_comporaventa_controller {
    
    @isTest
    public static void getOf(){
         
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('OpportunityTrigger');
                
        Opportunity oportunidad = TESTUtil.getOportunidad_Contrato_Compraventa_Libre_controller();
                
        PageReference pageRef = Page.VF_Documento_contrato_compraventa;
        pageRef.getParameters().put('id', oportunidad.id);
        Test.setCurrentPage(pageRef);        
        Contrato_compraventa_controller controller = new Contrato_compraventa_controller();
        controller.getOficina();
        
        TriggerHandler.clearBypass('AccountTriggerHandler');
        TriggerHandler.clearBypass('OpportunityTrigger');
    }
    
    @isTest
    public static void testContratoCompraventaLibre(){
        
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('OpportunityTrigger');
        
        Opportunity oportunidad = TESTUtil.getOportunidad_Contrato_Compraventa_Libre_controller();
        
        system.debug('TEST OPORTUNIDAD Libre'+oportunidad);
        
        PageReference pageRef = Page.VF_Documento_contrato_compraventa;
        pageRef.getParameters().put('id', oportunidad.id);
        
        Test.setCurrentPage(pageRef);
        
        Contrato_compraventa_controller controller = new Contrato_compraventa_controller();
        
        
        String nextPage = pageRef.getUrl();
        
        //System.assertEquals('/apex/slider_promocion', nextPage);
        
        //Métodos que devuleven valores
        Contrato_compraventa_controller.getReservaConIva();
        Contrato_compraventa_controller.getImporteAlContado();
        Contrato_compraventa_controller.getImporteAlContadoConReserva();
        Contrato_compraventa_controller.getImporteAPlazos();
        Contrato_compraventa_controller.getImporteAPlazosConIva();
        Contrato_compraventa_controller.getImporteEscrituracion();
        Contrato_compraventa_controller.getImporteIvaOportunidad();
        Contrato_compraventa_controller.getImporteOportunidadMenosReserva();
        Contrato_compraventa_controller.getImporteOportunidadMenosPenalizacion();
        Contrato_compraventa_controller.getImporteIvaCuotaMensual();
        //Contrato_compraventa_controller.getPrecioGarajes();
        Contrato_compraventa_controller.getImporteCuotasExtra();
        Contrato_compraventa_controller.getImporteCuotasExtraconIva();
        Contrato_compraventa_controller.getImporteOportunidadConIva();
        Contrato_compraventa_controller.getAnnoInicioEscrituracion();
        
        
        TriggerHandler.clearBypass('AccountTriggerHandler');
        TriggerHandler.clearBypass('OpportunityTrigger');
        
    }
    
    @isTest
    public static void testContratoCompraventaVPO(){
        
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('OpportunityTrigger');
        
        Opportunity oportunidad = TESTUtil.getOportunidad_Contrato_Compraventa_VPO_controller();
        
        system.debug('TEST OPORTUNIDAD VPO'+oportunidad);
        
        PageReference pageRef = Page.VF_Documento_contrato_compraventa_VPO;
        pageRef.getParameters().put('id', oportunidad.id);
        
        Test.setCurrentPage(pageRef);
        
        Contrato_compraventa_controller controller = new Contrato_compraventa_controller();
        
        
        String nextPage = pageRef.getUrl();
        
        //System.assertEquals('/apex/slider_promocion', nextPage);
        
        //Métodos que devuleven valores
        Contrato_compraventa_controller.getReservaConIva();
        Contrato_compraventa_controller.getImporteAlContado();
        Contrato_compraventa_controller.getImporteAlContadoConReserva();
        Contrato_compraventa_controller.getImporteAPlazos();
        Contrato_compraventa_controller.getImporteAPlazosConIva();
        Contrato_compraventa_controller.getImporteEscrituracion();
        Contrato_compraventa_controller.getImporteIvaOportunidad();
        Contrato_compraventa_controller.getImporteOportunidadMenosReserva();
        Contrato_compraventa_controller.getImporteOportunidadMenosPenalizacion();
        Contrato_compraventa_controller.getImporteIvaCuotaMensual();
        //Contrato_compraventa_controller.getPrecioGarajes();
        Contrato_compraventa_controller.getImporteCuotasExtra();
        Contrato_compraventa_controller.getImporteCuotasExtraconIva();
        Contrato_compraventa_controller.getImporteOportunidadConIva();
        Contrato_compraventa_controller.getAnnoInicioEscrituracion();
        
        TriggerHandler.clearBypass('AccountTriggerHandler');
        TriggerHandler.clearBypass('OpportunityTrigger');
    }
    
    //@isTest
    //public static void testContratoCompraventaVPT(){
    /*
        
        Opportunity oportunidad = TESTUtil.getOportunidad_Contrato_Compraventa_VPT_controller();
        
        
        PageReference pageRef = Page.VF_Documento_contrato_compraventa_VPT;
        pageRef.getParameters().put('id', oportunidad.id);
        
        Test.setCurrentPage(pageRef);
        
        Contrato_compraventa_controller controller = new Contrato_compraventa_controller();
        
        
        String nextPage = pageRef.getUrl();
        
        //System.assertEquals('/apex/slider_promocion', nextPage);
        
        //Métodos que devuleven valores
        //Revisar si usa estos metodos
        Contrato_compraventa_controller.getReservaConIva();
        Contrato_compraventa_controller.getImporteAlContado();
        Contrato_compraventa_controller.getImporteAlContadoConReserva();
        Contrato_compraventa_controller.getImporteAPlazos();
        Contrato_compraventa_controller.getImporteAPlazosConIva();
        Contrato_compraventa_controller.getImporteEscrituracion();
        Contrato_compraventa_controller.getImporteIvaOportunidad();
        Contrato_compraventa_controller.getImporteOportunidadMenosReserva();
        Contrato_compraventa_controller.getImporteOportunidadMenosPenalizacion();
        Contrato_compraventa_controller.getImporteIvaCuotaMensual();
        Contrato_compraventa_controller.getPrecioGarajes();
        Contrato_compraventa_controller.getImporteCuotasExtra();
        Contrato_compraventa_controller.getImporteCuotasExtraconIva();
        Contrato_compraventa_controller.getImporteOportunidadConIva();
        Contrato_compraventa_controller.getAnnoInicioEscrituracion();
        
        //Metodos seguros
        Contrato_compraventa_controller.getImporteOportunidadMenosPenalizacion();
        Contrato_compraventa_controller.getLocales();
    
    }*/
    
    @isTest
    public static void testModeloResolucionReserva(){
        
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('OpportunityTrigger');
        
        Opportunity oportunidad = TESTUtil.getOportunidadDocumento_reserva_controller();
        
        
        PageReference pageRef = Page.ModeloResolucionReservaVivienda;
        pageRef.getParameters().put('id', oportunidad.id);
        
        Test.setCurrentPage(pageRef);
        
        Contrato_compraventa_controller controller = new Contrato_compraventa_controller();
        
        
        String nextPage = pageRef.getUrl();
        
        TriggerHandler.clearBypass('AccountTriggerHandler');
        TriggerHandler.clearBypass('OpportunityTrigger');
        //System.assertEquals('/apex/slider_promocion', nextPage);
        
    }
  
}