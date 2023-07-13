public class Documento_reserva_controller {
    
    public Opportunity              oportunidad {get; set;}
    public Promocion__c             promocion {get; set;}
    public Account                  promotora {get; set;}
    public List<Account>            Titulares {get; set;}
    public Account                  cliente {get; set;}
    public AccountRecordType__c     AccountRecordType {get;set;}
    public Product2                 inmueble {get; set;}
    public String                   garajes {get; set;}
    public String                   trasteros {get; set;}
    public Contact                  representanteLegal {get; set;}    
    
    //public List<Contact> listRepresentatesLegales {get; set;}
    public Map <id, Contact>        mapRepresentantesLegales{get; set;}
    public Map <id, String>         mapRepresentantesLegalesFecha{get; set;}    
    
    //Fechas
    public String                   fechaEscrituraPromocion {get; set;}
    public String                   fechaCreacion {get; set;}
    public String                   fechaEscrituraPromotora {get; set;}
    
    //Listas
    public static List<Product2>    listGarajes {get; set;}
    public static List<Product2>    listTrasteros {get; set;}    

	 //Variable globales internas
    Private Set<id>                 setParticipantes = new Set<id>();
    
    //Variables importe formateadas
    public String                   StrOpporReserv {get;set;}
    public String                   StrOpporAmount {get;set;}
    public Decimal                  precioGarajes {get; set;}
    public Map<Id, List<String>>    MapGarajes {get;set;}
    public String                   StrGarajePrecio {get;set;}
    public Decimal                  precioTrasteros {get; set;}
    public Map<Id, List<String>>    MapTrasteros {get;set;}
    public String                   StrTrasteroPrecio {get;set;}
    public String                   StrInmueblePrecio {get;set;}
    public String                   StrOpporReservIVA {get;set;}
    public String                   StrOpporPagoContratoContado {get;set;}
    public String                   StrOpporPagoContratoContadoIVA {get;set;}
    public String                   StrOpporImportePagosReal {get;set;}
    public String                   StrOpporImporteCoutaExtra {get;set;}
    public String                   StrRestoEscrituraPublica {get;set;}
    public String                   StrOpporPenalReserv {get;set;}
    public String                   StrOpporPagoContrato {get;set;}
    
    public Documento_reserva_controller(){        
        
        Id idOportunidad = ApexPages.currentPage().getParameters().get('id');
        system.debug('Id Oportunidad '+idOportunidad);
		
         Oportunidad = [SELECT  id, 
                                Periodo_de_Reserva__c, 
                                promocion__c, 
                                AccountId, 
                                Reserva__c, 
                                name, 
                                Amount, 
                                Penalizacion_Reserva__c,
                                Pago_Contrato__c, 
                                N_Cuotas__c, 
                                Pago_Escritura__c, 
                                Porcentaje_IVA__c, 
                                Pago_Contrato_al_contado__c, 
                                Numero_Cuotas_Extra__c, 
                                Importe_Cuota_Extra__c,
                                Importe_plan_de_pagos_real__c 
                        FROM Opportunity 
                        WHERE id =: idOportunidad LIMIT 1];       
        
                                                    system.debug('Oportunidad Controller '+Oportunidad);
        getPromocion();                             system.debug('Promocion '+Promocion);
        getPromotora();                             system.debug('Promotora '+Promotora);
        getTitulares();                             system.debug('Lista de titulares '+titulares);
        getCliente();                               system.debug('Cliente '+Cliente);
        getRepresentanteLegal();                    system.debug('Representante legal '+representanteLegal);
        getRecordTypeIdCustomSetting();
        getInmuebles();                             system.debug('Inmuebles '+Inmueble);
        getFechaFinReserva();                       system.debug('FechaFinReserva '+getFechaFinReserva());
        getRepresentantesLegalesParticipantes();
        getPrecioGarajes();
        getPreciotrasteros();        
        
        //obtener fechas con mes escrito        
        fechaCreacion = getFechaEscrita(date.today());

        if(promocion.fecha_de_escritura__c != null){
             fechaEscrituraPromocion = getFechaEscrita(promocion.fecha_de_escritura__c);
        }
        if(promotora.fecha_de_escritura__c != null){
             fechaEscrituraPromotora = getFechaEscrita(promotora.fecha_de_escritura__c);
        }
        
        List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
          	//Formateamos campos de importe
            if(Oportunidad.Reserva__c != null){
           		StrOpporReserv = String.format(Oportunidad.Reserva__c.format(), formateo);
            }
        	if(Oportunidad.Amount != null){
        		StrOpporAmount = String.format(Oportunidad.Amount.format(), formateo);
        	}
        	if(Oportunidad.Reserva__c != null && Oportunidad.Porcentaje_IVA__c != null){
        		Decimal reservaConIva = Oportunidad.Reserva__c + ((Oportunidad.Porcentaje_IVA__c*0.01) * Oportunidad.reserva__c);
        		reservaConIVA = reservaConIva.setScale(2);
        		StrOpporReservIVA = String.format(reservaConIva.format(), formateo);
        	}
        	if(Oportunidad.Pago_Contrato_al_contado__c != null){
        		StrOpporPagoContratoContado = String.format(Oportunidad.Pago_Contrato_al_contado__c.format(), formateo);
        	}
        	if(Oportunidad.Amount != null && Oportunidad.Pago_Contrato_al_contado__c != null){
        		Decimal OpporPagoContratoContadoIVA = Oportunidad.Amount * Oportunidad.Pago_Contrato_al_contado__c/100;
        		OpporPagoContratoContadoIVA = OpporPagoContratoContadoIVA.setScale(2);
        		StrOpporPagoContratoContadoIVA = String.format(OpporPagoContratoContadoIVA.format(), formateo);
        	}
        	if(oportunidad.Importe_plan_de_pagos_real__c != null){
        		Decimal OpporImportePagosReal = oportunidad.Importe_plan_de_pagos_real__c;
        		OpporImportePagosReal = OpporImportePagosReal.setScale(2);
        		StrOpporImportePagosReal = String.format(OpporImportePagosReal.format(), formateo);
        	}
	        if(oportunidad.Importe_Cuota_Extra__c != null){
        		StrOpporImporteCoutaExtra = String.format(oportunidad.Importe_Cuota_Extra__c.format(), formateo);
            }
        	if(oportunidad.Pago_Escritura__c != null && oportunidad.Amount != null){
        		Decimal restoEscrituraPublica = oportunidad.Pago_Escritura__c/100 * oportunidad.Amount;
        		restoEscrituraPublica = restoEscrituraPublica.setScale(2);
        		StrRestoEscrituraPublica = String.format(RestoEscrituraPublica.format(), formateo);
        	}
        	if(oportunidad.Amount != null){
        		StrOpporPenalReserv = String.format(oportunidad.Amount.format(), formateo);
        	}
        	if (oportunidad.Pago_Contrato__c != null){
        		StrOpporPagoContrato = String.format(oportunidad.Pago_Contrato__c.format(), formateo);
        	}
    }
    
    public String getFechaEscrita(Date fecha){        
        String fechaNew =  string.valueOf(fecha.day()) + ' de ' + getMesEscrito(fecha.month()) + ' de ' + String.valueOf(fecha.year());
        return fechaNew;
    }    
    
    public String getMesEscrito(Integer mes){
        
        String mesEscrito;        

        if(mes == 1){mesEscrito = 'enero';}
        else if(mes == 2){mesEscrito = 'febrero';}
        else if(mes == 3){mesEscrito = 'marzo';}
        else if(mes == 4){mesEscrito = 'abril';}
        else if(mes == 5){mesEscrito = 'mayo';}
        else if(mes == 6){mesEscrito = 'junio';}
        else if(mes == 7){mesEscrito = 'julio';}
        else if(mes == 8){mesEscrito = 'agosto';}
        else if(mes == 9){mesEscrito = 'septiembre';}
        else if(mes == 10){mesEscrito = 'octubre';}
        else if(mes == 11){mesEscrito = 'noviembre';}
        else if(mes == 12){mesEscrito = 'diciembre';}
        
        return mesEscrito;
    }
    
    public void getPromocion(){
        
        promocion = [SELECT  id,
                             Periodo_de_Reserva__c,
                             Socio_Empresa_Promotora__c, 
                             name, 
                             Tipo_via__c, 
                             Nombre_via__c, 
                             N_Via__c, 
                             Provincia__c,
                             N_Viviendas_totales_promocion__c, 
                             Informacion_de_arquitectos_de_obra__c, 
                             Lugar_de_la_notaria__c,
                             Cuenta_Activa_1__c, 
                             Cuenta_Activa_2__c, 
                             Numero_de_cuenta_bancaria_1__c, 
                             Numero_de_cuenta_bancaria_2__c,
                             Titularidad_de_la_cuenta1__c, 
                             Titularidad_de_la_cuenta2__c, 
                             Entidad_Bancaria1__c, 
                             Entidad_Bancaria2__c, 
                             Condicion__c,
                             fecha_de_escritura__c, 
                             contact__c, 
                             Contact__r.Name, 
                             Contact__r.Tipo_de_documento__c, 
                             Contact__r.N_Documento__c, 
                             Contact__r.Tipo_via__c,
                             Contact__r.Nombre_via__c,
                             Contact__r.Numero_via__c,
                             Contact__r.Localidad__r.Name,
                    	 	 Contact__r.Pais__r.Name,
                             Lugar_del_registro__c,
                             Nombre_notario__c, 
                             Numero_de_protocolo__c
                    FROM Promocion__c 
                    WHERE Id =: Oportunidad.promocion__c];
    }
    
    public void getPromotora(){

        promotora = [SELECT id, 
                            name,
                            Tipo_de_documento__c, 
                            N_Documento__c, 
                            Dp_Comunidad_autonoma__c, 
                            DP_Provincia__c, 
                            DP_Localidad__c, 
                            DP_Tipo_de_via__c, 
                            DP_N_piso__c, 
                            DP_Codigo_postal__c, 
                            DP_nombre_via__c, 
                            DF_Localidad__c, 
                            DF_Nombre_via__c, 
                            DF_Localidad__r.name, 
                            DP_Localidad__r.name,
                            tomo__c, 
                            Seccion__c, 
                            Folio__c, 
                            N_Hoja__c, 
                            Lugar_del_registro__c, 
                            Nombre_del_notario__c, 
                            Numero_de_protocolo__c,
                            Fecha_de_Escritura__c, 
                            DP_N_via__c 
                    FROM Account 
                    WHERE Id =: promocion.Socio_Empresa_Promotora__c];  
    }
    
    public void getTitulares(){
        
        List<Participante__c> listParticipantes = [SELECT   id, 
                                                            Cliente__c
                                                    FROM Participante__c 
                                                    WHERE Opportunity__c =: oportunidad.id];
        
        for(Integer i = 0; i < listParticipantes.size(); i++){            
            setParticipantes.add(listParticipantes[i].cliente__c);
        }
        
        Titulares = [SELECT id, 
                            name,
                            PersonEmail,
                            Estado_Civil__pc, 
                            DF_Localidad__c, 
                            DP_Localidad__r.Name, 
                            DP_Tipo_de_vIa__c, 
                            DP_Nombre_via__c, 
                            DP_N_via__c, 
                            DP_Codigo_postal__c,
                            Pais__pr.Name,
                            Nacionalidad__pr.Name,
                            Tipo_de_documento__c, 
                            N_Documento__c, 
                            Lugar_del_registro__c, 
                            Tomo__c, 
                            seccion__c, 
                            folio__c, 
                            N_Hoja__c,
                            Nombre_del_notario__c, 
                            Numero_de_protocolo__c, 
                            Fecha_de_Escritura__c
                    FROM Account 
                    WHERE id IN: setParticipantes];        
    }
    
    public void getCliente(){
        
        cliente = [SELECT   id, 
                            RecordTypeId,
                            RecordType.DeveloperName,
                            DF_Localidad__c, 
                            DF_Localidad__r.name
                    FROM Account 
                    WHERE Id =: oportunidad.AccountId];        
    }
    
    public void getRepresentanteLegal(){        
        
        representanteLegal = [SELECT    name, 
                                        N_Documento__c, 
                                        Tipo_de_documento__c,
                                        Lugar_de_notaria__c, 
                                        Fecha_de_Escritura__c, 
                                        Nombre_notario__c, 
                                        Numero_de_protocolo__c
                              FROM Contact 
                              WHERE id =: promocion.contact__c AND Representante_legal__c = true];
    }
    
    public void getRepresentantesLegalesParticipantes(){
        
        List<Contact> listRepresentatesLegales = [SELECT    id, 
                                                            name, 
                                                            Tipo_de_documento__c, 
                                                            N_Documento__c, 
                                                            Lugar_de_notaria__c,
                                                            Nombre_notario__c, 
                                                            Fecha_de_Escritura__c, 
                                                            Numero_de_protocolo__c, 
                                                            Condicion__c,
                                                            Account.name, 
                                                            Account.Lugar_de_notaria__pc, 
                                                            Account.Nombre_del_notario__c, 
                                                            Account.Numero_de_protocolo__c,
                                                            Account.N_documento__c, 
                                                            Account.Fecha_de_Escritura__c
                                                FROM Contact 
                                                WHERE AccountId =: setParticipantes AND Representante_legal__c = true];
        
        mapRepresentantesLegales = new Map <id, Contact>();
        mapRepresentantesLegalesFecha = new Map <id, String>();
        
        for(integer i = 0; i < listRepresentatesLegales.size(); i++){            
            mapRepresentantesLegales.put(listRepresentatesLegales[i].AccountId, listRepresentatesLegales[i]);
            if(listRepresentatesLegales[i].Fecha_de_Escritura__c != null){
            	mapRepresentantesLegalesFecha.put(listRepresentatesLegales[i].AccountId, getFechaEscrita(listRepresentatesLegales[i].Fecha_de_Escritura__c));
            }
        }        
    }
    
    public void getRecordTypeIdCustomSetting(){        
         AccountRecordType  = AccountRecordType__c.getOrgDefaults();
    }
    
    public void getInmuebles(){

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
        List<Product2> listaInmuebles = [SELECT id,
                                                name,
                                                planta__c,
                                                Letra_N_Puerta__c,
                                                Inmueble_asociado__c,
                                                Tipo_de_inmueble__c,  
                                                N_Vivienda_Garaje_Trastero_Local__c, 
                                                Precio__c, 
                                                N_Via__c, 
                                                Tipo_de_inmueble__r.tipo__c, 
                                                Tipologia_de_vivienda__c
                                         FROM Product2 
                                         WHERE (id IN: setProductoOportunidad AND (     Tipo_de_inmueble__r.tipo__c = 'Vivienda' 
                                                                                    OR  Tipo_de_inmueble__r.tipo__c = 'Garaje'
                                                                                    OR  Tipo_de_inmueble__r.tipo__c = 'Trastero'
                                                                                    OR  Tipo_de_inmueble__r.tipo__c = 'Local'))];

        system.debug('listaInmuebles:::'+listaInmuebles);
        system.debug('listaInmuebles.size():::'+listaInmuebles.size());
        
        List<String> listaTipoInmueble = new List<String>();
        for(Product2 inmueble : listaInmuebles){
            listaTipoInmueble.add(inmueble.Tipo_de_inmueble__r.tipo__c);
        }        

		//Se asignan los inmuebles dependiendo de su tipo de vivienda
        for(integer i = 0; i < listaInmuebles.size() ; i++){
            
            if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Vivienda' || listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Local'){                
                inmueble = listaInmuebles[i];
            }
            else{                
                if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Garaje'){
                    if(listaTipoInmueble.contains('Garaje') && !listaTipoInmueble.contains('Vivienda')){
                        inmueble = listaInmuebles[i];
                    }
                    if(garajes == null){
                        garajes = listaInmuebles[i].name;
                    }
                    else{
                        garajes +=  ', ' +listaInmuebles[i].name;
                    }
                }
                else if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Trastero'){
                    if(listaTipoInmueble.contains('Trastero') && !listaTipoInmueble.contains('Vivienda')){
                        inmueble = listaInmuebles[i];
                    }
                    if(trasteros == null){
                        trasteros = listaInmuebles[i].name;
                    }
                    else{
                        trasteros +=  ', ' +listaInmuebles[i].name;
                    }
                }            
            }
        }
        
        system.debug('garajes:::'+garajes);
        system.debug('trasteros:::'+trasteros);
        
        //Se asignan los inmuebles dependiendo de su tipo de vivienda
        for(integer i = 0; i < listaInmuebles.size() ; i++){
            
            if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Vivienda'){
                inmueble = listaInmuebles[i];
            }else if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Local'){
                inmueble = listaInmuebles[i];
            }
            else{  
                if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Garaje'){
                    
                     listGarajes.add(listaInmuebles[i]);
                     system.debug('GARAJE ');
                     system.debug('listGarajes:::'+listGarajes);
                 }
                else if(listaInmuebles[i].Tipo_de_inmueble__r.Tipo__c == 'Trastero'){
                    
                    listTrasteros.add(listaInmuebles[i]); 
                    system.debug('TRASTERO ');
                    system.debug('listTrasteros:::'+listTrasteros);
                }
            }
        }
        
        List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
        //Formateamos campos de importe
        
		StrInmueblePrecio = String.format(inmueble.Precio__c.format(), formateo);            
        
        List<String> GarajeAux= new List <String>();
        MapGarajes = new Map<Id, List<String>>();
        
        for(integer i = 0; i < listGarajes.size() ; i++){
            GarajeAux = new List <String>();
        	Decimal preciogaraje = listGarajes[i].Precio__c ;
            preciogaraje = preciogaraje.setScale(2);
            
            StrGarajePrecio = String.format(preciogaraje.format(), formateo);
            
           	GarajeAux.add(StrGarajePrecio);
            MapGarajes.put(listGarajes[i].Id, GarajeAux);
        }
        
        List<String> TrasteroAux= new List <String>();
        MapTrasteros = new Map<Id, List<String>>();
        
        for(integer i = 0; i < listTrasteros.size() ; i++){
            TrasteroAux = new List <String>();
        	Decimal preciotrastero = listTrasteros[i].Precio__c ;
            preciotrastero = preciotrastero.setScale(2);
            
            StrTrasteroPrecio = String.format(preciotrastero.format(), formateo);
            
           	TrasteroAux.add(StrTrasteroPrecio);
            MapTrasteros.put(listTrasteros[i].Id, TrasteroAux);
        }
        
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
    
    public String getFechaFinReserva(){
        
        system.debug('oportunidad.Periodo_de_Reserva__c '+oportunidad.Periodo_de_Reserva__c);
        system.debug('oportunidad '+oportunidad);
        
        String fechaFinReservaEscrita;
        if(oportunidad.Periodo_de_Reserva__c != null){
			fechaFinReservaEscrita = 'día '+oportunidad.Periodo_de_Reserva__c.day()+' de '+getMesEscrito(oportunidad.Periodo_de_Reserva__c.month())+' de '+oportunidad.Periodo_de_Reserva__c.year();            
        }
        else{
            oportunidad.Periodo_de_Reserva__c = date.today().addDays(Integer.valueOf(promocion.Periodo_de_Reserva__c));
            fechaFinReservaEscrita = 'día '+oportunidad.Periodo_de_Reserva__c.day()+' de '+getMesEscrito(oportunidad.Periodo_de_Reserva__c.month())+' de '+oportunidad.Periodo_de_Reserva__c.year();            
        }

        return fechaFinReservaEscrita;
    }
    
    public decimal getRestoEscrituraPublica(){
        Decimal restoEscrituraPublica;
        if(oportunidad.Pago_Escritura__c != null && oportunidad.Amount != null){
            restoEscrituraPublica = oportunidad.Pago_Escritura__c/100 * oportunidad.Amount;
        }
        return restoEscrituraPublica;
    }
    
    public decimal getReservaConIva(){

        Decimal reservaConIva;

        if(oportunidad.reserva__c != null && oportunidad.Porcentaje_IVA__c != null){
        	reservaConIva = oportunidad.reserva__c + ((oportunidad.Porcentaje_IVA__c*0.01) * oportunidad.reserva__c); 
        }
        else{
            reservaConIva = null;
        }

        return reservaConIva;
    }
}