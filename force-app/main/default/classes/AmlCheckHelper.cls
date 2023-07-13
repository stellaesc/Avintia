/**
@description
<pre>
Clase helper para realizar llamadas al WS de AMLCheck</br>
DATE       	AUTHOR     	DESCRIPTION<br/>
04/01/2021 	LCS - JZD   Created.        
26/03/2021  LCS - JZD   Añadido método para llamar a AML Check a no futuro cuando se invoca desde el batch                  
</pre>
@author Leadclic Solutions
@date 04/01/2021
*/
public class AmlCheckHelper {

    /*private static final Id CUENTA_PERSONAL  = SObjectUtils.getRecordTypeId(Account.sObjectType, 'PersonAccount');
    private static final Id CUENTA_EMPRESA  = SObjectUtils.getRecordTypeId(Account.sObjectType, 'Cuenta');

    @AuraEnabled
    public static String getCurrentProfile() {
        Profile p = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        return p.Name;
    }

    @AuraEnabled
    public static List<Id> getAmlCheckOldAccounts() {
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id,Name,FirstName 
                                                          FROM Account 
                                                          WHERE RecordTypeId IN (:CUENTA_PERSONAL, :CUENTA_EMPRESA) AND EnviadoAmlCheck__c = false AND
                                                          (CNAE__c != null OR CNO__c != null OR Situacion_laboral__c != null)]);
        List<Id> accsIds = new List<Id>(accounts.keySet()); 
        return accsIds;
    }

    @future(callout = true)
    @AuraEnabled
    public static void envioClienteAmlCheckFuture(List<Id> accsIds, Boolean isInsert) {
        envioClienteAmlCheck(accsIds, isInsert);
    }
    
    public static void envioClienteAmlCheck(List<Id> accsIds, Boolean isInsert) {

        PropiedadesIntegracion__c propiedades = PropiedadesIntegracion__c.getInstance();
        AmlCheckClienteWS clienteConnection = new AmlCheckClienteWS();       

        List<Account> cuentas = [SELECT ID, RecordTypeId, Name, FirstName, LastName, Suffix, Tipo_de_documento__c, N_Documento__c, Sexo__pc, 
                                    Nacionalidad__r.Codigo_ISO3__c, Nacionalidad__pr.Codigo_ISO3__c, Pais_nacimiento__pr.Codigo_ISO3__c , 
                                    DP_Pais__r.Codigo_ISO3__c ,Fecha_constitucion__c, PersonBirthdate, 
                                    Situacion_laboral__c, DFI_Provincia__c, CNAE__c, CNO__c, CNAE__r.Codigo__c, CNO__r.Codigo__c
                                  FROM  Account 
                                  WHERE ID IN :accsIds];
        
        List<String> errors = new List<String>();
        List<Account> accs2Upd = new List<Account>();
        AmlCheckClienteWS.AmlCheckParams params;
        for(Account acc : cuentas) {
            try {
                params = new AmlCheckClienteWS.AmlCheckParams(); 
                AmlCheckClienteWS.Respuesta respuesta = new AmlCheckClienteWS.Respuesta();
                String tipoDocumento = '';
                String genero = '';
                
                // Comprobamos campos obligatorios de AML
                if(String.isBlank(acc.CNO__c) && String.isBlank(acc.CNAE__c) && String.isBlank(acc.Situacion_laboral__c)) {
                    errors.add('La cuenta ' + acc.Name + ' (' + acc.Id + ') no tiene relleno al menos uno de los siguientes campos: CNO, CNAE o Sitúación laboral');
                    continue;
                }

                // Se mapea el tipo de documento con la lista de valores de AML-CHECK
                tipoDocumento = AmlCheckClienteWS.docTypeMapping(acc.Tipo_de_documento__c);

                // Se mapea el género con la lista de valores de AML-CHECK
                genero = AmlCheckClienteWS.genderMapping(acc.Sexo__pc);

                // Hacemos la llamada
                System.debug('Se va a proceder a realizar el envío');
                if(acc.RecordTypeId.equals(CUENTA_PERSONAL)) {
                    System.debug('cuenta personal');
                    System.debug(acc.ID);
                    params.orisys = 'ADI-CRM';
                    params.persnume = String.valueOf(acc.ID);
		            params.perscodi = tipoDocumento;
		            params.persiden = acc.N_Documento__c == null ? '' : acc.N_Documento__c;
		            params.apellido1 = acc.LastName;
		            params.apellido2 = acc.Suffix == null ? '' : acc.Suffix;
		            params.nombre = String.isBlank(acc.FirstName) ? acc.LastName : acc.FirstName;
		            params.gender = String.isBlank(genero) ? '' : genero;
		            params.persnaci = acc.Nacionalidad__pr.Codigo_ISO3__c == null ? '' : acc.Nacionalidad__pr.Codigo_ISO3__c;
		            params.persnaci2 = '';
		            params.persnac = acc.Pais_nacimiento__pr.Codigo_ISO3__c == null ? '' : acc.Pais_nacimiento__pr.Codigo_ISO3__c;
		            params.perspais = acc.DP_Pais__r.Codigo_ISO3__c == null ? '' : acc.DP_Pais__r.Codigo_ISO3__c;
		            params.perspais2 = '';
		            params.persfiju = 'F';
		            params.persfnac = acc.PersonBirthdate == null ? '' : String.valueOf(acc.PersonBirthdate);
		            params.usertokenid = '';
                    params.dacosila = acc.Situacion_laboral__c;
                    params.persprof = acc.CNO__r.Codigo__c;
                    params.perscnae = acc.CNAE__r.Codigo__c;

                    // Comprobamos si están rellenos los campos obligatorios
                    checkRequiredParams(params);

                    if(!Test.isRunningTest()) respuesta = clienteConnection.onboardingRBA(params, isInsert);
                    else {
                        System.debug('entra test cuenta personal');
                        respuesta.returnCode = '0';
                        respuesta.returnCodeDescription = 'OK';		
                        respuesta.persiden = '0000001A';
                        respuesta.idalerta = '0';
                        respuesta.idevidencia = '0';
                        respuesta.rbalevel = 'risk.2.medium';
                        respuesta.rbarulecode = '';
                        respuesta.rbarulecodedesc = '';
                        respuesta.manualGlobalRisk = 'risk.2.medium';
                    }
                    System.debug(acc.ID);
                } else {
                    System.debug('Cuenta empresa');
                    params.orisys = 'ADI-CRM';
                    params.persnume = String.valueOf(acc.ID);
                    params.perscodi = tipoDocumento;
		            params.persiden = acc.N_Documento__c == null ? '' : acc.N_Documento__c;
		            params.apellido1 = '';
		            params.apellido2 = '';
		            params.nombre = acc.Name;
		            params.gender = '';
		            params.persnaci = acc.Nacionalidad__r.Codigo_ISO3__c == null ? '' : acc.Nacionalidad__r.Codigo_ISO3__c;
		            params.persnaci2 = '';
		            params.persnac = '';
		            params.perspais = '';
		            params.perspais2 = '';
		            params.persfiju = 'J';
		            params.persfnac = acc.Fecha_constitucion__c == null ? '' : String.valueOf(acc.Fecha_constitucion__c);
		            params.usertokenid = '';
                    params.dacosila = acc.Situacion_laboral__c;
                    params.persprof = acc.CNO__r.Codigo__c;
                    params.perscnae = acc.CNAE__r.Codigo__c;

                    // Comprobamos si están rellenos los campos obligatorios
                    checkRequiredParams(params);

                    if(!Test.isRunningTest()) respuesta = clienteConnection.onboardingRBA(params, isInsert);
                    else {
                        respuesta.returnCode = '0';
                        respuesta.returnCodeDescription = 'OK';		
                        respuesta.persiden = '0000001A';
                        respuesta.idalerta = '0';
                        respuesta.idevidencia = '0';
                        respuesta.rbalevel = 'risk.2.medium';
                        respuesta.rbarulecode = '';
                        respuesta.rbarulecodedesc = '';
                        respuesta.manualGlobalRisk = 'risk.2.medium';
                    }
                }

                if(respuesta != null) {
                    System.debug('Cuenta ' + acc.Name + ' (' + acc.Id + ') insertada en AML');

                    if(String.isNotBlank(respuesta.returnCode)) { 
                        Account cuenta = new Account( 
                            Id = acc.Id,
                            Respuesta_alta_PBC__c = respuesta.returnCode
                        );

                        if(respuesta.returnCode == '2' && cuenta.IsPersonAccount){
                            cuenta.PEP__pc = true;
                        }
                        if (respuesta.returnCode == '0' || respuesta.returnCode == '1' || respuesta.returnCode == '2' || respuesta.returnCode == '3') {
                            cuenta.EnviadoAmlCheck__c = true;
                            if(isInsert){
                                cuenta.Nivel_Riesgo_PBC__c = respuesta.returnCode == '0' ? respuesta.rbalevel : 'risk.2.medium';
                            } else {
                                cuenta.Nivel_Riesgo_PBC__c = respuesta.manualGlobalRisk;
                            }
                            accs2Upd.add(cuenta);
                        }                          
                    }
                }
            } catch(AmlCheckClienteWS.AmlAlreadyExistException e) {
                AmlCheckClienteWS.Respuesta respuesta = AmlCheckClienteWS.getClient(params);
                Account cuenta = new Account(
                    Id = acc.Id,
                    EnviadoAmlCheck__c = true,
                    Respuesta_alta_PBC__c = respuesta.returnCode,
                    Nivel_Riesgo_PBC__c = respuesta.manualGlobalRisk != null ? respuesta.manualGlobalRisk : respuesta.rbalevel
                );
                accs2Upd.add(cuenta);
                continue;
            } catch(AmlCheckClienteWS.AmlNoExistException e) {
                System.debug('No se ha podido enviar la cuenta a AMLCHECK. Error: ' + e.getMessage());
                errors.add(e.getMessage());
                continue;
            } catch(AmlCheckClienteWS.AmlNoExistParamsException e) {
                System.debug('No se ha podido enviar la cuenta a AMLCHECK. Error: ' + e.getMessage());
                errors.add(e.getMessage());
                continue;
            } catch(AmlCheckClienteWS.AmlRequiredParamsException e) {
                System.debug('No se ha podido enviar la cuenta a AMLCHECK. Error: ' + e.getMessage());
                errors.add(e.getMessage());
                continue;
            } catch(CalloutException e) {
                System.debug('No se ha podido enviar la cuenta a AMLCHECK. Error: ' + e.getMessage());
                errors.add(e.getMessage());
                continue;
            } catch( Exception e ) {
                System.debug('No se ha podido enviar la cuenta a AMLCHECK. Error: ' + e.getMessage() + ' | Traza: ' + e.getStackTraceString());
                errors.add(e.getMessage());
                continue;
            }
        }

        if(!accs2Upd.isEmpty()) {
            System.debug('Cuentas a actualizar por inserción en AML: ' + accs2Upd);
            TriggerHandler.bypass('AccountTriggerHandler');
            update accs2Upd;
            TriggerHandler.clearBypass('AccountTriggerHandler');
        }

        if(!errors.isEmpty()) {
            String errorsStr = String.join(errors, '\n\r');
            throw new CalloutException(errorsStr);
        }
    }

    private static void checkRequiredParams(AmlCheckClienteWS.AmlCheckParams params) {
        Boolean condition = String.isBlank(params.persnume) || String.isBlank(params.perscodi) ||
                String.isBlank(params.persiden) || String.isBlank(params.nombre) || String.isBlank(params.persnaci);
        if(params == null) throw new AmlCheckClienteWS.AmlNoExistParamsException('No se han encontrado parámetros');
        else if(condition) throw new AmlCheckClienteWS.AmlRequiredParamsException('Falta alguno de los siguientes párametros obligatorios: PERSNUME, PERSCODI, PERSIDEN, NOMBRE o PERSNACI');
    }*/
}