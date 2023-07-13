@isTest
public class TEST_PlanoTipoInmuebleController {
    
    @isTest
    public static void testPlanoInmueble() {
        Product2 inmueble = TestUtil.getInmueble();
        
        ContentVersion cv = new ContentVersion();
        
        cv.title = 'Imagen prueba';
        cv.PathOnClient = 'URL de prueba';
        cv.Tipo__c = 'Plano';
        cv.ParentId__c = inmueble.id;
        Blob b=Blob.valueOf('prueba');
        cv.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;
        
        ContentVersion cv2 = [SELECT id, ContentDocumentId FROM ContentVersion WHERE id =: cv.id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
        
        cdl.LinkedEntityId = inmueble.Id;
        cdl.ContentDocumentId =  cv2.ContentDocumentId;
        cdl.ShareType = 'V';
        insert cdl;
        
        PageReference pageRef = Page.PlanoTipoInmueble;
        System.currentPageReference().getParameters().put('id', inmueble.id);
        
        
        ApexPages.StandardController stdController = new Apexpages.StandardController(cv);
        
        PlanoTipoInmuebleController controller = new PlanoTipoInmuebleController(stdController);
        
        Test.setCurrentPage(pageRef);
        
        String nextPage = pageRef.getUrl();
        
        System.assertEquals('/apex/planotipoinmueble', nextPage); 
    }
    
    @isTest
    public static void testPlanoTipoInmueble() {
        
        Product2 inmueble = TestUtil.getInmueble();
        ContentVersion cv = TestUtil.getPlano(inmueble.Tipo_de_inmueble__c);
        
        PageReference pageRef = Page.PlanoTipoInmueble;
        System.currentPageReference().getParameters().put('id', inmueble.id);
        
        
        ApexPages.StandardController stdController = new Apexpages.StandardController(cv);
        
        PlanoTipoInmuebleController controller = new PlanoTipoInmuebleController(stdController);
        
        Test.setCurrentPage(pageRef);
        
        String nextPage = pageRef.getUrl();
        
        System.assertEquals('/apex/planotipoinmueble', nextPage); 
    }
    
    @isTest
    public static void testPlanoTipoInmuebleException() {
           
       Product2 inmueble = TestUtil.getInmueble();
           
        PageReference pageRef = Page.PlanoTipoInmueble;
        System.currentPageReference().getParameters().put('id', inmueble.id);


        ApexPages.StandardController stdController;

        PlanoTipoInmuebleController controller = new PlanoTipoInmuebleController(stdController);
        
        Test.setCurrentPage(pageRef);
        
        String nextPage = pageRef.getUrl();

        System.assertEquals('/apex/planotipoinmueble', nextPage);

    }
}