public class BotonAdendaController {

     @auraEnabled
     public static String getUrl(){
        String dominio = System.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/'; 
        //String dominio = System.URL.getSalesforceBaseUrl().toExternalForm();
        return (dominio);
    }

    /* @auraEnabled
     public static String getCongaURL(String RecordId){ 
         
        APXTConga4__Conga_Solution__c CongaSol = [SELECT Id, APXTConga4__Button_body_field__c FROM APXTConga4__Conga_Solution__c WHERE Name = 'DocumentoAdendaSolution' LIMIT 1];
         
        String dominio = CongaSol.APXTConga4__Button_body_field__c;
        dominio = dominio.replace('{!Plan_de_pagos__c.Id}', RecordId);
        
         return dominio;
    }*/
    
    @auraEnabled
    public static Boolean generarContrato(Id oportunidadId, String estado, String plantilla, String nombreFichero){
    
    	List<ContentDocumentLink> listaDocumentos = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: oportunidadId];
        
        Set<id> setIdDocumentos = new Set<id>();
        system.debug('1');
       
        
        for(integer i = 0; i < listaDocumentos.size(); i++){
            
            setIdDocumentos.add(listaDocumentos[i].ContentDocumentId);
        }
        
         List<ContentVersion> listaContenidoDocumentos = [SELECT id FROM ContentVersion WHERE ContentDocumentId IN : setIdDocumentos];
         system.debug('2');

        
            
            guardarPresupuesto(oportunidadId, estado, plantilla, nombreFichero);
            
            return true;
    
    }
    
    public static void guardarPresupuesto(Id oportunidadId, String estado, String plantilla, String nombreFichero){
        PageReference pdfPage;
        if(estado =='Contrato'){ 
            pdfPage = new PageReference('/apex/'+plantilla);
            pdfPage.getParameters().put('Id', oportunidadId);
            system.debug(oportunidadId); 
        }
        if(estado =='Plan de pagos'){ 
            
            Plan_de_pagos__c planPagos = [SELECT Id, Oportunidad__c FROM Plan_de_pagos__c WHERE Oportunidad__c =: oportunidadId AND Estado__c = 'Activo'];
            
            pdfPage = new PageReference('/apex/'+plantilla);
            system.debug('pdfPage 1:::'+pdfPage);
            pdfPage.getParameters().put('Id', planPagos.Id);
            system.debug(planPagos.Id); 
        }
        guardarPresupuestoSharePoint(pdfPage, oportunidadId, nombreFichero);
        guardarPresupuestoSF(pdfPage, oportunidadId, estado, nombreFichero);
    }

    private static void guardarPresupuestoSF(PageReference pdfPage, Id oportunidadId, String estado, String nombreFichero) {
        ContentVersion cv = new ContentVersion();
        if(estado == 'Contrato') cv.title = nombreFichero + ' ' + oportunidadId;
        cv.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()) cv.VersionData = blob.valueOf('Unit.Test');
        else cv.VersionData = pdfPage.getContentAsPdf();
        insert cv;
        
        ContentVersion cv2 = [SELECT ContentDocumentId, Title, VersionData FROM ContentVersion WHERE id = :cv.id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cv2.ContentDocumentId;
        cdl.LinkedEntityId = oportunidadId;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
    }

    private static void guardarPresupuestoSharePoint(PageReference pdfPage, Id oportunidadId, String nombreFichero) {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        String parentDir = spCustomSettings.spParentDir__c;
        String baseDirPath = spCustomSettings.spSiteUrl__c.replace(spCustomSettings.spSiteDomain__c, '');

        // Datos fichero
        String fileNameKey = nombreFichero;
        nombreFichero += ' ' + oportunidadId;

        // Obtenemos las categorías para ese tipo de archivo    
        List<String> fileCats = SharePointConnectorMappings.getCatsByFileType(fileNameKey);
        if(fileCats == null) fileCats = new List<String>();

        // Obtenemos los datos de la oportunidad
        Opportunity opp = [SELECT AccountId FROM Opportunity WHERE Id = :oportunidadId];
        
        // Obtenemos la promoción mediante la oportunidad
        String promotionQuery = SharePointConnectorMappings.getPromotionQueryByType(oportunidadId.getSObjectType()).replace('$value$', ':oportunidadId');
        Promocion__c promotion = Database.query(promotionQuery);

        // Preparamos subida a Sharepoint:
        Map<String, String> metaDataMap = new Map<String, String>();
        metaDataMap.put('IdPromocion', promotion.Id);
        metaDataMap.put('IdOportunidad', oportunidadId);
        metaDataMap.put('TipoDocumento', 'Contrato'); // FIXME -> SEGURAMENTE TAMBIÉN CON MAPEO
        metaDataMap.put('IdCuenta', opp.AccountId);
        Integer i = 1;
        for(String cat : fileCats) {
            metaDataMap.put('Categoria' + i, cat);
            i++;
        }
        metaDataMap.put('IdUsuario', UserInfo.getUserId());
        metaDataMap.put('Usuario', UserInfo.getUserEmail());

        DocumentCategory__c customDocCategory = null;
        String dirPath = baseDirPath + parentDir + '/' + promotion.Name;
        if(fileCats.size() > 0) {
        	customDocCategory = [SELECT ParentDirectoryName__c FROM DocumentCategory__c WHERE Name = :fileCats.get(0)];                                
            dirPath += '/' + customDocCategory.ParentDirectoryName__c;
        }

        nombreFichero = SharePointConnectorMappings.getNameByCats(fileCats);
        if(!Test.isRunningTest()) {
            SharePointConnector spConnector = new SharePointConnector(nombreFichero + '.pdf', dirPath, metaDataMap);
            spConnector.login();
            spConnector.createFile(EncodingUtil.base64Encode(pdfPage.getContentAsPdf()));
            spConnector.updateFileMetaData();
        }
        SharePointConnector.commitDocumentNumber();
    }

}