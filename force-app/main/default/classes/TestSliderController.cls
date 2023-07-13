@isTest
public class TestSliderController {
	
    private static Promocion__c promotion;
    
    private static void setPromotion() {
        Date fechaInicioComercializacionPrevista = date.newInstance(2018, 09,20 );
        Date fechaFinComercializacionPrevista = date.newInstance(2018, 10,03 );
        Integer NumSemanas = (fechaInicioComercializacionPrevista.toStartOfWeek().daysBetween(fechaFinComercializacionPrevista.toStartOfWeek()))/7;
        promotion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista );
    }
    
    @isTest
    public static void testMyController() {
        
        setPromotion();
        
        PageReference pageRef = Page.Slider_promocion;
        Test.setCurrentPage(pageRef);
        
        ApexPages.CurrentPage().GetParameters().put('id', promotion.Id);
           
        ApexPages.StandardController stdController;
        SliderController controller = new SliderController(stdController);
        String nextPage = pageRef.getUrl();
		System.debug(nextPage);
           
        // Verify that page fails without parameters
        System.assert(nextPage.contains('/apex/slider_promocion'));

        //promocion__c promo = TestUtil.testCrearPromocion(date.newInstance(2020, 08, 01), date.newInstance(2022, 08, 01));
           
           
        // Add parameters to page URL
        //ApexPages.currentPage().getParameters().put(promo.id);
      
           
           /*
        // Instantiate a new controller with all parameters in the page
        controller = new thecontroller(); 
        controller.setLastName('lastname');
        controller.setFirstName('firstname');
        controller.setCompany('acme');
        controller.setEmail('firstlast@acme.com');
        nextPage = controller.save().getUrl();

        // Verify that the success page displays
        System.assertEquals('/apex/success', nextPage);
        Lead[] leads = [select id, email from lead where Company = 'acme'];
        System.assertEquals('firstlast@acme.com', leads[0].email);
    */
    }
}