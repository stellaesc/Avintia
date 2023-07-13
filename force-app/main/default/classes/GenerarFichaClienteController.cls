public class GenerarFichaClienteController {

    @auraEnabled
     public static String getUrl(){
        String dominio = System.URL.getSalesforceBaseUrl().toExternalForm() + '/'; 
        return (dominio);
    }

    @auraEnabled
     public static String getCongaTemplateId(){
        APXTConga4__Conga_Template__c CongaTemplateId = [SELECT Id FROM APXTConga4__Conga_Template__c WHERE APXTConga4__Name__c = 'FichaCliente'];
        return (CongaTemplateId.Id);
    }    
    
    
    @auraEnabled
    public static Boolean generarFichaCliente(Id leadId){
    
    	/**List<ContentDocumentLink> listaDocumentos = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: leadId];
        
        Set<id> setIdDocumentos = new Set<id>();
        system.debug('1');
       
        
        for(integer i = 0; i < listaDocumentos.size(); i++){
            
            setIdDocumentos.add(listaDocumentos[i].ContentDocumentId);
        }
        
         List<ContentVersion> listaContenidoDocumentos = [SELECT id FROM ContentVersion WHERE ContentDocumentId IN : setIdDocumentos];
         system.debug('2');**/

            guardarFichaCliente(leadId); 
            return true;
      
    
    }
    
    
    
    public static void guardarFichaCliente(Id leadId){
         
         
     PageReference pdfPage; 
     pdfPage = new PageReference('/apex/FichaCliente');
     pdfPage.getParameters().put('Id', leadId);
     system.debug(leadId);
        
     ContentVersion cv = new ContentVersion();
 
        cv.title = 'Ficha Cliente';
        cv.PathOnClient = 'file.pdf';
        system.debug('llega aqui');
            if(Test.isRunningTest()){
                
                 cv.VersionData = blob.valueOf('Unit.Test');
            }
            else{
                 system.debug('antes de la llamada');
                 cv.VersionData = pdfPage.getContentAsPdf();
                 system.debug('despues');
            }
           
            
        
        insert cv;
        
        ContentVersion cv2 = [SELECT ContentDocumentId, Title, VersionData FROM ContentVersion WHERE id = :cv.id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cv2.ContentDocumentId;
            cdl.LinkedEntityId = leadId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
        
        insert cdl; 

     }
    
    
}