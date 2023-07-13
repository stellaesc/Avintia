public class Tarifario_Aprobado_AvisoPubl {
        
    @AuraEnabled
    public static Boolean searchTask(Id idTask){
        System.debug('HOLA');
		Task tsk = [SELECT Id, IsRecordatorioActivo__c FROM Task WHERE Id = :idTask];
        if(tsk.IsRecordatorioActivo__c){
            System.debug('TRUE'); return true;
        } 
        else{
          return false;  
        } 
    }
    
    @AuraEnabled
    public static void pendiente(Id idTask){
        Task tsk = [SELECT Id, IsRecordatorioActivo__c, NumRecordatorio__c, NextRecordatorio__c FROM Task WHERE Id = :idTask];
        tsk.IsRecordatorioActivo__c = true;
        tsk.NumRecordatorio__c = 1;
        tsk.NextRecordatorio__c = Date.today().addDays(2);
        update tsk;
    }
    
    @AuraEnabled
    public static string publicarWebAvintia(Id idTask, Boolean esPrueba) {
        System.debug('Entra a publicar');
        
        PropiedadesIntegracion__c propiedadesIntegracion = PropiedadesIntegracion__c.getInstance();
        String mensajeEnviar = '';
        string resultado = 'OK';
        System.debug(idTask + ' : ' + esPrueba);
        
        Task tsk = [SELECT Id, IsRecordatorioActivo__c, NumRecordatorio__c, NextRecordatorio__c, Promocion__c
                    FROM Task WHERE Id = :idTask];

        //Generamos el XML y lo enviamos al entorno.
        try {
            // Se llama al metodo de generacion del XML
            String endpointUrl = esPrueba ? propiedadesIntegracion.URL_WEBAVINTIA__c : propiedadesIntegracion.URL_WEBAVINTIA_PRO__c;
            mensajeEnviar = generarXmlPublicacion(tsk.Promocion__c, esPrueba);
            System.debug('mensajeEnviar: ' + mensajeEnviar);

            System.debug('Realizamos el envio al WS');
            System.debug (esPrueba);
    
            // Send the request
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(endpointUrl);
            req.setHeader('Content-Type','application/xml');
            req.setHeader('Authorization', propiedadesIntegracion.PasswordWSAvintia__c);
            req.setBody(mensajeEnviar);
            req.setTimeout(120000);
            Http http = new Http();

            HttpResponse res;
            if(!System.Test.isRunningTest()) { // FIXME -> HAY QUE HACER EN LAS PRUEBAS UN MOCK UP PARA HACER LAS PRUEBAS CORRECTAMENTE
                res = http.send(req);
                //System.debug('Respuesta del sistema: ' + res.getStatusCode()+ ' ' + res.getStatus()+ +res.getBody());
            }

            if (res != null && res.getStatusCode() == 200) {
			    String respuesta = res.getBody();
                if(respuesta != null && (respuesta.contains('Nodo modificado') || respuesta.contains('Nodo insertado'))) {
                    insertarLog('publicarWebAvintia',tsk.Promocion__c,mensajeEnviar,respuesta,'PORTAL WEB AVINTIA');
                    // Marcamos como publicada la prueba
                    Promocion__c promocion = new Promocion__c();
                    promocion.ID = tsk.Promocion__c;
                    promocion.PruebaPublicada__c = true;
                    if(respuesta.split(' ').size() >= 4){
                        system.debug('respuesta:::'+respuesta);
                        system.debug('respuesta.split( ):::'+respuesta.split('[^a-zA-Z0-9]')[4].trim());
                        promocion.Nodo_Web_Avintia__c = respuesta.split('[^a-zA-Z0-9]')[4].trim();
                    }
                    
                    update promocion;
                } else {
                    resultado='KO';
                    insertarLog('publicarWebAvintia', tsk.Promocion__c, mensajeEnviar, res.getBody(), 'PORTAL WEB AVINTIA');
                }
            } else {
                resultado='KO';
                insertarLog('publicarWebAvintia',tsk.Promocion__c ,mensajeEnviar, res != null ? res.toString() : null, 'PORTAL WEB AVINTIA');
            }

        } catch(Exception e){
            System.debug('Error al realizar el envio: '+ e + '\n\r' + e.getStackTraceString());
            resultado='KO';
            /*insertarLog('publicarWebAvintia', tsk.Promocion__c, mensajeEnviar, e.getMessage(), 'PORTAL WEB AVINTIA');
            throw new GenerarXMLException(e.getMessage());*/
        }
        
        return resultado;
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
    
        //Metodo encargado de generar el XML de la promocion de la Web de Avintia
    public static string generarXmlPublicacion(Id PromoId, Boolean esPrueba) {
        System.debug('Metodo de publicación en la Web de Avintia');
        PropiedadesIntegracion__c propiedadesIntegracion = PropiedadesIntegracion__c.getInstance();
        String mensajeEnviar = '';
        string resultado = 'OK';

        System.debug('Procedemos a generar el XML de envío');
        System.debug(esPrueba);
        string mensaje = '';
        try {
            DOM.Document doc = new DOM.Document();
            Set<id> setContentDocument = new Set<id>();
            Set<id> setContentDocumentTipologia = new Set<id>();
            Set<id> setTipologias = new Set<id>();
            List<ContentVersion> contentVersion = null;
            List<ContentDocumentLink> linkTipologia = null;
            List<ContentVersion> contentVersionTipologia = null;
            
            List<Promocion__c> promociones = [SELECT Id, Name, Nombre_promocion__c, Nombre_Comercial_Avintia_Inmobiliaria__c, Provincia__c, 
                                              Localidad__r.Name, Descricion_pequena__c, Slogan__c, Descripcion__c, Tipo_via__c, Nombre_via__c, 
                                              N_Via__c,Codigo_postal__c,Telefono_promocion_comercializadora__c,Email_promocion_comercializadora__c,
                                              Superficie_total_de_parcela__c, N_Plantas__c, N_Viviendas_totales_promocion__c,
                                              Piscina_Exterior__c,Zona_Infantil__c,Spa__c,Pistas_deportivas__c,Padel__c,Jardines__c,Gimnasio__c,
                                              Terrazas_Mirador__c,Zona_Gourmet__c,Ascensores__c,Sala_Multidisciplinar__c,Coordenadas__Latitude__s,
                                              Coordenadas__Longitude__s,Restaurantes__c,Mercados__c,Parques__c,Playas__c,Localizacion_Google__c,
                                              Agrupador_de_viviendas__c, Slogan_Final_Web__c, Descripcion_final_Web__c, Texto_financiacion__c, 
                                              Solarium__c,Plaza_de_Garaje_Parking__c,Trastero__c, Chill_Out__c, Domotica__c, Suelo_Radiante__c,
                                              Aerotermia__c, Vestuarios_comunitarios__c, Sauna__c, Piscina_Infantil__c, Ski_Room__c,
                                              Calificacion_Energetica_A__c, Calificacion_Energetica_B__c, Cargador_Coches_Electricos__c, 
                                              Buhardilla__c, Hammam__c, Hospitales__c, Colegios__c, Guarderias__c, Deportivas__c, Farmacias__c,
                                              Centros_Comerciales__c, Golf__c, Puerto__c, Metros__c, Autobuses__c, Tren__c, Aeropuertos__c, 
                                              Estacion_Esqui__c, Gasolineras__c, Universidades__c 
                                              FROM Promocion__c 
                                              WHERE WebAvinita__c = true AND Id = :PromoId];
            
            List<Product2> viviendas = [SELECT Id, Name, Precio__c, Estado__c, Tipologia_Vivienda_Garaje_Trastero_Local__c, Tipo_de_inmueble__c,
                                        N_habitaciones__c, N_banos__c, Superficie_Construida_m2__c, Superficie_Terrazas_Descubiertas__c,
                                        Superficie_Util_Garaje_con_calles_m2__c, Superficie_Terrazas_Cubiertas__c, Superficie_Jardines__c, 
                                        Superficie_Construida_total_con_ZZCC_m2__c, Piso__c,WebAvinita__c, Tipologia_de_vivienda__c 
                                        FROM Product2 
                                        WHERE Promocion__c = :PromoId AND (WebAvinita__c = true AND Idealista__c = true AND Fotocasa__c = true) AND Inmueble_asociado__c = null];

            for(Product2 vivTipologia : viviendas){
                setTipologias.add(vivTipologia.id);
                setTipologias.add(vivTipologia.Tipo_de_inmueble__c);
            }

            // Anejos
            Map<Id, List<Product2>> productsAnnexesMap = new Map<Id, List<Product2>>();
            List<Product2> annexes = [SELECT Id, Precio__c, Inmueble_asociado__c, Tipologia_Vivienda_Garaje_Trastero_Local__c 
                                      FROM Product2 
                                      WHERE Promocion__c = :PromoId AND Inmueble_asociado__c != null];
            for(Product2 annexe : annexes) {
                List<Product2> currAnnexesList = productsAnnexesMap.get(annexe.Inmueble_asociado__c);
                if(currAnnexesList == null) currAnnexesList = new List<Product2>();
                currAnnexesList.add(annexe);
                productsAnnexesMap.put(annexe.Inmueble_asociado__c, currAnnexesList);
            }

            //Obtener la id de los archivos (Imagenes) que están relacionados con las promociones
            List<ContentDocumentLink> linkPromocion = [SELECT Id, ContentDocumentId, LinkedEntityId  
                                                       FROM ContentDocumentLink
                                                       WHERE LinkedEntityId = :PromoId];
            for(ContentDocumentLink cdl : linkPromocion){ 
                setContentDocument.add(cdl.contentDocumentId);
            }
            //Obtener los archivos (Imagenes) de ContentVersion de las promociones
            if(!setContentDocument.isEmpty()) {
                contentVersion = ([SELECT Id, Title, Description, Posicion__c, ContentDocumentId, URL__c, Tipo__c, Url_Youtube__c, FileType 
                                FROM ContentVersion
                                WHERE ContentDocumentId IN :setContentDocument and IsLatest = true 
                                ORDER BY Posicion__c ASC]);
            }
        
            //Obtener la id de los archivos (Imagenes) que están relacionados con las tipologias
            if(!setTipologias.isEmpty()) {
                linkTipologia = [SELECT Id, ContentDocumentId, LinkedEntityId 
                                 FROM ContentDocumentLink 
                                 WHERE LinkedEntityId IN :setTipologias];
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
            }

            //Recorremos las promociones que vamos a enviar a la Web de Avintia
            if(promociones != null) { 
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

                    Dom.XmlNode promocionesAvintia= doc.createRootElement('promociones',null, null);
                    Dom.XmlNode promo= promocionesAvintia.addChildElement('promocion', null, null);
                    promo.addChildElement('id', null, null).
                        addTextNode(promocion.Id); 
                    promo.addChildElement('nombre_promocion', null, null).
                        addTextNode(String.isBlank(promocion.Nombre_Comercial_Avintia_Inmobiliaria__c) ? '' : promocion.Nombre_Comercial_Avintia_Inmobiliaria__c);
                    promo.addChildElement('localidad_provincia', null, null).
                        addTextNode((promocion.Localidad__r.Name == null ? '' : promocion.Localidad__r.Name)+' '+(promocion.Provincia__c == null ? '' : promocion.Provincia__c));
                    promo.addChildElement('resumen', null, null).
                        addTextNode(promocion.Descricion_pequena__c == null ? '' : promocion.Descricion_pequena__c);
                    promo.addChildElement('direccion', null, null).
                        addTextNode((promocion.Tipo_via__c==null ? '' : promocion.Tipo_via__c)+ ' ' + 
                            (promocion.Nombre_via__c == null ? '' : promocion.Nombre_via__c)+ ' ' + 
                            (promocion.N_Via__c == null ? '' : String.valueOf(promocion.N_Via__c))+ ' '+ 
                            (promocion.Localidad__r.Name == null ? '' : promocion.Localidad__r.Name)+' '+
                            (promocion.Provincia__c == null ? '' : promocion.Provincia__c)+ ' ' +
                            (promocion.Codigo_postal__c == null ? '' : promocion.Codigo_postal__c));

                    //Cálculamos el precio minimo de las viviendas de la promocion y las habitaciones que hay minimas y maximas                    
                    for(Product2 vivienda : viviendas) {                        
                        // Calculamos precio de la vivienda con el precio de sus anejos incluidos
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

                    promo.addChildElement('precio_desde', null, null).addTextNode(precio == null ? '' : precio.format());
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
                    if(contentVersion != null) {
                        for(ContentVersion conVer: contentVersion) {
                            if(conVer.Tipo__c == 'Imagen_carrusel' || conVer.Tipo__c == 'Video_Youtube') {
                                Dom.XmlNode imagen = imagenes.addChildElement('imagen', null, null);
                                String altImg = conVer.Tipo__c == 'Video_Youtube' ? conVer.Url_Youtube__c : conVer.Title;
                                if(conVer.Tipo__c == 'Video_Youtube') {
                                    imagen.addChildElement('title', null, null).addTextNode(conVer.Url_Youtube__c);
                                    imagen.addChildElement('alt_imagen', null, null).addTextNode(altImg);
                                }
                                imagen.addChildElement('url_imagen', null, null).addTextNode(devolverURLDocumento(conVer.URL__c, conVer.Id, conVer.FileType));                                
                            } else if(conVer.Tipo__c == 'Video') {
                                Dom.XmlNode imagen = imagenes.addChildElement('imagen', null, null);
                                imagen.addChildElement('url_imagen', null, null).addTextNode(devolverURLDocumento(conVer.URL__c, conVer.Id, conVer.FileType));
                                imagen.addChildElement('alt_imagen', null, null).addTextNode(conVer.Title);
                            } else if(conVer.Tipo__c == 'Imagen_financiera') {
                                financiada.addChildElement('icono', null, null).addTextNode(devolverURLDocumento(conVer.URL__c, conVer.Id, conVer.FileType));
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
                    promo.addChildElement('email_destino_formulario', null, null).
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
                    promo.addChildElement('definicion_promocion', null, null).addTextNode(descripcion);

                    Dom.XmlNode caracteristicas = promo.addChildElement('caracteristicas', null, null);
                    caracteristicas.addChildElement('superficie', null, null).
                        addTextNode('De ' + superficieConstruidaMinima + ' a ' + superficieConstruidaMaxima);

                    //Comprobamos los valores da las habitaciones
                    if(nMinHabitaciones != 0 && nMinHabitaciones == nMaxHabitaciones){
                        caracteristicas.addChildElement('habitaciones', null, null).addTextNode(nMinHabitaciones + ' habitaciones');
                    } else if(nMinHabitaciones != 0 && nMinHabitaciones != nMaxHabitaciones) {
                        caracteristicas.addChildElement('habitaciones', null, null).addTextNode('De ' + nMinHabitaciones + ' a ' + nMaxHabitaciones + ' habitaciones');
                    } else caracteristicas.addChildElement('habitaciones', null, null).addTextNode('');
            
                    caracteristicas.addChildElement('planta', null, null).
                        addTextNode(promocion.N_Plantas__c == null ? '' : String.valueOf(promocion.N_Plantas__c));
                    caracteristicas.addChildElement('total_viviendas', null, null).
                        addTextNode(promocion.N_Viviendas_totales_promocion__c == null ? '' : String.valueOf(promocion.N_Viviendas_totales_promocion__c));

                    Dom.XmlNode servicios = promo.addChildElement('servicios', null, null);
                    servicios.addChildElement('Solarium', null, null).addTextNode(String.valueOf(promocion.Solarium__c).toUpperCase());
                    //servicios.addChildElement('Parques', null, null).addTextNode('FALSE');
                    servicios.addChildElement('Piscina', null, null).addTextNode(String.valueOf(promocion.Piscina_Exterior__c).toUpperCase());
                    servicios.addChildElement('PiscinaInfantil', null, null).addTextNode(String.valueOf(promocion.Piscina_Infantil__c).toUpperCase());
                    servicios.addChildElement('ZonaInfantil', null, null).addTextNode(String.valueOf(promocion.Zona_Infantil__c).toUpperCase());
                    servicios.addChildElement('Spa', null, null).addTextNode(String.valueOf(promocion.Spa__c).toUpperCase());
                    servicios.addChildElement('Tenis', null, null).addTextNode(String.valueOf(promocion.Pistas_deportivas__c).toUpperCase());
                    servicios.addChildElement('Padel', null, null).addTextNode(String.valueOf(promocion.Padel__c).toUpperCase());
                    servicios.addChildElement('Jardin', null, null).addTextNode(String.valueOf(promocion.Jardines__c).toUpperCase());
                    servicios.addChildElement('Gimnasio', null, null).addTextNode(String.valueOf(promocion.Gimnasio__c).toUpperCase());
                    servicios.addChildElement('Terraza', null, null).addTextNode(String.valueOf(promocion.Terrazas_Mirador__c).toUpperCase());
                    servicios.addChildElement('ZonaGourmet', null, null).addTextNode(String.valueOf(promocion.Zona_Gourmet__c).toUpperCase());
                    servicios.addChildElement('Ascensores', null, null).addTextNode(String.valueOf(promocion.Ascensores__c).toUpperCase());
                    servicios.addChildElement('Salon_social', null, null).addTextNode(String.valueOf(promocion.Sala_Multidisciplinar__c).toUpperCase());
                    servicios.addChildElement('Parking', null, null).addTextNode(String.valueOf(promocion.Plaza_de_Garaje_Parking__c).toUpperCase());
                    servicios.addChildElement('Trastero', null, null).addTextNode(String.valueOf(promocion.Trastero__c).toUpperCase());
                    servicios.addChildElement('Chillout', null, null).addTextNode(String.valueOf(promocion.Chill_Out__c).toUpperCase());
                    servicios.addChildElement('SueloRadiante', null, null).addTextNode(String.valueOf(promocion.Suelo_Radiante__c).toUpperCase());
                    servicios.addChildElement('Aerotermia', null, null).addTextNode(String.valueOf(promocion.Aerotermia__c).toUpperCase());
                    servicios.addChildElement('Vestuarios', null, null).addTextNode(String.valueOf(promocion.Vestuarios_comunitarios__c).toUpperCase());
                    servicios.addChildElement('Sauna', null, null).addTextNode(String.valueOf(promocion.Sauna__c).toUpperCase());
                    servicios.addChildElement('Domotica', null, null).addTextNode(String.valueOf(promocion.Domotica__c).toUpperCase());
                    servicios.addChildElement('SkiRoom', null, null).addTextNode(String.valueOf(promocion.Ski_Room__c).toUpperCase());
                    servicios.addChildElement('EnergeticaA', null, null).addTextNode(String.valueOf(promocion.Calificacion_Energetica_A__c).toUpperCase());
                    servicios.addChildElement('EnergeticaB', null, null).addTextNode(String.valueOf(promocion.Calificacion_Energetica_B__c).toUpperCase());
                    servicios.addChildElement('RecargaCoche', null, null).addTextNode(String.valueOf(promocion.Cargador_Coches_Electricos__c).toUpperCase());
                    servicios.addChildElement('Buhardilla', null, null).addTextNode(String.valueOf(promocion.Buhardilla__c).toUpperCase());
                    servicios.addChildElement('Hammam', null, null).addTextNode(String.valueOf(promocion.Hammam__c).toUpperCase());

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
                    mapas.addChildElement('Hospital', null, null).addTextNode(promocion.Hospitales__c==null ?'' :promocion.Hospitales__c);
                    mapas.addChildElement('Colegios', null, null).addTextNode(promocion.Colegios__c==null ?'' :promocion.Colegios__c);
                    mapas.addChildElement('Guarderias', null, null).addTextNode(promocion.Guarderias__c==null ?'' :promocion.Guarderias__c);
                    mapas.addChildElement('Deportivas', null, null).addTextNode(promocion.Deportivas__c==null ?'' :promocion.Deportivas__c);
                    mapas.addChildElement('Farmacias', null, null).addTextNode(promocion.Farmacias__c==null ?'' :promocion.Farmacias__c);
                    mapas.addChildElement('CentroComercial', null, null).addTextNode(promocion.Centros_Comerciales__c==null ?'' :promocion.Centros_Comerciales__c);
                    mapas.addChildElement('Golf', null, null).addTextNode(promocion.Golf__c==null ?'' :promocion.Golf__c);
                    mapas.addChildElement('Puerto', null, null).addTextNode(promocion.Puerto__c==null ?'' :promocion.Puerto__c);
                    mapas.addChildElement('Metro', null, null).addTextNode(promocion.Metros__c==null ?'' :promocion.Metros__c);
                    mapas.addChildElement('Autobuses', null, null).addTextNode(promocion.Autobuses__c==null ?'' :promocion.Autobuses__c);
                    mapas.addChildElement('Tren', null, null).addTextNode(promocion.Tren__c==null ?'' :promocion.Tren__c);
                    mapas.addChildElement('Aeropuerto', null, null).addTextNode(promocion.Aeropuertos__c==null ?'' :promocion.Aeropuertos__c);
                    mapas.addChildElement('Esqui', null, null).addTextNode(promocion.Estacion_Esqui__c==null ?'' :promocion.Estacion_Esqui__c);
                    mapas.addChildElement('Gasolinera', null, null).addTextNode(promocion.Gasolineras__c==null ?'' :promocion.Gasolineras__c);
                    mapas.addChildElement('Universidad', null, null).addTextNode(promocion.Universidades__c==null ?'' :promocion.Universidades__c); 

                    Dom.XmlNode carruselLifestyle= promo.addChildElement('lifestyle', null, null);
                    Dom.XmlNode carruselEntono= promo.addChildElement('carrusel_entorno', null, null);

                    //Recorremos las imagenes de tipo carrusel lifestyle
                    if(contentVersion != null) {
                        for(ContentVersion conVer : contentVersion) {
                            if(conVer.Tipo__c == 'Carrusel_lifestyle') {
                                if(conVer.Posicion__c != null && String.valueOf(conVer.Posicion__c).equals('1')) {
                                    Dom.XmlNode bloque1 = carruselLifestyle.addChildElement('bloque1', null, null);
                                    bloque1.addChildElement('imagen', null, null).addTextNode(devolverURLDocumento(conVer.URL__c, conVer.Id, conVer.FileType));
                                    bloque1.addChildElement('titulo', null, null).addTextNode(conVer.Title == null ? '' : conVer.Title);
                                    bloque1.addChildElement('cuerpo', null, null).addTextNode(conVer.Description == null ? '' : conVer.Description);
                                } else if(conVer.Posicion__c != null && String.valueOf(conVer.Posicion__c).equals('2')) {
                                    Dom.XmlNode bloque2 = carruselLifestyle.addChildElement('bloque2', null, null);
                                    bloque2.addChildElement('imagen', null, null).addTextNode(devolverURLDocumento(conVer.URL__c, conVer.Id, conVer.FileType));
                                    bloque2.addChildElement('titulo', null, null).addTextNode(conVer.Title == null ? '' : conVer.Title);
                                    bloque2.addChildElement('cuerpo', null, null).addTextNode(conVer.Description == null ? '' : conVer.Description);
                                } else if (conVer.Posicion__c != null && String.valueOf(conVer.Posicion__c).equals('3')) {
                                    Dom.XmlNode bloque3 = carruselLifestyle.addChildElement('bloque3', null, null);
                                    bloque3.addChildElement('imagen', null, null).addTextNode(devolverURLDocumento(conVer.URL__c, conVer.Id, conVer.FileType));
                                    bloque3.addChildElement('titulo', null, null).addTextNode(conVer.Title == null ? '' : conVer.Title);
                                    bloque3.addChildElement('cuerpo', null, null).addTextNode(conVer.Description == null ? '' : conVer.Description);
                                }
                            } else if(conVer.Tipo__c == 'Carrusel_entorno') {
                                Dom.XmlNode item = carruselEntono.addChildElement('item', null, null);
                                item.addChildElement('imagen', null, null).addTextNode(devolverURLDocumento(conVer.URL__c, conVer.Id, conVer.FileType));
                                item.addChildElement('descripcion', null, null).addTextNode(conVer.Description == null ? '' : conVer.Description);
                            } else if (conVer.Tipo__c == 'Pie_de_web') {
                                promo.addChildElement('url_imagen_fondo_bloque_final', null, null).addTextNode(devolverURLDocumento(conVer.URL__c,conVer.Id,conVer.FileType));
                            }
                        }
                    }
                    promo.addChildElement('agrupadorTipologias', null, null).
                        addTextNode(promocion.Agrupador_de_viviendas__c == null ? '' : promocion.Agrupador_de_viviendas__c.toLowerCase());

                    Dom.XmlNode viviendasNodo = promo.addChildElement('viviendas', null, null);

                    for(Product2 vivienda : viviendas) {
                        if(vivienda.Estado__c != 'Libre' && vivienda.WebAvinita__c) throw new GenerarXMLException('El inmueble ' + vivienda.Name + ' no está libre. No se puede realizar la publicación en la web de Avintia.');
                        if(vivienda.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Vivienda' && vivienda.WebAvinita__c) {
                            List<Product2> currProductAnnexes = productsAnnexesMap.get(vivienda.Id);
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
                                addTextNode(vivienda.Superficie_Construida_total_con_ZZCC_m2__c == null ? '' : vivienda.Superficie_Construida_total_con_ZZCC_m2__c.format());
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
                                            }else if(cvPlanoPDF==null&&cvPlano==null&&contVers.Tipo__c=='Plano_PDF'&&link.ContentDocumentId.equals(contVers.ContentDocumentId)&&contVers.URL__c!=null && String.isNotBlank(contVers.URL__c) && contVers.Id!=null && String.isNotBlank(contVers.Id)) {
                                                cvPlano = contVers;
                                            }
                                        }
                                    }  
                                }
                                if(cvPlanoPDF != null) {                                                
                                    viviendaNodo.addChildElement('url_plano', null, null).addTextNode(devolverURLDocumento(cvPlanoPDF.URL__c,cvPlanoPDF.Id,cvPlanoPDF.FileType));
                                } else if(cvPlano != null) {
                                    viviendaNodo.addChildElement('url_plano', null, null).addTextNode(devolverURLDocumento(cvPlano.URL__c,cvPlano.Id,cvPlano.FileType));
                                }
                            } else viviendaNodo.addChildElement('url_plano', null, null).addTextNode('');
                        }
                    }             
                    promo.addChildElement('url_imagen_fondo_descargas', null, null).addTextNode('');

                    //Mostramos las URL de los folletos
                    if(!listaFolletos.isEmpty()) {
                        promo.addChildElement('url_folleto', null, null).addTextNode(devolverURLDocumento(listaFolletos.get(0).URL__c,listaFolletos.get(0).Id,listaFolletos.get(0).FileType));
                    } else {
                        promo.addChildElement('url_folleto', null, null).addTextNode('');
                    }

                    //Mostramos las URL de los Memoria de Calidades
                    if(!listaMemoriaCalidades.isEmpty()) {
                        promo.addChildElement('url_memoria_calidades', null, null).addTextNode(devolverURLDocumento(listaMemoriaCalidades.get(0).URL__c,listaMemoriaCalidades.get(0).Id,listaMemoriaCalidades.get(0).FileType));
                    } else {
                        promo.addChildElement('url_memoria_calidades', null, null).addTextNode('');
                    }

                    //Mostramos las URL de los Planos de las Zonas Comunes
                    if(!listaZonasComunes.isEmpty()) {
                        promo.addChildElement('url_planos_zonas_comunes', null, null).addTextNode(devolverURLDocumento(listaZonasComunes.get(0).URL__c,listaZonasComunes.get(0).Id,listaZonasComunes.get(0).FileType));
                    } else {
                        promo.addChildElement('url_planos_zonas_comunes', null, null).addTextNode('');
                    }
                    
                    promo.addChildElement('lifestyle_url_imagen1', null, null).addTextNode('');
                    promo.addChildElement('lifestyle_texto_1', null, null).addTextNode('');
                    promo.addChildElement('lifestyle_url_imagen2', null, null).addTextNode('');
                    promo.addChildElement('lifestyle_texto_2', null, null).addTextNode('');
                    promo.addChildElement('lifestyle_url_imagen3', null, null).addTextNode('');
                    promo.addChildElement('lifestyle_texto_3', null, null).addTextNode('');
                    promo.addChildElement('slogan_bloque_final', null, null).addTextNode(promocion.Slogan_Final_Web__c==null? '':promocion.Slogan_Final_Web__c );
                    promo.addChildElement('texto_bloque_final', null, null).addTextNode(promocion.Descripcion_final_Web__c==null? '':promocion.Descripcion_final_Web__c );
                }

                Blob blobMensaje = Blob.valueOf(doc.toXmlString());
                mensaje = Utils.blobToString(blobMensaje,'ISO-8859-1');

                System.debug('El mensaje que se va enviar es: '+ mensaje);

            }
        } catch( Exception ex ) {
            System.debug('Error al generar el XML de envio a la WEB de AVINTIA'+ ex);
            mensaje='KO';
            throw new GenerarXMLException(ex.getMessage());     
        }

        return mensaje;
     }
    
    //Metodo encargado de montar la URL de las imagenes
    public static string devolverURLDocumento(string URL, string versionId,string tipo) {
        PropiedadesIntegracion__c propiedades =PropiedadesIntegracion__c.getInstance();
        String URLFinal='';
        if(URL!=null && String.isNotBlank(URL) && versionId!=null && String.isNotBlank(versionId))
        {
            URLFinal=propiedades.URLDocuemntos__c+ tipo + '&versionId='+versionId+'&operationContext=DELIVERY&page=0&oid='+UserInfo.getOrganizationId().substring(0,UserInfo.getOrganizationId().length()-3)+'&dpt=null&d='+ url.substring((url.indexOf(UserInfo.getOrganizationId().substring(3,UserInfo.getOrganizationId().length()-3))+UserInfo.getOrganizationId().length()-6),url.length()) +'&tipo='+tipo;
            system.debug(URLFinal);
        }

        return URLFinal;
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
    
    public class GenerarXMLException extends Exception {}

}