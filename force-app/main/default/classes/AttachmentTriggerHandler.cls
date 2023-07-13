public class AttachmentTriggerHandler extends TriggerHandler {

    protected override void afterInsert() {
    	Map<Id, Attachment> news = (Map<Id, Attachment>) Trigger.newMap;
        List<Attachment> attachs = news.values();
        Id ParentId;
        String sParentObject = '';
        String fileNameKey = '';
        String fileName = '';
        
        for(Attachment att : attachs){
            ParentId = att.ParentId;
            sParentObject = ParentId.getSObjectType().getDescribe().getName();
            
            SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
            String parentDir = spCustomSettings.spParentDir__c;
            String baseDirPath = spCustomSettings.spSiteUrl__c.replace(spCustomSettings.spSiteDomain__c, '');            

            Attachment attach = [SELECT Id, Body, BodyLength, Name, ParentId, Description, ContentType FROM Attachment
                                WHERE ParentId = :ParentId ORDER BY CreatedDate DESC LIMIT 1];	
            /*
            //Decisión del tipo de objeto para realizar cada operación.
            if(sParentObject == 'Opportunity'){
                //obtener Adjunto
                ContentDocumentLink cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :ParentId LIMIT 1];
                ContentVersion cv = [SELECT ContentDocumentId, Title, VersionData FROM ContentVersion WHERE ContentDocumentId = :cdl.ContentDocumentId LIMIT 1];
				fileName = cv.Title;
                
                // Obtenemos las categorías para ese tipo de archivo    
                List<String> fileCats = SharePointConnectorMappings.getCatsByFileType(fileName);
                if(fileCats == null) fileCats = new List<String>();
        
                // Obtenemos los datos de la oportunidad
                Opportunity opp = [SELECT AccountId FROM Opportunity WHERE Id = :ParentId];
                
                // Obtenemos la promoción mediante la oportunidad
                String promotionQuery = SharePointConnectorMappings.getPromotionQueryByType(ParentId.getSObjectType()).replace('$value$', ':oportunidadId');
                Promocion__c promotion = Database.query(promotionQuery);
        
                // Preparamos subida a Sharepoint:
                Map<String, String> metaDataMap = new Map<String, String>();
                metaDataMap.put('IdPromocion', promotion.Id);
                metaDataMap.put('IdOportunidad', ParentId);
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
                
                fileName = SharePointConnectorMappings.getNameByCats(fileCats);*/
                /*if(!Test.isRunningTest()) {
                    SharePointConnector spConnector = new SharePointConnector(fileName + '.pdf', dirPath, metaDataMap);
                    spConnector.login();
                    spConnector.createFile(EncodingUtil.base64Encode(pagePdf.getContentAsPdf()));
                    spConnector.updateFileMetaData();            
                }*//*
                SharePointConnect(fileName, dirPath, metaDataMap, att.body);
                SharePointConnector.commitDocumentNumber();
            }
            
            if(sParentObject == 'Facutra__c'){
            	Factura__c factura = [SELECT Id, Name, Cliente__c,Oportunidad__r.Promocion__c FROM Factura__c WHERE id = :ParentId LIMIT 1];
            	fileName = factura.Name;
                String email;
                
                // Obtenemos las categorías para ese tipo de archivo    
                List<String> fileCats = SharePointConnectorMappings.getCatsByFileType('Factura');
                if(fileCats == null) fileCats = new List<String>();
                
                // Obtenemos la promoción mediante la oportunidad
                Promocion__c promotion = [SELECT Id, Name FROM Promocion__c WHERE Id = :factura.Oportunidad__r.Promocion__c];
                
                // Preparamos subida a Sharepoint:
                Map<String, String> metaDataMap = new Map<String, String>();
                metaDataMap.put('IdPromocion', promotion.Id);
                metaDataMap.put('TipoDocumento', 'Archivo'); // FIXME -> SEGURAMENTE TAMBIÉN CON MAPEO
                Integer i = 1;
                for(String cat : fileCats) {
                    metaDataMap.put('Categoria' + i, cat);
                    i++;
                }
                metaDataMap.put('IdUsuario', UserInfo.getUserId());
                metaDataMap.put('Usuario', UserInfo.getUserEmail());
        
                DocumentCategory__c customDocCategory = null;
                String dirPath = baseDirPath + parentDir + '/' + promotion.Name;
                System.debug('dirPath: ' + dirPath);
                if(fileCats.size() > 0) {
                    customDocCategory = [SELECT ParentDirectoryName__c FROM DocumentCategory__c WHERE Name = :fileCats.get(0)];                                
                    dirPath += '/' + customDocCategory.ParentDirectoryName__c;
                }
                
                fileName = SharePointConnectorMappings.getNameByCats(fileCats);*/
                /*if(!Test.isRunningTest()) {
                    SharePointConnector spConnector = new SharePointConnector(fileName + '.pdf', dirPath, metaDataMap);
                    spConnector.login();
                    spConnector.createFile(EncodingUtil.base64Encode(pdfPage.getContentAsPdf()));
                    spConnector.updateFileMetaData();
                }*//*
                SharePointConnect(fileName, dirPath, metaDataMap, att.body);
                SharePointConnector.commitDocumentNumber();
                
                //Enviar la factura por email
                //obtener Adjunto
                ContentDocumentLink cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :factura.Id LIMIT 1];
                ContentVersion cv = [SELECT ContentDocumentId, Title, VersionData FROM ContentVersion WHERE ContentDocumentId = :cdl.ContentDocumentId LIMIT 1];

                //Obtener email del destinarario (Cliente)
                Account cliente = [SELECT id, Email__c,PersonEmail, name FROM Account WHERE id =: factura.cliente__c LIMIT 1];
                System.debug(cliente);
                if(cliente.Email__c!=null){
                    email=cliente.Email__c;
                }else{
                    email=cliente.PersonEmail;
                }
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {email};
                message.optOutPolicy = 'FILTER';
                message.subject = 'Factura ' + Factura.name;
                message.plainTextBody = 'Se ha adjuntado su factura a este email';
                
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                            efa.setFileName(cv.Title+'.pdf');
                            efa.setBody(cv.VersionData);
                            efa.setContentType('application/pdf');
                
                message.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                
                System.debug(message);
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        
                if (results[0].success) {
                    System.debug('El email se ha enviado correctamente');
                } else {
                    System.debug('Ha habido un problema al enviar el email: ' + results[0].errors[0].message);
                }
                
            }
            
            if(sParentObject == 'Plan_de_pagos__c'){
                Plan_de_pagos__c planPagos = [SELECT Id, Oportunidad__c FROM Plan_de_pagos__c WHERE Id =: ParentId AND Estado__c = 'Activo' LIMIT 1];
                Id oportunidadId = planPagos.Oportunidad__c;
                
                fileNameKey = 'Adenda';
        		fileName += ' ' + oportunidadId;
                
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

                fileName = SharePointConnectorMappings.getNameByCats(fileCats);*/
                /*if(!Test.isRunningTest()) {
                    SharePointConnector spConnector = new SharePointConnector(fileName + '.pdf', dirPath, metaDataMap);
                    spConnector.login();
                    spConnector.createFile(EncodingUtil.base64Encode(pdfPage.getContentAsPdf()));
                    spConnector.updateFileMetaData();
                }*//*
                SharePointConnect(fileName, dirPath, metaDataMap, att.body);
                SharePointConnector.commitDocumentNumber();
            }*/
            
            if(sParentObject == 'Quote'){
                fileNameKey = 'FichaPreReserva';
        		fileName = fileNameKey + ' ' + ParentId;
                
                // Obtenemos las categorías para ese tipo de archivo    
                List<String> fileCats = SharePointConnectorMappings.getCatsByFileType(fileNameKey);
                if(fileCats == null) fileCats = new List<String>();
                
                List<Quote> qs = [SELECT Opportunity.Promocion__c FROM Quote WHERE Id = :ParentId];
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
                        //spConnector.createFile(EncodingUtil.base64Encode(pdfPage.getContentAsPdf()));
                        spConnector.createFile(EncodingUtil.base64Encode(att.body));
                        spConnector.updateFileMetaData();
                    }
                    //SharePointConnect(fileName, dirPath, metaDataMap, att.body);
                    fileName = SharePointConnectorMappings.getNameByCats(fileCats);            
                }
            }
        }

    }
    
 /*    @future (callout=true)
     Public static void SharePointConnect(String fileName, String dirPath, Map<String, String> metaDataMap, Blob attBody)
     {
         if(!Test.isRunningTest()) {
         	SharePointConnector spConnector = new SharePointConnector(fileName + '.pdf', dirPath, metaDataMap);
            spConnector.login();
            //spConnector.createFile(EncodingUtil.base64Encode(pdfPage.getContentAsPdf()));
            spConnector.createFile(EncodingUtil.base64Encode(attBody));
            spConnector.updateFileMetaData();
         }
     }*/
    
}