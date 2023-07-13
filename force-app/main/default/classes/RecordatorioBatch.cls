global class RecordatorioBatch implements Database.Batchable<sObject>, Schedulable{
    
    global void execute(SchedulableContext sc){
        //Instancia de la clase.
        RecordatorioBatch b = new RecordatorioBatch();
        Database.executebatch(b, 50);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //Consulta de task de tipo recordatorio 
        Id recordatorio = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Publicar_promocion').getRecordTypeId();
        
        return Database.getQueryLocator([SELECT Id, NextRecordatorio__c, NumRecordatorio__c, OwnerId
                                         FROM Task
                                         WHERE RecordTypeId =: recordatorio AND NextRecordatorio__c = TODAY AND NumRecordatorio__c <= 7]);
    }
    
    global void execute(Database.BatchableContext bc, List<Task> recordatorios){
        System.debug('Recordatorios: ' + recordatorios);
        List<Task> recordatoriosAct = new List<Task>();
        for(Task t: recordatorios){
            t.NumRecordatorio__c += 1;
        	t.NextRecordatorio__c = Date.today().addDays(2);
            recordatoriosAct.add(t);
            
            Map<String, Object> params = new Map<String, Object>();
            params.put('IdTask', t.Id);
            params.put('TaskOwnerId', t.OwnerId);
            params.put('SoloRecordatorio', true);
            Flow.Interview.Creacion_Aviso_Tarifario_Aprobado FlowSk = new Flow.Interview.Creacion_Aviso_Tarifario_Aprobado(params);
            FlowSk.start(); 
            
        }
        
        System.debug('recordatoriosAct: ' + recordatoriosAct);
                
        if (recordatoriosAct.size()>0) {   
        	update recordatoriosAct;             
        }
   	}
    
    global void finish(Database.BatchableContext bc){
        
    }

}