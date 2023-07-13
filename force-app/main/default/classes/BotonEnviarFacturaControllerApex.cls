/*
FECHA         AUTOR       DESCRIPCIÓN
??			  ??		  Created.
21/09/2021	  LCS - HPS   Modification. LineaFactura and Factura descriptions get substringed for correct oracle integration.
*/

public class BotonEnviarFacturaControllerApex {
     @auraEnabled
     public static String getUrl(){
        String dominio = System.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/'; 
        return (dominio);
    }

     @auraEnabled
     public static String getCongaURL(String RecordId){ 
         
        APXTConga4__Conga_Solution__c CongaSol = [SELECT Id, APXTConga4__Button_body_field__c FROM APXTConga4__Conga_Solution__c WHERE Name = 'Generar Documento Factura' LIMIT 1];
         
        String dominio = CongaSol.APXTConga4__Button_body_field__c;
        dominio = dominio.replace('{!Factura__c.Id}', RecordId);
        
         return dominio;
    }             
    
	@auraEnabled
    public static Boolean generarFactura(Id facturaId){
    	System.debug('generarFactura');
    	List<ContentDocumentLink> listaDocumentos = [SELECT id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: facturaId];
        Set<id> setIdDocumentos = new Set<id>();
        
        //Si se pueden añadir más documentos en una factura se tiene que mirar el tipo del contentVersion
        //Obtener ids de documentos
        for(integer i = 0; i < listaDocumentos.size(); i++){
            setIdDocumentos.add(listaDocumentos[i].ContentDocumentId);
        }
        
        List<ContentVersion> listaContenidoDocumentos = [SELECT id FROM ContentVersion WHERE ContentDocumentId IN : setIdDocumentos AND tipo__c = 'factura'];
        System.debug('listaContenidoDocumentos: ' + listaContenidoDocumentos);
        if(listaContenidoDocumentos.size() == 0){
            guardarFacturaSharePoint(facturaId);
            guardarFactura(facturaId);
            return true;
        }

        return false;
    }
    
    public static void guardarFactura(Id facturaId){
        System.debug('guardarFactura');
        Factura__c factura = [SELECT id, name, cliente__c FROM Factura__c WHERE id = :facturaId LIMIT 1];
        
        PageReference pdfPage = new PageReference('/apex/VF_Documento_factura');
        pdfPage.getParameters().put('Id', facturaId);
        
        ContentVersion cv = new ContentVersion();
        cv.title = factura.name;
        cv.tipo__c = 'Factura';
        cv.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()){
            cv.VersionData = blob.valueOf('Unit.Test');
        } else {
            cv.VersionData = pdfPage.getContentAsPdf();
        }
        cv.Origin = 'H';
    
        insert cv;
        
        ContentVersion cv2 = [SELECT ContentDocumentId, Title, VersionData FROM ContentVersion WHERE id = :cv.id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cv2.ContentDocumentId;
        cdl.LinkedEntityId = facturaId;
        cdl.ShareType = 'V';
        
        //REVISAR PERMISOS -- QUIEN PUEDE VER LAS FACTURAS??
        cdl.Visibility = 'AllUsers';
        
        insert cdl;
        
        enviarEmail(factura.id);
        
    }

    private static void guardarFacturaSharePoint(Id facturaId) {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        String parentDir = spCustomSettings.spParentDir__c;
        String baseDirPath = spCustomSettings.spSiteUrl__c.replace(spCustomSettings.spSiteDomain__c, '');
        
        Factura__c factura = [SELECT Id, Name, Cliente__c,Oportunidad__r.Promocion__c FROM Factura__c WHERE id = :facturaId LIMIT 1];
        String fileName = factura.Name;
        PageReference pdfPage = new PageReference('/apex/VF_Documento_factura');
        pdfPage.getParameters().put('Id', facturaId);

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

        fileName = SharePointConnectorMappings.getNameByCats(fileCats);
        if(!Test.isRunningTest()) {
            SharePointConnector spConnector = new SharePointConnector(fileName + '.pdf', dirPath, metaDataMap);
            spConnector.login();
            spConnector.createFile(EncodingUtil.base64Encode(pdfPage.getContentAsPdf()));
            spConnector.updateFileMetaData();
        }
        SharePointConnector.commitDocumentNumber();
    }
    
    @AuraEnabled
    public static void enviarEmail(Id facturaId){
        String email;
        System.debug('enviarEmail');
        //Obtener factura
        Factura__c factura = [SELECT name, cliente__c FROM Factura__c WHERE id =: facturaId LIMIT 1];
		//obtener Adjunto
        ContentDocumentLink cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :facturaId LIMIT 1];
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
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'comercial@avintiainmobiliaria.com'];
		if ( owea.size() > 0 ) {
    		message.setOrgWideEmailAddressId(owea.get(0).Id);
		}
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        
        if (results[0].success) {
            System.debug('El email se ha enviado correctamente');
        } else {
            System.debug('Ha habido un problema al enviar el email: ' + results[0].errors[0].message);
        }
        
        
    }
    
    @AuraEnabled
    public static id generarFacturaAnulacion(Id facturaId){
        
        String description;
        //Opportunity oportunidad = [SELECT id,Reserva__c, Description FROM Opportunity WHERE id =: oportunidadId LIMIT 1];
        
        List<Factura__c> facturaOldList = [SELECT Id, Numero_de_factura__c, Referencia__c, Descripcion__c, Codigo_Impuesto__c, Origen__c, Cliente__c, Sociedad__c , Fecha_Contable__c, Fecha_de_emision__c,
                             		       Estado_de_la_factura__c, Condicion_Cobro__c, Metodo_de_cobro__c, Pago_o_Cuota__c, Importe__c, Oportunidad__c, Plan_de_pagos__c, Estado_plan_de_pagos__c, Name
                             		       FROM Factura__c
                             		       WHERE Id =: facturaId];
        
     
        if(!facturaOldList.isEmpty()){
            Factura__c facturaOld = facturaOldList[0];
            Factura__c fac = new Factura__c();
            
            fac.name = 'Anulación de ' + facturaOld.name;
            fac.Numero_de_factura__c = null;
            fac.Tipo_de_factura__c = 'FACTURA RECTIFICATIVA';
            if(facturaOld.Importe__c != null){
            	fac.Importe__c = -1 * facturaOld.Importe__c ;    
            }
            fac.Tipologia__c = 'Abono';
            if(facturaOld.Referencia__c != null){
            	fac.Referencia__c = facturaOld.Referencia__c.substringBeforeLast('-')+'-09';
            }
            description = 'Anulación factura número '+ (facturaOld.Numero_de_factura__c);
            fac.Descripcion__c = description.length() > 80 ? description.substring(0, 80) : description; 
            fac.Codigo_Impuesto__c = facturaOld.Codigo_Impuesto__c;
            fac.Origen__c = 'Abonos';
            fac.Cliente__c = facturaOld.Cliente__c;
            fac.Sociedad__c = facturaOld.Sociedad__c;
            fac.Fecha_Contable__c = date.today() + 1;
            fac.Fecha_de_emision__c = date.today() + 1;
            fac.Estado_de_la_factura__c = 'Pendiente de emisión';
            fac.Condicion_Cobro__c = facturaOld.Condicion_Cobro__c; //cambiar
            fac.Metodo_de_cobro__c = facturaOld.Metodo_de_cobro__c;
            fac.Pago_o_Cuota__c = 'Abono';
            fac.Oportunidad__c = facturaOld.Oportunidad__c;
            fac.Plan_de_pagos__c = facturaOld.Plan_de_pagos__c;
            fac.Estado_plan_de_pagos__c = facturaOld.Estado_plan_de_pagos__c;
            //fac.Tipo_de_linea__c = 'Depósito';
            //fac.Fecha cobro 
            
            if(facturaOld.Estado_de_la_factura__c != 'Cancelada' && facturaOld.Estado_de_la_factura__c != 'Volcada y Emitida' && facturaOld.Estado_de_la_factura__c != 'Cobrada') facturaOld.Estado_de_la_factura__c = 'Cancelada';
            
            try{
                system.debug('fac:::'+fac);
                update facturaOld;
                insert fac;
                
                List<Linea_de_factura__c> lineaFacturaOldList = [SELECT Name, Numero_de_linea__c, Tipo_de_linea__c, Factura__c, Importe__c, DescripcionLinea__c
                                                       FROM Linea_de_factura__c
                                                       WHERE Factura__c =: facturaOld.Id];
                
                if(!lineaFacturaOldList.isEmpty()){
                    List<Linea_de_factura__c> lineaFacturaList = new List<Linea_de_factura__c>();
                    for(Integer i = 0; i < lineaFacturaOldList.size(); i++){
                        Linea_de_factura__c lineaFactura = new Linea_de_factura__c(); 
                        if(lineaFacturaOldList[i].Name.length() > 66){
                            String nombre = 'Anulación de ' + lineaFacturaOldList[i].Name;
                            lineaFactura.Name = nombre.length() > 80 ? nombre.substring(0, 80) : nombre;                                  
                        }else{
                            lineaFactura.Name = 'Anulación de ' + lineaFacturaOldList[i].Name;
                        }
                        lineaFactura.Numero_de_linea__c = lineaFacturaOldList[i].Numero_de_linea__c;
                        lineaFactura.Tipo_de_linea__c = lineaFacturaOldList[i].Tipo_de_linea__c;
                        lineaFactura.Factura__c = fac.Id;
                        if(lineaFacturaOldList[i].Importe__c != null){
                            lineaFactura.Importe__c = -1 * lineaFacturaOldList[i].Importe__c;    
                        }
                        
                        lineaFactura.DescripcionLinea__c = (lineaFacturaOldList[i].DescripcionLinea__c).length() > 80 ? (lineaFacturaOldList[i].DescripcionLinea__c).substring(0, 80) : lineaFacturaOldList[i].DescripcionLinea__c;
                        lineaFacturaList.add(lineaFactura);
                    }
                        try{
                            system.debug('lineaFactura:::'+lineaFacturaList);	
                            insert lineaFacturaList;
                            /*String dominio = System.URL.getSalesforceBaseUrl().toExternalForm() + '/';
                            PageReference retUrl = new PageReference(dominio+fac.id);
                            retURL.setRedirect(true);*/
                            system.debug('fac.id:::'+fac.id);
                            return fac.id;
                        }catch(System.DmlException e){
                            System.debug('BotonReservaController | generarFacturaAbono() - DmlException: ' + e.getMessage());
                        }
                	
                }
            }catch(System.DmlException e){
                System.debug('BotonReservaController | generarFacturaAbono() - DmlException: ' + e.getMessage());
            }    
        
        }

   		return null;
    }

}