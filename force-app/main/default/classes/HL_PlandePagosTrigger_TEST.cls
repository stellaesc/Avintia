@IsTest
public class HL_PlandePagosTrigger_TEST {

    @IsTest
    public static void testBeforeInsert() {
    	Plan_de_pagos__c pdp = TestUtil.getPlan_de_Pagos_controller();
        
        Test.startTest();
        Plan_de_pagos__c pp = [SELECT Id, API_Comercial__C, Responsable_Comercial__c FROM Plan_de_pagos__c WHERE Id = :pdp.Id];
        Opportunity opp = [SELECT Id, Promocion__r.Comercial__c, OwnerId FROM Opportunity WHERE Id = :pdp.Oportunidad__c];
        
        System.assertEquals(pp.API_Comercial__c, opp.OwnerId);
        System.assertEquals(pp.Responsable_Comercial__c, opp.Promocion__r.Comercial__c);
        Test.stopTest();
    }
    
    @IsTest
    public static void testBeforeUpdate() {
        Plan_de_pagos__c pdp = TestUtil.getPlan_de_Pagos_controller();
        
        Test.startTest();
        Plan_de_pagos__c pp = [SELECT Id, API_Comercial__C, Responsable_Comercial__c FROM Plan_de_pagos__c WHERE Id = :pdp.Id];
        Opportunity opp = [SELECT Id, Promocion__c, OwnerId FROM Opportunity WHERE Id = :pdp.Oportunidad__c];
        Promocion__c pr = [SELECT Id, Comercial__c FROM Promocion__c WHERE Id = :opp.Promocion__c];
        
        System.assertEquals(pp.API_Comercial__c, opp.OwnerId);
        System.assertEquals(pp.Responsable_Comercial__c, pr.Comercial__c);
        
        Profile prof = [SELECT Id FROM Profile WHERE Name LIKE '%Comercial%' LIMIT 1];
        User u = new User(LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             ProfileId = prof.Id);
        insert u;
        
        pr.Comercial__c = u.Id;
        update pr;
        pr = [SELECT Id, Comercial__c FROM Promocion__c WHERE Id = :opp.Promocion__c];
        
        pp.API_Comercial__c = UserInfo.getUserId();
        update pp;
        pp = [SELECT Id, API_Comercial__C, Responsable_Comercial__c FROM Plan_de_pagos__c WHERE Id = :pdp.Id];
        
        System.assertEquals(pp.API_Comercial__c, opp.OwnerId);
        System.assertEquals(pp.Responsable_Comercial__c, pr.Comercial__c);
        Test.stopTest();
    }
    
}