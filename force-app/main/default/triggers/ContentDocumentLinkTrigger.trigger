trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    if(!TriggerHandler.isBypassed('ContentDocumentLinkTrigger')) {
        new ContentDocumentLinkTriggerHandler().run();
    }
}