public class HL_ContentVersionTrigger extends TriggerHandler {

    protected override void afterInsert() {
        relateDocumentOpportunity(Trigger.new);    
        if(!System.isFuture()) HL_ContentVersionTrigger.createDocumentVersionHistoryRecord(((Map<Id, ContentVersion>) Trigger.newMap).keySet());
    } 
    
    protected override void afterUpdate() {
        Map<Id, ContentVersion> oldMap = (Map<Id, ContentVersion>) Trigger.oldMap;
        Set<Id> cvIds = new Set<Id>();
 		for(ContentVersion cv : ((List<ContentVersion>)Trigger.new)) {
            if(oldMap.get(cv.Id).Tipo__c != cv.Tipo__c && (cv.Tipo__c == 'Memoria_calidades' || cv.Tipo__c == 'Cuadro_superficies'))
                cvIds.add(cv.Id);
        }
        
        if(!cvIds.isEmpty() && !System.isFuture()) HL_ContentVersionTrigger.createDocumentVersionHistoryRecord(((Map<Id, ContentVersion>) Trigger.newMap).keySet());
        
        addURLPublica((Map<Id, ContentVersion>) Trigger.NewMap);
            }
    
        public void addURLPublica(Map<Id, ContentVersion> newMap){
        Map<Id,ContentDistribution> mapCD = new Map<Id,ContentDistribution>();
        Set<Id> setCv = new Set<id>();
        
        for(Id cv: newMap.keySet()){
            if((newMap.get(cv).tipo__c == 'Plano_PDF' || newMap.get(cv).tipo__c == 'Imagen_carrusel' || newMap.get(cv).tipo__c == 'Plano' ||newMap.get(cv).tipo__c =='Carrusel_lifestyle'||
                newMap.get(cv).tipo__c =='Video'||newMap.get(cv).tipo__c =='Folleto'||newMap.get(cv).tipo__c =='Memoria_calidades'||newMap.get(cv).tipo__c =='Planos_zonas_comunes'||
                newMap.get(cv).tipo__c =='Carrusel_entorno'||newMap.get(cv).tipo__c =='Pie_de_web'||newMap.get(cv).tipo__c =='Imagen_financiera' || newMap.get(cv).Tipo__c == 'Video_Youtube' ) && newMap.get(cv).url__c == null){
                    
                    ContentDistribution cd = new ContentDistribution();
                    cd.Name = newMap.get(cv).title;
                    cd.ContentVersionId = cv;
                    cd.PreferencesAllowViewInBrowser= true;
                    cd.PreferencesLinkLatestVersion=true;
                    cd.PreferencesNotifyOnVisit=false;
                    cd.PreferencesPasswordRequired=false;
                    cd.PreferencesAllowOriginalDownload= true;
                    mapCd.put(cv, cd);
                    setCv.add(cv);
                }
        }
        
        if(!mapCd.isEmpty()) {
            insert mapCd.values();
            
            Map<Id, ContentDistribution> mapCdConUrl = new Map<id, ContentDistribution>([SELECT id, DistributionPublicUrl, ContentVersionId 
                                                                                         FROM ContentDistribution
                                                                                         WHERE ContentVersionId IN: setCv]);
            Map<Id, contentVersion> mapCv = new Map<id, contentVersion>();
            for(Id cd: mapCdConUrl.keySet()) {
                for(Id cv : newMap.keyset()){
                    if(mapCdConUrl.get(cd).contentVersionId == cv && newMap.get(cv).url__c == null){
                        contentVersion imagen = new ContentVersion();
                        imagen.Id = cv;
                        imagen.URL__c = mapCdConUrl.get(cd).DistributionPublicUrl;
                        mapCv.put(cv, imagen);
                    }
                }
            }
            update mapCv.values();
        }
    }
    
    public void relateDocumentOpportunity(List<ContentVersion> newList) {
        List<ContentVersion> contentVersionFilteredList = new List<ContentVersion>();
        for(ContentVersion contentVersion : newList){
            if(contentVersion.Tipo__c == 'Plano_PDF' || contentVersion.Tipo__c == 'Memoria_calidades' && contentVersion.VersionNumber == '1')
                contentVersionFilteredList.add(contentVersion);
        }
        
        if(!contentVersionFilteredList.isEmpty()){
            List<Id> parentIdList = new List<Id>();
            for(ContentVersion contentVersionFiltered : contentVersionFilteredList){
                if(contentVersionFiltered.ParentId__c != null && !parentIdList.contains(contentVersionFiltered.ParentId__c))
                    parentIdList.add(contentVersionFiltered.ParentId__c);
            }
            
            if(!parentIdList.isEmpty()){
                List<Opportunity> opportunityList = [SELECT Id, Promocion__c FROM Opportunity WHERE Promocion__c IN: parentIdList];
                List<ContentDocumentLink> contentDocumentLinkToInsert = new List<ContentDocumentLink>();
                for(Opportunity opportunity : opportunityList){
                    for(ContentVersion contentVersionFiltered : contentVersionFilteredList){
                        if(opportunity.Promocion__c == contentVersionFiltered.ParentId__c){
                            ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
                            contentDocumentLink.LinkedEntityId = opportunity.Id;
                            contentDocumentLink.ContentDocumentId = contentVersionFiltered.ContentDocumentId;
                            contentDocumentLink.ShareType = 'I';
                            contentDocumentLinkToInsert.add(contentDocumentLink);
                        }
                    }
                }
                insert contentDocumentLinkToInsert;                
            }            
        }
    }
    
    /*public static Map<Id, Integer> getVersionNumber(List<ContentVersion> cvs) {
       	Map<Id, Integer> versions = new Map<Id, Integer>();
        Map<Id, Id> DVHtoCV = new Map<Id, Id>();
        for(ContentVersion cv : cvs) 
            if(cv.Document_Version_History__c != null) DVHtoCV.put(cv.Document_Version_History__c, cv.Id);
        
        for(AggregateResult r : [SELECT Id, MAX(VersionNumber__c) vn FROM DocumentVersionHistory__c WHERE Id IN :DVHtoCV.keySet() GROUP BY Id])
            versions.put( DVHtoCV.get((Id)r.get('Id')), r.get('vn') != null ? ((Decimal)r.get('vn')).intValue() +1 : 0 );
 		
        for(ContentVersion cv : cvs) 
            if(!versions.containsKey(cv.Id)) versions.put(cv.Id, 1);
        
        return versions;
    }*/
    
    public static Map<Id, Integer> getVersionNumber(List<ContentVersion> cvs) {
       	Map<Id, Integer> versions = new Map<Id, Integer>();
        Map<Id, List<ContentVersion>> DVHtoCV = new Map<Id, List<ContentVersion>>();
        for(ContentVersion cv : cvs) {
            if(!DVHtoCV.containsKey(cv.ContentDocumentId)) DVHtoCV.put(cv.ContentDocumentId, new List<ContentVersion>());
        	DVHtoCV.get(cv.ContentDocumentId).add(cv);
        }
        
        for(AggregateResult r : [SELECT ContentDocumentId, MAX(Document_Version_History__r.VersionNumber__c) vn FROM ContentVersion WHERE Document_Version_History__c != null GROUP BY ContentDocumentId]){
            if(DVHtoCV.containsKey((Id)r.get('ContentDocumentId'))){
                for(ContentVersion cv : DVHtoCV.get((Id)r.get('ContentDocumentId'))) {
                    versions.put(cv.Id, r.get('vn') != null ? ((Decimal)r.get('vn')).intValue() + 1 : 1 );
                }
            }
        }
        
        for(ContentVersion cv : cvs) 
            if(!versions.containsKey(cv.Id)) versions.put(cv.Id, 1);
        
        return versions;
    }
    
    @future
    public static void createDocumentVersionHistoryRecord(Set<Id> cvIds) {
        List<ContentVersion> cvs = [SELECT Id, Title, Tipo__c, VersionNumber, ParentId__c, Document_Version_History__c, ContentDocumentId FROM ContentVersion WHERE Id = :cvIds AND IsLatest = true];
        List<ContentVersion> contentVersionFilteredList = new List<ContentVersion>();
        List<Id> cdIds = new List<Id>();
        for(ContentVersion contentVersion : cvs){
            if(contentVersion.Tipo__c == 'Cuadro_superficies' || contentVersion.Tipo__c == 'Memoria_calidades'){
                contentVersionFilteredList.add(contentVersion);
                if(!cdIds.contains(contentVersion.ContentDocumentId)) cdIds.add(contentVersion.ContentDocumentId);
            }
        }
        if(!contentVersionFilteredList.isEmpty()){
            Map<Id, Id> cvToPromo = new Map<Id, Id>();
            Map<Id, Set<Id>> linkedEntities = new Map<Id, Set<Id>>();
            List<ContentDocumentLink> cdls = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId IN :cdIds];
            for(ContentDocumentLink cdl : cdls) {
                if(cdl.LinkedEntityId.getSObjectType() == Schema.Promocion__c.getsObjectType())
                    cvToPromo.put(cdl.ContentDocumentId, cdl.LinkedEntityId);

                if(cdl.LinkedEntityId.getSObjectType() == Schema.User.getsObjectType()) {
                    if(!linkedEntities.containsKey(cdl.ContentDocumentId)) linkedEntities.put(cdl.ContentDocumentId, new Set<Id>());
                    linkedEntities.get(cdl.ContentDocumentId).add(cdl.LinkedEntityId);
                }
            }
            
            Map<Id, Promocion__c> promos = new Map<Id, Promocion__c>([SELECT Id, Tecnico_Aprobador__c, Tecnico__c, Director_Promociones__c, Responsable_Comercial__c, Director_Comercial__c, Director_Negocio__c   
                                                                      FROM Promocion__c 
                                                                      WHERE Id IN :cvToPromo.values()]);
            Map<Id, DocumentVersionHistory__c> CVandDVHMap = new Map<Id, DocumentVersionHistory__c>();
            List<ContentDocumentLink> cdlToInsert = new List<ContentDocumentLink>();
            Map<Id, Integer> versions = getVersionNumber(contentVersionFilteredList);
            for(ContentVersion contentVersionFiltered : contentVersionFilteredList){
                DocumentVersionHistory__c documentVersionHistory = new DocumentVersionHistory__c();
                documentVersionHistory.Document_Version_History_Name__c = contentVersionFiltered.Title + ' - v' + versions.get(contentVersionFiltered.Id);
                documentVersionHistory.Tipo__c = contentVersionFiltered.Tipo__c;
                documentVersionHistory.Estado__c = 'Pendiente de Aprobación';
                documentVersionHistory.Promocion__c = cvToPromo.get(contentVersionFiltered.ContentDocumentId);
                documentVersionHistory.isNew__c = true;
                documentVersionHistory.VersionNumber__c = versions.get(contentVersionFiltered.Id);
                documentVersionHistory.Tecnico__c = Test.isRunningTest() ? UserInfo.getUserId() : promos.get(documentVersionHistory.Promocion__c).Tecnico_Aprobador__c; 
                documentVersionHistory.Responsable_Comercial__c = Test.isRunningTest() ? UserInfo.getUserId() : promos.get(documentVersionHistory.Promocion__c).Responsable_Comercial__c;
                if(Test.isRunningTest() || !String.isBlank(promos.get(documentVersionHistory.Promocion__c).Tecnico__c) ){
                    documentVersionHistory.Director_Tecnico__c = Test.isRunningTest() ? UserInfo.getUserId() : promos.get(documentVersionHistory.Promocion__c).Tecnico__c;
                }else{
                    documentVersionHistory.Director_Tecnico__c = '';
                }
                documentVersionHistory.Director_Promociones__c = Test.isRunningTest() ? UserInfo.getUserId() : promos.get(documentVersionHistory.Promocion__c).Director_Promociones__c;
                documentVersionHistory.Director_de_Negocio__c = Test.isRunningTest() ? UserInfo.getUserId() : promos.get(documentVersionHistory.Promocion__c).Director_Negocio__c;
                documentVersionHistory.Director_Comercial__c = Test.isRunningTest() ? UserInfo.getUserId() : promos.get(documentVersionHistory.Promocion__c).Director_Comercial__c;
                CVandDVHMap.put(contentVersionFiltered.Id, documentVersionHistory);
                
                 if(versions.get(contentVersionFiltered.Id) == 1){
                    Map<Id, ContentDocumentLink> toAdd = new Map<Id, ContentDocumentLink>();
                    if(!String.isBlank(documentVersionHistory.Director_Tecnico__c) && !linkedEntities.get(contentVersionFiltered.ContentDocumentId).contains(documentVersionHistory.Tecnico__c)){
                        ContentDocumentLink cdlTecnico = new ContentDocumentLink(LinkedEntityId = documentVersionHistory.Tecnico__c, ContentDocumentId = contentVersionFiltered.ContentDocumentId, ShareType = 'C');
                        if(!toAdd.containsKey(cdlTecnico.LinkedEntityId)) toAdd.put(cdlTecnico.LinkedEntityId, cdlTecnico);
                    }
                    if(!linkedEntities.get(contentVersionFiltered.ContentDocumentId).contains(documentVersionHistory.Responsable_Comercial__c)){
                        ContentDocumentLink cdlRespComercial = new ContentDocumentLink(LinkedEntityId = documentVersionHistory.Responsable_Comercial__c, ContentDocumentId = contentVersionFiltered.ContentDocumentId, ShareType = 'C');
                       	if(!toAdd.containsKey(cdlRespComercial.LinkedEntityId)) toAdd.put(cdlRespComercial.LinkedEntityId, cdlRespComercial);
                    }
                    if(!String.isBlank(documentVersionHistory.Director_Tecnico__c) && !linkedEntities.get(contentVersionFiltered.ContentDocumentId).contains(documentVersionHistory.Director_Tecnico__c)){
                        ContentDocumentLink cdlDirectorTecnico = new ContentDocumentLink(LinkedEntityId = documentVersionHistory.Director_Tecnico__c, ContentDocumentId = contentVersionFiltered.ContentDocumentId, ShareType = 'C');
                        if(!toAdd.containsKey(cdlDirectorTecnico.LinkedEntityId)) toAdd.put(cdlDirectorTecnico.LinkedEntityId, cdlDirectorTecnico);
                    }
                    if(!linkedEntities.get(contentVersionFiltered.ContentDocumentId).contains(documentVersionHistory.Director_Promociones__c)){
                        ContentDocumentLink cdlDirectorPromociones = new ContentDocumentLink(LinkedEntityId = documentVersionHistory.Director_Promociones__c, ContentDocumentId = contentVersionFiltered.ContentDocumentId, ShareType = 'C');
                        if(!toAdd.containsKey(cdlDirectorPromociones.LinkedEntityId)) toAdd.put(cdlDirectorPromociones.LinkedEntityId, cdlDirectorPromociones);
                    }
                    if(!linkedEntities.get(contentVersionFiltered.ContentDocumentId).contains(documentVersionHistory.Director_Comercial__c)){
                        ContentDocumentLink cdlDirectorComercial = new ContentDocumentLink(LinkedEntityId = documentVersionHistory.Director_Comercial__c, ContentDocumentId = contentVersionFiltered.ContentDocumentId, ShareType = 'C');
                        if(!toAdd.containsKey(cdlDirectorComercial.LinkedEntityId)) toAdd.put(cdlDirectorComercial.LinkedEntityId, cdlDirectorComercial);
                    }
                    cdlToInsert.addAll(toAdd.values());
                }
            }
            if(!CVandDVHMap.isEmpty()) insert CVandDVHMap.values();
            if(!cdlToInsert.isEmpty()) insert cdlToInsert;
            
            Map<Id, Cuadro_Superficies__c> cuadroSuperficiesToInsert = new Map<Id, Cuadro_Superficies__c>();
            for(ContentVersion contentVersionFiltered : contentVersionFilteredList){
            	if(contentVersionFiltered.Tipo__c == 'Cuadro_superficies'){
                    Cuadro_Superficies__c cuadroSuperficies = new Cuadro_Superficies__c();
                    cuadroSuperficies.Promocion__c = cvToPromo.get(contentVersionFiltered.ContentDocumentId);
                    cuadroSuperficies.Cuadro_Superficies_Name__c = CVandDVHMap.get(contentVersionFiltered.Id).Document_Version_History_Name__c;
                    cuadroSuperficies.Document_Version_History__c = CVandDVHMap.get(contentVersionFiltered.Id).Id;
                    cuadroSuperficiesToInsert.put(contentVersionFiltered.Id, cuadroSuperficies);
                }
            }
            if(!cuadroSuperficiesToInsert.isEmpty()) insert cuadroSuperficiesToInsert.values();
            
            List<DocumentVersionHistory__c> DVHtoUpdate = new List<DocumentVersionHistory__c>();
            for(Id i : cuadroSuperficiesToInsert.keySet()) {
                CVandDVHMap.get(i).Cuadro_Superficies__c = cuadroSuperficiesToInsert.get(i).Id;
                DVHtoUpdate.add(CVandDVHMap.get(i));
            }
            if(!DVHtoUpdate.isEmpty()) update DVHtoUpdate;
            
            for(ContentVersion contentVersion : contentVersionFilteredList){
                contentVersion.Document_Version_History__c = CVandDVHMap.get(contentVersion.Id).Id; 
                contentVersion.Activo__c = false;          
            } 
            if(!contentVersionFilteredList.isEmpty()) update contentVersionFilteredList;
            
            List<ContentVersion> otherCVs = [SELECT Id, Title, ContentDocumentId, Tipo__c, Activo__c, PathOnClient, VersionData FROM ContentVersion WHERE ContentDocumentId = :cdIds AND Activo__c = true ORDER BY CreatedDate DESC LIMIT 1];
            List<ContentVersion> toCreate = new List<ContentVersion>();
            for(ContentVersion cv : otherCVs){ 
                ContentVersion ncv = new ContentVersion();
                ncv.title = cv.title;
                ncv.ContentDocumentId = cv.ContentDocumentId;
                ncv.Tipo__c = cv.Tipo__c;
                ncv.Activo__c = cv.Activo__c;
                ncv.PathOnClient = cv.PathOnClient;
                ncv.Document_Version_History__c = null;
                
                if(Test.isRunningTest()) ncv.VersionData = blob.valueOf('Unit.Test');
                else ncv.VersionData = cv.VersionData;
                
                toCreate.add(ncv);
            }
            if(!toCreate.isEmpty()) insert toCreate; 
        }
    }
}