@isTest (seeAllData=false)
public class GenerarFichaClienteController_TEST {

    @isTest static void test(){

        CNO__c cnoObj = new CNO__c(
            Codigo__c = '1212',
            Name = 'CNO TEST',
            FullName__c = 'CNO TEST'
        );
        insert cnoObj;
        
        Lead ld = new Lead();
        ld.LastName = 'Apellido del lead';
        ld.CNO__c = cnoObj.Id;
        insert ld;
        
        APXTConga4__Conga_Template__c CongaTemp = new APXTConga4__Conga_Template__c();
        CongaTemp.APXTConga4__Name__c = 'FichaCliente';
        insert CongaTemp;
        
        Test.StartTest();
        GenerarFichaClienteController.generarFichaCliente(ld.Id);
        GenerarFichaClienteController.getUrl();  
        GenerarFichaClienteController.getCongaTemplateId();
        Test.StopTest();
    }   
}