@isTest(SeeAllData=false)
public class Product2TriggerHandler_Test {

    @isTest static void Product2TriggerHandler_Test(){
    	
        Profile pf1 = [Select Id from profile where Name='Planificación']; 
        Profile pf2 = [Select Id from profile where Name='Comercial']; 
        Profile pf3 = [Select Id from profile where Name='Marketing']; 
        Profile pf4 = [Select Id from profile where Name='Departamento Técnico']; 

        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User user1 =new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
		User user2 =new User(firstname = 'ABC2', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test1' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf2.Id
                        ); 
		User user3 =new User(firstname = 'ABC3', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test2' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf3.Id
                        ); 
		User user4 =new User(firstname = 'ABC4', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test3' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf4.Id
                        ); 
        
        List<User> userList = new List<User>{user1, user2, user3, user4};
        
        insert userList;
        
        TriggerHandler.bypass('PromocionTrigger');
        TriggerHandler.bypass('TipoInmuebleTrigger');
        Promocion__c promocion = TestUtil.getPromocion(Date.today(), Date.today().addMonths(12));
        Promocion__c promocion2 = TestUtil.getPromocion(Date.today(), Date.today().addMonths(11)); 
        
        Tipo_de_inmueble__c tipoInmueble1 = new Tipo_de_inmueble__c(Tipo__c = 'Vivienda');
        Tipo_de_inmueble__c tipoInmueble2 = new Tipo_de_inmueble__c(Tipo__c = 'Garaje');
        Tipo_de_inmueble__c tipoInmueble3 = new Tipo_de_inmueble__c(Tipo__c = 'Trastero');
        Tipo_de_inmueble__c tipoInmueble4 = new Tipo_de_inmueble__c(Tipo__c = 'Local');
        
        List<Tipo_de_inmueble__c> tipoInmuebleList = new List<Tipo_de_inmueble__c>{tipoInmueble1, tipoInmueble2, tipoInmueble3, tipoInmueble4};
        
        insert tipoInmuebleList;
        
        TriggerHandler.clearAllBypasses();
        
        Product2 inmueble1 = new Product2(Name = 'InmuebleTest', Promocion__c = promocion.Id, Tipo_de_inmueble__c = tipoInmueble1.Id, 
                                          Estado__c = 'Libre', Precio__c = 1000, Portal__c = '1', Planta__c = 'Ático', Piso__c = 3, Letra_N_Puerta__c = 'A');
        Product2 inmueble2 = new Product2(Name = 'InmuebleTest2', Promocion__c = promocion.Id, Tipo_de_inmueble__c = tipoInmueble2.Id, 
                                          Estado__c = 'Libre', Precio__c = 1000, Portal__c = '1', Planta__c = 'Bajo', Piso__c = 0, Letra_N_Puerta__c = 'A');
        Product2 inmueble3 = new Product2(Name = 'InmuebleTest3', Promocion__c = promocion.Id, Tipo_de_inmueble__c = tipoInmueble3.Id, 
                                          Estado__c = 'Libre', Precio__c = 1000, Portal__c = '1', Piso__c = 1, Planta__c = '1', Letra_N_Puerta__c = 'A');
        Product2 inmueble4 = new Product2(Name = 'InmuebleTest4', Promocion__c = promocion.Id, Tipo_de_inmueble__c = tipoInmueble4.Id, 
                                         Estado__c = 'Libre', Precio__c = 1000, Portal__c = '1', Piso__c = 1, Planta__c = '1', Letra_N_Puerta__c = 'B');
        
        List<Product2> inmuebleList = new List<Product2>{inmueble1, inmueble2, inmueble3, inmueble4};
        insert inmuebleList;
        
		inmueble1.Precio__c = 3000;
        update inmueble1;
        
        delete inmueble1;

    }

}