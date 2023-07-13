@isTest
public class TEST_PantallaSubidaFicherosController {

    private static List<DocumentCategory__c> cats = new List<DocumentCategory__c>();

    @TestSetUp
    public static void setUp() {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        insert new SharePointConnector__c(
            spClientId__c = 'test',
            spClientSecret__c = 'test',
            spResource__c = 'test',
            spDocumentNumber__c = 1,
            spParentDir__c = 'Promociones',
            spSiteDomain__c = 'http...',
            spSiteUrl__c = 'http..'
        );
    }

    private static void setCustomCategories() {
        DocumentCategory__c cat = new DocumentCategory__c(Code__c = '01', Level__c = 1, Name = 'Categoría nivel 1', ParentDirectoryName__c = 'TECNICO');
        insert cat;
        cats.add(cat);
        cat = new DocumentCategory__c(Code__c = '01.01', Level__c = 2, Name = 'Categoría nivel 2', ParentDocumentCategory__c = cat.Id);
        cats.add(cat);
        insert cat;
    }
    
    //Comprueba que se obtienen los valores de una picklist de un determinado campo
    @isTest
    public static void testObtenerValoresPicklist(){
        
        ContentVersion imagen = TestUtil.getImagen();
        

        //Se recuperan los valores de 'tipo' de contentVersion
        
        Test.startTest();
        List <String> listaValores = PantallaSubidaFicherosController.getselectOptions(imagen, 'Tipo__c');
        
        //API name de valores disponibles 
        List <String> listaValoresEsperados = new List<String>{'Imagen','Archivo','Plano', 'Plano_PDF','Pre-reserva','Justificante de pago',
            													'Reserva','Borrador de contrato','Contrato','Factura','Imagen_carrusel',
                                                                'Carrusel_lifestyle','Video','Folleto','Memoria_calidades','Planos_zonas_comunes',
                                                                'Carrusel_entorno','Pie_de_web', 'Imagen_financiera', 'Logo Promoción', 'Cuadro_superficies',
            													'Video_Youtube', 'Visita VR'};
        
        //Se ordenan las listas para la comparacion                                                            
        listaValores.sort();
        listaValoresEsperados.sort();
        
               system.debug('listaValores '+listaValores);
               system.debug('listaValoresEsperados '+listaValoresEsperados);
                                                                    
        //Si las listas no son iguales salta
        System.assert(listaValoresEsperados == listaValores);
        Test.stopTest();
  
    }
    
    //Guarda un archivo en base de datos
    @isTest
    public static void testGuardarArchivoFromPromo(){
        ContentVersion imagen = TestUtil.getImagen();
        Id parentId = imagen.ParentId__c;
        String VersionData = EncodingUtil.base64Encode(imagen.VersionData); 
        Integer posicion = integer.valueOf(imagen.Posicion__c);
		
        Test.startTest();
        Id fileId = PantallaSubidaFicherosController.guardarArchivo(parentId, imagen.Title, VersionData, 'tipo', 
                                    imagen.Tipo__c, posicion, imagen.Description, new List<PantallaSubidaFicherosController.DocumentCategoryOptWrapper>(), '', true);
        
        PantallaSubidaFicherosController.guardarArchivo(parentId, imagen.Title, '', 'tipo', imagen.Tipo__c, posicion, imagen.Description,
                                    new List<PantallaSubidaFicherosController.DocumentCategoryOptWrapper>(), fileId, true);

        ContentVersion imagenInsertada = [SELECT id, VersionData, ContentDocumentId, ParentId__c FROM ContentVersion WHERE Title = 'Imagen prueba' LIMIT 1];
        system.assertEquals(EncodingUtil.base64Encode(imagenInsertada.VersionData), EncodingUtil.base64Encode(imagen.VersionData));
        
        ContentDocumentLink cdl = [SELECT id, ContentDocumentId,  LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: imagen.ParentId__c order by Id asc LIMIT 1];
        //system.assertEquals(cdl.ContentDocumentId, imagenInsertada.ContentDocumentId);
        Test.stopTest();
        

    }

    @isTest
    public static void testGuardarArchivoFromOpportunity() {
        
        TestUtil.getOportunidad_Contrato_Compraventa_Libre_controller();
        Test.startTest();
        ContentVersion imagen = TestUtil.testCrearImagenOpp();
        Id parentId = imagen.ParentId__c;
        String VersionData = EncodingUtil.base64Encode(imagen.VersionData); 
        Integer posicion = integer.valueOf(imagen.Posicion__c);
		system.debug('Comprobar queries aqui');
        
        Id fileId = PantallaSubidaFicherosController.guardarArchivo(parentId, imagen.Title, VersionData, 'tipo', 
                                    imagen.Tipo__c, posicion, imagen.Description, new List<PantallaSubidaFicherosController.DocumentCategoryOptWrapper>(), '', true);
		
        
        PantallaSubidaFicherosController.guardarArchivo(parentId, imagen.Title, '', 'tipo', imagen.Tipo__c, posicion, imagen.Description,
                                    new List<PantallaSubidaFicherosController.DocumentCategoryOptWrapper>(), fileId, true);
        
        ContentVersion imagenInsertada = [SELECT id, VersionData, ContentDocumentId, ParentId__c FROM ContentVersion WHERE Title = 'Imagen prueba' LIMIT 1];
        system.assertEquals(EncodingUtil.base64Encode(imagenInsertada.VersionData), EncodingUtil.base64Encode(imagen.VersionData));
        
        ContentDocumentLink cdl = [SELECT id, ContentDocumentId,  LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: imagen.ParentId__c order by Id asc LIMIT 1];
        //system.assertEquals(cdl.ContentDocumentId, imagenInsertada.ContentDocumentId);
        Test.stopTest();
    }

    @isTest
    public static void testGetCategoryFieldsOK() {
        setCustomCategories();
		
        Test.startTest();
        List<PantallaSubidaFicherosController.DocumentCategoryWrapper> wrappers = PantallaSubidaFicherosController.getCategoryFields();
        Integer i = 0;
        for(PantallaSubidaFicherosController.DocumentCategoryWrapper w : wrappers) {
            DocumentCategory__c cat = cats.get(i);
            System.assertEquals(cat.Level__c, w.level);
            System.assertEquals(cat.Name, w.label);
            if(i == 0) {
                System.assert(!w.disabled);
                System.assert(w.options.size() > 0);
                for(PantallaSubidaFicherosController.DocumentCategoryOptWrapper opt : w.options) {
                    System.assertEquals(cat.Level__c, opt.level);
                    System.assertEquals(cat.Code__c, opt.docCode);
                    System.assertEquals(cat.ParentDirectoryName__c, opt.folderName);
                    System.assertEquals(cat.Name, opt.text);
                    System.assertEquals(cat.Id, opt.value);
                }
            } else {
                System.assert(w.disabled);
                System.assert(w.options == null);
            }
            i++;
        }
        Test.stopTest();
    }

    @isTest
    public static void testGetDependentOptsByParentCat() {
        setCustomCategories();
        Test.startTest();
        List<PantallaSubidaFicherosController.DocumentCategoryOptWrapper> subcats = PantallaSubidaFicherosController.getDependentOptsByParentCat(cats.get(0).Id);
        DocumentCategory__c cat = cats.get(1);
        System.assertEquals(1, subcats.size());
        Test.stopTest();
    }

}