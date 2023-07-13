public class PlanoTipoInmuebleController {

    public ContentVersion imagen {get;set;}
    public String prefijo {get;set;} 
    public List<ContentDocumentLink> contentDocumentLinks {get;set;}

    public PlanoTipoInmuebleController(ApexPages.StandardController stdController){
        String idInmueble = ApexPages.currentPage().getParameters().get('Id');
        prefijo = '../sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=';
        Product2 inmueble = [SELECT id, tipo_de_inmueble__c FROM Product2 WHERE id = :idInmueble LIMIT 1];
                
        try{
            contentDocumentLinks = [Select ContentDocumentId from ContentDocumentLink where LinkedEntityId =:inmueble.Id];
            if(contentDocumentLinks != null && !contentDocumentLinks.isEmpty()){
                Set<Id> contentDocumentIds = new Set<Id>();
                for (ContentDocumentLink cdl : contentDocumentLinks){
                    contentDocumentIds.add(cdl.ContentDocumentId);
                }
                List<ContentVersion> posiblesImagenes = [Select id from ContentVersion where ContentDocumentId IN: contentDocumentIds AND tipo__c='Plano' order by Posicion__c LIMIT 1];
                if(posiblesImagenes != null && !posiblesImagenes.isEmpty()){
                    imagen = posiblesImagenes.get(0);
                	return;
                }
            }
            contentDocumentLinks=[Select ContentDocumentId from ContentDocumentLink where LinkedEntityId =:inmueble.tipo_de_inmueble__c];
            Set<Id> contentDocumentIds = new Set<Id>();
            for (ContentDocumentLink cdl : contentDocumentLinks){
                contentDocumentIds.add(cdl.ContentDocumentId);
            }
            imagen = [Select id from ContentVersion where ContentDocumentId IN: contentDocumentIds AND tipo__c='Plano' order by Posicion__c LIMIT 1];
        }
        catch(exception e){
            System.debug('Se ha generado la siguiente excepción en la clase PlanoTipoInmuebleController: ' + e.getMessage());
        }
        
        /*try{
            contentDocumentLinks=[Select ContentDocumentId from ContentDocumentLink where LinkedEntityId =:inmueble.tipo_de_inmueble__c];
            System.debug(contentDocumentLinks);
            Set<Id> contentDocumentIds = new Set<Id>();
            for (ContentDocumentLink cdl : contentDocumentLinks){
                contentDocumentIds.add(cdl.ContentDocumentId);
            }
        	//imagen = [Select id from ContentVersion where Tipo_de_inmueble__c =:inmueble.tipo_de_inmueble__c AND tipo__c='Plano' LIMIT 1];
        	imagen = [Select id from ContentVersion where ContentDocumentId IN: contentDocumentIds AND tipo__c='Plano' order by Posicion__c LIMIT 1];
        }
        catch(exception e){
            System.debug('Se ha generado la siguiente excepción en la clase PlanoTipoInmuebleController: ' + e.getMessage());
        }*/
    }
}