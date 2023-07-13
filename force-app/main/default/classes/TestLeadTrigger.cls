@isTest
public class TestLeadTrigger {

    @isTest
    static void testAltaLead() {
        CNO__c cnoObj = new CNO__c(
            Codigo__c = '1212',
            Name = 'CNO TEST',
            FullName__c = 'CNO TEST'
        );
        insert cnoObj;

        //Lead con un NIE correcto
        Lead lead = new Lead();
        lead.FirstName='prueba';
        lead.LastName='apellidos';
        lead.Email='correo@correo.es';
        lead.Status='Lead';
        lead.LeadSource='Web corporativa';
         Pais__c pais =new Pais__c();
            pais.Name='España';
            pais.Codigo_ISO2__c='ES';
            pais.Codigo_ISO3__c='ESP';
            pais.Codigo_ISO3_num__c=724;
            insert pais;
        lead.Nacionalidad__c=pais.ID;
        lead.Tipo_de_documento__c='NIE';
        lead.Numero_de_documento__c='X8819773D';
        lead.CNO__c = cnoObj.Id;
        //Lead con datos erroneos
        Lead lead2 = new Lead();
        lead2.FirstName='prueba2';
        lead2.LastName='apellidos2';
        lead2.Email='corre2@correo.es';
        lead2.Status='Lead';
        lead2.LeadSource='Web corporativa';
        lead2.CNO__c = cnoObj.Id;
        lead.Nacionalidad__c=pais.ID;
        lead.Tipo_de_documento__c='NIE';
        lead.Numero_de_documento__c='188197730';

     Test.startTest(); 
      insert lead2;
      insert lead;
     Test.stopTest();


    }

}