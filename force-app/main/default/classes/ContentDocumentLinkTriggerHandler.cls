/**
 * Created by dgonzalezantona on 02/10/2019.
 */

public class ContentDocumentLinkTriggerHandler extends TriggerHandler {

    protected override void afterInsert() {
        actualizaTrasFirmaDeContrato((Map<Id, ContentDocumentLink>) Trigger.NewMap);
    }

    private void actualizaTrasFirmaDeContrato(Map<Id,ContentDocumentLink> linksMap) {
        Set<Id> linksIds = linksMap.keySet();
        Set<Id> contentDocumentsIds = new Set<Id>();
        Set<Id> linkedEntitiesIds = new Set<Id>();
        for(Id linkId : linksIds) {
            ContentDocumentLink link = linksMap.get(linkId);
            contentDocumentsIds.add(link.ContentDocumentId);
            linkedEntitiesIds.add(link.LinkedEntityId);
        }

        List<ContentVersion> files = [SELECT Id,ContentDocumentId,Title
                                      FROM ContentVersion 
                                      WHERE ContentDocumentId IN :contentDocumentsIds];
        
        Map<Id, ContentVersion> linkWithContentVersionMap = new Map<Id, ContentVersion>();
        for(Id linkId: linksIds) {
            ContentDocumentLink link = linksMap.get(linkId);
            for(ContentVersion file : files) {
                if(link.ContentDocumentId == file.ContentDocumentId) linkWithContentVersionMap.put(link.LinkedEntityId, file);
            }
        }
        
		List<HelloSign__HelloSign_Signature_Request__c> HelloSignStatuses = [SELECT Id, HelloSign__Opportunity__c
                                                           					FROM HelloSign__HelloSign_Signature_Request__c
                                                           					WHERE Id IN :linkedEntitiesIds AND
                                                           					HelloSign__Latest_Action__c = 'Signature Completed' AND
                                                           					HelloSign__Opportunity__c != null];
        Map<Id, HelloSign__HelloSign_Signature_Request__c> HelloSignStatusMap = new Map<Id, HelloSign__HelloSign_Signature_Request__c>(HelloSignStatuses);

        // Comprobamos estado de la firma y si es completo lo añadimos para actualizar
        Set<Id> idsOportunidadesFichaReserva = new Set<Id>();
        Set<Id> idsOportunidadesCompraVenta = new Set<Id>();
        for(Id helloSignStatusId : HelloSignStatusMap.keySet()) { HelloSign__HelloSign_Signature_Request__c helloSignStatus = HelloSignStatusMap.get(helloSignStatusId);
            ContentVersion file = linkWithContentVersionMap.get(helloSignStatusId);
            if (file.Title.containsIgnoreCase('FichaReserva')) idsOportunidadesFichaReserva.add(helloSignStatus.HelloSign__Opportunity__c);
            else if (file.Title.containsIgnoreCase('Compraventa')) idsOportunidadesCompraVenta.add(helloSignStatus.HelloSign__Opportunity__c);}


        List<Opportunity> opps2Upd = new List<Opportunity>();

        // Reserva
        List<Opportunity> oportunidadesFichaReserva = [SELECT Id,Contrato_Reserva_firmado__c,Fecha_firma_Contrato_Reserva__c, ContratoReservafirmadoHellowSign__c
        FROM Opportunity
        WHERE Id IN :idsOportunidadesFichaReserva];
        System.debug('oportunidadesFichaReserva: ' + oportunidadesFichaReserva);
        for(Opportunity opp : oportunidadesFichaReserva) {
          //  opp.Contrato_Reserva_firmado_DocuSign__c = true;
          	opp.ContratoReservafirmadoHellowSign__c = true;
            opp.Contrato_Reserva_firmado__c = true;
            opp.Fecha_firma_Contrato_Reserva__c = Date.today();
            opps2Upd.add(opp);
        }

        // Compraventa
        List<Opportunity> oportunidadesCompraVenta = [SELECT Id,Contrato_Compraventa_firmado__c,Fecha_firma_Contrato_Compraventa__c, ContratoCompraventafirmadoHelloSIgn__c
        FROM Opportunity
        WHERE Id IN :idsOportunidadesCompraVenta];
        System.debug('oportunidadesCompraVenta: ' + oportunidadesCompraVenta);
        for(Opportunity opp : oportunidadesCompraVenta) { 	opp.ContratoCompraventafirmadoHelloSIgn__c = true;
            opp.Contrato_Compraventa_firmado__c = true;
            opp.Fecha_firma_Contrato_Compraventa__c = Date.today();
            opps2Upd.add(opp);}
        update opps2Upd;
    }
}