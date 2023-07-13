public class AmlCheckOportunidadWSV1 {

   /* private static final String authenticationEndPointUri = '/amlcheck/api/authentication';
    private static final String createProposalEndPointUri = '/amlcheck/api/proposal-generic/';

    private AmlInfo aml;
    private Boolean authenticated;
    private String token;

    public AmlCheckOportunidadWSV1() {
        aml = getAmlInfo();
        authenticated = false;
    }

    public AmlCheckOportunidadWSV1(String token) {
        aml = getAmlInfo();
        authenticated = false;
        setToken(token);
    }

    public void authentication() {
        if(String.isBlank(getToken())) {
            String endpointUrl = aml.url + authenticationEndPointUri;
            String payload = 'j_username=' + aml.user + '&' +
                    'j_password=' + aml.password + '&' +
                    'remember-me=true';

            // Send the request
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(endpointUrl);
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setBody(payload);
            Http http = new Http();
            HttpResponse res = http.send(req);

            System.debug('AML Authentication: ' + res.getBody());
            Integer statusCode = res.getStatusCode();
            if (statusCode == 200) {
                AmlAuthenticationOKResponse response = (AmlAuthenticationOKResponse) JSON.deserialize(res.getBody(), AmlAuthenticationOKResponse.class);
                authenticated = true;
                token = response.id_token;
            } else if (statusCode == 401) {
                AmlAuthenticationErrResponse response = (AmlAuthenticationErrResponse) JSON.deserialize(res.getBody(), AmlAuthenticationErrResponse.class);
                token = null;
                authenticated = false;
                throw new AmlUnauthorizedException(response.error);
            }
        }
    }

    public void createProposal(Opportunity opp) {
        createProposalRequest(opp);
    }

    public void createProposal(Id oppId) {
        Opportunity opp = [SELECT Id, OpportunityNumber__c, CreatedDate, LastModifiedDate, Name, Type, Owner.Name, StageName, Amount, 
                            Account.N_Documento__c, Fecha_Vencimiento__c 
                        FROM Opportunity WHERE Id = :oppId];

        createProposalRequest(opp);
    }

    private void createProposalRequest(Opportunity opp) {
        String endpointUrl = aml.url + createProposalEndPointUri;
        if(opp != null) {
            List<Participante__c> participantes = [SELECT Id, Name, Porcentaje_de_participacion__c,
                    Cliente__c, Cliente__r.N_Documento__c
            FROM Participante__c
            WHERE Opportunity__c = :opp.Id];

            // Montamos la petición
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(endpointUrl);
            req.setHeader('Authorization', 'Bearer ' + getToken());
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CustomerId', '1'); // Siempre valor 1 para AVINTIA (Vaya ÑAPA)

            AmlOppCreationRequestParams requestParams = new AmlOppCreationRequestParams();
            requestParams.proposalNumber = opp.OpportunityNumber__c;
            requestParams.cartera = '01'; // FIXME -> VER DE DONDE SACAR ESTE CAMPO EN SF
            requestParams.sourceSystem = 'ADI-CRM';
            requestParams.manager = opp.Owner.Name;
            requestParams.isFinalStep = false;
            requestParams.link = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.Id;
            requestParams.ammount = opp.Amount;
            requestParams.isOCIApproved = false;
            requestParams.originSystemCreationDate = String.valueOfGmt(opp.CreatedDate).split(' ')[0];
            requestParams.deadline = opp.Fecha_Vencimiento__c != null ? String.valueOfGmt(opp.Fecha_Vencimiento__c) : '1970-01-01'; // FIXME -> QUITAR FECHA CUANDO YA NO SEA OBLIGATORIA
            requestParams.originSystemLastModifiedDate = String.valueOfGmt(opp.LastModifiedDate).split(' ')[0];
            requestParams.expectedSignDate = '1970-01-01'; // FIXME -> QUITAR FECHA CUANDO YA NO SEA OBLIGATORIA
            requestParams.ociapprovedDate = '1970-01-01'; // FIXME -> QUITAR FECHA CUANDO YA NO SEA OBLIGATORIA
            requestParams.proposalType = opp.Type;
            requestParams.previousStep = null;
            requestParams.step = '01'; // FIXME -> VER DE DONDE SACAR ESTE CAMPO EN SF
            requestParams.clientProposals = new List<String>();
            for(Participante__c p : participantes) requestParams.clientProposals.add(p.Cliente__c);
            requestParams.paymentMethodProposals = new List<Map<String, Integer>>();
            requestParams.contractProposals = new List<String>();
            requestParams.inmuebleProposals = new List<String>();
            requestParams.sourceFundProposals = new List<Map<String, Integer>>();

            String payload = JSON.serialize(requestParams);
            System.debug('AML createProposal Payload: ' + payload);
            req.setBody(payload);

            Http http = new Http();
            HttpResponse res = http.send(req);

            System.debug('AML createProposal Response: ' + res.getBody());
            Integer statusCode = res.getStatusCode();
            Boolean statusOk = statusCode >= 200 && statusCode <= 206;
            if(statusOk) {
                opp.Enviado_AML__c = true;
                update opp;
                insertarLog('createProposalRequest', opp.Id, payload, res.getBody());
            } else if(statusCode == 401) {
                AmlAuthenticationErrResponse response = (AmlAuthenticationErrResponse) JSON.deserialize(res.getBody(), AmlAuthenticationErrResponse.class);
                insertarLog('createProposalRequest', opp.Id, payload, res.getBody());
                throw new AmlUnauthorizedException(response.error);
            } else if(!statusOk) {
                insertarLog('createProposalRequest', opp.Id, payload, res.getBody());
                //AmlAuthenticationErrResponse response = (AmlAuthenticationErrResponse) JSON.deserialize(res.getBody(), AmlAuthenticationErrResponse.class);
                throw new AmlInternalServerException(res.getBody());
            }
        }
    }

    private AmlInfo getAmlInfo() {
        PropiedadesIntegracion__c propiedades = PropiedadesIntegracion__c.getInstance();
        AmlInfo info = new AmlInfo();
        info.url = propiedades.URL_AMLCHECK__c;
        info.user = propiedades.UsuarioAMLCHECK__c;
        info.password = propiedades.PasswordAMLCHECK__c;
        return info;
    }

    private void insertarLog(String nombreMetodo, String idOpp, String mensajeEnviado, String resultado) {
        Log__c log = new Log__c();
        log.Aplicacion__c = 'AMLCHECK';
        log.name = nombreMetodo;
        log.Identificador__c = idOpp;
        log.MensajeEnviado__c = mensajeEnviado;
        log.MensajeRecibido__c = resultado;

        insert log;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String tk) {
        token = tk;
    }

    /** Clases Wrappers */
    /*public class Response {
        public Boolean error;
        public String message;
    }

    private class AmlInfo {
        public String url;
        public String user;
        public String password;
    }

    private class AmlAuthenticationOKResponse {
        public String id_token;
    }

    private class AmlAuthenticationErrResponse {
        public DateTime timestamp;
        public Integer status;
        public String error;
        public String message;
        public String path;
    }

    private class AmlOppCreationRequestParams {
        public String proposalNumber; // Obligatorio
        public String cartera;
        public String sourceSystem;
        public String manager;
        public Boolean isFinalStep;
        public String link;
        public Double ammount;
        public Boolean isOCIApproved;
        public String originSystemCreationDate;
        public String deadline;
        public String originSystemLastModifiedDate;
        public String expectedSignDate;
        public String ociapprovedDate;
        public String proposalType;
        public String previousStep;
        public String step;
        public List<String> clientProposals;
        public List<Map<String, Integer>> paymentMethodProposals;
        public List<String> contractProposals;
        public List<String> inmuebleProposals;
        public List<Map<String, Integer>> sourceFundProposals;
    }

    /* EXCEPCIONES */
   // public class AmlUnauthorizedException extends Exception {}
   // public class AmlInternalServerException extends Exception {}

}