/**
 * Implementa una capa de abstracción que facilita la implementación
 * de servicios REST de Salesforce versionados.
 *
 * @author Daniel González <dgonzalezantona@deloitte.es>
 */

@RestResource(urlMapping='/*/*/*')
global abstract class DTT_VersionedRestService {

    public static RestRequest sRestRequest;
    public static RestResponse sRestResponse;

    //public static Map<String, Object> httpGetParams;
    //public static RequestParameters httpPostParams;
    public static DTT_VersionedRestRequestParameters httpParameters;
    public static String restRequestBody;

    /* Recursos del Servicio */
    @HttpGet
    global static Response httpGet() { return getKOResponse(); }

    @HttpPost
    global static Response httpPost() { return getKOResponse(); }

    @HttpPut
    global static Response httpPut() { return getKOResponse(); }

    @HttpPatch
    global static Response httpPatch() { return getKOResponse(); }

    @HttpDelete
    global static Response httpDelete() { return getKOResponse(); }

    /* Métodos de utilidad */

    /**
     * Configura el contexto de la petición REST
     */
    public static void setHttpRequestContext() {
        sRestRequest = RestContext.request;
    }

    /**
     * Configura el contexto de la respuesta REST
     */
    public static void setHttpResponseContext() {
        sRestResponse = RestContext.response;
        sRestResponse.addHeader('Content-Type', 'application/json');
    }

    /**
     * Añade una cabecera a la respuesta REST
     */
    public static void addHttpResponseHeader(String header, String value) {
        sRestResponse.addHeader(header, value);
    }

    /**
     * Configura los parámetros que llegan por método GET
     */
    public static void setHttpGetParams(List<String> params) {
        if(httpParameters == null) httpParameters = new DTT_VersionedRestRequestParameters();
        for(String param : params) {
            String value = sRestRequest.params.get(param);
            httpParameters.add(param, value);
        }
    }

    /**
     * Devuelve el valor del párametro GET pasando como parámetro la clave del parámetro.
     */
    public static Object getHttpGetParam(String p) {
        return httpParameters.get(p);
    }

    /**
     * Configura los parámetros que llegan por método POST
     */
    public static void setHttpPostJSONParams() {
        if(sRestRequest.requestBody != null){
            restRequestBody = sRestRequest.requestBody.toString();
            httpParameters = DTT_VersionedRestRequestParameters.deserialize(restRequestBody);
        }
    }

    public static DTT_VersionedRestRequestParameters getHttpPostParams() {
        return httpParameters;
    }

    /**
     * Configura el código de estado HTTP de la respuesta REST
     */
    public static void setHttpResponseStatusCode(Integer code) {
        sRestResponse.statusCode = code;
    }

    /**
     * Configura el cuerpo de la respuesta
     *
     * @param body
     */
    public static void setHttpResponseBody(Blob body) {
        sRestResponse.responseBody = body;
    }

    /**
     * Obtiene una respuesta de Error
     */
    public static Response getKOResponse() {
        KOResponse response = new KOResponse();
        response.status = 'ERR-01';
        response.message = 'No existe esa versión del servicio. Por favor consume una versión existente';
        return response;
    }

    /**
     * Obtiene una respuesta de método no implementado
     */
    public static Response getNotImplementedResponse() {
        KOResponse response = new KOResponse();
        response.status = 'ERR-02';
        response.message = 'Método no implementado aún.';
        return response;
    }


    /* Clases que representan respuestas */
    global virtual class Response { public String status; }
    global virtual class OKResponse extends Response {}
    global virtual class KOResponse extends Response { public String message; }
}