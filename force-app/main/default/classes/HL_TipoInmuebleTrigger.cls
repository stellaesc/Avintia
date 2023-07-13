public class HL_TipoInmuebleTrigger extends TriggerHandler {
        
    protected override void beforeDelete() {
        Id idGrupo = [SELECT Id FROM Group WHERE DeveloperName = 'Notificacion_borrado'].ID; 
        Id templateId = [select id, name from EmailTemplate where developername = 'Alerta_Borrado_Tipo_Inmueble'].Id;
        
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
        for(Tipo_de_inmueble__c ti : (List<Tipo_de_inmueble__c>)Trigger.old ){
            System.debug('Se borra y se manda mail');
            System.debug('Listado emails: '+ lemails);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = lemails;
            message.optOutPolicy = 'FILTER';
            message.setTemplateId(templateId);
            message.setTargetObjectId(c.id);
            message.setSaveAsActivity(false); 
            message.setWhatId(ti.id);
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

}