trigger OpportunityTrigger on Opportunity (after update, before insert, before update) {

    if(!TriggerHandler.isBypassed('OpportunityTrigger')) {
        system.debug('Entre trigger opp');
        new HL_Opportunity().run();
        TriggerHandler.bypass('OpportunityTrigger');
    }
    
    if(trigger.isAfter && trigger.isUpdate){
    	HL_Opportunity.afterUpdate(trigger.new, trigger.oldMap);
    }
}