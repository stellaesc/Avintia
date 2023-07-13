@isTest
public class TestSharePointConnector {

    private static HttpResponse getAccessToken() {
        // Mock necesario para login
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SharePointGetBearerRealmResponse');
        mock.setStatusCode(401);
        mock.setHeader('WWW-Authenticate', 'Bearer realm=\'785a77cc-15b7-4047-b267-58d7718526a4\',client_id=\'00000003-0000-0ff1-ce00-000000000000\',trusted_issuers=\'00000001-0000-0000-c000-000000000000@*,D3776938-3DBA-481F-A652-4BEDFCAB7CD8@*,https://sts.windows.net/*/,00000003-0000-0ff1-ce00-000000000000@90140122-8516-11e1-8eff-49304924019b\',authorization_uri=\'https://login.windows.net/common/oauth2/authorize\'');

        SharePointConnector spConnector = new SharePointConnector();
        Test.setMock(HttpCalloutMock.class, mock);

        HttpResponse result = spConnector.getBearerRealmResponse();
        spConnector.parseBearerRealmResponseHeaders(result);

        // Mock petición principal
        mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SharePointGetAccessToken');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);

        spConnector = new SharePointConnector();
        result = spConnector.getAccessTokenResponse();

        return result;
    }

    @isTest
    public static void testFullConstructor() {
        String file = 'test.txt';
        String path = 'Contratos';
        Map<String, String> meta = new Map<String, String>();
        meta.put('IdPromocion', 'test');
        meta.put('TipoDocumento', 'test');
        meta.put('Categoria', 'test');
        meta.put('Subcategoria', 'test');

        SharePointConnector spConnector = new SharePointConnector(file, path, meta);
        test.startTest();
        System.assertEquals(file, spConnector.fileName);
        System.assertEquals(path, spConnector.folderPath);
        System.assertEquals(meta, spConnector.metaDataMap);
        test.stopTest();
    }
    
    @isTest
    public static void testGetBearerRealmResponseOK() {
        // Creamos la respuesta mock
        
        SharePointConnector spConnector = new SharePointConnector();
        test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SharePointGetBearerRealmResponse');
        mock.setStatusCode(401);
        mock.setHeader('WWW-Authenticate', 'Bearer realm=\'785a77cc-15b7-4047-b267-58d7718526a4\',client_id=\'00000003-0000-0ff1-ce00-000000000000\',trusted_issuers=\'00000001-0000-0000-c000-000000000000@*,D3776938-3DBA-481F-A652-4BEDFCAB7CD8@*,https://sts.windows.net/*/,00000003-0000-0ff1-ce00-000000000000@90140122-8516-11e1-8eff-49304924019b\',authorization_uri=\'https://login.windows.net/common/oauth2/authorize\'');

        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse result = spConnector.getBearerRealmResponse();

        System.assertNotEquals(null, result, 'The callout returned a null response');
        System.assertEquals(401, result.getStatusCode(), 'The code status is not 401');
        System.assert(result.getHeader('WWW-Authenticate').contains('Bearer realm'), 'The response not contain bearer realm');
        test.stopTest();
    }

    @isTest
    public static void testGetBearerRealmResponseKO() {
        try {
            // Creamos la respuesta mock
            SharePointConnector spConnector = new SharePointConnector();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            Test.setMock(HttpCalloutMock.class, mock);
            //HttpResponse result = spConnector.getBearerRealmResponse();
            test.startTest();
            mock.setStaticResource('SharePointGetBearerRealmResponse');
            mock.setStatusCode(403);
            test.stopTest();
        } catch(SharePointConnector.SharePointConnectorException e) {
            System.assert(e.getMessage().contains('Error al obtener el bearer realm'));
        }
    }

    @isTest
    public static void testParseBearerRealmResponseHeadersOK() {
        // Creamos la respuesta mock
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SharePointGetBearerRealmResponse');
            mock.setStatusCode(401);
            mock.setHeader('WWW-Authenticate', 'Bearer realm=\'785a77cc-15b7-4047-b267-58d7718526a4\',client_id=\'00000003-0000-0ff1-ce00-000000000000\',trusted_issuers=\'00000001-0000-0000-c000-000000000000@*,D3776938-3DBA-481F-A652-4BEDFCAB7CD8@*,https://sts.windows.net/*/,00000003-0000-0ff1-ce00-000000000000@90140122-8516-11e1-8eff-49304924019b\',authorization_uri=\'https://login.windows.net/common/oauth2/authorize\'');

            Test.setMock(HttpCalloutMock.class, mock);
            SharePointConnector spConnector = new SharePointConnector();
            HttpResponse result = spConnector.getBearerRealmResponse();
        test.startTest();
        spConnector.parseBearerRealmResponseHeaders(result);
        
        System.assertEquals('\'785a77cc-15b7-4047-b267-58d7718526a4\'', spConnector.spTenant);
        System.assertEquals('\'00000003-0000-0ff1-ce00-000000000000\'', spConnector.spAppId);
        test.stopTest();
    }

    @isTest
    public static void testParseBearerRealmResponseHeadersKO() {
        try {
            SharePointConnector spConnector = new SharePointConnector();
            test.startTest();
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SharePointGetBearerRealmResponse');
            mock.setStatusCode(401);

            Test.setMock(HttpCalloutMock.class, mock);
            HttpResponse result = spConnector.getBearerRealmResponse();
            spConnector.parseBearerRealmResponseHeaders(result);
            test.stopTest();
        } catch(SharePointConnector.SharePointConnectorException e) {
            System.assert(e.getMessage().contains('Error no se encuentra la cabecera WWW-Authenticate en la respuesta'));
        }
    }
    
    @isTest(SeeAllData=true)
    public static void testGetAccessTokenResponseOK() {
        // Mock necesario para login
        
        SharePointConnector spConnector = new SharePointConnector();
        test.startTest();
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SharePointGetBearerRealmResponse');
        mock.setStatusCode(401);
        mock.setHeader('WWW-Authenticate', 'Bearer realm=\'785a77cc-15b7-4047-b267-58d7718526a4\',client_id=\'00000003-0000-0ff1-ce00-000000000000\',trusted_issuers=\'00000001-0000-0000-c000-000000000000@*,D3776938-3DBA-481F-A652-4BEDFCAB7CD8@*,https://sts.windows.net/*/,00000003-0000-0ff1-ce00-000000000000@90140122-8516-11e1-8eff-49304924019b\',authorization_uri=\'https://login.windows.net/common/oauth2/authorize\'');
		        
        Test.setMock(HttpCalloutMock.class, mock);
       
        HttpResponse result = spConnector.getBearerRealmResponse();
        spConnector.parseBearerRealmResponseHeaders(result);

        // Mock principal
        mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SharePointGetAccessToken');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);
        spConnector = new SharePointConnector();
        result = spConnector.getAccessTokenResponse();

        System.assertNotEquals(null, result, 'The callout returned a null response');
        System.assertEquals(200, result.getStatusCode(), 'The code status is not 200');
        System.assert(result.getBody().contains('access_token'));
        test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void testGetAccessTokenResponseKO() {
        try {
            SharePointConnector spConnector = new SharePointConnector();
            test.startTest();
            
            // Mock necesario para login
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SharePointGetBearerRealmResponse');
            mock.setStatusCode(401);
            mock.setHeader('WWW-Authenticate', 'Bearer realm=\'785a77cc-15b7-4047-b267-58d7718526a4\',client_id=\'00000003-0000-0ff1-ce00-000000000000\',trusted_issuers=\'00000001-0000-0000-c000-000000000000@*,D3776938-3DBA-481F-A652-4BEDFCAB7CD8@*,https://sts.windows.net/*/,00000003-0000-0ff1-ce00-000000000000@90140122-8516-11e1-8eff-49304924019b\',authorization_uri=\'https://login.windows.net/common/oauth2/authorize\'');

            Test.setMock(HttpCalloutMock.class, mock);

            HttpResponse result = spConnector.getBearerRealmResponse();
            spConnector.parseBearerRealmResponseHeaders(result);

            // Mock petición principal
            mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SharePointGetAccessToken');
            mock.setStatusCode(400);
            Test.setMock(HttpCalloutMock.class, mock);

            result = spConnector.getAccessTokenResponse();
            test.stopTest();
        } catch(SharePointConnector.SharePointConnectorException e) {
            System.assert(e.getMessage().contains('Error al obtener el access_token'));
        }
    }
    
    @isTest(SeeAllData=true)
    public static void testPutTokenInCacheOK() {
        SharePointConnector spConnector = new SharePointConnector(true);
        test.startTest();
        HttpResponse result = getAccessToken();

        spConnector.putTokenInCache(result);
        System.assertEquals('asdasdas', spConnector.accessToken, 'Invalid access token');
        test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void testPutTokenInCacheKO() {
        HttpResponse result = new HttpResponse();
        SharePointConnector spConnector = new SharePointConnector(true);
        test.startTest();

        spConnector.putTokenInCache(result);
        System.assert(spConnector.accessToken == null);
        test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void testCreateFoldersOK() {
        HttpResponse result = getAccessToken();
        SharePointConnector spConnector = new SharePointConnector(true);
        test.startTest();
        spConnector.putTokenInCache(result);

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SharePointCreateDir');
        mock.setStatusCode(201);
        Test.setMock(HttpCalloutMock.class, mock);

        result = spConnector.createFolders('testings', new List<String> { 'testin 2' });
        System.assertNotEquals(null, result, 'The callout returned  a null response');
        System.assertEquals(201, result.getStatusCode(), 'The code status is not 201');
        test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void testCreateFoldersKO() {
        try {
            SharePointConnector spConnector = new SharePointConnector(true);
            test.startTest();
            HttpResponse result = getAccessToken();
            spConnector.putTokenInCache(result);

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SharePointCreateDir');
            mock.setStatusCode(401);
            Test.setMock(HttpCalloutMock.class, mock);

            result = spConnector.createFolders('testings', new List<String> { 'testin 2' });
            test.stopTest();
        } catch(SharePointConnector.SharePointConnectorException e) {
            System.assert(e.getMessage().contains('Error al crear carpeta padre') || e.getMessage().contains('Error al crear subcarpetas'));
        }
    }

    @isTest(SeeAllData=true)
    public static void testCreateFileOK() {

        String file = 'test.txt';
        String path = 'Contratos';
        Map<String, String> meta = new Map<String, String>();
        meta.put('IdPromocion', 'test');
        meta.put('TipoDocumento', 'test');
        meta.put('Categoria', 'test');
        meta.put('Subcategoria', 'test');

        SharePointConnector spConnector = new SharePointConnector(file, path, meta, true);
        test.startTest();
        
        HttpResponse result = getAccessToken();
        spConnector.putTokenInCache(result);

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SharePointCreateFile');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);

        result = spConnector.createFile('hola que tal');
        System.assertNotEquals(null, result, 'The callout returned a null message');
        System.assertEquals(200, result.getStatusCode());
        test.stopTest();
    } 

    @isTest(SeeAllData=true)
    public static void testCreateFileKO() {
        try {
            HttpResponse result = getAccessToken();
            SharePointConnector spConnector = new SharePointConnector(true);
            test.startTest();
            spConnector.putTokenInCache(result);

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SharePointCreateFile');
            mock.setStatusCode(401);
            Test.setMock(HttpCalloutMock.class, mock);
            result = spConnector.createFile('hola que tal');
            test.stopTest();
        } catch(SharePointConnector.SharePointConnectorException e) {
            System.assert(e.getMessage().contains('Error al crear el archivo'));
        }
    } 

    @isTest(SeeAllData=true)
    public static void testUpdateFileMetaDataOK() {
        
        HttpResponse result = getAccessToken();

        String file = 'test.txt';
        String path = 'Contratos';
        Map<String, String> meta = new Map<String, String>();
        meta.put('IdPromocion', 'test');
        meta.put('TipoDocumento', 'test');
        meta.put('Categoria', 'test');
        meta.put('Subcategoria', 'test');
        
        SharePointConnector spConnector = new SharePointConnector(file, path, meta, true);
        test.startTest();

        spConnector.putTokenInCache(result);

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SharePointUpdFileMetaData');
        mock.setStatusCode(204);
        Test.setMock(HttpCalloutMock.class, mock);

        result = spConnector.updateFileMetadata();
        System.assertNotEquals(null, result, 'The callout returned a null message');
        System.assertEquals(204, result.getStatusCode());
        test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void testUpdateFileMetaDataKO() {
        try {
            HttpResponse result = getAccessToken();
            String file = 'test.txt';
            String path = 'Contratos';
            Map<String, String> meta = new Map<String, String>();
            
            meta.put('IdPromocion', 'test');
            meta.put('TipoDocumento', 'test');
            meta.put('Categoria', 'test');
            meta.put('Subcategoria', 'test');
            
            SharePointConnector spConnector = new SharePointConnector(file, path, meta, true);
            test.startTest();

            spConnector.putTokenInCache(result);

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SharePointUpdFileMetaData');
            mock.setStatusCode(401);
            Test.setMock(HttpCalloutMock.class, mock);

            result = spConnector.updateFileMetadata();
            test.stopTest();
        } catch(SharePointConnector.SharePointConnectorException e) {
            System.assert(e.getMessage().contains('Error al actualizar los metadatos del archivo'));
        }
    }

    @isTest(SeeAllData=true)
    public static void testGetAllFilesByFilterOK() {
        HttpResponse result = getAccessToken();
        String file = 'test.txt';
        String path = 'Contratos';
        Map<String, String> meta = new Map<String, String>();
        meta.put('IdPromocion', 'test');
        meta.put('TipoDocumento', 'test');
        meta.put('Categoria', 'test');
        meta.put('Subcategoria', 'test');
        
        SharePointConnector spConnector = new SharePointConnector(file, path, meta, true);
        test.startTest();        

        spConnector.putTokenInCache(result);

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SharePointGetFilteredFiles');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);

        List<String> selectFields = new List<String> { 
            'Id', 'Title', 'IdPromocion', 'TipoDocumento', 'Categoria', 'Subcategoria', 'FieldValuesAsText/FileRef' 
        };
        result = spConnector.getAllFilesByFilter('Contratos', selectFields, 'IdPromocion eq \'232321212\'');
        System.assertNotEquals(null, result, 'The callout returned a null message');
        System.assertEquals(200, result.getStatusCode());
        test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void testGetAllFilesByFilterKO() {
        try {
            
            String file = 'test.txt';
            String path = 'Contratos';
            Map<String, String> meta = new Map<String, String>();
            meta.put('IdPromocion', 'test');
            meta.put('TipoDocumento', 'test');
            meta.put('Categoria', 'test');
            meta.put('Subcategoria', 'test');
            
            SharePointConnector spConnector = new SharePointConnector(file, path, meta, true);
            test.startTest();
            HttpResponse result = getAccessToken();

            spConnector.putTokenInCache(result);

            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('SharePointGetFilteredFiles');
            mock.setStatusCode(401);
            Test.setMock(HttpCalloutMock.class, mock);

            List<String> selectFields = new List<String> { 
                'Id', 'Title', 'IdPromocion', 'TipoDocumento', 'Categoria', 'Subcategoria', 'FieldValuesAsText/FileRef' 
            };
            result = spConnector.getAllFilesByFilter('Contratos', selectFields, 'IdPromocion eq \'232321212\'');
            test.stopTest();
        } catch(SharePointConnector.SharePointConnectorException e) {
            System.assert(e.getMessage().contains('Error al obtener los todos los archivos con esos metadatos'));
        }
    }

    @isTest(SeeAllData=true)
    public static void testGetSharePointFilesFromJSON() {
        
        HttpResponse result = getAccessToken();
        String file = 'test.txt';
        String path = 'Contratos';
        Map<String, String> meta = new Map<String, String>();
        meta.put('IdPromocion', 'test');
        meta.put('TipoDocumento', 'test');
        meta.put('Categoria', 'test');
        meta.put('Subcategoria', 'test');
        
        SharePointConnector spConnector = new SharePointConnector(file, path, meta, true);
        test.startTest();

        spConnector.putTokenInCache(result);

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SharePointGetFilteredFiles');
        mock.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mock);

        List<String> selectFields = new List<String> { 
            'Id', 'Title', 'IdPromocion', 'TipoDocumento', 'Categoria', 'Subcategoria', 'FieldValuesAsText/FileRef' 
        };
        result = spConnector.getAllFilesByFilter('Contratos', selectFields, 'IdPromocion eq \'232321212\'');

        List<SharePointFile> files = spConnector.getSharePointFilesFromJSON(result);
        System.assert(files.size() > 0);
        test.stopTest();
    }
}