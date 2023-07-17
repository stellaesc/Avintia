trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    if(!TriggerHandler.isBypassed('AccountTriggerHandler')) {
        new AccountTriggerHandler().run();
    }
}