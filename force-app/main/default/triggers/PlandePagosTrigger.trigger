trigger PlandePagosTrigger on Plan_de_pagos__c (before insert, before update) {
     if(!TriggerHandler.isBypassed('PlandePagosTrigger')) {
        new HL_PlandePagosTrigger().run();
    }
}