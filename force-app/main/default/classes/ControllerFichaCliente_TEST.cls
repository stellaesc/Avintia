@isTest (seeAllData=false)
public class ControllerFichaCliente_TEST {

    @isTest static void test_1(){
        
        Promocion__c promo = new Promocion__c();
        promo.Name = 'Nombre de la promocion';

        CNO__c cnoObj = new CNO__c(
            Codigo__c = '1212',
            Name = 'CNO TEST',
            FullName__c = 'CNO TEST'
        );
        insert cnoObj; 
 
        Lead ld = new Lead();
        ld.LastName = 'Apellido del lead';
        ld.Promocion__c = promo.Id;
        ld.Preferencia_Dormitorios__c = '2';
        ld.Uso_de_Inmueble__c = '1ª Residencia (Primer acceso)';
        ld.Necesita_Financiacion__c = true;
        ld.Altura_de_vivienda_interes__c = 'Bajo';
        ld.CNO__c = cnoObj.Id;
        insert ld;
            
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(ld);
        ControllerFichaCliente cas = New ControllerFichaCliente(sc);       
        Test.StopTest();
    }   
    
        @isTest static void test_2(){
        
        Promocion__c promo = new Promocion__c();
        promo.Name = 'Nombre de la promocion';
        
        CNO__c cnoObj = new CNO__c(
            Codigo__c = '1212',
            Name = 'CNO TEST',
            FullName__c = 'CNO TEST'
        );
        insert cnoObj;

        Lead ld = new Lead();
        ld.LastName = 'Apellido del lead';
        ld.Promocion__c = promo.Id;
        ld.Preferencia_Dormitorios__c = '3';
        ld.Uso_de_Inmueble__c = '2ª Residencia (Uso propio)';
        ld.Necesita_Financiacion__c = false;
        ld.Altura_de_vivienda_interes__c = 'Plantas intermedias';
        ld.CNO__c = cnoObj.Id;
        insert ld;
            
            Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(ld);
        ControllerFichaCliente cas = New ControllerFichaCliente(sc);       
        Test.StopTest();
    } 
    
        @isTest static void test_3(){
        
        Promocion__c promo = new Promocion__c();
        promo.Name = 'Nombre de la promocion';

        CNO__c cnoObj = new CNO__c(
            Codigo__c = '1212',
            Name = 'CNO TEST',
            FullName__c = 'CNO TEST'
        );
        insert cnoObj;
        
        Lead ld = new Lead();
        ld.LastName = 'Apellido del lead';
        ld.Promocion__c = promo.Id;
        ld.Preferencia_Dormitorios__c = '4';
        ld.Uso_de_Inmueble__c = '2ª Residencia (Inversión)';
        ld.Necesita_Financiacion__c = true;
        ld.Altura_de_vivienda_interes__c = 'Ático';
        ld.CNO__c = cnoObj.Id;
        insert ld;
            
            Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(ld);
        ControllerFichaCliente cas = New ControllerFichaCliente(sc);       
        Test.StopTest();
    } 
    @isTest static void test_4(){
        
        Promocion__c promo = new Promocion__c();
        promo.Name = 'Nombre de la promocion';

        CNO__c cnoObj = new CNO__c(
            Codigo__c = '1212',
            Name = 'CNO TEST',
            FullName__c = 'CNO TEST'
        );
        insert cnoObj;
        
        Lead ld = new Lead();
        ld.LastName = 'Apellido del lead';
        ld.Promocion__c = promo.Id;
        ld.Preferencia_Dormitorios__c = '4';
        ld.Uso_de_Inmueble__c = '1ª Residencia (Reposición)';
        ld.Necesita_Financiacion__c = true;
        ld.Altura_de_vivienda_interes__c = 'Ático';
        ld.CNO__c = cnoObj.Id;
        insert ld;
            
            Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(ld);
        ControllerFichaCliente cas = New ControllerFichaCliente(sc);       
        Test.StopTest();
    } 
    @isTest static void test_5(){
        
        Promocion__c promo = new Promocion__c();
        promo.Name = 'Nombre de la promocion';

        CNO__c cnoObj = new CNO__c(
            Codigo__c = '1212',
            Name = 'CNO TEST',
            FullName__c = 'CNO TEST'
        );
        insert cnoObj;
        
        Lead ld = new Lead();
        ld.LastName = 'Apellido del lead';
        ld.Promocion__c = promo.Id;
        ld.Preferencia_Dormitorios__c = '4';
        ld.Uso_de_Inmueble__c = '1ª Residencia (Inversión)';
        ld.Necesita_Financiacion__c = true;
        ld.Altura_de_vivienda_interes__c = 'Ático';
        ld.CNO__c = cnoObj.Id;
        insert ld;
            
            Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(ld);
        ControllerFichaCliente cas = New ControllerFichaCliente(sc);       
        Test.StopTest();
    } 
}