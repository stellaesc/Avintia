public class PublicacionBabonlab {
    @AuraEnabled
     public static string enviarPromocion (Id PromoId)
     {
        string resultado ='OK';
        PropiedadesIntegracion__c propiedadesIntegracion =PropiedadesIntegracion__c.getInstance();
        DummyPromocionesEnvio envioPromocion;

        try{
                //Se genera el JSON con la petición de alta
                envioPromocion=generarPeticionAltaModifPromocion(PromoId);

                // Send the request
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint(propiedadesIntegracion.URL_BABONLAB_PROMOCION__c);
                req.setHeader('Content-Type','application/json');
                req.setHeader('Apikey',propiedadesIntegracion.API_KEY_BABONLAB__c);
                req.setBody(JSON.serialize(envioPromocion,true));
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
                    res.setBody('{ "id": 0, "municipality": 0, "province": 0, "state": 0, "country": 0, "slug": "string", "url360": "string", "name": "string", "enabled": true, "description": "string", "order": 0, "video": "string", "is_featured": true, "construction": "It will finish at the end of this year", "created_at": "2019-04-23T14:12:34.645Z", "updated_at": "2019-04-23T14:12:34.645Z", "category": 0, "address": { "id": 0, "country": 0, "province": 0, "state": 0, "municipality": 0, "province_ine_ref_code": 0, "state_ine_ref_code": 0, "municipality_ine_ref_code": 0, "street": "string", "number": "string", "postal_code": "string", "floor": "string", "floor_letter": "string", "lat": "string", "lng": "string" } }');
                }
                    
                //system.debug(res.getStatusCode());
                if (res!=null && res.getStatusCode()!=null && res.getStatusCode() == 201) {
                    
                    DummyPromocionesRespuesta respuesta= (DummyPromocionesRespuesta) JSON.deserialize(res.getBody(), DummyPromocionesRespuesta.class);
                    insertarLog('publicarBabonLab-->Prmocion',PromoId,envioPromocion.tostring(),respuesta.toString(),'INTEGRACION BABONLAB');
                   
                   if(respuesta!=null && respuesta.id!=null)
                   {
                       Promocion__c promocion=new Promocion__c();
                       promocion.ID=PromoId;
                       promocion.IdPromocionBabonlab__c=respuesta.ID;
                       update promocion;
                   }
                }
                 else
                {
                    resultado='KO';
                    insertarLog('publicarBabonLab-->Prmocion',PromoId,JSON.serialize(envioPromocion,true),resultado,'INTEGRACION BABONLAB');
                }

            }catch(Exception e){
                System.debug('Error al realizar el envio: '+ e);
                resultado='KO';
                insertarLog('publicarBabonLab',PromoId,JSON.serialize(envioPromocion,true), e.getMessage(),'PUBLICACION BABONLAB');
            }

         
         return resultado;
     }
    @AuraEnabled
     public static string actualizarPromocion (Id PromoId, Decimal idBabonlab)
     {
        string resultado ='OK';
        PropiedadesIntegracion__c propiedadesIntegracion =PropiedadesIntegracion__c.getInstance();
        DummyPromocionesEnvio envioPromocion;

        try{
                //Se genera el JSON con la petición de modificación
                envioPromocion=generarPeticionAltaModifPromocion(PromoId);
                system.debug(JSON.serialize(envioPromocion, true));
                system.debug(idBabonlab);
                // Send the request
                HttpRequest req = new HttpRequest();
                req.setEndpoint(propiedadesIntegracion.URL_BABONLAB_PROMOCION_MODIFICACION__c+idBabonlab);
                req.setHeader('Content-Type','application/json');
                req.setHeader('Apikey',propiedadesIntegracion.API_KEY_BABONLAB__c);
                req.setHeader('X-HTTP-Method-Override','PATCH');
                req.setMethod('POST');
                req.setBody(JSON.serialize(envioPromocion, true));
                
                req.setTimeout(120000);
                Http http = new Http();
                HttpResponse res;
                //Realizamos el envio de la promocion a Babonlab
                if(!System.Test.isRunningTest())
                {
                        
                    res = http.send(req);
                    system.debug('Respuesta'+res);
                }
                else
                {
                    res= new HttpResponse();
                    res.setStatusCode(204);
                    res.setBody('{ "id": 0, "municipality": 0, "province": 0, "state": 0, "country": 0, "slug": "string", "url360": "string", "name": "string", "enabled": true, "description": "string", "order": 0, "video": "string", "is_featured": true, "construction": "It will finish at the end of this year", "created_at": "2019-04-23T14:12:34.645Z", "updated_at": "2019-04-23T14:12:34.645Z", "category": 0, "address": { "id": 0, "country": 0, "province": 0, "state": 0, "municipality": 0, "province_ine_ref_code": 0, "state_ine_ref_code": 0, "municipality_ine_ref_code": 0, "street": "string", "number": "string", "postal_code": "string", "floor": "string", "floor_letter": "string", "lat": "string", "lng": "string" } }');
                }

                //system.debug(res.getStatusCode());
                if (res!=null && res.getStatusCode()!=null && res.getStatusCode() == 200) {
                    
                    
                    insertarLog('publicarModificacionBabonLab-->Prmocion',PromoId,envioPromocion.tostring(),res.toString(),'INTEGRACION BABONLAB');  
                }
                 else
                {
                    resultado='KO';
                    insertarLog('publicarModificacionBabonLab-->Prmocion',PromoId,JSON.serialize(envioPromocion, true),resultado,'INTEGRACION BABONLAB');
                }

            }catch(Exception e){
                System.debug('Error al realizar el envio de la modificación: '+ e);
                resultado='KO';
                insertarLog('publicarModificacionBabonLab',PromoId,JSON.serialize(envioPromocion, true), e.getMessage(),'PUBLICACION BABONLAB');
            }

         
         return resultado;
     }  
     
     @AuraEnabled
     public static string enviarViviendas (Id PromoId)
     {
        string resultado ='OK';
        PropiedadesIntegracion__c propiedadesIntegracion =PropiedadesIntegracion__c.getInstance();
        List<DummyViviendasEnvio> envioViviendas;
        try{
                //Se genera el JSON con la petición de alta
                envioViviendas=generarPeticionAltaModifVivienda(PromoId);

                // Send the request
                HttpRequest req = new HttpRequest();
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
                    
                   List<DummyRespuestaViviendas> respuesta= (List<DummyRespuestaViviendas>) JSON.deserialize(res.getBody(), List<DummyRespuestaViviendas>.class);
                    string mensaje;
                    string respuestaAlta;
                   if(JSON.serialize(envioViviendas,true).length()>131071 || res.getBody().length()>131071)
                   {
                       system.debug('PETICION ALTA--> ' + JSON.serialize(envioViviendas,true));
                       system.debug('RESPUESTA ALTA--> ' + res.getBody());
                       mensaje='Envio de peticion de alta de viviendas a Baboonlab (revise el log del servidor)';
                       respuestaAlta='Respuesta de peticion de alta de viviendas a Baboonlab (revise el log del servidor)';
                   }
                   else{
                       mensaje=JSON.serialize(envioViviendas,true);
                       respuestaAlta=res.getBody();

                   }
                   insertarLog('publicarBabonLab-->Viviendas',PromoId,mensaje,respuestaAlta,'INTEGRACION BABONLAB');
                    List<Product2> product2 =new List<Product2> ();
                    Product2 vivienda=null;
                    if(respuesta.size()>0)
                    {
                        for(DummyRespuestaViviendas resViv: respuesta){
                            vivienda=new Product2();
                            if(resViv!=null && resViv.id!=null && resViv.id_external!=null)
                            {
                                vivienda.id=resViv.id_external;
                                vivienda.id_ViviendaBaboonlab__c=resViv.id;
                                product2.add(vivienda);
                            }
                        }
                        if(product2.size()>0)
                        {
                            update product2;
                        }
                        Promocion__c promocion=new Promocion__c();
                        promocion.ID=PromoId;
                        promocion.PublicacionViviendasBaboonlab__c=true;
                        update promocion;
                    }
                }
                 else
                {
                    resultado='KO ';
                    system.debug(res);
                    system.debug(res.getBody());
                    system.debug(res.getStatusCode());
                    system.debug(JSON.serialize(envioViviendas,true));

                    string mensaje;
                    string respuestaAlta;
                   if(JSON.serialize(envioViviendas,true).length()>131071 || res.getBody().length()>131071)
                   {
                       system.debug('PETICION ALTA--> ' + JSON.serialize(envioViviendas,true));
                       system.debug('RESPUESTA ALTA--> ' + res.getBody());
                       mensaje='Envio de peticion de alta de viviendas a Baboonlab (revise el log del servidor)';
                       respuestaAlta='Respuesta de peticion de alta de viviendas a Baboonlab (revise el log del servidor)';
                   }
                   else{
                       mensaje=JSON.serialize(envioViviendas,true);
                       respuestaAlta=res.getBody();

                   }
                    insertarLog('publicarBabonLab-->Viviendas',PromoId,mensaje,respuestaAlta,'INTEGRACION BABONLAB');
                }

            }catch(Exception e){
                System.debug('Error al realizar el envio de las viviendas: '+ e);
                system.debug(JSON.serialize(envioViviendas,true));
                resultado='KO';
                string mensaje;
                if(JSON.serialize(envioViviendas,true).length()>131071)
                {
                    system.debug('PETICION ALTA--> ' + JSON.serialize(envioViviendas,true));
                    mensaje='Envio de peticion de alta de viviendas a Baboonlab (revise el log del servidor)';
                }
                else{
                    mensaje=JSON.serialize(envioViviendas,true);
                }

                insertarLog('publicarBabonLab-->Viviendas',PromoId,mensaje, e.getMessage(),'PUBLICACION BABONLAB');
            }


        return resultado;

     }
      @AuraEnabled
     public static string actualizarViviendas (Id PromoId)
     {
        string resultado ='OK';
        PropiedadesIntegracion__c propiedadesIntegracion =PropiedadesIntegracion__c.getInstance();
        List<DummyViviendasEnvio> envioViviendas;
        try{
                //Se genera el JSON con la petición de alta
                envioViviendas=generarPeticionAltaModifVivienda(PromoId);

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
                    
                   List<DummyRespuestaViviendas> respuesta= (List<DummyRespuestaViviendas>) JSON.deserialize(res.getBody(), List<DummyRespuestaViviendas>.class);
                   
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
                   
                   insertarLog('publicarBabonLab-->Viviendas',PromoId,mensaje,respuestaActualizacion,'INTEGRACION BABONLAB');
                }
                 else
                {
                    resultado='KO ';
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
                    insertarLog('publicarBabonLab-->Viviendas',PromoId,mensaje,respuestaActualizacion,'INTEGRACION BABONLAB');
                }

            }catch(Exception e){
                System.debug('Error al realizar el envio de las viviendas: '+ e);
                system.debug(JSON.serialize(envioViviendas,true));
                resultado='KO';
                insertarLog('publicarBabonLab-->Viviendas',PromoId,'Actualizacion de viviendas', e.getMessage(),'PUBLICACION BABONLAB');
            }


        return resultado;

     }

    public static DummyPromocionesEnvio generarPeticionAltaModifPromocion(ID promocionID) {
        DummyPromocionesEnvio envioPromocion = new DummyPromocionesEnvio ();
        //Se buscan los datos de la promoción
        List<Promocion__c> promociones = [SELECT Id, Nombre_Comercial_Avintia_Inmobiliaria__c, Descripcion__c, Localidad__c, Localidad__r.Codigo_municipio__c,
                                        Provincia__c, Localidad__r.Provincia__r.Codigo__c, Comunidad_autonoma__c, Localidad__r.Provincia__r.Comunidad_autonoma__r.Codigo__c,
                                        Coordenadas__Latitude__s, Coordenadas__Longitude__s, Tipo_via__c, Nombre_via__c, N_Via__c, Codigo_postal__c, 
                                        Superficie_util_m2_viviendas_calculada__c, Sup_Const_total_con_ZZCC_viviendas_Manu__c, Superficie_Jardines_Manu__c,
                                        Link_video_promocion__c 
                                        FROM Promocion__c 
                                        WHERE Id = :promocionID];

        // Hitos de la promoción
        List<Hitos_de_Promocion__c> hitos = [SELECT Id, Promocion__c, Inicio_de_obra__c, Fin_de_obra__c 
                                             FROM Hitos_de_Promocion__c 
                                             WHERE (Inicio_de_obra__c != null OR Fin_de_obra__c != null) AND Promocion__c = :promocionID 
                                             ORDER BY CreatedDate desc];
        Map<Id,List<Hitos_de_Promocion__c>> hitosPromocionMap = new Map<Id, List<Hitos_de_Promocion__c>>();
        if(hitos != null) {
            for(Hitos_de_Promocion__c hito: hitos) {
                List<Hitos_de_Promocion__c> listHitos = hitosPromocionMap.get(hito.Promocion__c);
                if(listHitos == null) listHitos = new List<Hitos_de_Promocion__c>();
                listHitos.add(hito); 
                hitosPromocionMap.put(hito.Promocion__c, listHitos); 
            }  
        }

        // Recorremos las promociones
        for(Promocion__c promocion : promociones) {
            envioPromocion.url360 = '';
            envioPromocion.name = String.isBlank(promocion.Nombre_Comercial_Avintia_Inmobiliaria__c) ? '' : promocion.Nombre_Comercial_Avintia_Inmobiliaria__c;
            envioPromocion.enabled = false;
            envioPromocion.description = String.isBlank(promocion.Descripcion__c) ? '' : promocion.Descripcion__c;
            envioPromocion.order = 0;
            envioPromocion.video = String.isBlank(promocion.Link_video_promocion__c) ? '' : promocion.Link_video_promocion__c;
            envioPromocion.is_featured = false;
            envioPromocion.construction = '';

            //Solo se mira el ultimo hito de promoción ya que se realizan cargas mensuales
            Integer category = 3;
            if(!hitosPromocionMap.isEmpty()) {
                if(hitosPromocionMap.get(promocion.id).get(0).Inicio_de_obra__c != null && hitosPromocionMap.get(promocion.id).get(0).Inicio_de_obra__c > Date.today()) {
                    category = 3;
                } else if(hitosPromocionMap.get(promocion.id).get(0).Inicio_de_obra__c != null && hitosPromocionMap.get(promocion.id).get(0).Inicio_de_obra__c < Date.today() && 
                    hitosPromocionMap.get(promocion.id).get(0).Fin_de_obra__c != null && hitosPromocionMap.get(promocion.id).get(0).Fin_de_obra__c > Date.today())
                {
                    category = 2;
                } else if(hitosPromocionMap.get(promocion.id).get(0).Fin_de_obra__c!=null && hitosPromocionMap.get(promocion.id).get(0).Fin_de_obra__c>Date.today()){
                    category = 1;
                }
            }
            
            envioPromocion.category = category;

            DummyPromocionesAdress direccion = new DummyPromocionesAdress();
            direccion.province_ine_ref_code = String.isBlank(promocion.Provincia__c) ? 0 : Integer.valueof(promocion.Localidad__r.Provincia__r.Codigo__c);
            direccion.state_ine_ref_code = String.isBlank(promocion.Comunidad_autonoma__c) ? 0 : Integer.valueof(promocion.Localidad__r.Provincia__r.Comunidad_autonoma__r.Codigo__c);
            direccion.municipality_ine_ref_code = String.isBlank(promocion.Localidad__c) ? 0 : Integer.valueof(promocion.Localidad__r.Codigo_municipio__c);
            direccion.street = (String.isBlank(promocion.Tipo_via__c) ? '' : promocion.Tipo_via__c) + ' ' + (String.isBlank(promocion.Nombre_via__c) ? '' : promocion.Nombre_via__c);
            direccion.address_number = promocion.N_Via__c == null ? '' : String.valueOf(promocion.N_Via__c);
            direccion.postal_code = String.isBlank(promocion.Codigo_postal__c) ? '' : promocion.Codigo_postal__c;
            direccion.floor = '';
            direccion.floor_letter = '';
            direccion.lat = promocion.Coordenadas__Latitude__s == null ? '' : String.valueOf(promocion.Coordenadas__Latitude__s);
            direccion.lng = promocion.Coordenadas__Longitude__s == null ? '' : String.valueOf(promocion.Coordenadas__Longitude__s);

            envioPromocion.address = direccion;
        }

        return envioPromocion;
    }

    public static List<DummyViviendasEnvio> generarPeticionAltaModifVivienda(ID PromocionID) {
        List<DummyViviendasEnvio> envioViviendasTotal=new List<DummyViviendasEnvio>();
        DummyViviendasEnvio envioViviendas=null;
        DummyOrientacion orientacion=null;
        Set<Id> idVivienda=new Set<Id>();
        List<OpportunityLineItem> oportunityLine= new List<OpportunityLineItem>();
        List<Product2> inmueblesAsociados= new List<Product2> ();
        List<Product2> viviendas=[Select Id,id_ViviendaBaboonlab__c,Estado__c, Promocion__r.IdPromocionBabonlab__c,Orientacion_Viv__c,Tipologia_de_vivienda__c,Planta__c,Name,Portal__c,
                                  Precio__c,N_habitaciones__c,N_banos__c,Promocion__r.Coordenadas__Latitude__s,Promocion__r.Coordenadas__Longitude__s,
                                  Bloque__c,Superficie_Construida_total_con_ZZCC_m2__c,Fase_Venta__c,Letra_N_Puerta__c,Escalera__c,Superficie_Construida_m2__c,
                                  Superficie_Util_m2__c,Superficie_Util_Garaje_con_calles_m2__c,Promocion__r.Pistas_deportivas__c ,Promocion__r.Jardines__c,
                                  Promocion__r.Piscina_Exterior__c,Promocion__r.Ascensores__c, Promocion__r.Terrazas_Mirador__c, Promocion__r.Terrazas_Mirador_m2__c,
                                  Description,Promocion__r.Localidad__c, Promocion__r.Localidad__r.Codigo_municipio__c,Promocion__r.Provincia__c,
                                  Promocion__r.Localidad__r.Provincia__r.Codigo__c,Promocion__r.Comunidad_autonoma__c,Promocion__r.Localidad__r.Provincia__r.Comunidad_autonoma__r.Codigo__c,
                                  Promocion__r.Tipo_via__c,Promocion__r.Nombre_via__c,Promocion__r.N_Via__c,Promocion__r.Codigo_postal__c
                                  from Product2 where Tipologia_Vivienda_Garaje_Trastero_Local__c='Vivienda' and Promocion__c=:PromocionID];

        //Se recorren los Ids de las viviendas
        for(Product2 viv :viviendas)
        {
            idVivienda.add(viv.Id);
        }
        if(idVivienda.Size()>0)
        {
            oportunityLine=[Select Product2Id,Opportunity.Fecha_firma_Contrato_Reserva__c,Opportunity.Fecha_firma_Contrato_Compraventa__c from OpportunityLineItem where Opportunity.StageName<>'Cancelada'and Product2Id in: idVivienda];
        }
        Map<Id,List<OpportunityLineItem>> mapOpportunityLine= new Map<Id, List<OpportunityLineItem>>();

        for(OpportunityLineItem oppoLine:oportunityLine)
        {
            if(mapOpportunityLine.get(oppoLine.Product2Id)==null)
            {
                List<OpportunityLineItem> oppLine= new List<OpportunityLineItem>{oppoLine};
                mapOpportunityLine.put(oppoLine.Product2Id,oppLine);
            }
            else{
                mapOpportunityLine.get(oppoLine.Product2Id).add(oppoLine);
            } 
        }

        //Obtenemos los inmuebles asociados a cada vivienda
        if(idVivienda.Size()>0)
        {
            inmueblesAsociados=[Select Inmueble_asociado__c,Tipologia_Vivienda_Garaje_Trastero_Local__c from Product2 where Inmueble_asociado__c in: idVivienda];
        }
        Map<Id,List<Product2>> mapViviendasAsociadas= new Map<Id, List<Product2>>();
        for(Product2 vivAsociada:inmueblesAsociados)
        {
            if(mapViviendasAsociadas.get(vivAsociada.Inmueble_asociado__c)==null)
            {
                List<Product2> listViAsociada=new List<Product2>{vivAsociada};
                mapViviendasAsociadas.put(vivAsociada.Inmueble_asociado__c,listViAsociada);
            }
            else{
                mapViviendasAsociadas.get(vivAsociada.Inmueble_asociado__c).add(vivAsociada);
            } 
        }


        for(Product2 vivienda :viviendas)
        {
            envioViviendas=new DummyViviendasEnvio();
            orientacion= new DummyOrientacion();
            envioViviendas.id_external=vivienda.ID;
            envioViviendas.id=(vivienda.id_ViviendaBaboonlab__c==null ?null :Integer.valueof(vivienda.id_ViviendaBaboonlab__c));
            envioViviendas.promotion=(vivienda.Promocion__r.IdPromocionBabonlab__c==null? null: Integer.valueof(vivienda.Promocion__r.IdPromocionBabonlab__c));
            //Revisamos la orientacion de la vivienda
            if(vivienda.Orientacion_Viv__c!=null){
                switch on vivienda.Orientacion_Viv__c {
                    when 'Norte' {
                        orientacion.n=true;
                    }
                    when 'Noreste' {
                        orientacion.ne=true;
                    }
                    when 'Este' {
                        orientacion.e=true;
                    }
                    when 'Sureste' {
                        orientacion.se=true;
                    }
                    when 'Sur' {
                        orientacion.s=true;
                    }
                    when 'Suroeste' {
                        orientacion.sw=true;
                    }
                    when 'Oeste' {
                        orientacion.w=true;
                    }
                    when 'Noroeste' {
                        orientacion.nw=true;
                    }
                }
            }
            envioViviendas.orientation=orientacion;

            integer tipoVivienda = null;
            if(vivienda.Tipologia_de_vivienda__c!=null)
            {
                switch on vivienda.Tipologia_de_vivienda__c{
                    when 'Piso' {
                        tipoVivienda=1;
                    }
                    when 'Ático' {
                        tipoVivienda=6;
                    }
                }
            }
            envioViviendas.type=tipoVivienda;
            envioViviendas.condition=1;//Siempre van a ser viviendas nuevas

            //Comprobamos la planta de la viviendas
            if(vivienda.Planta__c != null && String.isNotBlank(vivienda.Planta__c))
            {
                if(vivienda.Planta__c.equals('0'))
                {
                    envioViviendas.floor_type=2;
                }else if(vivienda.Planta__c.equals('1')){
                    envioViviendas.floor_type=4;
                }else if(vivienda.Tipologia_de_vivienda__c!=null && vivienda.Tipologia_de_vivienda__c.equals('Ático'))
                {
                    envioViviendas.floor_type=6;
                }
                else
                {
                    envioViviendas.floor_type=5;
                }
            }
            envioViviendas.name=vivienda.name;
            envioViviendas.price=vivienda.Precio__c;
            envioViviendas.area=vivienda.Superficie_Util_m2__c;
            envioViviendas.rooms=(vivienda.N_habitaciones__c==null?null:Integer.valueof(vivienda.N_habitaciones__c));
            envioViviendas.bathrooms=(vivienda.N_banos__c==null?null:Integer.valueof(vivienda.N_banos__c));
            envioViviendas.level=(vivienda.Planta__c==null? null:Integer.valueof(vivienda.Planta__c));
            envioViviendas.home_lat=(vivienda.Promocion__r.Coordenadas__Latitude__s==null? '' :string.valueof(vivienda.Promocion__r.Coordenadas__Latitude__s));
            envioViviendas.home_lng=(vivienda.Promocion__r.Coordenadas__Longitude__s==null? '' :string.valueof(vivienda.Promocion__r.Coordenadas__Longitude__s));
            envioViviendas.date_reservation=(mapOpportunityLine!=null && mapOpportunityLine.get(vivienda.id)!=null && mapOpportunityLine.get(vivienda.id).size()>0 && mapOpportunityLine.get(vivienda.id).get(0).Opportunity.Fecha_firma_Contrato_Reserva__c!=null ? mapOpportunityLine.get(vivienda.id).get(0).Opportunity.Fecha_firma_Contrato_Reserva__c: null);
            envioViviendas.date_sold=(mapOpportunityLine!=null &&  mapOpportunityLine.get(vivienda.id)!=null &&mapOpportunityLine.get(vivienda.id).size()>0 && mapOpportunityLine.get(vivienda.id).get(0).Opportunity.Fecha_firma_Contrato_Compraventa__c!=null ? mapOpportunityLine.get(vivienda.id).get(0).Opportunity.Fecha_firma_Contrato_Compraventa__c: null);
            envioViviendas.block=vivienda.Bloque__c;
            if(vivienda.Tipologia_de_vivienda__c!=null && vivienda.Tipologia_de_vivienda__c!=''&& vivienda.Tipologia_de_vivienda__c.equals('Ático'))
            {
                envioViviendas.penthouse=(1);
                envioViviendas.penthouse_area=vivienda.Superficie_Construida_total_con_ZZCC_m2__c;

            }else{
                envioViviendas.penthouse=(0);
                envioViviendas.penthouse_area=null; 
            }
            envioViviendas.phase=(vivienda.Fase_Venta__c==null?null:String.valueof(vivienda.Fase_Venta__c));
            envioViviendas.letter=vivienda.Letra_N_Puerta__c;
            envioViviendas.stairs=vivienda.Escalera__c;
            envioViviendas.built_area=vivienda.Superficie_Construida_m2__c;
            envioViviendas.useful_area=vivienda.Superficie_Util_m2__c;
            integer contGaraje=0;
            integer contTrastero=0;
            if(mapViviendasAsociadas!=null && mapViviendasAsociadas.get(vivienda.Id)!=null &&mapViviendasAsociadas.get(vivienda.Id).size()>0)
            {
                for(Product2 product: mapViviendasAsociadas.get(vivienda.Id))
                {
                    if(product.Tipologia_Vivienda_Garaje_Trastero_Local__c!=null && product.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Trastero'))
                    {
                        contTrastero++;
                    }
                    else if (product.Tipologia_Vivienda_Garaje_Trastero_Local__c!=null && product.Tipologia_Vivienda_Garaje_Trastero_Local__c.equals('Garaje'))
                    {
                        contGaraje++;
                    }
                }
            }
            envioViviendas.garages=contGaraje;
            envioViviendas.storerooms=contTrastero;
            envioViviendas.terrace=vivienda.Promocion__r.Terrazas_Mirador__c;
            envioViviendas.terrace_area=vivienda.Promocion__r.Terrazas_Mirador_m2__c; 
            envioViviendas.levels=(vivienda.Planta__c==null?null :Integer.valueof(vivienda.Planta__c));
            if(vivienda.Estado__c!=null && String.isNotBlank(vivienda.Estado__c) && vivienda.Estado__c.equals('Libre'))
            {
                envioViviendas.availability=1;
            }else
            {
                envioViviendas.availability=0;
            }
            envioViviendas.description=vivienda.Description;

            DummyPromocionesAdress direccion = new DummyPromocionesAdress();
            direccion.province_ine_ref_code=(vivienda.Promocion__r.Provincia__c==null? 0: Integer.valueof(vivienda.Promocion__r.Localidad__r.Provincia__r.Codigo__c));
            direccion.state_ine_ref_code=(vivienda.Promocion__r.Comunidad_autonoma__c==null ?0:Integer.valueof(vivienda.Promocion__r.Localidad__r.Provincia__r.Comunidad_autonoma__r.Codigo__c));
            direccion.municipality_ine_ref_code=(vivienda.Promocion__r.Localidad__c==null ? 0: Integer.valueof(vivienda.Promocion__r.Localidad__r.Codigo_municipio__c));
            direccion.street=((vivienda.Promocion__r.Tipo_via__c==null ?'' :vivienda.Promocion__r.Tipo_via__c)+ ' ' + (vivienda.Promocion__r.Nombre_via__c==null ?'' :vivienda.Promocion__r.Nombre_via__c));
            direccion.address_number=(vivienda.Promocion__r.N_Via__c==null ?'' :string.valueof(vivienda.Promocion__r.N_Via__c));
            direccion.postal_code=(vivienda.Promocion__r.Codigo_postal__c==null ?'' :vivienda.Promocion__r.Codigo_postal__c);
            direccion.floor=(vivienda.Planta__c);
            direccion.floor_letter=(vivienda.Letra_N_Puerta__c);
            direccion.lat=(vivienda.Promocion__r.Coordenadas__Latitude__s==null? '' :string.valueof(vivienda.Promocion__r.Coordenadas__Latitude__s));
            direccion.lng=(vivienda.Promocion__r.Coordenadas__Longitude__s==null? '' :string.valueof(vivienda.Promocion__r.Coordenadas__Longitude__s));
            envioViviendas.address=direccion;
            envioViviendas.elevator=vivienda.Promocion__r.Ascensores__c;
            envioViviendas.exterior=false; 
            envioViviendas.swimmingpool=vivienda.Promocion__r.Piscina_Exterior__c;
            envioViviendas.built_in_wardrobes=false;
            envioViviendas.air_conditioning=false;
            envioViviendas.garden=vivienda.Promocion__r.Jardines__c;
            envioViviendas.sports=vivienda.Promocion__r.Pistas_deportivas__c;
            envioViviendas.accessible=false; 
            envioViviendas.security_surveillance=false;
            envioViviendas.corner=false;
            envioViviendas.allow_adults=true;
            envioViviendas.allow_kids=true;
            envioViviendas.allow_babies=true;
            envioViviendas.allow_big_pets=true;
            envioViviendas.allow_small_pets=true;
            envioViviendas.transaction_type=1;

            envioViviendasTotal.add(envioViviendas);
 
        }
   
        return envioViviendasTotal;
    }

    public static void insertarLog( String nombreMetodo, String idCuenta, String mensajeEnviado, String resultado, String aplicacion)
    {
        Log__c log =new Log__c();
        log.Aplicacion__c=aplicacion;
        log.name=nombreMetodo;
      	log.Identificador__c=idCuenta;
        log.MensajeEnviado__c=mensajeEnviado;
        log.MensajeRecibido__c= resultado;

        insert log;
    }
    
    
    // dummy para enviar las promociones
    public class DummyPromocionesEnvio{
       
        public String url360;
        public String name;
        public Boolean enabled;
        public String description;
        public Integer order;
        public String video;
        public boolean is_featured;
        public String construction;
        public integer category;
        public DummyPromocionesAdress address;        
    }
    //dummy adress de promociones
    public class DummyPromocionesAdress{
        public Integer country;
        public Integer province;
        public Integer state;
        public Integer municipality;
        public Integer province_ine_ref_code;
        public Integer state_ine_ref_code;
        public Integer municipality_ine_ref_code;
        public String street;
        public String address_number;
        public String postal_code;
        public String floor;
        public String floor_letter;
        public String lat;
        public String lng;
    }
    // dummy para procesar las respuestas de las promociones
    public class DummyPromocionesRespuesta{
        public Integer id;
        public Integer municipality;
        public Integer province;
        public Integer state;
        public Integer country;
        public String slug;
        public String url360;
        public String name;
        public Boolean enabled;
        public String description;
        public Integer order;
        public String video;
        public boolean is_featured;
        public String construction;
        public String category;

       
       // public DateTime created_at;
        //public DateTime updated_at;
    }
    //Dummy para enviar las viviendas
    public class DummyViviendasEnvio{
        public integer id;
        public integer promotion;
        public String id_external;
        public DummyOrientacion orientation;
        public integer type;
        public integer condition;
        public integer floor_type;
        public string name;
        public Decimal price;
        public Decimal area;
        public integer rooms;
        public integer bathrooms;
        public integer level; 
        public String doorway;
        public integer zoom;
        public String home_lat;
        public String home_lng;
        public DateTime date_reservation;
        public DateTime date_sold;
        public String block;
        public integer penthouse;
        public Decimal penthouse_area;
        public String phase;
        public String letter;
        public String stairs;
        public Decimal built_area;
        public Decimal useful_area;
        public Decimal common_area;
        public integer garages;
        public integer storerooms;
        public Boolean terrace;
        public Decimal terrace_area;
        public Boolean enabled;
        public Boolean in_dekrs;
        public integer levels; 
        public integer availability;
        public String description;
        public DummyPromocionesAdress address;  
        public Boolean elevator;
        public Boolean exterior;
        public Boolean swimmingpool;
        public Boolean built_in_wardrobes;
        public Boolean air_conditioning;
        public Boolean garden;
        public Boolean sports;
        public Boolean accessible;
        public Boolean security_surveillance;
        public Boolean corner;
        public Boolean allow_adults;
        public Boolean allow_kids;
        public Boolean allow_babies;
        public Boolean allow_big_pets;
        public Boolean allow_small_pets;
        public Integer transaction_type;
        public Boolean is_featured;
    }    

    public class DummyOrientacion{
        public Boolean n =false;
        public Boolean ne =false;
        public Boolean e=false;
        public Boolean se=false;
        public Boolean s=false;
        public Boolean sw=false;
        public Boolean w=false;
        public Boolean nw=false;
    } 
    public class DummyRespuestaViviendas{
        public integer id;
        public string id_external;
    }




}