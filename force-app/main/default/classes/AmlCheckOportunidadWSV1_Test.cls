@IsTest
public class AmlCheckOportunidadWSV1_Test {

    /*@TestSetUp
    public static void setUp() {
        PropiedadesIntegracion__c propiedades = new PropiedadesIntegracion__c(
            UsuarioAMLCHECK__c = 'AVINTIA',
            PasswordAMLCHECK__c = 'asdasda',
            URL_AMLCHECK__c = 'http://test.test.com',
            ILC_IDEALISTA__c = 'ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7'
        );
        insert propiedades;

        TestUtil.getOportunidad_Contrato_Compraventa_Libre_controller();
    }

    @IsTest
    public static void testAuthenticationOK() {
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('AmlCheckAuthenticationRequestOK');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/json');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);

        AmlCheckOportunidadWSV1 aml = new AmlCheckOportunidadWSV1();
        aml.authentication();
        System.assertEquals('eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhdmludGlhIiwiYXV0aCI6IlJPTEVfUkVTVCIsImV4cCI6MTU2ODAyMzY3MH0.Bx-aueV368Pe4to6dqqYxllzUsZf6UyZsSpvGpGsqTRyMfFfTqPr4Kf_Q_e5N-F70_9RXkW7F1efmv7Jsl_Z-w',
                                aml.getToken());
        Test.stopTest();
    }

    @IsTest
    public static void testAuthenticationERR() {
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('AmlCheckAuthenticationRequestErr');
        mock.setStatusCode(401);
        mock.setHeader('Content-Type', 'text/json');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        AmlCheckOportunidadWSV1 aml = new AmlCheckOportunidadWSV1();

        try {
            aml.authentication();
        } catch(AmlCheckOportunidadWSV1.AmlUnauthorizedException e) {
            System.assertEquals('Unauthorized', e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void testCreateProposalOppOK() {
        Opportunity opp = [SELECT Id,Owner.Name,OpportunityNumber__c,Amount,CreatedDate,Fecha_Vencimiento__c,LastModifiedDate,Type
        FROM Opportunity WHERE Name = 'Oportunidad Test' LIMIT 1];

        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('AmlCheckAuthenticationRequestOK');
        mock.setStatusCode(201);
        mock.setHeader('Content-Type', 'text/json');

        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        AmlCheckOportunidadWSV1 aml = new AmlCheckOportunidadWSV1();

        Boolean isException = false;
        try {
            aml.createProposal(opp);
        } catch(Exception e) {
            isException = true;
        }
        System.assertEquals(false, isException);

        Test.stopTest();
    }

    @IsTest
    public static void testCreateProposalOK() {
        Id oppId = [SELECT Id,OpportunityNumber__c,Amount,CreatedDate,Fecha_Vencimiento__c,LastModifiedDate,Type
                    FROM Opportunity WHERE Name = 'Oportunidad Test' LIMIT 1].Id;

        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('AmlCheckAuthenticationRequestOK');
        mock.setStatusCode(201);
        mock.setHeader('Content-Type', 'text/json');

        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        AmlCheckOportunidadWSV1 aml = new AmlCheckOportunidadWSV1();

        Boolean isException = false;
        try {
            aml.createProposal(oppId);
        } catch(Exception e) {
            isException = true;
        }
        System.assertEquals(false, isException);

        Test.stopTest();
    }

    @IsTest
    public static void testCreateProposalErr() {
        Id oppId = [SELECT Id,OpportunityNumber__c,Amount,CreatedDate,Fecha_Vencimiento__c,LastModifiedDate,Type
        FROM Opportunity WHERE Name = 'Oportunidad Test' LIMIT 1].Id;

        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();

        mock.setStaticResource('AmlCheckAuthenticationRequestOK');
        mock.setStatusCode(401);
        mock.setHeader('Content-Type', 'text/json');

        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        AmlCheckOportunidadWSV1 aml = new AmlCheckOportunidadWSV1();

        Boolean isException = false;
        try {
            aml.createProposal(oppId);
        } catch(Exception e) {
            isException = true;
        }
        System.assertEquals(true, isException);

        Test.stopTest();
    }*/
}