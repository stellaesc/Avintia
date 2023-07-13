@RestResource(urlMapping = '/AmlAlerts/v1/*')
global with sharing class AmlAlertsManagerV1 {

    /*@HttpPost
    global static void createAlert() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        if(request.requestBody != null && request.requestBody.size() > 0) {
            String csvBody = request.requestBody.toString();
            List<String> csvRows = csvBody.split('\n');
            System.debug('csvRows: ' + csvRows);
            List<AML_Alerts__c> alertsList = new List<AML_Alerts__c>();
            Map<String, Account> accsMap = getAccountIds(csvRows);
            System.debug('   ' + accsMap);
            Boolean isFirstRow = true;
            Boolean isErr = false;
            for(String row : csvRows) {
                if(!isFirstRow) {
                    System.debug('row: ' + row);
                    List<String> csvColumns = row.split('\\|');
                    if(csvColumns.size() >= 9) {
                        Account acc = accsMap.get(csvColumns.get(6));
                        if(acc != null) {
                            String createdDateStr = csvColumns.get(3);
                            String stringDate = createdDateStr.substring(6,10) + '-' + 
                                            createdDateStr.substring(3,5) + '-' +
                                            createdDateStr.substring(0,2) + ' ' +
                                            createdDateStr.substring(11,19);
                            DateTime created = DateTime.valueOf(stringDate);

                            String modifiedDateStr = csvColumns.get(4);
                            stringDate = modifiedDateStr.substring(6,10) + '-' + 
                                            modifiedDateStr.substring(3,5) + '-' +
                                            modifiedDateStr.substring(0,2) + ' ' +
                                            modifiedDateStr.substring(11,19);
                            DateTime modified = DateTime.valueOf(stringDate);
                            AML_Alerts__c alert = new AML_Alerts__c(
                                AccountId__c = accsMap.get(csvColumns.get(6)).Id,
                                ExternalId__c = csvColumns.get(0),
                                Name = csvColumns.get(1),
                                Status__c = csvColumns.get(2),
                                AMLCreatedDate__c = created,
                                AMLLastModifiedDate__c = modified,
                                ExternalAccountNum__c = csvColumns.get(5),
                                OfficialAccountNum__c = csvColumns.get(6),
                                OfficalAccountIdType__c = csvColumns.get(7),
                                Confirmed__c = csvColumns.get(8),
                                PublicComments__c = csvColumns.size() == 10 ? csvColumns.get(9) : ''
                            );
                            alertsList.add(alert);
                        }
                    } else {
                        isErr = true;
                        response.statusCode = 404;
                        break;
                    }
                }

                isFirstRow = false;
            }

            if(!isErr) response.statusCode = 201;
            if(alertsList.size() > 0) {
                upsert alertsList ExternalId__c;                
            }
        } else response.statusCode = 404;
    }

    @TestVisible
    private static Map<String, Account> getAccountIds(List<String> csvRows) {
        System.debug('csvRows en getAccountsIds: ' + csvRows);
        Set<String> accountsIds = new Set<String>();
        Boolean isFirstRow = true;
        for(String row : csvRows) {
            if(!isFirstRow) {
                List<String> csvColumns = row.split('\\|');
                if(csvColumns.size() >= 9) {
                    accountsIds.add(csvColumns.get(6));
                }
            }
            isFirstRow = false;
        }
        System.debug('accountsIds: ' + accountsIds);

        List<Account> accounts = [SELECT Id,N_Documento__c,N_Documento__pc FROM Account WHERE (N_Documento__pc IN :accountsIds OR N_Documento__c IN :accountsIds)];
        Map<String, Account> accsMap = new Map<String, Account>();

        for(Account acc : accounts) {
            if(!String.isBlank(acc.N_Documento__c)) accsMap.put(acc.N_Documento__c, acc);
            if(!String.isBlank(acc.N_Documento__pc)) accsMap.put(acc.N_Documento__pc, acc);
        }

        return accsMap;
    }*/

}