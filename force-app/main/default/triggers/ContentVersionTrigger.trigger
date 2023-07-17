trigger ContentVersionTrigger on ContentVersion (after insert, after update) {
    if(!TriggerHandler.isBypassed('ContentVersionTrigger')) {
        new HL_ContentVersionTrigger().run();
    }
}