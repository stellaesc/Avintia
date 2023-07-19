@isTest(SeeAllData=false)
public class showCastilleteController_Test {

    @testSetup static void setUp_Test() {
        CNO__c cnoObj = new CNO__c(
                Codigo__c = '1212',
                Name = 'CNO TEST',
                FullName__c = 'CNO TEST'
        );
        insert cnoObj;

        Profile pf1 = [Select Id from profile where Name = 'Planificación'];
        Profile pf2 = [Select Id from profile where Name = 'Comercial'];
        Profile pf3 = [Select Id from profile where Name = 'Marketing'];
        Profile pf4 = [Select Id from profile where Name = 'Departamento Técnico'];

        String orgId = UserInfo.getOrganizationId();
        String userId = UserInfo.getUserId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '') ;
        Integer RandomId = Integer.valueOf(Math.rint(Math.random() * 1000000));
        String uniqueName = orgId + dateString + RandomId;
        User user1 = new User(firstname = 'ABC',
                lastName = 'XYZ',
                email = uniqueName + '@test' + orgId + '.org',
                Username = uniqueName + '@test' + orgId + '.org',
                EmailEncodingKey = 'ISO-8859-1',
                Alias = uniqueName.substring(18, 23),
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                ProfileId = pf1.Id
        );

        User user2 = new User(firstname = 'ABC2',
                lastName = 'XYZ',
                email = uniqueName + '@test' + orgId + '.org',
                Username = uniqueName + '@test1' + orgId + '.org',
                EmailEncodingKey = 'ISO-8859-1',
                Alias = uniqueName.substring(18, 23),
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                ProfileId = pf2.Id
        );
        User user3 = new User(firstname = 'ABC3',
                lastName = 'XYZ',
                email = uniqueName + '@test' + orgId + '.org',
                Username = uniqueName + '@test2' + orgId + '.org',
                EmailEncodingKey = 'ISO-8859-1',
                Alias = uniqueName.substring(18, 23),
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                ProfileId = pf3.Id
        );
        User user4 = new User(firstname = 'ABC4',
                lastName = 'XYZ',
                email = uniqueName + '@test' + orgId + '.org',
                Username = uniqueName + '@test3' + orgId + '.org',
                EmailEncodingKey = 'ISO-8859-1',
                Alias = uniqueName.substring(18, 23),
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                ProfileId = pf4.Id
        );

        List<User> userList = new List<User>{
                user1, user2, user3, user4
        };

        insert userList;


        Promocion__c promocion = new Promocion__c(Name = 'PromocionTest', Ritmo_de_ventas__c = 1, N_Unidades_iniciales_ritmo_de_ventas__c = 1,
                Inicio_comercializacion_prevista__c = date.newInstance(2018, 09, 24), Fin_comercializacion_prevista__c = date.newInstance(2018, 11, 25),
                Tecnico__c = user4.Id, Comercial__c = user2.Id, Planificacion__c = user1.Id, Marketing__c = user3.Id, Fase__c = 'Anteproyecto');
        insert promocion;

        Tipo_de_inmueble__c tipoInmueble1 = new Tipo_de_inmueble__c(Tipo__c = 'Vivienda');
        Tipo_de_inmueble__c tipoInmueble2 = new Tipo_de_inmueble__c(Tipo__c = 'Garaje');
        Tipo_de_inmueble__c tipoInmueble3 = new Tipo_de_inmueble__c(Tipo__c = 'Trastero');
        Tipo_de_inmueble__c tipoInmueble4 = new Tipo_de_inmueble__c(Tipo__c = 'Local');

        List<Tipo_de_inmueble__c> tipoInmuebleList = new List<Tipo_de_inmueble__c>{
                tipoInmueble1, tipoInmueble2, tipoInmueble3, tipoInmueble4
        };

        insert tipoInmuebleList;

        Product2 inmueble1 = new Product2(Name = 'InmuebleTest', Promocion__c = promocion.Id, Tipo_de_inmueble__c = tipoInmueble1.Id,
                Estado__c = 'Bloqueado Temporalmente', Precio__c = 1000, Portal__c = '1', Planta__c = 'Ático', Piso__c = 3, Letra_N_Puerta__c = 'A',
                UltimoModificadorEstado__c = userId.substring(0,15), Bloque__c = '1', Parcela__c = '1');
        Product2 inmueble2 = new Product2(Name = 'InmuebleTest2', Promocion__c = promocion.Id, Tipo_de_inmueble__c = tipoInmueble2.Id,
                Estado__c = 'Libre', Precio__c = 1000, Portal__c = '1', Planta__c = 'Bajo', Piso__c = 0, Letra_N_Puerta__c = 'A',
                Bloque__c = '1', Parcela__c = '1');
        Product2 inmueble3 = new Product2(Name = 'InmuebleTest3', Promocion__c = promocion.Id, Tipo_de_inmueble__c = tipoInmueble1.Id,
                Estado__c = 'Bloqueado Temporalmente', Precio__c = 1000, Portal__c = '1', Piso__c = 1, Planta__c = '1', Letra_N_Puerta__c = 'A',
                UltimoModificadorEstado__c = userId.substring(0,15), Bloque__c = '1', Parcela__c = '1');
        Product2 inmueble4 = new Product2(Name = 'InmuebleTest4', Promocion__c = promocion.Id, Tipo_de_inmueble__c = tipoInmueble4.Id,
                Estado__c = 'Bloqueado Temporalmente', Precio__c = 1000, Portal__c = '1', Piso__c = 1, Planta__c = '1', Letra_N_Puerta__c = 'B',
                UltimoModificadorEstado__c = userId.substring(0,15), Bloque__c = '1', Parcela__c = '1');
        Product2 inmueble5 = new Product2(Name = 'InmuebleTest5', Promocion__c = promocion.Id, Tipo_de_inmueble__c = tipoInmueble3.Id,
                Estado__c = 'Libre', Precio__c = 1000, Portal__c = '1', Piso__c = 1, Planta__c = '1', Letra_N_Puerta__c = 'B',
                UltimoModificadorEstado__c = userId.substring(0,15), Bloque__c = '1', Parcela__c = '1');

        List<Product2> inmuebleList = new List<Product2>{
                inmueble1, inmueble2, inmueble3, inmueble4, inmueble5
        };
        insert inmuebleList;
        
        inmueble2.Inmueble_asociado__c = inmueble1.Id;
        update inmueble2;

        //Insertar cuenta: necesita insertar objetivo País y Localidad 

        Pais__c pais = new Pais__c(Name = 'España', Codigo_ISO3__c = 'ESP');
        insert pais;

        Comunidad_autonoma__c cAutonoma = new Comunidad_autonoma__c(Name = 'Madrid', Pais__c = pais.Id);
        insert cAutonoma;

        Provincia__c provincia = new Provincia__c(Name = 'Madrid', Comunidad_autonoma__c = cAutonoma.Id);
        insert provincia;

        Municipio__c municipio = new Municipio__c(Name = 'Madrid', Provincia__c = provincia.Id);
        insert municipio;

        Account cuenta = new Account(Name = 'Pepe', Movil_empresa__c = '666666666', Email__c = 'pepeoror@gmail.com', Tipo_de_documento__c = 'NIF', N_Documento__c = '12345678A',
                AccountSource = 'RECOMENDACIÓN', Tipo_de_via_FISCAL__c = 'Calle', Nombre_de_via_FISCAL__c = 'siefnoerfr', NumeroViaFiscalText__c = '3', Pais_FISCAL__c = pais.Id,
                Tipo_de_sociedad__c = 'TS01', Estado_comercial__c = 'Cliente Gestión', Localidad_FISCAL__c = municipio.Id, Codigo_postal_FISCAL__c = '12345', DF_Tipo_de_via__c = 'Calle',
                DF_Nombre_via__c = 'siefnoerfr', NumeroVia2Text__c = '3', DF_Pais__c = pais.Id,
                DF_Localidad__c = municipio.Id, DF_Codigo_postal__c = '12345', DP_Tipo_de_via__c = 'Calle',
                DP_Nombre_via__c = 'siefnoerfr', NumeroViaText__c = '3', DP_Pais__c = pais.Id,
                DP_Localidad__c = municipio.Id, DP_Codigo_postal__c = '12345', Nacionalidad__c = pais.Id, CNO__c = cnoObj.Id);
        insert cuenta;

        Opportunity oportunidad = new Opportunity(Name = 'OportunidadTest', AccountId = cuenta.Id, CloseDate = date.newInstance(2018, 11, 25), StageName = 'Pre-Reserva',
                Promocion__c = promocion.Id);
        insert oportunidad;

        Quote oferta = new Quote(Name = 'QuoteTest', OpportunityId = oportunidad.Id, Pricebook2Id = Utils.getStandarPriceBook());
        insert oferta;

    }

    @isTest static void test1() {
		Test.startTest();        
        Promocion__c promocionToTest = [SELECT Id FROM Promocion__c LIMIT 1];
        Product2 inmueble1 = [SELECT Id, Tipo_de_inmueble__r.Tipo__c, Bloque__c, Parcela__c, UltimoModificadorEstado__c, Promocion__c FROM Product2 WHERE Name = 'InmuebleTest'];
        //Product2 inmueble2 = [SELECT Id, Tipo_de_inmueble__r.Tipo__c, Bloque__c, Parcela__c FROM Product2 WHERE Name = 'InmuebleTest2'];
        //Product2 inmueble3 = [SELECT Id, Tipo_de_inmueble__r.Tipo__c, Bloque__c, Parcela__c FROM Product2 WHERE Name = 'InmuebleTest3'];
        //Product2 inmueble4 = [SELECT Id, Tipo_de_inmueble__r.Tipo__c, Bloque__c, Parcela__c FROM Product2 WHERE Name = 'InmuebleTest4'];
        //Product2 inmueble5 = [SELECT Id, Tipo_de_inmueble__r.Tipo__c, Bloque__c, Parcela__c FROM Product2 WHERE Name = 'InmuebleTest5'];
        Opportunity oportunidad = [SELECT Id FROM Opportunity WHERE Name = 'OportunidadTest'];
        Quote oferta = [SELECT Id FROM Quote WHERE Name = 'QuoteTest'];
        Account cuenta = [SELECT Id FROM Account WHERE Name = 'Pepe'];

        List<Product2> inmueblesList = new List<Product2>{
                inmueble1/*, inmueble2, inmueble3, inmueble4,inmueble5*/
        };


        //ApexPages.StandardController scTest = new ApexPages.StandardController(promocionToTest);
        PageReference pageRefTest = Page.showCastillete;
        Test.setCurrentPage(pageRefTest);

        for (Product2 inmueble : inmueblesList) {

            System.currentPageReference().getParameters().put('Id', promocionToTest.Id);
            System.currentPageReference().getParameters().put('idproduct', inmueble.Id);
            System.currentPageReference().getParameters().put('tipoSel', inmueble.Tipo_de_inmueble__r.Tipo__c);
            System.currentPageReference().getParameters().put('parcelaSel', inmueble.Parcela__c);
            System.currentPageReference().getParameters().put('bloqueSel', String.valueOf(inmueble.Bloque__c));
            System.currentPageReference().getParameters().put('bloqueid', inmueble.id);
            //System.currentPageReference().getParameters().put('id', promocionToTest.id);
            //showCastilleteController controller = new showCastilleteController(scTest);
            showCastilleteController controller = new showCastilleteController();

            //Llamamos a los metodos del controlador
            controller.getEstados();
            controller.abrirInmueble();
            controller.bloqueaActivo();
            //controller.getTipo();
            controller.getPortales();
            controller.loadCastillete();
            controller.searchstring = '12345';
            controller.buscarCliente();
            controller.getItems();
            controller.getProm();
            controller.getTipoInmueble();
            controller.getParcela();
            controller.getBloque();


        }
        Test.stopTest();
    }
    
    @isTest static void test2() { 
        
        Test.startTest();
        Account cuenta = [SELECT Id FROM Account WHERE Name = 'Pepe'];
        Product2 inmueble1 = [SELECT Id, Estado__c, Tipo_de_inmueble__r.Tipo__c, Bloque__c, Parcela__c, UltimoModificadorEstado__c, Promocion__c FROM Product2 WHERE Name = 'InmuebleTest'];
        system.debug('TEST - inmueble1.Estado__c:::'+inmueble1.Estado__c);
        system.debug('TEST - inmueble1.UltimoModificadorEstado__c:::'+inmueble1.UltimoModificadorEstado__c);
        system.debug('TEST - inmueble1.Promocion__c:::'+inmueble1.Promocion__c);
        
        Quote oferta = [SELECT Id FROM Quote WHERE Name = 'QuoteTest'];
        System.currentPageReference().getParameters().put('id', oferta.id);
        showCastilleteController controller = new showCastilleteController();
        system.debug('TEST - inmueble1.Estado__c2:::'+inmueble1.Estado__c);
        controller.insertarProdPresupuesto();

        /*
        Product2 inmueblePrueba = new Product2(Name = 'InmuebleTestPrueba', Promocion__c = promocionToTest.Id, Tipo_de_inmueble__c = inmueble1.Tipo_de_inmueble__r.Id,
                                              Estado__c = 'Bloqueado Temporalmente', Precio__c = 1000, Portal__c = '1', Planta__c = 'Ático', Piso__c = 3, Letra_N_Puerta__c = 'A',
                                              UltimoModificadorEstado__c = UserInfo.getUserId(), Bloque__c ='1', Parcela__c = '1');
        insert inmueblePrueba;*/

        inmueble1.Estado__c = 'Bloqueado Temporalmente';
        update inmueble1;

        /*List<Product2> inmueblesss = [SELECT Name, UltimoModificadorEstado__c, Estado__c, Promocion__c FROM Product2];*/
        //system.debug('inmueblesList despues insertarProdPresupuesto:::' + inmueblesList);


        System.currentPageReference().getParameters().put('accId', cuenta.id);
        showCastilleteController controller2 = new showCastilleteController();
        system.debug('TEST - inmueble1.Estado__c3:::'+inmueble1.Estado__c);
        controller2.insertarOportunidad();
        Test.stopTest();
    }

}