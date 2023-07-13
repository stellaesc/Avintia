public class BotonPreReserva_Controller {
    
    @AuraEnabled
    public static String getTipoInmueble(Id quoteId){
    	List<QuoteLineItem> productoPresupuestoList = [SELECT Id, QuoteId, Product2.Tipo_de_vivienda__c, Product2.Tipo_de_inmueble__r.Tipo__c 
                                                   			FROM QuoteLineItem 
                                                   			WHERE QuoteId =: quoteId]; 
        
        List<String> tipoInmuebleList = new List<String>();
        for(QuoteLineItem productoPresupuesto : productoPresupuestoList){
            tipoInmuebleList.add(productoPresupuesto.Product2.Tipo_de_inmueble__r.Tipo__c);
        }
        system.debug('tipoInmuebleList:::'+tipoInmuebleList);
        
        if(!tipoInmuebleList.isEmpty()){
            if(tipoInmuebleList.contains('Vivienda')){
                String tipoInmueble = 'Vivienda';
                system.debug('tipoInmueble es:::'+ tipoInmueble);
                return tipoInmueble;
            }else if(tipoInmuebleList.contains('Local')){
                String tipoInmueble = 'Local';
                system.debug('tipoInmueble es:::'+ tipoInmueble);
                return tipoInmueble;
            }else if(tipoInmuebleList.contains('Trastero') && !tipoInmuebleList.contains('Trastero')){
                String tipoInmueble = 'Trastero';
                system.debug('tipoInmueble es:::'+ tipoInmueble);
                return tipoInmueble;                
            }else if(tipoInmuebleList.contains('Garaje') && !tipoInmuebleList.contains('Garaje')){
                String tipoInmueble = 'Garaje';
                system.debug('tipoInmueble es:::'+ tipoInmueble);
                return tipoInmueble ;                
            }
    
        } 
        return null;
    }
    
    @AuraEnabled
    public static String getUrl(){
        String dominio = System.URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        return (dominio);
    }
    
    @auraEnabled
     public static String getCongaTemplateId(){
        APXTConga4__Conga_Template__c CongaTemplateId = [SELECT Id FROM APXTConga4__Conga_Template__c WHERE APXTConga4__Name__c = 'FichaFormaPagoTemplate'];
        return (CongaTemplateId.Id);
    }   
    

    @AuraEnabled
    public static Boolean generarContrato(Id quoteId, String estado){
    	List<ContentDocumentLink> listaDocumentos = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: quoteId];
        
        Set<id> setIdDocumentos = new Set<id>();
        system.debug('1');
       
        for(integer i = 0; i < listaDocumentos.size(); i++) {
            setIdDocumentos.add(listaDocumentos[i].ContentDocumentId);
        }
        
        List<ContentVersion> listaContenidoDocumentos = [SELECT id FROM ContentVersion WHERE ContentDocumentId IN : setIdDocumentos];
        system.debug('2');

        
        guardarPresupuestoSharepoint(quoteId);
        guardarPresupuesto(quoteId, estado);
            
        return true;
    }
    
    public static void guardarPresupuesto(Id quoteId, String estado){
         
        PageReference pdfPage;
        pdfPage = new PageReference('/apex/VF_Ficha_Forma_pago');
         
        pdfPage.getParameters().put('Id', quoteId);
        system.debug(quoteId);
        
        Id oppId = [SELECT OpportunityId FROM Quote WHERE Id = :quoteId].OpportunityId;

        ContentVersion cv = new ContentVersion();
		cv.title = 'FichaPreReserva ' + quoteId;
         
        cv.PathOnClient = 'file.pdf';
        system.debug('llega aqui');
            if(Test.isRunningTest()){
                
                 cv.VersionData = blob.valueOf('Unit.Test');
            }
            else{
                 system.debug('antes de la llamada');
                 cv.VersionData = pdfPage.getContentAsPdf();
                 system.debug('despues');
            }
           
            
        
        insert cv;
        
        ContentVersion cv2 = [SELECT ContentDocumentId, Title, VersionData FROM ContentVersion WHERE id = :cv.id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cv2.ContentDocumentId;
            //cdl.LinkedEntityId = quoteId;
            cdl.LinkedEntityId = oppId;
            cdl.ShareType = 'V';
        

            cdl.Visibility = 'AllUsers';
        
        insert cdl; 
     }

    private static void guardarPresupuestoSharepoint(Id quoteId) {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        String parentDir = spCustomSettings.spParentDir__c;
        String baseDirPath = spCustomSettings.spSiteUrl__c.replace(spCustomSettings.spSiteDomain__c, '');

        String fileNameKey = 'FichaPreReserva';
        String fileName = fileNameKey + ' ' + quoteId;
        PageReference pdfPage;
        pdfPage = new PageReference('/apex/VF_Ficha_Forma_pago');         
        pdfPage.getParameters().put('Id', quoteId);

        // Obtenemos las categorías para ese tipo de archivo    
        List<String> fileCats = SharePointConnectorMappings.getCatsByFileType(fileNameKey);
        if(fileCats == null) fileCats = new List<String>();

        List<Quote> qs = [SELECT Opportunity.Promocion__c FROM Quote WHERE Id = :quoteId];
        if(qs.size() == 1) {
            Promocion__c promo = [SELECT Id,Name FROM Promocion__c WHERE Id = :qs.get(0).Opportunity.Promocion__c];

            // Preparamos subida a Sharepoint:
            Map<String, String> metaDataMap = new Map<String, String>();
            metaDataMap.put('IdPromocion', promo.Id);
            metaDataMap.put('TipoDocumento', 'Archivo'); // FIXME -> SEGURAMENTE TAMBIÉN CON MAPEO
            Integer i = 1;
            for(String cat : fileCats) {
                metaDataMap.put('Categoria' + i, cat);
                i++;
            }
            metaDataMap.put('IdUsuario', UserInfo.getUserId());
            metaDataMap.put('Usuario', UserInfo.getUserEmail());

            DocumentCategory__c customDocCategory = null;
            String dirPath = baseDirPath + parentDir + '/' + promo.Name;
            if(fileCats.size() > 0) {
                customDocCategory = [SELECT ParentDirectoryName__c FROM DocumentCategory__c WHERE Name = :fileCats.get(0)];                                
                dirPath += '/' + customDocCategory.ParentDirectoryName__c;
            }

            fileName = SharePointConnectorMappings.getNameByCats(fileCats);
            if(!Test.isRunningTest()) {
                SharePointConnector spConnector = new SharePointConnector(fileName + '.pdf', dirPath, metaDataMap);
                spConnector.login();
                spConnector.createFile(EncodingUtil.base64Encode(pdfPage.getContentAsPdf()));
                spConnector.updateFileMetaData();
            }
            fileName = SharePointConnectorMappings.getNameByCats(fileCats);
        }
    }

    
}