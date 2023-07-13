public class AvisoApprovalProcessController {

    @AuraEnabled
    public static String getApproverName(Id promocionId){
        system.debug('getApproverName - promocionId:::'+promocionId);
    	List<ProcessInstanceWorkitem> processInstanceWorkitenList =[SELECT ActorId, ProcessInstance.TargetObjectId 
                                                                    FROM ProcessInstanceWorkitem 
                                                                    WHERE ProcessInstance.TargetObjectId =: promocionId];
        
        system.debug('getApproverName - processInstanceWorkitenList:::'+processInstanceWorkitenList);
        List<User> user = [SELECT Name FROM User WHERE Id =: processInstanceWorkitenList[0].ActorId];
        system.debug('getApproverName - user:::'+user);
        
        if(user.size() > 0){
            return user[0].Name;
        }else{
            system.debug('getApproverName - user');
            return '';
        }
        
        
    }
    
}