trigger Product2Trigger on Product2 (before insert, before update, after insert, after update, before delete) {
    if(!TriggerHandler.isBypassed('Product2Trigger')) {
        new Product2TriggerHandler().run();
    }
}