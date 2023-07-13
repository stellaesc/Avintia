@isTest(SeeAllData=false)
public class BotonEditarPlanPagosController_Test {

    @isTest static void getPlanDePagos_Test(){
        
        Opportunity oportunidad = TESTUtil.getOportunidad_Contrato_Compraventa_VPO_controller();
        
        		system.debug('TEST OPORTUNIDAD VPO'+oportunidad);
        Test.startTest();   
        Factura__c factura = TESTUtil.getFactura(); //TOO MANY QUERIES
        
        List<Factura__c> facturaList = new List<Factura__c>();
        facturaList.add(factura);
        List<Factura__c> cuotaExtraList = TESTUtil.getFacturaCuotaExtra();
        
        
        List<Factura__c> cuotasList = BotonEditarPlanPagosController.getCuotas(oportunidad.Id, 'Cuota');
        List<String> respuesta = BotonEditarPlanPagosController.crearPlanPagos(oportunidad.Id, facturaList, 0, 'Guardar', cuotaExtraList, 0);
        List<String> respuesta2 = BotonEditarPlanPagosController.crearPlanPagos(oportunidad.Id, facturaList, 1, 'Guardar', cuotaExtraList, 0);
        List<String> respuesta3 = BotonEditarPlanPagosController.crearPlanPagos(oportunidad.Id, facturaList, 0, 'Solicitar', cuotaExtraList, 0);
        Test.stopTest();
    }    
    
}