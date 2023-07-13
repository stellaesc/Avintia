public class Ficha_Forma_pago_Controller {

    //Variables accesibles
    
    public Quote quote {get; set;}
    public Promocion__c promocion {get; set;}
    public Product2 inmueble {get; set;}
    public List<Product2> listGarajes {get; set;}
    public List<Product2>  listTrasteros {get; set;} 
    public String cadenaTiposVivienda {get; set;}
    
    public String urlLogoPromocion {get;set;}
    public List<ContentDocumentLink> imagen {get;set;}
    public List<ContentVersion> cv{get;set;}

    //Variables importe formateadas
    public String StrOpporReserva {get;set;}
    public String StrOpporPorcIVA {get;set;}
    public String StrOpporReservaIVA {get;set;}
    public String StrInmueblePrecio {get;set;}
    public String StrInmueblePrecioIVA {get;set;}
    public String StrInmueblePrecioTotal {get;set;}
    public String StrGarajePrecio {get;set;}
    public String StrGarajePrecioIVA {get;set;}
    public String StrGarajePrecioTotal {get;set;}
    public String StrTrasteroPrecio {get;set;}
    public String StrTrasteroPrecioIVA {get;set;}
    public String StrTrasteroPrecioTotal {get;set;}
	public String StrCuotasMensuales {get;set;}
    public String StrCuotasMensualesIVA {get;set;}
    public String StrCuotasMensualesTotal {get;set;}
    public String StrImporteContrato {get;set;}
    public String StrImporteContratoIVA {get;set;}
    public String StrImporteContratoTotal {get;set;}
    public String StrImporteEscritura {get;set;}
    public String StrImporteEscrituraIVA {get;set;}
    public String StrImporteEscrituraTotal {get;set;}
    public Map<Id, List<String>> MapGarajes {get;set;}
    public Map<Id, List<String>> MapTrasteros {get;set;}
    public String StrImporteCoutaExtra {get;set;}
    public String StrImporteCoutaExtraIVA {get;set;}
    public String StrImporteCoutaExtraTotal {get;set;}
    
    
    //Constructor
    public Ficha_Forma_pago_Controller() {
           Id idQuote = ApexPages.currentPage().getParameters().get('id');
           //Id idQuote = '0Q0n00000006P1XCAU';        
           system.debug('Id quote '+idQuote);
            
           quote = [SELECT id, Opportunity.promocion__c, Opportunity.accountId, Opportunity.Amount, Opportunity.Reserva__c, Opportunity.Tipo_de_Reserva__c, 
                          Opportunity.Porcentaje_IVA__c, Opportunity.Pago_Contrato__c,
                          Opportunity.N_Cuotas__c, Opportunity.Importe_de_Cuota__c, Opportunity.Fecha_de_primera_cuota__c, Opportunity.pago_Escritura__c, 
                          Opportunity.Penalizacion_Contrato__c, 
                          Opportunity.Fecha_firma_Contrato_Reserva__c, Opportunity.Fecha_firma_Contrato_Compraventa__c, Opportunity.Numero_Cuotas_Extra__c, Opportunity.Importe_Cuota_Extra__c,
                          Opportunity.Pago_Contrato_al_contado__c,Opportunity.Account.N_Documento__pc, Opportunity.Account.N_Documento__c, Importe_cuota__c,
                    	  Importe_cuota_extra__c, Importe_Escritura__c, Importe_firma_contrato__c, Importe_Plan_de_pagos__c, Importe_reserva__c
                           FROM Quote WHERE id =: idQuote];
           
           system.debug('quote CONTROLLER '+quote);
        
           List <String> formateo = new String[]{'0', 'number', '###,###,###.00'};
           //Formateamos campos de importe
           if(quote.Opportunity.Reserva__c != null){
               StrOpporReserva = String.format(quote.Opportunity.Reserva__c.format(), formateo);
               if(quote.Opportunity.Porcentaje_IVA__c != null){
                    StrOpporPorcIVA = String.format(quote.Opportunity.Porcentaje_IVA__c.format(), formateo);
                    Decimal Aux = quote.Opportunity.Reserva__c * (1 + quote.Opportunity.Porcentaje_IVA__c/100);
                    Aux = Aux.setScale(2);
                    StrOpporReservaIVA = String.format(Aux.format(), formateo);
               }
           }
           
           if(quote.Importe_cuota__c != null){
                StrCuotasMensuales = String.format(quote.Importe_cuota__c.format(), formateo);
                if(quote.Opportunity.Porcentaje_IVA__c != null){
                    Decimal CuotasMensualesIVA = quote.Importe_cuota__c * quote.Opportunity.Porcentaje_IVA__c/100;
                    CuotasMensualesIVA = CuotasMensualesIVA.setScale(2);
                    StrCuotasMensualesIVA = String.format(CuotasMensualesIVA.format(), formateo);
                    Decimal CuotasMensuales = quote.Importe_cuota__c *(1 + quote.Opportunity.Porcentaje_IVA__c/100);
                    CuotasMensuales = CuotasMensuales.setScale(2);
                    StrCuotasMensualesTotal = String.format(CuotasMensuales.format(), formateo);
                }
           }
           
            if(quote.Importe_firma_contrato__c != null){
                StrImporteContrato = String.format(quote.Importe_firma_contrato__c.format(), formateo);
                if(quote.Opportunity.Porcentaje_IVA__c != null){
                    Decimal ImporteContratoIVA = quote.Importe_firma_contrato__c * quote.Opportunity.Porcentaje_IVA__c/100;
                    ImporteContratoIVA = ImporteContratoIVA.setScale(2);
                    StrImporteContratoIVA = String.format(ImporteContratoIVA.format(), formateo);
                    Decimal CuotasMensualesTotal = quote.Importe_firma_contrato__c * (1 + quote.Opportunity.Porcentaje_IVA__c/100);
                    CuotasMensualesTotal = CuotasMensualesTotal.setScale(2);
                    StrImporteContratoTotal = String.format(CuotasMensualesTotal.format(), formateo);
                }
            }
           
            if(quote.Importe_Escritura__c != null){
                StrImporteEscritura = String.format(quote.Importe_Escritura__c.format(), formateo);
                if(quote.Opportunity.Porcentaje_IVA__c != null){
                    Decimal ImporteEscrituraIVA = quote.Importe_Escritura__c * quote.Opportunity.Porcentaje_IVA__c/100;
                    ImporteEscrituraIVA = ImporteEscrituraIVA.setScale(2);
                    StrImporteEscrituraIVA = String.format(ImporteEscrituraIVA.format(), formateo);
                    Decimal ImporteEscrituraTotal = quote.Importe_Escritura__c * (1 + quote.Opportunity.Porcentaje_IVA__c/100);
                    ImporteEscrituraTotal = ImporteEscrituraTotal.setScale(2);
                    StrImporteEscrituraTotal = String.format(ImporteEscrituraTotal.format(), formateo);
                }
            }
           
            if(quote.Importe_cuota_extra__c != null){
                StrImporteCoutaExtra = String.format(quote.Importe_cuota_extra__c.format(), formateo);
                if(quote.Opportunity.Porcentaje_IVA__c != null){
                    Decimal ImporteCoutaExtraIVA = quote.Importe_cuota_extra__c * quote.Opportunity.Porcentaje_IVA__c/100;
                    ImporteCoutaExtraIVA = ImporteCoutaExtraIVA.setScale(2);
                    StrImporteCoutaExtraIVA = String.format(ImporteCoutaExtraIVA.format(), formateo);
                    Decimal ImporteCoutaExtraTotal = quote.Importe_cuota_extra__c * (1 + quote.Opportunity.Porcentaje_IVA__c/100);
                    ImporteCoutaExtraTotal = ImporteCoutaExtraTotal.setScale(2);
                    StrImporteCoutaExtraTotal = String.format(ImporteCoutaExtraTotal.format(), formateo);
                }
            }
        
           getPromocion();
           system.debug('Promocion controller '+promocion);  
           getInmuebles();
           system.debug('Inmuebles controller '+inmueble);
           getTipoViviendasPromocion();
           system.debug('TipoViviendasPromocion controller '+cadenaTiposVivienda);
           getURLLogoPromocion();
    	}
     
    //Métodos
     public void getPromocion(){
            
            promocion = [SELECT id, name, Tipo_via__c, Nombre_via__c, N_Via__c, Socio_Empresa_Promotora__c, Codigo_postal__c, Localidad__r.Name, Superficie_total_de_parcela__c, 
                         N_Viviendas_totales_promocion__c, Cuenta_Activa_1__c, Cuenta_Activa_2__c, Numero_de_cuenta_bancaria_1__c, Numero_de_cuenta_bancaria_2__c, 
                         Entidad_Bancaria1__c, Entidad_Bancaria2__c, Socio_Empresa_Comercializadora__r.Name, Periodo_de_Reserva__c, Socio_Empresa_Promotora__r.Name, 
                         Porcentaje_IVA__c , Cantidad_de_Reserva__c, Direccion_punto_venta_comercializadora__c, Telefono_promocion_comercializadora__c,
                         Email_promocion_comercializadora__c, Codigo_de_la_promocion__c, Titularidad_de_la_cuenta1__c, Titularidad_de_la_cuenta2__c,
                         Semestre_de_escrituracion__c, Fecha_de_escritura__c, Mostrar_Fecha_de_Escritura__c, Inicio_de_escrituraciones__c 
                         FROM Promocion__c 
                         WHERE Id =: quote.Opportunity.promocion__c];
            
          }
    
    public void getTipoViviendasPromocion(){
            
		List<Product2> listaInmuebles = [SELECT Id, Tipo_de_vivienda__c  FROM Product2 WHERE Promocion__c =: quote.Opportunity.promocion__c];
        system.debug('listaInmuebles prueba'+listaInmuebles);
        system.debug('quote.Opportunity.promocion__c prueba'+quote.Opportunity.promocion__c);
        
        //Obtener los distintos tipo de vivienda que hay en la promoción
        Set<String> tipoViviendaSet = new Set<String>();
        for(Product2 inmueble: listaInmuebles){
            if(inmueble.Tipo_de_vivienda__c != null){
            	tipoViviendaSet.add(inmueble.Tipo_de_vivienda__c);                
            }
        }
        
        cadenaTiposVivienda = '';
        for(String tipoVivienda : tipoViviendaSet){
            if(cadenaTiposVivienda != ''){
                cadenaTiposVivienda += ' / ';
            }
            cadenaTiposVivienda += tipoVivienda;
        }
        
            
    }
    
    
    
    public void getInmuebles(){
        
        //Inicialización de listas
        listGarajes = new List<Product2>();
        listTrasteros = new List<Product2>();
        
        //Obtener producto de presupuesto - inmueble asociado al presupuesto
        List<QuoteLineItem> listProductoPresupuesto = [SELECT id, Product2Id
                                                        FROM QuoteLineItem WHERE QuoteId =: quote.id];
        
        system.debug('Productos de presupuesto '+listProductoPresupuesto);
        
        //Almacena las id de los inmuebles (Product2) de los productos de presupuesto
        Set<id> setProductoPresupuesto = new Set<id>();
        
        for(integer j = 0; j < listProductoPresupuesto.size() ; j++){
            
            setProductoPresupuesto.add(listProductoPresupuesto[j].Product2Id);
        }
        
        system.debug('SET Productos de presupuesto '+setProductoPresupuesto);
        
        //Obtener inmueble e inmuebles asociados
        List<Product2> listaInmuebles = [SELECT id, name, planta__c, Letra_N_Puerta__c, Inmueble_asociado__c, 
                                         Tipo_de_inmueble__c, Precio__c, Tipo_de_via__c, nombre_via__c, piso__c, portal__c, 
                                         N_habitaciones__c, N_banos__c, Superficie_Construida_total_con_ZZCC_m2__c, 
                                         N_Vivienda_Garaje_Trastero_Local__c, Superficie_Util_Trastero_con_pasillos_m2__c,
                                         sup_Cocina__c, sup_Salon__c, Superficie_Terrazas_Descubiertas__c, Superficie_Terrazas_Cubiertas__c,
                                         Bloque__c, Superficie_Util_Garaje_con_calles_m2__c, Superficie_Util_m2__c, Tipo_de_inmueble__r.Tipo__c,
                                         N_Via__c, ProductCode, Tipo_de_vivienda__c 
                                         FROM Product2 WHERE (id IN: setProductoPresupuesto AND    (Tipo_de_inmueble__r.tipo__c = 'Vivienda' 
                                                                                                OR Tipo_de_inmueble__r.tipo__c = 'Garaje'
                                                                                                OR Tipo_de_inmueble__r.tipo__c = 'Trastero'
                                                                                                OR Tipo_de_inmueble__r.tipo__c = 'Local'))];

        
        system.debug('listaInmuebles:::'+listaInmuebles);
        system.debug('listaInmuebles.size():::'+listaInmuebles.size());
        
        List<String> listaTipoInmueble = new List<String>();
        for(Product2 inmueble : listaInmuebles){
            listaTipoInmueble.add(inmueble.Tipo_de_inmueble__r.tipo__c);
        }
        
		//Se asignan los inmuebles dependiendo de su tipo de vivienda
        for(integer i = 0; i < listaInmuebles.size() ; i++){
            
            if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Vivienda'){
                inmueble = listaInmuebles[i];
            }else if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Local'){
                inmueble = listaInmuebles[i];
            }
            else{  
                if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Garaje'){
                     if(!listaTipoInmueble.contains('Vivienda')){
                        inmueble = listaInmuebles[i];
                     }
                     listGarajes.add(listaInmuebles[i]);
                     system.debug('GARAJE ');
                     system.debug('listGarajes:::'+listGarajes);
                 }
                else if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Trastero'){
                    if(!listaTipoInmueble.contains('Vivienda')){
                        inmueble = listaInmuebles[i];
                    }
                    listTrasteros.add(listaInmuebles[i]); 
                    system.debug('TRASTERO ');
                    system.debug('listTrasteros:::'+listTrasteros);
                }
            }
        }
        
     		List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
          	//Formateamos campos de importe
           	StrInmueblePrecio = String.format(inmueble.Precio__c.format(), formateo);
        
        Decimal AuxStrInmueblePrecioIVA = inmueble.Precio__c * quote.Opportunity.Porcentaje_IVA__c/100;
        	AuxStrInmueblePrecioIVA = AuxStrInmueblePrecioIVA.setScale(2);
        	StrInmueblePrecioIVA = String.format(AuxStrInmueblePrecioIVA.format(), formateo);
        	
        Decimal AuxStrInmueblePrecioTotal = inmueble.Precio__c * (1 + quote.Opportunity.Porcentaje_IVA__c/100);
        	AuxStrInmueblePrecioTotal= AuxStrInmueblePrecioTotal.setScale(2);
        	StrInmueblePrecioTotal = String.format(AuxStrInmueblePrecioTotal.format(), formateo);
      
        List<String> GarajeAux= new List <String>();
        MapGarajes = new Map<Id, List<String>>();
        
        for(integer i = 0; i < listGarajes.size() ; i++){
            GarajeAux = new List <String>();
        	Decimal preciogaraje = listGarajes[i].Precio__c ;
            preciogaraje = preciogaraje.setScale(2);
            Decimal preciogarajeIVA = listGarajes[i].Precio__c * quote.Opportunity.Porcentaje_IVA__c/100;
            preciogarajeIVA = preciogarajeIVA.setScale(2);
            Decimal preciogarajeTotal= listGarajes[i].Precio__c * (1 + quote.Opportunity.Porcentaje_IVA__c/100);
            preciogarajeTotal = preciogarajeTotal.setScale(2);
            
            StrGarajePrecio = String.format(preciogaraje.format(), formateo);
            StrGarajePrecioIVA = String.format(preciogarajeIVA.format(), formateo);
            StrGarajePrecioTotal = String.format(preciogarajeTotal.format(), formateo);
            
           	GarajeAux.add(StrGarajePrecio);
            GarajeAux.add(StrGarajePrecioIVA);
            GarajeAux.add(StrGarajePrecioTotal);
            MapGarajes.put(listGarajes[i].Id, GarajeAux);
            System.debug(GarajeAux);
           
            
            System.debug(MapGarajes);
        }
        
        List<String> TrasteroAux= new List <String>();
        MapTrasteros = new Map<Id, List<String>>();
        
        for(integer i = 0; i < listTrasteros.size() ; i++){
            TrasteroAux = new List <String>();
        	Decimal preciotrastero = listTrasteros[i].Precio__c ;
            preciotrastero = preciotrastero.setScale(2);
            Decimal preciotrasteroIVA = listTrasteros[i].Precio__c * quote.Opportunity.Porcentaje_IVA__c/100;
            preciotrasteroIVA = preciotrasteroIVA.setScale(2);
            Decimal preciotrasteroTotal= listTrasteros[i].Precio__c * (1 + quote.Opportunity.Porcentaje_IVA__c/100);
            preciotrasteroTotal = preciotrasteroTotal.setScale(2);
            
            StrTrasteroPrecio = String.format(preciotrastero.format(), formateo);
            StrTrasteroPrecioIVA = String.format(preciotrasteroIVA.format(), formateo);
            StrTrasteroPrecioTotal = String.format(preciotrasteroTotal.format(), formateo);
            
           	TrasteroAux.add(StrTrasteroPrecio);
            TrasteroAux.add(StrTrasteroPrecioIVA);
            TrasteroAux.add(StrTrasteroPrecioTotal);
            MapTrasteros.put(listTrasteros[i].Id, TrasteroAux);
        }
        
        //System.debug(listaGaraje);
        
        //StrGarajePrecio = String.format(garaje.Precio__c.format(), formateo);*/

    }
    
    public void getURLLogoPromocion(){
    	imagen = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: quote.Opportunity.Promocion__c];
              
              
        List<Id> idsDoc = new List<Id>();
        for(ContentDocumentLink documentos : imagen){
        	idsDoc.add(documentos.ContentDocumentId); 
        }
              
        cv = [SELECT Id FROM ContentVersion WHERE ContentDocumentId IN: idsDoc AND Tipo__c ='Logo Promoción' ORDER BY CreatedDate DESC];
              
        if(!cv.isEmpty()){
        	urlLogoPromocion = '../sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId='+cv[0].Id;           
       	}
        system.debug('logo '+urlLogoPromocion);        
    }

}