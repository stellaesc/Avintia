@RestResource(urlMapping = '/IdealistaLeads/*')
global class IdealistaLeadManager {

    @HttpPost
    global static void createLead() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        if(request.requestBody != null && request.requestBody.size() > 0) {
            try {
                IdealistaLeadsWrapper leadsWrapper = IdealistaLeadsWrapper.parse(request.requestBody.toString());

                Set<Id> inmueblesIds = new Set<Id>();
                Set<Id> promoIds = new Set<Id>();
                for(IdealistaLeadsWrapper.CustomerProperties property : leadsWrapper.customerProperties) {
                    if(((Id)property.propertyReference).getSObjectType() == Product2.getSObjectType())
                        inmueblesIds.add(property.propertyReference);
                	if(((Id)property.propertyReference).getSObjectType() == Promocion__c.getSObjectType())
                        promoIds.add(property.propertyReference);
                }
				
                Map<Id, Product2> inmuebles = new Map<Id, Product2>([SELECT Id, Promocion__c FROM Product2 WHERE Id IN :inmueblesIds]);
                Map<Id, Promocion__c> promociones = new Map<Id, Promocion__c>([SELECT Id FROM Promocion__c WHERE Id IN :promoIds]);
            	
                
                List<Lead> newLeadsList = new List<Lead>();
                for(IdealistaLeadsWrapper.CustomerProperties property : leadsWrapper.customerProperties) {
                    for(IdealistaLeadsWrapper.PropertyLeads l : property.propertyLeads) {
                        Lead newLead = new Lead (
                            LeadSource = 'Idealista',
                            FirstName = l.leadContactName,
                            LastName = l.leadContactName,
                            Email = l.leadContactEmail,
                            MobilePhone = l.leadContactPhone,
                            Status = 'Cliente Potencial',
                            Description = l.leadMessage,
                            // Id_promocion_web_to_lead__c =  inmuebles.get(property.propertyReference).Promocion__c,
                            //LastTransferDate = l.leadDate
                            Promocion__c = inmuebles.containsKey(property.propertyReference) ? inmuebles.get(property.propertyReference).Promocion__c : promociones.containsKey(property.propertyReference) ? promociones.get(property.propertyReference).Id : null,
                            Title = 'Idealista: ' + l.leadContactName,
                            EmailPromocion__c = l.leadContactEmail + (inmuebles.containsKey(property.propertyReference) ? inmuebles.get(property.propertyReference).Promocion__c : promociones.containsKey(property.propertyReference) ? promociones.get(property.propertyReference).Id : null)
                        );
                        if(String.isEmpty(l.leadContactName)){
                            newLead.LastName = l.leadContactEmail;
                            newLead.FirstName = l.leadContactEmail;
                        }
                        newLeadsList.add(newLead);
                    }
                }
                
                if(!newLeadsList.isEmpty()) upsert newLeadsList EmailPromocion__c;

                insert generateLog('CargaLeadsIdealista', null, null, 'Se han importado correctamente ' + newLeadsList.size() + ' candidatos', 'INTEGRACION IDEALISTA');
                response.statusCode = 201;
            } catch(Exception e) {
                response.statusCode = 500;
                response.responseBody = Blob.valueOf('Error: ' + e.getMessage() + '\nTraza: ' + e.getStackTraceString());
                insert generateLog('CargaLeadsIdealista', null, null, 'Error: ' + e.getMessage() + '\nTraza: ' + e.getStackTraceString(), 'INTEGRACION IDEALISTA');
            }
        } else {
            response.statusCode = 500;
            response.responseBody = Blob.valueOf('JSON no encontrado');
        }
    }

    public static Log__c generateLog( String nombreMetodo, String idCuenta, String mensajeEnviado, String resultado, String aplicacion) {
        Log__c log = new Log__c();
        log.Aplicacion__c = aplicacion;
        log.name = nombreMetodo;
      	log.Identificador__c = idCuenta;
        log.MensajeEnviado__c = String.isNotBlank(mensajeEnviado) ? mensajeEnviado.abbreviate(130000) : '';
        log.MensajeRecibido__c = String.isNotBlank(resultado) ? resultado.abbreviate(130000) : '';
        return log;
    }

}