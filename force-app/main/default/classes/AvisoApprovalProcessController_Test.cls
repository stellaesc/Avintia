@isTest
public class AvisoApprovalProcessController_Test {
	
    @isTest
     static void testAdelantarInicioComercializacionPrevista(){

        Map<String, User> usuariosList = TestUtil.crearUsuarios();
        
        date fechaInicioComercializacionPrevista = date.newInstance(2018, 10, 29 );
        date fechaFinComercializacionPrevista = date.newInstance(2018, 12, 12 );

        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);

        // Create an approval request for the Opportunity
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval automatically using Trigger');
        req1.setObjectId(promocion.id);
        req1.setNextApproverIds(new Id[] {usuariosList.values()[0].Id});

        // Submit the approval request for the Opportunity
        Approval.ProcessResult result = Approval.process(req1);

		AvisoApprovalProcessController.getApproverName(promocion.Id);        

    }    
    
}