trigger PromocionTrigger on Promocion__c (after insert, after update, before insert, before update) {
    if(!TriggerHandler.isBypassed('PromocionTrigger')) {
        
        //Validamos el numero de cuenta
        if(Trigger.isBefore) {
            List<Promocion__c> promos = (List<Promocion__c>)Trigger.New;
            Set<Id> constructoraIds = new Set<Id>();
            for(Promocion__c promocion : promos) {
                if(promocion.Constructora__c != null)
                    constructoraIds.add(promocion.Constructora__c);
            }
            Map<Id, Account> constructoras = new Map<Id, Account>([SELECT Id, RecordTypeId FROM Account WHERE Id = :constructoraIds]);
            Id rtConstructora = Schema.sObjectType.Account.getRecordTypeInfosByDeveloperName().get('Constructora').getRecordTypeId();
            for(Promocion__c promocion : promos) {
                if(constructoras.get(promocion.Constructora__c) != null && constructoras.get(promocion.Constructora__c).RecordTypeId != rtConstructora)
                    promocion.Constructora__c.addError('La cuenta elegida debe ser de tipo constructora');
            }
            
            for(Promocion__c promocion : promos) {
                //Realizamos la validacion de la cuenta bancaria
                if(promocion.Numero_de_cuenta_bancaria_1__c!=null && !String.isBlank(promocion.Numero_de_cuenta_bancaria_1__c) && 
                   promocion.Numero_de_cuenta_bancaria_1__c.substring(0,1).isAlpha() && 
                   promocion.Numero_de_cuenta_bancaria_1__c.substring(0,2).equals('ES')) {
                       boolean validacion= ValidadorUtil.esCuentaBancaria(promocion.Numero_de_cuenta_bancaria_1__c);
                       if(!validacion && !System.Test.isRunningTest()) {
                           promocion.addError('El Nº de cuenta 1  o no es válido, por favor revíselo');
                       }
                   } else if(promocion.Numero_de_cuenta_bancaria_1__c != null) {
                       promocion.addError('El Nº de cuenta 1 no tiene el IBAN correctamente informado, por favor revíselo');
                   }
                
                if(promocion.Numero_de_cuenta_bancaria_2__c != null && !String.isBlank(promocion.Numero_de_cuenta_bancaria_2__c) && 
                   promocion.Numero_de_cuenta_bancaria_2__c.substring(0,1).isAlpha() && 
                   promocion.Numero_de_cuenta_bancaria_2__c.substring(0,2).equals('ES')) {
                       boolean validacionCuenta2= ValidadorUtil.esCuentaBancaria(promocion.Numero_de_cuenta_bancaria_2__c);
                       if(!validacionCuenta2 && !System.Test.isRunningTest()){
                           promocion.addError('El Nº de cuenta 2  o no es válido, por favor revíselo');
                       }                    
                   } else if(promocion.Numero_de_cuenta_bancaria_2__c != null) {
                       promocion.addError('El Nº de cuenta 2 no tiene el IBAN correctamente informado, por favor revíselo');
                   }          
            }
        }
        
        if(Trigger.isInsert && Trigger.isAfter){
            system.debug('Entra en after insert');
            HL_Promocion.afterInsert(Trigger.newMap, Trigger.New);
        }
        
        if(Trigger.isUpdate && Trigger.isAfter){
            system.debug('Entra en after update');
            HL_Promocion.afterUpdate(Trigger.newMap, Trigger.oldMap, Trigger.New);
        }
        
    }
    
}