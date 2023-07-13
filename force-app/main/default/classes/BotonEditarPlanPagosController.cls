public class BotonEditarPlanPagosController {

/******************************************************************************************************************************
* Method Name: getCuotas                                                                                                      *
* Description:  Recupera las cuotas cobradas y pendientes de emitir que esten activas para poder modificarlas en la pantalla. *
*               Ademas, si hay varios participantes, unifica las cuotas por fecha.
* Author: Deloitte                                                                                                            *
* ****************************************************************************************************************************/      
    
    @AuraEnabled
    public static List<Factura__c> getCuotas(Id oportunidadId, String tipoCuota){
        
        Opportunity oportunidad = [SELECT Id, Facturacion_por_separado__c FROM Opportunity WHERE Id =: oportunidadId];
        
        //Estado_de_la_factura__c si Pdt de envío a Oracle, entonces se puede modificar
        List<Factura__c> facturasPendientesList = [SELECT Id, Name, Tipo_de_factura__c, Tipologia__c, Referencia__c, Obra__c, Descripcion__c, Sociedad__c,
                                         Fecha_de_emision__c
                                                   , Fecha_Contable__c, Condicion_Cobro__c, Metodo_de_cobro__c, 	Codigo_Impuesto__c, 
                                         Importe__c, Pago_o_Cuota__c, Estado_de_la_factura__c, Estado_plan_de_pagos__c, Cliente__r.Name, Origen__c
                                         FROM Factura__c
                                         WHERE Oportunidad__c =:oportunidadId AND Pago_o_Cuota__c =: tipoCuota AND Estado_plan_de_pagos__c = 'Activo' AND Estado_de_la_factura__c != 'Cancelada'];
        
        List<Factura__c> facturasList = [SELECT Id, Name, Tipo_de_factura__c, Tipologia__c, Referencia__c, Obra__c, Descripcion__c, Sociedad__c,
                                                 Fecha_de_emision__c, Fecha_Contable__c, Condicion_Cobro__c, Metodo_de_cobro__c, 	Codigo_Impuesto__c, 
                                                 Importe__c, Pago_o_Cuota__c, Estado_de_la_factura__c, Estado_plan_de_pagos__c, Cliente__r.Name, Origen__c
                                                 FROM Factura__c
                                        		 WHERE Oportunidad__c =:oportunidadId AND Estado_plan_de_pagos__c = 'Inactivo' AND Estado_de_la_factura__c != 'Cancelada' AND Estado_de_la_factura__c != 'Pendiente de emisión'
                                                 ORDER BY Fecha_de_emision__c ASC];
        
        facturasList.addAll(facturasPendientesList);
        
        system.debug('facturasList:::'+facturasList);
        //Creamos un map que nos permita sumar para fechas iguales, los importes de las facturas
        Map<Date,Decimal> cuotasMap = new Map<Date,Decimal>(); 
        for(Factura__c factura : facturasList){
        	if(!cuotasMap.keySet().contains(factura.Fecha_de_emision__c) && factura.Importe__c != null){
            	cuotasMap.put(factura.Fecha_de_emision__c, factura.Importe__c);
             }else if(factura.Importe__c != null){
                Decimal importeViejo = cuotasMap.get(factura.Fecha_de_emision__c);
             	cuotasMap.put(factura.Fecha_de_emision__c, importeViejo + factura.Importe__c);
             }
        }
        
        system.debug('cuotasMap:::'+cuotasMap);
        
        //Como no se puede acceder a maps en lightning, utilizamos un objeto de tipo factura para guardar las facturas unificadas y poder iterarlas en la componente,
        //como las cuotas extra no tienen Fecha, se uniran todas en null, por eso necesitamos saber antes cuantas cuotas extra quedan por pagar, para dividir
        //el valor guardado para la clave null entre el numero de cuotas
        
        List<String> clientesList = new List<String>();
        Integer cuotasExtraContador = 0;
        if(tipoCuota == 'Cuota Extra'){
            for(Factura__c factura : facturasList){
                if(!clientesList.contains(factura.Cliente__r.Name)){
                    clientesList.add(factura.Cliente__r.Name);
                }if(!(factura.Estado_de_la_factura__c == 'Cobrada') && factura.Fecha_de_emision__c == null){
                    cuotasExtraContador += 1;
                }
            }
        }
        system.debug('cuotasExtraContador: '+ cuotasExtraContador); //SCA
        
		Set<Date> fechaFacturaSet = cuotasMap.keySet();
        List<Factura__c> facturasUnificadasList = new List<Factura__c>();
        for(Date fechaFactura : fechaFacturaSet){
            //Si alguna factura tenia fecha nula, habra una clave que sea null
            if(fechaFactura != null){
                Factura__c facturaUnificada = new Factura__c(Fecha_de_emision__c = fechaFactura, Importe__c = cuotasMap.get(fechaFactura));
                facturasUnificadasList.add(facturaUnificada);
            }else if(tipoCuota == 'Cuota Extra'){
                for(Integer i=0; i < cuotasExtraContador/clientesList.size(); i++) {
					Factura__c facturaUnificada = new Factura__c(Fecha_de_emision__c = fechaFactura, Importe__c = cuotasMap.get(fechaFactura)/(cuotasExtraContador/clientesList.size()));
					facturasUnificadasList.add(facturaUnificada);
				}
            }
        }
        
        for(Factura__c factura : facturasList){
            for(Factura__c facturaUnificada : facturasUnificadasList){
                if(factura.Fecha_de_emision__c == facturaUnificada.Fecha_de_emision__c){
                    facturaUnificada.Estado_de_la_factura__c = factura.Estado_de_la_factura__c;
                    facturaUnificada.Name = factura.Name;
                    facturaUnificada.Tipo_de_factura__c = factura.Tipo_de_factura__c;
                    facturaUnificada.Tipologia__c = factura.Tipologia__c;
                    facturaUnificada.Referencia__c = factura.Referencia__c;
                    //facturaParticipante.Obra__c = factura.Obra__c;
                    facturaUnificada.Descripcion__c = factura.Descripcion__c;
                    facturaUnificada.Sociedad__c = factura.Sociedad__c;
                    facturaUnificada.Fecha_Contable__c = factura.Fecha_Contable__c;
                    facturaUnificada.Condicion_Cobro__c = factura.Condicion_Cobro__c;
                    facturaUnificada.Metodo_de_cobro__c = factura.Metodo_de_cobro__c;
                    facturaUnificada.Pago_o_Cuota__c = factura.Pago_o_Cuota__c;
                    facturaUnificada.Origen__c = factura.Origen__c;
                    facturaUnificada.Oportunidad__c = oportunidadId;
                    facturaUnificada.Codigo_Impuesto__c = factura.Codigo_Impuesto__c;
                    facturaUnificada.Estado_plan_de_pagos__c = factura.Estado_plan_de_pagos__c; //SCA
                }
            }
        }
        
        //Añadido SCA
        if(tipoCuota != 'Cuota Extra'){
            List<Factura__c> AbonosList = [SELECT Id, Importe__c FROM Factura__c WHERE Oportunidad__c =:oportunidadId AND Pago_o_Cuota__c = 'Abono' 
                                           AND Plan_de_pagos__c != null AND Tipo_de_factura__c = 'FACTURA RECTIFICATIVA' AND 
                                           Estado_de_la_factura__c != 'Cancelada'/*( Estado_de_la_factura__c = 'Cobrada' OR Estado_de_la_factura__c = 'Volcada y Emitida')*/];
            
            if(AbonosList != null && !AbonosList.isEmpty()){
                Double importeTotalAbonos = 0;
                for(Factura__c FacturaAbono : AbonosList){
                    importeTotalAbonos = importeTotalAbonos + FacturaAbono.Importe__c ;
                }
                if(importeTotalAbonos != 0){
                    Factura__c facturaAux = new Factura__c(Fecha_de_emision__c = null, Importe__c = importeTotalAbonos, Concepto__c = 'Factura Auxiliar Abono');
                    facturasUnificadasList.add(facturaAux);
                }
            }
        }
        //Fin añadido SCA

        //system.debug('facturasUnificadasList:::'+facturasUnificadasList);
		return facturasUnificadasList;
    }

   

/*********************************************************************************************************************************************
* Method Name: crearPlanPagos                                                                                                                *
* Description: Crea el plan de pagos, con sus facturas, y sus lineas de factura. Si la accion viene del boton Guardar, el plan de pagos se 
*              guarda como Borrador y si no como Pdte de Aprobación
*              Si se factura por separado, vuelve a separar las cuotas segun el porcentaje de participacion de cada participante
* Author: Deloitte                                                                                                                            *
* ********************************************************************************************************************************************/ 
    
    @AuraEnabled
    public static List<String> crearPlanPagos(Id oportunidadId, List<Factura__c> facturasList, Decimal descuadre, String accionBoton, List<Factura__c> facturasExtraList, Decimal descuadreExtra){

        system.debug('Entra en crearPlanPagos');
        if((descuadre == 0 && descuadreExtra == 0) || (descuadre == 0 && descuadreExtra == null)) {
        	

            Opportunity oportunidad = [SELECT Promocion__r.Name, Account.Name, AccountId, Amount, Facturacion_por_separado__c, MetodoDeCobro__c FROM Opportunity WHERE Id =: oportunidadId];
            
            //Primero mirar cuantas personas participan en la Oportunidad
            List<Participante__c> participanteList;
            if(oportunidad.Facturacion_por_separado__c == True){
                participanteList = [SELECT Id, Porcentaje_de_participacion__c, Opportunity__c, Cliente__c
                                                          FROM Participante__c
                                                          WHERE Opportunity__c =: oportunidadId];                
            }else{
               participanteList = [SELECT Id, Porcentaje_de_participacion__c, Opportunity__c, Cliente__c
                                                          FROM Participante__c
                                                          WHERE Opportunity__c =: oportunidadId AND Cliente__c =: oportunidad.AccountId LIMIT 1];
                
               participanteList[0].Porcentaje_de_participacion__c=100;
            }

            //Recogemos los planes de pagos asociados a la oportunidad
            List<Plan_de_pagos__c> planPagosList = [SELECT Id FROM Plan_de_pagos__c WHERE Oportunidad__c =: oportunidadId];
            system.debug('planPagosList:::'+planPagosList);
            
            
            Plan_de_pagos__c planPagos;
            //Se crea un nuevo registro de Plan de pagos con diferente estado según el boton al que se haya dado. Las facturas nuevas que se creen se relacionarán con este
            if(accionBoton == 'Guardar'){
            	planPagos = new Plan_de_pagos__c(Name = oportunidad.Promocion__r.Name + ' - '+ oportunidad.Account.Name + ' - '+ 'Versión ' + String.valueOf(planPagosList.size() + 1) , Oportunidad__c = oportunidadId, Estado__c = 'Borrador');
            }else if(accionBoton == 'Solicitar'){
                planPagos = new Plan_de_pagos__c(Name = oportunidad.Promocion__r.Name + ' - '+ oportunidad.Account.Name + ' - '+ 'Versión ' + String.valueOf(planPagosList.size() + 1), Oportunidad__c = oportunidadId, Estado__c = 'Pdte de Aprobación');
            }

            Savepoint sp = Database.setSavepoint();
            try{
            	insert planPagos;                 
                //Se recorren la lista de facturas resultante y se crean las facturas necesarias según los participantes
                if(!facturasList.isEmpty()){
                    facturasList.addAll(facturasExtraList);
                }
                List<Factura__c> facturasToInsert = new List<Factura__c>();
                Integer index = 0;
                for(Factura__c factura : facturasList){
                    if(factura.Estado_de_la_factura__c == 'Pendiente de emisión'){
                        for(Participante__c participante : participanteList){
                            Factura__c facturaParticipante = new Factura__c();
                            //Es ImporteFactura__c, pero ese campo es un RollUp summary                     
                            facturaParticipante.Cliente__c = participante.Cliente__c;
                            //Si la fecha no esta rellena se lanza una excepcion y un mensaje de alerta al usuari                            //
                             system.debug(factura.Fecha_de_emision__c);
                            try{
                                if(factura.Pago_o_Cuota__c == 'Cuota'){
                                    facturaParticipante.Name = 'Factura ' + String.valueOf(index + 1) + ' Plan de pagos ' + String.valueOf(factura.Fecha_de_emision__c.year()) + '-' + String.valueOf(factura.Fecha_de_emision__c.month()) +'-'+ String.valueOf(factura.Fecha_de_emision__c.day()) ;              
                                }else if(factura.Pago_o_Cuota__c == 'Cuota Extra'){
                                    facturaParticipante.Name = 'Cuota Extra';
                                }
                       
                            }catch(System.Exception e){
                                System.debug('BotonEditarPlanPagosController | crearPlanPagos() - NullPointerException: ' + e.getMessage());
                    			throw new GenerarPlanPagosException('Todas las cuotas deben tener Fecha de emisión.');
                            }
                            
                            //if(factura.Fecha_de_emision__c < Date.today() ){
                               
                                //List<String> respuestaList = new List<String>();
                                //respuestaList.add('error'); /* tipo de error */
                                //respuestaList.add('ERROR'); /* mensaje de error */
                                //respuestaList.add('Las cuotas no pueden tener fecha anterior a la actual.'); /* detalle de mensaje de error */
                                //system.debug('respuestaList:::'+respuestaList);
                                //return respuestaList;    
                            //}
                            facturaParticipante.Tipo_de_factura__c = factura.Tipo_de_factura__c;
                            facturaParticipante.Tipologia__c = factura.Tipologia__c;
                            facturaParticipante.Referencia__c = factura.Referencia__c;
                            //facturaParticipante.Obra__c = factura.Obra__c;
                            facturaParticipante.Descripcion__c = factura.Descripcion__c;
                            facturaParticipante.Sociedad__c = factura.Sociedad__c;
                            facturaParticipante.Fecha_de_emision__c = factura.Fecha_de_emision__c;
                            facturaParticipante.Fecha_Contable__c = factura.Fecha_de_emision__c;
                            facturaParticipante.Condicion_Cobro__c = factura.Condicion_Cobro__c;
                            facturaParticipante.Metodo_de_cobro__c = oportunidad.MetodoDeCobro__c;
                            //Si la fecha esta rellena, pero el importe no, se lanza tambien un mensaje de alerta al usuario para evitar que se inserte una factura sin importe 
                            if(factura.Importe__c != null && factura.Importe__c != 0){
                            	facturaParticipante.Importe__c = factura.Importe__c*participante.Porcentaje_de_participacion__c/100;
                            }else{
                                System.debug('BotonEditarPlanPagosController | crearPlanPagos() - El importe no puede ser 0 o nulo');
                                List<String> respuestaList = new List<String>();
                                respuestaList.add('error');
                                respuestaList.add('ERROR');
                                respuestaList.add('No se puede crear un pago sin importe.');
                                system.debug('respuestaList:::'+respuestaList);
                                return respuestaList;
                                
                            }                          
                            facturaParticipante.Pago_o_Cuota__c = factura.Pago_o_Cuota__c;
                            facturaParticipante.Codigo_Impuesto__c = factura.Codigo_Impuesto__c;
                            facturaParticipante.Estado_de_la_factura__c = factura.Estado_de_la_factura__c; 
                            facturaParticipante.Estado_plan_de_pagos__c = 'Inactivo';
                            facturaParticipante.Oportunidad__c = oportunidadId;
                            facturaParticipante.Plan_de_pagos__c = planPagos.Id;
                            facturaParticipante.Origen__c = factura.Origen__c;
                            facturaParticipante.Porcentaje_de_participacion__c = participante.Porcentaje_de_participacion__c;
                            system.debug('facturaParticipante.Porcentaje_de_participacion__c:::'+facturaParticipante.Porcentaje_de_participacion__c);
                            system.debug('participante.Porcentaje_de_participacion__c:::'+participante.Porcentaje_de_participacion__c);
                            facturasToInsert.add(facturaParticipante);
                    	}    
                            index+=1;   
                    }

                }
                try{
                    insert facturasToInsert;
                    system.debug('facturasToInsert:::'+facturasToInsert);
                    system.debug('facturasToInsert.size():::'+facturasToInsert.size()); 

                    //Segun los productos asociados a la Oportunidad, se crean las lineas de factura, que se corresponderan con el importe proporcional a cada producto.
                    //Si el importe de la vivienda y los anejos va incluido en el precio de vivienda, habra una unica linea de factura y se pone indica en el nombre de la linea los inmuebles que se incluyen
                    //Si el cada inmueble tiene su importe, entonces se hacen tantas lineas como productos asociados a la oportunidad, y sus importes seran proporcionales a los importes de los productos
                    List<OpportunityLineItem> opportunityLineItemList = [SELECT Id, Name, UnitPrice, Description FROM OpportunityLineItem WHERE OpportunityId =: oportunidadId];
                    
                    //Se itera la lista de objetos y nos quedamos solo con los que tienen precio, estos seran los que tendran linea
                    List<OpportunityLineItem> opportunityLineItemConPrecioList = new List<OpportunityLineItem>();
                    for(OpportunityLineItem opportunityLineItem : opportunityLineItemList){
                        if(opportunityLineItem.UnitPrice != null){
                        	opportunityLineItemConPrecioList.add(opportunityLineItem);                            
                        }
                    }
                    system.debug('opportunityLineItemConPrecioList:::'+opportunityLineItemConPrecioList);

                    //A continuacion se crean las lineas de factura para cada factura
                    List<Linea_de_factura__c> lineaFacturaList = new List<Linea_de_factura__c>();
                    for(Factura__c factura : facturasToInsert){
                        Integer indice = 0;
                        for(OpportunityLineItem opportunityLineItem : opportunityLineItemList){
                            if(opportunityLineItem.UnitPrice != 0){
                                indice+= 1;
                                Linea_de_factura__c lineaFactura = new Linea_de_factura__c();
                                lineaFactura.Factura__c = factura.Id;
                                lineaFactura.Tipo_de_linea__c = 'Entrega a cuenta';
                                if(opportunityLineItem.Description != null && opportunityLineItem.Description.length() > 80){
                                	lineaFactura.Name = opportunityLineItem.Description.substring(0, 80); /* Hay que tener en cuenta lo de que si el Importe es 0 se ponga el nombre de los inmuebles que incluye */                                    
                                }else{
                                    lineaFactura.Name = opportunityLineItem.Description;
                                }
                                lineaFactura.DescripcionLinea__c = (opportunityLineItem.Description).length() > 80 ? (opportunityLineItem.Description).substring(0, 80) : opportunityLineItem.Description;
                                if(factura.Importe__c != null && opportunityLineItem.UnitPrice != null && oportunidad.Amount != null){
                                	lineaFactura.Importe__c = factura.Importe__c * opportunityLineItem.UnitPrice/oportunidad.Amount;
                                }
                                lineaFactura.Numero_de_linea__c = indice;
                                lineaFacturaList.add(lineaFactura);                                
                            }

                        }
                    }
                    system.debug('lineaFacturaList:::'+lineaFacturaList);
                    
                    try{
                        insert lineaFacturaList;
                        List<String> respuestaList = new List<String>();
                        respuestaList.add('success');
                        respuestaList.add('ÉXITO');
                        respuestaList.add('El nuevo plan de pagos se ha insertado correctamente.');
                        system.debug('respuestaList:::'+respuestaList);
                        return respuestaList;
                    }catch(System.Exception e){
                        System.debug('BotonEditarPlanPagosController | crearPlanPagos() - DmlException: ' + e.getMessage());
                    	throw new GenerarPlanPagosException('No se han podido añadir las lineas de factura al nuevo plan de pagos.');                       
                    }   
                }
                catch(System.DMLException e){
                    System.debug('BotonEditarPlanPagosController | crearPlanPagos() - DmlException: ' + e.getMessage());
                     throw new GenerarPlanPagosException('No se han podido añadir las facturas al nuevo plan de pagos.');
                }
                /*
                catch(System.Exception e){
                    System.debug('BotonEditarPlanPagosController | crearPlanPagos() - DmlException: ' + e.getMessage());
                    throw new GenerarPlanPagosException('No se han podido añadir las facturas al nuevo plan de pagos.');
                }*/
            }catch(System.Exception e){
                System.debug('BotonEditarPlanPagosController | crearPlanPagos() - DmlException: ' + e.getMessage());
                //respuestaList tiene tres elementos, tipo (que puede ser success o error), mensaje (que es un mensaje general), detalleMensaje (que es un mensaje mas detallado del error)
                List<String> respuestaList = new List<String>();
                respuestaList.add('error'); /* tipo de error */
                respuestaList.add('ERROR'); /* mensaje de error */
                respuestaList.add(e.getMessage()); /* detalle de mensaje de error */
                respuestaList.add('No se ha podido añadir el nuevo plan de pagos.'); /* detalle de mensaje de error */
                system.debug('respuestaList:::'+respuestaList);
                Database.rollback(sp);
                return respuestaList;
            }


        }else{
            //respuestaList tiene tres elementos, tipo (que puede ser success o error), mensaje (que es un mensaje general), detalleMensaje (que es un mensaje mas detallado del error)
            List<String> respuestaList = new List<String>();
            system.debug('DESCUADRE CLASE APEX: ' + descuadre + 'DESCUADRE EXTRA: ' + descuadreExtra);
            respuestaList.add('error'); /* tipo de error */
            respuestaList.add('ERROR'); /* mensaje de error */
            respuestaList.add('El descuadre no puede ser distinto de 0.'); /* detalle de mensaje de error */
            system.debug('respuestaList:::'+respuestaList);
            return respuestaList;
        }

    }
    
    public class GenerarPlanPagosException extends Exception {}
    

}