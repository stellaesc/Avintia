@isTest
public class TEST_HL_TipoInmuebleTrigger {
    @isTest
    public static void testBeforeDelete(){
        Tipo_de_inmueble__c ti = new Tipo_de_inmueble__c();
        ti.Name = 'Inmueble para borrar';
        ti.Tipo__c = 'Local';
        ti.Superficie_Util_m2__c = 2;
        insert ti;
        
        delete ti;
    }

}