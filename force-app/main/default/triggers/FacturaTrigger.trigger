trigger FacturaTrigger on Factura__c (before delete) {
    if(!TriggerHandler.isBypassed('FacturaTrigger')) {
        new HL_FacturaTrigger().run();
    }
}