trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, before insert) {
	if(trigger.isAfter){
    	if (trigger.isInsert){
            system.debug('Entra en after insert - OpportunityLineItemTrigger');
            OpportunityLineItemTriggerHandler.anadirEstadoDescripcion(trigger.new);
        }
    }
    
    if(trigger.isBefore){
        if (trigger.isInsert){
            system.debug('Entra en before insert - OpportunityLineItemTrigger');
        	OpportunityLineItemTriggerHandler.validarEstadoInmuebles(trigger.new); 
        }
    }
}