/****************************************************************
 * Class Name: OpportunityLineItemTriggerHandler                *
 * Test Name: OpportunityLineItemTriggerHandler_Test            *
 * Date: 25/09/2018                                             *
 * Author: Deloitte                                             *
 * Description: handler class for product2 trigger              *
 * *************************************************************/
public class OpportunityLineItemTriggerHandler {

     /*******************************************************************************************************************
     * Method Name: anadirEstadoDescripcion                                                                             *
     * Description: Actualiza la entrada en la lista de precios estándar si ya existe, o crea la entrada si no existe . *
     * Author: Deloitte                                                                                                 *
     * *****************************************************************************************************************/  
    
    public static void anadirEstadoDescripcion (List<OpportunityLineItem> newList){ 

        //Recuperamos los Id de las oportunidades a las que están asociados los productos de oportunidad que hacen saltar el trigger
        Set<Id> opportunityIdSet = new Set<Id>();
        for(OpportunityLineItem opportunityLineItem : newList){
            opportunityIdSet.add(opportunityLineItem.OpportunityId);
        }
        
        //Recuperamos los productos de presupuesto asociados a una oferta que a su vez este asociada a las oportunidades anteriores
        List<QuoteLineItem> quoteLineItemList = [SELECT Product2.Name, Product2.Estado__c, Product2.Tipo_de_inmueble__r.Tipo__c ,Quote.OpportunityId, Product2.N_Vivienda_Garaje_Trastero_Local__c 
                                                 FROM QuoteLineItem 
                                                 WHERE Quote.OpportunityId IN: opportunityIdSet ORDER BY Product2.Name];
        system.debug('quoteLineItemList:::'+quoteLineItemList);
        
        
        //Hacemos algunas comprobaciones sobre los productos del presupuesto
        Boolean marcadorVivienda = False;
        for(QuoteLineItem quoteLineItem : quoteLineItemList){
            /*if(quoteLineItem.Product2.Estado__c != 'Libre' && quoteLineItem.Product2.Estado__c != 'Bloqueado temporalmente' && quoteLineItem.Product2.Estado__c != 'Asociado'){
                Trigger.new[0].addError('Alguno de los inmuebles que se está intentando sincronizar ya están Apalabrados', true);
            }*/
            if(quoteLineItem.Product2.Tipo_de_inmueble__r.Tipo__c == 'Vivienda'){
                marcadorVivienda = True;
            }
        }
        

        if(!quoteLineItemList.isEmpty()){
            //Creamos un map que relacione el id de una oportunidad con la concantenación del nombre de los inmuebles
            Map<Id, String> opportunityIdMap = new Map<Id, String>(); 
            Map<Id, QuoteLineItem> opportunityIdViviendaMap = new Map<Id, QuoteLineItem>(); 
            Map<Id, QuoteLineItem> oppIdViviendaMap = new Map<Id, QuoteLineItem>(); //Mapa para guardar solo las viviendas de una oportunidad
            Map<Id, String> oppIdViviendaDesc = new Map<Id, String>(); //Mapa para guardar solo las viviendas de una oportunidad
            for(Id opportunityId : opportunityIdSet){
                for(QuoteLineItem quoteLineItem : quoteLineItemList){
                    //Primero guardamos el inmueble, si hay vivienda, se guarda vivienda.
                    if(opportunityIdViviendaMap.get(opportunityId)!= null && quoteLineItem.Product2.Tipo_de_inmueble__r.Tipo__c == 'Vivienda' && opportunityIdViviendaMap.get(opportunityId).Product2.Tipo_de_inmueble__r.Tipo__c != 'Vivienda'){
                        opportunityIdViviendaMap.put(opportunityId, quoteLineItem);
                        oppIdViviendaMap.put(opportunityId, quoteLineItem);
                    }else if(opportunityIdViviendaMap.get(opportunityId)== null){
                        opportunityIdViviendaMap.put(opportunityId, quoteLineItem);
                    }
                    //Concantenamos los nombres de los productos
                    if(opportunityId == quoteLineItem.Quote.OpportunityId && !opportunityIdMap.keySet().contains(opportunityId)){
                        String descripcion = quoteLineItem.Product2.Name;
                        opportunityIdMap.put(opportunityId, descripcion);
                        oppIdViviendaDesc.put(opportunityId, descripcion);
                    }else if(opportunityId == quoteLineItem.Quote.OpportunityId && opportunityIdMap.keySet().contains(opportunityId)){
                        String descripcion = opportunityIdMap.get(opportunityId) + ', ' +quoteLineItem.Product2.Name;
                        opportunityIdMap.put(opportunityId, descripcion);
                    }
                }
            }
            
            //Recuperamos las oportunidades e iteramos la lista para poder sobreescribir los campos Description y StageName
            List<Opportunity> opportunityList = [SELECT Id, Description, Descripcion_Viviendas__c, StageName, Concepto_transferencia__c, Account.N_Documento__c, Promocion__r.Codigo_de_la_promocion__c FROM Opportunity WHERE Id IN: opportunityIdSet];
            for(Opportunity opportunity : opportunityList){
                opportunity.Descripcion_Viviendas__c = oppIdViviendaDesc.get(opportunity.Id).trim();
                if(opportunityIdMap.get(opportunity.Id).contains(',')){
                	opportunity.Description = 'Inmuebles '+opportunityIdMap.get(opportunity.Id).trim();                    
                }else{
                    opportunity.Description = 'Inmueble '+opportunityIdMap.get(opportunity.Id).trim();  
                }
                
                String concepto = opportunity.Promocion__r.Codigo_de_la_promocion__c + ' ' + opportunityIdViviendaMap.get(opportunity.Id).Product2.N_Vivienda_Garaje_Trastero_Local__c + ' ' + opportunity.Account.N_Documento__c; 
                if(opportunity.Concepto_transferencia__c == null && concepto.length() < 140){
                		opportunity.Concepto_transferencia__c = concepto;   
                }else if(opportunity.Concepto_transferencia__c == null && concepto.length() >= 140){
                    	opportunity.Concepto_transferencia__c = concepto.substring(0, 140);
                }
                //opportunity.StageName = 'Pre-Reserva';
                if(opportunity.StageName != 'Presupuesto' && opportunity.StageName != 'Pre-Reserva'){
                	opportunity.Verificando_PBC__c = true; //BCF - no retrocede etapa de la oportunidad y se marca el check PBC
                }
                if(marcadorVivienda == False){
                    opportunity.Porcentaje_IVA__c = 21; 
                }
            }
            system.debug('opportunityList:::'+opportunityList);
            update opportunityList;               
        }
     
        
    }
    
    public static void validarEstadoInmuebles (List<OpportunityLineItem> newList){
        
        //Recuperamos los Ids de los productos
        List<Id> product2IdList = new List<Id>();
        for(OpportunityLineItem opportunityLineItem : newList){
            product2IdList.add(opportunityLineItem.Product2Id);
        }
        
        List<Product2> product2List = [SELECT Estado__c FROM Product2 WHERE Id IN: product2IdList AND Estado__c != 'Libre' AND Estado__c != 'Bloqueado temporalmente' AND Estado__c != 'Asociado'];
        
        if(product2List.size() > 0){
            Trigger.new[0].addError('Alguno de los inmuebles que se está intentando sincronizar ya están Apalabrados', true);
        }
    }
    
}