trigger TipoInmuebleTrigger on Tipo_de_inmueble__c (before delete) {
    if(!TriggerHandler.isBypassed('TipoInmuebleTrigger')) {
        new HL_TipoInmuebleTrigger().run();
    }
}