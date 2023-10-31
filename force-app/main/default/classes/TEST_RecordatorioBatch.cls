@IsTest
public class TEST_RecordatorioBatch {

    @testSetup
    static void setup(){
        User us = [SELECT Id FROM User WHERE isActive = true AND UserType = 'Standard' LIMIT 1];
        
        Date fechaInicioComercializacionPrevista = Date.newInstance(2018, 09, 20);
        Date fechaFinComercializacionPrevista = Date.newInstance(2018, 10, 03);
        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        
        Id recordatorio = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Publicar_promocion').getRecordTypeId();
                
        Task tsk = new task();
        tsk.RecordTypeId = recordatorio;
        tsk.Type = 'Call';
        tsk.Subject = 'Other';
        tsk.Status = 'Open';
        tsk.Priority = 'Media';
        tsk.OwnerId = us.Id;
		tsk.Promocion__c = promocion.Id;
        tsk.NextRecordatorio__c = Date.today();
        tsk.NumRecordatorio__c = 1;
        insert tsk;

    }
    @IsTest
    static void test(){
        test.startTest();
        RecordatorioBatch btch = new RecordatorioBatch();
        Id batchId = Database.executeBatch(btch);
        test.stopTest();
     }
 
}