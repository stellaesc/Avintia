public class PublicacionPortales{	

    public static Integer WEB_AVINTIA = 0;
    public static Integer WEB_IDEALISTA = 1;
    public static Integer WEB_FOTOCASA = 2;

    	
    @AuraEnabled	
    public static Profile getProfileInfo(){	
          try{	
                return [SELECT Id, Name FROM Profile WHERE Id =:UserInfo.getProfileId()];	
          }catch(Exception e){	
            	throw new AuraHandledException(e.getMessage()); 	
          }	
    }	
    	
    @AuraEnabled	
    public static String UpdateCurrIdea(Promocion__c Prom){	
        String result;	
        if(Prom != null){	
            Date currD = date.today();	
			Id UserId = UserInfo.getUserId();	
            List<Promocion__c> promUpd = [SELECT Id, Ultima_Publicacion_Idealista__c, Ultimo_Publicante_Idealista__c	
                                         FROM Promocion__c WHERE Idealista__c = true];	
            	
            for(Promocion__c p: promUpd){	
                p.Ultima_Publicacion_Idealista__c = currD;	
                p.Ultimo_Publicante_Idealista__c = UserId;	
            }	
            Update promUpd;	
            result = 'OK';	
        }else{	
            result = 'ERROR ///';	
        }	
        return result;	
    }	
    	
	@AuraEnabled	
    public static String UpdateCurrWeb(Promocion__c Prom){	
        
        String result;	
        if(Prom != null){	
            Date currD = date.today();	
			Id UserId = UserInfo.getUserId();	
            Prom.Ultima_Publicacion_Web_Avintia__c = currD;	
            Prom.Ultimo_Publicante_Web__c = UserId;	
            Update Prom;	
            result = 'OK';	
        }else{	
            result = 'ERROR ///';	
        }	
        return result;
    }	
    	
    @AuraEnabled	
    public static String UpdateCurrFotoC(Promocion__c Prom){	
        String result;	
        if(Prom != null){	
            Date currD = date.today();	
			Id UserId = UserInfo.getUserId();
            List<Promocion__c> promUpd = [SELECT Id, Ultima_Publicacion_Fotocasa__c, Ultimo_Publicante_Fotocasa__c	
                                         FROM Promocion__c WHERE WebAvinita__c = true AND Idealista__c = true AND Fotocasa__c = true];	
            System.debug('Estoy aqui: ' + promUpd);	
            for(Promocion__c p: promUpd){	
                p.Ultima_Publicacion_Fotocasa__c = currD;	
                p.Ultimo_Publicante_Fotocasa__c = UserId;	
            }	
            Update promUpd;	
            result = 'OK';	
        }else{	
            result = 'ERROR ///';	
        }	
        return result;	
    }  	
    	
    @AuraEnabled	
    public static string publicarWebAvintia(Id PromoId, Boolean esPrueba) {	
        	
        //System.debug('Metodo de publicación en la Web de Avintia');	
        PropiedadesIntegracion__c propiedadesIntegracion = PropiedadesIntegracion__c.getInstance();	
        String mensajeEnviar = '';	
        string resultado = 'OK';	
        System.debug('mensajeEnviar: ' + resultado);	

        //Generamos el XML y lo enviamos al entorno.	
        try {	
            // Se llama al metodo de generacion del XML	
            String endpointUrl = esPrueba ? propiedadesIntegracion.URL_WEBAVINTIA__c : propiedadesIntegracion.URL_WEBAVINTIA_PRO__c;
            
            mensajeEnviar = generarXmlPublicacion(PromoId, esPrueba);	
            System.debug('mensajeEnviar: ' + resultado);		
            	

            //send message	
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();	
			message.toAddresses = new String[] {'avintia@leadclic.com'};	
			message.optOutPolicy = 'FILTER';	
            if(esPrueba){
                message.subject = 'Prueba Publicación Web';	
            }
            else{
                message.subject = 'Publicación Web';	
            }
            message.plainTextBody = mensajeEnviar;	
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'comercial@avintiainmobiliaria.com'];	
            if ( owea.size() > 0 ) {	
                message.setOrgWideEmailAddressId(owea.get(0).Id);	
            }	
			Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};	
            
            // Send the request
            HttpRequest req = new HttpRequest();	
            req.setMethod('POST');	
            req.setEndpoint(endpointUrl);	
            System.debug('ENDPOINT: ' + req.getEndpoint());	
            req.setHeader('Content-Type','application/xml');	
            if(esPrueba){
                String username = propiedadesIntegracion.usernamePruebas__c;
                String password = propiedadesIntegracion.passwordPruebas__c;
                Blob headerValue = Blob.valueOf(username + ':' + password);
                String authorizationHeader = 'Basic ' +
                    EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                system.debug(esPrueba + ' | Ejecutado desde la prueba');
            }
            req.setHeader('Authorization-Promociones', propiedadesIntegracion.PasswordWSAvintia__c);	
            req.setBody(mensajeEnviar);	
            req.setTimeout(120000);	
            // Create a new http object to send the request object
            // A response object is generated as a result of the request  
            Http http = new Http();
            HttpResponse res;	
            if(!System.Test.isRunningTest()) { // FIXME -> HAY QUE HACER EN LAS PRUEBAS UN MOCK UP PARA HACER LAS PRUEBAS CORRECTAMENTE	
                res = http.send(req);	
                System.debug('Respuesta del sistema: ' + res.getStatusCode()+ ' ' + res.getStatus()+ +res.getBody());	
            }

            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            //END 
            if (res != null && res.getStatusCode() == 200) {	
			    String respuesta = res.getBody();	
                insertarLog('publicarWebAvintia',PromoId,mensajeEnviar,respuesta,'PORTAL WEB AVINTIA');	
                resultado='OK';
            } else {	
                resultado='KO';	
                insertarLog('publicarWebAvintia',PromoId,mensajeEnviar, res != null ? res.toString() : null, 'PORTAL WEB AVINTIA');	
            }	
        } catch(Exception e){	
            System.debug('Error al realizar el envio: '+ e + '\n\r' + e.getStackTraceString());	
            resultado='KO';	
            insertarLog('publicarWebAvintia', PromoId, mensajeEnviar, e.getMessage(), 'PORTAL WEB AVINTIA');	
            throw new GenerarXMLException(e.getMessage());	
        }	
        	
        return resultado;	
    }


    public static boolean generateNewDoc(String jsonParsed, PropiedadesIntegracion__c propiedadesIntegracion, Boolean esPrueba){
        
      String base64Content = EncodingUtil.Base64Encode( 
            Blob.valueOf(jsonParsed) 
        );
        System.debug( 'Base64 Content is ' + base64Content );
        Blob blobContent = EncodingUtil.base64Decode( base64Content );
        System.debug( 'Decoded Base64 value is ' + blobContent.toString() );
        // Antes de crear el nuevo fichero se comprueba si ha habido algún cambio
        List<ContentDocument> lCdsId = [Select Id from ContentDocument where Title = :propiedadesIntegracion.CustomerCodeIdealista__c];
        Set<Id> cdSet = new Set<Id>();
        for(ContentDocument cd : lCdsId) cdSet.add(cd.Id);
        List<ContentVersion> cvExistentes = !cdSet.isEmpty() ? [Select Id, VersionData, ContentDocumentId from ContentVersion where ContentDocumentId in :cdSet order by CreatedDate desc limit 1]: new List<ContentVersion>()  ;

        Boolean loadNewFile = false;
        system.debug('EMPTY : ' + cvExistentes.isEmpty());
        if(!cvExistentes.isEmpty()){
            JSONParser parserNewJSON = JSON.createParser(jsonParsed);

            String previousVersionData = cvExistentes[0].VersionData.toString();
            
            JSONParser parserPreviousJSON = JSON.createParser(previousVersionData);
            
            while(parserNewJSON.nextToken() != null && parserPreviousJSON.nextToken() != null && loadNewFile == false){
                system.debug(parserNewJSON.getCurrentName() + ': ' + parserNewJSON.getText() + ' | ' + parserPreviousJSON.getCurrentName() + ': ' + parserPreviousJSON.getText());
                if(parserNewJSON.getCurrentName() != 'customerSendDate' && parserPreviousJSON.getCurrentName() != 'customerSendDate'){
                    if((parserNewJSON.getText() != parserPreviousJSON.getText()) ||
                    (parserNewJSON.getCurrentToken() != parserPreviousJSON.getCurrentToken())){
                        loadNewFile = true;
                    }
                }
            }
        }
        else{
            loadNewFile = true;
        }
        if(loadNewFile == true){
            ContentVersion objCV;
            objCV = new ContentVersion(
                Title = propiedadesIntegracion.CustomerCodeIdealista__c,
                PathOnClient = propiedadesIntegracion.CustomerCodeIdealista__c + '.json',
                VersionData = blobContent,
                PublicadoFTPIdealista__c = false
            );
            insert objCV;
            objCV = [
                SELECT ContentDocumentId
                FROM ContentVersion
                WHERE Id =: objCV.Id
            ];
            /*Id hardcodeado
            ContentDocumentLink objCDL = new ContentDocumentLink(
                ContentDocumentId = objCV.ContentDocumentId,
                LinkedEntityId = '00517000008VHdLAAW',
                Visibility = 'AllUsers'
            );
            insert objCDL;
            */
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();	
            message.toAddresses = new String[] {'avintia@leadclic.com'};	
            message.optOutPolicy = 'FILTER';	
            message.subject = 'Nuevo Fichero Publicación Web IDEALISTA Generado';	
            message.plainTextBody = jsonParsed;	
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'comercial@avintiainmobiliaria.com'];	
            if ( owea.size() > 0 ) {	
                message.setOrgWideEmailAddressId(owea.get(0).Id);	
            }	
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};	
    
            if(Test.isRunningTest() == false) Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        }

        //send message	
        return loadNewFile;
    }

    @AuraEnabled	
    public static String publicacionPortalesIdealista(Id PromoId, Boolean esPrueba) {	
        //System.debug('Metodo de publicación en la Web de Avintia');	
        PropiedadesIntegracion__c propiedadesIntegracion = PropiedadesIntegracion__c.getInstance();	
        String mensajeEnviar = '';	
        string resultado = 'OK';	
        System.debug('mensajeEnviar: ' + resultado);	
        Boolean ret;

        //Generamos el XML y lo enviamos al entorno.	
        try {	
            // Se llama al metodo de generacion del XML	
            String endpointUrl = esPrueba ? propiedadesIntegracion.URL_WEBAVINTIA__c : propiedadesIntegracion.URL_WEBAVINTIA_PRO__c;
            
            String jsonParsed = PublicacionPortalIdealista.generarJson();
            
            ret = generateNewDoc(jsonParsed, propiedadesIntegracion, esPrueba);

            system.debug(endpointUrl);
            //mensajeEnviar = generarXmlPublicacion(PromoId, esPrueba, WEB_IDEALISTA);	

            System.debug('mensajeEnviar: ' + mensajeEnviar);	
            //System.debug('Realizamos el envio al WS');	
            System.debug (esPrueba);	

        } catch(Exception e){	
            System.debug('Error al generar el JSON: '+ e + '\n\r' + e.getStackTraceString());	
            resultado='KO';	
            insertarLog('publicarWebAvintia', PromoId, mensajeEnviar, e.getMessage(), 'PORTAL WEB AVINTIA');	
            throw new GenerarXMLException(e.getLineNumber() + ' | ' + e.getMessage());	
        }	
        if(ret == false){
            resultado = 'DUPLICATED';
        }
        return resultado;	
    }		

    @AuraEnabled	
    public static string publicacionPortalesFotocasa(Id PromoId, Boolean esPrueba) {	
        PropiedadesIntegracion__c propiedadesIntegracion = PropiedadesIntegracion__c.getInstance();	
        String mensajeEnviar = '';	
        string resultado = 'OK';	
        System.debug('mensajeEnviar: ' + resultado);	

        //Generamos el XML y lo enviamos al entorno.	
        try {	
            // Se llama al metodo de generacion del XML	
            String endpointUrl = esPrueba ? propiedadesIntegracion.URL_WEBAVINTIA__c : propiedadesIntegracion.URL_WEBAVINTIA_PRO__c;
            
            system.debug(endpointUrl);
            mensajeEnviar = generarXmlPublicacion(PromoId, esPrueba);	
            System.debug('mensajeEnviar: ' + mensajeEnviar);	
            //System.debug('Realizamos el envio al WS');	
            System.debug (esPrueba);	
            	

            //send message	
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();	
			message.toAddresses = new String[] {'avintia@leadclic.com'};	
			message.optOutPolicy = 'FILTER';	
            if(esPrueba){
                message.subject = 'Prueba Publicación Web FOTOCASA';	
            }
            else{
                message.subject = 'Publicación Web';	
            }
            message.plainTextBody = mensajeEnviar;	
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'comercial@avintiainmobiliaria.com'];	
            if ( owea.size() > 0 ) {	
                message.setOrgWideEmailAddressId(owea.get(0).Id);	
            }	
			Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};	
            
            // Send the request
            HttpRequest req = new HttpRequest();	
            req.setMethod('POST');	
            req.setEndpoint(endpointUrl);	
            System.debug('ENDPOINT: ' + req.getEndpoint());	
            req.setHeader('Content-Type','application/xml');	
            if(esPrueba){
                String username = propiedadesIntegracion.usernamePruebas__c;
                String password = propiedadesIntegracion.passwordPruebas__c;
                Blob headerValue = Blob.valueOf(username + ':' + password);
                String authorizationHeader = 'Basic ' +
                    EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                system.debug(esPrueba + ' | Ejecutado desde la prueba');
            }
            req.setHeader('Authorization-Promociones', propiedadesIntegracion.PasswordWSAvintia__c);	
            req.setBody(mensajeEnviar);	
            req.setTimeout(120000);	
            // Create a new http object to send the request object
            // A response object is generated as a result of the request  
            Http http = new Http();
            HttpResponse res;	
            if(!System.Test.isRunningTest()) { // FIXME -> HAY QUE HACER EN LAS PRUEBAS UN MOCK UP PARA HACER LAS PRUEBAS CORRECTAMENTE	
                res = http.send(req);	
                System.debug('Respuesta del sistema: ' + res.getStatusCode()+ ' ' + res.getStatus()+ +res.getBody());	
            }

            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            //END 
            if (res != null && res.getStatusCode() == 200) {	
			    String respuesta = res.getBody();	
                insertarLog('publicarWebAvintia',PromoId,mensajeEnviar,respuesta,'PORTAL WEB AVINTIA');	
                resultado='OK';
            } else {	
                resultado='KO';	
                insertarLog('publicarWebAvintia',PromoId,mensajeEnviar, res != null ? res.toString() : null, 'PORTAL WEB AVINTIA');	
            }	
        } catch(Exception e){	
            System.debug('Error al realizar el envio: '+ e + '\n\r' + e.getStackTraceString());	
            resultado='KO';	
            insertarLog('publicarWebAvintia', PromoId, mensajeEnviar, e.getMessage(), 'PORTAL WEB AVINTIA');	
            throw new GenerarXMLException(e.getMessage());	
        }	
        return resultado;	
    }	
    //Metodo encargado de montar la URL de las imagenes	
    public static string devolverURLDocumento(string URL, string versionId,string tipo) {	
        PropiedadesIntegracion__c propiedades =PropiedadesIntegracion__c.getInstance();	
        String URLFinal='';	
        if(URL!=null && String.isNotBlank(URL) && versionId!=null && String.isNotBlank(versionId))	
        {	
            URLFinal=propiedades.URLDocuemntos__c+ tipo + '&versionId='+versionId+'&operationContext=DELIVERY&page=0&oid='+UserInfo.getOrganizationId().substring(0,UserInfo.getOrganizationId().length()-3)+'&dpt=null&d='+ url.substring((url.indexOf(UserInfo.getOrganizationId().substring(3,UserInfo.getOrganizationId().length()-3))+UserInfo.getOrganizationId().length()-6),url.length()) +'&tipo='+tipo;	
            //system.debug(URLFinal);	
        }	
        return URLFinal;	
    }
    public static string getPublicLinkCV(ContentVersion cv){
        List<ContentDistribution> cdList = [SELECT DistributionPublicUrl from ContentDistribution where ContentVersionId = :cv.Id order by createdDate desc limit 1];
        if(!cdList.isEmpty()){
            return cdList[0].DistributionPublicUrl;
        }
        else{
			return '';
        }
    }
    
    //Metodo encargado de montar la URL de las imagenes para FOTOCASA	
    //Metodo encargado de generar el XML de la promocion de la Web de Avintia	
    public static string generarXmlPublicacion(Id PromoId, Boolean esPrueba) {	
                
        string mensaje = '';	
        string debug = '';
        String listStrings = '';	
        try {	
            DOM.Document doc = new DOM.Document();	
            Set<id> setContentDocument = new Set<id>();	
            Set<id> setContentDocumentTipologia = new Set<id>();	
            Set<id> setTipologias = new Set<id>();
            Set<id> setContentVersionUrlsAux = new Set<id>();
            Set<id> setContentVersion = new Set<id>();
            Map<id, List<ContentVersion>> promosMapped  = new Map<id, List<ContentVersion>>();	
            List<ContentVersion> contentVersion = null;	
            List<ContentDocumentLink> linkTipologia = null;	
            List<ContentVersion> contentVersionTipologia = null;
            List<Promocion__c> promociones = [SELECT Id, Name, Nombre_promocion__c, Nombre_Comercial_Avintia_Inmobiliaria__c, Provincia__c, 
                                              Localidad__r.Name, Descricion_pequena__c, Slogan__c, Descripcion__c, Tipo_via__c, Nombre_via__c, 
                                              N_Via__c,Codigo_postal__c,Telefono_promocion_comercializadora__c,Email_promocion_comercializadora__c,
                                              Superficie_total_de_parcela__c, N_Plantas__c, N_Viviendas_totales_promocion__c,Precio_maximo_1_dormitorio__c,
                                              Precio_maximo_3_dormitorios__c,Precio_maximo_4_dormitorios__c,Precio_minimo_1_dormitorio__c,Precio_minimo_2_dormitorios__c,
                                              Precio_minimo_3_dormitorios__c,Precio_minimo_4_dormitorios__c,Precio_maximo_2_dormitorios__c,
                                              Piscina_Exterior__c,Zona_Infantil__c,Spa__c,Pistas_deportivas__c,Padel__c,Jardines__c,Gimnasio__c,
                                              Terrazas_Mirador__c,Zona_Gourmet__c,Ascensores__c,Sala_Multidisciplinar__c,Coordenadas__Latitude__s,
                                              Coordenadas__Longitude__s,Restaurantes__c,Mercados__c,Parques__c,Playas__c,Localizacion_Google__c,
                                              Agrupador_de_viviendas__c, Slogan_Final_Web__c, Descripcion_final_Web__c, Texto_financiacion__c, 
                                              Solarium__c,Plaza_de_Garaje_Parking__c,Trastero__c, Chill_Out__c, Domotica__c, Suelo_Radiante__c,
                                              Aerotermia__c, Vestuarios_comunitarios__c, Sauna__c, Piscina_Infantil__c, Ski_Room__c,
                                              Calificacion_Energetica_A__c, Calificacion_Energetica_B__c, Cargador_Coches_Electricos__c, 
                                              Buhardilla__c, Hammam__c, Hospitales__c, Colegios__c, Guarderias__c, Deportivas__c, Farmacias__c,Centros_Comerciales__c,Finca__c, Golf__c, Puerto__c, Metros__c, Autobuses__c, Tren__c, Aeropuertos__c, 
                                              Estacion_Esqui__c, Gasolineras__c, Universidades__c, PuntoVenta__c, Link_video_promocion__c 	
                                              FROM Promocion__c 	
                                              WHERE WebAvinita__c = true]; 
            List<Id> lIds= new List<Id>();
            for(Promocion__c getId:  promociones){
                lIds.add(getId.Id);
            }											  
            List<Product2> viviendas = [SELECT Id, Promocion__c, Name, Precio__c, Estado__c, Tipologia_Vivienda_Garaje_Trastero_Local__c, Tipo_de_inmueble__c,
                                        N_habitaciones__c, N_banos__c, Superficie_Construida_m2__c, Superficie_Terrazas_Descubiertas__c,
                                        Superficie_Util_Garaje_con_calles_m2__c,Superficie_Util_m2__c,Superficie_Util_Trastero_con_pasillos_m2__c,Inmueble_asociado__c, Superficie_Terrazas_Cubiertas__c, Superficie_Jardines__c, 
                                        Superficie_Construida_total_con_ZZCC_m2__c, SupConstTotal__c, Piso__c,WebAvinita__c, Tipologia_de_vivienda__c, Precio_con_anejos_incluidos__c 
                                        FROM Product2 
                                        WHERE Promocion__c in :lIds AND WebAvinita__c = true AND Inmueble_asociado__c = null];
            for(Product2 vivTipologia : viviendas){
                setTipologias.add(vivTipologia.id);
                setTipologias.add(vivTipologia.Tipo_de_inmueble__c);
            }
            // Anejos
            Map<Id, List<Product2>> productsAnnexesMap = new Map<Id, List<Product2>>();
            List<Product2> annexes = [SELECT Id, Precio__c, Inmueble_asociado__c, Tipologia_Vivienda_Garaje_Trastero_Local__c 
                                      FROM Product2 
                                      WHERE Promocion__c in :lIds AND Inmueble_asociado__c != null];
            for(Product2 annexe : annexes) {
                List<Product2> currAnnexesList = productsAnnexesMap.get(annexe.Inmueble_asociado__c);
                if(currAnnexesList == null) currAnnexesList = new List<Product2>();
                currAnnexesList.add(annexe);
                productsAnnexesMap.put(annexe.Inmueble_asociado__c, currAnnexesList);
            }
            //Obtener la id de los archivos (Imagenes) que están relacionados con las promociones
            List<ContentDocumentLink> linkPromocion = [SELECT Id, ContentDocumentId, LinkedEntityId  
                                                       FROM ContentDocumentLink
                                                       WHERE LinkedEntityId in :lIds];
            for(ContentDocumentLink cdl : linkPromocion){ 
                setContentDocument.add(cdl.contentDocumentId);
            }
            //Obtener los archivos (Imagenes) de ContentVersion de las promociones
            if(!setContentDocument.isEmpty()) {
                contentVersion = ([SELECT Id, Title, Description, Posicion__c, ContentDocumentId, URL__c, Tipo__c, Url_Youtube__c, FileType 
                                FROM ContentVersion
                                WHERE ContentDocumentId IN :setContentDocument and IsLatest = true 
                                ORDER BY Posicion__c ASC]);
                for(ContentVersion cvAux : contentVersion)
                    setContentVersionUrlsAux.add(cvAux.Id);
            }
            //Agrupamos en el mapa cada promocion y sus documentos
            if(contentVersion != null){
                for(ContentDocumentLink lp : linkPromocion){
                    for(ContentVersion cv: contentVersion){
                        if(lp.ContentDocumentId == cv.ContentDocumentId){
                            List<ContentVersion> cvList;
                            system.debug('CONDICION OK ' + lp.LinkedEntityId + ' | ' + cv);
                            debug += 'CONDICION OK ' + lp.LinkedEntityId + ' | ' + cv;
                            if(!promosMapped.keySet().contains(lp.LinkedEntityId)){
                                cvList = new List<ContentVersion>();
                                cvList.add(cv);
                                promosMapped.put(lp.LinkedEntityId, cvList);
                            }
                            else{
                                cvList = promosMapped.get(lp.LinkedEntityId);
                                cvList.add(cv);
                                promosMapped.put(lp.LinkedEntityId, cvList);
                            }
                        }
                    }
                }
            }

            //Obtener la id de los archivos (Imagenes) que están relacionados con las tipologias
            
            if(!setTipologias.isEmpty()) {
                linkTipologia = [SELECT Id, ContentDocumentId, LinkedEntityId 
                                 FROM ContentDocumentLink 
                                 WHERE LinkedEntityId IN :setTipologias];
                /*for(ContentDocumentLink linkTtoDebug : linkTipologia){
                    listStrings += linkTtoDebug.LinkedEntityId + ' | ' + linkTtoDebug.Id + '\n';
                }*/
                for(ContentDocumentLink cdTipo : linkTipologia){ 
                    setContentDocumentTipologia.add(cdTipo.contentDocumentId);
                }
            }

            //Obtener los archivos (Imagenes) de ContentVersion de las promociones
            if(!setContentDocumentTipologia.isEmpty()) {
                contentVersionTipologia = ([SELECT Id, Title, Description, Posicion__c, ContentDocumentId, URL__c, Tipo__c, Url_Youtube__c, FileType 
                                            FROM ContentVersion
                                            WHERE  ContentDocumentId IN :setContentDocumentTipologia AND IsLatest = true AND 
                                            (Tipo__c = 'Plano' OR Tipo__c = 'Plano_PDF' OR Tipo__c = 'Video_Youtube')]);
                if(!contentVersionTipologia.isEmpty()){
                    for(ContentVersion cv : contentVersionTipologia)
                        setContentVersion.add(cv.Id);
                }
            }
            Map<Id, String> publicLinksCV = new Map<Id, String>();
            if(!setContentVersion.isEmpty()){
                List<ContentDistribution> lCD = [SELECT DistributionPublicUrl, ContentVersionId from ContentDistribution where ContentVersionId in  :setContentVersion or ContentVersionId in :setContentVersionUrlsAux order by createdDate desc];
                for(ContentDistribution cd : lCD){
                    publicLinksCV.put(cd.ContentVersionId, cd.DistributionPublicUrl);
                }
            }
            
            listStrings += 'CONTENTVERSIONTIPOLOGIAS\n';

            for(ContentVersion cvTest : contentVersionTipologia){
                listStrings	+= ' |CV: ' + cvTest.Id + ' | CD:' + cvTest.ContentDocumentId + ' | ' + cvTest.Title + '\n';
            }
            listStrings += '------' + '\n\nLINKTIPOLOGIAS';

            for(ContentDocumentLink cdlTest : linkTipologia){
                listStrings	+= ' |LinkedEntity: ' + cdlTest.LinkedEntityId + ' | CDL-Id' + cdlTest.Id + ' | CD:' + cdlTest.ContentDocumentId + '\n';
            }
            listStrings += '------' + '\n\n';

            //Recorremos las promociones que vamos a enviar a la Web de Avintia
            if(promociones != null) { 
                Dom.XmlNode promocionesAvintia= doc.createRootElement('promociones',null, null);
                for(Promocion__c promocion : promociones) {
                    Double precio = null;
                    Double porcentajeVendido;
                    Integer viviendasVendidas = 0;
                    Integer nMinHabitaciones = 0;
                    Integer nMaxHabitaciones = 0;
                    Long superficieConstruidaMaxima = 0;
                    Long superficieConstruidaMinima = 0;
                    String descripcionPromocion;
                    List<ContentVersion> listaFolletos = new List<ContentVersion>();
                    List<ContentVersion> listaMemoriaCalidades = new List<ContentVersion>();
                    List<ContentVersion> listaZonasComunes = new List<ContentVersion>();
                    List<ContentVersion> contentVersionsPromo;

                    Dom.XmlNode promo= promocionesAvintia.addChildElement('promocion', null, null);
                    promo.addChildElement('id', null, null).
                        addTextNode(promocion.Id); 
                    promo.addChildElement('titulo', null, null).
                        addTextNode(String.isBlank(promocion.Nombre_Comercial_Avintia_Inmobiliaria__c) ? '' : promocion.Nombre_Comercial_Avintia_Inmobiliaria__c);
                    promo.addChildElement('localidad', null, null).
                        addTextNode((promocion.Localidad__r.Name == null ? '' : promocion.Localidad__r.Name));
                    promo.addChildElement('resumen', null, null).
                        addTextNode(promocion.Descricion_pequena__c == null ? '' : promocion.Descricion_pequena__c);
                    promo.addChildElement('direccion', null, null).
                        addTextNode((promocion.Tipo_via__c==null ? '' : promocion.Tipo_via__c)+ ' ' + 
                            (promocion.Nombre_via__c == null ? '' : promocion.Nombre_via__c)+ ' ' + 
                            (promocion.N_Via__c == null ? '' : String.valueOf(promocion.N_Via__c))+ ' '+ 
                            (promocion.Localidad__r.Name == null ? '' : promocion.Localidad__r.Name)+' '+
                            (promocion.Provincia__c == null ? '' : promocion.Provincia__c)+ ' ' +
                            (promocion.Codigo_postal__c == null ? '' : promocion.Codigo_postal__c));
                    
                    if(promocion.PuntoVenta__c != null){
                        promo.addChildElement('punto_de_venta', null, null).
                            addTextNode(promocion.PuntoVenta__c);
                    }

                    //Cálculamos el precio minimo de las viviendas de la promocion y las habitaciones que hay minimas y maximas                    
                    for(Product2 vivienda : viviendas) {                
                        // Calculamos precio de la vivienda con el precio de sus anejos incluidos
                        if(vivienda.Promocion__c == promocion.Id){
                            List<Product2> currProductAnnexes = productsAnnexesMap.get(vivienda.Id);
                            if(currProductAnnexes == null) currProductAnnexes = new List<Product2>();
                            Decimal totalPrice = getTotalPriceWithAnnexesIncluded(vivienda, currProductAnnexes);
                            // Calculamos el precio minimo y contamos las viviendas que estan en estado libre para calcular el porcentaje vendido
                            if(vivienda.Estado__c == 'Libre' && vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Vivienda') {
                                if(totalPrice > 0 && (precio == null || precio > totalPrice)) precio = totalPrice;
                                viviendasVendidas++;
                            }
                            // Calculamos el numero de habitaciones, superficie max y min para mostrarlo por la web
                            if(String.isNotBlank(String.valueOf(vivienda.N_habitaciones__c)) && vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Vivienda') {
                                Integer nRooms = Integer.valueOf(vivienda.N_habitaciones__c);
                                Decimal supConstruidaAct = vivienda.Superficie_Construida_m2__c;
                                if(nMinHabitaciones == 0 || nMinHabitaciones > nRooms) nMinHabitaciones = nRooms;
                                if(nMaxHabitaciones == 0 || nMaxHabitaciones < nRooms) nMaxHabitaciones = nRooms;
                                if(superficieConstruidaMinima == 0 || superficieConstruidaMinima > supConstruidaAct) superficieConstruidaMinima = supConstruidaAct.round();
                                if(superficieConstruidaMaxima == 0 || superficieConstruidaMaxima < supConstruidaAct) superficieConstruidaMaxima = supConstruidaAct.round();
                            }
                        }
                        
                    }

                    promo.addChildElement('precio', null, null).addTextNode(precio == null ? '' : precio.format());
                    Dom.XmlNode financiada = promo.addChildElement('financiado', null, null);
                    financiada.addChildElement('texto', null, null).addTextNode(promocion.Texto_financiacion__c == null ? '' : promocion.Texto_financiacion__c);
                    promo.addChildElement('material_comercial', null, null).addTextNode('Material Comercial');
                    //Calculamos el porcentaje vendido
                    if(promocion.N_Viviendas_totales_promocion__c == null) promocion.N_Viviendas_totales_promocion__c = 0;
                    if(viviendasVendidas > 0 && promocion.N_Viviendas_totales_promocion__c > 0) {                        
                        porcentajeVendido = viviendasVendidas * 100 / promocion.N_Viviendas_totales_promocion__c;
                    } else porcentajeVendido = 0;
                    promo.addChildElement('porcentaje_vendido', null, null).addTextNode(String.valueOf(porcentajeVendido.round()) + '%');
                    promo.addChildElement('porcentaje_construido', null, null).addTextNode('');
                    promo.addChildElement('url_externa', null, null).addTextNode('');
                    promo.addChildElement('banner_listado', null, null).addTextNode('');
                    promo.addChildElement('banner_listado_alt', null, null).addTextNode('');
                    promo.addChildElement('provincia', null, null).addTextNode(promocion.Provincia__c == null ? '' : promocion.Provincia__c);
                    promo.addChildElement('localidad', null, null).addTextNode(promocion.Localidad__r.Name == null ? '' : promocion.Localidad__r.Name);
                    Dom.XmlNode carrusel = promo.addChildElement('carrusel', null, null);
                    Dom.XmlNode imagenes = carrusel.addChildElement('imagenes', null, null); 
                    //Recorremos las imagenes asociadas a la promocion
                    contentVersionsPromo = promosMapped.get(promocion.Id);
                    if(contentVersionsPromo != null) {
                        for(ContentVersion conVer: contentVersionsPromo) {
                            if(conVer.Tipo__c == 'Imagen_carrusel' || conVer.Tipo__c == 'Video_Youtube') {
                                Dom.XmlNode imagen = imagenes.addChildElement('imagen', null, null);
                                String altImg = conVer.Tipo__c == 'Video_Youtube' ? conVer.Url_Youtube__c : conVer.Title;
                                if(conVer.Tipo__c == 'Video_Youtube') {
                                    imagen.addChildElement('title', null, null).addTextNode(conVer.Url_Youtube__c);
                                    imagen.addChildElement('alt_imagen', null, null).addTextNode(altImg);
                                }
                                imagen.addChildElement('url_imagen', null, null).addTextNode(publicLinksCV.get(conVer.Id));                                
                            } else if(conVer.Tipo__c == 'Video') {
                                Dom.XmlNode imagen = imagenes.addChildElement('imagen', null, null);
                                imagen.addChildElement('url_imagen', null, null).addTextNode(publicLinksCV.get(conVer.Id));
                                imagen.addChildElement('alt_imagen', null, null).addTextNode(conVer.Title);
                            } else if(conVer.Tipo__c == 'Imagen_financiera') {
                                financiada.addChildElement('icono', null, null).addTextNode(publicLinksCV.get(conVer.Id));
                            } else if(conVer.Tipo__c == 'Folleto') {
                                listaFolletos.add(conVer);
                            } else if(conVer.Tipo__c == 'Memoria_calidades') {
                                listaMemoriaCalidades.add(conVer);
                            } else if(conVer.Tipo__c == 'Planos_zonas_comunes'){
                                listaZonasComunes.add(conVer);
                            }
                        }
                    }
                    promo.addChildElement('telefono', null, null).
                        addTextNode(promocion.Telefono_promocion_comercializadora__c == null ? '' : promocion.Telefono_promocion_comercializadora__c);
                    promo.addChildElement('email_contacto', null, null).
                        addTextNode(promocion.Email_promocion_comercializadora__c == null ? '' : promocion.Email_promocion_comercializadora__c);
                    promo.addChildElement('slogan', null, null).
                        addTextNode(promocion.Slogan__c == null ? '' : promocion.Slogan__c);
                    promo.addChildElement('titulo_h2', null, null).
                        addTextNode('DEFINICIÓN DE LA PROMOCIÓN');
                    promo.addChildElement('titulo_h3', null, null).
                        addTextNode(promocion.nombre_promocion__c == null ? '' : promocion.nombre_promocion__c);
                    //Reemplazamos los saltos de lineas por <br> para que se visualice correctamente en la web
                    String descripcion = '';
                    if(String.isNotBlank(promocion.Descripcion__c)) descripcion = promocion.Descripcion__c.replace('\n','<br>');
                    promo.addChildElement('texto_adicional', null, null).addTextNode(descripcion);
                    Dom.XmlNode caracteristicas = promo.addChildElement('caracteristicas', null, null);
                    if(promocion.Finca__c!=null){
                        caracteristicas.addChildElement('finca', null, null).addTextNode(String.valueOf(promocion.Finca__c));
                    }else{caracteristicas.addChildElement('finca', null, null);}
                    caracteristicas.addChildElement('superficie', null, null).
                        addTextNode('De ' + superficieConstruidaMinima + ' a ' + superficieConstruidaMaxima);
                    // Precio por dormitorios
                    caracteristicas.addChildElement('precio_max_1_dormitorio', null, null).addTextNode(String.valueOf(promocion.Precio_maximo_1_dormitorio__c!=null?promocion.Precio_maximo_1_dormitorio__c:0));
                    caracteristicas.addChildElement('precio_min_1_dormitorio', null, null).addTextNode(String.valueOf(promocion.Precio_minimo_1_dormitorio__c!=null?promocion.Precio_minimo_1_dormitorio__c:0));
                    caracteristicas.addChildElement('precio_min_2_dormitorios', null, null).addTextNode(String.valueOf(promocion.Precio_minimo_2_dormitorios__c!=null?promocion.Precio_minimo_2_dormitorios__c:0));
                    caracteristicas.addChildElement('precio_max_2_dormitorios', null, null).addTextNode(String.valueOf(promocion.Precio_maximo_2_dormitorios__c!=null?promocion.Precio_maximo_2_dormitorios__c:0));
                    caracteristicas.addChildElement('precio_min_3_dormitorios', null, null).addTextNode(String.valueOf(promocion.Precio_minimo_3_dormitorios__c!=null?promocion.Precio_minimo_3_dormitorios__c:0));
                    caracteristicas.addChildElement('precio_max_3_dormitorios', null, null).addTextNode(String.valueOf(promocion.Precio_maximo_3_dormitorios__c!=null?promocion.Precio_maximo_3_dormitorios__c:0));
                    caracteristicas.addChildElement('precio_min_4_dormitorios', null, null).addTextNode(String.valueOf(promocion.Precio_minimo_4_dormitorios__c!=null?promocion.Precio_minimo_4_dormitorios__c:0));
                    caracteristicas.addChildElement('precio_max_4_dormitorios', null, null).addTextNode(String.valueOf(promocion.Precio_maximo_4_dormitorios__c!=null?promocion.Precio_maximo_4_dormitorios__c:0));						

                    //Comprobamos los valores da las habitaciones
                    if(nMinHabitaciones != 0 && nMinHabitaciones == nMaxHabitaciones){
                        caracteristicas.addChildElement('dormitorios', null, null).addTextNode(nMinHabitaciones + ' dormitorios');
                    } else if(nMinHabitaciones != 0 && nMinHabitaciones != nMaxHabitaciones) {
                        caracteristicas.addChildElement('dormitorios', null, null).addTextNode('De ' + nMinHabitaciones + ' a ' + nMaxHabitaciones + ' dormitorios');
                    } else caracteristicas.addChildElement('dormitorios', null, null).addTextNode('');
            
                    caracteristicas.addChildElement('planta', null, null).
                        addTextNode(promocion.N_Plantas__c == null ? '' : String.valueOf(promocion.N_Plantas__c));
                    caracteristicas.addChildElement('total_viviendas', null, null).
                        addTextNode(promocion.N_Viviendas_totales_promocion__c == null ? '' : String.valueOf(promocion.N_Viviendas_totales_promocion__c));
                    Dom.XmlNode servicios = promo.addChildElement('servicios', null, null);
                    servicios.addChildElement('solarium', null, null).addTextNode(String.valueOf(promocion.Solarium__c).toUpperCase());
                    //servicios.addChildElement('Parques', null, null).addTextNode('FALSE');
                    servicios.addChildElement('piscina', null, null).addTextNode(String.valueOf(promocion.Piscina_Exterior__c).toUpperCase());
                    servicios.addChildElement('piscina_infantil', null, null).addTextNode(String.valueOf(promocion.Piscina_Infantil__c).toUpperCase());
                    servicios.addChildElement('zona_infantil', null, null).addTextNode(String.valueOf(promocion.Zona_Infantil__c).toUpperCase());
                    servicios.addChildElement('spa', null, null).addTextNode(String.valueOf(promocion.Spa__c).toUpperCase());
                    servicios.addChildElement('tenis', null, null).addTextNode(String.valueOf(promocion.Pistas_deportivas__c).toUpperCase());
                    servicios.addChildElement('padel', null, null).addTextNode(String.valueOf(promocion.Padel__c).toUpperCase());
                    servicios.addChildElement('jardin', null, null).addTextNode(String.valueOf(promocion.Jardines__c).toUpperCase());
                    servicios.addChildElement('gimnasio', null, null).addTextNode(String.valueOf(promocion.Gimnasio__c).toUpperCase());
                    servicios.addChildElement('terraza', null, null).addTextNode(String.valueOf(promocion.Terrazas_Mirador__c).toUpperCase());
                    servicios.addChildElement('zona_gourmet', null, null).addTextNode(String.valueOf(promocion.Zona_Gourmet__c).toUpperCase());
                    servicios.addChildElement('ascensores', null, null).addTextNode(String.valueOf(promocion.Ascensores__c).toUpperCase());
                    servicios.addChildElement('salon_social', null, null).addTextNode(String.valueOf(promocion.Sala_Multidisciplinar__c).toUpperCase());
                    servicios.addChildElement('parking', null, null).addTextNode(String.valueOf(promocion.Plaza_de_Garaje_Parking__c).toUpperCase());
                    servicios.addChildElement('trastero', null, null).addTextNode(String.valueOf(promocion.Trastero__c).toUpperCase());
                    servicios.addChildElement('chillout', null, null).addTextNode(String.valueOf(promocion.Chill_Out__c).toUpperCase());
                    servicios.addChildElement('suelo_radiante', null, null).addTextNode(String.valueOf(promocion.Suelo_Radiante__c).toUpperCase());
                    servicios.addChildElement('aerotermia', null, null).addTextNode(String.valueOf(promocion.Aerotermia__c).toUpperCase());
                    servicios.addChildElement('vestuarios', null, null).addTextNode(String.valueOf(promocion.Vestuarios_comunitarios__c).toUpperCase());
                    servicios.addChildElement('sauna', null, null).addTextNode(String.valueOf(promocion.Sauna__c).toUpperCase());
                    servicios.addChildElement('domotica', null, null).addTextNode(String.valueOf(promocion.Domotica__c).toUpperCase());
                    servicios.addChildElement('ski_room', null, null).addTextNode(String.valueOf(promocion.Ski_Room__c).toUpperCase());
                    servicios.addChildElement('energetica_a', null, null).addTextNode(String.valueOf(promocion.Calificacion_Energetica_A__c).toUpperCase());
                    servicios.addChildElement('energetica_b', null, null).addTextNode(String.valueOf(promocion.Calificacion_Energetica_B__c).toUpperCase());
                    servicios.addChildElement('recarga_coche', null, null).addTextNode(String.valueOf(promocion.Cargador_Coches_Electricos__c).toUpperCase());
                    servicios.addChildElement('buhardilla', null, null).addTextNode(String.valueOf(promocion.Buhardilla__c).toUpperCase());
                    servicios.addChildElement('hammam', null, null).addTextNode(String.valueOf(promocion.Hammam__c).toUpperCase());					

                    if(promocion.Coordenadas__Latitude__s!=null && promocion.Coordenadas__Longitude__s!=null) {
                        promo.addChildElement('coordenadas_gmaps', null, null).addTextNode(promocion.Coordenadas__Latitude__s+','+promocion.Coordenadas__Longitude__s);
                    }
                    else
                    {
                        promo.addChildElement('coordenadas_gmaps', null, null).addTextNode('');
                    }
                    dom.XmlNode mapas= promo.addChildElement('mapas', null, null);
                    mapas.addChildElement('localizacion', null, null).addTextNode(promocion.Localizacion_Google__c==null ?'' :promocion.Localizacion_Google__c);
                    mapas.addChildElement('restaurantes', null, null).addTextNode(promocion.Restaurantes__c==null ?'' :promocion.Restaurantes__c);
                    mapas.addChildElement('mercados', null, null).addTextNode(promocion.Mercados__c==null ?'' :promocion.Mercados__c);
                    mapas.addChildElement('parques', null, null).addTextNode(promocion.Parques__c==null ?'' :promocion.Parques__c);
                    mapas.addChildElement('playas', null, null).addTextNode(promocion.Playas__c==null ?'' :promocion.Playas__c);
                    mapas.addChildElement('hospital', null, null).addTextNode(promocion.Hospitales__c==null ?'' :promocion.Hospitales__c);
                    mapas.addChildElement('colegios', null, null).addTextNode(promocion.Colegios__c==null ?'' :promocion.Colegios__c);
                    mapas.addChildElement('guarderias', null, null).addTextNode(promocion.Guarderias__c==null ?'' :promocion.Guarderias__c);
                    mapas.addChildElement('deportivas', null, null).addTextNode(promocion.Deportivas__c==null ?'' :promocion.Deportivas__c);
                    mapas.addChildElement('farmacias', null, null).addTextNode(promocion.Farmacias__c==null ?'' :promocion.Farmacias__c);
                    mapas.addChildElement('centro_comercial', null, null).addTextNode(promocion.Centros_Comerciales__c==null ?'' :promocion.Centros_Comerciales__c);
                    mapas.addChildElement('golf', null, null).addTextNode(promocion.Golf__c==null ?'' :promocion.Golf__c);
                    mapas.addChildElement('puerto', null, null).addTextNode(promocion.Puerto__c==null ?'' :promocion.Puerto__c);
                    mapas.addChildElement('metro', null, null).addTextNode(promocion.Metros__c==null ?'' :promocion.Metros__c);
                    mapas.addChildElement('autobuses', null, null).addTextNode(promocion.Autobuses__c==null ?'' :promocion.Autobuses__c);
                    mapas.addChildElement('tren', null, null).addTextNode(promocion.Tren__c==null ?'' :promocion.Tren__c);
                    mapas.addChildElement('aeropuerto', null, null).addTextNode(promocion.Aeropuertos__c==null ?'' :promocion.Aeropuertos__c);
                    mapas.addChildElement('esqui', null, null).addTextNode(promocion.Estacion_Esqui__c==null ?'' :promocion.Estacion_Esqui__c);
                    mapas.addChildElement('gasolinera', null, null).addTextNode(promocion.Gasolineras__c==null ?'' :promocion.Gasolineras__c);
                    mapas.addChildElement('universidad', null, null).addTextNode(promocion.Universidades__c==null ?'' :promocion.Universidades__c); 
                    Dom.XmlNode carruselLifestyle= promo.addChildElement('lifestyle', null, null);
                    Dom.XmlNode carruselEntono= promo.addChildElement('carrusel_entorno', null, null);
                    //Recorremos las imagenes de tipo carrusel lifestyle
                    if(contentVersion != null) {
                        for(ContentVersion conVer : contentVersion) {
                            if(conVer.Tipo__c == 'Carrusel_lifestyle') {
                                if(conVer.Posicion__c != null && String.valueOf(conVer.Posicion__c).equals('1')) {
                                    Dom.XmlNode bloque1 = carruselLifestyle.addChildElement('bloque1', null, null);
                                    bloque1.addChildElement('imagen', null, null).addTextNode(publicLinksCV.get(conVer.Id));
                                    bloque1.addChildElement('titulo', null, null).addTextNode(conVer.Title == null ? '' : conVer.Title);
                                    bloque1.addChildElement('cuerpo', null, null).addTextNode(conVer.Description == null ? '' : conVer.Description);
                                } else if(conVer.Posicion__c != null && String.valueOf(conVer.Posicion__c).equals('2')) {
                                    Dom.XmlNode bloque2 = carruselLifestyle.addChildElement('bloque2', null, null);
                                    bloque2.addChildElement('imagen', null, null).addTextNode(publicLinksCV.get(conVer.Id));
                                    bloque2.addChildElement('titulo', null, null).addTextNode(conVer.Title == null ? '' : conVer.Title);
                                    bloque2.addChildElement('cuerpo', null, null).addTextNode(conVer.Description == null ? '' : conVer.Description);
                                } else if (conVer.Posicion__c != null && String.valueOf(conVer.Posicion__c).equals('3')) {
                                    Dom.XmlNode bloque3 = carruselLifestyle.addChildElement('bloque3', null, null);
                                    bloque3.addChildElement('imagen', null, null).addTextNode(publicLinksCV.get(conVer.Id));
                                    bloque3.addChildElement('titulo', null, null).addTextNode(conVer.Title == null ? '' : conVer.Title);
                                    bloque3.addChildElement('cuerpo', null, null).addTextNode(conVer.Description == null ? '' : conVer.Description);
                                }
                            } else if(conVer.Tipo__c == 'Carrusel_entorno') {
                                Dom.XmlNode item = carruselEntono.addChildElement('item', null, null);
                                item.addChildElement('imagen', null, null).addTextNode(publicLinksCV.get(conVer.Id));
                                item.addChildElement('texto_promocion', null, null).addTextNode(conVer.Description == null ? '' : conVer.Description);
                            } else if (conVer.Tipo__c == 'Pie_de_web') {
                                promo.addChildElement('url_imagen_fondo_bloque_final', null, null).addTextNode(publicLinksCV.get(conVer.Id));
                            }
                        }
                    }
                    promo.addChildElement('agrupador_tipologias', null, null).
                        addTextNode(promocion.Agrupador_de_viviendas__c == null ? '' : promocion.Agrupador_de_viviendas__c.toLowerCase());
                    Dom.XmlNode viviendasNodo = promo.addChildElement('viviendas', null, null);
                    Dom.XmlNode garajes = promo.addChildElement('garajes',null,null);
                    Dom.XmlNode trasteros=promo.addChildElement('trasteros',null,null);
                    Dom.XmlNode locales=promo.addChildElement('locales',null,null);

                    for(Product2 vivienda : viviendas) {
                    
                        Boolean isGarage = vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Garaje');
                        Boolean isStorage = vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Trastero');
                        Boolean isLocal = vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Local');
                        Boolean isVivienda = vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Vivienda');
                        
                        if(vivienda.Promocion__c == promocion.Id){
                            if(vivienda.Estado__c != 'Libre' && vivienda.WebAvinita__c) throw new GenerarXMLException('El inmueble ' + vivienda.Name + ' no está libre. No se puede realizar la publicación en la web de Avintia.');
                            if(isVivienda && vivienda.WebAvinita__c) {
                                List<Product2> currProductAnnexes = productsAnnexesMap.get(vivienda.Id);
                                // Field added to include annexes in the price generated
                                if(currProductAnnexes == null) currProductAnnexes = new List<Product2>();
                                Decimal totalPrice = getTotalPriceWithAnnexesIncluded(vivienda, currProductAnnexes);

                                Dom.XmlNode viviendaNodo = viviendasNodo.addChildElement('vivienda', null, null);
                                viviendaNodo.addChildElement('tipo_inmueble', null, null).
                                    addTextNode(vivienda.Tipologia_de_vivienda__c == null ? '' : String.valueOf(vivienda.Tipologia_de_vivienda__c));
                                viviendaNodo.addChildElement('dormitorios', null, null).
                                    addTextNode(vivienda.N_habitaciones__c == null ? '' : String.valueOf(vivienda.N_habitaciones__c));
                                viviendaNodo.addChildElement('banos', null, null).
                                    addTextNode(vivienda.N_banos__c == null ? '' : String.valueOf(vivienda.N_banos__c));
                                viviendaNodo.addChildElement('planta', null, null).
                                    addTextNode(vivienda.Piso__c == null ? '' : String.valueOf(vivienda.Piso__c));
                                viviendaNodo.addChildElement('superficie_construida', null, null).
                                    addTextNode(vivienda.SupConstTotal__c == null ? '' : vivienda.SupConstTotal__c.format());
                                Decimal superficieTotal = ((vivienda.Superficie_Terrazas_Descubiertas__c == null ? 0 : vivienda.Superficie_Terrazas_Descubiertas__c)+(vivienda.Superficie_Terrazas_Cubiertas__c==null? 0:vivienda.Superficie_Terrazas_Cubiertas__c) + (vivienda.Superficie_Jardines__c==null? 0 :vivienda.Superficie_Jardines__c));
                                viviendaNodo.addChildElement('superficie_terrazas_jardin', null, null).
                                    addTextNode(superficieTotal == null ? '' : superficieTotal.format());
                                viviendaNodo.addChildElement('precio_desde', null, null).
                                    addTextNode(totalPrice.format());
	                                if(!linkTipologia.isEmpty()) {
                                    ContentVersion cvPlanoPDF = null;
                                    ContentVersion cvPlano = null;
                                    for(ContentDocumentLink link: linkTipologia) {
                                        if(link.LinkedEntityId.equals(vivienda.id)) {
                                            for(ContentVersion contVers: contentVersionTipologia) {
                                                if(cvPlanoPDF == null && contVers.Tipo__c=='Plano_PDF' && link.ContentDocumentId.equals(contVers.ContentDocumentId)&&contVers.URL__c!=null && String.isNotBlank(contVers.URL__c) && contVers.Id!=null && String.isNotBlank(contVers.Id)){
                                                    cvPlanoPDF = contVers;
                                                } else if(cvPlanoPDF==null&&cvPlano==null&&contVers.Tipo__c=='Plano'&&link.ContentDocumentId.equals(contVers.ContentDocumentId)&&contVers.URL__c!=null && String.isNotBlank(contVers.URL__c) && contVers.Id!=null && String.isNotBlank(contVers.Id)) {
                                                    cvPlano = contVers;
                                                }
                                            }
                                        } else if(link.LinkedEntityId.equals(vivienda.Tipo_de_inmueble__c)) { 
                                            for(ContentVersion contVers: contentVersionTipologia) {
                                                if(cvPlanoPDF==null&&contVers.Tipo__c=='Plano_PDF'&&link.ContentDocumentId.equals(contVers.ContentDocumentId)&&contVers.URL__c!=null && String.isNotBlank(contVers.URL__c) && contVers.Id!=null && String.isNotBlank(contVers.Id)){
                                                    cvPlanoPDF = contVers;
                                                }else if(cvPlanoPDF==null&&cvPlano==null&&contVers.Tipo__c=='Plano'&&link.ContentDocumentId.equals(contVers.ContentDocumentId)&&contVers.URL__c!=null && String.isNotBlank(contVers.URL__c) && contVers.Id!=null && String.isNotBlank(contVers.Id)) {
                                                    cvPlano = contVers;
                                                } 
                                            }
                                        }  
                                    }
                                    if(cvPlanoPDF != null) {                                                
                                        viviendaNodo.addChildElement('url_plano', null, null).addTextNode(publicLinksCV.get(cvPlanoPDF.Id));
                                    } else if(cvPlano != null) {
                                        viviendaNodo.addChildElement('url_plano', null, null).addTextNode(publicLinksCV.get(cvPlano.Id));
                                    }
                                } else viviendaNodo.addChildElement('url_plano', null, null).addTextNode('');
                            }else if(isGarage && vivienda.WebAvinita__c && vivienda.Inmueble_asociado__c== null) {
                                List<Product2> currProductAnnexes = productsAnnexesMap.get(vivienda.Id);
                                if(currProductAnnexes == null) currProductAnnexes = new List<Product2>();
                                Decimal totalPrice = getTotalPriceWithAnnexesIncluded(vivienda, currProductAnnexes); // DATOS ESPECÍFICOS DE LOS GARAJES

                                Dom.XmlNode garaje = garajes.addChildElement('garaje', null, null);
                                garaje.addChildElement('area', null, null).
                                addTextNode(vivienda.Superficie_Construida_total_con_ZZCC_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Construida_total_con_ZZCC_m2__c));
                                garaje.addChildElement('built_area', null, null).
                                addTextNode(vivienda.Superficie_Util_Garaje_con_calles_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Util_Garaje_con_calles_m2__c));                      
                                garaje.addChildElement('living_area', null, null).
                                addTextNode(vivienda.Superficie_Util_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Util_m2__c));    
                                garaje.addChildElement('precio_desde', null, null).
                                    addTextNode(totalPrice.format());

                            } else if(isStorage && vivienda.WebAvinita__c && vivienda.Inmueble_asociado__c== null) { 
                                List<Product2> currProductAnnexes = productsAnnexesMap.get(vivienda.Id);
                                if(currProductAnnexes == null) currProductAnnexes = new List<Product2>();
                                Decimal totalPrice = getTotalPriceWithAnnexesIncluded(vivienda, currProductAnnexes);// DATOS ESPECÍFICOS DE LOS TRASTEROS
                                Dom.XmlNode trastero = trasteros.addChildElement('trastero', null, null);
                                trastero.addChildElement('area', null, null).
                                addTextNode(vivienda.Superficie_Construida_total_con_ZZCC_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Construida_total_con_ZZCC_m2__c));
                                trastero.addChildElement('built_area', null, null).
                                addTextNode(vivienda.Superficie_Util_Trastero_con_pasillos_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Util_Trastero_con_pasillos_m2__c));                      
                                trastero.addChildElement('living_area', null, null).
                                addTextNode(vivienda.Superficie_Util_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Util_m2__c));   
                                trastero.addChildElement('precio_desde', null, null).
                                    addTextNode(totalPrice.format());   
                            }
                            else if(isLocal && vivienda.WebAvinita__c && vivienda.Inmueble_asociado__c== null) {
                                List<Product2> currProductAnnexes = productsAnnexesMap.get(vivienda.Id);
                                Dom.XmlNode localNodo = locales.addChildElement('local', null, null);
                                localNodo.addChildElement('planta', null, null).
                                    addTextNode(vivienda.Piso__c == null ? '0' : String.valueOf(vivienda.Piso__c));
                                localNodo.addChildElement('superficie_construida', null, null).
                                    addTextNode(vivienda.SupConstTotal__c == null ? '' : vivienda.SupConstTotal__c.format());
                                
                                if(currProductAnnexes == null) currProductAnnexes = new List<Product2>();
                                Decimal totalPrice = getTotalPriceWithAnnexesIncluded(vivienda, currProductAnnexes);
                                localNodo.addChildElement('precio_desde', null, null).
                                    addTextNode(totalPrice.format());
                                if(!linkTipologia.isEmpty()) {
                                    ContentVersion cvPlanoPDF = null;
                                    ContentVersion cvPlano = null;
                                    for(ContentDocumentLink link: linkTipologia) {
                                        system.debug(link.LinkedEntityId + '  |  ' + vivienda.id);
                                        if(link.LinkedEntityId.equals(vivienda.id)) {
                                            for(ContentVersion contVers: contentVersionTipologia) {
                                                if(cvPlanoPDF == null && contVers.Tipo__c=='Plano_PDF' && link.ContentDocumentId.equals(contVers.ContentDocumentId)&&contVers.URL__c!=null && String.isNotBlank(contVers.URL__c) && contVers.Id!=null && String.isNotBlank(contVers.Id)){
                                                    cvPlanoPDF = contVers;
                                                } else if(cvPlanoPDF==null&&cvPlano==null&&contVers.Tipo__c=='Plano'&&link.ContentDocumentId.equals(contVers.ContentDocumentId)&&contVers.URL__c!=null && String.isNotBlank(contVers.URL__c) && contVers.Id!=null && String.isNotBlank(contVers.Id)) {
                                                    cvPlano = contVers;
                                                }
                                            }
                                        } else if(link.LinkedEntityId.equals(vivienda.Tipo_de_inmueble__c)) { 
                                            for(ContentVersion contVers: contentVersionTipologia) {
                                                if(cvPlanoPDF==null&&contVers.Tipo__c=='Plano_PDF'&&link.ContentDocumentId.equals(contVers.ContentDocumentId)&&contVers.URL__c!=null && String.isNotBlank(contVers.URL__c) && contVers.Id!=null && String.isNotBlank(contVers.Id)){
                                                    cvPlanoPDF = contVers;
                                                }else if(cvPlanoPDF==null&&cvPlano==null&&contVers.Tipo__c=='Plano'&&link.ContentDocumentId.equals(contVers.ContentDocumentId)&&contVers.URL__c!=null && String.isNotBlank(contVers.URL__c) && contVers.Id!=null && String.isNotBlank(contVers.Id)) {
                                                    cvPlano = contVers;
                                                }
                                            }
                                        }  
                                    }
                                    if(cvPlanoPDF != null) {                                                
                                        localNodo.addChildElement('url_plano', null, null).addTextNode(publicLinksCV.get(cvPlanoPDF.Id));
                                    } else if(cvPlano != null) {
                                        localNodo.addChildElement('url_plano', null, null).addTextNode(publicLinksCV.get(cvPlano.Id));
                                    }
                                } else localNodo.addChildElement('url_plano', null, null).addTextNode('');
                            }
                        } 
                    }             
                    promo.addChildElement('url_imagen_fondo_descargas', null, null).addTextNode('');
					//Mostramos las URL de los folletos
                    if(!listaFolletos.isEmpty()) {
                        promo.addChildElement('descargables_descargable_folleto', null, null).addTextNode(publicLinksCV.get(listaFolletos.get(0).Id));
                    } else {
                        promo.addChildElement('descargables_descargable_folleto', null, null).addTextNode('');
                    }
                    //Mostramos las URL de los Memoria de Calidades
                    if(!listaMemoriaCalidades.isEmpty()) { 
                        promo.addChildElement('descargables_descargable_memoria', null, null).addTextNode(publicLinksCV.get(listaMemoriaCalidades.get(0).Id));
                    } else {
                        promo.addChildElement('descargables_descargable_memoria', null, null).addTextNode('');
                    }
                    //Mostramos las URL de los Planos de las Zonas Comunes
                    if(!listaZonasComunes.isEmpty()) {
                        promo.addChildElement('descargables_descargable_planos', null, null).addTextNode(publicLinksCV.get(listaZonasComunes.get(0).Id));
                    } else {
                        promo.addChildElement('descargables_descargable_planos', null, null).addTextNode('');
                    }
					
                    promo.addChildElement('lifestyle_url_imagen1', null, null).addTextNode('');
                    promo.addChildElement('lifestyle_texto_1', null, null).addTextNode('');
                    promo.addChildElement('lifestyle_url_imagen2', null, null).addTextNode('');
                    promo.addChildElement('lifestyle_texto_2', null, null).addTextNode('');
                    promo.addChildElement('lifestyle_url_imagen3', null, null).addTextNode('');
                    promo.addChildElement('lifestyle_texto_3', null, null).addTextNode('');
                    promo.addChildElement('slogan_bloque_final', null, null).addTextNode(promocion.Slogan_Final_Web__c==null? '':promocion.Slogan_Final_Web__c );
                    promo.addChildElement('entradilla_web', null, null).addTextNode(promocion.Descripcion_final_Web__c==null? '':promocion.Descripcion_final_Web__c );
                }
				System.debug(doc.toXmlString());
                Blob blobMensaje = Blob.valueOf(doc.toXmlString());	
                mensaje = Utils.blobToString(blobMensaje,'UTF-8');	
            }	
        } catch( Exception ex ) {	
            System.debug('Error al generar el XML de envio a la WEB de AVINTIA'+ ex + ex.getLineNumber());	
            mensaje='KO';	
            throw new GenerarXMLException(ex.getMessage());     	
        }
        return mensaje;	
     }
    
    /*public static string devolverURLDocumentoFotocasa(String URL, String versionId, String tipo) {	
        PropiedadesIntegracion__c propiedades = PropiedadesIntegracion__c.getInstance();	
        String URLFinal = '';	
        if(String.isNotBlank(URL) && String.isNotBlank(versionId)) {	
            URLFinal = '<![CDATA['+propiedades.URLDocuemntos__c+tipo+'&versionId='+versionId+'&oid='+UserInfo.getOrganizationId().substring(0,UserInfo.getOrganizationId().length()-3)+'&d='+ url.substring((url.indexOf(UserInfo.getOrganizationId().substring(3,UserInfo.getOrganizationId().length()-3))+UserInfo.getOrganizationId().length()-6),url.length())+']]>';	
        }	
        return URLFinal;	
    }*/	
     public static string  generarFotocasa(ID PromoId) {	
        //System.debug ('Procedemos a generar el XML de envío de Fotocasa');	
        Set<id> setContentDocumentTipologia = new Set<id>();	
        List<ContentDocumentLink> linkTipologia = null;	
        List<ContentVersion> contentVersionTipologia = null;
        string mensaje = '';	
        /*try {	
            // Promociones	
            List<Promocion__c> promociones = [SELECT Id,Nombre_Comercial_Avintia_Inmobiliaria__c,Localidad__c, Localidad__r.Codigo_municipio__c,Provincia__c,	
                                              Localidad__r.Provincia__r.Codigo__c,Pais__c,Pais__r.Codigo_ISO3_num__c,Descricion_pequena__c,	
                                              Slogan__c,Descripcion__c,Tipo_via__c, Nombre_via__c,N_Via__c,Codigo_postal__c,	
                                              Telefono_promocion_comercializadora__c,Email_promocion_comercializadora__c,Superficie_total_de_parcela__c,	
                                              N_Plantas__c,N_Viviendas_totales_promocion__c, Piscina_Exterior__c,Zona_Infantil__c,Spa__c,	
                                              Pistas_deportivas__c,Padel__c,Jardines__c,Gimnasio__c,Terrazas_Mirador__c,Zona_Gourmet__c,	
                                              Ascensores__c,Sala_Multidisciplinar__c,Coordenadas__Latitude__s,Coordenadas__Longitude__s,	
                                              Restaurantes__c,Mercados__c,Parques__c,Playas__c,Localizacion_Google__c,Agrupador_de_viviendas__c,	
                                              Slogan_Final_Web__c,Descripcion_final_Web__c,Texto_financiacion__c ,Constructora__r.Name,	
                                              Socio_Empresa_Promotora__r.Name, Socio_Empresa_Comercializadora__r.Name 	
                                              FROM Promocion__c 	
                                              WHERE Fotocasa__c = true];	
            Set<Id> setPromociones = new Set<Id>();	
            for (Promocion__C promo: promociones) setPromociones.add(promo.ID);	
            // Inmuebles	
            List<Product2> viviendas = [SELECT Id, Promocion__c, Description, Name, Precio__c, Planta__c, Estado__c, Tipologia_Vivienda_Garaje_Trastero_Local__c,	
                                        Tipo_de_inmueble__c, N_habitaciones__c, N_banos__c, Superficie_Construida_m2__c, Superficie_Terrazas_Descubiertas__c,	
                                        Superficie_Terrazas_Cubiertas__c, Superficie_Jardines__c, Piso__c, Fotocasa__c, Tipologia_de_vivienda__c,	
                                        Superficie_Construida_total_con_ZZCC_m2__c, SupConstTotal__c, Superficie_Util_Trastero_con_pasillos_m2__c, Superficie_Util_m2__c, 	
                                        Superficie_Util_Garaje_con_calles_m2__c, Inmueble_asociado__c, Certificado_de_eficiencia_energetica__c, Precio_con_anejos_incluidos__c	
                                        FROM Product2 	
                                        WHERE Promocion__c IN :setPromociones AND Inmueble_asociado__c = null AND 	
                                        Fotocasa__c = true];
            Map<Id, List<Product2>> promosInmueblesMap = new Map<Id, List<Product2>>();
            system.debug('TEST Fotocasa: ' + viviendas.size());
            for(Product2 inmueble : viviendas) {	
                List<Product2> inms = promosInmueblesMap.get(inmueble.Promocion__c);	
                if(inms == null) inms = new List<Product2>();	
                inms.add(inmueble);	
                promosInmueblesMap.put(inmueble.Promocion__c, inms);	
            }	
            // Anejos	
            Map<Id, List<Product2>> productsAnnexesMap = new Map<Id, List<Product2>>();	
            List<Product2> annexes = [SELECT Id, Precio__c, Inmueble_asociado__c, Tipologia_Vivienda_Garaje_Trastero_Local__c 	
                                      FROM Product2 	
                                      WHERE Promocion__c IN :setPromociones AND Inmueble_asociado__c != null AND 	
                                      Inmueble_asociado__r.Fotocasa__c = true];	
            for(Product2 annexe : annexes) {	
                List<Product2> currAnnexesList = productsAnnexesMap.get(annexe.Inmueble_asociado__c);	
                if(currAnnexesList == null) currAnnexesList = new List<Product2>();	
                currAnnexesList.add(annexe);	
                productsAnnexesMap.put(annexe.Inmueble_asociado__c, currAnnexesList);	
            }	
            // Obtenemos las imagenes de las promociones	
            List<ContentDocumentLink> linkPromocion= new List<ContentDocumentLink>();	
            Map<Id,List<ContentVersion>> promosDocsMap= new Map<Id, List<ContentVersion>>();	
            Map<Id, Id> docPromosIdsMap = new Map<Id, Id>();	
            if(!setPromociones.isEmpty()) {	
                linkPromocion = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId in: setPromociones ];	
                for(ContentDocumentLink cdl : linkPromocion) {	
                    //setContentDocument.add(cdl.contentDocumentId);	
                    docPromosIdsMap.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
                }	
                	
                List<ContentVersion> contentVersion = ([SELECT id, Title, Description, Posicion__c, ContentDocumentId, URL__c,	
                                                        Tipo__c, FileType, Url_Youtube__c	
                                                        FROM ContentVersion	
                                                        WHERE ContentDocumentId IN :docPromosIdsMap.keySet() AND 	
                                                        (Tipo__c = 'Imagen_carrusel' OR Tipo__c = 'Memoria_calidades'	
                                                         OR Tipo__c = 'Video' OR Tipo__c = 'Video_Youtube') AND 	
                                                        IsLatest = true]);	
                for(ContentVersion doc : contentVersion) {	
                    List<ContentVersion> docsList = promosDocsMap.get(docPromosIdsMap.get(doc.ContentDocumentId));	
                    if(docsList == null) docsList = new List<ContentVersion>();	
                    docsList.add(doc);	
                    promosDocsMap.put(docPromosIdsMap.get(doc.ContentDocumentId), docsList);	
                }	
            }
			
            // Anejos	
            // Preparamos para obtener las imagenes de inmuebles y sus planos	
            Map<Id, Product2> productsMap = new Map<Id, Product2>(viviendas);	
            Set<Id> setTipologias = new Set<Id>();	
            for(Product2 vivTipologia : viviendas) setTipologias.add(vivTipologia.Tipo_de_inmueble__c);	
            // Planos de sus tipologías	
            List<ContentDocumentLink> typesDocsLinks = [SELECT Id, LinkedEntityId, 	
                                                        ContentDocument.LatestPublishedVersion.FileType, 	
                                                        ContentDocument.LatestPublishedVersion.Title, 	
                                                        ContentDocument.LatestPublishedVersion.Promocion__c, 	
                                                        ContentDocument.LatestPublishedVersion.Posicion__c, 	
                                                        ContentDocument.LatestPublishedVersion.URL__c 	
                                                        FROM ContentDocumentLink 	
                                                        WHERE LinkedEntityId IN :setTipologias AND ContentDocument.LatestPublishedVersion.Tipo__c = 'Plano'];	
            Map<Id, ContentDocumentLink> productTypesDocsLinksMap = new Map<Id, ContentDocumentLink>();	
            for(ContentDocumentLink link : typesDocsLinks) {	
                productTypesDocsLinksMap.put(link.LinkedEntityId, link);	
            }
	            // Imagenes y planos de los inmuebles	
            Map<Id, List<ContentDocumentLink>> inmueblesDocsMap = new Map<Id, List<ContentDocumentLink>>();	
            List<ContentDocumentLink> productsContentsLinks = [SELECT Id, ContentDocumentId, LinkedEntityId, 	
                                                            ContentDocument.LatestPublishedVersion.FileType, 	
                                                            ContentDocument.LatestPublishedVersion.Title, 	
                                                            ContentDocument.LatestPublishedVersion.Tipo__c, 	
                                                            ContentDocument.LatestPublishedVersion.Promocion__c, 	
                                                            ContentDocument.LatestPublishedVersion.Posicion__c, 	
                                                            ContentDocument.LatestPublishedVersion.URL__c 	
                                                            FROM ContentDocumentLink 	
                                                            WHERE LinkedEntityId IN :productsMap.keySet() AND 	
                                                            (ContentDocument.LatestPublishedVersion.Tipo__c = 'Plano' OR 	
                                                            ContentDocument.LatestPublishedVersion.Tipo__c = 'Imagen_carrusel')];	
            // Definimos el mapa de qué productos tienen plano y cuales no	
            Map<Id, Boolean> hasMapMap = new Map<Id, Boolean>();	
            for(ContentDocumentLink link : productsContentsLinks) {	
                if(!hasMapMap.containsKey(link.LinkedEntityId)) hasMapMap.put(link.LinkedEntityId, false);	
                if(link.ContentDocument.LatestPublishedVersion.Tipo__c == 'Plano') hasMapMap.put(link.LinkedEntityId, true);	
            }	
            // Creamos el mapa id de producto con lista de documentos	
            for(ContentDocumentLink link : productsContentsLinks) {	
                List<ContentDocumentLink> docsList = inmueblesDocsMap.get(link.LinkedEntityId);	
                if(docsList == null) docsList = new List<ContentDocumentLink>();	
                docsList.add(link);	
                inmueblesDocsMap.put(link.LinkedEntityId, docsList);	
            }	
            // A los productos que no tenian plano le metemos el plano de su tipo	
            for(Id productId : hasMapMap.keySet()) {	
                Boolean hasMap = hasMapMap.get(productId) == true;	
                if(!hasMap) {	
                    List<ContentDocumentLink> docsList = inmueblesDocsMap.get(productId);	
                    if(docsList == null) docsList = new List<ContentDocumentLink>();	
                    ContentDocumentLink doc = productTypesDocsLinksMap.get(productsMap.get(productId).Tipo_de_inmueble__c);	
                    docsList.add(doc);	
                    inmueblesDocsMap.put(productId, docsList);	
                }	
            }	
            	
            String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
            String xsd = 'http://www.w3.org/2001/XMLSchema';	
	        String xsd1 = 'http://tempuri.org/AdDevelopment.xsd';	
            DOM.Document doc = new DOM.Document();	
            Dom.XmlNode adDevelopment= doc.createRootElement('AdDevelopment',null, null);	
            adDevelopment.setNamespace('xsi', xsi);	
            adDevelopment.setNamespace('xsd', xsd);	
            adDevelopment.setNamespace('', xsd1);	
            	
            for(Promocion__c promocion : promociones) {	
                Decimal minPrecio=0;	
                Decimal maxPrecio=0;	
                Integer nMinHabitaciones=0;	
                Integer nMaxHabitaciones=0;	
                Decimal superficieMin=0;	
                Decimal superficieMax=0;	
                // Nodo Development	
                Dom.XmlNode development= adDevelopment.addChildElement('Development', null, null);	
                development.addChildElement('TitleAd',null,null).	
                    addTextNode(String.isBlank(promocion.Nombre_Comercial_Avintia_Inmobiliaria__c) ? '' : promocion.Nombre_Comercial_Avintia_Inmobiliaria__c);	
                development.addChildElement('DescriptionAd',null,null).	
                    addTextNode(promocion.Descripcion__c == null ? '' : promocion.Descripcion__c);	
                development.addChildElement('DateRegister',null,null).	
                    addTextNode((String.valueOf(Date.today()))+'T00:00:00');	
                development.addChildElement('DateExpiry',null,null).	
                    addTextNode('');	
                // Nodo Development.ContactList	
                Dom.XmlNode contactList= development.addChildElement('ContactList', null, null);	
                integer cont = 0;	
                if(!String.isBlank(promocion.Email_promocion_comercializadora__c)) {	
                    cont++;	
                    Dom.XmlNode contact= contactList.addChildElement('Contact', null, null);	
                    contact.addChildElement('TypeId',null,null).addTextNode('1');	
                    contact.addChildElement('Value',null,null).addTextNode(promocion.Email_promocion_comercializadora__c==null?'':promocion.Email_promocion_comercializadora__c);	
                    contact.addChildElement('Show',null,null).addTextNode('true');	
                    contact.addChildElement('Order',null,null).addTextNode(String.valueOf(cont));	
                }
                if(!String.isBlank(promocion.Telefono_promocion_comercializadora__c)) {	
                    cont++;	
                    Dom.XmlNode contact2= contactList.addChildElement('Contact', null, null);	
                    contact2.addChildElement('TypeId', null, null).addTextNode('2');	
                    contact2.addChildElement('Value', null, null).addTextNode(promocion.Telefono_promocion_comercializadora__c == null ? '' : promocion.Telefono_promocion_comercializadora__c.replace(' ' ,''));	
                    contact2.addChildElement('Show', null, null).addTextNode('true');	
                    contact2.addChildElement('Order', null, null).addTextNode(String.valueOf(cont));	
                }	
                	
                // Nodo Development.Locations	
                Dom.XmlNode locations = development.addChildElement('Locations', null, null);	
                locations.addChildElement('ZIPCode', null, null).addTextNode(promocion.Codigo_postal__c == null ? '' : promocion.Codigo_postal__c);	
                Dom.XmlNode locationList = locations.addChildElement('LocationList', null, null);	
                if(promocion.Pais__c!=null && String.isNotBlank(promocion.Pais__c)) {	
                    Dom.XmlNode locationPais = locationList.addChildElement('Location', null, null);	
                    locationPais.addChildElement('Value',null,null).addTextNode(promocion.Pais__r.Codigo_ISO3_num__c==null? '':String.valueOf(promocion.Pais__r.Codigo_ISO3_num__c));	
                    locationPais.addChildElement('TypeId',null,null).addTextNode('1');	
                }	
                if(promocion.Provincia__c!=null && String.isNotBlank(promocion.Provincia__c)) {	
                    Dom.XmlNode locationProvincia = locationList.addChildElement('Location', null, null);	
                    locationProvincia.addChildElement('Value', null, null).	
                            addTextNode(promocion.Localidad__r.Provincia__r.Codigo__c == null ? '': String.valueOf(promocion.Localidad__r.Provincia__r.Codigo__c));	
                    locationProvincia.addChildElement('TypeId', null, null).	
                            addTextNode('2');	
                }	
                if(String.isNotBlank(promocion.Localidad__c)) {	
                    String codigoMunicipio=String.valueOf(promocion.Localidad__r.Codigo_municipio__c);	
                    if(promocion.Pais__r.Codigo_ISO3_num__c == 724) { // España	
                        codigoMunicipio = String.valueOf(promocion.Localidad__r.Provincia__r.Codigo__c) + codigoMunicipio.leftPad(3, '0');
                    }	
                    Dom.XmlNode locationLocalidad= locationList.addChildElement('Location', null, null);	
                    locationLocalidad.addChildElement('Value', null, null).addTextNode(codigoMunicipio);	
                    locationLocalidad.addChildElement('TypeId', null, null).addTextNode('3');	
                }	
                development.addChildElement('CustomerId', null, null).addTextNode('0');	
                development.addChildElement('LanguageId', null, null).addTextNode('2');	
                development.addChildElement('CustomerRef', null, null).addTextNode(promocion.Id);	
                development.addChildElement('InternetId', null, null).addTextNode('0');	
                //Recorremos las imagenes asociadas a la promocion	
                Dom.XmlNode mediaList= development.addChildElement('MediaList', null, null);	
                if(promosDocsMap.get(promocion.Id) != null) {	
                    Integer ordenImagen = 0;	
                    Integer ordenVideo = 0;	
                    Integer ordenMcalidades = 0;	
                	
                    for(ContentVersion conVer : promosDocsMap.get(promocion.Id)) {	
                        String order = '';	
                        String dictionaryId = '';	
                        if(conVer.Tipo__c == 'Imagen_carrusel') {	
                            ordenImagen++;	
                            order = String.valueOf(ordenImagen);	
                            dictionaryId = '7';	
                        } else if(conVer.Tipo__c == 'Video') {	
                            System.debug('Hay un video de tipo: ' + conVer.Tipo__c);	
                            ordenVideo++;	
                            order = String.valueOf(ordenVideo);	
                            dictionaryId = '10';	
                        } else if(conVer.Tipo__c == 'Memoria_calidades') {	
                            ordenMcalidades++;	
                            order = String.valueOf(ordenMcalidades);	
                            dictionaryId = '4';	
                        }  else if(conVer.Tipo__c == 'Video_Youtube') {	
                            ordenVideo++;	
                            order = String.valueOf(ordenVideo);	
                            dictionaryId = '21';	
                        }	
                        Dom.XmlNode media= mediaList.addChildElement('Media', null, null);	
                        media.addChildElement('Name', null, null).addTextNode(conVer.Title == null ? '' : conVer.Title );
	                        if(conVer.Tipo__c == 'Video_Youtube'){	
                            media.addChildElement('Url', null, null).addTextNode('https://www.youtube.com/watch?v='+conVer.Url_Youtube__c);	
                            System.debug('Media: ' + media);	
                        }	
                        else{	
                            media.addChildElement('Url', null, null).addTextNode(getPublicLinkCV(conVer));                            	
                        }	
                        media.addChildElement('DictionaryId', null, null).addTextNode(dictionaryId);	
                        media.addChildElement('Order', null, null).addTextNode(order);        	
                    }	
                }	
                development.addChildElement('ExternalURL',null,null).addTextNode('');	
                development.addChildElement('DevelopmentTypeId',null,null).addTextNode('');	
                development.addChildElement('Street',null,null).addTextNode((promocion.Tipo_via__c==null ?'' :promocion.Tipo_via__c)+ ' ' + (promocion.Nombre_via__c==null ?'' :promocion.Nombre_via__c));	
                development.addChildElement('StreetNumber',null,null).addTextNode((promocion.N_Via__c==null ?'' :String.valueOf(promocion.N_Via__c)));	
                development.addChildElement('ShowStreetNumber',null,null).addTextNode('true');	
                development.addChildElement('Zone',null,null).addTextNode('');	
                development.addChildElement('ShowZone',null,null).addTextNode('false');	
                development.addChildElement('X',null,null).addTextNode(promocion.Coordenadas__Longitude__s==null ? '' :String.valueOf(promocion.Coordenadas__Longitude__s));	
                development.addChildElement('Y',null,null).addTextNode(promocion.Coordenadas__Latitude__s==null ?'' : String.valueOf(promocion.Coordenadas__Latitude__s));	
                development.addChildElement('Web',null,null).addTextNode('');	
                development.addChildElement('ShowWeb',null,null).addTextNode('false');	
                List<Product2> promoProducts = promosInmueblesMap.get(promocion.Id);	
                if(promoProducts == null) promoProducts = new List<Product2>();	
                // Calculamos mínimos y máximos de la promoción actual	
                for(Product2 vivienda : promoProducts) {
                    if(vivienda.Estado__c == 'Libre') {	
                        Boolean isBuilding = vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Vivienda');	
                        Boolean isGarage = vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Garaje');	
                        Boolean isStorage = vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Trastero');	
                        if(!isGarage && !isStorage) {	
                            List<Product2> currProductAnnexes = productsAnnexesMap.get(vivienda.Id);	
                            Decimal priceTotal = getTotalPriceWithAnnexesIncluded(vivienda, currProductAnnexes);	
                            // Calculamos precio mínimo y máximo	
                            if(priceTotal > 0 && isBuilding) {	
                                if(minPrecio == 0 || minPrecio > priceTotal) minPrecio = priceTotal;	
                                if(maxPrecio == 0 || maxPrecio < priceTotal) maxPrecio = priceTotal;   	
                            }	
                            // Calculamos nº habitaciones min y max	
                            if(vivienda.N_habitaciones__c > 0 && isBuilding) {	
                                Integer nRooms = Integer.valueOf(vivienda.N_habitaciones__c);	
                                if(nMinHabitaciones == 0 || nMinHabitaciones > nRooms) nMinHabitaciones = nRooms;	
                                if(nMaxHabitaciones == 0 || nMaxHabitaciones < nRooms) nMaxHabitaciones = nRooms;	
                            }	
                        }	
                    }	
                }	
                development.addChildElement('MinPrice', null, null).addTextNode(String.valueOf(minPrecio));	
                development.addChildElement('MaxPrice', null, null).addTextNode(String.valueOf(maxPrecio));	
                development.addChildElement('MinRentPrice', null, null).addTextNode('0');	
                development.addChildElement('MaxRentPrice', null, null).addTextNode('0');	
                development.addChildElement('MinRooms', null, null).addTextNode(String.valueOf(nMinHabitaciones));	
                development.addChildElement('MaxRooms', null, null).addTextNode(String.valueOf(nMaxHabitaciones));	
                development.addChildElement('MinSurface', null, null).addTextNode(String.valueOf(superficieMin));	
                development.addChildElement('MaxSurface', null, null).addTextNode(String.valueOf(superficieMax));	
                development.addChildElement('BuildingSpecifications', null, null).addTextNode('');	
                development.addChildElement('DeliveryDate', null, null).addTextNode('');	
                development.addChildElement('PaymentMode', null, null).addTextNode('');	
                development.addChildElement('Financing', null, null).addTextNode('');
                development.addChildElement('ConstructionCompany', null, null).addTextNode(promocion.Constructora__r.Name==null? '' :promocion.Constructora__r.Name);	
                development.addChildElement('LogoUrl', null, null).addTextNode('');	
                development.addChildElement('PromotedBy', null, null).addTextNode(promocion.Socio_Empresa_Promotora__r.Name==null? '' :promocion.Socio_Empresa_Promotora__r.Name);	
                development.addChildElement('MarketedBy', null, null).addTextNode(promocion.Socio_Empresa_Comercializadora__r.Name==null? '' :promocion.Socio_Empresa_Comercializadora__r.Name);	
                dom.XmlNode advertisementList= development.addChildElement('AdvertisementList', null, null);	
                //Recorremos las viviendas asociadas a la promocion	
                for(Product2 vivienda : promoProducts) {	
                    if(vivienda.Estado__c != 'Libre') throw new GenerarXMLException('El inmueble ' + vivienda.Name + ' no está libre. No se puede realizar la publicación en Fotocasa.');	
                    Boolean isBuilding = vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Vivienda');	
                    Boolean isGarage = vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Garaje');	
                    Boolean isStorage = vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Trastero');	
                    if((!isGarage && !isStorage) && vivienda.Fotocasa__c) {	
                        Dom.XmlNode advertisement= advertisementList.addChildElement('Advertisement', null, null);	
                        advertisement.addChildElement('TitleAd',null,null).addTextNode(vivienda.Name == null ? '' : vivienda.Name);	
                        advertisement.addChildElement('DescriptionAd',null,null).addTextNode(vivienda.Description==null?'':vivienda.Description);	
                        advertisement.addChildElement('CustomerRef',null,null).addTextNode(vivienda.ID);	
                        advertisement.addChildElement('InternetId',null,null).addTextNode('0');	
                        Dom.XmlNode mediaListVivienda = advertisement.addChildElement('MediaList', null, null);	
                        if(isBuilding) {	
                            // Imagenes	
                            if(inmueblesDocsMap.get(vivienda.Id) != null) {	
                                Integer contador = 0;	
                                for(ContentDocumentLink docLink : inmueblesDocsMap.get(vivienda.Id)) {	
                                    contador++;	
                                    Dom.XmlNode mediaVivienda = mediaListVivienda.addChildElement('Media', null, null);	
                                    mediaVivienda.addChildElement('Name', null, null).
                                            addTextNode(docLink.ContentDocument.LatestPublishedVersion.Title == null? '' : docLink.ContentDocument.LatestPublishedVersion.Title);	
                                    mediaVivienda.addChildElement('Url', null, null).	
                                            addTextNode(devolverURLDocumentoFotocasa(docLink.ContentDocument.LatestPublishedVersion.URL__c, docLink.ContentDocument.LatestPublishedVersion.Id, docLink.ContentDocument.LatestPublishedVersion.FileType));	
                                    mediaVivienda.addChildElement('DictionaryId', null, null).	
                                            addTextNode('7'); 	
                                    mediaVivienda.addChildElement('Order', null, null).	
                                            addTextNode(String.valueOf(contador));	
                                }	
                            }	
                        }	
                        // Datos de transacción                        	
                        List<Product2> currProductAnnexes = productsAnnexesMap.get(vivienda.Id);	
                        Decimal totalPrice = getTotalPriceWithAnnexesIncluded(vivienda, currProductAnnexes);	
                        advertisement.addChildElement('ExternalURL', null, null).addTextNode('');	
                        Dom.XmlNode priceList= advertisement.addChildElement('PriceList', null, null);	
                        Dom.XmlNode price= priceList.addChildElement('Price', null, null);	
                        price.addChildElement('TransactionId', null, null).addTextNode('1');	
                        price.addChildElement('CurrencyId', null, null).addTextNode('1');	
                        price.addChildElement('PriceValue', null, null).addTextNode(String.valueOf(Integer.valueOf(totalPrice)));	
                        price.addChildElement('Negotiable', null, null).addTextNode('false');	
                        price.addChildElement('Order', null, null).addTextNode('1');	
                        price.addChildElement('Recurrence', null, null).addTextNode('0');	
                        price.addChildElement('Description', null, null).addTextNode('0');	
                        if(isBuilding) { // Es vivienda	
                            if(String.isNotBlank(vivienda.Planta__c)) {	
                                String floor;	
                                if(vivienda.Tipologia_de_vivienda__c == 'Bajo') floor = '3';	
                                else if(vivienda.Tipologia_de_vivienda__c == 'Chalet') floor = '5';	
                                else if(vivienda.Tipologia_de_vivienda__c == 'Ático') floor = '22';
                                else {	
                                    Integer piso = Integer.valueOf(vivienda.Planta__c);	
                                    floor = piso <= 15 ? String.valueOf(piso + 5) : '21';	
                                }	
                                advertisement.addChildElement('Floor', null, null).addTextNode(floor);	
                            }	
                            // Datos detalle inmueble 	
                            advertisement.addChildElement('NRooms',null,null).addTextNode(vivienda.N_habitaciones__c==null?'' :String.valueOf(vivienda.N_habitaciones__c));	
                            advertisement.addChildElement('RoomsDescription',null,null).addTextNode('');	
                            advertisement.addChildElement('NBathrooms',null,null).addTextNode(vivienda.N_banos__c==null?'': String.valueOf(vivienda.N_banos__c));	
                            advertisement.addChildElement('BathroomsDescription',null,null).addTextNode('');	
                            advertisement.addChildElement('NDoubleRooms',null,null).addTextNode('');	
                            advertisement.addChildElement('NToilettes',null,null).addTextNode('0');	
                            advertisement.addChildElement('BuildingTypeId',null,null).addTextNode('2');	
                            String houseTypeId = '';	
                            if(vivienda.Tipologia_de_vivienda__c == 'Piso') houseTypeId = '1';	
                            else if(vivienda.Tipologia_de_vivienda__c == 'Chalet') houseTypeId = '3';	
                            else if(vivienda.Tipologia_de_vivienda__c == 'Bajo') houseTypeId = '52';	
                            else if(vivienda.Tipologia_de_vivienda__c == 'Ático') houseTypeId = '6';	
                            else houseTypeId = '31';	
                            advertisement.addChildElement('HouseTypeId', null, null).addTextNode(houseTypeId);	
                            // Conteo de anejos	
                            Integer numPlazasGaraje = 0;	
                            Boolean trastero = false;	
                            if(currProductAnnexes != null) {	
                                for(Product2 anejo : currProductAnnexes) {	
                                    if(anejo.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Garaje') numPlazasGaraje++;	
                                    else if(anejo.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Trastero') trastero = true;	
                                }	
                            }

	                            // Extras de la vivienda	
                            Dom.XmlNode extras = advertisement.addChildElement('Extras', null, null);	
                            if(promocion.Piscina_Exterior__c) extras.addChildElement('AccessoryId', null, null).addTextNode('17');                    	
                            if(promocion.Zona_Infantil__c) extras.addChildElement('AccessoryId', null, null).addTextNode('83');	
                            if(promocion.Pistas_deportivas__c || promocion.Padel__c) extras.addChildElement('AccessoryId', null, null).addTextNode('82');	
                            if(promocion.Jardines__c) extras.addChildElement('AccessoryId', null, null).addTextNode('7');	
                            if(promocion.Gimnasio__c) extras.addChildElement('AccessoryId', null, null).addTextNode('42'); 	
                            if(promocion.Terrazas_Mirador__c) extras.addChildElement('AccessoryId', null, null).addTextNode('10'); 	
                            if(promocion.Ascensores__c) extras.addChildElement('AccessoryId', null, null).addTextNode('13'); 	
                            if(promocion.Sala_Multidisciplinar__c) extras.addChildElement('AccessoryId', null, null).addTextNode('12'); 	
                            if(trastero) extras.addChildElement('AccessoryId', null, null).addTextNode('11'); 	
                            if(numPlazasGaraje > 0) extras.addChildElement('AccessoryId', null, null).addTextNode('5'); 	
                            advertisement.addChildElement('Area', null, null).addTextNode(vivienda.Superficie_Construida_total_con_ZZCC_m2__c==null?'':String.valueOf(vivienda.Superficie_Construida_total_con_ZZCC_m2__c));	
                            advertisement.addChildElement('LivingArea', null, null).addTextNode(vivienda.Superficie_Util_m2__c==null?'' :String.valueOf(vivienda.Superficie_Util_m2__c));	
                            advertisement.addChildElement('BuiltArea', null, null).addTextNode(vivienda.Superficie_Construida_total_con_ZZCC_m2__c==null? '' : String.valueOf(vivienda.Superficie_Construida_total_con_ZZCC_m2__c));	
                            advertisement.addChildElement('ParkingSpaceId', null, null).addTextNode(String.valueOf(numPlazasGaraje));	
                            // if(vivienda.Certificado_de_eficiencia_energetica__c!=null && String.isNotBlank(vivienda.Certificado_de_eficiencia_energetica__c)) {	
                            //     advertisement.addChildElement('EnergyPerformanceCertificate',null,null).addTextNode('1');
                            //     switch on vivienda.Certificado_de_eficiencia_energetica__c {	
                            //         when 'A'{	
                            //             advertisement.addChildElement('EnergyEfficiencyRating',null,null).addTextNode('1');	
                            //         }	
                            //         when 'B'{	
                            //             advertisement.addChildElement('EnergyEfficiencyRating',null,null).addTextNode('2');	
                            //         }	
                            //         when 'C'{	
                            //             advertisement.addChildElement('EnergyEfficiencyRating',null,null).addTextNode('3');	
                            //         }	
                            //         when 'D'{	
                            //             advertisement.addChildElement('EnergyEfficiencyRating',null,null).addTextNode('4');	
                            //         }	
                            //         when 'E'{	
                            //             advertisement.addChildElement('EnergyEfficiencyRating',null,null).addTextNode('5');	
                            //         }	
                            //         when 'F'{	
                            //             advertisement.addChildElement('EnergyEfficiencyRating',null,null).addTextNode('6');	
                            //         }	
                            //         when 'G'{	
                            //             advertisement.addChildElement('EnergyEfficiencyRating',null,null).addTextNode('7');	
                            //         }	
                            //     }	
                            // }	
                            //Se informa estos nodos ya que son de nueva construccción	
                            advertisement.addChildElement('EnergyPerformanceCertificate', null, null).addTextNode('3');	
                            //advertisement.addChildElement('EnergyEfficiencyRating',null,null).addTextNode('');	
                            //advertisement.addChildElement('EnergyEfficiencyValue',null,null).addTextNode('');	
                            //advertisement.addChildElement('EnvironmentImpactRating',null,null).addTextNode('');	
                            //advertisement.addChildElement('EnvironmentImpactValue',null,null).addTextNode(''); 	
                        } /*else if(isGarage) { // DATOS ESPECÍFICOS DE LOS GARAJES	
                            advertisement.addChildElement('Area', null, null).	
                                addTextNode(vivienda.Superficie_Construida_total_con_ZZCC_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Construida_total_con_ZZCC_m2__c));
                            advertisement.addChildElement('BuiltArea', null, null).	
                                addTextNode(vivienda.Superficie_Util_Garaje_con_calles_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Util_Garaje_con_calles_m2__c));                      	
                            advertisement.addChildElement('LivingArea', null, null).	
                                addTextNode(vivienda.Superficie_Util_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Util_m2__c));      	
                        } else if(isStorage) { // DATOS ESPECÍFICOS DE LOS TRASTEROS	
                            advertisement.addChildElement('Area', null, null).	
                                addTextNode(vivienda.Superficie_Construida_total_con_ZZCC_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Construida_total_con_ZZCC_m2__c));	
                            advertisement.addChildElement('BuiltArea', null, null).	
                                addTextNode(vivienda.Superficie_Util_Trastero_con_pasillos_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Util_Trastero_con_pasillos_m2__c));                      	
                            advertisement.addChildElement('LivingArea', null, null).	
                                addTextNode(vivienda.Superficie_Util_m2__c == null ? '' : String.valueOf(vivienda.Superficie_Util_m2__c));      	
                        }	
                    }	
                }	
            }            	
            mensaje = doc.toXmlString();	
        } catch( Exception ex ) {	
            mensaje='KO';	
            throw new GenerarXMLException(ex.getMessage() + '\n\r' + ex.getStackTraceString());      	
        }*/	
        return mensaje;	
     }	
     private static Decimal getTotalPriceWithAnnexesIncluded(Product2 p, List<Product2> annexes) {	
        Decimal totalPrice = p.Precio__c > 0.0 ? p.Precio__c : 0.0; 	
        if(annexes != null) {	
            for(Product2 annexe : annexes) {	
                totalPrice += annexe.Precio__c > 0.0 ? annexe.Precio__c : 0.0;	
            }	
        }	
        return totalPrice;	
    }

	
    public static void insertarLog( String nombreMetodo, String idCuenta, String mensajeEnviado, String resultado, String aplicacion) {	
        Log__c log = new Log__c();	
        log.Aplicacion__c = aplicacion;	
        log.name = nombreMetodo;	
      	log.Identificador__c = idCuenta;	
        log.MensajeEnviado__c = String.isNotBlank(mensajeEnviado) ? mensajeEnviado.abbreviate(130000) : '';	
        log.MensajeRecibido__c = String.isNotBlank(resultado) ? resultado.abbreviate(130000) : '';	
        insert log;	
    }	
    public class GenerarXMLException extends Exception {}	
}