/*
 * 		Date 		Author		Description
 * 14/07/2021 		LCS-GMC		Modified.Add method "getEntregaCuenta" line 267, modify line 64.
*/

public class Documento_factura_controller {

	public Map <id, String>				MapaParticipantesOpp{get; set;}
	public List<Account>				listaClientes {get; set;}
	public List<Linea_de_factura__c>	lineasFacturaList {get;set;}

	public Account						cliente {get; set;}
	public Account						sociedad {get; set;}
	public Opportunity					oportunidad {get; set;}
	public Factura__c					factura {get; set;}

	public String						NombreLocalidad {get; set;}
	public String						NombrePais {get; set;}
	public String						fechaCreacion {get; set;}

	public Decimal						importeConIva {get; set;}
	public Decimal						IVA {get;set;}
	public Decimal						importeIVA {get;set;}
    
    public Boolean 						isFacturaEscrituracion {get; set;}
    public String 						TotalImporteEscr {get;set;}
    public String 						TotalCobradoImporteEscr {get;set;}
    
    //Variables importe formateadas
    public String StrFacturaImporte {get;set;}
    public String StrDescripcion {get;set;}
    public String StrImporte {get;set;}
    public String StrCodigoImpuesto {get;set;}
    public String StrFacturaImporteIVA {get;set;}
    public String StrFacturaImporteConIVA {get;set;}
    public Map<Id, List<String>> MapFacturas {get;set;}
    

	public Documento_factura_controller(){

		Id idFactura = ApexPages.currentPage().getParameters().get('id'); system.debug('TEST idFactura ' +idFactura);

		factura = [ SELECT  id,
							name,
							sociedad__c, 
							cliente__c, 
							Numero_de_factura__c, 
							CreatedDate, 
							descripcion__c,
							Codigo_Impuesto__c, 
                   			Fecha_de_emision__c,
							Importe__c,
							Oportunidad__r.Promocion__r.Name,
                   			Oportunidad__r.Amount,
                   			Oportunidad__r.Acumulado_de_Importe_Pagado__c
					FROM Factura__c 
					WHERE id =: idFactura];
        
        List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
        
        if(factura.name != null && factura.name.contains('Escrituración')){
            isFacturaEscrituracion = true;
            TotalImporteEscr = String.format(factura.Oportunidad__r.Amount.format(), formateo) + ' €';
            TotalCobradoImporteEscr = String.format(getEntregaCuenta(idFactura).format(), formateo) + ' €';
            //TotalCobradoImporteEscr = String.format(factura.Oportunidad__r.Acumulado_de_Importe_Pagado__c.format(), formateo) + ' €';
        } 
        
        getListaClientes();
		getLineasFacturaList();
		getSociedad();
		getLocalidad();
		getPais();
		getFechaCreacion();
		getImporteIVA();
		getImporteConIVA();
        
        //Formateamos campos de importe
        //
        if(factura.Importe__c != null){
           		StrFacturaImporte = String.format(factura.Importe__c.format(), formateo) + ' €' ;
           	}
        if(factura.Codigo_Impuesto__c != null){
            StrCodigoImpuesto = String.format(factura.Codigo_Impuesto__c.format(), formateo) + ' %' ;
        }

	}

	public void getListaClientes(){

		List <Participante__c> listaParticipantes = [SELECT Id, 
															Cliente__c, 
															Porcentaje_de_participacion__c 
													FROM Participante__c 
													WHERE Opportunity__r.Id =: factura.Oportunidad__r.Id];

		MapaParticipantesOpp = new Map <id, String>();
        
		List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
    
		for(Participante__c participante : listaParticipantes){
            if(participante.Porcentaje_de_participacion__c != null){
           	String Strparticipacion = String.format(participante.Porcentaje_de_participacion__c.format(), formateo) + ' %' ;
			MapaParticipantesOpp.put(participante.Cliente__c, Strparticipacion);
            }
		}

		Set<Id> accsIds = new Set<Id>();
		for(Participante__c participante : listaParticipantes){
			accsIds.add(participante.Cliente__c);
		}

		listaClientes = [SELECT Id,
								Name,  
								PersonTitle, 
								Tipo_de_documento__c, 
								N_Documento__c, 
								DF_N_piso__c, 
								DF_Puerta__c, 
								DF_Escalera__c, 
								DF_Codigo_postal__c, 
								DF_Provincia__c, 
								DF_Pais__r.Name,
								DF_Pais__r.Codigo_ISO3__c, 
								DF_Tipo_de_via__c, 
								DF_Nombre_via__c, 
								DF_N_via__c, 
								Phone, 
								DF_Localidad__c, 
								Direccion_Extranjera_F__c 
						FROM Account
						WHERE Id IN :accsIds];
        
	}

	public void getLineasFacturaList(){
		
		lineasFacturaList = [SELECT id, 
									Importe__c, 
									DescripcionLinea__c
							 FROM Linea_de_factura__c 
							 WHERE Factura__c =: factura.Id];

		//system.debug('Entra en getLineasFactura ' + lineasFacturaList);
		
		List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
          	//Formateamos campos de importe
           	        
        List<String> FacturaAux= new List <String>();
        MapFacturas = new Map<Id, List<String>>();
        
        for(integer i = 0; i < lineasFacturaList.size() ; i++){
            StrDescripcion =  '#@#VACIO#@#';
            StrImporte = '#@#VACIO#@#';
            
            FacturaAux = new List <String>();
            if(lineasFacturaList[i].DescripcionLinea__c!=null){
            	StrDescripcion = lineasFacturaList[i].DescripcionLinea__c;
            }
            if(lineasFacturaList[i].Importe__c!=null){
            	StrImporte = String.format(lineasFacturaList[i].Importe__c.format(), formateo);
            }
            
           	FacturaAux.add(StrDescripcion);
            FacturaAux.add(StrImporte);
            MapFacturas.put(lineasFacturaList[i].Id, FacturaAux);
        }
        
	}

	public void getSociedad(){
		
		 sociedad = [SELECT id, 
							name, 
							Tipo_de_documento__c,
							N_Documento__c , 
							DF_Tipo_de_via__c, 
							DF_Nombre_via__c, 
							DF_N_via__c, Phone, 
							DF_Codigo_postal__c,
							DF_Localidad__c, 
							DF_Provincia__c, 
							DF_Pais__c
					 FROM Account 
					 WHERE Id =: factura.sociedad__c];

		//system.debug('Entra en getSociedad ' + sociedad);
	}

	public void getLocalidad(){

		Municipio__c localidad = [  SELECT name 
									FROM Municipio__c 
									WHERE id =: sociedad.DF_Localidad__c LIMIT 1];        
		NombreLocalidad = localidad.name;

		//system.debug('Entra en getLocalidad '+ localidad);
	}

	public void getPais(){

		Pais__c pais = [SELECT  name, 
								Codigo_ISO3__c 
						FROM Pais__c 
						WHERE id =: sociedad.DF_Pais__c LIMIT 1];
		NombrePais = pais.name;

		//system.debug('Entra en getPais ' + pais);
	}

	public void getFechaCreacion(){
        if(factura != null && factura.Fecha_de_emision__c  != null) {
            fechaCreacion = factura.Fecha_de_emision__c.day()+' de '+getMes(factura.Fecha_de_emision__c.month())+' del año '+factura.Fecha_de_emision__c.year();
        } else {
            fechaCreacion = datetime.now().day()+' de '+getMes(datetime.now().month())+' del año '+datetime.now().year();
        }
	}

	public String getMes(Integer mes){
		
		String nombreMes;
		if(mes == 1){nombreMes = 'Enero'; }
		else if(mes == 2){nombreMes = 'Febrero';}
		else if(mes == 3){nombreMes = 'Marzo';}
		else if(mes == 4){nombreMes = 'Abril';}
		else if(mes == 5){nombreMes = 'Mayo';}
		else if(mes == 6){nombreMes = 'Junio';}
		else if(mes == 7){nombreMes = 'Julio';}
		else if(mes == 8){nombreMes = 'Agosto';}
		else if(mes == 9){nombreMes = 'Septiembre';}
		else if(mes == 10){nombreMes = 'Octubre';}
		else if(mes == 11){nombreMes = 'Noviembre';}
		else if(mes == 12){nombreMes = 'Diciembre';}
		return nombreMes;
	}
	
	public void getImporteIVA(){
		
		if(factura.Codigo_Impuesto__c != null){
			IVA = factura.Codigo_Impuesto__c;
		}else{
			IVA = 0;
		} 
		
		importeIVA = factura.Importe__c * iva*0.01;
        
        
        List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
        //Formateamos campos de importe
        if(importeIVA != null){
       			StrFacturaImporteIVA = String.format(importeIVA.format(), formateo) + ' €';
       		}
        System.debug('Prueba StrFacturaImporteIVA:::'+StrFacturaImporteIVA);
        //System.debug('Codigo Impuesto' + factura.Codigo_Impuesto__c);
	}

	Public void getImporteConIVA(){
		importeConIVA = factura.Importe__c + importeIVA;
        List <String> formateo = new String[]{'0', 'number', '###.###.##0,00'};
        //Formateamos campos de importe
        if(importeConIVA != null){
       			StrFacturaImporteConIVA = String.format(importeConIVA.format(), formateo) + ' €';
       		}
        System.debug('Prueba StrFacturaImporteConIVA:::'+StrFacturaImporteConIVA);
	}
    
    
        Public Double getEntregaCuenta(Id idFactura){
        Double entregaCuenta = 0;
        list<Linea_de_factura__c> listaLineasFactura = [SELECT Id, Importe__c FROM Linea_de_factura__c where Factura__c =: idFactura AND Tipo_de_linea__c = 'Entrega a cuenta'];
        if (listaLineasFactura.size()>0){
            for (Integer i =0; i<listaLineasFactura.size(); i++){
                if (listaLineasFactura[i].Importe__c!=null){
                    entregaCuenta += listaLineasFactura[i].Importe__c;
                }
            }
        }
        if (entregaCuenta<0){
        	entregaCuenta = entregaCuenta *(-1);
        }
        return entregaCuenta;
    }
}