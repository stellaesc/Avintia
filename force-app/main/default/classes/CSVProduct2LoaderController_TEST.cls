@isTest
public class CSVProduct2LoaderController_TEST {
	
    public static Id testSetup() {
        TestUtil.getProductoOportunidad();
        Id recordId = TestUtil.getPromocion(Date.newInstance(2018, 09, 20), Date.today()).Id;
        
        Tipo_de_inmueble__c tipoInmueble = new Tipo_de_inmueble__c();
        tipoInmueble.name = 'Tipo de Inmueble Vivienda Test';
        tipoInmueble.Tipo__c = 'Vivienda';
        tipoInmueble.N_de_habitaciones__c = 3;
        tipoInmueble.N_de_banos__c=2;
        tipoInmueble.Superficie_Terrazas_Descubiertas__c=7;
        tipoInmueble.Superficie_Terrazas_Cubiertas__c=6;
        tipoInmueble.Superficie_Jardines__c=12;
        tipoInmueble.Superficie_Construida_m2__c = 50;
        tipoInmueble.Superficie_Util_m2__c=55;
        tipoInmueble.Superficie_Construida_total_con_ZZCC_m2__c=60;
        insert tipoInmueble;
       	
        List<Product2> prds = new List<Product2>();
        Product2 prd1 = new Product2();
        prd1.name = 'Inmueble Test';
        prd1.Tipo_de_inmueble__c = tipoInmueble.Id;
        prd1.Precio__c=200.000;
        prd1.Promocion__c = recordId;
        prds.add(prd1);
        
        Product2 prd2 = new Product2();
        prd2.name = 'Inmueble 2 Test';
        prd2.Tipo_de_inmueble__c = tipoInmueble.Id;
        prd2.Precio__c=200.000;
        prd2.Promocion__c = recordId;
       	prds.add(prd2);
        
        insert prds;
            
        ContentVersion cv = new ContentVersion();
        cv.title = 'Test Doc';
        cv.ParentId__c = recordId;
        cv.versiondata = Blob.valueOf('Id;Name;Precio_propuesto__c\n' + prd1.Id + ';1A;11.11\n' + prd2.Id + ';1B;22.22');
        cv.Tipo__c = 'Memoria_calidades';
        cv.IsMajorVersion = true;
        cv.PathOnClient = 'URL de prueba';
        insert cv;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink link = new ContentDocumentLink(
            LinkedEntityId = recordId,
            ContentDocumentId = documents.get(0).Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert link;
        
        return recordId;
    }
    
    @isTest
    public static void testGetProfileInfo() {
        CSVProduct2LoaderController.getProfileInfo(testSetup());
    }
    
    @isTest
    public static void testFileProcessingSuccess() {
        Id prm = testSetup();

        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE name = 'Oportunidad Test' LIMIT 1];
        
        HelloSign__HelloSign_Signature_Request__c hellosignStatus = new HelloSign__HelloSign_Signature_Request__c(HelloSign__Latest_Action__c = 'Signature Completed',
                                                                                                                  HelloSign__Opportunity__c= opp.Id);
        insert hellosignStatus;
        List<CSVProduct2LoaderController.DocumentInfo> cdocs = new List<CSVProduct2LoaderController.DocumentInfo>();
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion LIMIT 1];
        CSVProduct2LoaderController.DocumentInfo di = new CSVProduct2LoaderController.DocumentInfo();
        di.Name = 'DocName';
        di.documentId = cv.ContentDocumentId;
        cdocs.add(di);
        
        CSVProduct2LoaderController.fileProcessing(prm, cdocs);
        Test.stopTest();
    }
    
    @isTest
    public static void testSaveFileSuccess() {
       	Id prm = testSetup();
        
        Test.startTest();
        List<CSVProduct2LoaderController.DocumentInfo> cdocs = new List<CSVProduct2LoaderController.DocumentInfo>();
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion LIMIT 1];
        CSVProduct2LoaderController.DocumentInfo di = new CSVProduct2LoaderController.DocumentInfo();
        di.Name = 'DocName';
        di.documentId = cv.ContentDocumentId;
        cdocs.add(di);
        
        CSVProduct2LoaderController.saveFile(prm, cdocs);
        Test.stopTest();
    }
    
    @isTest
    public static void testDeleteFile() {
        testSetup();
        
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion LIMIT 1];
        
        CSVProduct2LoaderController.DocumentInfo di = new CSVProduct2LoaderController.DocumentInfo();
        di.documentId = cv.ContentDocumentId;
        CSVProduct2LoaderController.deleteFile(new List<CSVProduct2LoaderController.DocumentInfo>{di});
        
        List<ContentDocument> cds = [SELECT Id FROM ContentDocument WHERE Id = :cv.ContentDocumentId];
        System.assert(cds.isEmpty());
    }
    
    @isTest
    public static void testGetProducts() {
      	CSVProduct2LoaderController.getProducts(testSetup());
    }
    
    @isTest
    public static void testReturnException() {
        CSVProduct2LoaderController.returnException('Prueba', 'Cuerpo', '');
    }
    
}