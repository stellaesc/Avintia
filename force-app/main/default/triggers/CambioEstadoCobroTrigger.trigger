trigger CambioEstadoCobroTrigger on Cobro__c (after insert, after update) {

    if (Trigger.isAfter)
    {
        List<Factura__c> facturas=new List<Factura__c>();
        Factura__c factura=null;
         for(Cobro__c cobro : trigger.new) { 

             if(cobro.Factura__c!=null &&String.isNotBlank(cobro.Factura__c))
             {
                 factura= new Factura__c();
                 factura.Id=cobro.Factura__c;
                 factura.Estado_de_la_factura__c='Conciliada SF';
                facturas.add(factura);
             } 
         }  


         if(facturas.size()>0)
         {
             update(facturas);
         } 
    }

}