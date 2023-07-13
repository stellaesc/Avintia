public class SharePointFilesListController {

    public List<Map<String,String>> allTable { get; set; }
    public List<Map<String,String>> table { get; set; }
    public List<String> tableHeaders { get; set; }
    public Map<String,String> headersMap { get; set; }

    Integer levels;
    public String search { get; set; }
    
    private List<DocumentCategory__c> docCategories;

    public SharePointFilesListController() {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        String parentDir = spCustomSettings.spParentDir__c;
        Id parentId = ApexPages.currentPage().getParameters().get('id');
        String filter = SharePointConnectorMappings.getFilterByType(parentId.getSObjectType(), parentId);
        List<String> selectFields = SharePointConnectorMappings.getSelectFieldsByType(parentId.getSObjectType());

        List<AggregateResult> catResults = [SELECT COUNT_DISTINCT(Level__c) Levels FROM DocumentCategory__c];
        levels = (Integer) catResults.get(0).get('Levels');
        
        headersMap = new Map<String, String>();
        headersMap.put('Position', ' ');
        headersMap.put('Name', 'Título');
        headersMap.put('FileRef', 'Referencia');
        headersMap.put('DocType', 'Tipo');

        for(Integer i = 1; i <= levels; i++) {
            selectFields.add('Categoria' + i);
            headersMap.put('Categoria'+i, 'Categoría ' + i);
        }

        SharePointConnector sharePointConnector = new SharePointConnector();
        List<SharePointFile> files = new List<SharePointFile>();
        if(!Test.isRunningTest()) {
            sharePointConnector.login();
            HttpResponse res = sharePointConnector.getAllFilesByFilter(parentDir, selectFields, filter);
            files = sharePointConnector.getSharePointFilesFromJSON(res);
        } else {
            for(Integer i = 1; i <= 10; i++) {
                SharePointFile f = new SharePointFile();
                f.Position = i;
                f.Name = 'Archivo ' + i;
                f.DocType = 'Doc';
                f.FileRef = 'REF' + i;
                f.Categories = new List<String>{'Cat 1'};                
                files.add(f);
            }           
        }
        
        table = new List<Map<String,String>>();
        if(files != null && files.size() > 0) {
            for(SharePointFile f : files) {
                Map<String, String> fMap = new Map<String, String>();
                fMap.put('Position', String.valueOf(f.Position));
                fMap.put('Name', f.Name);
                fMap.put('FileRef', f.FileRef);
                fMap.put('DocType', f.DocType);
                
                Integer i = 1;
                for(String cat : f.categories) {
                    fMap.put('Categoria'+i, cat);
                    i++;
                }
                table.add(fMap);
            }
        }
        
        allTable = table;
        tableHeaders = table.size() > 0 ? new List<String>(table[0].keySet()) : new List<String>();
        
    }

    public void searchFiles() {
        if(search != '') {
            List<Map<String, String>> currfiles = new List<Map<String, String>>();

            for(Map<String,String> row : allTable) {
                if(row.get('Name').containsIgnoreCase(search)) currFiles.add(row);
                else if(row.get('DocType').containsIgnoreCase(search)) currFiles.add(row);
                else {
                    for(Integer i = 1; i <= levels; i++) {
                        if(row.get('Categoria'+i).containsIgnoreCase(search)) {
                            currFiles.add(row);
                            break;
                        }
                    }
                }
            }
            table = currFiles;
        } else table = allTable;
    }
}