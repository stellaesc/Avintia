trigger DocumentVersionHistoryTrigger on DocumentVersionHistory__c (after update) {
	if(!TriggerHandler.isBypassed('DocumentVersionHistoryTrigger')) {
        new HL_DocumentVersionHistoryTrigger().run();
    }
}