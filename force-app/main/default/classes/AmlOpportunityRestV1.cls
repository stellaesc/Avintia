/**
 * Implementa los servicios que serán consumidos por AML
 * para registrar datos de PBC en las Oportunidades
 *
 * @author Daniel González <dgonzalezantona@deloitte.es>
 */

@RestResource(urlMapping='/AML/v1/Opportunity')
global class AmlOpportunityRestV1 extends DTT_VersionedRestService {

    /* Recursos del Servicio */
   /* @HttpPost
    global static Response httpPost() {
        setHttpRequestContext();
        setHttpResponseContext();
        setHttpPostJSONParams();
        DTT_VersionedRestRequestParameters postParams = (DTT_VersionedRestRequestParameters) getHttpPostParams();

        if(postParams != null) {
            if(String.isBlank((String) postParams.get('proposalNumber'))) {
                setHttpResponseStatusCode(404);
                KOResponse koResp = new KOResponse();
                koResp.status = 'ERR';
                koResp.message = 'El parámetro proposalNumber es obligatorio';
                return koResp;
            }
            try {
                String proposalNumber = (String) postParams.get('proposalNumber');
                List<Opportunity> opps = [
                        SELECT Id, Resultado_PBC__c, Riesgo_PBC_Operacion__c, Observaciones_Resultado_PBC__c
                        FROM Opportunity
                        WHERE OpportunityNumber__c = :proposalNumber
                ];
                if(opps.size() == 0) {
                    setHttpResponseStatusCode(404);
                    KOResponse koResp = new KOResponse();
                    koResp.status = 'ERR';
                    koResp.message = 'No hay ninguna oportunidad con ese proposalNumber';
                    return koResp;
                }

                Opportunity opp = opps.get(0);
                opp.Resultado_PBC__c = (String) postParams.get('manualStatus');
                opp.Riesgo_PBC_Operacion__c = (String) postParams.get('manualRisk');
                opp.Observaciones_Resultado_PBC__c = (String) postParams.get('comments')+ '\n\n' +
                        (String) postParams.get('resolution')+ '\n\n' +
                        (String) postParams.get('conditions');
                update opp;

                setHttpResponseStatusCode(201);
                return null;
            } catch(CalloutException e) {
                setHttpResponseStatusCode(500);
                KOResponse koResp = new KOResponse();
                koResp.status = 'ERR';
                koResp.message = 'Se ha producido un error interno en el servidor. Por favor, contacta con la administración';
                return koResp;
            }
        } else {
            setHttpResponseStatusCode(404);
            KOResponse koResp = new KOResponse();
            koResp.status = 'ERR';
            koResp.message = 'No se ha encontrado párametros de entrada';
            return koResp;
        }
    }*/

}