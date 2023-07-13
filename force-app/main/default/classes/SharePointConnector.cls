/**
 * Clase que implementa la integración con
 * Sharepoint
*/
public class SharePointConnector {

    // Claves de variables de caché
    public static final String spAccessTokenKey = 'SPAccessToken';
    public static final String spTokenExpDateKey = 'SPTokenExpDate';
    
    // Custom Settings
    private String spEndPointLogin;
    private String spClientId;
    private String spClientSecret;
    private String spResource;
    private String spSiteDomain;
    private String spEndPointSite;
    @TestVisible
    private String spTenant;
    @TestVisible
    private String spAppId;
    
    // Propiedades de conexión
    @TestVisible
    private String accessToken;
    private Boolean async = false;

    // Metadatos archivo
    @TestVisible
    private String fileName;

    @TestVisible
    private String folderPath;

    @TestVisible
    private Map<String, String> metaDataMap;
    
    public SharePointConnector() {
        // Custom Settings
        setCustomSettings();
    }

    public SharePointConnector(Boolean isAsync) {
        async = isAsync;
        setCustomSettings();
    }

    public SharePointConnector(String fName, String fPath, Map<String, String> metadata) {
        // Custom Settings
        setCustomSettings();

        // Metadatos
        fileName = fName;
        folderPath = fPath;
        metaDataMap = metadata;
    }

    
    public SharePointConnector(String fName, String fPath, Map<String, String> metadata, Boolean isAsync) {
        // Custom Settings
        setCustomSettings();

        // Metadatos
        fileName = fName;
        folderPath = fPath;
        metaDataMap = metadata;
        async = isAsync;
    }

    /**
     * Establece las propiedades correspondientes con los valores
     * de las custom settings del conector
     */
    private void setCustomSettings() {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        spEndPointLogin = spCustomSettings.spDomainLogin__c;
        spClientId = spCustomSettings.spClientId__c;
        spClientSecret = spCustomSettings.spClientSecret__c;
        spResource = spCustomSettings.spResource__c;
        spEndPointSite = spCustomSettings.spSiteUrl__c;
        spSiteDomain = spCustomSettings.spSiteDomain__c;
    }

    public static String getNewDocumentNumber() {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        Integer docNum = spCustomSettings.spDocumentNumber__c.intValue();
        System.debug(docNum);
        String docNumStr = String.valueOf(spCustomSettings.spDocumentNumber__c).replace('.0', '');
        System.debug(docNumStr);
        docNumStr = docNumStr.leftPad(3, '0');
        return docNumStr;
    }

    public static void commitDocumentNumber() {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        spCustomSettings.spDocumentNumber__c += 1;
        update spCustomSettings;
    }
   
    /**
     * Proporciona login si es necesario
     */
    public void login() {
        HttpResponse res = null;
        Long currTime = System.now().getTime();
        Boolean conditions = null;

        if(!async) {
            conditions = (!Cache.Session.contains(SharePointConnector.spAccessTokenKey) && !Cache.Session.contains(SharePointConnector.spTokenExpDateKey));
            conditions = conditions || (Cache.Session.contains(SharePointConnector.spTokenExpDateKey) && (Long) Cache.Session.get(SharePointConnector.spTokenExpDateKey) < currTime);
        } else conditions = true;

        if(conditions) {
            // Obtención del Bearer Realm
            res = getBearerRealmResponse();
            parseBearerRealmResponseHeaders(res);
            
            // Obtención del access token
            res = getAccessTokenResponse();
            putTokenInCache(res);
              
            // TODO -> IMPLEMENTAR MEJOR EL REFRESCO DEL TOKEN
            
        } else accessToken = (String) Cache.Session.get(SharePointConnector.spAccessTokenKey);
        System.debug('accessToken: ' + accessToken);
    }
    
    /**
     * Obtiene los datos del bearer para posterior obtención
     * del access token
     */
    @TestVisible
    private HttpResponse getBearerRealmResponse() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(spEndPointSite + '_vti_bin/client.svc');
        req.setMethod('GET');
        req.setBody('');
        req.setHeader('Authorization', 'Bearer');
        Http http = new Http();
        HttpResponse res = http.send(req);
        if(res.getStatusCode() != 401) {
            throw new SharePointConnectorException('Error al obtener el bearer realm.\n\rRequest: ' + 
                        req.getBody() + '\n\rResponse: ' + res.getBody());
        }
        return res;
    }
    
    /**
     * Parsea el header de la llamada que obtiene  los datos
     * del bearer
     */
    @TestVisible
    private void parseBearerRealmResponseHeaders(HttpResponse res) {
        // Parseo de headers
        String[] headerKeys = res.getHeaderKeys();
        Map<String, String> headers = new Map<String, String>();
        for(String s : headerKeys) {
            headers.put(s,res.getHeader(s));
        }
        
        // Obtención de elementos para obtener el token de acceso
        String wwwAuthenticateHeader = headers.get('WWW-Authenticate');
        if(wwwAuthenticateHeader == null || wwwAuthenticateHeader == '') {
            throw new SharePointConnectorException('Error no se encuentra la cabecera WWW-Authenticate en la respuesta');
        }

        String[] authenticateHeaderElems = wwwAuthenticateHeader.split(',');
        spTenant = authenticateHeaderElems[0].split('=')[1].replace('"', '');
        spAppId = authenticateHeaderElems[1].split('=')[1].replace('"', '');
    }
    
    /**
     * Realiza la petición para la obtención del access token
     */
    @TestVisible
    private HttpResponse getAccessTokenResponse() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(spEndPointLogin + spTenant + '/tokens/OAuth/2');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials&client_id='+spclientId+'@'+spTenant+'&client_secret=' +
                    EncodingUtil.urlEncode(spClientSecret, 'UTF-8') + 
                    '&resource=' + EncodingUtil.urlEncode(spAppId + '/' + spResource + '@' + spTenant, 'UTF-8'));
        Http http = new Http();
        HttpResponse res = http.send(req);
        if(res.getStatusCode() != 200) {
            throw new SharePointConnectorException('Error al obtener el access_token.\n\rRequest: ' + 
                        req.getBody() + '\n\rResponse: ' + res.getBody());
        }

        return res;
    }

    
    /**
     * Guarda el token en caché para su posterior comprobación
     * de expiración.
     */
    @TestVisible
    private void putTokenInCache(HttpResponse res) {
        String bodyRes = res.getBody();
        
        JSONParser parser = JSON.createParser(bodyRes);
        while (parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'expires_on') {
                parser.nextToken();
                Long expiresOn = Long.valueOf(parser.getText()) * 1000; // Para pasarlo a milisegundos                   
                if(!async) Cache.Session.put(SharePointConnector.spTokenExpDateKey, expiresOn);
            }
            
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'access_token')) {
                parser.nextToken();
                accessToken = parser.getText();
                if(!async) Cache.Session.put(SharePointConnector.spAccessTokenKey, accessToken);
            	break;
            }
        }
    }

    /**
     * Crea carpetas y subcarpetas en el sitio SharePoint
     */
    public HttpResponse createFolders(String folderPath, List<String> subFolders) {
        HttpRequest req = new HttpRequest();
        String method = 'Folders';
        req.setEndpoint(spEndPointSite + '_api/web/' + method);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + EncodingUtil.urlEncode(accessToken, 'UTF-8'));
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Expect', '100-continue');
        req.setBody('{\'ServerRelativeUrl\': \''+folderPath+'\'}');
        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode() != 201) {
            throw new SharePointConnectorException('Error al crear carpeta padre.\n\rRequest: ' + 
                req.getBody() + '\n\rResponse: ' + res.getBody());
        }

        if(subFolders.size() > 0) {
            for(String folder : subFolders) {
                req.setBody('{\'ServerRelativeUrl\': \''+folderPath + '/' + folder+'\'}');
                res = http.send(req);
                if(res.getStatusCode() != 201) {
                    throw new SharePointConnectorException('Error al crear subcarpetas.\n\rRequest: ' + 
                        req.getBody() + '\n\rResponse: ' + res.getBody());
                }
            }
        }

        return res;
    }
    
    /**
     * Crear el archivo en nuestro sitio SharePoint
     */
    public HttpResponse createFile(String base64Data) {
        //base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Blob fileContent = EncodingUtil.base64Decode(base64Data);
        HttpRequest req = new HttpRequest();
        System.debug(folderPath);
        String method = EncodingUtil.urlEncode('GetFolderByServerRelativeUrl(\''+folderPath+'\')', 'UTF-8') +
            '/Files/' + 
            EncodingUtil.urlEncode('add(overwrite=true,url=\'' + fileName + '\')', 'UTF-8');
        method = method.replace('+', '%20');
        
        req.setEndpoint(spEndPointSite + '_api/web/' + method);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + EncodingUtil.urlEncode(accessToken, 'UTF-8'));
        req.setHeader('Accept', 'application/json');
        req.setBodyAsBlob(fileContent);
        Http http = new Http();
        HttpResponse resp = http.send(req);
        System.debug(resp.getBody());

        if(resp.getStatusCode() != 200) {
            throw new SharePointConnectorException('Error al crear el archivo.\n\rRequest: ' + 
                req.getBody() + '\n\rResponse: ' + resp.getBody());
        }

        return resp;
    }
    
    /**
     * Crea un nuevo campo para metadatos
     */
    /*private void createFileMetaData() {

    }*/

    /**
     * Actualiza los metadatos de un archivo
     */
    public HttpResponse updateFileMetaData() {
        HttpRequest req = new HttpRequest();
        String method = EncodingUtil.urlEncode('GetFolderByServerRelativeUrl(\''+folderPath+'/'+fileName+'\')', 'UTF-8') + '/ListItemAllFields';
        method = method.replace('+', '%20');
        req.setEndpoint(spEndPointSite + '_api/web/' + method);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + EncodingUtil.urlEncode(accessToken, 'UTF-8'));
        req.setHeader('Accept', 'application/json;odata=verbose');
        req.setHeader('Content-Type', 'application/json;odata=verbose');
        req.setHeader('X-HTTP-Method', 'PATCH');
        req.setHeader('If-Match', '*');
        String metaDataFields = getMetaDataFieldsJSON();
        
        String[] folderPathElems = folderPath.replace(spEndPointSite.replace(spSiteDomain, ''), '').split('/');
        String firstFolder = folderPathElems.get(0);
        req.setBody('{\'__metadata\': { ' +
                '\'type\': \'SP.Data.'+firstFolder.replace(' ', '')+'Item\'' +
            '}, ' + 
            metaDataFields +
        '}');
        System.debug(req.getBody());
        Http http = new Http();
        HttpResponse res = http.send(req);
        if(res.getStatusCode() != 204) {
            throw new SharePointConnectorException('Error al actualizar los metadatos del archivo. ### Request: ' + 
                req.getBody() + '### Response: ' + res.getBody());
        }
        return res;
    }

    /**
     * Obtiene los metadatos que hay que configurar en los ficheros
     */
    private String getMetaDataFieldsJSON() {
        String res = '';
        for(String key : metaDataMap.keySet()) {
            res += '\'' + key + '\': \'' + metaDataMap.get(key) + '\',';
        }
        res += '\'Title\': \'' + fileName + '\',';
        res = res.removeEnd(',');
        return res;
    }

    /**
     * Obtiene los metadatos de un archivo
     */
    /*private void getFileMetaData() {
        HttpRequest req = new HttpRequest();
        String method = EncodingUtil.urlEncode('GetFolderByServerRelativeUrl(\'Contratos/'+fileName+'\')', 'UTF-8') + '/ListItemAllFields';
        req.setEndpoint(spEndPointSite + '_api/web/' + method);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + EncodingUtil.urlEncode(accessToken, 'UTF-8'));
        req.setHeader('Accept', 'application/json;odata=verbose');
        req.setBody('');
        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode() != 200) {
            throw new SharePointConnectorException('Error al obtener los metadatos del archivo.\n\rRequest: ' + 
                req.getBody() + '\n\rResponse: ' + res.getBody());
        }

        // TODO -> PARSEAR Y DEVOLVER METADATOS
    }*/

    /**
     * Obtiene todos los archivos dados unos metadatos
     */
    public HttpResponse getAllFilesByFilter(String dirPath, List<String> selectFields, String filterExp) {
        HttpRequest req = new HttpRequest();
        Boolean hasSelectFields = false;
        String method = 'lists/GetByTitle(\''+dirPath+'\')/Items';

        if(selectFields.size() > 0) {
            hasSelectFields = true;
            method += '?$select=';
            for(String field : selectFields) {
                method += EncodingUtil.urlEncode(field, 'UTF-8') + ',';
            }
            method = method.removeEnd(',');
            method += '&$expand=FieldValuesAsText/FileRef';
        }

        if(filterExp != null && filterExp.length() > 0) {
            method += (hasSelectFields ? '&' : '?') + '$filter=';
            method += EncodingUtil.urlEncode(filterExp, 'UTF-8');
        }

        req.setEndPoint(spEndPointSite + '_api/web/' + method);
        System.debug('EndPoint: ' + spEndPointSite + '_api/web/' + method);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + EncodingUtil.urlEncode(accessToken, 'UTF-8'));
        req.setHeader('X-HTTP-Method', 'GET');
        req.setHeader('Accept', 'application/json');
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Response body: ' + res.getBody());

        if(res.getStatusCode() != 200) {
            throw new SharePointConnectorException('Error al obtener los todos los archivos con esos metadatos.\n\rRequest: ' + 
                req.getBody() + '\n\rResponse: ' + res.getBody());
        }

        return res;
    }
    
    public List<SharePointFile> getSharePointFilesFromJSON(HttpResponse res) {
        List<SharePointFile> files = new List<SharePointFile>();
        JSONParser parser = JSON.createParser(res.getBody());
        Integer pos = 1;
        while (parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'value') {
                SharePointFile file = null;
                while(parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        file = new SharePointFile();
                        file.Position = pos;
                        file.Categories = new List<String>();
                        continue;
                    } else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'ID') {
                         parser.nextToken();
                         file.Id = parser.getText();
                         continue;
                    } else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'Title') {
                        parser.nextToken();
                        file.Name = parser.getText();
                        continue;
                    } else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'TipoDocumento') {
                        parser.nextToken();
                        file.DocType = parser.getText();
                        continue;
                    } else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText().contains('Categoria')) {
                        parser.nextToken();
                        file.Categories.add(parser.getText());
                        continue;
                    } else if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'FieldValuesAsText') {
                        parser.nextToken();
                        parser.nextToken();
                        parser.nextToken();
                        parser.nextToken();
                        parser.nextToken();
                        parser.nextToken();
                        parser.nextToken();
                        parser.nextToken();
                        if(parser.getText() == 'FileRef') {
                            parser.nextToken();
                            spSiteDomain = spSiteDomain.removeEnd('/');
                            file.FileRef = spSiteDomain + '/' + parser.getText();
                            parser.nextToken();
                            continue;
                        }
                    } else if(parser.getCurrentToken() == JSONToken.END_OBJECT) {
                        files.add(file);
                        pos++;
                        continue;
                    } else if(parser.getCurrentToken() == JSONToken.END_ARRAY) {
                        break;
                    }
                }
            } else continue;

        }

        return files;
    }

    public class SharePointConnectorException extends Exception {}
    
}