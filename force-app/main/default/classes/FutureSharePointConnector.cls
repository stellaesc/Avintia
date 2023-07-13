public with sharing class FutureSharePointConnector {

    @future(callout = true)
    public static void createFolders(String parentFolderPath, List<String> subFolders) {
        SharePointConnector spConnector = new SharePointConnector(true);
        spConnector.login();
        spConnector.createFolders(parentFolderPath, subFolders);
    }
}