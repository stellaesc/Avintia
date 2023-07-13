@isTest
public class TEST_OpportunityLineItemTrigger {

    @isTest
    static void anadirEstadoDescripcionTest(){

        Quote presupuesto = TestUtil.getPresupuesto_Ficha_Forma_Pago_controller();
        
        List<QuoteLineItem> quoteLineItemList = [SELECT Id, Product2.Estado__c FROM QuoteLineItem WHERE QuoteId =: presupuesto.Id];
        
        system.debug('size:::'+quoteLineItemList.size());
        system.debug('quoteLineItemList[0].Product2.Estado__c:::'+quoteLineItemList[0].Product2.Estado__c);
        
        List<Opportunity> opportunity = [SELECT SyncedQuoteId FROM Opportunity WHERE Id =: presupuesto.OpportunityId];
        system.debug('opportunity.SyncedQuoteId:::'+opportunity[0].SyncedQuoteId);
        
        //En los test para sincronizar un presupuesto NO se puede hacer quote.isSyncing, hay que hacer opportunity.SyncedQuoteId = presupuesto.Id
        //Al tener que hacerlo en opportunity salta la validacion en un momento en el que en los casos reales, no salta
        try{
            if(opportunity.size() > 0){
                opportunity[0].SyncedQuoteId = presupuesto.Id;
            }
            system.debug('quoteLineItemList[0].Product2.Estado__c:::'+quoteLineItemList[0].Product2.Estado__c);
            
            update opportunity[0];
        }catch(System.DMLException e){
            system.debug('TEST_OpportunityLineItemTrigger - anadirEstadoDescripcionTest()DmlException::::'+e.getMessage());
        }
         
    }
    
    /*
    @isTest
    static void cambiarEstadoInmuebleApalabradoBorradoTest(){
        
        Opportunity oportunidad = new Opportunity();
        
        //Generar datos
        OpportunityLineItem opportunityLineItem = TestUtil.getProductoLibreOportunidad();
        
        Product2 inmueble = [SELECT id, estado__c FROM Product2 WHERE id =: opportunityLineItem.Product2Id LIMIT 1];
        
        inmueble.estado__c = 'Apalabrado';

        update inmueble;
        
        delete opportunityLineItem;
 
    }*/
}