public class SharePointConnectorMappings {

    private static Map<String, String> typeFiltersMap = new Map<String, String> {
        'Account' => 'IdCuenta eq \'$eqValue$\'',
        'Promocion__c' => 'IdPromocion eq \'$eqValue$\'',
        'Opportunity' => 'IdOportunidad eq \'$eqValue$\'',
        'Product2' => 'IdInmueble eq \'$eqValue$\'',
        'Tipo_de_inmueble__c' => 'IdTipoInmueble eq \'$eqValue$\''
    };

    private static Map<String, List<String>> selectFieldsMap = new Map<String, List<String>> {
        'Account' => new List<String> {'Id', 'Title', 'IdCuenta', 'TipoDocumento', 'FieldValuesAsText/FileRef'},
        'Promocion__c' => new List<String> {'Id', 'Title', 'IdPromocion', 'TipoDocumento', 'FieldValuesAsText/FileRef'},
        'Opportunity' => new List<String> {'Id', 'Title', 'IdOportunidad', 'TipoDocumento', 'FieldValuesAsText/FileRef'},
        'Product2' => new List<String> {'Id', 'Title', 'IdInmueble', 'TipoDocumento', 'FieldValuesAsText/FileRef'},
        'Tipo_de_inmueble__c' => new List<String> {'Id', 'Title', 'IdTipoInmueble', 'TipoDocumento', 'FieldValuesAsText/FileRef'}
    };

    private static Map<String, String> parentMetadataFieldsMap = new Map<String, String> {
        'Account' => 'IdCuenta',
        'Promocion__c' => 'IdPromocion',
        'Opportunity' => 'IdOportunidad',
        'Product2' => 'IdInmueble',
        'Tipo_de_inmueble__c' => 'IdTipoInmueble'
    };

    private static Map<String, String> promotionQueryMap = new Map<String, String> {
        'Account' => 'SELECT Name FROM Promocion__c WHERE Id IN (SELECT Promocion__c FROM Opportunity WHERE AccountId = $value$)',
        'Promocion__c' => 'SELECT Name FROM Promocion__c WHERE Id = $value$',
        'Opportunity' => 'SELECT Name FROM Promocion__c WHERE Id IN (SELECT Promocion__c FROM Opportunity WHERE Id = $value$)',
        'Product2' => 'SELECT Name FROM Promocion__c WHERE Id IN (SELECT Promocion__c FROM Product2 WHERE Id = $value$)',
        'Tipo_de_inmueble__c' => 'SELECT Name FROM Promocion__c WHERE Id IN (SELECT Promocion__c FROM Tipo_de_inmueble__c WHERE Id = $value$)'
    };

    private static Map<String, List<String>> catsMap = new Map<String, List<String>> {
        'FichaPreReserva' => new List<String> {'Contratos de reserva viviendas'},
        'FichaReserva' => new List<String> {'Contratos de reserva viviendas'},
        'ResoluciónReserva' => new List<String> {'Contratos de reserva viviendas'},
        'ContratoCompraventa' => new List<String> {'Contratos compra-venta viviendas'},
        'ContratoCompraventaVPT' => new List<String> {'Contratos compra-venta viviendas'},
        'FichaEscrituración' => new List<String> {'Escrituras compraventa clientes'},
        'Adenda' => new List<String> {'Contratos compra-venta viviendas'},
        'BorradorContratoCompraventa' => new List<String> {'Contratos compra-venta viviendas'},
        'BorradorContratoCompraventaVPT' => new List<String> {'Contratos compra-venta viviendas'},
        'BorradorContratoCompraventaVPO' => new List<String> {'Contratos compra-venta viviendas'},
        'Factura' => new List<String> {'Facturas'}
    };

    public static String getFilterByType(Schema.SObjectType type, String eqValue) {
        return typeFiltersMap.get(type + '').replace('$eqValue$', eqValue);
    }

    public static List<String> getSelectFieldsByType(Schema.SObjectType type) {
        return selectFieldsMap.get(type + '');
    }

    public static String getParentMetadataFieldByType(Schema.SObjectType type) {
        return parentMetadataFieldsMap.get(type + '');
    }

    public static String getPromotionQueryByType(Schema.SObjectType type) {
        return promotionQueryMap.get(type + '');
    }

    public static List<String> getCatsByFileType(String type) {
        return catsMap.get(type);
    }

    public static String getNameByCats(List<String> cats) {
        String fy = DateTime.now().format('YY');
        String parentCatName = '';
        String docCode = '';
        String fileName = '';
        String catName = '';
        String folderName = '';
        String catLvl1Name = '';

        List<DocumentCategory__c> docCats = [SELECT Id, Level__c, Code__c, Name, ParentDirectoryName__c,ParentDocumentCategory__c 
                                             FROM DocumentCategory__c WHERE Name IN :cats ORDER BY Level__c ASC];

        String prevCatName = '';
        for(DocumentCategory__c cat : docCats) {
            if(cat.Level__c == 1) {
                catLvl1Name = cat.Name;
                folderName = cat.ParentDirectoryName__c;
            }
            docCode = cat.Code__c;
            if(prevCatName != '' && prevCatName != cat.Name) parentCatName = prevCatName + '-';
            else parentCatName = '';
            catName = cat.Name;
            prevCatName = cat.Name;
        }

        // Obtenemos el nº de documento
        if(docCats.size() > 0) {
            String docNum = SharePointConnector.getNewDocumentNumber();
            fileName = docNum + '-' + docCode + '-' + parentCatName + catName + '-' + folderName + '_' + catLvl1Name + '-' + fy;            
        }
        return fileName;
    }

}