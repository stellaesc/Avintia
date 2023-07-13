public class Contrato_compraventa_controller {

    //Variables accesibles    
    public static Opportunity oportunidad {get; set;}
    public static Promocion__c promocion {get; set;}
    public Hitos_de_Promocion__c hitoPromocion {get; set;}
    public Product2 inmueble {get; set;} 
    public Account cliente {get; set;}
    public Account promotora {get; set;}//O SOCIEDAD
    public Tipo_de_inmueble__c tipoInmueble {get; set;}
    public AccountRecordType__c AccountRecordType {get;set;}
    public static OpportunityLineItem prodOportunidadLocal {get; set;}
    public Contact Apoderado {get; set;}
    //public Contact representanteLegal {get; set;}
    public Decimal precioTrasteros {get; set;}
    public Decimal precioGarajes {get; set;}    
    
    //Listas
    public List<Participante__c> Titulares {get; set;}
    public List<Product2> listGarajes {get; set;}
    public List<Product2> listTrasteros {get; set;}
    public List<Contact> listRepresentatesLegales {get; set;}
    public List<String> fechaPrimeraCuotaList {get; set;}
    public List<Decimal> cuotasExtraList {get; set;}
    
    //mapas
    public Map <id, Contact> mapRepresentantesLegales {get; set;}
    public Map <id, String> mapRepresentantesFechas {get; set;}
    public Map <id, Municipio__c> maplocalidadTitulares {get; set;}
    
    
    public Integer numInmueblesVPO {get; set;}
    public Integer numInmueblesVPT {get; set;}
    
    public Decimal ImporteOportunidadMenosPenalizacionContrato {get; set;}
    public Decimal complementarioPenalContrato {get; set;}
    public Decimal precioLocalIva {get; set;}
    public Decimal precioLocalTotal {get; set;}
    public Decimal importeFirmaContrato {get; set;}
   

    //fechas
    public String fechaEscrituracionPromocion {get; set;}
    public String fechaCreacion {get; set;}
    public String fechaContratoReservaLocal {get; set;}
    public String fechaPrimeraCuota {get; set;}
    public String fechaAprobacionLicencia {get; set;}
    public String fechaFirmaContratoCompraventa {get; set;}
    public String fechaFirmaContratoReserva {get; set;}
    public String fechaFirmaContratoReservaMayuscula {get; set;}
    public String fechaEscrituraPromotora {get; set;}
    public String fechaEscrituraClienteEmpresa {get; set;}
    	//public String fechaEscrituraApoderado {get; set;}
    
    
    //Variable globales internas
    Private Set<id> setParticipantes = new Set<id>();
    Private Set<id> setLocalidades = new Set<id>();
    
    
    //Variables importe formateadas
    public String StrOpporReserv {get;set;}
    public String StrOpporPenal {get;set;}
    public String StrPromSupTotalParcela {get;set;}
    public String StrInmuSuperConstTot {get;set;}
    public Map<Id, List<String>> MapGarajes {get;set;}
    public Map<Id, List<String>> MapTrasteros {get;set;}
    public String StrGarajeName {get;set;}
    public String StrGarajePlanta {get;set;}
    public String StrGarajeSupTotal {get;set;}
    public String StrTrasteroName {get;set;}
    public String StrTrasteroPlanta {get;set;}
    public String StrTrasteroSupTotal {get;set;}
    public Map<Id, List<String>> MapTitulares {get;set;}
    public String StrTitularName {get;set;}
    public String StrTitularReg {get;set;}
    public String StrTitularPorc {get;set;}
    public String StrOpporAmount {get;set;}
    public String StrOpporAmount10x100 {get;set;}
    public String StrOpporAmount80x100 {get;set;}
    public String StrInmuPrecio {get;set;}
    public String StrGarajePrecio {get;set;}
    public String StrTrasteroPrecio {get;set;}
    public String StrOpporPorc {get;set;}
    public String StrOpporAmountRest {get;set;}
    public String StrOpporAmountRestIVA {get;set;}
    public String StrImporteAPlazosIva {get;set;}
    public String StrImporteAPlazos {get;set;}
    public String StrOpporImpCuota {get;set;}
    public String StrOpporImpCuotaIVA {get;set;}
    public String StrImporteCuotasExtra {get;set;}
	public String StrOpporImpCuotaExtra {get;set;}
    public String StrOpporImpEscritura {get;set;}
    public String StrReservaConIva {get;set;}
    public String StrOpporPagoContrato {get;set;}
    public String StrOpporPagoContratoIVA {get;set;}
    public String StrImporteCuotasExtraIVA {get;set;}
    public String StrContratoPrivado {get;set;}
    public String StrOpporImpEntrada {get;set;}
    public List<String> cuotasExtraListForm {get;set;}
    public String StrOpporPagoEscritura {get;set;}
    public String StrOpporPagoEscrituraIVA {get;set;}
    public String SrcOpporPenContrato {get;set;}
    public String StrOpporImpIVA {get;set;}    
    
    public boolean regimenGananciales {get;set;}
    public boolean regimenBienes {get;set;}
    public boolean solteros {get;set;}
    public String idEspanha {get;set;}

    
//-----------------------------------------------------------------------------------------------------------------------//
        
   //Constructor
   public Contrato_compraventa_controller(){
        
       Id idOportunidad = ApexPages.currentPage().getParameters().get('id');
       //Id idOportunidad = '006n0000007YKNtAAO';
        
        			system.debug('Id oportunidad '+idOportunidad);
		
       Oportunidad = [SELECT id, promocion__c, accountId, Amount, Reserva__c, Tipo_de_Reserva__c, Porcentaje_IVA__c, Pago_Contrato__c,
                        N_Cuotas__c, Importe_de_Cuota__c, Fecha_de_primera_cuota__c, pago_Escritura__c, Penalizacion_Contrato__c, 
                      Fecha_firma_Contrato_Reserva__c, Fecha_firma_Contrato_Compraventa__c, Numero_Cuotas_Extra__c, Importe_Cuota_Extra__c,
                      Cuenta_Bancaria_de_mandato__c, BIC_Cuenta_cliente__c, Pago_Contrato_al_contado__c, Fecha_de_Escrituracion__c, Penalizacion_Reserva__c, Importe_de_Entrada__c,
                      Importe_plan_de_pagos__c, Importe_escritura__c, Asignacion_participantes__c, Description,Importe_plan_de_pagos_real__c
                       FROM Opportunity WHERE id =: idOportunidad];
       
       system.debug('Oportunidad CONTROLLER '+oportunidad);
       
       
       getPromocion();
       			system.debug('Promocion controller '+promocion);
       //getLocalidadPromocion();
       getInmuebles();
       			System.debug('inmueble '+inmueble);
       getRecordTypeIdCustomSetting();
       getCliente();
       //getRepresentanteLegal();
       getTitulares();
       getLocalidadTitulares();
       getRepresentantesLegales();
       getPromotora();
       //getTipoInmueble();
       getNumViviendas();
       getImporteOportunidadMenosPenalizacion();
       getApoderado();
       getLocales();
       getImporteOportunidadConIva();
       getHitoPromocion();
       getPrecioGarajes();
       getPrecioTrasteros();
       getFechaPrimeraCuotaList();
       getCuotasExtraList();
       
       if(cliente.Fecha_de_Escritura__c != null){
            fechaEscrituraClienteEmpresa = getFechaString(cliente.Fecha_de_Escritura__c);         
       }
       
       //Para transformar fechas al formato correcto, asignar a una variable pública el resultado de pasar al método general getFechaString la fecha necesaria
       if(promocion.Fecha_de_Escritura__c != null){
       		fechaEscrituracionPromocion = getFechaString(promocion.Fecha_de_Escritura__c);           
       }
       fechaCreacion = getFechaString(Date.today());
       if(promotora.Fecha_de_Escritura__c != null){
       		fechaEscrituraPromotora = getFechaString(promotora.Fecha_de_Escritura__c);    
       }
       if(oportunidad.Fecha_firma_Contrato_Compraventa__c != null){
       		fechaFirmaContratoCompraventa = getFechaString(oportunidad.Fecha_firma_Contrato_Compraventa__c); 
       }
       if(oportunidad.Fecha_firma_Contrato_Reserva__c != null){
            fechaFirmaContratoReserva = getFechaString(oportunidad.Fecha_firma_Contrato_Reserva__c);
            fechaFirmaContratoReservaMayuscula = fechaFirmaContratoReserva.toUpperCase();
       }
       if(promocion.Fecha_de_escritura__c != null){
            fechaContratoReservaLocal = getFechaString(promocion.Fecha_de_escritura__c);    
       }
       if(hitoPromocion != null && hitoPromocion.Aprobacion_de_la_licencia_de_obras__c != null){
            fechaAprobacionLicencia = getFechaString(hitoPromocion.Aprobacion_de_la_licencia_de_obras__c);    
       }
       if(oportunidad.Fecha_de_primera_cuota__c != null){
           
            fechaPrimeraCuota =   '10 de '+
            						getMesEscrito(oportunidad.Fecha_de_primera_cuota__c.month()) +' de '+
        							String.valueOf(oportunidad.Fecha_de_primera_cuota__c.year());
   
       }
       /*if(Apoderado.Fecha_de_Escritura__c != null){
            fechaEscrituraApoderado = getFechaString(Apoderado.Fecha_de_Escritura__c);    
       }*/
       
       //Para obtener la otra parte del porcentaje de penalización
       if(oportunidad.Penalizacion_Contrato__c != null){
       		complementarioPenalContrato = 100 - oportunidad.Penalizacion_Contrato__c;
       }

       //Método para calcular un precio con IVA:
       if(prodOportunidadLocal != null && prodOportunidadLocal.Product2.Precio__c != null && oportunidad.Porcentaje_IVA__c != null){
       		precioLocalIva = getImporteIva(prodOportunidadLocal.Product2.Precio__c,oportunidad.Porcentaje_IVA__c);           
       }
       if(prodOportunidadLocal != null && prodOportunidadLocal.Product2.Precio__c != null && precioLocalIva != null){
       		precioLocalTotal = prodOportunidadLocal.Product2.Precio__c + precioLocalIva;    
       }
       if(prodOportunidadLocal != null && precioLocalTotal != null && promocion.Porcentaje_Pago_Firma_Contrato__c != null){
       		importeFirmaContrato = getImporteIva(precioLocalTotal,promocion.Porcentaje_Pago_Firma_Contrato__c);           
       }
       
       
       List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
          	//Formateamos campos de importe
           	if(Oportunidad.Reserva__c != null){
           		StrOpporReserv = String.format(Oportunidad.Reserva__c.format(), formateo);
           	}
       		if(Oportunidad.Penalizacion_Reserva__c != null){
       			StrOpporPenal = String.format(Oportunidad.Penalizacion_Reserva__c.format(), formateo);
            }
       		if(oportunidad.Amount != null){
       			StrOpporAmount = String.format(oportunidad.Amount.format(), formateo);
            }
            if(oportunidad.Amount != null){
                Decimal StrOpporAmount10 = oportunidad.Amount * 10/100;
       			StrOpporAmount10x100 = String.format(StrOpporAmount10.format(), formateo);

                Decimal StrOpporAmount80 = oportunidad.Amount * 80/100;
       			StrOpporAmount80x100 = String.format(StrOpporAmount80.format(), formateo);
            }
       		if(oportunidad.Porcentaje_IVA__c != null){
       			StrOpporPorc = String.format(oportunidad.Porcentaje_IVA__c.format(), formateo);
       		}
       		if(oportunidad.amount != null && oportunidad.Pago_Contrato_al_contado__c != null){
       			Decimal OpporAmountRest = oportunidad.amount * oportunidad.Pago_Contrato_al_contado__c/100;
            	OpporAmountRest = OpporAmountRest.setScale(2);
            	StrOpporAmountRest = String.format(OpporAmountRest.format(), formateo);
       		}
       		if(oportunidad.amount != null && oportunidad.Pago_Contrato_al_contado__c != null && oportunidad.Porcentaje_IVA__c != null){
            	Decimal OpporAmountRestIVA = oportunidad.amount * oportunidad.Pago_Contrato_al_contado__c/100 *(1 + oportunidad.Porcentaje_IVA__c/100);
            	OpporAmountRestIVA = OpporAmountRestIVA.setScale(2);
            	StrOpporAmountRestIVA = String.format(OpporAmountRestIVA.format(), formateo);
       		}
       		if(oportunidad.Importe_plan_de_pagos_real__c != null){
            	StrImporteAPlazos = String.format(oportunidad.Importe_plan_de_pagos_real__c.format(), formateo);
       		}
       		if(getImporteAPlazos() != null && oportunidad.Porcentaje_IVA__c != null &&getImporteAPlazos() != null){
            	Decimal ImporteAPlazosIva = getImporteAPlazos() + ((oportunidad.Porcentaje_IVA__c*0.01) * getImporteAPlazos());
            	ImporteAPlazosIva = ImporteAPlazosIva.setScale(2);
            	StrImporteAPlazosIva = String.format(ImporteAPlazosIva.format(), formateo);
            }               
            // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INCIDENCIA SUSANA CUESTA >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            // if(oportunidad.Importe_de_Cuota__c != null){
            // 	StrOpporImpCuota = String.format(oportunidad.Importe_de_Cuota__c.format(), formateo);
       		// }
            if(oportunidad.Numero_Cuotas_Extra__c != null && oportunidad.Importe_Cuota_Extra__c != null){
                Decimal ImporteCuotasExtra = Oportunidad.Numero_Cuotas_Extra__c * Oportunidad.Importe_Cuota_Extra__c;
                ImporteCuotasExtra = ImporteCuotasExtra.setScale(2);
                StrImporteCuotasExtra = String.format(ImporteCuotasExtra.format(), formateo);
            }
       		if(oportunidad.Importe_Cuota_Extra__c != null){
       			StrOpporImpCuotaExtra = String.format(oportunidad.Importe_Cuota_Extra__c.format(), formateo);
       		}
       		if(oportunidad.Importe_escritura__c != null){
       			StrOpporImpEscritura = String.format(oportunidad.Importe_escritura__c.format(), formateo);
       		}
       		if(oportunidad.reserva__c != null && oportunidad.Porcentaje_IVA__c != null && oportunidad.reserva__c != null){
       			Decimal reservaConIva = oportunidad.reserva__c + ((oportunidad.Porcentaje_IVA__c*0.01) * oportunidad.reserva__c);
       			reservaConIva = reservaConIva.setScale(2);
       			StrReservaConIva = String.format(reservaConIva.format(), formateo);
       		}
       		if(oportunidad.amount != null && oportunidad.Pago_Contrato_al_contado__c != null && oportunidad.Reserva__c != null){
       			Decimal pagoContratoContado = oportunidad.amount* oportunidad.Pago_Contrato_al_contado__c*0.01 - oportunidad.Reserva__c;
            	pagoContratoContado = pagoContratoContado.setScale(2);    
            	StrOpporPagoContrato = String.format(pagoContratoContado.format(), formateo);
       		}
       		if(oportunidad.amount != null && oportunidad.Pago_Contrato_al_contado__c != null && oportunidad.Reserva__c != null && oportunidad.Porcentaje_IVA__c != null){
       			Decimal pagoContratoContadoIVA = (oportunidad.amount* oportunidad.Pago_Contrato_al_contado__c*0.01 - oportunidad.Reserva__c) * (1 + oportunidad.Porcentaje_IVA__c*0.01);
       			pagoContratoContadoIVA = pagoContratoContadoIVA.setScale(2);
            	StrOpporPagoContratoIVA = String.format(pagoContratoContadoIVA.format(), formateo);
       		}
       		if(oportunidad.Numero_Cuotas_Extra__c !=null && oportunidad.Importe_Cuota_Extra__c != null && oportunidad.Porcentaje_IVA__c != null){
                Decimal importeCuotasExtraIVA = oportunidad.Numero_Cuotas_Extra__c * oportunidad.Importe_Cuota_Extra__c * (1 + oportunidad.Porcentaje_IVA__c * 0.01);
       			importeCuotasExtraIVA = importeCuotasExtraIVA.setScale(2);
       			StrImporteCuotasExtraIVA = String.format(importeCuotasExtraIVA.format(), formateo);
            }
       		if(oportunidad.Importe_de_Entrada__c != null && oportunidad.Reserva__c != null){
           		Decimal contratoPrivado = oportunidad.Importe_de_Entrada__c-oportunidad.Reserva__c;
            	contratoPrivado = contratoPrivado.setScale(2);    
            	StrContratoPrivado = String.format(contratoPrivado.format(), formateo);
       		}
       		if(oportunidad.Importe_de_Entrada__c != null){
       			StrOpporImpEntrada = String.format(oportunidad.Importe_de_Entrada__c.format(), formateo);
       		}
       		if(oportunidad.Numero_Cuotas_Extra__c != null){
           		Decimal numCuotasExtra = oportunidad.Numero_Cuotas_Extra__c;
      			cuotasExtraListForm = new List<String>();
           		for(Integer i = 0; i < numCuotasExtra; i++){
                	if(oportunidad.Importe_Cuota_Extra__c != null){
               			cuotasExtraListForm.add(String.format(oportunidad.Importe_Cuota_Extra__c.format(), formateo));
                    }
           		}
               }
            // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INCIDENCIA SUSANA CUESTA >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
       		// if(oportunidad.Amount != null && oportunidad.Pago_Escritura__c != null){
       		// 	Decimal pagoEscritura =  oportunidad.Amount * oportunidad.Pago_Escritura__c/100;
       		// 	pagoEscritura = pagoEscritura.setScale(2);
            //     StrOpporPagoEscritura = String.format(pagoEscritura.format(), formateo);
       		// }
       		if(oportunidad.Penalizacion_Contrato__c != null){
       			SrcOpporPenContrato = String.format(oportunidad.Penalizacion_Contrato__c.format(), formateo);
       		}
       		if(oportunidad.amount != null && oportunidad.Porcentaje_IVA__c != null){
       			Decimal opporImpIVA = oportunidad.amount + (oportunidad.amount * oportunidad.Porcentaje_IVA__c * 0.01);
       			opporImpIVA = opporImpIVA.setScale(2);
       			StrOpporImpIVA = String.format(opporImpIVA.format(), formateo);
            }
            // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INCIDENCIA SUSANA CUESTA >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            if(oportunidad.Amount != null && oportunidad.Pago_Escritura__c != null){

                Decimal pagoEscritura       = oportunidad.Amount * oportunidad.Pago_Escritura__c/100;
                Decimal pagoEscrituraIva    = pagoEscritura + pagoEscritura*( (oportunidad.Porcentaje_IVA__c * 0.01) );

                pagoEscritura   = pagoEscritura.setScale(2);
                pagoEscrituraIva= pagoEscrituraIva.setScale(2);

                StrOpporPagoEscritura   = String.format(pagoEscritura.format(), formateo);
                StrOpporPagoEscrituraIVA= String.format(pagoEscrituraIva.format(), formateo);               

            }
            // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INCIDENCIA SUSANA CUESTA >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            if(oportunidad.Importe_de_Cuota__c != null){

                Decimal OpporImpCuotaConIVA;

                OpporImpCuotaConIVA = oportunidad.Importe_de_Cuota__c + oportunidad.Importe_de_Cuota__c * ( (oportunidad.Porcentaje_IVA__c * 0.01) );
                OpporImpCuotaConIVA = OpporImpCuotaConIva.setScale(2);

                StrOpporImpCuotaIVA = String.format(OpporImpCuotaConIVA.format(), formateo);

                StrOpporImpCuota = String.format(oportunidad.Importe_de_Cuota__c.format(), formateo);
            }
    }
    
    
    //Métodos
     public void getPromocion(){
        
        promocion = [SELECT id, name, Tipo_via__c, Nombre_via__c, N_Via__c, Socio_Empresa_Promotora__c,
                     		Codigo_postal__c, Localidad__c, Provincia__c, Superficie_total_de_parcela__c, Descricion_pequena__c, Descripcion__c,
                     		Semestre_de_escrituracion__c, Inicio_de_escrituraciones__c, N_Viviendas_totales_promocion__c,
                     		Lugar_del_registro__c, Tomo__c, Libro__c, Folio__c, Finca__c, Fecha_de_Escritura__c, Nombre_notario__c, Numero_de_protocolo__c,
                     		Contact__r.Name, Contact__r.N_Documento__c, Contact__r.Tipo_de_documento__c,
                     		Contact__r.Nacionalidad__c, Contact__r.Nombre_via__c, Contact__r.Numero_via__c, Contact__r.N_Piso__c ,
                     		Contact__r.Puerta__c, Contact__r.Localidad__r.Name, Contact__r.Estado_Civil__c, Contact__r.Fecha_de_Escritura__c,
                     		Contact__r.Nombre_notario__c, Contact__r.Numero_de_protocolo__c, 
                     		Informacion_de_arquitectos_de_obra__c, Cuenta_Activa_1__c, Cuenta_Activa_2__c, Numero_de_cuenta_bancaria_1__c, Numero_de_cuenta_bancaria_2__c, 
                     		Entidad_Bancaria1__c, Entidad_Bancaria2__c, Contact__c, Referencia_catastral__c, N_Garages_totales_promocion__c,
                     		N_Trasteros_totales_promocion__c, N_Locales_totales_promocion__c, Lugar_de_la_notaria__c, Condicion__c, descripcion_suelo__c, Socio_Empresa_Comercializadora__r.Name,
                     		Periodo_de_Reserva__c, Promocion__c.Localidad__r.name, Constructora__r.Name, Constructora__r.Tipo_de_via_FISCAL__c, Constructora__r.Nombre_de_via_FISCAL__c,
                     		Constructora__r.N_via_FISCAL__c, Constructora__r.Codigo_postal_FISCAL__c, Constructora__r.Localidad_FISCAL__r.Name, Constructora__r.Pais_FISCAL__r.Name,
                     		Constructora__r.Tipo_de_documento__c, Constructora__r.N_Documento__c, nombre_promocion__c, Direccion_Suelo__c
                            FROM Promocion__c WHERE Id =: Oportunidad.promocion__c];
         
             List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
          	//Formateamos campos de importe
            if(promocion.Superficie_total_de_parcela__c != null){
           		StrPromSupTotalParcela = String.format(promocion.Superficie_total_de_parcela__c.format(), formateo);
            }
        
    }
    
    public String getOficina(){
        
        String oficina;
        String cuentaSinEspacios;
        
        if(promocion.Cuenta_Activa_1__c == true){
            
           cuentaSinEspacios =  String.valueOf(promocion.Numero_de_cuenta_bancaria_1__c).replaceAll('\\s','');
        }
        else if(promocion.Cuenta_Activa_2__c == true){
            
            cuentaSinEspacios =  String.valueOf(promocion.Numero_de_cuenta_bancaria_2__c).replaceAll('\\s','');
        }
        
        if(cuentaSinEspacios != null && cuentaSinEspacios.length() > 12){
           oficina = cuentaSinEspacios.substring(9, 13);
        }else{
           oficina = cuentaSinEspacios;
        }

        
        return oficina;
        
    }
    
    public void getHitoPromocion(){

        List<Hitos_de_Promocion__c> hitosPromocionList = [SELECT Aprobacion_de_la_licencia_de_obras__c FROM Hitos_de_Promocion__c 
                                    WHERE Promocion__c =: Oportunidad.promocion__c AND Aprobacion_de_la_licencia_de_obras__c != null AND BC__c = TRUE 
                                    ORDER BY CreatedDate DESC];
        if(hitosPromocionList.size() > 0){
			hitoPromocion = hitosPromocionList[0];            
        }

    }
     
    /*public void getRepresentanteLegal(){
    	
        representanteLegal = [SELECT Lugar_de_notaria__c, Fecha_de_Escritura__c, Nombre_notario__c, Numero_de_protocolo__c, Name,
                              N_Documento__c, Tipo_de_documento__c
                              FROM Contact 
                              WHERE AccountId =: cliente.Id AND Representante_legal__c = true LIMIT 1];    
        
    }*/
    
    public static void getLocales(){
        //Obtener producto de oportunidad - inmueble asociado a la oportunidad
        
        List<OpportunityLineItem> prodOportunidadLocalList = [SELECT id, Product2Id, Product2.Superficie_Construida_total_con_ZZCC_m2__c, Product2.Superficie_Util_m2__c, Product2.Tipo_de_inmueble__r.Tipo__c,
                                                    Product2.Letra_N_Puerta__c, Product2.Precio__c
                                                    FROM OpportunityLineItem 
                                                    WHERE OpportunityId =: oportunidad.id AND Product2.Tipo_de_inmueble__r.Tipo__c =: 'Local']; 
        
        if(prodOportunidadLocalList.size() > 0){
            prodOportunidadLocal = prodOportunidadLocalList[0];
        }        

    }
     
    public void getInmuebles(){
        
        //Inicialización de listas
         listGarajes = new List<Product2>();
         listTrasteros = new List<Product2>();
        
        //Obtener producto de oportunidad - inmueble asociado a la oportunidad
        List<OpportunityLineItem> listProductoOportunidad = [SELECT id, Product2Id
                                                        FROM OpportunityLineItem WHERE OpportunityId =: oportunidad.id];
        
        system.debug('Productos de oportunidad '+listProductoOportunidad);
        
        //Almacena las id de los inmuebles (Product2) de los productos de oportunidad
        Set<id> setProductoOportunidad = new Set<id>();
        
        for(integer j = 0; j < listProductoOportunidad.size() ; j++){
            
            setProductoOportunidad.add(listProductoOportunidad[j].Product2Id);
        }
        
        system.debug('SET Productos de oportunidad '+setProductoOportunidad);
        
        //Obtener inmueble e inmuebles asociados
        List<Product2> listaInmuebles = [SELECT id, name, planta__c, Tipologia_de_vivienda__c, Letra_N_Puerta__c, Inmueble_asociado__c, 
                                         Tipo_de_inmueble__c, Precio__c, Tipo_de_via__c, nombre_via__c, piso__c, portal__c, Escalera__c,
                                         N_habitaciones__c, N_banos__c, Superficie_Construida_total_con_ZZCC_m2__c, 
                                         N_Vivienda_Garaje_Trastero_Local__c, Superficie_Util_Trastero_con_pasillos_m2__c,
                                         sup_Cocina__c, sup_Salon__c, sup_Tendedero__c, Superficie_Terrazas_Descubiertas__c, Superficie_Terrazas_Cubiertas__c,
                                         Bloque__c, Superficie_Util_Garaje_con_calles_m2__c, Superficie_Util_m2__c, Tipo_de_inmueble__r.Tipo__c,
                                         N_Via__c, Tipo_de_vivienda__c, Codigo_postal__c, Localidad__c, Description
                                         FROM Product2 WHERE (id IN: setProductoOportunidad AND    (Tipo_de_inmueble__r.tipo__c = 'Vivienda' 
                                                                                                OR Tipo_de_inmueble__r.tipo__c = 'Garaje'
                                                                                                OR Tipo_de_inmueble__r.tipo__c = 'Trastero'
                                                                                                OR Tipo_de_inmueble__r.tipo__c = 'Local'))];
        
        
        
        List<String> listaTipoInmueble = new List<String>();
        for(Product2 inmueble : listaInmuebles){
            listaTipoInmueble.add(inmueble.Tipo_de_inmueble__r.tipo__c);
        }
        
        system.debug('listaInmuebles:::'+listaInmuebles);
        system.debug('listaInmuebles.size():::'+listaInmuebles.size());
        
        //Se asignan los inmuebles dependiendo de su tipo de vivienda
        for(integer i = 0; i < listaInmuebles.size() ; i++){
            
            if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Vivienda'){
                inmueble = listaInmuebles[i];
            }else if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Local'){
                inmueble = listaInmuebles[i];
            }
            else{  
                if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Garaje'){
                     if(!listaTipoInmueble.contains('Vivienda')){
                        inmueble = listaInmuebles[i];
                     }
                     listGarajes.add(listaInmuebles[i]);
                     system.debug('GARAJE ');
                     system.debug('listGarajes:::'+listGarajes);
                 }
                else if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Trastero'){
                     if(!listaTipoInmueble.contains('Vivienda')){
                        inmueble = listaInmuebles[i];
                     }
                    listTrasteros.add(listaInmuebles[i]); 
                    system.debug('TRASTERO ');
                    system.debug('listTrasteros:::'+listTrasteros);
                }
            }
        } 
        
        List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
        //Formateamos campos de importe
        if(inmueble.Superficie_Construida_total_con_ZZCC_m2__c != null){
        	StrInmuSuperConstTot = String.format(inmueble.Superficie_Construida_total_con_ZZCC_m2__c.format(), formateo);
        }
        if(inmueble.Precio__c != null){
            StrInmuPrecio = String.format(inmueble.Precio__c.format(), formateo);
        }
        
        List<String> GarajeAux= new List <String>();
        MapGarajes = new Map<Id, List<String>>();
        
        for(integer i = 0; i < listGarajes.size() ; i++){
            StrGarajeName =  '#@#VACIO#@#';
            StrGarajePlanta = '#@#VACIO#@#';
            StrGarajeSupTotal = '#@#VACIO#@#';
            StrGarajePrecio = '#@#VACIO#@#';
            
            GarajeAux = new List <String>();
            if(listGarajes[i].Name!=null){
            	StrGarajeName = listGarajes[i].Name;
            }
            if(listGarajes[i].Planta__c!=null){
            	StrGarajePlanta = listGarajes[i].Planta__c;
            }
            System.debug(StrGarajePlanta);

            // CAMBIAMOS A M2 ÚTILES EN LOS GARAJES >>
            
            // if( listGarajes[i].Superficie_Util_Garaje_con_calles_m2__c != null ) {
            //     StrGarajeSupTotal = String.format(listGarajes[i].Superficie_Util_Garaje_con_calles_m2__c.format(), formateo);            
            // }

            if(listGarajes[i].Superficie_Construida_total_con_ZZCC_m2__c!=null){
            	StrGarajeSupTotal = String.format(listGarajes[i].Superficie_Construida_total_con_ZZCC_m2__c.format(), formateo);
            }

            if(listGarajes[i].Precio__c!=null){
            	StrGarajePrecio = String.format(listGarajes[i].Precio__c.format(), formateo);
            }
            
           	GarajeAux.add(StrGarajeName);
            GarajeAux.add(StrGarajePlanta);
            GarajeAux.add(StrGarajeSupTotal);
            GarajeAux.add(StrGarajePrecio);
            MapGarajes.put(listGarajes[i].Id, GarajeAux);
        }
        
        
         List<String> TrasteroAux= new List <String>();
        MapTrasteros = new Map<Id, List<String>>();
        
        for(integer i = 0; i < listTrasteros.size() ; i++){
            TrasteroAux = new List <String>();
            StrTrasteroName = '#@#VACIO#@#';
            StrTrasteroPlanta = '#@#VACIO#@#';
            StrTrasteroSupTotal = '#@#VACIO#@#';
            StrTrasteroPrecio = '#@#VACIO#@#';
                
                
            if(listTrasteros[i].Name!=null){
            	StrTrasteroName = listTrasteros[i].Name;
            }
            if(listTrasteros[i].Planta__c!=null){
            	StrTrasteroPlanta = listTrasteros[i].Planta__c;
            }
            if(listTrasteros[i].Superficie_Construida_total_con_ZZCC_m2__c !=null){
            	StrTrasteroSupTotal = String.format(listTrasteros[i].Superficie_Construida_total_con_ZZCC_m2__c.format(), formateo);
            }
            if(listTrasteros[i].Precio__c!=null){
            	StrTrasteroPrecio = String.format(listTrasteros[i].Precio__c.format(), formateo);
            }
            
           	TrasteroAux.add(StrTrasteroName);
            TrasteroAux.add(StrTrasteroPlanta);
            TrasteroAux.add(StrTrasteroSupTotal);
            TrasteroAux.add(StrTrasteroPrecio);
            MapTrasteros.put(listTrasteros[i].Id, TrasteroAux);
        }

    }
    
    public void getNumViviendas(){
    	List<Product2> listaInmuebles = [SELECT Id, Tipo_de_vivienda__c  FROM Product2];
        
        numInmueblesVPO = 0;
        numInmueblesVPT = 0;
        for(Product2 inmueble : listaInmuebles){
            if(inmueble.Tipo_de_vivienda__c == 'VPO'){
                numInmueblesVPO += 1;
            }
            if(inmueble.Tipo_de_vivienda__c == 'VPT'){
                numInmueblesVPT += 1;
            }
        }
        system.debug('numInmueblesVPO:::'+numInmueblesVPO);
        system.debug('numInmueblesVPT:::'+numInmueblesVPT);
    }
    
    public void getCliente(){
        
//DP o DF???
//SI CLIENTE NO ES CUENTA PERSONAL??
        cliente = [SELECT id, name, 
                   Estado_Civil__pc, DP_Localidad__c, DP_Tipo_de_vIa__c, DP_Nombre_via__c, DP_N_via__c, DP_Codigo_postal__c,
                   Tipo_de_documento__c, N_Documento__c,Nacionalidad__r.Name, DP_Localidad__r.Name, tomo__c, Seccion__c, Folio__c,
                   N_Hoja__c, Lugar_de_notaria__pc, RecordTypeId, RecordType.DeveloperName, N_cuenta_corriente__c, Fecha_de_Escritura__c,
                   Nombre_del_notario__c, Numero_de_protocolo__c
                   FROM Account 
                   WHERE Id =: oportunidad.AccountId];
        System.debug('getCliente:::'+cliente);
        
    }
        
    public void getPromotora(){

        System.debug('[1211] promocion.Socio_Empresa_Promotora__c >>>>> '+ promocion.Socio_Empresa_Promotora__c);
        
        promotora = [SELECT id, name, DF_Comunidad_autonoma__c, DF_Provincia__c,  DF_Localidad__r.Name, 
                     DF_Tipo_de_via__c, DF_Nombre_via__c, DF_N_piso__c, DF_Codigo_postal__c,
                     DF_N_via__c, tomo__c, Seccion__c, Folio__c, N_Hoja__c, Nombre_del_notario__c,
                     Lugar_de_notaria__pc, Fecha_de_Escritura__c, Numero_de_protocolo__c,
                     Lugar_del_registro__c, Tipo_de_documento__c, N_Documento__c, 
                     Nombre_notario__pc, N_cuenta_corriente__c, DF_Escalera__c, DF_Puerta__c  
                            FROM Account WHERE Id =: promocion.Socio_Empresa_Promotora__c];
        
    }
    
    
    public void getTitulares(){
        
        
        idEspanha = [SELECT id FROM Pais__c WHERE Name='España' LIMIT 1].Id;
        
        
        List<Participante__c> listParticipantes = [SELECT id, Cliente__c, Porcentaje_de_participacion__c 
                                     FROM Participante__c WHERE Opportunity__c =: oportunidad.id];


        
        for(Integer i = 0; i < listParticipantes.size(); i++){
            
            setParticipantes.add(listParticipantes[i].cliente__c);
        }
        
        Titulares = [SELECT Cliente__r.id, 
                            Cliente__r.Sexo__pc, 
                            Cliente__r.name, 
                            Cliente__r.Estado_Civil__pc, 
                            Cliente__r.DF_Localidad__c, 
                            Cliente__r.DP_Tipo_de_vIa__c, 
                            Cliente__r.DP_Nombre_via__c, 
                            Cliente__r.DP_N_via__c, 
                            Cliente__r.DP_N_piso__c, 
                            Cliente__r.DP_Puerta__c, 
                            Cliente__r.DP_Codigo_postal__c, 
                            Cliente__r.Tipo_de_documento__c, 
                            Cliente__r.DP_Localidad__c, 
                            Cliente__r.N_Documento__c, 
                            Cliente__r.Lugar_del_registro__c, 
                            Cliente__r.Tomo__c, 
                            Cliente__r.seccion__c,
                            Cliente__r.folio__c, 
                            Cliente__r.N_Hoja__c, 
                            Cliente__r.Nombre_del_notario__c, 
                            Cliente__r.Numero_de_protocolo__c, 
                            Cliente__r.Fecha_de_Escritura__c, 
                            Cliente__r.DP_Localidad__r.name, 
                            Cliente__r.Nacionalidad__r.name, 
                            Cliente__r.nacionalidad__c, 
                            Cliente__r.Lugar_de_notaria__pc,  
                            Cliente__r.Regimen__c, 
                            Porcentaje_de_participacion__c, 
                            Name, 
                            Cliente__r.PersonMobilePhone , 
                            Cliente__r.Phone, 
                            Cliente__r.PersonEmail,   
                            Cliente__r.DF_Tipo_de_via__c,
                            Cliente__r.Direccion_Extranjera_P__c,
                            Cliente__r.Direccion_Extranjera_F__c,  
                            Cliente__r.Pais__pr.Name,
                            Cliente__r.Pais_FISCAL__r.Name,
                            Cliente__r.Localidad_Extranjera_F__c
                            FROM Participante__c WHERE Opportunity__c =: oportunidad.id];
        
                            System.debug('Titulares: '+Titulares);
			
        for(integer j = 0; j < Titulares.size(); j++){
        	
        	if(Titulares[j].Cliente__r.Regimen__c == 'Casado/a en régimen de gananciales'){
                regimenGananciales = true;
            }else if (Titulares[j].Cliente__r.Regimen__c == 'Casado/a en separación de bienes'){
            	regimenBienes = true;
            }else if (Titulares[j].Cliente__r.Regimen__c == 'Soltero'){
            	solteros = true;
            }
            
            setLocalidades.add(Titulares[j].Cliente__r.DP_Localidad__c);
        }
		
        
        List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
        //Formateamos campos de importe
        
        List<String> TitularAux= new List <String>();
        MapTitulares = new Map<Id, List<String>>();
        
        for(integer i = 0; i < Titulares.size() ; i++){
            
            StrTitularName = '#@#VACIO#@#';
            StrTitularReg = '#@#VACIO#@#';
            
            TitularAux = new List <String>();
        	            
            if(Titulares[i].Cliente__r.name!=null){
                StrTitularName = Titulares[i].Cliente__r.name;
            }
            if(Titulares[i].Cliente__r.Regimen__c!=null){
                StrTitularReg = Titulares[i].Cliente__r.Regimen__c;
            }
            if(Titulares[i].Porcentaje_de_participacion__c!=null){
            	Decimal porctitular = Titulares[i].Porcentaje_de_participacion__c;
            	porctitular = porctitular.setScale(2);
                StrTitularPorc = String.format(porctitular.format(), formateo);
            }
            
            TitularAux.add(StrTitularName);
            TitularAux.add(StrTitularReg);
           	TitularAux.add(StrTitularPorc);
            MapTitulares.put(Titulares[i].Id, TitularAux);
        }
        
        
    }
    
    //Obtener representantesLegales de Sociedades Participantes (1 por sociedad)
    public void getRepresentantesLegales(){
        
        system.debug('OBTENER REPRESENTANTES LEGALES');
        
        listRepresentatesLegales = [SELECT id, name, Tipo_de_documento__c, N_Documento__c, Lugar_de_notaria__c,
                                    Nombre_notario__c, Fecha_de_Escritura__c, Numero_de_protocolo__c, Condicion__c,
                                    Account.name, Account.Lugar_de_notaria__pc, Account.Nombre_del_notario__c, Account.Numero_de_protocolo__c,
                                    Account.N_documento__c, Account.Fecha_de_Escritura__c
                                    
                                    FROM Contact WHERE AccountId =: setParticipantes And Representante_legal__c = true];
        
        mapRepresentantesLegales = new Map <id, Contact>();
        
        mapRepresentantesFechas = new Map <id, String>();
        
        
        for(integer i = 0; i < listRepresentatesLegales.size(); i++){
            
            mapRepresentantesLegales.put(listRepresentatesLegales[i].AccountId, listRepresentatesLegales[i]);
            if(mapRepresentantesLegales.get(listRepresentatesLegales[i].AccountId).Fecha_de_Escritura__c != null){
                            mapRepresentantesFechas.put(listRepresentatesLegales[i].AccountId, 
                                        getFechaString(mapRepresentantesLegales.get(listRepresentatesLegales[i].AccountId).Fecha_de_Escritura__c));
            }

        }
        system.debug('listRepresentatesLegales '+listRepresentatesLegales);
        system.debug('mapRepresentantesLegales '+mapRepresentantesLegales);
        system.debug('mapRepresentantesFechas '+mapRepresentantesFechas);
        
    }
    
    //Comprobar ----------------------------------------------------
    public void getLocalidadTitulares(){
        
        maplocalidadTitulares = new Map <id, Municipio__C> ([SELECT id, name
                            FROM Municipio__c WHERE Id =: setLocalidades]);
        
    }
    //Comprobar ----------------------------------------------------
    
    public void getTipoInmueble(){
        
        TipoInmueble = [SELECT id, name, tipo__c FROM Tipo_de_inmueble__c WHERE id =: inmueble.Tipo_de_inmueble__c];
        
        System.debug('GET RESERVA CON IVA '+oportunidad.reserva__c+ ' iva '+oportunidad.Porcentaje_IVA__c);
         System.debug('Tipo de reserva '+oportunidad.Tipo_de_Reserva__c+ ' amount '+oportunidad.amount);
        
    }
    
     public void getRecordTypeIdCustomSetting(){
        
         AccountRecordType  = AccountRecordType__c.getOrgDefaults();
		 system.debug('AccountRecordType'+AccountRecordType);
    }
    
    public void getApoderado(){
        
        Apoderado = [SELECT id, Sexo__c, name, Account.name, tipo_de_documento__c, N_documento__c, Nombre_notario__c, Lugar_de_notaria__c, Fecha_de_Escritura__c, 
                            Numero_de_protocolo__c, Tipo_via__c, Nombre_via__c, N_piso__c, Localidad__r.Name, Dc_Provincia__c, escalera__c, Puerta__c, Numero_via__c
                      FROM  Contact Where id =: promocion.Contact__c LIMIT 1];
    }
    
    public void getPrecioGarajes(){
        
        precioGarajes = 0;
        system.debug('listGarajes:::'+listGarajes);
        if(listGarajes != null && listGarajes.size() > 0){
            
        
            for(integer i = 0; i < listGarajes.size(); i++){
                
                if(listGarajes[i].precio__c != null){
                    
                     precioGarajes += listGarajes[i].precio__c;
                }   
            }
        }
        system.debug('precioGarajes:::'+precioGarajes);
    } 
    
    public void getPrecioTrasteros(){
        
        precioTrasteros = 0;
        system.debug('listTrasteros:::'+listTrasteros);
        if(listTrasteros != null && listTrasteros.size() > 0){
            
        
            for(integer i = 0; i < listTrasteros.size(); i++){
                
                if(listTrasteros[i].precio__c != null){
                    
                     precioTrasteros += listTrasteros[i].precio__c;
                }   
            }
        }
        system.debug('precioTrasteros:::'+precioTrasteros);
    } 
    
    public void getFechaPrimeraCuotaList(){
       	Decimal numCuotas = oportunidad.N_Cuotas__c;
        Date fechaPrimeraCuota = oportunidad.Fecha_de_primera_cuota__c;
        if(fechaPrimeraCuota != null){
            Date fechaPrimeraCuota10 = date.newInstance(fechaPrimeraCuota.year(), fechaPrimeraCuota.month(), 10);
            
            fechaPrimeraCuotaList = new List<String>();
            for (Integer i = 0; i < numCuotas; i++) {
                String fechaString= String.valueOf(fechaPrimeraCuota10.day()) + '/' + String.valueOf(fechaPrimeraCuota10.month()) + '/' + String.valueOf(fechaPrimeraCuota10.year());
                    
                    
                fechaPrimeraCuotaList.add(fechaString);
                fechaPrimeraCuota10 = fechaPrimeraCuota10.addMonths(1);
            }
            system.debug('fechaPrimeraCuotaList:::'+fechaPrimeraCuotaList);
            }

    }
    
   public void getCuotasExtraList(){
       Decimal numCuotasExtra = oportunidad.Numero_Cuotas_Extra__c;
       cuotasExtraList = new List<Decimal>();
       
       if(numCuotasExtra != null){
           for(Integer i = 0; i < numCuotasExtra; i++){
               cuotasExtraList.add(oportunidad.Importe_Cuota_Extra__c);
           }
       }

	   system.debug('cuotasExtraList:::'+cuotasExtraList);
    }

    
    
    //Metodos que devuelven un valor
    public static decimal getReservaConIva(){
        
        
        Decimal reservaConIva; 
        if(oportunidad.reserva__c != null && oportunidad.Porcentaje_IVA__c != null){
        	reservaConIva = oportunidad.reserva__c + ((oportunidad.Porcentaje_IVA__c*0.01) * oportunidad.reserva__c); 
        }
        else{
            reservaConIva = null;
        }

        return reservaConIva;
    }
    
    public static decimal getImporteAlContado(){
        Decimal ImporteAlContado;
        if(oportunidad.amount != null && oportunidad.Pago_Contrato__c != null){
                   ImporteAlContado = oportunidad.amount * (oportunidad.Pago_Contrato__c*0.01); 
        }
        return ImporteAlContado;
    }
    
    public static decimal getImporteAlContadoConReserva(){
        Decimal ImporteAlContadoConReserva;
        if(oportunidad.amount != null && oportunidad.Pago_Contrato__c != null && oportunidad.Reserva__c != null){
            ImporteAlContadoConReserva = (oportunidad.amount * (oportunidad.Pago_Contrato__c*0.01)) - oportunidad.Reserva__c;
        }
        return ImporteAlContadoConReserva;
    }
    
    public static decimal getImporteAPlazos(){
        Decimal ImporteAPlazos;
        /*
        if(oportunidad.amount != null && oportunidad.Pago_Contrato__c != null){
            ImporteAPlazos = oportunidad.amount * (oportunidad.Pago_Contrato__c*0.01);
        }
        */
        //Cuota por número de cuotas
        ImporteAPlazos = oportunidad.Importe_plan_de_pagos_real__c;
        System.debug('ImporteAPlazos :'+ImporteAPlazos);
        return ImporteAPlazos;
    }
    
    public static decimal getImporteAPlazosConIva(){
        
        Decimal ImporteAPlazosConIva;
        if(getImporteAPlazos() != null && oportunidad.Porcentaje_IVA__c != null){
            ImporteAPlazosConIva = getImporteAPlazos() + ((oportunidad.Porcentaje_IVA__c*0.01) * getImporteAPlazos());
        }
        
        System.debug('Porcentaje :'+oportunidad.Porcentaje_IVA__c);
        System.debug('ImporteAPlazosConIVA :'+ImporteAPlazosConIva);
        return ImporteAPlazosConIva;
    }
    
    public static decimal getImporteEscrituracion(){
        Decimal ImporteEscrituracion;
        if(oportunidad.pago_Escritura__c != null && oportunidad.Amount != null){
            //ImporteEscrituracion = oportunidad.pago_Escritura__c * 0.01 * oportunidad.Amount;
            ImporteEscrituracion = oportunidad.Importe_escritura__c;
        }
        
        return ImporteEscrituracion;
    }
    
    public static Decimal getImporteIvaOportunidad(){
        Decimal ImporteIvaOportunidad;
        if(oportunidad.Amount != null && oportunidad.Porcentaje_IVA__c != null){
        	ImporteIvaOportunidad = (oportunidad.Porcentaje_IVA__c * 0.01) * oportunidad.Amount;    
        }
        return ImporteIvaOportunidad;
        
    }
    
    public static Decimal getImporteOportunidadMenosReserva(){
        Decimal ImporteOportunidadMenosReserva;
        if(oportunidad.Amount != null && oportunidad.reserva__c != null){
                ImporteOportunidadMenosReserva = oportunidad.Amount - oportunidad.reserva__c;    
        }

        
        return ImporteOportunidadMenosReserva;
        
    }
    
    public static Decimal getImporteOportunidadMenosPenalizacion(){
        
        Decimal ImporteOportunidadMenosPenalizacionContrato;
        if(oportunidad.Amount != null && oportunidad.Penalizacion_Contrato__c != null){
            ImporteOportunidadMenosPenalizacionContrato = oportunidad.Amount - oportunidad.Penalizacion_Contrato__c;
        }
        return ImporteOportunidadMenosPenalizacionContrato;
        
    }
    
    public static Decimal getImporteIvaCuotaMensual(){
        Decimal ImporteIvaCuotaMensual;
        if(oportunidad.Porcentaje_IVA__c != null && oportunidad.Importe_de_Cuota__c != null){
            ImporteIvaCuotaMensual = (oportunidad.Porcentaje_IVA__c * 0.01) - oportunidad.Importe_de_Cuota__c;
        }
        
        return ImporteIvaCuotaMensual;
        
    }

    public static Decimal getImporteCuotasExtra(){
       
       Decimal ImporteCuotasExtra;
        if(oportunidad.Numero_Cuotas_Extra__c != null && oportunidad.Importe_Cuota_Extra__c != null){
              ImporteCuotasExtra = oportunidad.Numero_Cuotas_Extra__c * oportunidad.Importe_Cuota_Extra__c;
        }

        return ImporteCuotasExtra;
           
    }
    
    public static Decimal getImporteCuotasExtraconIva(){
        Decimal ImporteCuotasExtraconIva;
        if(getImporteCuotasExtra() != null && oportunidad.Porcentaje_IVA__c != null){
            ImporteCuotasExtraconIva = getImporteCuotasExtra() * (oportunidad.Porcentaje_IVA__c * 0.01) + getImporteCuotasExtra();
        }

        return ImporteCuotasExtraconIva;
    }
    
    public static Decimal getImporteOportunidadConIva(){
        Decimal oportunidadTotal;
        if(oportunidad.amount != null && oportunidad.Porcentaje_IVA__c != null){
            system.debug('GETIMPORTEOPORTUNIDADIVA '+oportunidad.amount + ' + '+oportunidad.Porcentaje_IVA__c);
            oportunidadTotal = getImporteIva(oportunidad.amount, oportunidad.Porcentaje_IVA__c);    
        }
        if(oportunidadTotal != null && oportunidad.amount != null){
            return oportunidadTotal + oportunidad.amount;
        }else{
            return null; 
        }

    }
    
    public static Integer getAnnoInicioEscrituracion(){
        Integer anno;
        if(promocion.Inicio_de_escrituraciones__c != null){
        	anno = promocion.Inicio_de_escrituraciones__c.year();
        }
        return anno;
    }
    
    
    //Metodos internos de la clase    
    private static Decimal getImporteIva(Decimal precio, Decimal porcentajeIva){
        Decimal importeIva;
        if(precio != null && porcentajeIva != null){
        	importeIva = precio*porcentajeIva*0.01;            
        }

        return importeIva;
    }
    
    private String getFechaString(Date fecha){
        
        String fechaNew =  string.valueOf(fecha.day()) +' de '+
            						getMesEscrito(fecha.month()) +' de '+
        							String.valueOf(fecha.year());
        return fechaNew;
    }
       
    private String getMesEscrito(Integer mes){
        
		String mesEscrito;
        
         if(mes == 1){
                mesEscrito = 'enero';
         }
        else if(mes == 2){
            mesEscrito = 'febrero';
        }
        else if(mes == 3){
            mesEscrito = 'marzo';
        }
        else if(mes == 4){
            mesEscrito = 'abril';
        }
        else if(mes == 5){
            mesEscrito = 'mayo';
        }
        else if(mes == 6){
            mesEscrito = 'junio';
        }
        else if(mes == 7){
            mesEscrito = 'julio';
        }
        else if(mes == 8){
            mesEscrito = 'agosto';
        }
        else if(mes == 9){
            mesEscrito = 'septiembre';
        }
        else if(mes == 10){
            mesEscrito = 'octubre';
        }
        else if(mes == 11){
            mesEscrito = 'noviembre';
        }
        else if(mes == 12){
            mesEscrito = 'diciembre';
        }
        
		return mesEscrito;
    }
    
    
}