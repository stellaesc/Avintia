public class HL_FacturaTrigger extends TriggerHandler {
    
    protected override void beforeDelete() {
        Id idGrupo = [SELECT Id FROM Group WHERE DeveloperName = 'Notificacion_borrado'].ID; 
        Id templateId = [select id, name from EmailTemplate where developername = 'Alerta_Borrado_Factura'].Id;
        
        List<GroupMember> lgmember = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId =: idGrupo];
        Set<Id> idslgmember = new Set<Id>();
        for(GroupMember gm: lgmember){
            idslgmember.add(gm.UserOrGroupId);
        }
        List<User> luser = [SELECT email FROM User WHERE id IN: Idslgmember];
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
        for(Factura__c fact : (List<Factura__c>)Trigger.old ){
            if(fact.Numero_de_factura__c != null && !fact.Permitir_borrado_con_numeracion__c){
                fact.addError('La factura que se desea eliminar tiene número de factura y no está marcado el check'+
                              +' "Permitir borrado con numeración". Si desea eliminar la factura, recuerde marcar dicho check.');
            }
            System.debug('Se borra y se manda mail');
            System.debug('Listado emails: '+ lemails);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = lemails;
            message.optOutPolicy = 'FILTER';
            message.setTemplateId(templateId);
            message.setTargetObjectId(c.id);
            message.setSaveAsActivity(false); 
            message.setWhatId(fact.id);
            message.setTreatTargetObjectAsRecipient(false);
            if ( owea.size() > 0 ) {	
                message.setOrgWideEmailAddressId(owea.get(0).Id);	
            }	
            messages.add(message);
        }
         Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            System.debug('Resultados: '+ results);
        delete c;
    }
    
    protected override void beforeUpdate() {
     	Map<Id,Factura__c> news = (Map<Id,Factura__c>) Trigger.newMap;
        
        Set<Id> idOpp = new Set<Id>();
        
        for(Id idNew : news.keySet()){
            idOpp.add(news.get(idNew).Oportunidad__c);
        }
        
        List<Factura__c> lFact = [SELECT id, Numero_de_factura__c, Fecha_de_emision__c, Oportunidad__c FROM Factura__c WHERE Oportunidad__c IN:idOpp];
        
        for(Factura__c f: lFact){
            for(Id idFact: news.keySet()){
                if(news.get(idFact).Oportunidad__c == f.Oportunidad__c && news.get(idFact).Numero_de_factura__c != null && news.get(idFact).Fecha_de_emision__c != null && f.Fecha_de_emision__c > news.get(idFact).Fecha_de_emision__c && f.Numero_de_factura__c < news.get(idFact).Numero_de_factura__c){
                       news.get(idFact).addError('La fecha de la factura no puede ser menor a la fecha de otra factura, siendo su número de factura mayor.');
                   }
            }
        }

    }   
    
}