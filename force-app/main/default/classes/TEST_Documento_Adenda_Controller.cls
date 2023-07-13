@isTest
public class TEST_Documento_Adenda_Controller {

    @isTest
    public static void testPlanPagos(){    
        Plan_de_pagos__c planPagos = TESTUtil.getPlan_de_Pagos_controller();
        Test.startTest();
		system.debug('TEST OPORTUNIDAD Libre'+planPagos);
           
        PageReference pageRef = Page.VF_Documento_adenda;
        pageRef.getParameters().put('id', planPagos.id);
           
        Test.setCurrentPage(pageRef);

        Documento_Adenda_Controller controller = new Documento_Adenda_Controller();
        Test.stopTest();
    }
    
}