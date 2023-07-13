public with sharing class PantallaSubidaFicherosController {
 
    //Obtener valores de picklist del campo tipo
    @AuraEnabled
     public static List <String> getselectOptions(sObject objObject, string fld) {
         
      system.debug('objObject --->' + objObject);
      system.debug('fld --->' + fld);
         
      List <String> allOpts = new list <String>();
         
      //Obtener el tipo del objeto
      Schema.sObjectType objType = objObject.getSObjectType();
     
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
     
      // Get a map of fields for the SObject
      map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
     
      // Get the list of picklist values for this field.
      list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
     
      // Add these values to the selectoption list.
      for (Schema.PicklistEntry a: values) {
          
       allOpts.add(a.getValue());
      }
      system.debug('allOpts ---->' + allOpts);
         
      allOpts.sort();
         
      return allOpts;
     }
 
    //-----------------------------------------------------------------------------------------------------------------------
    
 	@AuraEnabled
    public static Id guardarArchivo(Id parentId, String nombreArchivo, String base64Data, String contentType, 
                                    String tipo, Integer posicion, String descripcion, List<DocumentCategoryOptWrapper> categories, String fileId,
                                    Boolean completed) {
        // Obtenemos el nº de documento
        String docNum = SharePointConnector.getNewDocumentNumber();
        if(fileId == '') {            
            nombreArchivo = docNum + '-' + nombreArchivo;

            // SalesForce
    	    fileId = guardarArchivoSalesForce(parentId, nombreArchivo, base64Data, contentType, tipo, posicion, descripcion);

            // Actualizamos el contador de documentos
            if(fileId != null) SharePointConnector.commitDocumentNumber();
        } else {
            Integer intDocNum = Integer.valueOf(docNum);
            docNum = String.valueOf(intDocNum).leftPad(3, '0');
            nombreArchivo = docNum + '-' + nombreArchivo;
            ContentVersion file = anadirAArchivoSalesForce(fileId, base64Data, completed);
            if(completed && file != null) {
                // SharePoint
                guardarArchivoSharePoint(parentId, nombreArchivo, EncodingUtil.urlEncode(EncodingUtil.base64Encode(file.VersionData), 'UTF-8'), 
                                            contentType, tipo, descripcion, categories);
            }
        }
        
        return fileId;
    }
    
    public static Id guardarArchivoSalesForce(Id parentId, String nombreArchivo, String base64Data, String contentType, 
                                    String tipo, Integer posicion, String descripcion) {
        
    	base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        ContentVersion cv = new ContentVersion();
        //cv.parentId = promocionId;
 		cv.tipo__c = tipo;
        cv.versionData = EncodingUtil.base64Decode(base64Data);
        cv.Title = nombreArchivo;
        cv.PathOnClient = nombreArchivo;
        cv.Posicion__c = posicion;
        cv.parentId__c = parentId;
        cv.Description = descripcion;
        cv.IsMajorVersion = false;                
        //cv.ContentType = contentType;
        insert cv;
        
        ContentVersion cv2 = [SELECT id, ContentDocumentId FROM ContentVersion WHERE id =: cv.id LIMIT 1];
        
        //Crear ContentDocumentLink
        ContentDocumentLink cdl = new ContentDocumentLink();
        
        cdl.LinkedEntityId = parentId;
        cdl.ContentDocumentId =  cv2.ContentDocumentId;
        cdl.ShareType = 'V';
        insert cdl;
        
        return cv.id;                    
    }
 
    private static ContentVersion anadirAArchivoSalesForce(Id fileId, String base64Data, Boolean completed) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion cv = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :fileId];
        if(base64Data != '') {
            String existingBody = EncodingUtil.base64Encode(cv.VersionData);
            cv.VersionData = EncodingUtil.base64Decode(existingBody + base64Data);
            //if(completed) cv.IsMajorVersion = true;
            update cv;
        }
        return completed ? cv : null;
    }
    
    public static void guardarArchivoSharePoint(Id parentId, String nombreArchivo, String base64Data, String contentType, 
                                    String tipo, String descripcion, List<DocumentCategoryOptWrapper> categories) {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        String parentDir = spCustomSettings.spParentDir__c;
        String baseDirPath = spCustomSettings.spSiteUrl__c.replace(spCustomSettings.spSiteDomain__c, '');

        // Obtención de la promoción
        String promotionQuery = SharePointConnectorMappings.getPromotionQueryByType(parentId.getSObjectType()).replace('$value$', ':parentId');
        System.debug('query promotion: ' + promotionQuery + parentId);
        Promocion__c promotion = Database.query(promotionQuery);

        // Metadatos
        Map<String, String> metaDataMap = new Map<String, String>();        
        metaDataMap.put(SharePointConnectorMappings.getParentMetadataFieldByType(parentId.getSObjectType()), parentId);
        metaDataMap.put('TipoDocumento', tipo);
        Integer i = 1;
        for(DocumentCategoryOptWrapper cat : categories) {
            if(cat.value != '') metaDataMap.put('Categoria' + i, cat.text);
            i++;
        }
        metaDataMap.put('IdUsuario', UserInfo.getUserId());
        metaDataMap.put('Usuario', UserInfo.getUserEmail());
        if(parentId.getSObjectType() + '' != 'Promocion__c') {
            metaDataMap.put(SharePointConnectorMappings.getParentMetadataFieldByType(promotion.Id.getSObjectType()), promotion.Id);
            if(parentId.getSObjectType() + '' == 'Opportunity') {
                Opportunity opp = [SELECT AccountId FROM Opportunity WHERE Id = :parentId];
                metaDataMap.put('IdCuenta', opp.AccountId); 
            }
        }

        // Categorización
		DocumentCategory__c customDocCategory = null;
        String dirPath = baseDirPath+parentDir+'/' + promotion.Name;
        if(categories.size() > 0) {
        	customDocCategory = [SELECT ParentDirectoryName__c FROM DocumentCategory__c WHERE Id = :categories.get(0).value];                                
            dirPath += '/' + customDocCategory.ParentDirectoryName__c;
        }
   
        if(!Test.isRunningTest()) {
            // Subida Sharepoint
            SharePointConnector spConnector = new SharePointConnector(nombreArchivo, dirPath, metaDataMap);
            spConnector.login();
            spConnector.createFile(EncodingUtil.urlDecode(base64Data, 'UTF-8'));
            spConnector.updateFileMetaData();
        }
    }
    
    //Obtener picklist dependiente

    @AuraEnabled
    public static List<DocumentCategoryWrapper> getCategoryFields() {
        List<AggregateResult> res = [SELECT COUNT_DISTINCT(Level__c) levels FROM DocumentCategory__c];
        Integer levels = (Integer) res.get(0).get('levels');
        List<DocumentCategoryWrapper> wrapperList = new List<DocumentCategoryWrapper>();
        
        for(Integer i = 1; i <= levels; i++) {
            DocumentCategoryWrapper wrapper = new DocumentCategoryWrapper();
            wrapper.level = i;
            wrapper.disabled = i == 1 ? false : true;
            wrapper.label = 'Categoría nivel ' + i;

            List<DocumentCategoryOptWrapper> opts = new List<DocumentCategoryOptWrapper>();
            if(i == 1) {                
                List<DocumentCategory__c> cats = [SELECT Code__c, Level__c, Name, ParentDirectoryName__c 
                                                   FROM DocumentCategory__c 
                                                  WHERE Level__c = :i];
                for(DocumentCategory__c cat : cats) {
                    DocumentCategoryOptWrapper opt = new DocumentCategoryOptWrapper();
                    opt.folderName = cat.ParentDirectoryName__c;
                    opt.level = cat.Level__c.intValue();
                    opt.docCode = cat.Code__c;
                    opt.value = cat.Id;
                    opt.text = cat.Name;
                    opt.text = cat.Name;
                    opt.value = cat.Id;
                    opts.add(opt);
                }
                wrapper.options = opts.clone();
            }

            wrapperList.add(wrapper);
        }
        
        System.debug('WrapperList:' + wrapperList);

        return wrapperList;
    }

    @AuraEnabled
    public static List<DocumentCategoryOptWrapper> getDependentOptsByParentCat(Id parentCategoryId) {
        List<DocumentCategoryOptWrapper> opts = new List<DocumentCategoryOptWrapper>();
        List<DocumentCategory__c> categories = [SELECT Code__c,Level__c, Name,ParentDirectoryName__c 
                                                 FROM DocumentCategory__c 
                                                WHERE ParentDocumentCategory__c = :parentCategoryId];
        
        for(DocumentCategory__c c : categories) {
            DocumentCategoryOptWrapper opt = new DocumentCategoryOptWrapper();
            if(c.Level__c == 1) opt.folderName = c.ParentDirectoryName__c;
            opt.level = c.Level__c.intValue();
            opt.docCode = c.Code__c;
            opt.value = c.Id;
            opt.text = c.Name;
            System.debug('opt: ' + opt);
			opts.add(opt);            
        }
        return opts;
    }

    public class DocumentCategoryWrapper {
        @AuraEnabled public Integer level { get; set; }
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }
        @AuraEnabled public Boolean disabled { get; set; }
        @AuraEnabled public List<DocumentCategoryOptWrapper> options { get; set; }
    }

    public class DocumentCategoryOptWrapper {
        @AuraEnabled public Integer level { get; set; }
        @AuraEnabled public String numDoc { get; set; }
        @AuraEnabled public String docCode { get; set; }
        @AuraEnabled public String folderName { get; set; }
        @AuraEnabled public String text { get; set; }
        @AuraEnabled public String value { get; set; }
    }

}