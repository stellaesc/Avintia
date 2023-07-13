@isTest
public class TestUtil {
    
    //Variables
    private static Pais__c pais = crearPais();
    private static Municipio__c localidad = crearLocalidad();
    private static Comunidad_Autonoma__c comunidadAutonoma = crearComunidadAutonoma();
    private static Provincia__c provincia = crearProvincia();
    private static Account CuentaCliente = crearCuentaCliente(); 
    private static Account CuentaSociedad = crearCuentaSociedad();
    private static Account representanteLegalPromocion = crearCuentaPersona();
    private static Contact representanteLegalCliente = testCrearRepresentanteLegalCliente();
    private static Promocion__c promocion = testCrearPromocion(date.newInstance(2018, 10, 29), date.newInstance(2018, 12, 12));
    private static Hitos_De_promocion__c hitosPromocion = testCrearHitosPromocion();
    private static CNO__c cnoObj;
    
    
    private static Opportunity oportunidad;
    private static participante__c participante;
    private static Quote presupuesto;
    private static QuoteLineItem prodPresupuesto;
    private static Factura__c factura;
    private static Plan_de_pagos__c planPagos;

    //private static Contact apoderado;
    
    private static product2 inmueble;
    //private static product2 garaje = testCrearGaraje();
    private static List<product2> listGarajes;
    //private static product2 trastero = testCrearTrastero();
    private static List<product2> listTrastero;
    private static List<product2> listLocales;
    private static PriceBookEntry pbc;
    private static OpportunityLineItem productosOportunidad;
    private static Linea_de_factura__c lineaFactura;    

    
    
   //Metodos accesibles 
    public static Opportunity getOportunidadDocumento_reserva_controller(){
        
           oportunidad = testCrearOportunidad();
           participante = testCrearParticipante();
           representanteLegalCliente = testCrearRepresentanteLegalCliente();
        
           inmueble = testCrearInmueble();
           //garaje = testCrearGaraje();
           listGarajes = testCrearListGarajes(2);
           //trastero = testCrearTrastero();
           listTrastero = testCrearListTrasteros(2);
           pbc = testCrearPriceBookEntry();
           productosOportunidad =  testCrearProductosOportunidad();
        
        return oportunidad;
    }
    
    public static Opportunity getOportunidad_Contrato_Compraventa_Libre_controller(){
        

        	
           oportunidad = testCrearOportunidad();
           participante = testCrearParticipante();
           representanteLegalCliente = testCrearRepresentanteLegalCliente();
        
           inmueble = testCrearInmuebleTipo('Libre');
           //garaje = testCrearGaraje();
           listGarajes = testCrearListGarajes(2);
           //trastero = testCrearTrastero();
           listTrastero = testCrearListTrasteros(2);
           pbc = testCrearPriceBookEntry();
           productosOportunidad =  testCrearProductosOportunidad();
        
        
        return oportunidad;
    }
    
    public static Opportunity getOportunidad_Contrato_Compraventa_VPO_controller(){
        
           oportunidad = testCrearOportunidad();
           participante = testCrearParticipante();
           representanteLegalCliente = testCrearRepresentanteLegalCliente();
        
           inmueble = testCrearInmuebleTipo('VPO');
           //garaje = testCrearGaraje();
           listGarajes = testCrearListGarajes(2);
           //trastero = testCrearTrastero();
           listTrastero = testCrearListTrasteros(2);
           pbc = testCrearPriceBookEntry();
           productosOportunidad =  testCrearProductosOportunidad();
            planPagos = testCrearPlanPagos();
           factura = testCrearFactura();
           Linea_de_factura__c lineaFactura = testCrearLineaFactura();
           
            		
        return oportunidad;
    }
    
    public static Opportunity getOportunidad_Contrato_Compraventa_VPT_controller(){
        
           oportunidad = testCrearOportunidad();
           participante = testCrearParticipante();
           representanteLegalCliente = testCrearRepresentanteLegalCliente();
        
           inmueble = testCrearInmuebleTipo('VPT');
           listLocales = testCrearListLocales(2);
           pbc = testCrearPriceBookEntry();
           productosOportunidad =  testCrearProductosOportunidad();
        
        return oportunidad;
    }
    
    public static Quote getPresupuesto_Ficha_Forma_Pago_controller(){
           oportunidad = testCrearOportunidad();
           participante = testCrearParticipante();
           Tipo_de_inmueble__c tipoInmueble = testCrearTipoInmuebleVivienda();
           inmueble = testCrearInmueble();
           system.debug('tipoInmueble.Tipo__c:::'+tipoInmueble.Tipo__c);
           inmueble.Tipo_de_inmueble__c = tipoInmueble.Id;
           inmueble.isActive = true;
           update inmueble;
           //inmueble = testCrearInmueblePromocion(promocion.Id)[0];
           //listGarajes = testCrearListGarajes(2);
           //listTrastero = testCrearListTrasteros(2);
           pbc = testCrearPriceBookEntry();
           presupuesto = testCrearPresupuesto();
           //prodPresupuesto = testCrearProdPresupuesto();
           testCrearProdPresupuesto();
        return presupuesto;
    }
    
    public static Plan_de_pagos__c getPlan_de_Pagos_controller(){
        
           oportunidad = testCrearOportunidad();
           participante = testCrearParticipante();
           representanteLegalCliente = testCrearRepresentanteLegalCliente();
        
           inmueble = testCrearInmuebleTipo('VPO');
           //garaje = testCrearGaraje();
           listGarajes = testCrearListGarajes(2);
           //trastero = testCrearTrastero();
           listTrastero = testCrearListTrasteros(2);
           pbc = testCrearPriceBookEntry();
           productosOportunidad =  testCrearProductosOportunidad();
           planPagos = testCrearPlanPagos();   
           factura = testCrearFactura();
           Linea_de_factura__c lineaFactura = testCrearLineaFactura();
           
            		
        return planPagos;
    }

    //TEST_PantallaSubidaFicherosController TEST_HL_ContentVersionTrigger
    public static ContentVersion getImagen(){
        
        ContentVersion imagen = testCrearImagen();
        
        return imagen;
    }
    
    //TEST_Documento_factura TEST_BotonEnviarFacturaControllerApex
    public static Factura__c getFactura(){
    
       oportunidad = testCrearOportunidad();
        
        return testCrearFactura();
    }
    
    //TEST_Documento_factura TEST_BotonEnviarFacturaControllerApex
    public static List<Factura__c> getFacturaCuotaExtra(){
    
       List<Factura__c> cuotaExtraList = testCrearFacturaCuotaExtra();
        
       return cuotaExtraList;
    }

     public static void getFacturaNumeroFactura(){
    
       oportunidad = testCrearOportunidad();
       testCrearFacturaCuotaExtra();
       testCrearFacturaProformas();
       testCrearFacturaAbono();
    }
    
    public static Linea_de_factura__c getLineaFactura(){
    
       oportunidad = testCrearOportunidad();
       factura = testCrearFactura();
       lineaFactura = testCrearLineaFactura();
        
       return lineaFactura;
    }
    
    //TEST_PlanoTipoInmuebleController
    public static product2 getInmueble(){
        
           oportunidad = testCrearOportunidad();
           participante = testCrearParticipante();
           representanteLegalCliente = testCrearRepresentanteLegalCliente();
        
           inmueble = testCrearInmueble();
           
        return inmueble;
    }

    public static List<Product2> testCrearInmueblePromocionWithReturn(ID PromoId){
        
        Product2 inmueble = new Product2();
        Product2 inmueble2 = new Product2();
        List<Product2> inmuebles= new List<Product2>();
        
        inmueble.name = 'Inmueble Test';
        inmueble.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda1(PromoId).id;
        inmueble.Precio__c=200.000;
        inmueble.Estado__c='Libre';
        inmueble.Piso__c=1;
        inmueble.Planta__c='1';
        inmueble.WebAvinita__c=true;
        inmueble.Idealista__c=true; 
        inmueble.Fotocasa__c=true;  
        inmueble.Tipologia_de_vivienda__c='Piso';
        inmueble.Promocion__c=PromoId;
        inmueble.Certificado_de_eficiencia_energetica__c='A';
        inmuebles.add(inmueble);

        inmueble2.name = 'Inmueble Test 2';
        inmueble2.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda2(PromoId).id;
        inmueble2.Precio__c=400.000;
        inmueble2.Estado__c='Bloqueado';
        inmueble2.Piso__c=1;
        inmueble2.Planta__c='BAJO';
        inmueble2.WebAvinita__c=false; 
        inmueble2.Tipologia_de_vivienda__c='Bajo';
        inmueble2.Idealista__c=false; 
        inmueble2.Fotocasa__c=false;
        inmueble2.Promocion__c=PromoId;
        inmueble2.Certificado_de_eficiencia_energetica__c='G';

        inmuebles.add(inmueble2);
        insert inmuebles;

        testCrearGaraje(inmueble.Id, PromoId);
        testCrearImgInmueble(inmueble.Id);
        getPlano(inmueble.Tipo_de_inmueble__c);
        return [SELECT Id, Promocion__c,Tipo_de_inmueble__c FROM Product2 WHERE Name = 'Inmueble Test'];
    }
    
    public static void testCrearInmueblePromocion(ID PromoId){
        
        Product2 inmueble = new Product2();
        Product2 inmueble2 = new Product2();
        List<Product2> inmuebles= new List<Product2>();
        
        inmueble.name = 'Inmueble Test';
        inmueble.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda1(PromoId).id;
        inmueble.Precio__c=200.000;
        inmueble.Estado__c='Libre';
        inmueble.Piso__c=1;
        inmueble.Planta__c='1';
        inmueble.WebAvinita__c=true;
        inmueble.Idealista__c=true;  
        inmueble.Fotocasa__c=true;  
        inmueble.Tipologia_de_vivienda__c='Piso';
        inmueble.Promocion__c=PromoId;
        inmueble.Certificado_de_eficiencia_energetica__c='A';
        inmuebles.add(inmueble);

        inmueble2.name = 'Inmueble Test 2';
        inmueble2.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda2(PromoId).id;
        inmueble2.Precio__c=400.000;
        inmueble2.Estado__c='Libre';
        inmueble2.Piso__c=1;
        inmueble2.Planta__c='BAJO';
        inmueble2.WebAvinita__c=false; 
        inmueble2.Tipologia_de_vivienda__c='Bajo';
        inmueble2.Idealista__c=false;  
        inmueble2.Fotocasa__c=false;
        inmueble2.Promocion__c=PromoId;
        inmueble2.Certificado_de_eficiencia_energetica__c='G';

        inmuebles.add(inmueble2);
        insert inmuebles;
       
    }
    
    public static void testCrearInmueblePromocion2(ID PromoId){
        
        Product2 inmueble = new Product2();
        Product2 inmueble2 = new Product2();
        Product2 inmueble3 = new Product2();
        Product2 inmueble4 = new Product2();
        Product2 inmueble5 = new Product2();
        Product2 inmueble6 = new Product2();
        Product2 inmueble7 = new Product2();
        Product2 inmueble8 = new Product2();
        List<Product2> inmuebles= new List<Product2>();
        
        inmueble.name = 'Inmueble Test';
        inmueble.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda1(PromoId).id;
        inmueble.Precio__c=200.000;
        inmueble.Estado__c='Libre';
        inmueble.Piso__c=1;
        inmueble.Planta__c='1';
        inmueble.WebAvinita__c=true;
        inmueble.Idealista__c=true;  
        inmueble.Fotocasa__c=true;  
        inmueble.Tipologia_de_vivienda__c='Piso';
        inmueble.Promocion__c=PromoId;
        inmueble.Certificado_de_eficiencia_energetica__c='A';
        inmueble.Orientacion_Viv__c= 'Norte';
        inmuebles.add(inmueble);

        inmueble2.name = 'Inmueble Test';
        inmueble2.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda2(PromoId).id;
        inmueble2.Precio__c=400.000;
        inmueble2.Estado__c='Bloqueado';
        inmueble2.Piso__c=1;
        inmueble2.Planta__c='0';
        inmueble2.WebAvinita__c=true; 
        inmueble2.Tipologia_de_vivienda__c='Ático';
        inmueble2.Idealista__c=true; 
        inmueble2.Fotocasa__c=true;
        inmueble2.Promocion__c=PromoId;
        inmueble2.Certificado_de_eficiencia_energetica__c='G';
        inmueble.Orientacion_Viv__c= 'Noreste';
        inmuebles.add(inmueble2);
        
        inmueble3.name = 'Inmueble Test';
        inmueble3.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda2(PromoId).id;
        inmueble3.Precio__c=400.000;
        inmueble3.Estado__c='Bloqueado';
        inmueble3.Piso__c=1;
        inmueble3.Planta__c='0';
        inmueble3.WebAvinita__c=true; 
        inmueble3.Tipologia_de_vivienda__c='Ático';
        inmueble3.Idealista__c=true; 
        inmueble3.Fotocasa__c=true;
        inmueble3.Promocion__c=PromoId;
        inmueble3.Certificado_de_eficiencia_energetica__c='G';
        inmueble3.Orientacion_Viv__c= 'Sur';
        inmuebles.add(inmueble3);
        
        inmueble4.name = 'Inmueble Test';
        inmueble4.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda2(PromoId).id;
        inmueble4.Precio__c=400.000;
        inmueble4.Estado__c='Bloqueado';
        inmueble4.Piso__c=1;
        inmueble4.Planta__c='0';
        inmueble4.WebAvinita__c=true; 
        inmueble4.Tipologia_de_vivienda__c='Ático';
        inmueble4.Idealista__c=true; 
        inmueble4.Fotocasa__c=true;
        inmueble4.Promocion__c=PromoId;
        inmueble4.Certificado_de_eficiencia_energetica__c='G';
        inmueble4.Orientacion_Viv__c= 'Este';
        inmuebles.add(inmueble4);
        
        inmueble5.name = 'Inmueble Test';
        inmueble5.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda2(PromoId).id;
        inmueble5.Precio__c=400.000;
        inmueble5.Estado__c='Bloqueado';
        inmueble5.Piso__c=1;
        inmueble5.Planta__c='0';
        inmueble5.WebAvinita__c=true; 
        inmueble5.Tipologia_de_vivienda__c='Ático';
        inmueble5.Idealista__c=true; 
        inmueble5.Fotocasa__c=true;
        inmueble5.Promocion__c=PromoId;
        inmueble5.Certificado_de_eficiencia_energetica__c='G';
        inmueble5.Orientacion_Viv__c= 'Sureste';
        inmuebles.add(inmueble5);
        
        inmueble6.name = 'Inmueble Test';
        inmueble6.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda2(PromoId).id;
        inmueble6.Precio__c=400.000;
        inmueble6.Estado__c='Bloqueado';
        inmueble6.Piso__c=1;
        inmueble6.Planta__c='0';
        inmueble6.WebAvinita__c=true; 
        inmueble6.Tipologia_de_vivienda__c='Ático';
        inmueble6.Idealista__c=true; 
        inmueble6.Fotocasa__c=true;
        inmueble6.Promocion__c=PromoId;
        inmueble6.Certificado_de_eficiencia_energetica__c='G';
        inmueble6.Orientacion_Viv__c= 'Suroeste';
        inmuebles.add(inmueble6);
        
        inmueble7.name = 'Inmueble Test';
        inmueble7.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda2(PromoId).id;
        inmueble7.Precio__c=400.000;
        inmueble7.Estado__c='Bloqueado';
        inmueble7.Piso__c=1;
        inmueble7.Planta__c='0';
        inmueble7.WebAvinita__c=true; 
        inmueble7.Tipologia_de_vivienda__c='Ático';
        inmueble7.Idealista__c=true; 
        inmueble7.Fotocasa__c=true;
        inmueble7.Promocion__c=PromoId;
        inmueble7.Certificado_de_eficiencia_energetica__c='G';
        inmueble7.Orientacion_Viv__c= 'Oeste';
        inmuebles.add(inmueble7);
        
        inmueble8.name = 'Inmueble Test';
        inmueble8.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda2(PromoId).id;
        inmueble8.Precio__c=400.000;
        inmueble8.Estado__c='Bloqueado';
        inmueble8.Piso__c=1;
        inmueble8.Planta__c='0';
        inmueble8.WebAvinita__c=true; 
        inmueble8.Tipologia_de_vivienda__c='Ático';
        inmueble8.Idealista__c=true; 
        inmueble8.Fotocasa__c=true;
        inmueble8.Promocion__c=PromoId;
        inmueble8.Certificado_de_eficiencia_energetica__c='G';
        inmueble8.Orientacion_Viv__c= 'Noroeste';
        inmuebles.add(inmueble8);
        
        insert inmuebles;
       
    }
    public static void testCrearAsociacionDocumentoslViviendas(ID PromoId){

        List<Product2> viviendas =[Select Id,Tipo_de_inmueble__c from Product2 where Promocion__c=:PromoId];
        system.debug('Las viviendas son '+ viviendas.size());

        ContentVersion cv = new ContentVersion();
        cv.title = 'Plano';
        cv.PathOnClient = 'plano.png';
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.Tipo__c = 'Plano';
        cv.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cv.Posicion__c=1;
        insert cv;
        
        List<ContentVersion> cv2 = [SELECT ContentDocumentId, Title, VersionData FROM ContentVersion WHERE id =:cv.Id];
        //system.debug('Las imagenes son '+ cv.id);
        //system.debug('Las imagenes son 2 '+ cv2.get(0).id);
        //system.debug('Las imagenes son 2 '+ cv2.get(0).ContentDocumentId);

        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink> () ;
        for(ContentVersion content2:cv2)
        {
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = content2.ContentDocumentId;
            cdl.LinkedEntityId = viviendas.get(0).Tipo_de_inmueble__c;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            cdlList.add(cdl);
        }
       
        insert cdlList; 
         
    }

    public static void testCrearAsociacionDocumentoslPromocion(ID PromoID){
        List<ContentVersion> cvs =new List<ContentVersion>();
        ContentVersion cv = new ContentVersion();
        cv.title = 'Imagen';
        cv.PathOnClient = 'imagen.png';
        Blob b1=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.Tipo__c = 'Imagen_carrusel';
        cv.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cv.Posicion__c=1;
        cvs.add(cv);
        ContentVersion cvVideo = new ContentVersion();
        cvVideo.title = 'Video';
        cvVideo.PathOnClient = 'video.png';
        Blob b2=Blob.valueOf('Unit Test Attachment Body');
        cvVideo.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cvVideo.Tipo__c = 'Video';
        cvVideo.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cvVideo.Posicion__c=1;
        cvs.add(cvVideo);
        ContentVersion cvFolleto = new ContentVersion();
        cvFolleto.title = 'Folleto';
        cvFolleto.PathOnClient = 'folleto.pdf';
        Blob b3=Blob.valueOf('Unit Test Attachment Body');
        cvFolleto.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cvFolleto.Tipo__c = 'Folleto';
        cvFolleto.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cvFolleto.Posicion__c=1;
        cvs.add(cvFolleto);
        ContentVersion cvCarruselLife1 = new ContentVersion();
        cvCarruselLife1.title = 'Life1';
        cvCarruselLife1.PathOnClient = 'prueba1.png';
        cvCarruselLife1.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cvCarruselLife1.Tipo__c = 'Carrusel_lifestyle';
        cvCarruselLife1.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cvCarruselLife1.Posicion__c=1;
        cvs.add(cvCarruselLife1);
        ContentVersion cvCarruselLife2 = new ContentVersion();
        cvCarruselLife2.title = 'Life2';
        cvCarruselLife2.PathOnClient = 'prueba1.png';
        cvCarruselLife2.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cvCarruselLife2.Tipo__c = 'Carrusel_lifestyle';
        cvCarruselLife2.Posicion__c=2;
        cvCarruselLife2.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cvs.add(cvCarruselLife2);
        ContentVersion cvCarruselLife3 = new ContentVersion();
        cvCarruselLife3.title = 'Life2';
        cvCarruselLife3.PathOnClient = 'prueba1.png';
        cvCarruselLife3.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cvCarruselLife3.Tipo__c = 'Carrusel_lifestyle';
        cvCarruselLife3.Posicion__c=3;
        cvCarruselLife3.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cvs.add(cvCarruselLife3);

        ContentVersion cvCarruselEntorno = new ContentVersion();
        cvCarruselEntorno.title = 'Entorno';
        cvCarruselEntorno.PathOnClient = 'entorno.png';
        cvCarruselEntorno.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cvCarruselEntorno.Tipo__c = 'Carrusel_entorno';
        cvCarruselEntorno.Posicion__c=3;
        cvCarruselEntorno.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cvs.add(cvCarruselEntorno);
        ContentVersion cvPieWeb = new ContentVersion();
        cvPieWeb.title = 'PieWeb';
        cvPieWeb.PathOnClient = 'PieWeb.png';
        cvPieWeb.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cvPieWeb.Tipo__c = 'Pie_de_web';
        cvPieWeb.Posicion__c=1;
        cvPieWeb.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cvs.add(cvPieWeb);

        ContentVersion imagenFinanciera = new ContentVersion();
        imagenFinanciera.title = 'imagenFinanciera';
        imagenFinanciera.PathOnClient = 'imagenFinanciera.png';
        imagenFinanciera.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        imagenFinanciera.Tipo__c = 'Imagen_financiera';
        imagenFinanciera.Posicion__c=1;
        imagenFinanciera.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cvs.add(imagenFinanciera);

        ContentVersion memoriaCalidades = new ContentVersion();
        memoriaCalidades.title = 'memoriaCalidades';
        memoriaCalidades.PathOnClient = 'memoriaCalidades.png';
        memoriaCalidades.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        memoriaCalidades.Tipo__c = 'Memoria_calidades';
        memoriaCalidades.Posicion__c=1;
        memoriaCalidades.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cvs.add(memoriaCalidades);

        ContentVersion planosZonasComunes = new ContentVersion();
        planosZonasComunes.title = 'planos';
        planosZonasComunes.PathOnClient = 'planos.pdf';
        planosZonasComunes.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        planosZonasComunes.Tipo__c = 'Planos_zonas_comunes';
        planosZonasComunes.Posicion__c=1;
        planosZonasComunes.URL__c='https://grupoavintia--despro.my.salesforce.com/sfc/p/n000000099Uk/a/n00000008Rbp/mmBR6Hw9rpqPbhq_I1Eju1en2TwPsu.YWpA2EHMdPV8';
        cvs.add(planosZonasComunes);



        insert cvs;
        Set<id> setContentDocument = new Set<id>();
        for(ContentVersion content:cvs)
        {
            setContentDocument.add(content.ID);
        }
        
        List<ContentVersion> cv2 = [SELECT ContentDocumentId, Title, VersionData FROM ContentVersion WHERE id in :setContentDocument];
        List<ContentDocumentLink> cdlList =new List<ContentDocumentLink> () ;
        for(ContentVersion content2:cv2)
        {
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = content2.ContentDocumentId;
            cdl.LinkedEntityId = PromoID;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            cdlList.add(cdl);
        }
       
        insert cdlList; 
    }
    
    public static ContentVersion getPlano(Id IdTipoInmueble){
           
       
        return testCrearPlano(IdTipoInmueble);
    }
    
    //TEST_promocion
    public static Promocion__c getPromocion(Date inicio, Date fin){
        
        return  testCrearPromocion(inicio, fin);
    }
    
    //TEST_promocion
    public static Map<id,Ritmo_ventas__c> getRitmoVentas(Id promocionId){
        
        return  testGetRitmosDeVentas(promocionId);
    }
    
    //TEST_promocion
    public static OpportunityLineItem getProductoOportunidad(){
        
        inmueble = testCrearInmueble();
        oportunidad =  testCrearOportunidad();
        
        pbc = testCrearPriceBookEntry();
        
        
        return  testCrearProductosOportunidad();
    }
    
    
    //Metodos privados
    public static Map<String, User> crearUsuarios(){
        
        //Profile perfilAdministrador = [Select Id from profile where Name='Administrador del sistema']; 
        Profile perfilComercial = [Select Id from profile where Name='Comercial']; 
        Profile perfilComercialAPI = [Select Id from profile where Name='Comercial API']; 
        Profile perfilPlanificacion = [Select Id from profile where Name='Planificación']; 
        Profile perfilMarketing = [Select Id from profile where Name='Marketing']; 
        Profile perfilTecnico = [Select Id from profile where Name='Departamento Técnico']; 
        
        Map<String, User> mapUsuarios = new Map<String, User>();

        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 

        User usuarioComercial = new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US',
                         isActive = true,
                         ProfileId = perfilComercial.Id
                        ); 
        
        MapUsuarios.put('Comercial' ,usuarioComercial);
        
        User usuarioComercialAPI = new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@testapi' + orgId + '.org', 
                         Username = uniqueName + '@testapi' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US',
                         isActive = true,
                         ProfileId = perfilComercialAPI.Id
                        ); 
        
        MapUsuarios.put('Comercial_API' , usuarioComercialAPI);
        
		User usuarioPlanificacion =new User(firstname = 'ABC2', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test1' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         isActive = true,
                         ProfileId = perfilPlanificacion.Id
                        ); 
        
        MapUsuarios.put('Planificacion' ,usuarioPlanificacion);
        
		User usuarioMarketing = new User(firstname = 'ABC3', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test2' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US',
                         isActive = true,
                         ProfileId = perfilMarketing.Id
                        ); 
        
        MapUsuarios.put('Marketing' ,usuarioMarketing);
        
		User usuarioTecnico = new User(firstname = 'ABC4', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test3' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US',
                         isActive = true,
                         ProfileId = perfilTecnico.Id
                        ); 
        
        MapUsuarios.put('Tecnico' ,usuarioTecnico);
        
        insert MapUsuarios.values();

        return MapUsuarios;
         
    }

	private static Pais__c crearPais(){
        
        Pais__c pais = new Pais__c();
        pais.name = 'España';
        pais.Codigo_ISO3__c='ESP';
        insert pais;
        return pais;
    }
    
    private static Comunidad_Autonoma__c crearComunidadAutonoma(){
        
        Comunidad_Autonoma__c comunidadAutonoma = new Comunidad_Autonoma__c();
        comunidadAutonoma.name = 'Madrid';
        comunidadAutonoma.Pais__c = pais.id;
        
        insert comunidadAutonoma;
        return comunidadAutonoma;
    }	
    
    private static Provincia__c crearProvincia(){
        
        Provincia__c provincia = new Provincia__c();
        provincia.name = 'Madrid';
        provincia.Codigo__c=8;
        provincia.Comunidad_autonoma__c = crearComunidadAutonoma().id;
        
        
        insert provincia;
        return provincia;
    }
    
    private static Municipio__c crearLocalidad(){
        
        Municipio__c localidad = new Municipio__c();
        localidad.name = 'Madrid';
        localidad.Codigo_municipio__c = 28;

        localidad.provincia__c = crearProvincia().id;
        
        insert localidad;
        return localidad;
    }

    private static CNO__c createCNO() {
        CNO__c cnoObj = new CNO__c(
            Codigo__c = '1212',
            Name = 'CNO TEST',
            FullName__c = 'CNO TEST'
        );
        insert cnoObj;
        System.debug('CNO: ' + cnoObj);
        return cnoObj;
    }
    
    private static Account crearCuentaCliente(){
        if(cnoObj == null) cnoObj = createCNO();
        Account cuenta = new Account();
        
        cuenta.name = 'Cuenta test1';
        cuenta.Movil_empresa__c = '660112233';
        cuenta.Email__c = 'test@test.test';
        cuenta.Tipo_de_documento__c = 'CIF';
        cuenta.N_Documento__c = 'B85984000';
        cuenta.AccountSource = 'Caseta';
        cuenta.Nacionalidad__c = pais.Id;
        cuenta.Fecha_constitucion__c = date.newInstance(2018, 3, 13);
        
        //Dirección fiscal
        cuenta.Tipo_de_via_FISCAL__c = 'Calle';
        cuenta.Puerta_FISCAL__c = 'a';
        cuenta.Nombre_de_via_FISCAL__c = 'via';
        cuenta.NumeroViaFiscalText__c = '4';
        cuenta.Pais_FISCAL__c = pais.Id;
        cuenta.Localidad_FISCAL__c = localidad.Id;
        cuenta.Escalera_FISCAL__c = 'a';
        cuenta.Codigo_postal_FISCAL__c = '23456';
        //Dirección de facturación
        cuenta.DF_Tipo_de_via__c = 'Calle';
        cuenta.DF_Puerta__c = 'a';
        cuenta.DF_Nombre_via__c = 'via';
        cuenta.NumeroVia2Text__c = '4';
        cuenta.DF_Pais__c = pais.Id;
        cuenta.DF_Localidad__c = localidad.Id;
        cuenta.DF_Escalera__c = 'a';
        cuenta.DF_Codigo_postal__c = '23456';
        //Dirección de facturación
        cuenta.DP_Tipo_de_via__c = 'Calle';
        cuenta.DP_Puerta__c = 'a';
        cuenta.DP_Nombre_via__c = 'via';
        cuenta.NumeroViaText__c = '4';
        cuenta.DP_Pais__c = pais.Id;
        cuenta.DP_Localidad__c = localidad.Id;
        cuenta.DP_Escalera__c = 'a';
        cuenta.DP_Codigo_postal__c = '23456';
        
        //
        cuenta.tomo__c = '1';
        cuenta.Seccion__c ='2';
        cuenta.Folio__c ='3';
        cuenta.N_Hoja__c ='4';

        cuenta.CNO__c = cnoObj.Id;
        cuenta.N_Documento__c = '12567893A';
        cuenta.Tipo_de_documento__c = 'NIF';
        cuenta.AccountSource = 'PUNTO DE VENTA';
        cuenta.Estado_comercial__c = 'Cliente Gestión';
        cuenta.Nacionalidad__c = pais.Id;
        cuenta.Tipo_de_sociedad__c = 'TS01';
        cuenta.DP_Pais__c = pais.Id;
        
        //cuenta.Lugar_de_notaria__pc
        //cuenta.Estado_Civil__pc
        //cuenta.RecordTypeId

        insert cuenta;
        system.debug('CREA CUENTA');
        return cuenta;
        
    }
    
    private static Account crearCuentaSociedad(){
        Account cuentaSociedad = new Account();
        cuentaSociedad.Codigo_de_sociedad__c = 'CodigoSociedadTest';
        cuentaSociedad.name = 'Cuenta Sociedad test1';
        cuentaSociedad.RecordTypeId = SObjectUtils.getRecordTypeId(Account.sObjectType, 'Sociedad');
        cuentaSociedad.Movil_empresa__c = '660112233';
        cuentaSociedad.Email__c = 'testSociedad@test.test';
        cuentaSociedad.Tipo_de_documento__c = 'NIF';
        cuentaSociedad.N_Documento__c = '35101068G';
        cuentaSociedad.AccountSource = 'Caseta';
        cuentaSociedad.Nacionalidad__c = pais.Id;
        cuentaSociedad.Fecha_constitucion__c = date.newInstance(2018, 3, 13);
        
        //Dirección fiscal
        cuentaSociedad.Tipo_de_via_FISCAL__c = 'Calle';
        cuentaSociedad.Puerta_FISCAL__c = 'a';
        cuentaSociedad.Nombre_de_via_FISCAL__c = 'via';
        cuentaSociedad.NumeroViaFiscalText__c = '4';
        cuentaSociedad.Pais_FISCAL__c = pais.Id;
        cuentaSociedad.Localidad_FISCAL__c = localidad.Id;
        cuentaSociedad.Escalera_FISCAL__c = 'a';
        cuentaSociedad.Codigo_postal_FISCAL__c = '23456';
        //Dirección de facturación
        cuentaSociedad.DF_Tipo_de_via__c = 'Calle';
        cuentaSociedad.DF_Puerta__c = 'a';
        cuentaSociedad.DF_Nombre_via__c = 'via';
        cuentaSociedad.NumeroVia2Text__c = '4';
        cuentaSociedad.DF_Pais__c = pais.Id;
        cuentaSociedad.DF_Localidad__c = localidad.Id;
        cuentaSociedad.DF_Escalera__c = 'a';
        cuentaSociedad.DF_Codigo_postal__c = '23456';
        //Dirección de facturación
        cuentaSociedad.DP_Tipo_de_via__c = 'Calle';
        cuentaSociedad.DP_Puerta__c = 'a';
        cuentaSociedad.DP_Nombre_via__c = 'via';
        cuentaSociedad.NumeroViaText__c = '4';
        cuentaSociedad.DP_Pais__c = pais.Id;
        cuentaSociedad.DP_Localidad__c = localidad.Id;
        cuentaSociedad.DP_Escalera__c = 'a';
        cuentaSociedad.DP_Codigo_postal__c = '23456';
        //Otros datos
        cuentaSociedad.tomo__c = '1';
        cuentaSociedad.seccion__c = '2';
        cuentaSociedad.Folio__c = '3';
        cuentaSociedad.N_hoja__c = '4';
        cuentaSociedad.Lugar_del_registro__c = 'Segovia';
        cuentaSociedad.nombre_del_notario__c = 'Pedro Perez';
        cuentaSociedad.numero_De_protocolo__c = 12345;
        cuentaSociedad.Fecha_de_escritura__c = date.newInstance(date.today().year(),date.today().month(), date.today().day());
        
        insert cuentaSociedad;
        system.debug('CREA CUENTA SOCIEDAD');
        return cuentaSociedad;
        
    }
    
    private static Account crearCuentaPersona(){
        if(cnoObj == null) cnoObj = createCNO();
        Account cuentaPersona = new Account();
        cuentaPersona.firstname = 'Cuenta persona test1';
        cuentaPersona.lastname = 'test1';
        cuentaPersona.RecordTypeId =   SObjectUtils.getRecordTypeId(Account.sObjectType, 'PersonAccount');
        cuentaPersona.Movil_empresa__c = '660112233';
        cuentaPersona.Email__c = 'testPersona@test.test';
        cuentaPersona.Tipo_de_documento__c = 'NIF';
        cuentaPersona.N_Documento__c = '35101068Y';
        cuentaPersona.AccountSource = 'Caseta';
        cuentaPersona.Nacionalidad__c = pais.Id;
        cuentaPersona.Nacionalidad__pc = pais.Id;
        cuentaPersona.Fecha_constitucion__c = date.newInstance(2018, 3, 13);
        
        //Dirección fiscal
        cuentaPersona.Tipo_de_via_FISCAL__c = 'Calle';
        cuentaPersona.Puerta_FISCAL__c = 'a';
        cuentaPersona.Nombre_de_via_FISCAL__c = 'via';
        cuentaPersona.NumeroViaFiscalText__c = '4';
        cuentaPersona.Pais_FISCAL__c = pais.Id;
        cuentaPersona.Localidad_FISCAL__c = localidad.Id;
        cuentaPersona.Escalera_FISCAL__c = 'a';
        cuentaPersona.Codigo_postal_FISCAL__c = '23456';
        //Dirección de facturación
        cuentaPersona.DF_Tipo_de_via__c = 'Calle';
        cuentaPersona.DF_Puerta__c = 'a';
        cuentaPersona.DF_Nombre_via__c = 'via';
        cuentaPersona.NumeroVia2Text__c = '4';
        cuentaPersona.DF_Pais__c = pais.Id;
        cuentaPersona.DF_Localidad__c = localidad.Id;
        cuentaPersona.DF_Escalera__c = 'a';
        cuentaPersona.DF_Codigo_postal__c = '23456';
        //Dirección de facturación
        cuentaPersona.DP_Tipo_de_via__c = 'Calle';
        cuentaPersona.DP_Puerta__c = 'a';
        cuentaPersona.DP_Nombre_via__c = 'via';
        cuentaPersona.NumeroViaText__c = '4';
        cuentaPersona.DP_Pais__c = pais.Id;
        cuentaPersona.DP_Localidad__c = localidad.Id;
        cuentaPersona.DP_Escalera__c = 'a';
        cuentaPersona.DP_Codigo_postal__c = '23456';

        cuentaPersona.CNO__c = cnoObj.Id;

        //Otros datos
        cuentaPersona.tomo__c = '1';
        cuentaPersona.seccion__c = '2';
        cuentaPersona.Folio__c = '3';
        cuentaPersona.N_hoja__c = '4';
        cuentaPersona.Lugar_del_registro__c = 'Segovia';
        cuentaPersona.nombre_del_notario__c = 'Pedro Perez';
        cuentaPersona.numero_De_protocolo__c = 12345;
        cuentaPersona.Fecha_de_escritura__c = date.newInstance(date.today().year(),date.today().month(), date.today().day());
        
        insert cuentaPersona;
        system.debug('CREA CUENTA PERSONA');
        return cuentaPersona;
        
    }
    
    
    
    private static Promocion__c testCrearPromocion(Date inicio, Date fin){
        
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        if(spCustomSettings.spClientId__c == null) {
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

		Map<String, User> usuarios = crearUsuarios();
        

     	promocion__c promocion = new promocion__c();
        promocion.name = 'Promocion test';
        promocion.Nombre_Comercial_Avintia_Inmobiliaria__c = 'Promocion test';
        promocion.fase__c = 'Anteproyecto';
        promocion.estado__c = 'Alta promoción';
        promocion.Descricion_pequena__c='prueba';
        promocion.Slogan__c='Prueba slogan';
        promocion.Descripcion__c='DEscipcion';
        promocion.Telefono_promocion_comercializadora__c='912345890';
        promocion.Email_promocion_comercializadora__c='correo@correo.es';
        promocion.Superficie_total_de_parcela__c=3450;
        promocion.N_Plantas__c='3';
        promocion.N_Viviendas_totales_promocion__c=6;

        promocion.Piscina_Exterior__c=true;
        promocion.Zona_Infantil__c=true;
        promocion.Spa__c=true;
        promocion.Pistas_deportivas__c=true;
        promocion.Padel__c=true;
        promocion.Jardines__c=true;
        promocion.Gimnasio__c=true;
        promocion.Terrazas_Mirador__c=true;
        promocion.Zona_Gourmet__c=true;
        promocion.Ascensores__c=true;
        promocion.Sala_Multidisciplinar__c=true;
        promocion.Coordenadas__Latitude__s=39.443071;
        promocion.Coordenadas__Longitude__s=-0.377865;
        promocion.WebAvinita__c=true;
        promocion.Idealista__c=true;
        promocion.Fotocasa__c=true;
     
        //Ritmo de ventas
        promocion.N_Unidades_iniciales_ritmo_de_ventas__c = 1;
        promocion.Ritmo_de_ventas__c = 3;

        
        promocion.Tecnico__c = usuarios.get('Tecnico').id;
        promocion.Comercial__c = usuarios.get('Comercial').id;
        promocion.Comercial_API__c = usuarios.get('Comercial_API').id;
        promocion.Marketing__c = usuarios.get('Marketing').id;
		promocion.Planificacion__c = usuarios.get('Planificacion').id;
        
        promocion.Socio_Empresa_Promotora__c = cuentaSociedad.id;
        
        promocion.Tipo_via__c = 'Calle'; 
        promocion.Nombre_via__c = 'Real';
        promocion.Codigo_Postal__c = '12345';
        promocion.N_Via__c = 23; 
        promocion.Pais__c=crearPais().id;
        promocion.Localidad__c=crearLocalidad().id;
        promocion.N_Viviendas_totales_promocion__c = 48;
       	promocion.Informacion_de_arquitectos_de_obra__c = 'Arquitectos tecnicos Juan Ramon y Pedro';
        promocion.Lugar_de_la_notaria__c = 'Sevilla';
        promocion.Cuenta_Activa_1__c = true;
        promocion.Cuenta_Activa_2__c = false;
        promocion.Numero_de_cuenta_bancaria_1__c = 'ES1000492352082414205416';
      	promocion.Numero_de_cuenta_bancaria_2__c ='ES1720852066623456789011';
        promocion.Titularidad_de_la_cuenta1__c = 'Titulares ...';
		promocion.Titularidad_de_la_cuenta2__c = 'Titulares ...';
        promocion.Entidad_Bancaria1__c = 'Banco Santander';
        promocion.Entidad_Bancaria2__c = 'Banco BBVA';
        promocion.Condicion__c = 'Apoderado';
        promocion.Comercializa__c = 'ADI';
        promocion.Aprobar_tarifario__c = false;
        promocion.Contact__c = testCrearApoderado().id;
    
             
        
        //Campos que se pasan a oportunidad (Process builder)
        promocion.inicio_de_escrituraciones__c = date.today();
        promocion.Porcentaje_pago_contrato__c = 10;
        promocion.Porcentaje_pago_firma_contrato__c = 10;
        promocion.Porcentaje_pago_escritura__c = 80;
        promocion.porcentaje_penalizacion_contrato__c = 5;
        promocion.porcentaje_penalizacion_escritura__c = 5;
        promocion.porcentaje_penalizacion_escritura__c = 5;
        promocion.porcentaje_penalizacion_reserva__c = 30;
        promocion.periodo_de_reserva__c = 30;
        promocion.porcentaje_iva__c = 10;
        promocion.Cantidad_de_reserva__c = 3000;
        promocion.Tipo_de_reserva__c = 'Reserva con IVA';
        
        //Fechas
        promocion.Inicio_de_escrituraciones__c = date.today().toStartOfMonth().addDays(30);
        promocion.Inicio_comercializacion_prevista__c = inicio;
        promocion.Fin_comercializacion_prevista__c = fin;
        promocion.fecha_de_escritura__c = date.today().toStartOfMonth().addDays(30);
        promocion.PublicacionViviendasBaboonlab__c = true;

        //Generar numero facturas
        promocion.Envio_Oracle__c = true;
        
        insert promocion;
        
        return promocion;
        
    }
    
    private static Hitos_de_Promocion__c testCrearHitosPromocion(){
        
        Hitos_de_Promocion__c hitosPromocion = new Hitos_de_Promocion__c();
        
        hitosPromocion.name = 'Hitos promocion Test';
        hitosPromocion.Promocion__c = promocion.id;
        hitosPromocion.Aprobacion_de_la_licencia_de_obras__c = date.today();
        
        insert hitosPromocion;
        return hitosPromocion;
        
    }
    
     public static Hitos_de_Promocion__c getHitos(Id promocionId){
        

        Hitos_de_Promocion__c hitosPromocion = new Hitos_de_Promocion__c();
        
        hitosPromocion.name = 'Hitos promocion Test';
        hitosPromocion.Promocion__c = promocionId;
        hitosPromocion.Aprobacion_de_la_licencia_de_obras__c = date.today();
        hitosPromocion.Inicio_de_obra__c = date.today()+1;
        hitosPromocion.Fin_de_obra__c = date.today()+ 130;
      
         
        insert hitosPromocion;
        return hitosPromocion;
        
    }
    
    public static Hitos_de_Promocion__c getHitos2(Id promocionId){
        
        Hitos_de_Promocion__c hitosPromocion = new Hitos_de_Promocion__c();
        
        hitosPromocion.name = 'Hitos promocion Test';
        hitosPromocion.Promocion__c = promocionId;
        hitosPromocion.Aprobacion_de_la_licencia_de_obras__c = date.today();
        hitosPromocion.Inicio_de_obra__c = date.today()-1;
        hitosPromocion.Fin_de_obra__c = date.today()+ 130;
      
         
        insert hitosPromocion;
        return hitosPromocion;
        
    }
     public static Hitos_de_Promocion__c getHitos3(Id promocionId){
        
        Hitos_de_Promocion__c hitosPromocion = new Hitos_de_Promocion__c();
        
        hitosPromocion.name = 'Hitos promocion Test';
        hitosPromocion.Promocion__c = promocionId;
        hitosPromocion.Aprobacion_de_la_licencia_de_obras__c = date.today();
        hitosPromocion.Fin_de_obra__c = date.today()+ 130;
      
         
        insert hitosPromocion;
        return hitosPromocion;
        
    }
   
    private static Map<id,Ritmo_ventas__c> testGetRitmosDeVentas(Id promocionId){
    	
        
        Map<id,Ritmo_ventas__c> mapRitmosVentas = new  Map<id,Ritmo_ventas__c>(
            [SELECT id, name, Fecha_inicio_periodo__c, Fecha_fin_periodo__c, N_semana__c FROM Ritmo_ventas__c WHERE promocion__c =: promocionId]);
        
        return mapRitmosVentas;
        
    }
    
    
    //Crear oportunidad
    private static Opportunity testCrearOportunidad(){
         

        Opportunity oportunidad = new Opportunity();
        
        oportunidad.name = 'Oportunidad Test';
        oportunidad.AccountId = cuentaCliente.id;
        oportunidad.Promocion__c = promocion.id;
        oportunidad.Pago_Contrato_al_contado__c = 10;
        oportunidad.Pago_Escritura__c = 80;
        oportunidad.Penalizacion_Reserva__c = 25;
        oportunidad.Pago_Contrato__c = 10;
        
        oportunidad.StageName = 'Reserva';
        oportunidad.Periodo_de_Reserva__c = date.newInstance(2018, 11, 24); 
        oportunidad.closeDate = date.newInstance(2018, 11, 24); 
        oportunidad.Promocion__c = promocion.id;
        oportunidad.Pricebook2Id = Test.getStandardPricebookId();
        oportunidad.Penalizacion_Contrato__c = 2.00;
        oportunidad.amount = 200000;
		oportunidad.Porcentaje_IVA__c = 10;
        oportunidad.Importe_de_Cuota__c = 15000;
        oportunidad.reserva__c = 2000;
        oportunidad.Tipo_De_reserva__c = 'Reserva con IVA';
        oportunidad.Amount = 200000;
        oportunidad.Cuenta_Bancaria_de_mandato__c='ES1720852066623456789011';
        
        oportunidad.Fecha_firma_Contrato_Compraventa__c = date.today();
        oportunidad.Fecha_firma_Contrato_Reserva__c = date.today();
        oportunidad.Fecha_de_primera_cuota__c = date.today().toStartOfMonth();
		oportunidad.Fecha_de_escrituracion__c = oportunidad.Fecha_de_primera_cuota__c.addDays(30);
        
        //Cuotas extra
        oportunidad.Numero_Cuotas_Extra__c = 12;
        oportunidad.Importe_Cuota_Extra__c = 1000;
        oportunidad.Cuentas__c ='Cuentas Operativas';
        
        
        insert oportunidad;
        system.debug('CREA OPORTUNIDAD');
        return oportunidad;
    }
    
    private static OpportunityLineItem testCrearProductosOportunidad(){
	
        
        OpportunityLineItem productoOportunidad = new OpportunityLineItem();
        
        productoOportunidad.OpportunityId = Oportunidad.Id;
        productoOportunidad.Product2Id = Inmueble.id;
        productoOportunidad.PriceBookEntryId = pbc.id;
        productoOportunidad.Quantity = 1;
        productoOportunidad.UnitPrice = 10;
            

        insert productoOportunidad;
        
        
        return productoOportunidad;
    }

    public static Quote testCrearPresupuesto(){
    
        Quote presupuesto = new Quote();
        
        presupuesto.name = 'Presupuesto Test';
        presupuesto.OpportunityId = Oportunidad.Id;
        presupuesto.Pricebook2Id = Utils.getStandarPriceBook();
        
        insert presupuesto;
        
        return presupuesto;
        
    }
    
    public static QuoteLineItem testCrearProdPresupuesto(){
    
        QuoteLineItem prodPresupuesto = new QuoteLineItem();
        
        prodPresupuesto.QuoteId = presupuesto.Id;
        prodPresupuesto.Quantity = 1;
        prodPresupuesto.Product2Id = Inmueble.id;
        prodPresupuesto.UnitPrice = Inmueble.Precio__c;
        
        insert prodPresupuesto;
        
        return prodPresupuesto;
        
    }
    
    
    private static Participante__c testCrearParticipante(){
        
        Participante__c participante = new Participante__c();
        
        participante.name = 'test Participante';
        participante.Opportunity__c = Oportunidad.id;
        participante.Cliente__c = cuentaCliente.Id;
        participante.Porcentaje_de_participacion__c = 100;
        
        insert participante;
        return participante;
        
        
    }
    
    private static Contact testCrearRepresentanteLegalCliente(){
        System.debug('Representante legal');
        
        Contact representanteLegalCliente = new Contact();
        representanteLegalCliente.lastName = 'Representate test';
        representanteLegalCliente.Lugar_de_notaria__c = 'Segovia';
        representanteLegalCliente.Fecha_de_Escritura__c = date.today();
        representanteLegalCliente.Nombre_notario__c = 'Pablo Gómez';
        representanteLegalCliente.Numero_de_protocolo__c = '123456';
        representanteLegalCliente.N_Documento__c = '78456271L';
        representanteLegalCliente.Tipo_de_documento__c = 'NIF';
        representanteLegalCliente.AccountId = CuentaCliente.id;
        representanteLegalCliente.Representante_legal__c = true;
        
        
        System.debug('TestUtil Crear representanteLegalCliente');
        
        insert representanteLegalCliente;
        return representanteLegalCliente;
        
    }
    
    private static Contact testCrearApoderado(){
        
        Contact apoderado = new Contact();
        
        apoderado.lastName = 'Representate test';
        apoderado.Lugar_de_notaria__c = 'Segovia';
        apoderado.Fecha_de_Escritura__c = date.today();
        apoderado.Nombre_notario__c = 'Pablo Gómez';
        apoderado.Numero_de_protocolo__c = '123456';
        apoderado.N_Documento__c = '78456271L';
        apoderado.Tipo_de_documento__c = 'NIF';
        apoderado.Representante_legal__c = true;
        
        
        insert apoderado;
        return apoderado;
        
    }
    
    public static Product2 testCrearInmueble(){
        
        Product2 inmueble = new Product2();
        
        inmueble.name = 'Inmueble Test';
        inmueble.Precio__c = 200000;
        inmueble.Estado__c = 'Libre';
        inmueble.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda().id;
        inmueble.isActive = true;
            

        insert inmueble;
       
        return inmueble;
    }
    
    
    
    private static Product2 testCrearInmuebleTipo(String tipoVivienda /*Libre, VPO, VPT*/){
        
        
        Product2 inmueble = new Product2();
        inmueble.name = 'Inmueble Test';
        inmueble.Tipo_de_inmueble__c = testCrearTipoInmuebleVivienda().id;
        inmueble.Tipo_de_vivienda__c = tipoVivienda;
        inmueble.Estado__c = 'Libre';
        inmueble.isActive = true;
            

        insert inmueble;
       
        return inmueble;
    }
    
    /*public static List<Product2> testCrearInmuebles(){
        
        Map<Integer, Product2> mapInmuebles = new Map<Integer, Product2>();
        
        for(integer i = 0; i < 10; i++){
            
            Product2 inmueble = new Product2();
            inmueble.name = 'Inmueble Test'+i;
            
            mapInmuebles.put(i, inmueble);
        }
        
        insert mapInmuebles.values();
        
        List<Product2> listInmueblesReturn = [SELECT id, name FROM Product2 WHERE name LIKE 'Inmueble Test%'];
        
        system.debug('CREA INMUEBLES');
        return listInmueblesReturn;
    }*/
    
    
    private static Tipo_de_inmueble__c testCrearTipoInmuebleVivienda(){
        
        
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
       
        return tipoInmueble;
    }

    private static Tipo_de_inmueble__c testCrearTipoInmuebleVivienda1(ID Promoid){
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
       
        return tipoInmueble;
    }

    private static Tipo_de_inmueble__c testCrearTipoInmuebleVivienda2(ID Promoid){
        
        
        Tipo_de_inmueble__c tipoInmueble = new Tipo_de_inmueble__c();
        tipoInmueble.name = 'Tipo de Inmueble Vivienda Test';
        tipoInmueble.Tipo__c = 'Vivienda';
        tipoInmueble.N_de_habitaciones__c = 2;
        tipoInmueble.N_de_banos__c=1;
        tipoInmueble.Superficie_Terrazas_Descubiertas__c=7;
        tipoInmueble.Superficie_Terrazas_Cubiertas__c=6;
        tipoInmueble.Superficie_Jardines__c=12;
        tipoInmueble.Superficie_Construida_m2__c = 50;
        tipoInmueble.Promocion__c=Promoid;
        tipoInmueble.Superficie_Util_m2__c=55;
        tipoInmueble.Superficie_Construida_total_con_ZZCC_m2__c=60;
 
               
        
        insert tipoInmueble;
       
        return tipoInmueble;
    }
    
    //Garajes
    private static Product2 testCrearGaraje(Id inmuebleId, Id promoId){
        
        Product2 garaje = new Product2();
        garaje.Promocion__c = promoId;
        garaje.name = 'Garaje Test';
        garaje.Tipo_de_inmueble__c = testCrearTipoInmuebleGaraje().id;
        garaje.inmueble_asociado__c = inmuebleId;
        garaje.precio__c = 1000;
            

        insert garaje;
       
        return garaje;
    }
    
    private static List<Product2> testCrearListGarajes(integer numero){
        
        List<Product2> listGarajes = new List<Product2>();
        
        for(integer i = 0; i < numero; i++){
            
            Product2 garaje = new Product2();
            
            garaje.name = 'Garaje Test '+i;
            garaje.Tipo_de_inmueble__c = testCrearTipoInmuebleGaraje().id;
            garaje.inmueble_asociado__c = inmueble.id;
            listGarajes.add(garaje);
        }
        
        insert listGarajes;
       
        return listGarajes;
    }
    
    private static Tipo_de_inmueble__c testCrearTipoInmuebleGaraje(){
        
        
        Tipo_de_inmueble__c tipoInmueble = new Tipo_de_inmueble__c();
        tipoInmueble.name = 'Tipo de Inmueble Garaje Test';
        tipoInmueble.Tipo__c = 'Garaje';
        tipoInmueble.Superficie_Construida_m2__c = 10;
        
        insert tipoInmueble;
       
        return tipoInmueble;
    }
    
    //Trasteros
    private static Product2 testCrearTrastero(){
        
        
        Product2 trastero = new Product2();
        trastero.name = 'Trastero Test';
        trastero.Tipo_de_inmueble__c = testCrearTipoInmuebleTrastero().id;
        trastero.inmueble_asociado__c = inmueble.id;
            

        insert trastero;
       
        return trastero;
    }
    
    private static List<Product2> testCrearListTrasteros(integer numero){
        
        List<Product2> listTrasteros = new List<Product2>();
        
        for(integer i = 0; i < numero; i++){
            
            Product2 trastero = new Product2();
            
            trastero.name = 'Trastero Test '+i;
            trastero.Tipo_de_inmueble__c = testCrearTipoInmuebleTrastero().id;
            trastero.inmueble_asociado__c = inmueble.id;
            listTrasteros.add(trastero);
        }
        
        insert listTrasteros;
       
        return listTrasteros;
    }
    
    private static Tipo_de_inmueble__c testCrearTipoInmuebleTrastero(){
        
        
        Tipo_de_inmueble__c tipoInmueble = new Tipo_de_inmueble__c();
        tipoInmueble.name = 'Tipo de Inmueble Trastero Test';
        tipoInmueble.Tipo__c = 'Trastero';
        tipoInmueble.Superficie_Construida_m2__c = 5;
        
        insert tipoInmueble;
       
        return tipoInmueble;
    }
    
    //Locales
    private static List<Product2> testCrearListLocales(integer numero){
        
        List<Product2> listLocales = new List<Product2>();
        
        for(integer i = 0; i < numero; i++){
            
            Product2 local = new Product2();
            
            local.name = 'Local Test '+i;
            local.Tipo_de_inmueble__c = testCrearTipoInmuebleLocal().id;
            local.inmueble_asociado__c = inmueble.id;
            listLocales.add(local);
        }
        
        insert listLocales;
       
        return listLocales;
    }
      
    private static Tipo_de_inmueble__c testCrearTipoInmuebleLocal(){
        
        
        Tipo_de_inmueble__c tipoInmueble = new Tipo_de_inmueble__c();
        tipoInmueble.name = 'Tipo de Inmueble Local Test';
        tipoInmueble.Tipo__c = 'Local';
        tipoInmueble.Superficie_Construida_m2__c = 40;
        
        insert tipoInmueble;
       
        return tipoInmueble;
    }
    
	private static PriceBookEntry testCrearPriceBookEntry(){

		PriceBookEntry pbe = [SELECT UnitPrice, Product2Id, IsActive FROM PriceBookEntry WHERE Product2Id =: Inmueble.id];
        pbe.UnitPrice = 100000;
        pbe.IsActive = true;
        
        update pbe;
        
        return pbe;        
    
        
/*
        PriceBookEntry pbe = new PriceBookEntry();
        
        pbe.Pricebook2Id = Test.getStandardPricebookId();

        pbe.UnitPrice = 100000;
        pbe.Product2Id = Inmueble.id;
        pbe.IsActive = true;
        
        insert pbe;
        return pbe;
*/        

        
    }
    

    
    
	/*public static Map<id,OpportunityLineItem> testCrearProductosOportunidad(){
		

        List<OpportunityLineItem> ListProductoOportunidad = new List<OpportunityLineItem>();

        //Obtener inmuebles
        List<Product2> listInmuebles = testCrearInmuebles();
        
        //Obtener PriceBookEntry
        PriceBookEntry pbc =  testCrearPriceBookEntry();
        
        Id OportunidadId = testCrearOportunidad().id;
        
        for(integer k = 0; k <10 ; k++){
            
            OpportunityLineItem productoOportunidad = new OpportunityLineItem();
            
            productoOportunidad.OpportunityId = OportunidadId;
            productoOportunidad.Product2Id = listInmuebles[k].id;
            productoOportunidad.PriceBookEntryId = pbc.id;
            productoOportunidad.Quantity = 25;
            productoOportunidad.UnitPrice = 10;
            
            MapProductoOportunidad.put(k, productoOportunidad);
         }
        
        
         for(iNTEGER i: MapProductoOportunidad.keyset()){
                            
                            system.debug('****************nombre '+MapProductoOportunidad.get(i).name + '----- inmueble '
                                         +MapProductoOportunidad.get(i).Product2Id);
                        } 
        //DEBUGGGG
        
 
        insert MapProductoOportunidad;
        
        Map<id, OpportunityLineItem> MapProductoOportunidadReturn = new Map<id, OpportunityLineItem>([SELECT id,NAME,PRODUCT2ID 
                                                                                                       FROM OpportunityLineItem 
                                                                                                       WHERE OpportunityId =: OportunidadId]);
        //DEBUGGGGG
         for(id i: MapProductoOportunidadReturn.keyset()){
                            
                            system.debug('id '+i+ '------------nombre '+MapProductoOportunidadReturn.get(i).name + '----- inmueble '
                                         +MapProductoOportunidadReturn.get(i).Product2Id);
                        } 
        //DEBUGGGG
        
        
        system.debug('CREAR PRODUCTOS DE OPORTUNIDAD');
        return MapProductoOportunidadReturn;
    }*/    
	private static ContentVersion testCrearImagen(){

        ContentVersion cv = new ContentVersion();
        
        cv.title = 'Imagen prueba';
        cv.PathOnClient = 'URL de prueba';
        cv.Tipo__c = 'Imagen_carrusel';
        cv.posicion__c = 1;
        cv.categoria__c = 'Categoria 1';
        cv.subcategoria__c = 'Subcategoría 1';
        cv.ParentId__c = promocion.id;
        cv.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.IsMajorVersion = true;
        insert cv;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink link = new ContentDocumentLink(
            LinkedEntityId = promocion.Id,
            ContentDocumentId = documents.get(0).Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert link;
        
        return cv;
    }

    @TestVisible
    private static ContentVersion testCrearImagenOpp(){
           
        ContentVersion cv = new ContentVersion();
        
        cv.title = 'Imagen prueba';
        cv.PathOnClient = 'URL de prueba';
        cv.Tipo__c = 'Imagen_carrusel';
        cv.posicion__c = 1;
        cv.categoria__c = 'Categoria 1';
        cv.subcategoria__c = 'Subcategoría 1';
        cv.ParentId__c = oportunidad.id;
        cv.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
           
        insert cv;
        
        return cv;
    }

    private static ContentVersion testCrearImgInmueble(Id inmuebleId){
           
        ContentVersion cv = new ContentVersion();
        
        cv.title = 'Imagen prueba';
        cv.PathOnClient = 'URL de prueba';
        cv.Tipo__c = 'Imagen_carrusel';
        cv.Posicion__c = 1;
        Blob b=Blob.valueOf('prueba');
        cv.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.IsMajorVersion = true;
        insert cv;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id];

        ContentDocumentLink link = new ContentDocumentLink(
            LinkedEntityId = inmuebleId,
            ContentDocumentId = documents.get(0).Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert link;
        
        return cv;
    }
    
    private static ContentVersion testCrearPlano(Id IdTipoInmueble){
           
        ContentVersion cv = new ContentVersion();
        
        cv.title = 'Imagen prueba';
        cv.PathOnClient = 'URL de prueba';
        cv.Tipo__c = 'Plano';
        cv.Tipo_de_inmueble__c = IdTipoInmueble;
        Blob b=Blob.valueOf('prueba');
        cv.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.IsMajorVersion = true;
        insert cv;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id];

        ContentDocumentLink link = new ContentDocumentLink(
            LinkedEntityId = IdTipoInmueble,
            ContentDocumentId = documents.get(0).Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert link;
        
        return cv;
    }

    private static Plan_de_pagos__c testCrearPlanPagos(){
        
  
        Plan_de_pagos__c planPagos = new Plan_de_pagos__c();
        
      	planPagos.Name='Plan Pagos Test';
        planPagos.Oportunidad__c = Oportunidad.id;
        planPagos.Estado__c = 'Activo';
        
        insert planPagos;
       
        return planPagos;
         
        
    }
    
    private static Factura__c testCrearFactura(){
        
  
        Factura__c factura = new Factura__c();
        
      	Factura.name = 'Test Factura';
        Factura.Oportunidad__c = Oportunidad.id;
        
        Account cliente = [SELECT id FROM Account WHERE name = 'Cuenta test1' LIMIT 1];
        
        Factura.Cliente__c = Cliente.id;
        Factura.Sociedad__c = CuentaSociedad.id;
        Factura.Codigo_Impuesto__c = 0.1;
        Factura.Importe__c = 1000;
        Factura.Pago_o_Cuota__c = 'Cuota';
        Factura.Tipo_de_factura__c = 'DEPOSITOS';
        //Factura.Estado_de_la_factura__c = 'Pendiente de emisión';
        Factura.Estado_de_la_factura__c = 'Cobrada';
        Factura.Fecha_de_emision__c = Date.today().addDays(5);
        if(planPagos != null){
        	Factura.Plan_de_pagos__c = planPagos.Id;    
        }
        Factura.Estado_plan_de_pagos__c = 'Activo';
        
        insert factura;

        return factura;
         
        
    }
    private static List<Factura__c> testCrearFacturaCuotaExtra(){
        
        List<Factura__c> facturas= new List<Factura__c>();
        Factura__c factura = new Factura__c();
        
      	factura.name = 'Test Factura1';
        factura.Oportunidad__c = Oportunidad.id;
        
        Account cliente = [SELECT id FROM Account WHERE name = 'Cuenta test1' LIMIT 1];
        
        factura.Cliente__c = Cliente.id;
        factura.Sociedad__c = CuentaSociedad.id;
        factura.Codigo_Impuesto__c = 0.1;
        factura.Importe__c = 1000;
        factura.Pago_o_Cuota__c = 'Cuota Extra';
        factura.Tipo_de_factura__c = 'DEPOSITOS';
        factura.Estado_de_la_factura__c = 'Pendiente de emisión';
        factura.Fecha_de_emision__c = Date.today();
        factura.Estado_plan_de_pagos__c = 'Activo';
        facturas.add(factura);

        Factura__c factura1 = new Factura__c();
        
      	factura1.name = 'Test Factura2';
        factura1.Oportunidad__c = Oportunidad.id;
        
        
        factura1.Cliente__c = Cliente.id;
        factura1.Sociedad__c = CuentaSociedad.id;
        factura1.Codigo_Impuesto__c = 0.1;
        factura1.Importe__c = 1000;
        factura1.Pago_o_Cuota__c = 'Cuota Extra';
        factura1.Tipo_de_factura__c = 'RESERVAS';
        factura1.Estado_de_la_factura__c = 'Pendiente de emisión';
        factura1.Fecha_de_emision__c = Date.today();
        factura1.Estado_plan_de_pagos__c = 'Activo';
        facturas.add(factura1);

         Factura__c factura2 = new Factura__c();
        
      	factura2.name = 'Test Factura21';
        factura2.Oportunidad__c = Oportunidad.id;
        factura2.Cliente__c = Cliente.id;
        factura2.Sociedad__c = CuentaSociedad.id;
        factura2.Codigo_Impuesto__c = 0.1;
        factura2.Importe__c = 1000;
        factura2.Pago_o_Cuota__c = 'Cuota Extra';
        factura2.Tipo_de_factura__c = 'FACTURA DE VENTA';
        factura2.Estado_de_la_factura__c = 'Pendiente de emisión';
        factura2.Fecha_de_emision__c = Date.today();
        factura2.Estado_plan_de_pagos__c = 'Activo';
        facturas.add(factura2);

        Factura__c factura3 = new Factura__c();
        
      	factura3.name = 'Test Factura21';
        factura3.Oportunidad__c = Oportunidad.id;
        factura3.Cliente__c = Cliente.id;
        factura3.Sociedad__c = CuentaSociedad.id;
        factura3.Codigo_Impuesto__c = 0.1;
        factura3.Importe__c = 1000;
        factura3.Pago_o_Cuota__c = 'Cuota Extra';
        factura3.Tipo_de_factura__c = 'ENTREGAS A CUENTA';
        factura3.Estado_de_la_factura__c = 'Pendiente de emisión';
        factura3.Fecha_de_emision__c = Date.today();
        factura3.Estado_plan_de_pagos__c = 'Activo';
        facturas.add(factura3);

        Factura__c factura4 = new Factura__c();
        
      	factura4.name = 'Test Factura21';
        factura4.Oportunidad__c = Oportunidad.id;
        factura4.Cliente__c = Cliente.id;
        factura4.Sociedad__c = CuentaSociedad.id;
        factura4.Codigo_Impuesto__c = 0.1;
        factura4.Importe__c = 1000;
        factura4.Pago_o_Cuota__c = 'Cuota Extra';
        factura4.Tipo_de_factura__c = 'FACTURA RECTIFICATIVA';
        factura4.Estado_de_la_factura__c = 'Pendiente de emisión';
        factura4.Fecha_de_emision__c = Date.today();
        factura4.Estado_plan_de_pagos__c = 'Activo';
        facturas.add(factura4);
       

        insert facturas;
        
        return facturas;
       

         
        
    }
    private static void testCrearFacturaProformas(){
        
        List<Factura__c> facturas= new List<Factura__c>();
        Factura__c factura = new Factura__c();
        
      	factura.name = 'Test Factura1';
        factura.Oportunidad__c = Oportunidad.id;
        
        Account cliente = [SELECT id FROM Account WHERE name = 'Cuenta test1' LIMIT 1];
        
        factura.Cliente__c = Cliente.id;
        factura.SecuencialFactura__c=1;
        factura.Sociedad__c = CuentaSociedad.id;
        factura.Codigo_Impuesto__c = 0.1;
        factura.Importe__c = 1000;
        factura.Pago_o_Cuota__c = 'Proforma';
        factura.Tipo_de_factura__c = 'DEPOSITOS';
        factura.Estado_de_la_factura__c = 'Conciliada SF';
        factura.Fecha_de_emision__c = Date.today();
        facturas.add(factura);

        Factura__c factura1 = new Factura__c();
        
      	factura1.name = 'Test Factura2';
        factura1.Oportunidad__c = Oportunidad.id;
        
        
        factura1.Cliente__c = Cliente.id;
        factura1.Sociedad__c = CuentaSociedad.id;
        factura1.SecuencialFactura__c=1;
        factura1.Codigo_Impuesto__c = 0.1;
        factura1.Importe__c = 1000;
        factura1.Pago_o_Cuota__c = 'Proforma';
        factura1.Tipo_de_factura__c = 'RESERVAS';
        factura1.Estado_de_la_factura__c = 'Conciliada SF';
        factura1.Fecha_de_emision__c = Date.today();
        facturas.add(factura1);

         Factura__c factura2 = new Factura__c();
        
      	factura2.name = 'Test Factura21';
        factura2.Oportunidad__c = Oportunidad.id;
        factura2.SecuencialFactura__c=1;
        factura2.Cliente__c = Cliente.id;
        factura2.Sociedad__c = CuentaSociedad.id;
        factura2.Codigo_Impuesto__c = 0.1;
        factura2.Importe__c = 1000;
        factura2.Pago_o_Cuota__c = 'Proforma';
        factura2.Tipo_de_factura__c = 'FACTURA DE VENTA';
        factura2.Estado_de_la_factura__c = 'Conciliada SF';
        factura2.Fecha_de_emision__c = Date.today();
        facturas.add(factura2);

        Factura__c factura3 = new Factura__c();
        
      	factura3.name = 'Test Factura21';
        factura3.Oportunidad__c = Oportunidad.id;
        factura3.SecuencialFactura__c=1;
        factura3.Cliente__c = Cliente.id;
        factura3.Sociedad__c = CuentaSociedad.id;
        factura3.Codigo_Impuesto__c = 0.1;
        factura3.Importe__c = 1000;
        factura3.Pago_o_Cuota__c = 'Proforma';
        factura3.Tipo_de_factura__c = 'ENTREGAS A CUENTA';
        factura3.Estado_de_la_factura__c = 'Conciliada SF';
        factura3.Fecha_de_emision__c = Date.today();
        facturas.add(factura3);

        Factura__c factura4 = new Factura__c();
        
      	factura4.name = 'Test Factura21';
        factura4.Oportunidad__c = Oportunidad.id;
        factura4.SecuencialFactura__c=1;
        factura4.Cliente__c = Cliente.id;
        factura4.Sociedad__c = CuentaSociedad.id;
        factura4.Codigo_Impuesto__c = 0.1;
        factura4.Importe__c = 1000;
        factura4.Pago_o_Cuota__c = 'Proforma';
        factura4.Tipo_de_factura__c = 'FACTURA RECTIFICATIVA';
        factura4.Estado_de_la_factura__c = 'Conciliada SF';
        factura4.Fecha_de_emision__c = Date.today();
        facturas.add(factura4);
        
        //Generar numero factura test
        Factura__c factura5 = new Factura__c();
        
      	factura5.name = 'Test Factura212';
        factura5.Oportunidad__c = Oportunidad.id;
        factura5.SecuencialFactura__c=0;
        factura5.Cliente__c = Cliente.id;
        factura5.Sociedad__c = CuentaSociedad.id;
        factura5.Codigo_Impuesto__c = 0.1;
        factura5.Importe__c = 1000;
        factura5.Pago_o_Cuota__c = 'Proforma';
        factura5.Tipo_de_factura__c = 'FACTURA RECTIFICATIVA';
        factura5.Estado_de_la_factura__c = 'Conciliada SF';
        factura5.Fecha_de_emision__c = Date.today();
        factura5.Enviar_Factura_Oracle__c = true;
        factura5.Numero_de_factura__c = null;
        facturas.add(factura5);

        Factura__c factura6 = new Factura__c();
        
      	factura6.name = 'Test Factura213';
        factura6.Oportunidad__c = Oportunidad.id;
        factura6.Cliente__c = Cliente.id;
        factura6.Sociedad__c = CuentaSociedad.id;
        factura6.Codigo_Impuesto__c = 0.1;
        factura6.Importe__c = 1000;
        factura6.Pago_o_Cuota__c = 'Proforma';
        factura6.Tipo_de_factura__c = 'FACTURA RECTIFICATIVA';
        factura6.Estado_de_la_factura__c = 'Conciliada SF';
        factura6.Enviar_Factura_Oracle__c = true;
        factura6.Numero_de_factura__c = null;
        facturas.add(factura6);


        insert facturas;   
         
        
    }
    private static void testCrearFacturaAbono(){
        List<Factura__c> facturas= new List<Factura__c>();
        Factura__c factura = new Factura__c();
        
      	factura.name = 'Test Factura1';
        factura.Oportunidad__c = Oportunidad.id;
        
        Account cliente = [SELECT id FROM Account WHERE name = 'Cuenta test1' LIMIT 1];
        
      	factura.name = 'Test Factura31';
        factura.Oportunidad__c = Oportunidad.id;
        factura.Cliente__c = Cliente.id;
        factura.Sociedad__c = CuentaSociedad.id;
        factura.Codigo_Impuesto__c = 0.1;
        factura.Importe__c = 1000;
        factura.Pago_o_Cuota__c = 'Abono';
        factura.Tipo_de_factura__c = 'FACTURA RECTIFICATIVA';
        factura.Estado_de_la_factura__c = 'Conciliada SF';
        factura.Fecha_de_emision__c = Date.today();
        factura.Enviar_Factura_Oracle__c = true;
        factura.Numero_de_factura__c = null;
        facturas.add(factura);

        insert facturas; 
    }
    
    private static Linea_de_factura__c testCrearLineaFactura(){
        
  
        Linea_de_factura__c lineaFactura = new Linea_de_factura__c();
        
        lineaFactura.Name = 'LineaTest';
        lineaFactura.Numero_de_linea__c = 1;
        lineaFactura.Tipo_de_linea__c = '';
        lineaFactura.Importe__c = 1000;
        lineaFactura.DescripcionLinea__c = 'DescripcionLinea__c';
  		lineaFactura.Factura__c = factura.Id;
        
        insert lineaFactura;
        
        return lineaFactura;
         
        
    }

}