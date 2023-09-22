public with sharing class PublicacionPortalIdealista {

    private static String prettyJSON;

    public static String getJSONRequest() {
        return prettyJSON;
    } 

    @TestVisible
    private static List<Promocion__c> getPromotions() {
        List<Promocion__c> promotions = [SELECT Id, Nombre_Comercial_Avintia_Inmobiliaria__c, Descripcion__c, Piscina_Exterior__c, Nombre_Via__c, N_Via__c, Codigo_postal__c, 
                                            Pais__r.Name, Localidad__r.Name, Cuenta_Activa_1__c, Cuenta_Activa_2__c, Numero_de_cuenta_bancaria_1__c,
                                            Numero_de_cuenta_bancaria_2__c, Entidad_Bancaria1__c, Entidad_Bancaria2__c, Tipo_via__c, Coordenadas__c, Descricion_pequena__c
                                        FROM Promocion__c WHERE Idealista__c = true];
        return promotions;
    }

    @TestVisible
    private static Map<Id, List<Product2>> getPromotionsInmuebles(Set<Id> promosIds) {
        List<Product2> inmuebles = [SELECT Id, Name, Tipologia_de_vivienda__c, Estado__c, Promocion__c, Idealista__c, Fotocasa__c, WebAvinita__c, Tipo_de_via__c,Nombre_Via__c, N_Via__c, Piso__c, Escalera__c, 
                                    Letra_N_Puerta__c, Codigo_postal__c, Pais__c, Superficie_Construida_m2__c, Superficie_Util_m2__c, N_banos__c, N_habitaciones__c, 
                                    Certificado_de_eficiencia_energetica__c, Superficie_Jardines__c, Orientacion_Viv__c , Superficie_Util_Trastero_con_pasillos_m2__c, 
                                    Precio__c, Tipo_de_inmueble__c, Tipo_de_inmueble__r.Tipo__c, Superficie_Terrazas_Cubiertas__c, Superficie_Terrazas_descubiertas__c, 
                                    Superficie_Construida_total_con_ZZCC_m2__c, Superficie_Util_Garaje_con_calles_m2__c, Description, Precio_con_anejos_incluidos__c, Bloque__c 
                                    FROM Product2 WHERE Promocion__c IN :promosIds AND Inmueble_asociado__c = null AND 
                                    Idealista__c = true AND Fotocasa__c = true AND WebAvinita__c = true];

        Map<Id, List<Product2>> promosInmueblesMap = new Map<Id, List<Product2>>();
        for(Product2 inmueble : inmuebles) {
            List<Product2> inms = promosInmueblesMap.get(inmueble.Promocion__c);
            if(inms == null) inms = new List<Product2>();
            inms.add(inmueble);
            promosInmueblesMap.put(inmueble.Promocion__c, inms);
        }

        return promosInmueblesMap;
    }

    @TestVisible
    private static Map<Id, List<Product2>> getProductAnnexesByPromo(Set<Id> promosIds) {
        Map<Id, List<Product2>> productsAnnexesMap = new Map<Id, List<Product2>>();
        List<Product2> annexes = [SELECT Id, Precio__c, Inmueble_asociado__c, Precio_con_anejos_incluidos__c 
                                    FROM Product2 
                                    WHERE Promocion__c IN :promosIds AND Inmueble_asociado__c != null AND 
                                    Inmueble_asociado__r.Idealista__c = true];
        for(Product2 annexe : annexes) {
            List<Product2> currAnnexesList = productsAnnexesMap.get(annexe.Inmueble_asociado__c);
            if(currAnnexesList == null) currAnnexesList = new List<Product2>();
            currAnnexesList.add(annexe);
            productsAnnexesMap.put(annexe.Inmueble_asociado__c, currAnnexesList);
        }

        return productsAnnexesMap;
    }

    @TestVisible
    private static Decimal getTotalPriceWithAnnexesIncluded(Product2 p, List<Product2> annexes) {
        Decimal totalPrice = p.Precio__c > 0.0 ? p.Precio__c : 0.0; 
        if(annexes != null) {
            for(Product2 annexe : annexes) {
                totalPrice += annexe.Precio__c > 0.0 ? annexe.Precio__c : 0.0;
            }
        }
        return totalPrice;
    }

    @TestVisible
    private static Map<Id, List<ContentVersion>> getPromotionsImgs(Set<Id> promosIds) {
        Map<Id, Id> promosMap = new Map<Id, Id>();
        Map<Id, List<ContentVersion>> promosDocsMap = new Map<Id, List<ContentVersion>>();
        Set<Id> contentDocumentsIds = new Set<Id>();
       
        List<ContentDocumentLink> promosDocuments = [SELECT Id,ContentDocumentId, LinkedEntityId 
                                                     FROM ContentDocumentLink 
                                                     WHERE LinkedEntityId IN :promosIds];
        for(ContentDocumentLink doc : promosDocuments) {
            contentDocumentsIds.add(doc.ContentDocumentId);
            promosMap.put(doc.ContentDocumentId, doc.LinkedEntityId);
            system.debug('GETPROMOTIONIMG : ' +  doc.LinkedEntityId + ' | ' + doc.ContentDocumentId);
        }
        system.debug('QUERY : ' + [SELECT Id, FileType, Title, Promocion__c, Posicion__c, ContentDocumentId, URL__c
                                         FROM ContentVersion
                                         WHERE
                                         IsLatest = true AND ContentDocumentId  IN :contentDocumentsIds]);
        


        List<ContentVersion> contents = [SELECT Id, FileType, Title, Promocion__c, Posicion__c, ContentDocumentId, URL__c
                                         FROM ContentVersion
                                         WHERE (Tipo__c = 'Imagen_carrusel' OR Tipo__c = 'Memoria_calidades') AND
                                         IsLatest = true AND ContentDocumentId  IN :contentDocumentsIds and FileType in ('JPG','PNG','JPEG')];
        system.debug('GETPROMOTIONIMG 2: ' + contents.size());
        for(ContentVersion doc : contents) {
            List<ContentVersion> docsList = promosDocsMap.get(promosMap.get(doc.ContentDocumentId));
            if(docsList == null) docsList = new List<ContentVersion>();

            docsList.add(doc);
            promosDocsMap.put(promosMap.get(doc.ContentDocumentId), docsList);
        }

        return promosDocsMap;
    }

    @TestVisible
    private static Map<Id, List<ContentDocumentLink>> getInmueblesImgs(Set<Id> tiposInmueblesIds, Map<Id, Product2> inmueblesMap) {
        // Planos de los tipos de inmuebles
        List<ContentDocumentLink> typesDocsLinks =  tiposInmueblesIds.isEmpty()? new List<ContentDocumentLink>():
                                                    [SELECT Id, LinkedEntityId, 
                                                    ContentDocument.LatestPublishedVersion.FileType, 
                                                    ContentDocument.LatestPublishedVersion.Title, 
                                                    ContentDocument.LatestPublishedVersion.Promocion__c, 
                                                    ContentDocument.LatestPublishedVersion.Posicion__c, 
                                                    ContentDocument.LatestPublishedVersion.URL__c 
                                                    FROM ContentDocumentLink 
                                                    WHERE LinkedEntityId IN :tiposInmueblesIds AND ContentDocument.LatestPublishedVersion.Tipo__c = 'Plano'];
        Map<Id, ContentDocumentLink> productTypesDocsLinksMap = new Map<Id, ContentDocumentLink>();
        for(ContentDocumentLink link : typesDocsLinks) {
            productTypesDocsLinksMap.put(link.LinkedEntityId, link);
        }

        // Imagenes y planos de los inmuebles
        Map<Id, List<ContentDocumentLink>> inmueblesDocsMap = new Map<Id, List<ContentDocumentLink>>();
        List<ContentDocumentLink> productsContentsLinks = inmueblesMap.isEmpty() ? new List<ContentDocumentLink>() :
                                                          [SELECT Id, ContentDocumentId, LinkedEntityId, 
                                                           ContentDocument.LatestPublishedVersion.FileType, 
                                                           ContentDocument.LatestPublishedVersion.Title, 
                                                           ContentDocument.LatestPublishedVersion.Tipo__c, 
                                                           ContentDocument.LatestPublishedVersion.Promocion__c, 
                                                           ContentDocument.LatestPublishedVersion.Posicion__c, 
                                                           ContentDocument.LatestPublishedVersion.URL__c 
                                                           FROM ContentDocumentLink 
                                                           WHERE LinkedEntityId IN :inmueblesMap.keySet() AND 
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
                ContentDocumentLink doc = productTypesDocsLinksMap.get(inmueblesMap.get(productId).Tipo_de_inmueble__c);
                docsList.add(doc);
                inmueblesDocsMap.put(productId, docsList);
            }
        }

        return inmueblesDocsMap;
    }

    @TestVisible
    public static String generarJson() {
        PropiedadesIntegracion__c propiedadesIntegracion = PropiedadesIntegracion__c.getInstance();        
        List<Promocion__c> promotions = getPromotions();
        prettyJSON = '';
        if(!promotions.isEmpty()) {
            Set<Id> promosIds = new Set<Id>();
            for(Promocion__c promo : promotions) promosIds.add(promo.Id);
            Map<Id, List<Product2>> promosInmueblesMap = getPromotionsInmuebles(promosIds);
            Map<Id, List<ContentVersion>> imgs = getPromotionsImgs(promosIds);
            Map<Id, List<Product2>> productsAnnexesMap = getProductAnnexesByPromo(promosIds);

            Map<Id, Product2> inmueblesMap = new Map<Id, Product2>();
            //Set<Id> inmueblesIds = new Set<Id>();
            Set<Id> tiposInmueblesIds = new Set<Id>();
            for(Id promoId : promosInmueblesMap.keySet()) {
                List<Product2> inmuebles = promosInmueblesMap.get(promoId);
                for(Product2 p : inmuebles) {
                    inmueblesMap.put(p.Id, p);
                    //inmueblesIds.add(p.Id);
                    tiposInmueblesIds.add(p.Tipo_de_inmueble__c);
                }
            }
            Map<Id, List<ContentDocumentLink>> inmueblesImgs = getInmueblesImgs(tiposInmueblesIds, inmueblesMap);
            String fecha = DateTime.now().format('yyyy/MM/dd hh:mm:ss');

            // Comprobamos errores de datos
            checkDataErrors(promotions, promosInmueblesMap);
               
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
                gen.writeStringField('customerCountry', 'Spain');//Obligatorio
                gen.writeStringField('customerCode', !Test.isRunningTest() ? propiedadesIntegracion.CustomerCodeIdealista__c : 'ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7');//Obligatorio*
                gen.writeStringField('customerReference', '260360319');//Obligatorio*
                gen.writeStringField('customerSendDate', fecha); 
                gen.writeStringField('CustomerName', 'Soldit Homes');

                //Datos de contacto del Vendedor  
                gen.writeFieldName('customerContact');
                gen.writeStartObject();
                    gen.writeStringField('contactName', 'Avintia Inmobiliaria');
                    gen.writeStringField('contactEmail', 'xxx' );
                    gen.writeNumberField('contactPrimaryPhonePrefix', 34);
                    gen.writeNumberField('contactPrimaryPhoneNumber',  680167485);
                    gen.writeNumberField('contactSecondaryPhonePrefix',  34);
                    gen.writeNumberField('contactSecondaryPhoneNumber', 0);
                gen.writeEndObject();

                // Propiedades especificas
                gen.writeFieldName('customerNewDevelopments');
                gen.writeStartArray();

                for(Promocion__c promotion : promotions) {
                    gen.writeStartObject();
                        gen.writeStringField('propertyCode', promotion.Id);//Obligatorio
                        gen.writeStringField('propertyReference', promotion.Id);
                        gen.writeStringField('propertyVisibility', 'idealista'); //Valores: idealista, microsite, private //En el momento de pasar a producción esta propiedad debe pasar a publica
                        //Dirección de la promoción
                        gen.writeFieldName('propertyAddress');
                        gen.writeStartObject();
                            gen.writeStringField('addressVisibility', 'full'); //"full","street","hidden" // full address, street name or zone will be shown publicly
                            if(promotion.Nombre_Via__c != null) gen.writeStringField('addressStreetName', promotion.Tipo_via__c + ' ' + promotion.Nombre_Via__c); //Obligatorio
                            if(promotion.N_Via__c != null) gen.writeStringField('addressStreetNumber', String.valueOf(promotion.N_Via__c));

                            // estos datos son propios de cada vivienda de la promocion
                            //no aplica      gen.writeStringField('addressBlock', 'xxx');
                            //no aplica     gen.writeNumberField('addressFloor', mapPromocion.get(promo).Piso__c);
                            //no aplica     gen.writeStringField('addressStair', mapPromocion.get(promo).Escalera__c);
                            //no aplica     gen.writeStringField('addressDoor', mapPromocion.get(promo).Letra_N_Puerta__c);
                            //gen.writeStringField('addressUrbanization', 'xxx');

                            if(promotion.Codigo_postal__c != null) gen.writeStringField('addressPostalCode', promotion.Codigo_postal__c);
                            /* SOLO DE ITALIA
                            gen.writeNumberField('addressNsiCode', 0);
                            */
                            if(promotion.Localidad__r.Name != null ) gen.writeStringField('addressTown', promotion.Localidad__r.Name);
                            if(promotion.Pais__r.Name == 'España'){
                                gen.writeStringField('addressCountry', 'Spain'); //Obligatorio
                            }
                            else if(promotion.Pais__r.Name == 'Andorra'){
                                gen.writeStringField('addressCountry', 'Andorra'); //Obligatorio
                            }
                            else if(promotion.Pais__r.Name == 'Francia'){
                                gen.writeStringField('addressCountry', 'France'); //Obligatorio
                            }
                            if(promotion.Coordenadas__c != null){
                                gen.writeStringField('addressCoordinatesPrecision', 'exact'); //"enum": ["exact","moved"]
                            }
                            if(promotion.Coordenadas__c != null){
                                gen.writeNumberField('addressCoordinatesLatitude', promotion.Coordenadas__c.getLatitude()); //Obligatorio* (Si no se pone addressCountry y addressPostalCode)
                            }
                            if(promotion.Coordenadas__c != null){
                                gen.writeNumberField('addressCoordinatesLongitude', promotion.Coordenadas__c.getLongitude());//Obligatorio* (Si no se pone addressCountry y addressPostalCode)
                            }
                            /* SOLO DE ITALIA
                            "addressCasaZoneId"
                            */
                        gen.writeEndObject();

                        //Datos del contacto        
                        /*gen.writeFieldName('propertyContact');
                        gen.writeStartObject();
                            gen.writeStringField('contactName', 'xxx');
                            gen.writeStringField('contactEmail', 'xxx');
                            gen.writeNumberField('contactPrimaryPhonePrefix', 34);
                            gen.writeNumberField('contactPrimaryPhoneNumber', 0);
                            gen.writeNumberField('contactSecondaryPhonePrefix', 34);
                            gen.writeNumberField('contactSecondaryPhoneNumber', 0);
                        gen.writeEndObject(); */

                        //Caracteristicas de la Promocion -- featuresType = promo      
                        gen.writeFieldName('propertyFeatures');
                        gen.writeStartObject();
                            gen.writeStringField('featuresType', 'promo');
                            gen.writeStringField('featuresNewDevelopmentType', 'new_building'); //Obligatorio //"restored_building","new_building","house","mixed_promos"
                            gen.writeStringField('featuresNewDevelopmentName', promotion.Nombre_Comercial_Avintia_Inmobiliaria__c); //Obligatorio
                            //Falta         gen.writeStringField('featuresFinished', 'boolean'); //Si se ha acabado la obra??
                            //Falta         gen.writeDateField('featuresStartDate', 'fecha'); //Fecha de inicio? de la obra?
                            //Falta         gen.writeNumberField('featuresKeyDeliveryYear','año' );
                            //Falta         gen.writeNumberField('featuresKeyDeliveryMonth', 'Mes numero');
                            //Falta         gen.writeStringField('featuresBuiltPhase', 'pilot'); //"land_move","foundation","carpentry","pilot", "paving", "equipment","keydelivery"
                            //Falta         gen.writeBooleanField('featuresAvailabilityHour', ''); //Enum - "any_morning","mornings","at_noon","afternoons", "nights", "weekends","business_hour"

                            //Meter bucle for por cada idioma Comentario del anunciante?? en diferentes idiomas -- "spanish","italian","portuguese","english","german","french","russian","chinese","catalan"
                            //gen.writeFieldName('featuresAccessComments');
                            //gen.writeStartArray();
                                //gen.writeStartObject();
                                    //gen.writeStringField('descriptionLanguage', 'spanish');
                                    //gen.writeStringField('descriptionText', promotion.Descricion_pequena__c);
                                //gen.writeEndObject();
                            //gen.writeEndArray();
                        
                            //Falta          gen.writeBooleanField('featuresOnSite', 'true');
                            //Falta          gen.writeBooleanField('featuresMortgageStateSubsidized', 'true');
                            if(promotion.Cuenta_Activa_1__c) gen.writeStringField('featuresMortgageBankName', promotion.Entidad_Bancaria1__c);
                            else if(promotion.Cuenta_Activa_2__c) gen.writeStringField('featuresMortgageBankName', promotion.Entidad_Bancaria2__c);                        
                            //Falta			 gen.writeNumberField('featuresMortgageEntryPercentage', '');
                            //Falta			 gen.writeNumberField('featuresMortgageLettersPercentage', 30.8);
                            //Falta			 gen.writeNumberField('featuresMortgagePercentage', 15.5);
                            //Falta			 gen.writeNumberField('featuresMortgageInterestRate', 8);
                            //Falta			 gen.writeNumberField('featuresMortgageYears', 25);
                        gen.writeEndObject();

                        // Descripcion de la promo en diferentes idiomas -- "spanish","italian","portuguese","english","german","french","russian","chinese","catalan"			
                        gen.writeFieldName('propertyDescriptions');
                        gen.writeStartArray();
                            gen.writeStartObject();
                                gen.writeStringField('descriptionLanguage', 'spanish');
                                if(promotion.Descripcion__c != null){
                                    gen.writeStringField('descriptionText', promotion.Descripcion__c.abbreviate(4000)); //Máximo 4000 caracteres
                                }
                            gen.writeEndObject();
                        gen.writeEndArray();

                        // Imágenes
                        gen.writeFieldName('propertyImages');
                        gen.writeStartArray(); 
                        if(imgs.containsKey(promotion.Id)) {
                            Integer i = 1;
                            for(ContentVersion img : imgs.get(promotion.Id)) {
                                gen.writeStartObject();
                                    gen.writeNumberField('imageOrder', img.Posicion__c != null ? img.Posicion__c : i);
                                    //Falta    gen.writeStringField('imageLabel', ''); //"bathroom","bedroom","communalareas","corridor","details","energycertificate","facade","garage","garden","gateway","hall","kitchen","land","living","mates","plan","pool","reception","room","storage","terrace","unknown","views","waitingroom"
                                    gen.writeStringField('imageUrl', PublicacionPortales.getPublicLinkCV(img)); //Obligatorio //Que url meter?
                                gen.writeEndObject();
                                i++;
                            }
                        }
                        gen.writeEndArray();

                        //Propiedades dentro de la promoción
                        gen.writeFieldName('newDevelopmentTypologies');
                        gen.writeStartArray();
                            List<Product2> inmuebles = promosInmueblesMap.get(promotion.Id);
                            if(inmuebles != null) {
                                for(Product2 inmueble : inmuebles) {
                                    if(inmueble.Estado__c != 'Libre') throw new PublicacionPortalIdealistaException('El inmueble ' + inmueble.Name + ' no está libre. No se puede realizar la publicación en Idealista.');
                                    Boolean isGarage = inmueble.Tipo_de_inmueble__r.Tipo__c == 'Garaje';
                                    Boolean isStorage = inmueble.Tipo_de_inmueble__r.Tipo__c == 'Trastero';
                                    if(!isGarage && !isStorage) { // Sólo se van a publicar viviendas
                                        List<Product2> currProductAnnexes = productsAnnexesMap.get(inmueble.Id);
                                        if(inmueble.Precio_con_anejos_incluidos__c == false)  currProductAnnexes = new List<Product2>();
                                        Decimal totalPrice = getTotalPriceWithAnnexesIncluded(inmueble, currProductAnnexes);

                                        gen.writeStartObject();
                                            gen.writeStringField('propertyCode', inmueble.Id);
                                            gen.writeStringField('propertyReference', inmueble.Id); 
                                            gen.writeFieldName('propertyOperation'); 
                                            gen.writeStartObject();
                                                gen.writeStringField('operationType', 'sale'); //Obligatorio //Siempre será 'sale'
                                                gen.writeNumberField('operationPrice', Integer.valueOf(totalPrice)); //Obligatorio 
                                                //Falta                                 gen.writeNumberField('operationPriceCommunity', 0); 
                                            gen.writeEndObject();

                                            gen.writeFieldName('propertyAddress'); 
                                            gen.writeStartObject();
                                                gen.writeStringField('addressVisibility', 'hidden'); //"full","street","hidden" // full address, street name or zone will be shown publicly
                                                if(inmueble.Nombre_Via__c != null) gen.writeStringField('addressStreetName', inmueble.Tipo_de_via__c + ' ' +inmueble.Nombre_Via__c);
                                                if(inmueble.N_Via__c != null) gen.writeStringField('addressStreetNumber', String.valueOf(inmueble.N_Via__c));
                                                if(inmueble.Bloque__c != null) gen.writeStringField('addressBlock', String.valueOf(inmueble.Bloque__c));
                                                String addressFloor = inmueble.Piso__c == 0 ? 'bj' : String.valueOf(inmueble.Piso__c);
                                                if(inmueble.Piso__c != null) gen.writeStringField('addressFloor', addressFloor);
                                                if(inmueble.Escalera__c != null) gen.writeStringField('addressStair', inmueble.Escalera__c);
                                                if(inmueble.Letra_N_Puerta__c != null) gen.writeStringField('addressDoor', inmueble.Letra_N_Puerta__c);
                                                //falta      gen.writeStringField('addressUrbanization', 'xxx');
                                                if(inmueble.Codigo_postal__c != null) gen.writeStringField('addressPostalCode', inmueble.Codigo_postal__c);//Obligatorio
                                                //falta      ITALIA SOLO gen.writeNumberField('addressNsiCode', 0);
                                                if(promotion.Localidad__r.Name != null) gen.writeStringField('addressTown', promotion.Localidad__r.Name);
                                                if(inmueble.Pais__c == 'España'){
                                                    gen.writeStringField('addressCountry', 'Spain'); //Obligatorio
                                                } else if(inmueble.Pais__c == 'Italia'){
                                                    gen.writeStringField('addressCountry', 'Italy'); //Obligatorio
                                                } else if(inmueble.Pais__c == 'Francia'){
                                                    gen.writeStringField('addressCountry', 'France'); //Obligatorio
                                                }
                                                
                                                // Coordenadas
                                                gen.writeStringField('addressCoordinatesPrecision', promotion.Coordenadas__c != null ? 'exact' : 'moved'); //"enum": ["exact","moved"]
                                                if(promotion.Coordenadas__c != null){
                                                    gen.writeNumberField('addressCoordinatesLatitude', promotion.Coordenadas__c.getLatitude()); //Obligatorio* (Si no se pone addressCountry y addressPostalCode)
                                                }
                                                if(promotion.Coordenadas__c != null){
                                                    gen.writeNumberField('addressCoordinatesLongitude', promotion.Coordenadas__c.getLongitude());//Obligatorio* (Si no se pone addressCountry y addressPostalCode)
                                                }
                                            gen.writeEndObject();

                                            //Caracteristicas del inmueble                       
                                            gen.writeFieldName('propertyFeatures'); 
                                            gen.writeStartObject();
                                                if(inmueble.Tipo_de_inmueble__r.Tipo__c == 'Vivienda') {
                                                    String houseType;
                                                    if(inmueble.Tipologia_de_vivienda__c == 'Chalet') houseType = 'house';
                                                    else houseType = 'flat';
                                                    gen.writeStringField('featuresType', houseType); 
                                                    gen.writeNumberField('featuresAreaConstructed', Integer.valueOf(inmueble.Superficie_Construida_total_con_ZZCC_m2__c));
                                                    
                                                    //En este caso se indican los campos de HOMES.JSON al haber seleccionado un piso
                                                    //gen.writeNumberField('featuresAreaPlot', Integer.valueOf(mapInmueblesIdealista.get(inm).Superficie_Construida_total_con_ZZCC_m2__c);
                                                    gen.writeNumberField('featuresAreaUsable', Integer.valueOf(inmueble.Superficie_Util_m2__c));
                                                    Boolean hasBalcony = false;
                                                    if(inmueble.Superficie_Terrazas_Cubiertas__c > 0 || inmueble.Superficie_Terrazas_Descubiertas__c > 0)
                                                        hasBalcony = true;
                                                    else
                                                        hasBalcony = false;

                                                    gen.writeBooleanField('featuresBalcony', hasBalcony);

                                                    if(inmueble.N_banos__c != null){
                                                        gen.writeNumberField('featuresBathroomNumber', inmueble.N_banos__c); //Obligatorio
                                                    }
                                                    
                                                    if(inmueble.N_habitaciones__c != null){
                                                        gen.writeNumberField('featuresBedroomNumber', inmueble.N_habitaciones__c);
                                                    }
                                                    
                                                    //Falta ->  gen.writeNumberField('featuresBuiltYear', Promocion.BuiltYear);
                                                    //Falta ->  gen.writeBooleanField('featuresConditionedAir', true/false);
                                                    gen.writeStringField('featuresConservation', 'new'); // new, good o toRestore
                                                    //Falta ->  gen.writeBooleanField('featuresChimney', true/false);
                                                    //Falta ->  gen.writeBooleanField('featuresDoorman', true/false);
                                                    //Falta ->  gen.writeBooleanField('featuresDuplex', true/false);
                                                    //Falta ->  gen.writeBooleanField('featuresEquippedKitchen', true/false);
                                                    //Falta ->  gen.writeBooleanField('featuresEquippedWithFurniture', true/false);
                                                    //Falta ->  gen.writeStringField('featuresEnergyCertificatePerformance', 0);
                                                    //Falta ->  gen.writeStringField('featuresEnergyCertificateLaw', '');    "enum": [ "dl-192_2005","legge-90_2013"]
                                                    if(inmueble.Certificado_de_eficiencia_energetica__c != null){
                                                        gen.writeStringField('featuresEnergyCertificateRating', inmueble.Certificado_de_eficiencia_energetica__c);
                                                    }
                                                    //Falta ->  gen.writeStringField('featuresEnergyCertificateType', '');    "enum": ["project","completed"]
                                                    //Falta ->	gen.writeNumberField('featuresFloorsBuilding', 0);
                                                    //Falta ->  gen.writeNumberField('featuresFloorsInTop', '');

                                                    //Jardin
                                                    gen.writeBooleanField('featuresGarden', inmueble.Superficie_Jardines__c > 0);
                                                    
                                                    //Falta ->  gen.writeBooleanField('featuresHandicapAdaptedAccess', true/false);
                                                    //Falta ->  gen.writeBooleanField('featuresHandicapAdaptedUse', true/false);
                                                    //Falta ->  gen.writeBooleanField('featuresLiftAvailable', true/false);

                                                    //Orientación
                                                    switch on inmueble.Orientacion_Viv__c {
                                                        when 'Norte' {
                                                            gen.writeBooleanField('featuresOrientationNorth', true);
                                                        }
                                                        when 'Sur' {
                                                            gen.writeBooleanField('featuresOrientationSouth', true);
                                                        }
                                                        when 'Este' {
                                                            gen.writeBooleanField('featuresOrientationEast', true);
                                                        }
                                                        when 'Oeste' {
                                                            gen.writeBooleanField('featuresOrientationWest', true);
                                                        }
                                                        when 'Noreste' {
                                                            gen.writeBooleanField('featuresOrientationNorth', true);
                                                            gen.writeBooleanField('featuresOrientationEast', true);
                                                        }
                                                        when 'Noroeste' {
                                                            gen.writeBooleanField('featuresOrientationNorth', true);
                                                            gen.writeBooleanField('featuresOrientationWest', true);
                                                        }
                                                        when 'Sureste' {
                                                            gen.writeBooleanField('featuresOrientationSouth', true);
                                                            gen.writeBooleanField('featuresOrientationEast', true);
                                                        }
                                                        when 'Suroeste' {
                                                            gen.writeBooleanField('featuresOrientationSouth', true);
                                                            gen.writeBooleanField('featuresOrientationWest', true);
                                                        }
                                                    }
           
                                                    //Falta ->  gen.writeBooleanField('featuresParkingAvailable', );
                                                    //Falta ->  gen.writeBooleanField('featuresPenthouse', );
                                                    //Falta ->  gen.writeBooleanField('featuresPetsAllowed', '');
                                                    gen.writeBooleanField('featuresPool', promotion.Piscina_Exterior__c);
                                                    gen.writeNumberField('featuresRooms', inmueble.N_habitaciones__c);

                                                    //Trastero
                                                    gen.writeBooleanField('featuresStorage', inmueble.Superficie_Util_Trastero_con_pasillos_m2__c > 0);                                    
                                                    gen.writeBooleanField('featuresTerrace', inmueble.Superficie_Util_Trastero_con_pasillos_m2__c > 0 || inmueble.Superficie_Terrazas_Descubiertas__c > 0);
                                                    
                                                    //Falta ->  gen.writeBooleanField('featuresStudio', '');
                                                    //Falta ->  gen.writeBooleanField('featuresWardrobes', '');
                                                    //Falta ->  gen.writeStringField('featuresWindowsLocation', '');
                                                    //Falta ->  gen.writeStringField('featuresHeatingType', '');
                                            
                                                } else if(inmueble.Tipo_de_inmueble__r.Tipo__c == 'Garaje'){
                                                    gen.writeStringField('featuresType', 'garage');
                                                    gen.writeNumberField('featuresAreaConstructed', Integer.valueOf(inmueble.Superficie_Construida_total_con_ZZCC_m2__c));
                                                    gen.writeNumberField('featuresAreaUsable', Integer.valueOf(inmueble.Superficie_Util_m2__c));
                                                } else if(inmueble.Tipo_de_inmueble__r.Tipo__c == 'Trastero'){
                                                    gen.writeStringField('featuresType', 'storage');
                                                    gen.writeNumberField('featuresAreaConstructed', Integer.valueOf(inmueble.Superficie_Construida_total_con_ZZCC_m2__c));
                                                    gen.writeNumberField('featuresAreaUsable', Integer.valueOf(inmueble.Superficie_Util_m2__c));                                            
                                                } else if(inmueble.Tipo_de_inmueble__r.Tipo__c == 'Local'){
                                                    gen.writeStringField('featuresType', 'offices');
                                                    gen.writeNumberField('featuresAreaConstructed', Integer.valueOf(inmueble.Superficie_Construida_total_con_ZZCC_m2__c));  
                                                    gen.writeNumberField('featuresAreaUsable', Integer.valueOf(inmueble.Superficie_Util_m2__c));
                                                }

                                            gen.writeEndObject();

                                            //Descripciones de la propiedad                        	
                                            gen.writeFieldName('propertyDescriptions');    
                                            gen.writeStartArray();
                                                gen.writeStartObject();
                                                    // TODO -> HACERLO EN DIVERSOS IDIOMAS?
                                                    gen.writeStringField('descriptionLanguage', 'spanish');
                                                    if(inmueble.Description != null){
                                                        gen.writeStringField('descriptionText', inmueble.Description.abbreviate(4000));
                                                    }
                                                gen.writeEndObject();
                                            gen.writeEndArray();

                                            // Imágenes del inmueble actual
                                            List<ContentDocumentLink> inmuebleImgsList = inmueblesImgs.get(inmueble.Id);
                                            gen.writeFieldName('propertyImages');
                                            gen.writeStartArray(); 
                                            if(inmuebleImgsList != null) {
                                                Integer i = 1;
                                                for(ContentDocumentLink img : inmuebleImgsList) {
                                                    if(img != null) {
                                                        gen.writeStartObject();
                                                            gen.writeNumberField('imageOrder', img.ContentDocument.LatestPublishedVersion.Posicion__c != null ? img.ContentDocument.LatestPublishedVersion.Posicion__c : i);
                                                            //Falta ->  gen.writeStringField('imageLabel', ''); //"bathroom","bedroom","communalareas","corridor","details","energycertificate","facade","garage","garden","gateway","hall","kitchen","land","living","mates","plan","pool","reception","room","storage","terrace","unknown","views","waitingroom"
                                                            gen.writeStringField('imageUrl', PublicacionPortales.devolverURLDocumento(img.ContentDocument.LatestPublishedVersion.URL__c, img.ContentDocument.LatestPublishedVersion.Id, img.ContentDocument.LatestPublishedVersion.FileType)); 
                                                        gen.writeEndObject();
                                                        i++;
                                                    }
                                                }
                                            }
                                            gen.writeEndArray();

                                        gen.writeEndObject();
                                    }
                                }
                            }
                        gen.writeEndArray();
                        //end array inmuebles
                    gen.writeEndObject();
                }
                gen.writeEndArray();
            gen.writeEndObject();
            prettyJSON = gen.getAsString();
        }
        System.debug('prettyJSON: ' + prettyJSON);

        return prettyJSON;
    }

    private static void checkDataErrors(List<Promocion__c> promotions, Map<Id, List<Product2>> promosInmueblesMap) {
        // Comprobación de obligatorios
        String errors = '';
        for(Promocion__c promotion : promotions) {

            List<Product2> inmuebles = promosInmueblesMap.get(promotion.Id);
            if(inmuebles != null) {
                for(Product2 inmueble : inmuebles) {
                    if(inmueble.Precio__c < 1 || inmueble.Precio__c == null) {
                        errors += 'El inmueble ' + inmueble.Name + ' de la promoción ' + promotion.Nombre_Comercial_Avintia_Inmobiliaria__c + ' no tiene precio o es menor a 1, es obligatorio y tiene que ser mayor a 0.\n\r';
                    }

                    if(inmueble.Nombre_Via__c == null) {
                        errors += 'El inmueble ' + inmueble.Name + ' de la promoción ' + promotion.Nombre_Comercial_Avintia_Inmobiliaria__c + ' no tiene nombre de vía, es obligatorio.\n\r';
                    }

                    if(inmueble.Tipo_de_inmueble__r.Tipo__c == 'Vivienda' && (inmueble.N_habitaciones__c < 1 || inmueble.N_habitaciones__c == null)) {
                        errors += 'El inmueble ' + inmueble.Name + ' de la promoción ' + promotion.Nombre_Comercial_Avintia_Inmobiliaria__c + ' no tiene nº habitaciones o es menor a 1, es obligatorio y tiene que ser mayor a 0.\n\r';
                    }

                    if(inmueble.Tipo_de_inmueble__r.Tipo__c == 'Vivienda' && (inmueble.Superficie_Construida_total_con_ZZCC_m2__c < 1 || inmueble.Superficie_Construida_total_con_ZZCC_m2__c == null)) {
                        errors += 'El inmueble ' + inmueble.Name + ' de la promoción ' + promotion.Nombre_Comercial_Avintia_Inmobiliaria__c + ' no tiene m2 construidos o es menor a 1, es obligatorio y tiene que ser mayor a 0.\n\r';
                    }

                    if(inmueble.Codigo_postal__c == null) {
                        errors += 'El inmueble ' + inmueble.Name + ' de la promoción ' + promotion.Nombre_Comercial_Avintia_Inmobiliaria__c + ' no tiene código postal, es obligatorio.\n\r';
                    }
                }
            }
        }
        if(errors != '') {
            errors = 'Los errores han sido los siguientes: \n\r' + errors;
            if(!Test.isRunningTest()) {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] { UserInfo.getUserEmail() };
                message.subject = 'Error de datos al publicar en Idealista';
                message.plainTextBody = errors;
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
            throw new PublicacionPortalIdealistaException('No se ha podido completar la publicación en Idealista, hay errores en los datos. Se ha enviado un correo con estos errores a revisar.');
        }
    }
    
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

    public class PublicacionPortalIdealistaException extends Exception {}
}