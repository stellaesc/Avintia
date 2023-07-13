public class Utils {

    public static Id getStandarPriceBook(){
       if(Test.isrunningtest()) { 
            Id pricebookId = Test.getStandardPricebookId();
           return pricebookId;}
        else { 
            Pricebook2 listaPreciosEstandar = [SELECT Id, IsStandard FROM Pricebook2 WHERE IsStandard = True LIMIT 1];
        	Id pricebookId = listaPreciosEstandar.Id;
        	return pricebookId;}
        
    }

      public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
        bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
    
}