public class Ficha_Escrituracion_Controller {
    public Opportunity oportunidad {get; set;}
	public Promocion__c promocion {get; set;}
    public List<Account> Titulares {get; set;}
    public Map <id, Municipio__c> maplocalidadTitulares {get; set;}
    public List<OpportunityLineItem> opportunityLineItemList {get; set;}
    public Map <Id, Decimal> hipotecaMap {get; set;}
    public List<Factura__c> facturaList {get; set;}
    public Double precioVentaIVA {get; set;}
    public Decimal precioVentaTotal {get; set;}
    public Decimal hipotecaIVA {get; set;}
    public Decimal reservaIVA {get; set;}
    public Decimal reservaTotal {get; set;}
    public Boolean precioConjunto {get; set;}
    public Decimal vencPendientes {get; set;}
    public List<Factura__c> facturasCobradas {get; set;}
    public Account cliente {get; set;}
    public AccountRecordType__c AccountRecordType {get;set;}
    
    //Variable globales internas
    Private Set<id> setParticipantes = new Set<id>();
    Private Set<id> setLocalidades = new Set<id>();

    //mapas
    public Map <id, Contact> mapRepresentantesLegales {get; set;}
    
     public List<Contact> listRepresentatesLegales {get; set;}
    
    //Variables importe formateadas
    public String StrOpporPagoEscritura {get;set;}
    public Map <Id, String> MapHipoteca {get;set;}
    public Map <Id, String> MapOpporUnitPrice {get;set;}
    public Map <Id, String> MapOpporProdSupUtil {get;set;}
    public Map <Id, String> MapOpporProdSupCon {get;set;}
    public Map <Id, String> MapOpporProdSupConTotal {get;set;}
    public String StrOpporAmount {get;set;}
    public String StrPrecioVentaIVA{get;set;}
    public String StrPrecioVentaTotal{get;set;}
    public String StrOpporAcumImpPag{get;set;}
    public String StrOpporAcumImpPagIVA{get;set;}
    public String StrOpporAcumImpPagTotal{get;set;}
    public String StrVencPendientes{get;set;}
    public String StrVencPendientesIVA{get;set;}
    public String StrVencPendientesTotal{get;set;}
    public String StrHipotecaIVA{get;set;}
    public String StrLiqIVA{get;set;}
    public Map <Id, String> MapFactura {get;set;}
    
    
//Constructor
    public Ficha_Escrituracion_Controller(){ 
       
        //Recuperar promocion
        Id idOportunidad = ApexPages.currentPage().getParameters().get('id');
        //Id idOportunidad = '006n0000007YII6AAO';
        system.debug('Id oportunidad:::'+idOportunidad);
            
        oportunidad = [SELECT Id, promocion__c, Amount, Porcentaje_IVA__c, Pago_Escritura__c, Reserva__c, Acumulado_de_Importe_Pagado__c, Fecha_de_Escrituracion__c, AccountId 
                       FROM Opportunity 
                       WHERE Id =: idOportunidad];
        system.debug('oportunidad:::'+idOportunidad);
        
        if(oportunidad.Porcentaje_IVA__c != null && oportunidad.Amount != null){
            precioVentaIVA = calcularPrecioIVA(oportunidad.Porcentaje_IVA__c, oportunidad.Amount);
        }
        if(oportunidad.Amount != null && precioVentaIVA != null){
            precioVentaTotal = oportunidad.Amount + precioVentaIVA;
        }
        if(precioVentaIVA != null && oportunidad.Pago_Escritura__c != null){
            hipotecaIVA = precioVentaIVA*oportunidad.Pago_Escritura__c/100;
        }
        if(oportunidad.Porcentaje_IVA__c != null && oportunidad.Reserva__c != null){
            reservaIVA = calcularPrecioIVA(oportunidad.Porcentaje_IVA__c, oportunidad.Reserva__c);
        }
        if(oportunidad.Reserva__c != null && reservaIVA != null){
         	reservaTotal = oportunidad.Reserva__c + reservaIVA;           
        }


        promocion = [SELECT Id, Name, Fecha_de_escritura__c FROM Promocion__c WHERE Id =: Oportunidad.promocion__c];
        system.debug('promocion:::'+promocion);
        
       //Recuperar productos de oportunidad         
        opportunityLineItemList = [SELECT Id, UnitPrice, Opportunity.Pago_Escritura__c, OpportunityId, Product2.Superficie_Construida_m2__c, Product2.Superficie_Util_m2__c, 
                                   Product2.Superficie_Construida_total_con_ZZCC_m2__c, Product2.Tipo_de_inmueble__r.Tipo__c, Product2.Tipo_de_via__c, Product2.nombre_via__c,
                                   Product2.portal__c, Product2.piso__c, Product2.planta__c, Product2.Letra_N_Puerta__c , Product2.N_Vivienda_Garaje_Trastero_Local__c 
                                   FROM OpportunityLineItem 
                                   WHERE OpportunityId =: oportunidad.Id
                                   ORDER BY Product2.Tipo_de_inmueble__r.Tipo__c DESC];
        system.debug('opportunityLineItemList:::'+opportunityLineItemList);

        
        hipotecaMap = new Map <Id, Decimal>();
        precioConjunto = False;
        for(OpportunityLineItem opportunityLineItem : opportunityLineItemList){
            if(opportunityLineItem.UnitPrice == null || opportunityLineItem.UnitPrice == 0){
					precioConjunto = True;
                	system.debug('precioConjunto:::' + precioConjunto);
            }
            Decimal hipoteca = opportunityLineItem.UnitPrice*opportunityLineItem.Opportunity.Pago_Escritura__c/100;
            system.debug('hipoteca:::' + hipoteca);
            hipotecaMap.put(opportunityLineItem.Id, hipoteca);
        }
        
        //Factura
        facturaList = [SELECT Descripcion__c, Metodo_de_cobro__c, Importe__c, Fecha_de_emision__c, Oportunidad__c, Numero_de_factura__c, Pago_o_Cuota__c,Estado_de_la_factura__c,
                       			Tipo_de_factura__c
                       FROM Factura__c
                       WHERE Oportunidad__c =: oportunidad.Id ORDER BY Fecha_de_emision__c];
        
        vencPendientes = 0;
        for(Factura__c factura : facturaList){
            if((factura.Pago_o_Cuota__c == 'Cuota' || factura.Pago_o_Cuota__c == 'Cuota Extra') && factura.Estado_de_la_factura__c == 'Pendiente de emisión'){
                vencPendientes += factura.Importe__c;
            }
        }
        
        facturasCobradas = new List<Factura__c>();
        for(Factura__c factura : facturaList){
            if(factura.Estado_de_la_factura__c == 'Cobrada' && (factura.Tipo_de_factura__c == 'RESERVAS' || factura.Tipo_de_factura__c == 'FACTURA DE VENTA' || factura.Tipo_de_factura__c == 'ENTREGAS A CUENTA')){
                facturasCobradas.add(factura);
            }
            
        }
        
        getTitulares();
        getLocalidadTitulares();
        getCliente();
        getRecordTypeIdCustomSetting();
        
        
        
        
        List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
          	//Formateamos campos de importe
        if(oportunidad.Amount != null && oportunidad.Pago_Escritura__c != null){
        	Decimal OpporPagoEscritura = oportunidad.Amount*oportunidad.Pago_Escritura__c/100;
        	OpporPagoEscritura = OpporPagoEscritura.setScale(2);
        	StrOpporPagoEscritura = String.format(OpporPagoEscritura.format(), formateo);
        }
        if(oportunidad.Amount != null){
        	StrOpporAmount = String.format(oportunidad.Amount.format(), formateo);
        }
        if(precioVentaIVA != null){
            StrPrecioVentaIVA = String.format(precioVentaIVA.format(), formateo);
        }
        if(precioVentaTotal != null){
        	StrPrecioVentaTotal = String.format(precioVentaTotal.format(), formateo);
        }
        if(oportunidad.Acumulado_de_Importe_Pagado__c != null){
            StrOpporAcumImpPag = String.format(oportunidad.Acumulado_de_Importe_Pagado__c.format(), formateo);
        }
        if(oportunidad.Acumulado_de_Importe_Pagado__c != null && oportunidad.Porcentaje_IVA__c != null){
        	Decimal OpporAcumImpPagIVA = oportunidad.Acumulado_de_Importe_Pagado__c * oportunidad.Porcentaje_IVA__c /100;
        	OpporAcumImpPagIVA = OpporAcumImpPagIVA.setScale(2);
        	StrOpporAcumImpPagIVA = String.format(OpporAcumImpPagIVA.format(), formateo);
        	Decimal OpporAcumImpPagTotal = oportunidad.Acumulado_de_Importe_Pagado__c * ( 1 + oportunidad.Porcentaje_IVA__c / 100);
        	OpporAcumImpPagTotal = OpporAcumImpPagTotal.setScale(2);
        	StrOpporAcumImpPagTotal = String.format(OpporAcumImpPagTotal.format(), formateo);
        }
        if(vencPendientes != null){
       		StrVencPendientes = String.format(vencPendientes.format(), formateo);
        }
        if(vencPendientes != null && oportunidad.Porcentaje_IVA__c != null){
       		Decimal VencPendientesIVA = vencPendientes * oportunidad.Porcentaje_IVA__c/100;
       		VencPendientesIVA = VencPendientesIVA.setScale(2);
        	StrVencPendientesIVA = String.format(VencPendientesIVA.format(), formateo);
        	Decimal VencPendientesTotal = vencPendientes * (1 + oportunidad.Porcentaje_IVA__c/100);
       		VencPendientesTotal = VencPendientesTotal.setScale(2);
        	StrVencPendientesTotal = String.format(VencPendientesTotal.format(), formateo);
        }
        if(oportunidad.Amount != null && oportunidad.Pago_Escritura__c != null && oportunidad.Porcentaje_IVA__c != null){
        	Decimal HipotecaIVA = (oportunidad.Amount*oportunidad.Pago_Escritura__c /100) * oportunidad.Porcentaje_IVA__c / 100;
        	HipotecaIVA = HipotecaIVA.setScale(2);
        	StrHipotecaIVA = String.format(HipotecaIVA.format(), formateo);
        }
        if(vencPendientes != null && oportunidad.Amount != null && oportunidad.Pago_Escritura__c != null && oportunidad.Porcentaje_IVA__c != null){
        	Decimal LiqIVA = (vencPendientes + oportunidad.Amount*oportunidad.Pago_Escritura__c /100) * oportunidad.Porcentaje_IVA__c/100;
        	LiqIVA = LiqIVA.setScale(2);
        	StrLiqIVA = String.format(LiqIVA.format(), formateo);
        }
        
        MapHipoteca = new Map <Id, String>();
        MapOpporUnitPrice = new Map <Id, String>();
        MapOpporProdSupUtil = new Map <Id, String>();
        MapOpporProdSupCon = new Map <Id, String>();
        MapOpporProdSupConTotal = new Map <Id, String>();
                        
        for(OpportunityLineItem opportunityLineItem : opportunityLineItemList){
            String StrHipoteca = '';
            String StrOpporUnitPrice = '';
            String StrOpporProdSupUtil = '';
            String StrOpporProdSupCon = '';
            String StrOpporProdSupConTotal = '';
            if(opportunityLineItem.UnitPrice != null && opportunityLineItem.Opportunity.Pago_Escritura__c != null){
            	Decimal hipoteca = opportunityLineItem.UnitPrice*opportunityLineItem.Opportunity.Pago_Escritura__c/100;
            	hipoteca = hipoteca.setScale(2);
            	StrHipoteca = String.format(hipoteca.format(), formateo);
            }
            if(opportunityLineItem.UnitPrice != null){
            	StrOpporUnitPrice = String.format(opportunityLineItem.UnitPrice.format(), formateo);
            }
            if(opportunityLineItem.Product2.Superficie_Util_m2__c != null){
            	StrOpporProdSupUtil = String.format(opportunityLineItem.Product2.Superficie_Util_m2__c.format(), formateo);
            }
            if(opportunityLineItem.Product2.Superficie_Construida_m2__c != null){
            	StrOpporProdSupCon = String.format(opportunityLineItem.Product2.Superficie_Construida_m2__c.format(), formateo);
            }
            if(opportunityLineItem.Product2.Superficie_Construida_total_con_ZZCC_m2__c != null){
            	StrOpporProdSupConTotal = String.format(opportunityLineItem.Product2.Superficie_Construida_total_con_ZZCC_m2__c.format(), formateo);
            }
    
            MapHipoteca.put(opportunityLineItem.Id, StrHipoteca);
            MapOpporUnitPrice.put(opportunityLineItem.Id, StrOpporUnitPrice);
            MapOpporProdSupUtil.put(opportunityLineItem.Id, StrOpporProdSupUtil);
            MapOpporProdSupCon.put(opportunityLineItem.Id, StrOpporProdSupCon);
            MapOpporProdSupConTotal.put(opportunityLineItem.Id, StrOpporProdSupConTotal);    
        }
        
        MapFactura = new Map <Id, String>();
        
        for(factura__c facturas : facturasCobradas){
            String StrFacturaImp = '';
            if(facturas.Importe__c != null){
        		StrFacturaImp = String.format(facturas.Importe__c.format(),formateo);
            }
            MapFactura.put(facturas.Id, StrFacturaImp);
        }
        
    }


	//Recuperar titulares
    public void getTitulares(){
            
            List<Participante__c> listParticipantes = [SELECT id, Cliente__c 
                                          FROM Participante__c WHERE Opportunity__c =: oportunidad.id];
            
        	system.debug('Ficha_Escrituracion_Controller - getTitulares() - listParticipantes:::'+listParticipantes);    
        	for(Integer i = 0; i < listParticipantes.size(); i++){
                
                setParticipantes.add(listParticipantes[i].cliente__c);
            }
            
            Titulares = [SELECT id, name, Estado_Civil__pc, DF_Localidad__c, DP_Tipo_de_vIa__c, 
                                DP_Nombre_via__c, DP_N_via__c, DP_N_piso__c, DP_Puerta__c, DP_Codigo_postal__c,Tipo_de_documento__c, DP_Localidad__c,
                                N_Documento__c, Profesion__pc, Phone, PersonBirthdate, DP_Localidad__r.Name, Tipo_de_via_FISCAL__c, Nombre_de_via_FISCAL__c, N_via_FISCAL__c,
                         		N_piso_FISCAL__c, Puerta_FISCAL__c, Localidad_FISCAL__r.Name
                                FROM Account 
                         		WHERE id IN: setParticipantes];
        	system.debug('Ficha_Escrituracion_Controller - getTitulares() - Titulares:::'+Titulares);
            
            for(integer j = 0; j < Titulares.size(); j++){
                
                setLocalidades.add(Titulares[j].DP_Localidad__c);
            }
            
        }       
    
    
    public void getLocalidadTitulares(){
        
        maplocalidadTitulares = new Map <id, Municipio__C> ([SELECT id, name
                            FROM Municipio__c WHERE Id =: setLocalidades]);
        
    }        
        
        

     //Calcular IVA
     public Decimal calcularPrecioIVA(Decimal porcentaje, Decimal precio){
         Decimal precioIVA;
         if(porcentaje != null && precio != null){
         	precioIVA = precio * porcentaje/100;             
         }
     return precioIVA;       
     }
    
    public void getCliente(){
        
//DP o DF???
//SI CLIENTE NO ES CUENTA PERSONAL??
        cliente = [SELECT id, name, 
                   Estado_Civil__pc, DP_Localidad__c, DP_Tipo_de_vIa__c, DP_Nombre_via__c, DP_N_via__c, DP_Codigo_postal__c,Tipo_de_documento__c, N_Documento__c,
                   Nacionalidad__r.Name, DP_Localidad__r.Name, tomo__c, Seccion__c, Folio__c, N_Hoja__c, Lugar_de_notaria__pc, RecordTypeId, RecordType.DeveloperName
                   FROM Account 
                   WHERE Id =: oportunidad.AccountId];
        
    }
    
     public void getRecordTypeIdCustomSetting(){
        
         AccountRecordType  = AccountRecordType__c.getOrgDefaults();
		 system.debug('AccountRecordType'+AccountRecordType);
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
        
        
        
        for(integer i = 0; i < listRepresentatesLegales.size(); i++){
            
            mapRepresentantesLegales.put(listRepresentatesLegales[i].AccountId, listRepresentatesLegales[i]);

        }
        
        system.debug('mapRepresentantesLegales '+mapRepresentantesLegales);
        
    }
    
	
}