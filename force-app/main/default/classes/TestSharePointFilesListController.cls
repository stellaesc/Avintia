@isTest
public class TestSharePointFilesListController {

    private static SharePointFilesListController controller;

    @TestSetUp
    public static void populatePromotion() {
        new TestUtil();

        DocumentCategory__c cat = new DocumentCategory__c(Name = 'Cat 1', Level__c = 1, Code__c = '01');
        insert cat;
    }

    @isTest
    public static void testConstructor() {
        List<Promocion__c> promos = [SELECT Id FROM Promocion__c WHERE Name = 'Promocion test'];
        ApexPages.currentPage().getParameters().put('id', promos.get(0).Id);
        controller = new SharePointFilesListController();
        
        System.assertEquals(10, controller.table.size());
        System.assertEquals(10, controller.allTable.size());
    }

    @isTest
    public static void testSearchFiles() {
        List<Promocion__c> promos = [SELECT Id FROM Promocion__c WHERE Name = 'Promocion test'];
        ApexPages.currentPage().getParameters().put('id', promos.get(0).Id);
        controller = new SharePointFilesListController();

        controller.search = 'Archivo 2';
        controller.searchFiles();

        System.assertEquals(1, controller.table.size());

        controller.search = '';
        controller.searchFiles();

        controller.search = 'Cat 1';
        controller.searchFiles();

        System.assertEquals(10, controller.table.size());
    }
    
    @isTest
    public static void testSearchFilesEmpty() {
        List<Promocion__c> promos = [SELECT Id FROM Promocion__c WHERE Name = 'Promocion test'];
        ApexPages.currentPage().getParameters().put('id', promos.get(0).Id);
        controller = new SharePointFilesListController();

        controller.search = '';
        controller.searchFiles();

        System.assertEquals(10, controller.table.size());
    }
}