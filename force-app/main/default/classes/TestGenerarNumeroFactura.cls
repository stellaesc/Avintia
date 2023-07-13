@isTest
public class TestGenerarNumeroFactura {
    @isTest
    static void testgeneradorNumFactura() {
        
       TestUtil.getFacturaNumeroFactura();

    	Test.startTest();
            GenerarNumeroFactura gen= new GenerarNumeroFactura();
            gen.execute(null);
    	Test.stopTest();
    }

}