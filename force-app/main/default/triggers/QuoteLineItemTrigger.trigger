trigger QuoteLineItemTrigger on QuoteLineItem (before insert) {
	if(trigger.isBefore){
        if (trigger.isInsert){
            system.debug('Entra en before insert - QuoteLineItemTrigger');
            QuoteLineItemTriggerHandler.anadirPriceBookEntry(trigger.new);
            QuoteLineItemTriggerHandler.validarCondicionesInsercion(trigger.new);

            }
        }
}