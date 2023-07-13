@isTest
public class TestContactTrigger {

    @isTest
    static void testAltaContacto() {
        Contact contact = new Contact();
        contact.FirstName='pruebaContacto';
        contact.LastName='apellidos';
        contact.Tipo_de_documento__c='NIE';
        contact.N_Documento__c='X8819773D';
        contact.Email='corrreo@correeo.es';
        contact.Sexo__c='Hombre';

        Pais__c pais =new Pais__c();
            pais.Name='España';
            pais.Codigo_ISO2__c='ES';
            pais.Codigo_ISO3__c='ESP';
            pais.Codigo_ISO3_num__c=724;
            insert pais;
      contact.Nacionalidad__c=pais.ID;
    
     Test.startTest(); 
      insert contact;
     Test.stopTest();

    }

}