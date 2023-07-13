/**
@description
<pre>
Manejador para el trigger sobre Account</br>
DATE       	AUTHOR     	DESCRIPTION<br/>
                        Created.  
04/01/2021 	LCS - JZD   Modificado. Cambiada la llamada al método de envioClienteAmlCheck para usar la nueva clase AmlCheckHelper                         
</pre>
@author Leadclic Solutions
@date 04/01/2021
*/
global class AMLCheckBatch implements Database.Batchable<sObject>, Schedulable{
    
    private static final Id CUENTA_PERSONAL  = SObjectUtils.getRecordTypeId(Account.sObjectType, 'PersonAccount');
    private static final Id CUENTA_EMPRESA  = SObjectUtils.getRecordTypeId(Account.sObjectType, 'Cuenta');

    global void execute(SchedulableContext sc){
        //Instancia de la clase.
        AMLCheckBatch b = new AMLCheckBatch();
        Database.executebatch(b, 50);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id,Name,FirstName, CNAE__c, CNO__c, Situacion_laboral__c, RecordTypeId, EnviadoAmlCheck__c
                                         FROM Account
                                         WHERE RecordTypeId IN (:CUENTA_PERSONAL, :CUENTA_EMPRESA) AND EnviadoAmlCheck__c = false
                                         AND (CNAE__c != null OR CNO__c != null OR Situacion_laboral__c != null)]);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accounts){
        List<Id> accsIds = new List<Id>(); 
        for(Account acc: accounts){
            accsIds.add(acc.Id);
        }
       // AmlCheckHelper.envioClienteAmlCheck(accsIds, false);
    }
    
    global void finish(Database.BatchableContext bc){}
   
}