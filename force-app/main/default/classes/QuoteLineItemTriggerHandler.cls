/****************************************************************
 * Class Name: OpportunityLineItemTriggerHandler                *
 * Test Name: OpportunityLineItemTriggerHandler_Test            *
 * Date: 25/09/2018                                             *
 * Author: Deloitte                                             *
 * Description: handler class for product2 trigger              *
 * *************************************************************/
public class QuoteLineItemTriggerHandler {
    
     /*******************************************************************************************************************
     * Method Name: anadirEstadoDescripcion                                                                             *
     * Description: Actualiza la entrada en la lista de precios estándar si ya existe, o crea la entrada si no existe . *
     * Author: Deloitte                                                                                                 *
     * *****************************************************************************************************************/  
    
    public static void anadirPriceBookEntry (List<QuoteLineItem> newList){ 

		//Sacamos los ids de los productos para recuperarlos con una query
        List<Id> productIdList = new List<Id>();
        for(QuoteLineItem quoteLineItem: newList){
            productIdList.add(quoteLineItem.Product2Id);
        }
        
        List<Product2> product2List = [SELECT Precio__c FROM Product2 WHERE Id IN: productIdList];

        List<Product2> productPrecioToUpdate = new List<Product2>();
        for(Product2 inmueble: product2List){
            if(inmueble.Precio__c == null){
                inmueble.Precio__c = 0;
                //En productPrecioToUpdate se guardan unicamente los productos que no tenian precio
                productPrecioToUpdate.add(inmueble);
            }
        } 
        update productPrecioToUpdate;
        system.debug('productPrecioToUpdate:::'+productPrecioToUpdate);
        
        //Sacamos las entradas de la lista de precios estandar para los productos
        Id pricebookId = Utils.getStandarPriceBook();
        List<PricebookEntry> pricebookEntryList = [SELECT Id, Product2Id, Pricebook2Id, UnitPrice FROM PricebookEntry WHERE Product2Id IN: productIdList AND Pricebook2Id =:pricebookId];
        system.debug('productPrecioToUpdate:::'+productPrecioToUpdate);
        
        //Asignamos el pricebook a cada quote line item
        for(QuoteLineItem quoteLineItem: newList){
            for(PriceBookEntry pricebookentry : pricebookEntryList){
                if(quoteLineItem.Product2Id == pricebookentry.Product2Id){
                    quoteLineItem.UnitPrice = pricebookentry.UnitPrice;
                    quoteLineItem.PricebookEntryId = pricebookentry.Id;                    
                }
            }
        } 

        
    }
    
     /*******************************************************************************************************************
     * Method Name: validarCondicionesInsercion                                                                             *
     * Description: Validaciones como no insertar 2 veces el mismo producto o no insertar mas productos de los permitidos (por tipo). *
     * Author: Deloitte                                                                                                 *
     * *****************************************************************************************************************/      
    public static void validarCondicionesInsercion (List<QuoteLineItem> newList){ 
        
        //Organizamos el trigger new en un map con clave Quote Id y valor sus productos de presupuesto
        Map<Id,List<QuoteLineItem>> mapNewQuoteLineItem = new Map<Id,List<QuoteLineItem>>();
        for(QuoteLineItem quoteLineItem : newList){
            if(mapNewQuoteLineItem.get(quoteLineItem.QuoteId) == null){
            	List<QuoteLineItem> quoteLineItemList = new List<QuoteLineItem>{quoteLineItem};
            	mapNewQuoteLineItem.put(quoteLineItem.QuoteId, quoteLineItemList);
            }else{
                mapNewQuoteLineItem.get(quoteLineItem.QuoteId).add(quoteLineItem);            
            }
        }
        
        //Recuperamos los productos que estan ya insertados en la quote    
        List<QuoteLineItem> quoteLineItemsOld = [SELECT Id, Product2.Tipo_de_inmueble__r.Tipo__c FROM QuoteLineItem  WHERE QuoteId =: mapNewQuoteLineItem.keySet()];
        system.debug('quoteLineItemsOld:::'+quoteLineItemsOld);
        
       //Recuperamos los Ids de los productos ya insertados para poder validar mas tarde que no se inserte 2 veces el mismo producto
        List<Id> quoteProduct2IdList = new List<Id>();
        for(QuoteLineItem quoteLineItem : quoteLineItemsOld){
                quoteProduct2IdList.add(quoteLineItem.Product2Id);
        }
        system.debug('quoteProduct2IdList:::'+quoteProduct2IdList);    

        //Productos que ya estaban en el presupuesto: contamos cuantos hay de cada tipo
        Map<String, Integer> mapTipoCantidad = new Map<String, Integer>();
        for(QuoteLineItem quoteLineItem : quoteLineItemsOld ){
        	//Primero utilizamos el bucle para guardar en el mapa el numero de inmuebles por tipo
            if(!mapTipoCantidad.keySet().contains(quoteLineItem.Product2.Tipo_de_inmueble__r.Tipo__c)){
            	mapTipoCantidad.put(quoteLineItem.Product2.Tipo_de_inmueble__r.Tipo__c, 1);
             }else{
                Integer cantidad = mapTipoCantidad.get(quoteLineItem.Product2.Tipo_de_inmueble__r.Tipo__c);
             	mapTipoCantidad.put(quoteLineItem.Product2.Tipo_de_inmueble__r.Tipo__c, cantidad + 1);
             }

        }            
        system.debug('mapTipoCantidad:::'+mapTipoCantidad);
        
        List<Id> productIdQuoteLineItemNew = new List<Id>();
        for(QuoteLineItem quoteLineItemNew : newList){
            productIdQuoteLineItemNew.add(quoteLineItemNew.Product2Id);
        }
        
        List<Product2> productQuoteLineItemNew = [SELECT Id, Tipo_de_inmueble__r.Tipo__c FROM Product2 WHERE Id IN: productIdQuoteLineItemNew];
        
        //Productos que se van a insertar: contamos cuantos hay de cada tipo y hacemos la validacion de que no se incluya 2 veces el mismo  
        for(Product2 productQuoteLineItem : productQuoteLineItemNew){
        	if(!mapTipoCantidad.keySet().contains(productQuoteLineItem.Tipo_de_inmueble__r.Tipo__c)){
            	mapTipoCantidad.put(productQuoteLineItem.Tipo_de_inmueble__r.Tipo__c, 1);
             }else{
                Integer cantidad = mapTipoCantidad.get(productQuoteLineItem.Tipo_de_inmueble__r.Tipo__c);
             	mapTipoCantidad.put(productQuoteLineItem.Tipo_de_inmueble__r.Tipo__c, cantidad + 1);
             }
            
            //-------------------------VALIDACION 1 -----------------------
            if(quoteProduct2IdList.contains(productQuoteLineItem.Id)){
                String mensaje  = 'Este inmueble ya está incluído en el presupuesto.';
                system.debug(mensaje);
            	//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, mensaje));
                Trigger.new[0].addError(mensaje);
                return;
            }
        } 
		system.debug('mapTipoCantidad:::'+mapTipoCantidad);
        
		//mapTipoCantidad guarda la cantidad de inmuebles, por tipo tiene la quote (tanto los que ya estan como los que se insertan)
        String mensaje = 'No es posible incluir más de 1 vivienda en una oportunidad.';
        if(mapTipoCantidad.get('Vivienda') == null ||  mapTipoCantidad.get('Vivienda') <= 1){
        	mensaje = 'No es posible incluir más de 1 local en una oportunidad.';
            system.debug('mapTipoCantidad.get(Vivienda):::'+mapTipoCantidad.get('Vivienda'));
            if(mapTipoCantidad.get('Local') == null || mapTipoCantidad.get('Local') <= 1){
            	mensaje = 'No es posible incluir más de 2 garajes en una oportunidad.';
                system.debug('mapTipoCantidad.get(Local):::'+mapTipoCantidad.get('Local'));
                if(mapTipoCantidad.get('Garaje') == null || mapTipoCantidad.get('Garaje') <= 2){
                	mensaje = '';
                    system.debug('mapTipoCantidad.get(Garaje):::'+mapTipoCantidad.get('Garaje'));
                }
            }
 		
        }
        
        //Si se encuentra marcada la checkbox "Venta Masiva" se permitirá un número ilimitado de inmuebles
        Set<id> sIdDescuentos = new Set<id>();
        for(QuoteLineItem quoteLineItemNew : newList){
            sIdDescuentos.add(quoteLineItemNew.QuoteId); 
        }
        
        List<Quote> lQuotes = [SELECT id, OpportunityId from Quote where id in: sIdDescuentos];
        Set<id> sIdOportunidades = new Set<id>();
        for(Quote quotes : lQuotes){
            sIdOportunidades.add(quotes.OpportunityId);
        }
        
        List<Opportunity> lOportunidades = [SELECT id, VentaMasiva__c from Opportunity where id in:sIdOportunidades];
        for(Opportunity oportunidades: lOportunidades){
            if(oportunidades.VentaMasiva__c == true) mensaje = '';
        }
                
        if(mensaje != '' && ApexPages.currentPage() !=null){
            try{
                system.debug('mensaje:::'+mensaje);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,mensaje));
                Trigger.new[0].addError(mensaje);
                return;
            }catch(DmlException e){System.debug('The following exception has occurred: ' + e.getMessage());}
        }       
 
    }
    
    
    
}