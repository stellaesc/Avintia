global class CargaLeadFotocasa implements Schedulable{

    global void execute(SchedulableContext ctx){
        system.debug('Realizamos la llamada al metodo encargado de cargar los Lead en Salesforce');
        cargarLeadSalesforce();  
    }

    @future (callout=true)
    public static void cargarLeadSalesforce(){
        CNO__c cnoObj = [SELECT Id FROM CNO__c WHERE Codigo__c = '1212'];

        PropiedadesIntegracion__c propiedadesIntegracion = PropiedadesIntegracion__c.getInstance();
        String hoy = (String.valueof(Date.today()));
        String ayer = (String.valueof(Date.today() - Integer.valueof(propiedadesIntegracion.NumDiasLeadFotocasa__c)));
        String username = propiedadesIntegracion.UsuarioLeadFotocasa__c;
        String password = propiedadesIntegracion.PasswordLeadFotocasa__c;

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(propiedadesIntegracion.URL_LEAD_FOTOCASA__c+'?startDate='+ayer+'&endDate='+hoy);
        system.debug(propiedadesIntegracion.URL_LEAD_FOTOCASA__c+'?startDate='+ayer+'&endDate='+hoy);
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        Http http = new Http();
        HttpResponse res;
        //Realizamos el envio de la promocion a Babonlab
        if(!Test.isRunningTest()) res = http.send(req);
        else {
            res = new HttpResponse();
            List<Product2> viviendas = [SELECT Id FROM Product2 LIMIT 1];
            res.setStatusCode(200);
            res.setBody('[ { "Id": 8765680, "PropertyId": 148605299, "TransactionTypeId": 1, "Reference":"' +viviendas.get(0).Id+'", "Name": "PruebaTest", "Phone": "666123123", "Email": "correo@correo.es", "Comments": "Me gustaría recibir más información de este Piso", "Date": "2019-03-25T17:41:36.353" } ]');
        }
        
        if (res != null && res.getStatusCode() != null && res.getStatusCode() == 200) {
            DummyLeadRespuesta[] respuesta = (DummyLeadRespuesta[]) JSON.deserialize(res.getBody(), DummyLeadRespuesta[].class);
            system.debug('Han llegado '+respuesta.size()+ ' Lead');

            // Recorremos los resultados para buscar su correspondiente promocion
            Set<String> setViviendas = new Set<String>();
            Set<String> setPromos = new Set<String>();
            for(integer i = 0; i < respuesta.size(); i++) {
                if(!respuesta.get(i).Reference.equals('')) {
                    if(((Id)respuesta.get(i).Reference).getSObjectType() == Product2.getSObjectType())
                    	setViviendas.add(respuesta.get(i).Reference);
                    if(((Id)respuesta.get(i).Reference).getSObjectType() == Promocion__c.getSObjectType())
                        setPromos.add(respuesta.get(i).Reference);
                }         
            }
            system.debug(setViviendas);

            if(!setViviendas.isEmpty()) {
                List<Product2> viviendas = [SELECT Id, Promocion__c FROM Product2 WHERE Id IN :setViviendas];
                Map<Id, Promocion__c> promociones= new Map<Id, Promocion__c>([Select Id from Promocion__c where Id in:setPromos]);
                List<Lead> leads = new List<Lead>();
                for(Product2 vivienda : viviendas) {
                    for(integer i = 0; i < respuesta.size(); i++) {   
                        Lead lead = new Lead();
                        if(!respuesta.get(i).Reference.equals('') && respuesta.get(i).Reference.equals(vivienda.Id)) {
                            lead.LastName = respuesta.get(i).Name;
                            lead.Email = respuesta.get(i).Email;
                            lead.Phone = respuesta.get(i).Phone;
                            lead.Description = respuesta.get(i).Comments;
                            lead.LeadSource = 'Fotocasa';
                            lead.Promocion__c = vivienda.Promocion__c;
                            lead.CNO__c = cnoObj.Id;
                            leads.add(lead);
                        } else if(!respuesta.get(i).Reference.equals('') && promociones.containsKey(respuesta.get(i).Reference)){
                            lead.LastName=respuesta.get(i).Name;
                            lead.Email= respuesta.get(i).Email;
                            lead.Phone=respuesta.get(i).Phone;
                            lead.Description=respuesta.get(i).Comments;
                            lead.LeadSource='Fotocasa';
                            lead.Promocion__c= promociones.get(respuesta.get(i).Reference).Id;
                            lead.CNO__c = cnoObj.Id;
                            leads.add(lead);
                        }
                        
                    }
                }

                if(!leads.isEmpty()) {
                    List<Database.SaveResult> results = Database.insert(leads, false);
                    String errorLogMsg = '';
                    Integer successNum = 0;
                    for(Database.SaveResult r : results) {
                        if(!r.isSuccess()) {
                            for(Database.Error err : r.getErrors()) {
                                errorLogMsg += '--- ERROR ----\n\r';
                                errorLogMsg += err.getMessage() + '\n\r';
                                errorLogMsg += 'Se ha producido en los siguientes campos: ' + err.getFields() + '\n\r\n\r';
                            }
                        } else successNum++;
                    }
                    String logMsg = 'Se han intentado importar ' + leads.size() + ' candidatos y se han importado correctamente ' + successNum + '\n\r';
                    logMsg += errorLogMsg;

                    insert generateLog('CargaLeadsFotocasa', null, null, logMsg, 'INTEGRACION FOTOCASA');
                }
            }
        } else insert generateLog('CargaLeadsFotocasa', null, null, res.getBody(), 'INTEGRACION FOTOCASA');


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

    public class DummyLeadRespuesta{
        public Integer Id;
        public Integer PropertyId;
        public Integer TransactionTypeId;
        public String Reference;
        public String Name;
        public String Phone;
        public String Email;
        public String Comments;

    }


}