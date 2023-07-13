/**
 * Implementa una capa de abstracción que facilita la implementación
 * del parseo de los parámetros que se mandan en los servicios REST de
 * Salesforce versionados.
 *
 * @author Daniel González <dgonzalezantona@deloitte.es>
 */

public class DTT_VersionedRestRequestParameters {
    private Map<String, Object> parameters = new Map<String, Object>();

    public void add(String name, Object value) {
        this.parameters.put(name, value);
    }

    public Object get(String name) {
        Object result = null;
        if (this.parameters.containsKey(name)) {
            result = this.parameters.get(name);
        }
        return result;
    }

    public String serialize() {
        return JSON.serialize(parameters);
    }

    public static DTT_VersionedRestRequestParameters deserialize(String serialized) {
        DTT_VersionedRestRequestParameters parameters = new DTT_VersionedRestRequestParameters();
        parameters.parameters = (Map<String, Object>) JSON.deserializeUntyped(serialized);
        return parameters;
    }
}