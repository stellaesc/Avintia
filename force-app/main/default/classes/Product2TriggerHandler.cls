/*****************************************************
* Class Name: Product2TriggerHandler                *
* Test Name: Product2TriggerHandler_Test            *
* Date: 25/09/2018                                  *
* Author: Deloitte                                  *
* Description: handler class for product2 trigger   *
* ***************************************************/
public class Product2TriggerHandler extends TriggerHandler {
    
    protected override void beforeInsert() {
        Set <Id> idProm = new Set<Id>();
        for(Product2 pr : (List<Product2>)Trigger.new ){
            idProm.add(pr.Promocion__c);
        }
        Map<Id, Promocion__c> prom = new Map<Id, Promocion__c>([SELECT Id, Suma_Precios_Inmuebles__c FROM Promocion__c WHERE Id IN:idProm]);
        List<Promocion__c> promAct = new List<Promocion__c>();
        for(Product2 pr : (List<Product2>)Trigger.new){
            if(pr.Precio__c != null && pr.Promocion__c != null){
                prom.get(pr.Promocion__c).Suma_Precios_Inmuebles__c += pr.Precio__c;
                if(!promAct.contains(prom.get(pr.Promocion__c))){
                    promAct.add(prom.get(pr.Promocion__c));                   
                }
            }
        }
        update promAct;
    }

    protected override void beforeUpdate() {
        //if(!Test.isRunningTest()){
            Set <Id> idProm = new Set<Id>();
            for(Product2 pr : (List<Product2>)Trigger.new){
                idProm.add(pr.Promocion__c);
            }
            for(Product2 pr : (List<Product2>)Trigger.old){
                idProm.add(pr.Promocion__c);
            }
            Map<Id, Promocion__c> prom = new Map<Id, Promocion__c>([SELECT Id, Suma_Precios_Inmuebles__c FROM Promocion__c WHERE Id IN:idProm]);
            List<Promocion__c> promAct = new List<Promocion__c>();
            for(Product2 pr : (List<Product2>)Trigger.new){
                for(Product2 pr2: (List<Product2>)Trigger.old){
                    if(pr.Precio__c != pr2.Precio__c && pr2.Precio__c != null && pr.Precio__c != null && pr2.Promocion__c == pr.Promocion__c
                       && pr.Promocion__c != null && pr2.Promocion__c != null){
                           Decimal diferencia = pr.Precio__c - pr2.Precio__c;
                           prom.get(pr.Promocion__c).Suma_Precios_Inmuebles__c += diferencia;
                           if(!promAct.contains(prom.get(pr.Promocion__c))){
                               promAct.add(prom.get(pr.Promocion__c));                   
                           }
                       }
                }
            }
            if(!promAct.isEmpty()){
                update promAct;
            }
            
            checkPrecioPropuestoByOpportunity((List<Product2>)Trigger.new, (Map<Id, Product2>)Trigger.oldMap);
        //}
    }

    protected override void afterInsert() {
        ActualizarPriceBookEntry((List<Product2>)Trigger.new, (List<Product2>)Trigger.old);
        if(!Test.isRunningTest()){
        	TriggerHandler.bypass('Product2Trigger');
        }
    }

    protected override void afterUpdate() {
        ActualizarPriceBookEntry((List<Product2>)Trigger.new, (List<Product2>)Trigger.old);
        ActualizarViviendasBabonlab((List<Product2>)Trigger.new, (List<Product2>)Trigger.old);
        if(!Test.isRunningTest()){
        	TriggerHandler.bypass('Product2Trigger');    
        }
    }
    
    protected override void beforeDelete() {
        Set <Id> idProm = new Set<Id>();
        for(Product2 pr : (List<Product2>)Trigger.old ){
            idProm.add(pr.Promocion__c);
        }
        Map<Id, Promocion__c> prom = new Map<Id, Promocion__c>([SELECT Id, Suma_Precios_Inmuebles__c FROM Promocion__c WHERE Id IN:idProm]);
        List<Promocion__c> promAct = new List<Promocion__c>();
        for(Product2 pr : (List<Product2>)Trigger.old){
            if(pr.Precio__c != null){
                prom.get(pr.Promocion__c).Suma_Precios_Inmuebles__c -= pr.Precio__c;
                if(!promAct.contains(prom.get(pr.Promocion__c))){
                    promAct.add(prom.get(pr.Promocion__c));                   
                }
            }
        }
        update promAct;
        
        Id idGrupo = [SELECT Id FROM Group WHERE DeveloperName = 'Notificacion_borrado'].ID;        
        List<GroupMember> lgmember = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId =: idGrupo];
        Id templateId = [select id, name from EmailTemplate where developername = 'Alerta_Borrado_Producto'].Id;
        Set<Id> idslgmember = new Set<Id>();
        for(GroupMember gm: lgmember){
            idslgmember.add(gm.UserOrGroupId);
        }
        List<User> luser = [SELECT id, email FROM User WHERE id IN: Idslgmember];
        List<String> lemails = new List<String>();
        List<String> lids = new List<String>();
     
        for(User em: luser){
            lemails.add(em.Email);
            lids.add(em.ID);
        }
        Contact c = new Contact(LastName = 'c1', Email = lemails.get(0));
        insert c;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();   
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'comercial@avintiainmobiliaria.com'];	     
        for(Product2 pr : (List<Product2>)Trigger.old ){
            System.debug('Se borra y se manda mail');
            System.debug('PRODUCTO ' + pr.Id);
            System.debug('Listado emails: '+ lemails);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = lemails;
            message.optOutPolicy = 'FILTER';
            message.setTemplateId(templateId);
            message.setTargetObjectId(c.Id);
            message.setSaveAsActivity(false); 
            message.setTreatTargetObjectAsRecipient(false);
            message.setWhatId(pr.Id);
            if ( owea.size() > 0 ) {	
                message.setOrgWideEmailAddressId(owea.get(0).Id);	
            }	
            messages.add(message);
           // message.setHtmlBody(message.getHtmlBody() + ' ' + pr.id);
        }
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        System.debug('Resultados: '+ results);
        delete c;
        
    }

    public void checkPrecioPropuestoByOpportunity(List<Product2> newList, Map<Id, Product2> oldMap) {
            Set<Id> oppIds = new Set<Id>();
            for(Product2 prd : newList)
                if(prd.Oportunidad__c != null) oppIds.add(prd.Oportunidad__c);

            Map<Id, List<Product2>> oppPrds = new Map<Id, List<Product2>>();
            for(Product2 prd : newList)
                if(prd.Oportunidad__c != null){
                    if(!oppPrds.containsKey(prd.Oportunidad__c)) oppPrds.put(prd.Oportunidad__c, new List<Product2>());

                    oppPrds.get(prd.Oportunidad__c).add(prd);
                }

            Map<Id, Opportunity> opps = new Map<Id, Opportunity>([SELECT Id, StageName FROM Opportunity WHERE Id = :oppIds]);
            for(Id i : oppPrds.keyset()) {
                for(Product2 prd : oppPrds.get(i)){
                    if( (opps.get(i).StageName != 'Cancelada' && opps.get(i).StageName != 'Fin Postventa') && (prd.Precio_propuesto__c != null && oldMap.get(prd.Id).Precio_propuesto__c != prd.Precio_propuesto__c) )
                        prd.Precio_propuesto__c.addError('El producto pertenece a una oportunidad abierta.');
                }
            }
        
    }

    /***********************************************************************************************
* Method Name: ActualizarPriceBookEntry                                                                            *
* Description: Actualiza la entrada en la lista de precios estándar si ya existe, o crea la entrada si no existe . *
* Author: Deloitte                                                                             *
* **********************************************************************************************/  
    
    public void ActualizarPriceBookEntry(List<Product2> newList, List<Product2> oldList){
        // Metemos los ids de los inmuebles que se van a insertar o actualizar en la lista productListId
        List<Id> productListId = new List<Id>();
        for(Product2 inmueble : newList){
            productListId.add(inmueble.Id);
        }
        system.debug('productListId:::'+productListId);
        
        Id pricebookId = Utils.getStandarPriceBook();
        
        // Recuperamos las entradas de Precios que tienen estos productos en la lista de precios estandar (si tienen entrada)
        List<PriceBookEntry> entradaPreciosList = [SELECT Id, UnitPrice, Product2Id, Pricebook2Id 
                                                   FROM PriceBookEntry
                                                   WHERE Product2Id IN : productListId AND Pricebook2Id =: pricebookId FOR UPDATE];
        System.debug('entradaPreciosList:::'+entradaPreciosList);
        
        
        ///////////////////////////////// SI TIENEN ENTRADA <==> SI ES UPDATE ////////////////////////////////////////////
        // Rellenamos la lista priceBookEntryToUpdate con las entradas de precios actualizadas (UnitPrice recoge Precio__c)
        
        List<PriceBookEntry> priceBookEntryToUpdate = new List<PriceBookEntry>();
        for(PriceBookEntry entrada : entradaPreciosList){
            for(Product2 inmueble : newList){
                if(entrada.Product2Id == inmueble.Id && inmueble.Precio__c != null){   
                    entrada.UnitPrice = inmueble.Precio__c;
                    priceBookEntryToUpdate.add(entrada);                    
                }  
            }
        }
        
        ///////////////////////////////// NO TIENEN ENTRADA ////////////////////////////////////////////
        
        //Recogemos los Ids de los inmuebles que sí tienen entrada de precios
        List<Id> inmueblesConEntradaPreciosList = new List<Id>();
        for(PriceBookEntry entradaPrecios : entradaPreciosList){
            inmueblesConEntradaPreciosList.add(entradaPrecios.Product2Id);
        }
        system.debug('inmueblesConEntradaPreciosList:::'+inmueblesConEntradaPreciosList);
        
        // Filtramos newList y nos quedamos con los inmuebles que no tienen entrada de precios
        List<Product2> inmueblesSinEntradaPreciosList = new List<Product2>();
        for(Product2 inmueble: newList){
            if (!inmueblesConEntradaPreciosList.contains(inmueble.Id)){
                inmueblesSinEntradaPreciosList.add(inmueble);
            }
        }
        system.debug('inmueblesSinEntradaPreciosList:::'+inmueblesSinEntradaPreciosList);
        
        // Creamos una entrada de precios por cada inmueble que no tiene entrada
        List<PriceBookEntry> priceBookEntryToInsert = new List<PriceBookEntry>();
        for(Product2 inmueble : inmueblesSinEntradaPreciosList){
            if(inmueble.Precio__c != null){
                PriceBookEntry entradaPrecios = new PriceBookEntry(UnitPrice = inmueble.Precio__c, Product2Id = inmueble.Id, Pricebook2Id = pricebookId, IsActive = True);
                priceBookEntryToInsert.add(entradaPrecios); 
            }
        } 
        
        
        system.debug('priceBookEntryToInsert:::'+priceBookEntryToInsert);
        insert priceBookEntryToInsert; 
        
        system.debug('priceBookEntryToUpdate:::'+priceBookEntryToUpdate);
        update priceBookEntryToUpdate;
    }   
    
    /***********************************************************************************************
* Method Name: ActualizarViviendasBabonlab                                                                            *
* Description: Actualiza las viviendas en Babonlab . *
* Author: Deloitte                                                                             *
* **********************************************************************************************/  
    //@future(callout = true)
    public void ActualizarViviendasBabonlab(List<Product2> newList, List<Product2> oldList){
        
        
        Set<Id> idsPromociones= new Set<Id>();
        for (Product2 viv:newList)
        {
            
            idsPromociones.add(viv.Promocion__c);
            
        }
        
        List<Promocion__c> promociones =[Select Id from Promocion__c where Id in:idsPromociones and PublicacionViviendasBaboonlab__c=true];
        
        for(Promocion__c promo:promociones){
            envioViviendasBabonlab(promo.Id);
        }
        
    }
    @future(callout = true)
    public static void envioViviendasBabonlab(Id PromoId)
    {
        PropiedadesIntegracion__c propiedadesIntegracion =PropiedadesIntegracion__c.getInstance();
        List<PublicacionBabonlab.DummyViviendasEnvio> envioViviendas;
        try{
            //Se genera el JSON con la petición de alta
            envioViviendas=PublicacionBabonlab.generarPeticionAltaModifVivienda(PromoId);
            
            // Send the request
            HttpRequest req = new HttpRequest();
            req.setHeader('X-HTTP-Method-Override','PATCH');
            req.setMethod('POST');
            req.setEndpoint(propiedadesIntegracion.URL_BABONLAB_VIVIENDAS__c);
            req.setHeader('Content-Type','application/json');
            req.setHeader('Apikey',propiedadesIntegracion.API_KEY_BABONLAB__c);
            req.setBody(JSON.serialize(envioViviendas,true));
            req.setTimeout(120000);
            Http http = new Http();
            HttpResponse res;
            //Realizamos el envio de la promocion a Babonlab
            if(!System.Test.isRunningTest())
            {
                
                res = http.send(req);
            }
            else
            {
                res= new HttpResponse();
                res.setStatusCode(201);
                res.setBody('[ { "id": 0, "id_external": "string", "promotion": 0, "slug": "string", "orientation": { "additionalProp1": true, "additionalProp2": true, "additionalProp3": true }, "type": 0, "condition": 0, "floor_type": 0, "name": "string", "price": 0, "area": 0, "rooms": 0, "bathrooms": 0, "level": 0, "doorway": "string", "zoom": 0, "home_lat": "string", "home_lng": "string", "date_reservation": "2019-06-25T07:19:13.881Z", "date_sold": "2019-06-25T07:19:13.881Z", "block": "string", "penthouse": 0, "penthouse_area": 0, "phase": "string", "letter": "string", "stairs": "string", "built_area": 0, "useful_area": 0, "common_area": 0, "garages": 0, "storerooms": 0, "terrace": true, "terrace_area": 0, "created_at": "2019-06-25T07:19:13.881Z", "updated_at": "2019-06-25T07:19:13.881Z", "enabled": true, "in_dekrs": true, "levels": 0, "availability": 0, "description": "string", "address": { "id": 0, "country": 0, "province": 0, "state": 0, "municipality": 0, "province_ine_ref_code": 0, "state_ine_ref_code": 0, "municipality_ine_ref_code": 0, "street": "string", "address_number": "string", "postal_code": "string", "floor": "string", "floor_letter": "string", "lat": "string", "lng": "string" }, "elevator": true, "exterior": true, "swimmingpool": true, "built_in_wardrobes": true, "air_conditioning": true, "garden": true, "sports": true, "accessible": true, "security_surveillance": true, "corner": true, "allow_adults": true, "allow_kids": true, "allow_babies": true, "allow_big_pets": true, "allow_small_pets": true, "transaction_type": 0, "is_featured": true } ]');
            }
            
            if (res!=null && res.getStatusCode()!=null && res.getStatusCode() == 201) {
                
                List<PublicacionBabonlab.DummyRespuestaViviendas> respuesta= (List<PublicacionBabonlab.DummyRespuestaViviendas>) JSON.deserialize(res.getBody(), List<PublicacionBabonlab.DummyRespuestaViviendas>.class);
                
                string mensaje;
                string respuestaActualizacion;
                if(JSON.serialize(envioViviendas,true).length()>131071 || res.getBody().length()>131071)
                {
                    system.debug('PETICION ACTUALIZACIÓN--> ' + JSON.serialize(envioViviendas,true));
                    system.debug('RESPUESTA ACTUALIZACIÓN--> ' + res.getBody());
                    mensaje='Envio de peticion de actualización de viviendas a Baboonlab (revise el log del servidor)';
                    respuestaActualizacion='Respuesta de peticion de actualización de viviendas a Baboonlab (revise el log del servidor)';
                }
                else{
                    mensaje=JSON.serialize(envioViviendas,true);
                    respuestaActualizacion=res.getBody();
                    
                }
                
                PublicacionBabonlab.insertarLog('publicarBabonLab-->Viviendas',PromoId,mensaje,respuestaActualizacion,'INTEGRACION BABONLAB');
            }
            else
            {
                
                system.debug(res);
                system.debug(res.getBody());
                system.debug(res.getStatusCode());
                system.debug(JSON.serialize(envioViviendas,true));
                string mensaje;
                string respuestaActualizacion;
                if(JSON.serialize(envioViviendas,true).length()>131071 || res.getBody().length()>131071)
                {
                    system.debug('PETICION ACTUALIZACIÓN--> ' + JSON.serialize(envioViviendas,true));
                    system.debug('RESPUESTA ACTUALIZACIÓN--> ' + res.getBody());
                    mensaje='Envio de peticion de actualización de viviendas a Baboonlab (revise el log del servidor)';
                    respuestaActualizacion='Respuesta de peticion de actualización de viviendas a Baboonlab (revise el log del servidor)';
                }
                else{
                    mensaje=JSON.serialize(envioViviendas,true);
                    respuestaActualizacion=res.getBody();
                    
                }
                PublicacionBabonlab.insertarLog('publicarBabonLab-->Viviendas',PromoId,mensaje,respuestaActualizacion,'INTEGRACION BABONLAB');
            }
            
        }catch(Exception e){
            System.debug('Error al realizar el envio de las viviendas: '+ e);
            system.debug(JSON.serialize(envioViviendas,true));
            PublicacionBabonlab.insertarLog('publicarBabonLab-->Viviendas',PromoId,'Actualizacion de viviendas', e.getMessage(),'PUBLICACION BABONLAB');
        }
    }
}