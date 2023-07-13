/*
FECHA         AUTOR       DESCRIPCIÓN
??			  ??		  Created.
21/04/2021    LCS - SCA   Modificación. Se modifica el método generarFacturaAbono para que se puedan generar varios abonos de deposito si hay varias facturas de reserva.
21/09/2021	  LCS - HPS   Modification. LineaFactura and Factura descriptions get substringed for correct oracle integration.
*/

public class BotonReservaController {


    @AuraEnabled
    public static String getTipoVivienda(Id oportunidadId){
        
        List<OpportunityLineItem> productoOportunidad = [SELECT Id, OpportunityId, Product2.Tipo_de_vivienda__c, Product2.Tipo_de_inmueble__r.Tipo__c 
                                                   FROM OpportunityLineItem 
                                                   WHERE OpportunityId =: oportunidadId AND 
                                                   Product2.Tipo_de_inmueble__r.Tipo__c = 'Vivienda'];
    
       
        String tipoVivienda;
        if(productoOportunidad.size() != 0){
            system.debug('productoOportunidad:::'+productoOportunidad[0]);
            tipoVivienda = productoOportunidad[0].Product2.Tipo_de_vivienda__c;
            system.debug('tipoVivienda:::'+tipoVivienda);    
        }

		return tipoVivienda;
    }
    
    @AuraEnabled
    public static String getTipoInmueble(Id oportunidadId){
    	List<OpportunityLineItem> productoOportunidadList = [SELECT Id, OpportunityId, Product2.Tipo_de_vivienda__c, Product2.Tipo_de_inmueble__r.Tipo__c 
                                                   			FROM OpportunityLineItem 
                                                   			WHERE OpportunityId =: oportunidadId]; 
        
        List<String> tipoInmuebleList = new List<String>();
        for(OpportunityLineItem productoOportunidad : productoOportunidadList){
            tipoInmuebleList.add(productoOportunidad.Product2.Tipo_de_inmueble__r.Tipo__c);
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
            }else if(tipoInmuebleList.contains('Trastero') && !tipoInmuebleList.contains('Vivienda')){
                String tipoInmueble = 'Trastero';
                system.debug('tipoInmueble es:::'+ tipoInmueble);
                return tipoInmueble;                
            }else if(tipoInmuebleList.contains('Garaje') && !tipoInmuebleList.contains('Vivienda')){
                String tipoInmueble = 'Garaje';
                system.debug('tipoInmueble es:::'+ tipoInmueble);
                return tipoInmueble ;                
            }
    
        } 
        return null;
    }
    
     @auraEnabled
     public static String getUrl(){
        String dominio = System.URL.getSalesforceBaseUrl().toExternalForm() + '/apex/'; 
        return (dominio);
    }

     @auraEnabled
     public static String getCongaURL(String CongaSolName, String RecordId, String CongaTemplateName){ 
         
        APXTConga4__Conga_Solution__c CongaSol = [SELECT Id, APXTConga4__Button_body_field__c FROM APXTConga4__Conga_Solution__c WHERE Name =: CongaSolName LIMIT 1];
        List<APXTConga4__Conga_Template__c> CongaTemplates = [SELECT Id FROM APXTConga4__Conga_Template__c WHERE APXTConga4__Name__c =: CongaTemplateName LIMIT 1];
        if(CongaTemplates.size() < 1)
        {
            String TemplanteNoLang = CongaTemplateName.replace('_ES', '').replace('_EN', '').replace('_DE', '');
            CongaTemplates = [SELECT Id FROM APXTConga4__Conga_Template__c WHERE APXTConga4__Name__c =: TemplanteNoLang LIMIT 1];
        }
         
        String dominio = CongaSol.APXTConga4__Button_body_field__c;
        String CongaTemplateId = CongaTemplates.get(0).Id;
        dominio = dominio.replace('{!Opportunity.Id}', RecordId);
        if(dominio.indexOf('TemplateId=') > -1)
        	dominio = dominio.substring(0, dominio.indexOf('TemplateId=')+11) + CongaTemplateId + dominio.substring(dominio.indexOf('TemplateId=')+26, dominio.length());
         
         return dominio;
    }    
    
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
        if(estado =='Reserva'){ 
            pdfPage = new PageReference('/apex/'+plantilla);
            pdfPage.getParameters().put('Id', oportunidadId);
            system.debug(oportunidadId); 
        }else if(estado =='Contrato'){
            pdfPage = new PageReference('/apex/'+plantilla);
            pdfPage.getParameters().put('Id', oportunidadId);
            system.debug(oportunidadId);     
        }else if(estado =='Escrituración'){ 
            pdfPage = new PageReference('/apex/'+plantilla);
            pdfPage.getParameters().put('Id', oportunidadId);
            system.debug(oportunidadId); 
        }else if(estado =='Cancelada'){
            pdfPage = new PageReference('/apex/'+plantilla);
            pdfPage.getParameters().put('Id', oportunidadId);
            system.debug(oportunidadId);    
        }    

        guardarPresupuestoSharepoint(pdfPage, oportunidadId, nombreFichero);
        guardarPresupuestoSF(pdfPage, oportunidadId, estado, nombreFichero);
    }

    private static void guardarPresupuestoSF(PageReference pdfPage, Id oportunidadId, String estado, String nombreFichero) {
        ContentVersion cv = new ContentVersion();
        
        if(estado =='Reserva'){ 
			cv.title = nombreFichero + ' ' + oportunidadId;
        }else if(estado =='Contrato'){
            cv.title = nombreFichero + ' ' + oportunidadId;    
        }else if(estado =='Escrituración'){ 
            cv.title = nombreFichero + ' ' + oportunidadId; 
        }else if(estado =='Cancelada'){
            cv.title = nombreFichero + ' ' + oportunidadId;   
        }          

        cv.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()) {
            cv.VersionData = blob.valueOf('Unit.Test');
        } else {
            cv.VersionData = pdfPage.getContentAsPdf();
        }
        
        insert cv;
        
        ContentVersion cv2 = [SELECT ContentDocumentId, Title, VersionData FROM ContentVersion WHERE id = :cv.id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cv2.ContentDocumentId;
            cdl.LinkedEntityId = oportunidadId;
            cdl.ShareType = 'V';
        

            cdl.Visibility = 'AllUsers';
        
        insert cdl; 
    }

    private static void guardarPresupuestoSharepoint(PageReference pagePdf, Id oportunidadId, String nombreFichero) {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        String parentDir = spCustomSettings.spParentDir__c;
        String baseDirPath = spCustomSettings.spSiteUrl__c.replace(spCustomSettings.spSiteDomain__c, '');

        // Obtenemos las categorías para ese tipo de archivo    
        List<String> fileCats = SharePointConnectorMappings.getCatsByFileType(nombreFichero);
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
            spConnector.createFile(EncodingUtil.base64Encode(pagePdf.getContentAsPdf()));
            spConnector.updateFileMetaData();            
        }
        SharePointConnector.commitDocumentNumber();
    }
    
    
    
    
    @AuraEnabled
    public static id generarFacturaAbono(Id oportunidadId){
        
        Opportunity oportunidad = [SELECT id,Reserva__c, Description, Facturacion_por_separado__c FROM Opportunity WHERE id =: oportunidadId LIMIT 1];
        
        //Definimos lista de participantes por si hay más de uno     
        /*List<Participante__c> lPrt = new List<Participante__c>();
        lPrt = [SELECT id, Porcentaje_de_participacion__c FROM Participante__c WHERE Opportunity__c =: oportunidadId];*/
        
        List<Factura__c> facturaReservaList = [SELECT Id, Numero_de_factura__c, Referencia__c, Descripcion__c, Codigo_Impuesto__c, Origen__c, Cliente__c, Sociedad__c , Fecha_Contable__c, Fecha_de_emision__c,
                             		       Estado_de_la_factura__c, Condicion_Cobro__c, Metodo_de_cobro__c, Pago_o_Cuota__c, Importe__c
                             		       FROM Factura__c
                             		       WHERE Estado_de_la_factura__c = 'Cobrada' AND Tipo_de_factura__c = 'DEPOSITOS' AND Oportunidad__c =: oportunidadId];
        System.debug('Oportunidad Id: ' + oportunidadId);   
        System.debug('facturaReservaList: ' + facturaReservaList);   
        Set<Id> sFacturasDeposito = new Set<Id>();
        Map<Id,Factura__c> mFacInsWithOldId = new Map<Id, Factura__c>();
        List<Linea_de_factura__c> lLineasFactIns = new List<Linea_de_factura__c>();
        String description;
     
        if(!facturaReservaList.isEmpty()){
            for(Factura__c elementFact : facturaReservaList){
                sFacturasDeposito.add(elementFact.Id);
                Factura__c facturaReserva = elementFact;
                Factura__c fac = new Factura__c();
                
                fac.name = 'Abono depósito';
                fac.Numero_de_factura__c = null;
                fac.Tipo_de_factura__c = 'FACTURA RECTIFICATIVA';
                if(elementFact.Importe__c != null){ 
                    fac.Importe__c = -1 * elementFact.Importe__c;
                }
                fac.Tipologia__c = 'Abono';
                fac.Referencia__c = facturaReserva.Referencia__c;
                description = 'Abono de factura depósito número '+ facturaReserva.Numero_de_factura__c + ' de '+ oportunidad.Description;
                fac.Descripcion__c = description.length() > 80 ? description.substring(0, 80) : description; 
                fac.Codigo_Impuesto__c = facturaReserva.Codigo_Impuesto__c;
                fac.Origen__c = 'Abonos';
                fac.Cliente__c = facturaReserva.Cliente__c;
                fac.Sociedad__c = facturaReserva.Sociedad__c;
                fac.Fecha_Contable__c = date.today() + 1;
                fac.Fecha_de_emision__c = date.today() + 1;
                fac.Estado_de_la_factura__c = 'Pendiente de emisión';
                fac.Condicion_Cobro__c = facturaReserva.Condicion_Cobro__c; //cambiar
                fac.Metodo_de_cobro__c = facturaReserva.Metodo_de_cobro__c;
                fac.Pago_o_Cuota__c = 'Abono';
                fac.Oportunidad__c = oportunidadId;
                //fac.Tipo_de_linea__c = 'Depósito';
                //fac.Fecha cobro 
                mFacInsWithOldId.put(elementFact.Id, fac);
            }
            try{
                //system.debug('fac:::'+fac);			
                //insert fac;
                //insert lFacturasInsert;
                if(mFacInsWithOldId != null && !mFacInsWithOldId.isEmpty() && !mFacInsWithOldId.values().isEmpty()) insert mFacInsWithOldId.values();
                system.debug('TIENE ID: '+ mFacInsWithOldId.values()[0].Id);
                
                List<Linea_de_factura__c> lineaFacturaOldList = [SELECT Name, Numero_de_linea__c, Tipo_de_linea__c, Factura__c, Importe__c, DescripcionLinea__c
                                                       FROM Linea_de_factura__c
                                                       WHERE Factura__c =: /*facturaReserva.Id*/sFacturasDeposito];
                
                if(!lineaFacturaOldList.isEmpty()){
                    for(Linea_de_factura__c lFactOld : lineaFacturaOldList){
                        Linea_de_factura__c lineaFacturaOld = lFactOld;
                        Linea_de_factura__c lineaFactura = new Linea_de_factura__c();
                        if(lineaFacturaOld.Name.length() > 71){
                            String nombre = 'Abono de ' + lineaFacturaOld.Name;
                            lineaFactura.Name = nombre.length() > 80 ? nombre.substring(0, 80) : nombre;                                  
                        }else{
                            lineaFactura.Name = 'Abono de ' + lineaFacturaOld.Name;
                        }
                        lineaFactura.Numero_de_linea__c = lineaFacturaOld.Numero_de_linea__c;
                        lineaFactura.Tipo_de_linea__c = lineaFacturaOld.Tipo_de_linea__c;
                        lineaFactura.Factura__c = mFacInsWithOldId.get(lineaFacturaOld.Factura__c).Id;
                        if(lineaFacturaOld.Importe__c != null){ 
                            lineaFactura.Importe__c = -1 * lineaFacturaOld.Importe__c;
                        }
                        
                        lineaFactura.DescripcionLinea__c = (lineaFacturaOld.DescripcionLinea__c).length() > 80 ? (lineaFacturaOld.DescripcionLinea__c).substring(0, 80) : (lineaFacturaOld.DescripcionLinea__c);
                        lLineasFactIns.add(lineaFactura);
                    }
                    try{
                        //system.debug('lineaFactura:::'+lineaFactura);	
                        system.debug('lineaFactura:::'+lLineasFactIns);
                        if(lLineasFactIns != null && !lLineasFactIns.isEmpty()) insert lLineasFactIns;
                        return mFacInsWithOldId.values()[0].Id;
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