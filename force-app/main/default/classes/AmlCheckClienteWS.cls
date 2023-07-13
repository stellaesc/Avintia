public class AmlCheckClienteWS {

	/*public Respuesta onboarding(AmlCheckParams params) {
		PropiedadesIntegracion__c propiedades = PropiedadesIntegracion__c.getInstance();
		Respuesta respuesta = new Respuesta();
		String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
		String V1 = 'http://www.amlcheck.es/ws/onboarding/v1';
		String V11 = 'http://www.amlcheck.es/ws/clientbase/v1';
		String security = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
		DOM.Document doc = new DOM.Document();
      	DOM.XmlNode envelope = doc.createRootElement('Envelope', soapNS, 'soapenv');
      	envelope.setNamespace('v1', V1);
	  	envelope.setNamespace('v11', V11);

		//Header de la petición
	 	DOM.XmlNode header = envelope.addChildElement('Header', soapNS, null);
     	DOM.XmlNode security1 = header.addChildElement('Security', security, 'wsse');
	 	DOM.XmlNode usernameToken = security1.addChildElement('UsernameToken', security, 'wsse');
	 	usernameToken.addChildElement('Username', security, 'wsse').addTextNode(propiedades.UsuarioAMLCHECK__c);
	 	usernameToken.addChildElement('Password', security, 'wsse').addTextNode(propiedades.PasswordAMLCHECK__c);

		//Cuerpo del mensaje Soap
     	DOM.XmlNode body= envelope.addChildElement('Body', soapNS, null);
	 	DOM.XmlNode request= body.addChildElement('onboardingRequest', V1, 'v1');
	 	request.addChildElement('orisys', V11, 'v11').addTextNode(params.orisys);
	 	request.addChildElement('persnume', V11, 'v11').addTextNode(params.persnume);
	 	request.addChildElement('perscodi', V11, 'v11').addTextNode(params.perscodi);
	 	request.addChildElement('persiden', V11, 'v11').addTextNode(params.persiden);
	 	request.addChildElement('apellido1', V11, 'v11').addTextNode(params.apellido1);
	 	request.addChildElement('apellido2', V11, 'v11').addTextNode(params.apellido2);
	 	request.addChildElement('nombre', V11, 'v11').addTextNode(params.nombre);
	 	request.addChildElement('gender', V11, 'v11').addTextNode(params.gender);
     	request.addChildElement('persnaci', V11, 'v11').addTextNode(params.persnaci);
	 	request.addChildElement('persnaci2', V11, 'v11').addTextNode(params.persnaci2);
	 	request.addChildElement('persnac', V11, 'v11').addTextNode(params.persnac);
	 	request.addChildElement('perspais', V11, 'v11').addTextNode(params.perspais);
     	request.addChildElement('perspais2', V11, 'v11').addTextNode(params.perspais2);
     	request.addChildElement('persfiju', V11, 'v11').addTextNode(params.persfiju);
     	request.addChildElement('persfnac', V11, 'v11').addTextNode(params.persfnac);
     	request.addChildElement('usertokenid', V11, 'v11').addTextNode(params.usertokenid);
        //request.addChildElement('perscnae', V11, 'v11').addTextNode('');
        //request.addChildElement('persprof', V11, 'v11').addTextNode('');
        //request.addChildElement('origing', V11, 'v11').addTextNode('');
 	    //request.addChildElement('paisfisc', V11, 'v11').addTextNode('');
 	    //request.addChildElement('paispost', V11, 'v11').addTextNode('');
        
     	System.debug('El mensaje que se va enviar es: '+ doc.toXmlString());

		// Send the request
    	HttpRequest req = new HttpRequest();
    	req.setMethod('POST');
    	req.setEndpoint(propiedades.URL_AMLCHECK__c + '/WSClient/ws');
    	req.setHeader('Content-Type', 'text/xml');
    	req.setBodyDocument(doc);
    	Http http = new Http();
		HttpResponse res = http.send(req);
		System.debug('Respuesta del sistema: ' + res.getStatusCode()+ ' ' + res.getStatus());

		if (res != null && res.getStatusCode() != null && res.getStatusCode() == 200) {
			DOM.Document resDoc = res.getBodyDocument();
			System.debug(resDoc.toXmlString());
			System.debug(res.getBodyDocument());
			DOM.XmlNode resXml = resDoc.getRootElement();

			//Mapeamos la repuesta
			respuesta.returnCode = resXml.getChildElement('Body', soapNS).getChildElement('onboardingResponse', V1).getChildElement('returnCode', V11).getText();
			respuesta.returnCodeDescription = resXml.getChildElement('Body', soapNS).getChildElement('onboardingResponse', V1).getChildElement('returnCodeDescription', V11).getText();
			respuesta.persiden = resXml.getChildElement('Body', soapNS).getChildElement('onboardingResponse', V1).getChildElement('persiden', V11).getText();
			respuesta.idalerta = resXml.getChildElement('Body', soapNS).getChildElement('onboardingResponse', V1).getChildElement('idalerta', V11).getText();
			respuesta.idevidencia = resXml.getChildElement('Body', soapNS).getChildElement('onboardingResponse', V1).getChildElement('idevidencia', V11).getText();
			if(!Test.isRunningTest()) insertarLog('AltaClientesOnboarding',params.persnume,doc.toXmlString(),resDoc.toXmlString());
		} else {
			if(!Test.isRunningTest()) insertarLog('AltaClientesOnboarding',params.persnume,doc.toXmlString(),null);
			return null;
		}
		
     	return respuesta;
	}

	public Respuesta onboardingRBA(AmlCheckParams params, Boolean isInsert) {
		PropiedadesIntegracion__c propiedades = PropiedadesIntegracion__c.getInstance();
		Respuesta respuesta = new Respuesta();
		String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
		String V1 = isInsert ? 'http://www.amlcheck.es/ws/onboarding/v1' : 'http://www.amlcheck.es/ws/client/v1';
		String V11 = 'http://www.amlcheck.es/ws/clientbase/v1';
		String V12 = 'http://www.amlcheck.es/ws/client/v1';
		String security = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
		DOM.Document doc = new DOM.Document();
      	DOM.XmlNode envelope = doc.createRootElement('Envelope', soapNS, 'soapenv');
      	envelope.setNamespace('v1', V1);
	  	envelope.setNamespace('v11', V11);
	  	if(isInsert) envelope.setNamespace('v12', V12);
                //ID del grupo al que se tiene que mandar el mensaje
        Id idGrupo = [SELECT Id FROM Group WHERE DeveloperName = 'Notificacion_Servidor_PBC'].ID;
        
        List<GroupMember> lgmember = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId =: idGrupo];
  
        Set<Id> idslgmember = new Set<Id>();
        for(GroupMember gm: lgmember){
            idslgmember.add(gm.UserOrGroupId);
        }
        List<User> luser = [SELECT email FROM User WHERE id IN: Idslgmember];
        
        List<String> lemails = new List<String>();
        for(User em: luser){
            lemails.add(em.Email);
        }      
  
		// Header de la petición
	 	DOM.XmlNode header = envelope.addChildElement('Header', soapNS, null);
     	DOM.XmlNode security1 = header.addChildElement('Security', security, 'wsse');
	 	DOM.XmlNode usernameToken = security1.addChildElement('UsernameToken', security, 'wsse');
	 	usernameToken.addChildElement('Username', security, 'wsse').addTextNode(propiedades.UsuarioAMLCHECK__c);
	 	usernameToken.addChildElement('Password', security, 'wsse').addTextNode(propiedades.PasswordAMLCHECK__c);

		// Cuerpo del mensaje Soap
     	DOM.XmlNode body= envelope.addChildElement('Body', soapNS, null);
	 	DOM.XmlNode request= body.addChildElement(isInsert ? 'onboardingRbaRequest' : 'updateClientWithAttributesRequest', V1, 'v1');
	 	//DOM.XmlNode request= body.addChildElement(isInsert ? 'onboardingRbaRequest' : 'onboardingRbaRequest', V1, 'v1');
	 	request.addChildElement('orisys', V11, 'v11').addTextNode(params.orisys);
	 	request.addChildElement('persnume', V11, 'v11').addTextNode(params.persnume);
	 	request.addChildElement('perscodi', V11, 'v11').addTextNode(params.perscodi);
	 	request.addChildElement('persiden', V11, 'v11').addTextNode(params.persiden);
	 	request.addChildElement('apellido1', V11, 'v11').addTextNode(params.apellido1);
	 	request.addChildElement('apellido2', V11, 'v11').addTextNode(params.apellido2);
	 	request.addChildElement('nombre', V11, 'v11').addTextNode(params.nombre);
	 	request.addChildElement('gender', V11, 'v11').addTextNode(params.gender);
     	request.addChildElement('persnaci', V11, 'v11').addTextNode(params.persnaci);
	 	request.addChildElement('persnaci2', V11, 'v11').addTextNode(params.persnaci2);
	 	request.addChildElement('persnac', V11, 'v11').addTextNode(params.persnac);
	 	request.addChildElement('perspais', V11, 'v11').addTextNode(params.perspais);
     	request.addChildElement('perspais2', V11, 'v11').addTextNode(params.perspais2);
     	request.addChildElement('persfiju', V11, 'v11').addTextNode(params.persfiju);
     	request.addChildElement('persfnac', V11, 'v11').addTextNode(params.persfnac);
     	request.addChildElement('usertokenid', V11, 'v11').addTextNode(params.usertokenid);
        //request.addChildElement('origing', V11, 'v11').addTextNode('');
 	    //request.addChildElement('paisfisc', V11, 'v11').addTextNode('');
 	    //request.addChildElement('paispost', V11, 'v11').addTextNode('');

		// RBA
		if(params.dacosila != null) request.addChildElement('attributeKeys', isInsert ? V12 : V1, isInsert ? 'v12' : 'v1').addTextNode('DACOSILA');
		if(params.persprof != null) request.addChildElement('attributeKeys', isInsert ? V12 : V1, isInsert ? 'v12' : 'v1').addTextNode('PERSPROF');
		if(params.perscnae != null) request.addChildElement('attributeKeys', isInsert ? V12 : V1, isInsert ? 'v12' : 'v1').addTextNode('PERSCNAE');

		if(params.dacosila != null) request.addChildElement('attributeValues', isInsert ? V12 : V1, isInsert ? 'v12' : 'v1').addTextNode(params.dacosila);
		if(params.persprof != null) request.addChildElement('attributeValues', isInsert ? V12 : V1, isInsert ? 'v12' : 'v1').addTextNode(params.persprof);
		if(params.perscnae != null) request.addChildElement('attributeValues', isInsert ? V12 : V1, isInsert ? 'v12' : 'v1').addTextNode(params.perscnae);
        
     	System.debug('El mensaje que se va enviar es: '+ doc.toXmlString());

		// Send the request
		System.debug('Endpoint: ' + propiedades.URL_AMLCHECK__c + '/WSClient/ws');
		HttpResponse res;
		try {
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(propiedades.URL_AMLCHECK__c + '/WSClient/ws');
			req.setHeader('Content-Type', 'text/xml');
			req.setBodyDocument(doc);
			Http http = new Http();
			res = http.send(req);
			System.debug('Respuesta del sistema: ' + res.getStatusCode()+ ' ' + res.getStatus());

			if (res != null && res.getStatusCode() != null && res.getStatusCode() == 200) {
				DOM.Document resDoc = res.getBodyDocument();
				System.debug(resDoc.toXmlString());
				System.debug(res.getBodyDocument());
				DOM.XmlNode resXml = resDoc.getRootElement();
				//Mapeamos la repuesta
				respuesta.returnCode = resXml.getChildElement('Body', soapNS).getChildElement(isInsert ? 'onboardingRbaResponse' : 'updateClientWithAttributesResponse', V1).getChildElement('returnCode', V11).getText();
				respuesta.returnCodeDescription = resXml.getChildElement('Body', soapNS).getChildElement(isInsert ? 'onboardingRbaResponse' : 'updateClientWithAttributesResponse', V1).getChildElement('returnCodeDescription', V11).getText();
				if(respuesta.returnCode != '77' && respuesta.returnCode != '78') {
					respuesta.persiden = resXml.getChildElement('Body', soapNS).getChildElement(isInsert ? 'onboardingRbaResponse' : 'updateClientWithAttributesResponse', V1).getChildElement('persiden', V11).getText();
					respuesta.idalerta = resXml.getChildElement('Body', soapNS).getChildElement(isInsert ?'onboardingRbaResponse' : 'updateClientWithAttributesResponse', V1).getChildElement('idalerta', V11).getText();
					respuesta.idevidencia = resXml.getChildElement('Body', soapNS).getChildElement(isInsert ? 'onboardingRbaResponse' : 'updateClientWithAttributesResponse', V1).getChildElement('idevidencia', V11).getText();
					respuesta.rbalevel = resXml.getChildElement('Body', soapNS).getChildElement(isInsert ? 'onboardingRbaResponse' : 'updateClientWithAttributesResponse', V1).getChildElement('rbalevel', V11).getText();
					respuesta.rbarulecode = resXml.getChildElement('Body', soapNS).getChildElement(isInsert ? 'onboardingRbaResponse' : 'updateClientWithAttributesResponse', V1).getChildElement('rbarulecode', V11).getText();
					respuesta.rbarulecodedesc = resXml.getChildElement('Body', soapNS).getChildElement(isInsert ? 'onboardingRbaResponse' : 'updateClientWithAttributesResponse', V1).getChildElement('rbarulecodedesc', V11).getText();
					if(!isInsert) respuesta.manualGlobalRisk = resXml.getChildElement('Body', soapNS).getChildElement('updateClientWithAttributesResponse', V1).getChildElement('manualGlobalRisk', V1).getText();
				}
				
				if(respuesta.returnCode == '77') { // Ya existe el cliente en la base de datos AML
					throw new AmlAlreadyExistException('La cuenta ' + params.persiden + ' ya existe en la base de datos AML\n\r' + resDoc.toXmlString());
				} else if(respuesta.returnCode == '78') { // No existe el cliente en la base de datos AML y se ha intentado actualizar
					throw new AmlNoExistException('La cuenta ' + params.persiden + ' no existe en la base de datos AML y se ha intentado actualizar');
				} else insertarLog('AltaClientesOnboardingRBA', params.persnume, doc.toXmlString(), resDoc.toXmlString());
			} else {
				System.debug('Respuesta RBA: ' + respuesta);
				insertarLog('AltaClientesOnboardingRBA', params.persnume, doc.toXmlString(), null);
				// TODO -> MANDAR UN EMAIL A LOS USUARIOS CON PERFIL ADMIN Y PMO.
				sendExceptionMessage('Excepcion del servidor', 'El servidor ha devuelto el siguiente error: '+ res.getStatus() + res.getStatusCode()+
                    'Al insertar el cliente con identificador: ' + params.persiden, lemails);
				return null;
			}
			System.debug('Respuesta RBA: ' + respuesta);
		} catch(AmlAlreadyExistException e) {
			System.debug('Respuesta RBA: ' + respuesta);
			//insertarLog('AltaClientesOnboardingRBA', params.persnume, doc.toXmlString(), e.getMessage());
			throw e;
		} catch(System.CalloutException e) {
			System.debug('Respuesta RBA: ' + respuesta);
			insertarLog('AltaClientesOnboardingRBA', params.persnume, doc.toXmlString(), e.getMessage());
			// TODO -> MANDAR UN EMAIL A LOS USUARIOS CON PERFIL ADMIN Y PMO.
			sendExceptionMessage('Excepcion del servidor', 'No se ha podido realizar la inserción/actualización del cliente con el siguiente identificador fiscal: '
                + params.persiden + 'a causa de la siguiente excepción: ' + e.getMessage(), lemails);
			throw e;
		} catch(Exception e) {
			System.debug('Respuesta RBA: ' + respuesta);
			insertarLog('AltaClientesOnboardingRBA', params.persnume, doc.toXmlString(), e.getMessage());
			// TODO -> MANDAR UN EMAIL A LOS USUARIOS CON PERFIL ADMIN Y PMO.
			sendExceptionMessage('Excepcion del servidor', 'No se ha podido realizar la inserción/actualización del cliente con el siguiente identificador fiscal: '
                + params.persiden + 'a causa de la siguiente excepción: ' + e.getMessage(), lemails);
			throw e;
		}

		return respuesta;
	}
    
    public static void sendExceptionMessage(String subject, String body, List<String> lemails) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = lemails;
        message.optOutPolicy = 'FILTER';
        message.subject = subject;
        message.plainTextBody = body;
        if(!Test.isRunningTest()) Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {message});
    }  
    
	public static Respuesta getClient(AmlCheckParams params) {
		PropiedadesIntegracion__c propiedades = PropiedadesIntegracion__c.getInstance();
		Respuesta respuesta = new Respuesta();
		String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
		String V1 = 'http://www.amlcheck.es/ws/client/v1';
		String ns2 = 'http://www.amlcheck.es/ws/clientbase/v1';
		String ns3 = 'http://www.amlcheck.es/ws/client/v1';
		String security = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
		DOM.Document doc = new DOM.Document();
      	DOM.XmlNode envelope = doc.createRootElement('Envelope', soapNS, 'soapenv');
      	envelope.setNamespace('v1', V1);
	  	//envelope.setNamespace('v11', V11);
	  	//if(isInsert) envelope.setNamespace('v12', V12);

		// Header de la petición
	 	DOM.XmlNode header = envelope.addChildElement('Header', soapNS, null);
     	DOM.XmlNode security1 = header.addChildElement('Security', security, 'wsse');
	 	DOM.XmlNode usernameToken = security1.addChildElement('UsernameToken', security, 'wsse');
	 	usernameToken.addChildElement('Username', security, 'wsse').addTextNode(propiedades.UsuarioAMLCHECK__c);
	 	usernameToken.addChildElement('Password', security, 'wsse').addTextNode(propiedades.PasswordAMLCHECK__c);

		// Cuerpo del mensaje Soap
     	DOM.XmlNode body = envelope.addChildElement('Body', soapNS, null);
		DOM.XmlNode request = body.addChildElement('getClientRequest', V1, 'v1');
		request.addChildElement('id', V1, 'v1').addTextNode(params.persiden);
		request.addChildElement('typeId', V1, 'v1').addTextNode(params.perscodi);

		System.debug('El mensaje que se va enviar es: '+ doc.toXmlString());

		// Send the request
		System.debug('Endpoint: ' + propiedades.URL_AMLCHECK__c + '/WSClient/ws');
		HttpResponse res;
		try {
			HttpRequest req = new HttpRequest();
			req.setMethod('POST');
			req.setEndpoint(propiedades.URL_AMLCHECK__c + '/WSClient/ws');
			req.setHeader('Content-Type', 'text/xml');
			req.setBodyDocument(doc);
			Http http = new Http();
			res = http.send(req);
			System.debug('Respuesta del sistema: ' + res.getStatusCode()+ ' ' + res.getStatus() + '\n\r' + res.getBody());

			if(res.getStatusCode() == 200) {
				DOM.Document resDoc = res.getBodyDocument();
				DOM.XmlNode resXml = resDoc.getRootElement();
				//Mapeamos la repuesta
				respuesta.returnCode = resXml.getChildElement('Body', soapNS).getChildElement('getClientResponse', ns3).
					getChildElement('returnCode', ns2).getText();
				respuesta.returnCodeDescription = resXml.getChildElement('Body', soapNS).getChildElement('getClientResponse', ns3).
					getChildElement('returnCodeDescription', ns2).getText();
				if(respuesta.returnCode != '95' && respuesta.returnCode != '78') {
					respuesta.idalerta = resXml.getChildElement('Body', soapNS).getChildElement('getClientResponse', ns3).
						getChildElement('idalerta', ns2).getText();
					respuesta.idevidencia = resXml.getChildElement('Body', soapNS).getChildElement('getClientResponse', ns3).
						getChildElement('idevidencia', ns2).getText();
					respuesta.rbalevel = resXml.getChildElement('Body', soapNS).getChildElement('getClientResponse', ns3).
						getChildElement('rbalevel', ns2).getText();
					respuesta.rbarulecode = resXml.getChildElement('Body', soapNS).getChildElement('getClientResponse', ns3).
						getChildElement('rbarulecode', ns2).getText();
					respuesta.rbarulecodedesc = resXml.getChildElement('Body', soapNS).getChildElement('getClientResponse', ns3).
						getChildElement('rbarulecodedesc', ns2).getText();
					respuesta.manualGlobalRisk = resXml.getChildElement('Body', soapNS).getChildElement('getClientResponse', ns3).
						getChildElement('manualGlobalRisk', ns3).getText();
				}
				insertarLog('GetClientData', params.persnume, doc.toXmlString(), resDoc.toXmlString());
			}
		} catch(Exception e) {
			System.debug('Exception msg: ' + e.getMessage());
			insertarLog('GetClientData', params.persnume, doc.toXmlString(), e.getMessage());
		}

		return respuesta;
	}

	public static void insertarLog( String nombreMetodo, String idCuenta, String mensajeEnviado, String resultado) {
        Log__c log = new Log__c();
        log.Aplicacion__c = 'AMLCHECK';
        log.name = nombreMetodo;
      	log.Identificador__c = idCuenta;
		log.MensajeEnviado__c = String.isNotBlank(mensajeEnviado) ? mensajeEnviado.abbreviate(130000) : '';
		log.MensajeRecibido__c = String.isNotBlank(resultado) ? resultado.abbreviate(130000) : '';

        insert log;
    }

	public static String docTypeMapping(String docType) {
        String amlCheckDocType = '';
        switch on docType {
            when 'NIF' {
                amlCheckDocType = 'F';
            }
            when 'CIF' {
                amlCheckDocType = 'C';
            }
            when 'NIE' {
                amlCheckDocType = 'N';
            }
            when 'Pasaporte' {
                amlCheckDocType = 'P';
            }
            when else{
                amlCheckDocType = 'O';
            }
        }
        return amlCheckDocType;
    }

	public static String genderMapping(String gender) {
        String amlCheckGender = '';
        switch on gender {
            when 'Hombre' {
                amlCheckGender = 'H';
            }
            when 'Mujer' {
                amlCheckGender = 'M';
            }
            when else {
                amlCheckGender = null;
            }
        }
        return amlCheckGender;
    }
*/
	/** 
    * =====================================================================================
    * @className        AmlCheckParams
    * @description      Wrapper class
    * =====================================================================================
    **/
/*	public class AmlCheckParams {
		public String orisys;
		public String persnume;
		public String perscodi;
		public String persiden;
		public String apellido1;
		public String apellido2;
		public String nombre;
		public String gender;
		public String persnaci;
		public String persnaci2;
		public String persnac;
		public String perspais;
		public String perspais2;
		public String persfiju;
		public String persfnac;
		public String usertokenid;

		// RBA
		public String dacosila; // Situación laboral
		public String persprof; // Provincia direccion fiscal
		public String perscnae;
	}

    /** 
    * =====================================================================================
    * @className        Respuesta
    * @description      Wrapper class
    * =====================================================================================
    **/
/*    public class Respuesta {
        public String returnCode;
        public String returnCodeDescription;
		//public String persnume;
		//public String percodi;
		public String persiden;
        public String idalerta;
        public String idevidencia;
		public String rbalevel;
		public String manualGlobalRisk;
		public String rbarulecode;
		public String rbarulecodedesc;
    }
*/    
/*	public class AmlAlreadyExistException extends Exception {}
	public class AmlNoExistException extends Exception {}
	public class AmlNoExistParamsException extends Exception {}
	public class AmlRequiredParamsException extends Exception {}
*/
}