public class HL_PlandePagosTrigger extends TriggerHandler{
    
    protected override void beforeInsert(){
     	List<Plan_de_pagos__c> news = (List<Plan_de_pagos__c>) Trigger.new;
        
        Set<Id> oppIds = new Set<Id>();
        for(Plan_de_pagos__c n : news) 
        	if(n.Oportunidad__c != null && !oppIds.contains(n.Oportunidad__c)) oppIds.add(n.Oportunidad__c);
            
        Map<Id, Opportunity> opps = new Map<Id, Opportunity>([SELECT Id, Promocion__r.Comercial__c, OwnerId FROM Opportunity WHERE Id IN :oppIds]);
        for(Plan_de_pagos__c n : news) {
            n.API_Comercial__c = opps.containsKey(n.Oportunidad__c) ? opps.get(n.Oportunidad__c).OwnerId : null;
            n.Responsable_Comercial__c = opps.containsKey(n.Oportunidad__c) ? opps.get(n.Oportunidad__c).Promocion__r.Comercial__c : null;
        }
    }
    
    protected override void beforeUpdate(){
     	List<Plan_de_pagos__c> news = (List<Plan_de_pagos__c>) Trigger.new;
        
        Set<Id> oppIds = new Set<Id>();
        for(Plan_de_pagos__c n : news) 
        	if(n.Oportunidad__c != null && !oppIds.contains(n.Oportunidad__c)) oppIds.add(n.Oportunidad__c);
            
        Map<Id, Opportunity> opps = new Map<Id, Opportunity>([SELECT Id, Promocion__r.Comercial__c, OwnerId FROM Opportunity WHERE Id IN :oppIds]);
        for(Plan_de_pagos__c n : news) {
            n.API_Comercial__c = opps.containsKey(n.Oportunidad__c) ? opps.get(n.Oportunidad__c).OwnerId : null;
            n.Responsable_Comercial__c = opps.containsKey(n.Oportunidad__c) ? opps.get(n.Oportunidad__c).Promocion__r.Comercial__c : null;
        }
    }
    
}