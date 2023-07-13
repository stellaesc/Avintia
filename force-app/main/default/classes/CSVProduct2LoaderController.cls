public class CSVProduct2LoaderController {
    
    @AuraEnabled
    public static Boolean getProfileInfo(Id recordId){
        Promocion__c prm = [SELECT Id, Comercial__c FROM Promocion__c WHERE Id = :recordId];
        Profile prof = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        if(prof.Name == 'System Administrator' || prof.Name == 'Administrador del sistema') return true;
        if(prm.Comercial__c == UserInfo.getUserId()) return true;
        return false;
    }
    
    @AuraEnabled
    public static List<DocumentInfo> fileProcessing(Id recordId, List<DocumentInfo> cdocs) {
        Map<Id, DocumentInfo> cdocsMap = new Map<Id, DocumentInfo>();
        for(DocumentInfo di : cdocs){
            if(di.documentId != null) cdocsMap.put(di.documentId, di);
        }
        
        List<ContentVersion> cvs = [SELECT Id, VersionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :cdocsMap.keySet() AND IsLatest = true];
        
        for(ContentVersion cv : cvs)
            cdocsMap.get(cv.ContentDocumentId).ps = loadCSVFile(recordId, cv.VersionData.toString());
        
        return cdocsMap.values();
    }
    
    @AuraEnabled
    public static List<DocumentInfo> saveFile(Id recordId, List<DocumentInfo> cdocs) {
        Map<Id, DocumentInfo> cdocsMap = new Map<Id, DocumentInfo>();
        for(DocumentInfo di : cdocs){
            if(di.documentId != null) cdocsMap.put(di.documentId, di);
        }
        
        List<ContentVersion> cvs = [SELECT Id, VersionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :cdocsMap.keySet() AND IsLatest = true];
        for(ContentVersion cv : cvs)
            cdocsMap.get(cv.ContentDocumentId).ps = saveCSVFile(recordId, cv.VersionData.toString());
        
        return cdocsMap.values();
    }
    
    @AuraEnabled
    public static void deleteFile(List<DocumentInfo> cdocs) {
        List<ContentDocument> toDelete = new List<ContentDocument>();
        for(DocumentInfo cdoc : cdocs) {
            if(cdoc.documentId != null) toDelete.add(new ContentDocument(Id = cdoc.documentId));
        }
        if(!toDelete.isEmpty()) delete toDelete;
    }
    
    @AuraEnabled
    public static List<Product2> getProducts(Id recordId) {
   		return [SELECT Id, Name, Precio_Comercial__c, Precio_propuesto__c FROM Product2 WHERE Promocion__c = :recordId];
    }
    
    public static List<Product> loadCSVFile(Id recordId, String content){
        System.debug('CSV Load Start');
        List<Product> ps = new List<Product>();
        Map<Id, sObject> objs = new Map<Id, sObject>();
        try {
            List<String> csvLines = content.split('\n');
            try {
                for(Integer i = 1; i < csvLines.size(); i++) {
                    List<string> csvLineContent = csvLines[i].replaceAll('\"','').split(';');
                    if(csvLineContent.size() > 4) throw new System.ListException();
                    
                    sObject obj = Schema.getGlobalDescribe().get('Product2').newSObject();
                    obj.put('Id', ((String)csvLineContent.get(0)).trim());
                    try { 
                        obj.put('Precio_propuesto__c', String.isNotBlank(csvLineContent.get(2)) ? Decimal.valueOf(csvLineContent.get(2).trim()) : null);
                    } catch (ListException ex1) {
                        obj.put('Precio_propuesto__c', null);
                    }                   
                    objs.put(obj.Id, obj);  
                } 	
            } catch (ListException ex2) {
                return returnException('ListException', 'Incorrectly formatted CSV file.', '');
            }
            
           	List<Product2> prds = [SELECT Id, Name, Oportunidad__c, Oportunidad__r.StageName, Precio_Comercial__c, Precio_propuesto__c FROM Product2 WHERE Id IN :objs.keyset() AND Promocion__c = :recordId];
          	
            if(prds.size() != objs.values().size()) return returnException('SObjectException', 'Existen Ids mal formadas, vacias o Ids procedentes de diferentes promociones.', '');
            if(prds.isEmpty()) return returnException('SObjectException', 'No hay inmuebles con esos Ids en la promoción.', '');
                       
            for(Product2 prd : prds) {
                Product p = new Product();
                p.prdId = prd.Id;
                p.name = prd.Name;
                p.precio = String.valueOf(objs.get(prd.Id).get('Precio_propuesto__c'));
                p.precio_actual = prd.Precio_Comercial__c != null ? String.valueOf(prd.Precio_Comercial__c) : '';
                p.precio_prop_actual = prd.Precio_propuesto__c != null ? String.valueOf(prd.Precio_propuesto__c) : '';
                    
                if(prd.Oportunidad__c != null) {
                    p.opp = prd.Oportunidad__c;
                    p.stage = prd.Oportunidad__r.StageName;
                    
                    if(prd.Oportunidad__r.StageName != 'Cancelada') p.bad = true;
                    else p.bad = false;                    
                } else {
                    p.opp = '';
                    p.stage = '';
                    p.bad = false;
                }
                
                ps.add(p);
            }
        } catch (QueryException ex3) {
            return returnException('QueryException', 'Error leyendo los Ids del documento CSV.', '');
        }  catch(Exception e) {
            return returnException('Exception', 'Error leyendo el documento CSV.', '');
        }
        return ps;
    }
    
    public static List<Product> saveCSVFile(Id recordId, String content){
        System.debug('CSV Save Start');
        List<Product> ps = new List<Product>();
        Map<Id, sObject> objs = new Map<Id, sObject>();
        try {
            List<String> csvLines = content.split('\n');
            try {
                for(Integer i = 1; i < csvLines.size(); i++) {
                    List<string> csvLineContent = csvLines[i].replaceAll('\"','').split(';');
                    if(csvLineContent.size() > 4) throw new System.ListException();
                    
                    sObject obj = Schema.getGlobalDescribe().get('Product2').newSObject();
                    obj.put('Id', csvLineContent.get(0).trim());
                    try { 
                        obj.put('Precio_propuesto__c', String.isNotBlank(csvLineContent.get(2)) ? Decimal.valueOf(csvLineContent.get(2).trim()) : null);
                    } catch (ListException ex1) {
                        obj.put('Precio_propuesto__c', null);
                    }                   
                    objs.put(obj.Id, obj);  
                } 	
            } catch (ListException ex2) {
                return returnException('ListException', 'Incorrectly formatted CSV file.', '');
            }
            
            Promocion__c prm = [SELECT Id, Aprobar_tarifario__c, Pendiente_de_aprobacion_de_tarifario__c FROM Promocion__c WHERE Id = :recordId];
            if(prm.Aprobar_tarifario__c || prm.Pendiente_de_aprobacion_de_tarifario__c)
                return returnException(prm.Id, 'Ya existe una aprobación de tarifario activa para esta promoción.', '');
            
           	List<Product2> prds = [SELECT Id, Name, Oportunidad__c, Oportunidad__r.StageName, Precio_Comercial__c, Precio_propuesto__c FROM Product2 WHERE Id IN :objs.keyset() AND Promocion__c = :recordId];
            
            if(prds.size() != objs.values().size()) return returnException('SObjectException', 'Existen Ids mal formadas, vacias o Ids procedentes de diferentes promociones.', '');
            if(prds.isEmpty()) return returnException('SObjectException', 'No hay inmuebles con esos Ids en la promoción.', '');
            
            for(Product2 prd : prds) {
                if( prd.Oportunidad__c == null || (prd.Oportunidad__c != null && prd.Oportunidad__r.StageName == 'Cancelada') )
                	prd.Precio_propuesto__c = (Decimal)objs.get(prd.Id).get('Precio_propuesto__c');
                else return returnException(prd.Id, 'Uno o más productos están asignados a una oportunidad abierta.', '');  
            }
            
            Savepoint sp = Database.setSavepoint();
            List<Database.SaveResult> srs = Database.update(prds);
            for(Database.SaveResult sr : srs) {
                Product p = new Product();
                p.prdId = sr.getId();
                if (sr.isSuccess()) {
                    p.name = 'Succesfully updated.';
                    p.precio = '';
                    p.precio_actual = '';
                    p.precio_prop_actual = '';
                    p.opp = '';
                    p.stage = '';
                    p.bad = false;
                	ps.add(p);
                } else {       
                    Database.Error err = sr.getErrors().get(0);
                    Database.rollback(sp);
                   	return returnException('Failed to save CSV file, product prices have not been updated.', err.getMessage(), '');
                }
            }
            
            if(!prm.Aprobar_tarifario__c && !prm.Pendiente_de_aprobacion_de_tarifario__c) {
                try{
                    Map<String, Object> params = new Map<String, Object>();
                    params.put('recordId', prm.Id);
                    Flow.Interview.Proceso_de_aprobacion_de_tarifario_automatica fc = new Flow.Interview.Proceso_de_aprobacion_de_tarifario_automatica(params);
                    fc.start();
                 } catch(Exception e) {
                    Database.rollback(sp);
                    return returnException('FlowException', 'Error al iniciar el proceso de aprobación del tarifario.', '');
                 }
            } else Database.rollback(sp);
        } catch (QueryException ex3) {
            return returnException('SObjectException', 'Error leyendo los Ids del documento CSV.', '');
        } catch(Exception e) {
            return returnException('SObjectException', 'Error guardando el documento CSV.', '');
        }
        return ps;
    }
    
    public static List<Product> returnException(String e1, String e2, String e3) {
       	Product p = new Product();
        p.prdId = e1;
        p.name = e2;
        p.precio = e3;
        p.precio_actual = '';
        p.precio_prop_actual = '';
        p.opp = '';
        p.stage = '';
        p.bad = true;
        return new List<Product>{p};
    }
    
    public class Product {
        @AuraEnabled public String prdId;
        @AuraEnabled public String name;
        @AuraEnabled public String precio;
        @AuraEnabled public String precio_actual;
        @AuraEnabled public String precio_prop_actual;
        @AuraEnabled public String opp;
        @AuraEnabled public String stage;
        @AuraEnabled public Boolean bad;
    }
    
    public class DocumentInfo {
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String documentId {get;set;}
        @AuraEnabled public List<Product> ps {get;set;}
    }
}