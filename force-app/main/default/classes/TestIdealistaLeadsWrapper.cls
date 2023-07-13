@isTest
public class TestIdealistaLeadsWrapper {
	
    @isTest
	public static void testParse() {
		String json = '{'+
		'  \"customerCode\" : \"ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7\",'+
		'  \"customerProperties\" : [ {'+
		'    \"propertyId\" : 81318461,'+
		'    \"propertyOperation\" : \"sale\",'+
		'    \"propertyLeads\" : [ {'+
		'      \"leadType\" : \"normal\",'+
		'      \"leadContactName\" : \"Els Dhauwer\",'+
		'      \"leadContactEmail\" : \"elsdhauwer@hotmail.com\",'+
		'      \"leadContactPhone\" : \"476507096\",'+
		'      \"leadDate\" : \"11/07/2018 09:02:18\",'+
		'      \"leadMessage\" : \"Could you please send me an overview of the available apartments, additional costs and the timeline for this apartment? \\nThank you, Els\"'+
		'    }, {'+
		'      \"leadType\" : \"normal\",'+
		'      \"leadContactName\" : \"Andres Lista\",'+
		'      \"leadContactEmail\" : \"alistabruno@gmail.com\",'+
		'      \"leadContactPhone\" : \"637559778\",'+
		'      \"leadDate\" : \"11/07/2018 16:11:18\",'+
		'      \"leadMessage\" : \"Hola, me interesa esta promoción y me gustaría hacer una visita.\\nUn saludo\"'+
		'    } ]'+
		'  }, {'+
		'    \"propertyId\" : 81319941,'+
		'    \"propertyReference\" : \"P5 2ªD\",'+
		'    \"propertyOperation\" : \"sale\",'+
		'    \"propertyLeads\" : [ {'+
		'      \"leadType\" : \"normal\",'+
		'      \"leadContactName\" : \"Tere\",'+
		'      \"leadContactEmail\" : \"t.bloch@gmx.ch\",'+
		'      \"leadContactPhone\" : \"660345212\",'+
		'      \"leadDate\" : \"10/07/2018 18:57:08\",'+
		'      \"leadMessage\" : \"Hola, me interesa este piso y me gustaría hacer una visita.\\nUn saludo\"'+
		'    } ]'+
		'  } ]'+
		'}';
		IdealistaLeadsWrapper obj = IdealistaLeadsWrapper.parse(json);
		System.assert(obj != null);
	}
}