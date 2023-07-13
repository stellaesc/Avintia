public class SelectMejoraQuoteController {

    @AuraEnabled
    public static List<Mejora> getMejoras(Id quoteId) {
        Quote qu = [SELECT Id, Opportunity.Promocion__c FROM Quote WHERE Id = :quoteId LIMIT 1];
        List<Mejora__c> mejoras = new List<Mejora__c>([SELECT Id, Name, Precio__c, Descripcion__c FROM Mejora__c WHERE Promocion__c = :qu.Opportunity.Promocion__c]);

        List<Mejora> response = new List<Mejora>();
        for(Mejora__c m : mejoras) {
            Mejora nm = new Mejora();
            nm.ident = m.Id;
            nm.Name = m.Name;
            nm.Descripcion = m.Descripcion__c;
            nm.Precio = m.Precio__c;
            nm.check = false;
            response.add(nm);
        }
        return response;
    }
    
    @AuraEnabled
    public static void saveMejoras(Id quoteId, List<Mejora> mejoras) {
        List<MejoraPresupuesto__c> toCreate = new List<MejoraPresupuesto__c>();
        
        for(Mejora mj : mejoras)
            if(mj.check){
                MejoraPresupuesto__c mp = new MejoraPresupuesto__c();
                mp.Mejora__c = mj.ident;
                mp.Presupuesto__c = quoteId;
                mp.Name = mj.Name;
                mp.Descripcion__c = mj.Descripcion;
                mp.Precio__c = mj.Precio;
                toCreate.add(mp);
            }
        
        if(!toCreate.isEmpty()) insert toCreate;
    }
    
    public class Mejora {
        @AuraEnabled public Id ident{get;set;}
        @AuraEnabled public String Name{get;set;}
        @AuraEnabled public String Descripcion{get;set;}
        @AuraEnabled public Double Precio{get;set;}
        @AuraEnabled public Boolean check {get;set;} 
    }
    
}