/** 
* =====================================================================================
* @className        SObjectUtils
* @description      Utility methods regarding sObject functionality 
* @author           Deloitte
* @testClass        SObjectUtilsTest
* @date created     2018/11/20 
* =====================================================================================
*/
public class SObjectUtils {    

    private static final String SEPARATOR = '-';
    private static Map<String, Id> RECORDTYPE_CACHE;
    /**
        @name           getRecordTypeId
        @description    Method that will update a list of records retrieved from Database, taking values from
                            a list of records
        @params         SObjectType objectType, String developerName
        @returnType     Id
    **/   
    public static Id getRecordTypeId(SObjectType objectType, String developerName) {
        if (RECORDTYPE_CACHE == null) {
            RECORDTYPE_CACHE = new Map<String, Id>();
            for (RecordType rt : [SELECT Id, SObjectType, DeveloperName
                                  FROM RecordType Limit 49999]) {
                RECORDTYPE_CACHE.put(rt.SObjectType + SEPARATOR + rt.DeveloperName, rt.Id);
            }
        }
        
        return RECORDTYPE_CACHE.get( String.valueOf(objectType) + SEPARATOR + developerName );
    }
}