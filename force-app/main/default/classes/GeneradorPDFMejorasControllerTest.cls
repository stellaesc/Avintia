@IsTest
public class GeneradorPDFMejorasControllerTest {
    @TestSetup
    public static void makeData(){
        /*CNO__c cnoObj = new CNO__c(
                Codigo__c = '1212',
                Name = 'CNO TEST',
                FullName__c = 'CNO TEST'
        );
        insert cnoObj;*/
        Profile pf1 = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1]; 
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User user1 =new User(firstname = 'ABC', 
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
        /*Pais__c pais = new Pais__c(Name = 'España', Codigo_ISO2__c = 'ES', Codigo_ISO3__c = 'ESP', OLDID__c = '170', Codigo_ISO3_num__c = 123);
        insert pais;
        Account a = new Account(Name = 'Test', Tipo_de_documento__c = 'NIF', N_Documento__c = '12345678P', 
        AccountSource='PUNTO DE VENTA', Estado_comercial__c='Cliente Gestión', Nacionalidad__c=pais.Id, 
         Tipo_de_sociedad__c='TS01', DP_Pais__c=pais.Id, Tipo_de_via_FISCAL__c='Calle', 
         Nombre_de_via_FISCAL__c='TEST ', N_via_FISCAL__c=1, localidad);*/

         Pais__c pais = new Pais__c(Name = 'España', Codigo_ISO3__c = 'ESP');
        insert pais;

        Comunidad_autonoma__c cAutonoma = new Comunidad_autonoma__c(Name = 'Madrid', Pais__c = pais.Id);
        insert cAutonoma;

        Provincia__c provincia = new Provincia__c(Name = 'Madrid', Comunidad_autonoma__c = cAutonoma.Id);
        insert provincia;

        Municipio__c municipio = new Municipio__c(Name = 'Madrid', Provincia__c = provincia.Id);
        insert municipio;
         Account cuenta = new Account(Name = 'Pepe', Movil_empresa__c = '666666666', Email__c = 'pepeoror@gmail.com', Tipo_de_documento__c = 'NIF', N_Documento__c = '12345678A',
                Tipo_de_via_FISCAL__c = 'Calle', Nombre_de_via_FISCAL__c = 'siefnoerfr', NumeroViaFiscalText__c = '3', Pais_FISCAL__c = pais.Id,
                Localidad_FISCAL__c = municipio.Id, Codigo_postal_FISCAL__c = '12345', DF_Tipo_de_via__c = 'Calle',
                DF_Nombre_via__c = 'siefnoerfr', NumeroVia2Text__c = '3', DF_Pais__c = pais.Id,
                DF_Localidad__c = municipio.Id, DF_Codigo_postal__c = '12345', DP_Tipo_de_via__c = 'Calle',
                DP_Nombre_via__c = 'siefnoerfr', NumeroViaText__c = '3',
                DP_Localidad__c = municipio.Id, DP_Codigo_postal__c = '12345', Nacionalidad__c = pais.Id,
                AccountSource = 'PUNTO DE VENTA', Estado_comercial__c='Cliente Gestión', Tipo_de_sociedad__c='TS01',
                DP_Pais__c = pais.Id);
        insert cuenta;

        PriceBook2 pb = new PriceBook2(Name = 'Pricebook Test', IsActive = true);
        insert pb; 

        

        Tipo_de_inmueble__c tipoInmueble1 = new Tipo_de_inmueble__c(Name = 'Tipo de Inmueble Vivienda Test', Tipo__c = 'Vivienda');
        insert tipoInmueble1;

        Promocion__c promocion2 = TestUtil.getPromocion(date.today(), date.today()+30);

        Opportunity o = new Opportunity(Name = 'Test', Promocion__c = promocion2.Id, StageName = 'Closed Won', CloseDate = Date.today(), AccountId = cuenta.Id, Pricebook2Id = pb.Id);
        insert o;


        Product2 p = new Product2();
        p.Name = 'Vivienda Test';
        p.Estado__c = 'Libre';
        p.Tipo_de_inmueble__c = tipoInmueble1.Id;
        p.Precio__c = 45000;
        p.Promocion__c = promocion2.Id;
        p.Oportunidad__c = o.Id;
        //p.Tipologia_Vivienda_Garaje_Trastero_Local__c = 'Vivienda';
        insert p;  

        PriceBookEntry pbe = new PriceBookEntry();
        pbe.IsActive = true;
        pbe.Pricebook2Id = pb.Id;
        pbe.Product2Id = p.Id;
        pbe.UnitPrice = 1000;
        insert pbe;

        OpportunityLineItem productoOpp = new OpportunityLineItem();
        productoOpp.OpportunityId = o.Id;
        productoOpp.Product2Id = p.Id;
        productoOpp.UnitPrice = 1500;
        productoOpp.Quantity = 1;
        productoOpp.Description = 'Producto 5';
        insert productoOpp;
        
        Mejora__c c = new Mejora__c(Name = 'Test1', Precio__c = 1, MejoraPadre__c=NULL, DescripcionMejora__c='Test Descripcion 1', FechaLimiteContratacion__c = Date.today()+20, Activa__c=TRUE, Promocion__c = promocion2.Id);
        Mejora__c c2 = new Mejora__c(Name = 'Test2', Precio__c = 2, MejoraPadre__c=c.Id, DescripcionMejora__c='Test Descripcion 2', FechaLimiteContratacion__c = Date.today()+20, Activa__c=TRUE, Promocion__c = promocion2.Id);
        Mejora__c c3 = new Mejora__c(Name = 'Test3', Precio__c = 3, MejoraPadre__c=NULL, DescripcionMejora__c='Test Descripcion 33', FechaLimiteContratacion__c = Date.today()+20, Activa__c=TRUE, Promocion__c = promocion2.Id);
        Mejora__c c4 = new Mejora__c(Name = 'Test4', Precio__c = 4, MejoraPadre__c=c3.Id, DescripcionMejora__c='Test Descripcion 4', FechaLimiteContratacion__c = Date.today()+20, Activa__c=TRUE, Promocion__c = promocion2.Id);
        Mejora__c c5 = new Mejora__c(Name = 'Test5', Precio__c = 5, MejoraPadre__c=c4.Id, DescripcionMejora__c='Test Descripcion 5', FechaLimiteContratacion__c = Date.today()+20, Activa__c=TRUE, Promocion__c = promocion2.Id);
        List<Mejora__c> mejorasLst = new List<Mejora__c>{c, c2, c3, c4, c5};
        insert mejorasLst;
        c2.MejoraPadre__c = c.Id;
        c4.MejoraPadre__c = c3.Id;
        c5.MejoraPadre__c = c4.Id;
        update mejorasLst;

        System.debug('c: ' + c);
        System.debug('c2: ' + c2);
        System.debug('c3: ' + c3);
        System.debug('c4: ' + c4);
        System.debug('c5: ' + c5);
        
        
        MejorasViviendas__c mv = new MejorasViviendas__c(Name = 'Test 1', Precio__c = 1, Vivienda__c = p.Id, Mejora__c = c.Id);
        MejorasViviendas__c mv2 = new MejorasViviendas__c(Name = 'Test 2', Precio__c = 1, Vivienda__c = p.Id, Mejora__c = c2.Id);
        MejorasViviendas__c mv3 = new MejorasViviendas__c(Name = 'Test 3', Precio__c = 1, Vivienda__c = p.Id, Mejora__c = c3.Id);
        MejorasViviendas__c mv4 = new MejorasViviendas__c(Name = 'Test 4', Precio__c = 1, Vivienda__c = p.Id, Mejora__c = c4.Id);
        MejorasViviendas__c mv5 = new MejorasViviendas__c(Name = 'Test 5', Precio__c = 1, Vivienda__c = p.Id, Mejora__c = c5.Id);
        List<MejorasViviendas__c> mvLst = new List<MejorasViviendas__c>{mv, mv2, mv3, mv4, mv5};
        insert mvLst;

        MejorasTiposInmueble__c mti = new MejorasTiposInmueble__c(Mejora__c = c.Id, TipoInmueble__c = tipoInmueble1.Id);
        MejorasTiposInmueble__c mti2 = new MejorasTiposInmueble__c(Mejora__c = c2.Id, TipoInmueble__c = tipoInmueble1.Id);
        MejorasTiposInmueble__c mti3 = new MejorasTiposInmueble__c(Mejora__c = c3.Id, TipoInmueble__c = tipoInmueble1.Id);
        MejorasTiposInmueble__c mti4 = new MejorasTiposInmueble__c(Mejora__c = c4.Id, TipoInmueble__c = tipoInmueble1.Id);
        MejorasTiposInmueble__c mti5 = new MejorasTiposInmueble__c(Mejora__c = c5.Id, TipoInmueble__c = tipoInmueble1.Id);
        List<MejorasTiposInmueble__c> mtiLst = new List<MejorasTiposInmueble__c>{mti, mti2, mti3, mti4, mti5};
        insert mtiLst;
        

    }
    @IsTest
    public static void GeneradorPDFMejorasControllerTest(){
        Opportunity o = [SELECT Id, Promocion__c FROM Opportunity LIMIT 1];

        PageReference pageRef = Page.GeneradorPDFMejoras;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(o);
        ApexPages.currentPage().getParameters().put('Id',o.id);

        GeneradorPDFMejorasController controller = new GeneradorPDFMejorasController();
        
    }
}