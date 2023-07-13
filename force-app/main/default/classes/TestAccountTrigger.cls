@isTest
public class TestAccountTrigger {
    private static final Id CUENTA_PERSONAL = SObjectUtils.getRecordTypeId(Account.sObjectType, 'PersonAccount');
    private static final Id CUENTA_EMPRESA = SObjectUtils.getRecordTypeId(Account.sObjectType, 'Cuenta');
    private static final Id CUENTA_SOCIEDAD = SObjectUtils.getRecordTypeId(Account.sObjectType, 'Sociedad');

    private static PropiedadesIntegracion__c propiedades;
    /*static {

        propiedades = new PropiedadesIntegracion__c();

        propiedades.UsuarioAMLCHECK__c = '123344';
        propiedades.PasswordAMLCHECK__c = 'password';
        propiedades.URL_AMLCHECK__c = 'http://prueba.com';
        propiedades.ILC_Idealista__c = 'ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7';

        upsert propiedades;

    }*/

    @isTest
    static void testAltaAccount() {
        CNO__c cnoObj = new CNO__c(
                Codigo__c = '1212',
                Name = 'CNO TEST',
                FullName__c = 'CNO TEST'
        );
        insert cnoObj;

        //Insertamos la cuenta que vamos testear
        Account account = new Account();
        Account accountPersonaFisica = new Account();
        Account accountPersonaFisicaNIF = new Account();
        Account accountSociedad = new Account();
        //Cuenta de empresa
        account.Name = 'Prueba Test';
        account.RecordTypeId = CUENTA_EMPRESA;
        account.Tipo_de_documento__c = 'CIF';
        account.N_Documento__c = 'W55968949';
        Pais__c pais = new Pais__c();
        pais.Name = 'España';
        pais.Codigo_ISO2__c = 'ES';
        pais.Codigo_ISO3__c = 'ESP';
        pais.Codigo_ISO3_num__c = 724;
        insert pais;
        account.Nacionalidad__c = pais.ID;
        account.DP_Codigo_postal__c = '2800';
        account.CNO__c = cnoObj.Id;

        Municipio__c municipio = new Municipio__c();
        municipio.Codigo_municipio__c = 79;
        municipio.Digito_control__c = 6;
        municipio.Name = 'Madrid';

        Comunidad_Autonoma__c comunidad = new Comunidad_Autonoma__c();
        comunidad.Codigo__c = 13;
        comunidad.Name = 'Comunidad de Madrid';
        comunidad.Pais__c = pais.ID;
        insert comunidad;
        Provincia__c provincia = new Provincia__c ();
        provincia.Codigo__c = 28;
        provincia.Name = 'Madrid';
        provincia.Comunidad_autonoma__c = comunidad.ID;
        insert provincia;
        municipio.Provincia__c = provincia.ID;
        insert municipio;

        account.DP_Localidad__c = municipio.id;
        account.NumeroViaText__c = '1';
        account.DP_Nombre_via__c = 'prueba';
        account.DP_Pais__c = pais.ID;
        account.DP_Tipo_de_vIa__c = 'Avenida';
        account.Copiar_direccion_2__c = true;
        account.Direcciones_iguales__c = true;
        account.Fecha_constitucion__c = datetime.now().date();


        //Cuenta personal con un NIE
        accountPersonaFisica.FirstName = 'prueba';
        accountPersonaFisica.RecordTypeId = CUENTA_PERSONAL;
        accountPersonaFisica.LastName = 'apellidos';
        accountPersonaFisica.PersonEmail = 'correoprueba@correo.es';
        accountPersonaFisica.Tipo_de_documento__c = 'NIE';
        accountPersonaFisica.N_Documento__c = 'X8819773D';
        accountPersonaFisica.PersonEmail = 'correo@correo12.es';
        accountPersonaFisica.Profesion__pc = 'profesion';
        accountPersonaFisica.Estado_Civil__pc = 'Soltero/a';
        accountPersonaFisica.PersonMobilePhone = '619282929';
        accountPersonaFisica.Sexo__pc = 'Hombre';
        accountPersonaFisica.Nacionalidad__pc = pais.ID;
        accountPersonaFisica.Pais_nacimiento__pc = pais.ID;
        accountPersonaFisica.AccountSource = 'Web corporativa';
        accountPersonaFisica.PersonBirthdate = datetime.now().date();
        accountPersonaFisica.DF_Tipo_de_via__c = 'Avenida';
        accountPersonaFisica.DF_Pais__c = pais.ID;
        accountPersonaFisica.DF_Nombre_via__c = 'paseo la castellana';
        accountPersonaFisica.DF_Localidad__c = municipio.id;
        accountPersonaFisica.NumeroVia2Text__c = '20';
        accountPersonaFisica.DF_N_piso__c = 5;
        accountPersonaFisica.DF_Puerta__c = 'A';
        accountPersonaFisica.N_cuenta_corriente__c = 'ES66 2100 0418 40 1234567891';
        accountPersonaFisica.DF_Codigo_postal__c = '28044';
        //Domicilio principal
        accountPersonaFisica.DP_Tipo_de_via__c = 'Avenida';
        accountPersonaFisica.DP_Pais__c = pais.ID;
        accountPersonaFisica.DP_Nombre_via__c = 'paseo la castellana';
        accountPersonaFisica.DP_Localidad__c = municipio.id;
        accountPersonaFisica.NumeroViaText__c = '20';
        accountPersonaFisica.DP_N_piso__c = 5;
        accountPersonaFisica.DP_Puerta__c = 'A';
        accountPersonaFisica.DP_Codigo_postal__c = '28044';
        accountPersonaFisica.CNO__C = cnoObj.Id;


        //Cuenta personal con un NIF
        accountPersonaFisicaNIF.FirstName = 'prueba2';
        accountPersonaFisicaNIF.RecordTypeId = CUENTA_PERSONAL;
        accountPersonaFisicaNIF.LastName = 'apellidos2';
        accountPersonaFisicaNIF.PersonEmail = 'correoprueba2@correo.es';
        accountPersonaFisicaNIF.Tipo_de_documento__c = 'NIF';
        accountPersonaFisicaNIF.N_Documento__c = '98853536L';
        accountPersonaFisicaNIF.PersonEmail = 'correo1@correo12.es';
        accountPersonaFisicaNIF.Profesion__pc = 'profesion';
        accountPersonaFisicaNIF.Estado_Civil__pc = 'Soltero/a';
        accountPersonaFisicaNIF.PersonMobilePhone = '619282929';
        accountPersonaFisicaNIF.Sexo__pc = 'Mujer';
        accountPersonaFisicaNIF.Nacionalidad__pc = pais.ID;
        accountPersonaFisicaNIF.Pais_nacimiento__pc = pais.ID;
        accountPersonaFisicaNIF.AccountSource = 'Web corporativa';
        accountPersonaFisicaNIF.PersonBirthdate = datetime.now().date();
        accountPersonaFisicaNIF.DF_Tipo_de_via__c = 'Avenida';
        accountPersonaFisicaNIF.DF_Pais__c = pais.ID;
        accountPersonaFisicaNIF.DF_Nombre_via__c = 'paseo la castellana';
        accountPersonaFisicaNIF.DF_Localidad__c = municipio.id;
        accountPersonaFisicaNIF.NumeroVia2Text__c = '20';
        accountPersonaFisicaNIF.DF_N_piso__c = 5;
        accountPersonaFisicaNIF.DF_Puerta__c = 'A';
        accountPersonaFisicaNIF.DF_Codigo_postal__c = '28044';
        //Domicilio principal
        accountPersonaFisicaNIF.DP_Tipo_de_via__c = 'Avenida';
        accountPersonaFisicaNIF.DP_Pais__c = pais.ID;
        accountPersonaFisicaNIF.DP_Nombre_via__c = 'paseo la castellana';
        accountPersonaFisicaNIF.DP_Localidad__c = municipio.id;
        accountPersonaFisicaNIF.NumeroViaText__c = '20';
        accountPersonaFisicaNIF.DP_N_piso__c = 5;
        accountPersonaFisicaNIF.DP_Puerta__c = 'A';
        accountPersonaFisicaNIF.DP_Codigo_postal__c = '28044';
        accountPersonaFisicaNIF.CNO__c = cnoObj.Id;

        //Cuenta Sociedad
        accountSociedad.Name = 'CuentaSociedad';
        accountSociedad.RecordTypeId = CUENTA_SOCIEDAD;
        accountSociedad.Tipo_de_documento__c = 'NIE';
        accountSociedad.N_Documento__c = 'Z9219465N';
        accountSociedad.Estado_comercial__c = 'Cliente Gestión';
        //Domicilio principal
        accountSociedad.DP_Tipo_de_via__c = 'Avenida'; 
        accountSociedad.DP_Pais__c = pais.ID;
        accountSociedad.DP_Nombre_via__c = 'paseo la castellana';
        accountSociedad.DP_Localidad__c = municipio.id;
        accountSociedad.NumeroViaText__c = '23';
        accountSociedad.DP_N_piso__c = 5;
        accountSociedad.DP_Puerta__c = 'A';
        accountSociedad.DP_Codigo_postal__c = '28044';

        Test.startTest();
        insert account;
        insert accountPersonaFisica;
        insert accountPersonaFisicaNIF;
        insert accountSociedad;
        Test.stopTest();
    }

}