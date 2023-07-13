global class GenerarNumeroFactura implements Schedulable{
   
    global void execute(SchedulableContext ctx) {
       System.debug('Realizamos la llamada al metodo de generar las facturas');
       generador(); 
    }

    @future(callout=true)
    @AuraEnabled
    public static void generador(){
        InvoicesManagement__c invManagement = InvoicesManagement__c.getOrgDefaults();

        Map<String, Decimal> lastNumsByYearAndSociety = getMaxSecuencial();
		
        List<Factura__c> listadoFacturas = [SELECT Id, Name, Oportunidad__r.Name, Cliente__r.Name, Sociedad__c, SecuencialFactura__c, Numero_de_factura__c, Tipo_de_factura__c,
                                            Estado_de_la_factura__c, Fecha_de_emision__c, Pago_o_Cuota__c, Estado_plan_de_pagos__c, Oportunidad__r.FechaEscrituracionReal__c
                                            FROM Factura__c 
                                            WHERE SecuencialFactura__c = null AND Oportunidad__c != null AND Oportunidad__r.Promocion__r.Envio_Oracle__c = true
                                            AND Oportunidad__r.Verificando_PBC__c = false AND Enviar_Factura_Oracle__c = true AND Fecha_de_emision__c != null];

        List<Factura__c> lFacturasError = [SELECT Id, Name, Oportunidad__r.Name, Cliente__r.Name, Sociedad__c, SecuencialFactura__c, Numero_de_factura__c, Tipo_de_factura__c,
                                           Estado_de_la_factura__c, Fecha_de_emision__c, Pago_o_Cuota__c, Estado_plan_de_pagos__c, Oportunidad__r.FechaEscrituracionReal__c
                                           FROM Factura__c 
                                           WHERE SecuencialFactura__c = null AND Oportunidad__c != null AND Oportunidad__r.Promocion__r.Envio_Oracle__c = true
                                           AND Oportunidad__r.Verificando_PBC__c = false AND Enviar_Factura_Oracle__c = true AND Fecha_de_emision__c = null];

        //Recorreomos las facturas para generar el numero de factura
        List<Factura__c> facturasActualizar = new List<Factura__c> ();
        for(Factura__c fact : listadoFacturas) {

            Boolean isPreInvoice = fact.Pago_o_Cuota__c == 'Proforma';
            Boolean invoiceHasStatus = String.isNotBlank(fact.Estado_de_la_factura__c);
            Boolean statusIsConciliated = fact.Estado_de_la_factura__c == 'Conciliada SF';
            Boolean isPayment = fact.Pago_o_Cuota__c == 'Abono';
            Boolean statusIsPendingSent = fact.Estado_de_la_factura__c == 'Pendiente de emisión';
            Boolean invoiceNumIsBlank = String.isBlank(fact.Numero_de_factura__c);
            Boolean isFee = fact.Pago_o_Cuota__c == 'Cuota';
            Boolean isExtraFee = fact.Pago_o_Cuota__c == 'Cuota Extra';
            String invoiceTypePreffix = getInvoicePreffix(fact.Tipo_de_factura__c);
            Boolean invoiceHasDeedDate = fact.Oportunidad__r.FechaEscrituracionReal__c != null; //Fecha de escrituración real
            Boolean isInDateRange = fact.Fecha_de_emision__c <= fact.Oportunidad__r.FechaEscrituracionReal__c; //añadido SCA
         
            system.debug('factura:' + fact.Id + ' fecha: '+ fact.Fecha_de_emision__c + ' tipo: ' + fact.Tipo_de_factura__c + ' estado: ' + fact.Estado_de_la_factura__c);
            
            if(!lastNumsByYearAndSociety.containsKey(fact.Fecha_de_emision__c.year() + '|' + fact.Sociedad__c + '|' + invoiceTypePreffix) || Test.isRunningTest()) {
                lastNumsByYearAndSociety.put(fact.Fecha_de_emision__c.year() + '|' + fact.Sociedad__c + '|' + invoiceTypePreffix, 0);
            }
            
            Decimal lastNum = lastNumsByYearAndSociety.get(fact.Fecha_de_emision__c.year() + '|' + fact.Sociedad__c + '|' + invoiceTypePreffix);
            if((!invoiceHasDeedDate || invoiceHasDeedDate && isInDateRange) && invoiceNumIsBlank && ((isPreInvoice && invoiceHasStatus && statusIsConciliated) || (isPayment && invoiceHasStatus && statusIsPendingSent) || (isPayment && invoiceHasStatus && statusIsConciliated))) {
                fact.Numero_de_factura__c = calculaNumeroFactura(fact.Tipo_de_factura__c, fact.Fecha_de_emision__c, lastNum);
                fact.SecuencialFactura__c = Decimal.valueOf(generateSecuencialNum(lastNum));
                lastNumsByYearAndSociety.put(fact.Fecha_de_emision__c.year() + '|' + fact.Sociedad__c + '|' + invoiceTypePreffix, lastNum+1);
                facturasActualizar.add(fact);

            } else if((!invoiceHasDeedDate || invoiceHasDeedDate && isInDateRange) && isFee && fact.Estado_plan_de_pagos__c == 'Activo' && invoiceHasStatus && statusIsPendingSent &&
                     ((Date.today().day()>=invManagement.endOfTheMonthFromDayFee__c && fact.Fecha_de_emision__c!=null && fact.Fecha_de_emision__c.month()==(Date.today().addMonths(1)).month() && fact.Fecha_de_emision__c.year()==(Date.today().addMonths(1)).year())||
                     (Date.today().day()<=invManagement.startOfTheMonthToDayFee__c && fact.Fecha_de_emision__c!=null && fact.Fecha_de_emision__c.month()==Date.today().month() && fact.Fecha_de_emision__c.year()==Date.today().year())) && 
                     invoiceNumIsBlank)
            {
                System.debug('Pasaa 1');
                fact.Numero_de_factura__c = calculaNumeroFactura(fact.Tipo_de_factura__c, fact.Fecha_de_emision__c, lastNum);
                fact.SecuencialFactura__c = Decimal.valueOf(generateSecuencialNum(lastNum));
                facturasActualizar.add(fact);
                lastNumsByYearAndSociety.put(fact.Fecha_de_emision__c.year() + '|' + fact.Sociedad__c + '|' + invoiceTypePreffix, lastNum+1);

            } else if((!invoiceHasDeedDate || invoiceHasDeedDate && isInDateRange) && isExtraFee && fact.Estado_plan_de_pagos__c == 'Activo' && invoiceHasStatus && statusIsPendingSent &&
                     ((Date.today().day()>=invManagement.endOfTheMonthFromDayExtraFee__c && fact.Fecha_de_emision__c!=null && fact.Fecha_de_emision__c.month()==(Date.today().addMonths(1)).month() && fact.Fecha_de_emision__c.year()==(Date.today().addMonths(1)).year())||
                     (Date.today().day()<=invManagement.startOfTheMonthToDayExtraFee__c && fact.Fecha_de_emision__c!=null && fact.Fecha_de_emision__c.month()==Date.today().month() && fact.Fecha_de_emision__c.year()==Date.today().year())) && 
                     invoiceNumIsBlank)
            {                    
                fact.Numero_de_factura__c = calculaNumeroFactura(fact.Tipo_de_factura__c, fact.Fecha_de_emision__c, lastNum);
                fact.SecuencialFactura__c = Decimal.valueOf(generateSecuencialNum(lastNum));
                facturasActualizar.add(fact);
                lastNumsByYearAndSociety.put(fact.Fecha_de_emision__c.year() + '|' + fact.Sociedad__c + '|' + invoiceTypePreffix, lastNum+1);
                
            }else if((!invoiceHasDeedDate || invoiceHasDeedDate && isInDateRange) && isFee && fact.Estado_plan_de_pagos__c == 'Activo' && invoiceHasStatus && statusIsConciliated && invoiceNumIsBlank)
            {
                fact.Numero_de_factura__c = calculaNumeroFactura(fact.Tipo_de_factura__c, fact.Fecha_de_emision__c, lastNum);
                fact.SecuencialFactura__c = Decimal.valueOf(generateSecuencialNum(lastNum));
                facturasActualizar.add(fact);
                lastNumsByYearAndSociety.put(fact.Fecha_de_emision__c.year() + '|' + fact.Sociedad__c + '|' + invoiceTypePreffix, lastNum+1);
            }
            
        }

        System.debug('El numero de facturas a actualizar es: '+ facturasActualizar.size());
        if(!facturasActualizar.isEmpty()) update facturasActualizar;
        
        if(lFacturasError != null && !lFacturasError.isEmpty()){ //Enviar email con las facturas que no se han podido generar
            System.debug('Facturas Error');
            sendEmail(lFacturasError);
        }
       
    }

    private static Map<String, Decimal> getMaxSecuencial() {
        List<AggregateResult> results = [SELECT CALENDAR_YEAR(Fecha_de_emision__c) year, Sociedad__c, Tipo_de_factura__c, MAX(SecuencialFactura__c) lastNumber 
                                         FROM Factura__c 
                                         WHERE Oportunidad__r.Promocion__r.Envio_Oracle__c = true AND SecuencialFactura__c != null
                                         GROUP BY CALENDAR_YEAR(Fecha_de_emision__c), Sociedad__c, Tipo_de_factura__c];
        Map<String, Decimal> maxSecsMap = new Map<String, Decimal>();
        for(AggregateResult r : results) {
            String lastNumStr = String.valueOf((Decimal) r.get('lastNumber'));
            Decimal lastNum = String.isBlank(lastNumStr) ? 0 : Decimal.valueOf(lastNumStr);
            Integer year = (Integer) r.get('year');
            String society = (String) r.get('Sociedad__c');
            String type = getInvoicePreffix((String) r.get('Tipo_de_factura__c'));
            maxSecsMap.put(year + '|' + society + '|' + type, lastNum);
        }
        return maxSecsMap;
    }

    private static String calculaNumeroFactura(String tipoFactura, Date fechaFactura, Decimal maxNum) {
        String preffix = getInvoicePreffix(tipoFactura);
        return String.valueof((fechaFactura.year())).substring(2,4) + preffix + generateSecuencialNum(maxNum);
        
    }

    private static String getInvoicePreffix(String tipoFactura) {
        String preffix = '';
        switch on tipoFactura {
            when 'RESERVAS' { preffix = '01'; }
            when 'DEPOSITOS' { preffix = '02'; }
            when 'FACTURA DE VENTA' { preffix = '03'; }
            when 'ENTREGAS A CUENTA' { preffix = '04'; }
            when 'FACTURA RECTIFICATIVA' { preffix = '09'; }
            when 'MEJORAS' { preffix = '05'; }
            when 'APORTACIONES CAPITAL' { preffix = '06'; }
            when 'OTRAS VENTAS' { preffix = '07'; }
            when else {
                // TODO -> LANZAR EXCEPCIÓN
            }
        }
        return preffix;
    }

    private static String generateSecuencialNum(Decimal maxNumero) {   
        String newNum = String.valueOf(maxNumero + 1); 
        return newNum.leftPad(6, '0');
    }
    
    private static void sendEmail(List <Factura__c> lista){  
        List <String> lEmails = System.label.EmailNumFacturaMsg.split(';');
                
		String msg = 'Hola,' + '\n' + '\n' + 'Para generar el número de factura y su secuencia se necesita informar el campo Fecha de factura de las siguientes facturas: ' + '\n' + '\n';

        for(Factura__c fact: lista){
        	msg = msg + '- Oportunidad: ' + fact.Oportunidad__r.Name+ ', Factura: ' + fact.Name + ', Cliente: ' + fact.Cliente__r.Name + '\n';
        }
        
        msg = msg + '\n' + 'Un saludo';
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = lEmails;
        message.optOutPolicy = 'FILTER';
        message.subject = 'Números de factura no generados';
        message.plainTextBody = msg;
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'comercial@avintiainmobiliaria.com'];
		if ( owea.size() > 0 ) {
    		message.setOrgWideEmailAddressId(owea.get(0).Id);
		}
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
    }

}