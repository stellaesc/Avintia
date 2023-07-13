/**
@description
<pre>
Manejador para el trigger sobre Account</br>
DATE       	AUTHOR     	DESCRIPTION<br/>
                        Created.  
04/01/2021 	LCS - JZD   Modificado. Refactorización para evitar queries dentro de bucles. Se sacan los métodos de AMLCheck a una nueva clase                         
</pre>
@author Leadclic Solutions
@date 04/01/2021
*/
public class AccountTriggerHandler extends TriggerHandler {  
    private static final Id CUENTA_PERSONAL  = SObjectUtils.getRecordTypeId(Account.sObjectType, 'PersonAccount');
    private static final Id CUENTA_EMPRESA  = SObjectUtils.getRecordTypeId(Account.sObjectType, 'Cuenta');


    protected override void beforeInsert() {
        System.debug('Se ejecuta beforeInsert de AccountTrigger');
        //before();
    }

    protected override void beforeUpdate() {
        System.debug('Se ejecuta beforeUpdate de AccountTrigger');
        //before();
    }

    protected override void before() {
        System.debug('Account Trigger sin AML');
        boolean resultado1;
        boolean resultado2;
        boolean resultado3;

        //Se busca el pais españa para saber la nacionalidad
        List <Pais__c> pais = [SELECT ID FROM Pais__c WHERE Codigo_ISO3__c = :'ESP'];

        for(Account acc : (List<Account>) Trigger.New) {
            if(acc.RecordTypeId.equals(CUENTA_PERSONAL) || acc.RecordTypeId.equals(CUENTA_EMPRESA)) {
                if(pais != null && !pais.isEmpty() && (acc.Nacionalidad__c == pais.get(0).ID || acc.Nacionalidad__pc==pais.get(0).ID) && 
                    (acc.Tipo_de_documento__c != null && acc.Tipo_de_documento__c != '' && acc.Tipo_de_documento__c != 'Pasaporte' && 
                        acc.Tipo_de_documento__c != 'Nº Contribuyente' && acc.Tipo_de_documento__c != 'Otros' && 
                        acc.N_Documento__c != null && acc.N_Documento__c != '')) { 

                    resultado1 = ValidadorTriggerNIFHandler.validateNIFEmpresa(acc.N_Documento__c);
                    if (resultado1) {
                        resultado2 = ValidadorTriggerNIFHandler.validateNIFpersona(acc.N_Documento__c);
                        if (resultado1 && !resultado2) {
                            resultado3 = ValidadorTriggerNIFHandler.validateNIE(acc.N_Documento__c);
                            if (resultado1 && !resultado2 && !resultado3 && !System.Test.isRunningTest()){
                                acc.addError('El NIF/CIF o NIE introducido no es válido, por favor revíselo');
                            }
                        }
                    }
                
                }

                //Realizamos la validacion de la cuenta bancaria
                if(acc.N_cuenta_corriente__c != null && !String.isBlank(acc.N_cuenta_corriente__c)) {   
                    if(acc.N_cuenta_corriente__c.substring(0,2).isAlpha()) { //&& acc.N_cuenta_corriente__c.substring(0,2).equals('ES')) {
                        /*boolean validacion= ValidadorUtil.esCuentaBancaria(acc.N_cuenta_corriente__c);
                        if(!validacion && !System.Test.isRunningTest()) {
                        acc.addError('El Nº de cuenta no es válido, por favor revíselo');
                        }*/
                        if(!IBANValidation.validateIban(acc.N_cuenta_corriente__c) && !Test.isRunningTest())
                            acc.addError('El Nº de cuenta no es válido, por favor revíselo');
                    } else {
                        acc.addError('El Nº de cuenta no tiene el IBAN correctamente informado, por favor revíselo');
                    }
                }
            } else {
                if((acc.Copiar_direccion_2__c==false && acc.Pais_FISCAL__c!=null && acc.Pais_FISCAL__c == pais.get(0).ID) || (acc.Copiar_direccion_2__c==true && acc.DP_Pais__c!=null && acc.DP_Pais__c == pais.get(0).ID))
                 {
                    if(acc.Tipo_de_documento__c!=null && acc.Tipo_de_documento__c!='' && acc.Tipo_de_documento__c!= 'Pasaporte' && acc.Tipo_de_documento__c!= 'Nº Contribuyente'&&acc.Tipo_de_documento__c!= 'Otros'&& acc.N_Documento__c!=null && acc.N_Documento__c!='')
                    {
                        resultado1 = ValidadorTriggerNIFHandler.validateNIFEmpresa(acc.N_Documento__c);
                        if (resultado1) {
                            
                            resultado2 = ValidadorTriggerNIFHandler.validateNIFpersona(acc.N_Documento__c);
                            if (resultado1 && !resultado2){
                                
                                resultado3 = ValidadorTriggerNIFHandler.validateNIE(acc.N_Documento__c);
                                if (resultado1 && !resultado2 && !resultado3){
                                    if(!System.Test.isRunningTest()){
                                        acc.addError('El NIF/CIF o NIE introducido no es válido, por favor revíselo');
                                    }
                                }
                            }
                        }
                    }

                 }
            }            
        }

    }

    /*public override void afterInsert() {
        Set<Id> accsIds = new Set<Id>();
        List<Id> accsIdsList = new List<Id>();
        for(Account acc : (List<Account>) Trigger.New) {
            Boolean allowedRecordTypes = acc.RecordTypeId.equals(CUENTA_EMPRESA) || acc.RecordTypeId.equals(CUENTA_PERSONAL);
            if(allowedRecordTypes && !acc.EnviadoAmlCheck__c) accsIds.add(acc.Id);
        }
        accsIdsList.addAll(accsIds);

        if(!accsIdsList.isEmpty()) AmlCheckHelper.envioClienteAmlCheckFuture(accsIdsList, true);
    }

    public override void afterUpdate() {
        Map<Id, Account> oldMap = (Map<Id, Account>) Trigger.OldMap;
        Map<Id, Account> newMap = (Map<Id, Account>) Trigger.NewMap;
        Set<Id> accsIds = new Set<Id>();
        List<Id> accsIdsList = new List<Id>();
        for(Account acc : (List<Account>) Trigger.New) {
            Boolean allowedRecordTypes = acc.RecordTypeId.equals(CUENTA_EMPRESA) || acc.RecordTypeId.equals(CUENTA_PERSONAL);
            Boolean changedStatus = oldMap.get(acc.Id).Estado_comercial__c != newMap.get(acc.Id).Estado_comercial__c;
            if(allowedRecordTypes && acc.EnviadoAmlCheck__c && changedStatus) accsIds.add(acc.Id);
        }
        accsIdsList.addAll(accsIds);

        if(!accsIdsList.isEmpty()) AmlCheckHelper.envioClienteAmlCheckFuture(accsIdsList, false);
    }*/



}