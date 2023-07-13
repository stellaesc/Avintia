@RestResource(urlMapping = '/UpdAccounts/v1/*')
global with sharing class ActualizarClienteWSV1 {
    
    /*@HttpPost
    global static void uppAccount() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        if(request.requestBody != null && request.requestBody.size() > 0) {
            String csvBody = request.requestBody.toString();
            List<String> csvRows = csvBody.split('\n');
            Set<String> idAccs = new Set<String>();
            System.debug('csvRows: ' + csvRows);
            Boolean isFirstRow = true;
            Boolean isErr = false;
            for(String row : csvRows) {
                if(!isFirstRow) {
                    System.debug('row: ' + row);
                    List<String> csvColumns = row.split('\\|');
                    if(csvColumns.size() == 8) {
                        idAccs.add(csvColumns.get(1));
                    }
                }
                isFirstRow = false;
            }
            List<Account> accUpd = [SELECT Id, N_Documento__pc, N_Documento__c, Respuesta_alta_PBC__c, Nivel_Riesgo_PBC__c, Comentarios_PBC__c
                                    FROM Account WHERE N_Documento__pc in: idAccs OR N_Documento__c in: idAccs];
            
            for(String row : csvRows) {
                if(!isFirstRow) {
                    System.debug('row: ' + row);
                    List<String> csvColumns = row.split('\\|');
                    if(csvColumns.size() >= 9) {
                        for(Account acc : accUpd){
                            if(csvColumns.get(1) == acc.N_Documento__c || csvColumns.get(1) == acc.N_Documento__pc){
                                acc.Nivel_Riesgo_PBC__c = csvColumns.get(3);
                                acc.Comentarios_PBC__c = csvColumns.get(9);
                            }
                        }
                    }
                }
                isFirstRow = false;
            }
            
            if(!isErr) response.statusCode = 201;

        } else response.statusCode = 404;
    }*/

}