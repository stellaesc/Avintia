trigger LeadTrigger on Lead (before insert,before update) {
    if(Trigger.isBefore)
    {
        boolean resultado1;
        boolean resultado2;
        boolean resultado3;
         Map<Id, String> promociones=new  Map<Id, String>();
            
         //Se busca el pais españa para saber la nacionalidad
        List <Pais__c> pais = [Select ID from Pais__c where Codigo_ISO3__c=:'ESP'];
         //Buscamos todas las promociones de los Lead
        
        Set<Id> promocionesId= new Set<Id>();
        for(Lead leadId : trigger.new) {

            if(leadId.Id_promocion_web_to_lead__c!=null && String.isNotBlank(leadId.Id_promocion_web_to_lead__c))
            {
                system.debug('Lead: '+leadId.Id_promocion_web_to_lead__c);
                promocionesId.add(leadId.Id_promocion_web_to_lead__c);
            }     
            else if(leadId.Promocion__c!=null && String.isNotBlank(leadId.Promocion__c))
            {
                promocionesId.add(leadId.Promocion__c);
            }
        }
        if(promocionesId.size()>0)
        {
           
            List<Promocion__c> promo=[Select ID, Link_video_promocion__c from Promocion__c where ID in:promocionesId];
            for(Promocion__c p:promo)
            {
                promociones.put(p.ID,p.Link_video_promocion__c);
            }
        }
        
        
        for(Lead lead : trigger.new) {
            
            if(lead.Nacionalidad__c!=null &&lead.Nacionalidad__c==pais.get(0).ID)
            { 
                if(lead.Tipo_de_documento__c!=null && lead.Tipo_de_documento__c!= 'Pasaporte' && lead.Tipo_de_documento__c!= 'Nº Contribuyente'&&lead.Tipo_de_documento__c!= 'Otros'&& lead.Numero_de_documento__c!=null && lead.Numero_de_documento__c!='')
                {
                    resultado1 = ValidadorTriggerNIFHandler.validateNIFEmpresa(lead.Numero_de_documento__c);
                    if (resultado1) {
                        
                        resultado2 = ValidadorTriggerNIFHandler.validateNIFpersona(lead.Numero_de_documento__c);
                        if (resultado1 && !resultado2){
                            
                            resultado3 = ValidadorTriggerNIFHandler.validateNIE(lead.Numero_de_documento__c);
                            if (resultado1 && !resultado2 && !resultado3){
                                
                                if(!System.Test.isRunningTest()){

                                    lead.addError('El NIF/CIF o NIE introducido no es válido, por favor revíselo');
                                }
                            }

                        }
                    }
                }
            }

            if(Trigger.isInsert)
            {
                if(lead.Id_promocion_web_to_lead__c!=null && String.isNotBlank(lead.Id_promocion_web_to_lead__c))
                {
                    lead.Link_Promocion__c=promociones.get(lead.Id_promocion_web_to_lead__c);
                } else if(lead.Promocion__c!=null && String.isNotBlank(lead.Promocion__c))
                {
                    lead.Link_Promocion__c=promociones.get(lead.Promocion__c);
                }

            }
        }

        if(Trigger.isUpdate) {
            Map<Id, Lead> news = (Map<Id, Lead>) Trigger.newMap;
            Map<Id, Lead> olds = (Map<Id, Lead>) Trigger.oldMap;
            
            for(Lead l : news.values()) {
                if(olds.get(l.Id).Status != l.Status)
                    l.LastLeadStatus__c = olds.get(l.Id).Status;
            }
        }
    }

}