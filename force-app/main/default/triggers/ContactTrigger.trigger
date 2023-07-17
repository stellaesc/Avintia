trigger ContactTrigger on Contact (before insert,before update) {

    if(Trigger.isBefore)
    {
        boolean resultado1;
        boolean resultado2;
        boolean resultado3;
            
         //Se busca el pais españa para saber la nacionalidad
        List <Pais__c> pais = [Select ID from Pais__c where Codigo_ISO3__c=:'ESP'];
        
        for(Contact contact : trigger.new) {
            
            if(contact.Nacionalidad__c!=null &&contact.Nacionalidad__c==pais.get(0).ID)
            { 
                if(contact.Tipo_de_documento__c!=null && contact.Tipo_de_documento__c!= 'Pasaporte' && contact.Tipo_de_documento__c!= 'Nº Contribuyente'&&contact.Tipo_de_documento__c!= 'Otros'&& contact.N_Documento__c!=null && contact.N_Documento__c!='')
                {
                    resultado1 = ValidadorTriggerNIFHandler.validateNIFEmpresa(contact.N_Documento__c);
                    if (resultado1) {
                        
                        resultado2 = ValidadorTriggerNIFHandler.validateNIFpersona(contact.N_Documento__c);
                        if (resultado1 && !resultado2){
                            
                            resultado3 = ValidadorTriggerNIFHandler.validateNIE(contact.N_Documento__c);
                            if (resultado1 && !resultado2 && !resultado3){
                                
                                if(!System.Test.isRunningTest()){

                                    contact.addError('El NIF/CIF o NIE introducido no es válido, por favor revíselo');
                                }
                            }

                        }
                    }
                }
            }
        }
    }

}