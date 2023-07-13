public class HL_DocumentVersionHistoryTrigger extends TriggerHandler {
    
    protected override void afterUpdate() {
        cloneApprovedContentVersion((Map<Id, DocumentVersionHistory__c>)Trigger.newMap, (Map<Id, DocumentVersionHistory__c>)Trigger.oldMap);
    }
    
    public void cloneApprovedContentVersion(Map<Id, DocumentVersionHistory__c> newMap, Map<Id, DocumentVersionHistory__c> oldMap) {
        Set<Id> dvhs = new Set<Id>();
        for(Id i : newMap.keySet()) {
            if(newMap.get(i).Estado__c != oldMap.get(i).Estado__c && newMap.get(i).Estado__c == 'Aprobado')
                dvhs.add(i);
        }
        if(!dvhs.isEmpty()) cloneApprovedContentVersion2(dvhs);
    }
    
    @future
    public static void cloneApprovedContentVersion2(Set<Id> dvhIds){
        List<ContentVersion> contentVersionApprovedList = [SELECT Id, Title, ContentDocumentId, Tipo__c, Activo__c, PathOnClient, VersionData 
                                                           FROM ContentVersion 
                                                           WHERE Document_Version_History__c = :dvhIds]; 
        
        List<ContentVersion> toCreate = new List<ContentVersion>();
        for(ContentVersion cv : contentVersionApprovedList){
            ContentVersion ncv = new ContentVersion();
            ncv.title = cv.title;
            ncv.ContentDocumentId = cv.ContentDocumentId;
            ncv.Tipo__c = cv.Tipo__c;
            ncv.Activo__c = true;
            ncv.PathOnClient = cv.PathOnClient;
            ncv.Document_Version_History__c = null;
            
            if(Test.isRunningTest()) ncv.VersionData = blob.valueOf('Unit.Test');
            else ncv.VersionData = cv.VersionData;
            
            toCreate.add(ncv);
        }
        insert toCreate;
    }
    
}