public class SliderController {

    public Integer numImagenes {get;set;}
    public List<ContentVersion> imagenes {get;set;}
    public List<ContentDocumentLink> contentDocumentLinks {get;set;}
    public String prefijo {get;set;} 
    

    public SliderController(ApexPages.StandardController stdController){
        
        String idPromocion = ApexPages.currentPage().getParameters().get('Id');
        System.debug(idPromocion);
        numImagenes = 0;

        //Poner como constante
        if(!String.isBlank(idPromocion)) {
            prefijo = '../sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=';
            Set<Id> LinkedEntityIds = new Set<Id>();
            LinkedEntityIds.add(idPromocion);
            contentDocumentLinks = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :idPromocion];
            Set<Id> contentDocumentIds = new Set<Id>();
            for (ContentDocumentLink cdl : contentDocumentLinks) {
                contentDocumentIds.add(cdl.ContentDocumentId);
            }
            imagenes = [
                    SELECT Id
                    FROM ContentVersion
                    WHERE ContentDocumentId IN:contentDocumentIds AND Tipo__c = 'Imagen_carrusel' AND
                    IsLatest = true
                    ORDER BY Posicion__c
            ];

            numImagenes = imagenes.size();
        }
    }
}