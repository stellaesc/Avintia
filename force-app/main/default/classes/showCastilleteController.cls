public class showCastilleteController{
	
    //Variables donde se guardan los parámetros que se pasan por url: id del registro, id del inmueble, tipo de inmueble, número de parcela, número de bloque y páginaNueva que es una variable auxiliar
    //y que definen cómo se cargará el castillete
    public Id idSel {get;set;}
    public String paginaNueva {get;set;}    
    public String idproduct {get;set;}    
    public String tipoSel {get;set;}
    public String parcelaSel {get;set;}
    public String bloqueSel {get;set;}

	//Variable donde se guarda la promoción seleccionada 
    public String promSel {get;set;}
    
    //Listas y maps para dibujar el castillete 
    public Map<String, List<Integer>> lpisosPorPortal {get;set;}
    public Map<String, List<String>> lpuertasPorPortal {get;set;}
    public Map<String, Map<Integer,List<Product2>>> mapmapproductos {get;set;}  
    public Map<String, String> mapplantaspisos {get;set;}     

	//Variables donde se guardan la Oportunidad en el caso en que el castillete esté en Oportunidad y el producto de Oportunidad
    public List<Opportunity> oportunidad {get;set;}
    public List<OpportunityLineItem> prodOportunidadList {get;set;}
    public Quote presupuesto {get;set;}
    public List<QuoteLineItem> prodPresupuestoList {get;set;}
    
    //Variables relativas a la cuenta a la que se va a asociar el inmueble
	public String searchstring {get;set;}
    public List<Account> acc {get;set;}
    public Id accSelected {get;set;}
    
    //Otras varibles necesarias
    public List<String> portalSel {get;set;}
    public List<String> portalSelList {get;set;}
    public List<String> estadosUV{get;set;}
    public String activosSeleccionados {get;set;}
    public String dominio {get;set;}

    //Variables para mostrar Tipos de Inmueble y estados asociados 
    public String viviendasTotales {get;set;}
    public String viviendasLibres {get;set;}
    public String viviendasReservadas {get;set;}
    public String viviendasContratadas {get;set;}
    public String viviendasEnPlanDePagos {get;set;}
    public String viviendasEscrituradas {get;set;}

    public String trasterosTotales {get;set;}
    public String trasterosLibres {get;set;}
    public String trasterosReservados {get;set;}
    public String trasterosContratados {get;set;}
    public String trasterosEnPlanDePagos {get;set;}
    public String trasterosEscriturados {get;set;}

    public String garajesTotales {get;set;}
    public String garajesLibres {get;set;}
    public String garajesReservados {get;set;}
    public String garajesContratados {get;set;}
    public String garajesEnPlanDePagos {get;set;}
    public String garajesEscriturados {get;set;}

    public String localesTotales {get;set;}
    public String localesLibres {get;set;}
    public String localesReservados {get;set;}
    public String localesContratados {get;set;}
    public String localesEnPlanDePagos {get;set;}
    public String localesEscriturados {get;set;}    

    /***********************************************************************************************************
    * Method Name: showCastilleteController                                                                    *
    * Description:  Constructor de la Clase.                                                                   *
    * Author: Deloitte                                                                                         *
    * *********************************************************************************************************/
    public showCastilleteController() {

        //Recuperamos todos los parametros que se pasan por URL cuando se recarga el castillete
        idSel = ApexPages.currentPage().getParameters().get('Id');        

        viviendasTotales        = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Tipo_de_inmueble__r.Tipo__c  = 'Vivienda'                                                            AND IsActive = true AND IsArchived = False ]);
        viviendasLibres         = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Estado__c                    = 'Libre'               AND Tipo_de_inmueble__r.Tipo__c = 'Vivienda'    AND IsActive = true AND IsArchived = False ]);      
        viviendasReservadas     = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Reserva'             AND Tipo_de_inmueble__r.Tipo__c = 'Vivienda'    AND IsActive = true AND IsArchived = False ]);
        viviendasContratadas    = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Contrato'            AND Tipo_de_inmueble__r.Tipo__c = 'Vivienda'    AND IsActive = true AND IsArchived = False ]);
        viviendasEscrituradas   = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Escrituración'       AND Tipo_de_inmueble__r.Tipo__c = 'Vivienda'    AND IsActive = true AND IsArchived = False ]);
        viviendasEnPlanDePagos  = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Plan de pagos'       AND Tipo_de_inmueble__r.Tipo__c = 'Vivienda'    AND IsActive = true AND IsArchived = False ]);

        trasterosTotales        = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Tipo_de_inmueble__r.Tipo__c  = 'Trastero'                                                            AND IsActive = true AND IsArchived = False ]);
        trasterosLibres         = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Estado__c                    = 'Libre'               AND Tipo_de_inmueble__r.Tipo__c = 'Trastero'    AND IsActive = true AND IsArchived = False ]);      
        trasterosReservados     = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Reserva'             AND Tipo_de_inmueble__r.Tipo__c = 'Trastero'    AND IsActive = true AND IsArchived = False ]);
        trasterosContratados    = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Contrato'            AND Tipo_de_inmueble__r.Tipo__c = 'Trastero'    AND IsActive = true AND IsArchived = False ]);
        trasterosEscriturados   = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Escrituración'       AND Tipo_de_inmueble__r.Tipo__c = 'Trastero'    AND IsActive = true AND IsArchived = False ]);
        trasterosEnPlanDePagos  = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Plan de pagos'       AND Tipo_de_inmueble__r.Tipo__c = 'Trastero'    AND IsActive = true AND IsArchived = False ]);

        garajesTotales          = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Tipo_de_inmueble__r.Tipo__c  = 'Garaje'                                                              AND IsActive = true AND IsArchived = False ]);
        garajesLibres           = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Estado__c                    = 'Libre'               AND Tipo_de_inmueble__r.Tipo__c = 'Garaje'      AND IsActive = true AND IsArchived = False ]);      
        garajesReservados       = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Reserva'             AND Tipo_de_inmueble__r.Tipo__c = 'Garaje'      AND IsActive = true AND IsArchived = False ]);
        garajesContratados      = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Contrato'            AND Tipo_de_inmueble__r.Tipo__c = 'Garaje'      AND IsActive = true AND IsArchived = False ]);
        garajesEscriturados     = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Escrituración'       AND Tipo_de_inmueble__r.Tipo__c = 'Garaje'      AND IsActive = true AND IsArchived = False ]);
        garajesEnPlanDePagos    = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Plan de pagos'       AND Tipo_de_inmueble__r.Tipo__c = 'Garaje'      AND IsActive = true AND IsArchived = False ]);

        localesTotales          = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Tipo_de_inmueble__r.Tipo__c  = 'Local'                                                               AND IsActive = true AND IsArchived = False ]);
        localesLibres           = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Estado__c                    = 'Libre'               AND Tipo_de_inmueble__r.Tipo__c = 'Local'       AND IsActive = true AND IsArchived = False ]);      
        localesReservados       = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Reserva'             AND Tipo_de_inmueble__r.Tipo__c = 'Local'       AND IsActive = true AND IsArchived = False ]);
        localesContratados      = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Contrato'            AND Tipo_de_inmueble__r.Tipo__c = 'Local'       AND IsActive = true AND IsArchived = False ]);
        localesEscriturados     = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Escrituración'       AND Tipo_de_inmueble__r.Tipo__c = 'Local'       AND IsActive = true AND IsArchived = False ]);        
        localesEnPlanDePagos    = String.valueOf([SELECT COUNT() FROM Product2 WHERE  Promocion__r.Id =: idSel AND Oportunidad__r.StageName     = 'Plan de pagos'       AND Tipo_de_inmueble__r.Tipo__c = 'Local'       AND IsActive = true AND IsArchived = False ]);

        
        paginaNueva = ApexPages.currentPage().getParameters().get('paginaNueva');
        idproduct = ApexPages.currentPage().getParameters().get('idproduct');
        //tipoSel se pasa cuando se cambia el tipo de inmueble en el combo
        tipoSel = ApexPages.currentPage().getParameters().get('tipoSel');
        parcelaSel = ApexPages.currentPage().getParameters().get('parcelaSel');
        if( ApexPages.currentPage().getParameters().get('bloqueSel') != null && ApexPages.currentPage().getParameters().get('bloqueSel').trim() != ''){
        	bloqueSel = ApexPages.currentPage().getParameters().get('bloqueSel');            
        }
        dominio = System.URL.getSalesforceBaseUrl().toExternalForm() + '/';
        activosSeleccionados = '';
        
        //Como la visualforce esta en Promocion y Oportunidad idSel puede ser el Id de la Promocion o de la Oportunidad. Metemos en promSel el valor bueno
        List<Promocion__c> promocion = new List<Promocion__c>();
        promocion = [SELECT Id FROM Promocion__c WHERE Id =: idSel];
        system.debug('promocion:::'+promocion);
        system.debug('idSel:::'+idSel);
        if(promocion == null || promocion.isEmpty() && idSel != null){
            oportunidad = [SELECT Id, Promocion__c FROM Opportunity WHERE Id =: idSel];
            system.debug('oportunidad:::'+oportunidad);
            if(oportunidad == null || oportunidad.isEmpty() && idSel != null){
            	   presupuesto = [SELECT Id, Opportunity.Promocion__c FROM Quote WHERE Id =: idSel]; 
                   Id promocionId = presupuesto.Opportunity.Promocion__c;
                   promocion = [SELECT Id FROM Promocion__c WHERE Id =: promocionId];
                   promSel = promocion[0].Id;
                   system.debug('promSel:::'+promSel);
                
            }else{
                Id promocionId = oportunidad[0].Promocion__c;
                promocion = [SELECT Id FROM Promocion__c WHERE Id =: promocionId];
                promSel = promocion[0].Id;
                system.debug('promSel:::'+promSel);
                //prodOportunidadList = [SELECT Id, OpportunityId  FROM OpportunityLineItem WHERE OpportunityId =: idSel];
                //system.debug('prodOportunidadList:::'+prodOportunidadList);
            }

        }else if(oportunidad == null && idSel != null){
            promSel = idSel;
            system.debug('promSel:::'+promSel);
        }
        
        system.debug('promSel:::'+promSel);
        System.debug('parcelaSel:::'+parcelaSel);
        

        //Por defecto el combo pone el bloque = 1
        if(bloqueSel == null ){
            List<SelectOption> optionsBloque = getBloque();
            if(optionsBloque.size() == 0){
                bloqueSel= '1'; 
            }else if(optionsBloque.size() >= 1){
            	bloqueSel= getBloque()[0].getValue();    
            }
        }        
        System.debug('bloqueSel:::'+bloqueSel);
        //Por defecto el combo pone tipo de inmueble = vivienda
        if(tipoSel == null || tipoSel == ''){
            tipoSel='Vivienda';
        }
        
            
        //Entra en los métodos para pintar el castillete
        getPortales();

    }
    

/***********************************************************************************************************
* Method Name: getEstados                                                                                  *
* Description:  Recupera los estados de la picklist estado__c para pintarlos en la leyenda del castillete. *
* Author: Deloitte                                                                                         *
* *********************************************************************************************************/  
    
    public void getEstados(){
      // cargamos los estados del picklist de Estados para mostrarlos en la leyenda con sus colores.
      estadosUV = new List<String>(); //new list for holding all of the picklist values     
      Schema.sObjectType sobject_type = Product2.getSObjectType(); //grab the sobject that was passed
      Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
      Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
      List<Schema.PicklistEntry> pick_list_values = field_map.get('estado__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
      for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
               system.debug('estado: ' + a.getLabel());   
            estadosUV.add(a.getLabel()); //add the value and label to our final list
      } 
      
    }


    
/****************************************************************************************************
* Method Name: abrirInmueble                                                                        *
* Description:  . *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/      
    
    public PageReference abrirInmueble(){
    	String param = ApexPages.CurrentPage().getParameters().get('bloqueid');
    	return null;
    }

/**************************************************************************************************************************
* Method Name: bloqueaActivo                                                                                              *
* Description:  Actualiza en base de datos el estado del inmueble cuando se hace doble click sobre este en el castillete. *
* Author: Deloitte                                                                                                        *
* ************************************************************************************************************************/   
    
    public PageReference bloqueaActivo(){
        System.debug('Entra en bloqueaActivo');
        String param = ApexPages.CurrentPage().getParameters().get('bloqueid');
        Id blockId = Id.valueOf(param);
		System.debug('blockId:::'+ blockId);
        List<Product2> bloques= [Select ID,Estado__c, UltimoModificadorEstado__c, Promocion__c, Oportunidad__c  from Product2 where ID=:blockId];
        Product2 bloque =bloques.get(0);
        List<Product2> inmueblesPromocion= [Select ID, Estado__c, UltimoModificadorEstado__c, Promocion__c, Oportunidad__c  from Product2 where Promocion__c =: bloque.Promocion__c AND ID !=:blockId];
        System.debug('inmueblesPromocion:::'+ inmueblesPromocion);
        
        List<Product2> inmueblesToUpdate = new List<Product2>();

        // Este bloque if else es para poner en el estado correcto el inmueble seleccionado
        if(bloque.Estado__c == 'Libre'){
            bloque.Estado__c='Bloqueado Temporalmente';
        	inmueblesToUpdate.add(bloque);
        }
        else if(bloque.Estado__c == 'Bloqueado Temporalmente'){
            if(bloque.Oportunidad__c == null && bloque.UltimoModificadorEstado__c != null && bloque.UltimoModificadorEstado__c.substring(0, 15) == UserInfo.getUserId().substring(0, 15)){
                bloque.Estado__c='Libre';
                inmueblesToUpdate.add(bloque);                
            }

        }
        
        // Este for devuelve a Libre los inmuebles que hubieses seleccionado antes
        for(Product2 inmueble : inmueblesPromocion){
            if(inmueble.Estado__c == 'Bloqueado Temporalmente'){
                if(inmueble.Oportunidad__c == null && inmueble.UltimoModificadorEstado__c != null && inmueble.UltimoModificadorEstado__c.substring(0, 15) == UserInfo.getUserId().substring(0, 15)){
                    inmueble.Estado__c = 'Libre';
                    System.debug('inmuebleNOSeleccionadoBloqueado:::'+inmueble + 'opp: ' + inmueble.Oportunidad__c);
                    inmueblesToUpdate.add(inmueble);                    
                }

            }
            
        }
        
        update inmueblesToUpdate; 
        return null;    

    }

    
/****************************************************************************************************
* Method Name: getPortales                                                                        *
* Description:  . *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/      
    public PageReference getPortales() {
        getEstados(); 
        system.debug('getPortales: ');
        system.debug('tipoSel:::'+tipoSel);

         portalSel =null;
           
       if (tipoSel=='Vivienda') {
           List<Product2> portales=[Select Portal__c, Escalera__c, Oportunidad__c from Product2 where Promocion__c=:promSel and Tipo_de_inmueble__r.Tipo__c=:tipoSel AND Bloque__c =: bloqueSel AND Parcela__c =: parcelaSel];
           
           //portalSelList concatena el portal con la escalera. Esta variable NO se pasa luego a la query para recuperar inmubles, sino que se usa para iterar en la visualforce
           Set<String> res = new Set<String>();
           for (Product2 p: portales) {
               if(p.Portal__c != null && p.Escalera__c != null){
                  res.add(p.Portal__c + '-' + p.Escalera__c);                   
               }if(p.Portal__c != null && p.Escalera__c == null){
                  res.add(p.Portal__c);     
               }
           }
           
           List<String> result = new List<String>(res);
           result.sort();
           system.debug('showCastilleteController | getPortales() - result: ' + result);
           portalSel=result;
           //portalSel=result[0];
           getUnidadesVenta();
           
      //Los Trasteros y Garajes no van por portal, sino por bloque (un bloque puede incluir varios portales)
      //Para reutilizar el método getUnidadesVenta() recuperamos los bloques (tipo número), los pasamos a textos y los asignamos al campo Portal sin hacer update 
       }else if(tipoSel=='Trastero' || tipoSel=='Garaje' || tipoSel=='Local') {
           List<Product2> bloques=[Select Portal__c, Bloque__c, Oportunidad__c from Product2 where Promocion__c=:promSel and Tipo_de_inmueble__r.Tipo__c=:tipoSel AND Bloque__c =: bloqueSel AND Parcela__c =: parcelaSel];

           Set<String> res = new Set<String>();
           for (Product2 p: bloques) {
               if(p.Bloque__c != null){ 
                  res.add(p.Bloque__c);                   
               }
           }
           
           List<String> result = new List<String>(res);
           system.debug('showCastilleteController | getPortales() - result: ' + result);
           //portalSel guarda en este caso los BLOQUES seleccionados
           portalSel=result;
       	   getUnidadesVenta();
       }
      return null;
    
    }
   
/****************************************************************************************************
* Method Name: getUnidadesVenta                                                                        *
* Description:  Organiza la información de los inmuebles asociadas. *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/ 
    
    public PageReference getUnidadesVenta() {    
        mapmapproductos = new Map<String, Map<Integer,List<Product2>>>();
        lpisosPorPortal = new Map<String, List<Integer>>(); 
        lpuertasPorPortal = new Map<String, List<String>>(); 
        
        mapplantaspisos = new Map<String, String>();
        
        system.debug('portalSel:::'+ portalSel);
        for(String portal : portalSel){
        Set<String> setPuertas= new Set<String>();
        String plantaspisos=null;
        
        //
        List<Product2> lista;
        if (tipoSel=='Vivienda') {
            lista =[Select id, name, Portal__c, Bloque__c, Parcela__c, Escalera__c, planta__c, Piso__c,Tipo_de_inmueble__r.Tipo__c, Tipo_de_inmueble__r.Name, Inmueble_asociado__c, Letra_N_Puerta__c, estado__c, 
                    Precio__c, Superficie_Util_m2__c, UltimoModificadorEstado__c, Precio_Comercial__c, Oportunidad__c 
                    from Product2 
                    where Promocion__c=:promSel AND Parcela__c =: parcelaSel AND Bloque__c =: bloqueSel AND Portal__c= :portal.substringBefore('-') and Tipo_de_inmueble__r.Tipo__c=:tipoSel order by Portal__c,Piso__c, Letra_N_Puerta__c];
        }
        else if(tipoSel=='Trastero' || tipoSel=='Garaje' || tipoSel=='Local'){
            lista =[Select id, name, Portal__c, Bloque__c, Parcela__c, Escalera__c, planta__c, Piso__c,Tipo_de_inmueble__r.Tipo__c,Tipo_de_inmueble__r.Name, Inmueble_asociado__c, Letra_N_Puerta__c, estado__c, 
                    Precio__c, Superficie_Util_m2__c, UltimoModificadorEstado__c, Precio_Comercial__c, Oportunidad__c 
                    from Product2 
                    where Promocion__c=:promSel AND Parcela__c =: parcelaSel AND Bloque__c =: bloqueSel /* and Bloque__c =: Integer.valueOf(portal) */ and Tipo_de_inmueble__r.Tipo__c=:tipoSel order by Bloque__c,Piso__c, Letra_N_Puerta__c]; 
            
        Decimal pisoAnterior = lista[0].Piso__c;
        if(lista[0].Letra_N_Puerta__c == null){
            Integer j = 0;
            for(Integer i=0; i<lista.size(); i++){
                if(pisoAnterior != lista[i].Piso__c){
                        j=0;
                        pisoAnterior = lista[i].Piso__c;
                 }
                 j++;
                 lista[i].Letra_N_Puerta__c = String.valueOf(j);
            }         
        }
            
        }
        
        //
        for(Product2 inmueble : lista){
            if(inmueble.Piso__c == null){
            	inmueble.Piso__c = 500;    
            }
            if(inmueble.Portal__c != null && inmueble.Escalera__c != null){
                inmueble.Portal__c = inmueble.Portal__c + '-' + inmueble.Escalera__c;                   
            }
           
        }    
        // si son pisos tenemos que reordenar los datos para mostrar
        // Ático - pisos en orden descendente  - Bajos
        // procesamos los áticos primero y calculamos el piso más alto.
        Integer pisoAlto=0;
        Integer pisoBajo=0;

        Map<Integer,List<Product2>> mapproductos =new Map<Integer,List<Product2>>();

        List<Integer> lpisos=new List<Integer>();
        if(tipoSel!='Vivienda') { pisoAlto=-20;}
       
        system.debug('lista: ' + lista);
        
        
        for (product2 prod:lista) {
            if((prod.Tipo_de_inmueble__r.Tipo__c == 'Vivienda' && prod.Portal__c.substringAfter('-') == portal.substringAfter('-')) ||
               prod.Tipo_de_inmueble__r.Tipo__c != 'Vivienda'){           
                        
                if(prod.Piso__c>pisoalto) { 
                        pisoalto=Integer.valueOf(prod.Piso__c);
                        system.debug('El piso más alto encontrado hasta el momento es el ' + pisoalto);
                }
                    
                if(prod.Piso__c<pisoBajo) { 
                        pisoBajo=Integer.valueOf(prod.Piso__c);
                        system.debug('El piso más bajo encontrado hasta el momento es el ' + pisoBajo);
                }
                
            }
        }
     	system.debug('pisoalto: ' + pisoalto);                     
  		system.debug('pisoBajo: ' + pisoBajo);
        // ahora con la lista de pisos los introducimos en la lista de forma ordenada.
        for (Integer i=pisoalto;i>=pisoBajo;i--) {    
        system.debug('recorre pisos: ' + i);    
          for (Product2 prod:lista) {
				if((prod.Tipo_de_inmueble__r.Tipo__c == 'Vivienda' && prod.Portal__c.substringAfter('-') == portal.substringAfter('-')) ||
               		prod.Tipo_de_inmueble__r.Tipo__c != 'Vivienda'){ 
                    if(prod.Piso__c==i) {
                        List<Product2> lproductos= mapproductos .get(Integer.valueOf(prod.Piso__c));
                        if (lproductos==null) {
                          system.debug('El mapa está vacío para el piso: ' + prod.Piso__c);
                          lproductos=new List<Product2>();
                                                lpisos.add(Integer.valueOf(prod.Piso__c));
                        }
                        lproductos.add(prod);
                        system.debug('Metemos el piso en el Mapa.');
                        mapproductos.put(Integer.valueOf(prod.Piso__c),lproductos);
                        system.debug('portal:::' + prod.Portal__c);
                        system.debug('Mapa de pisos: ' + mapproductos.get(Integer.valueOf(prod.Piso__c)));
                        system.debug('puerta encontrada: ' + prod.Letra_N_Puerta__c);
                        setPuertas.add(prod.Letra_N_Puerta__c);
                        plantaspisos=plantaspisos+ ' ' + String.valueOf(prod.Piso__c)+prod.Letra_N_Puerta__c;
                    }

         		}
          }
       }  

      //  lpuertas = new List<String>(setPuertas);
       
      List<String> puertasordenadas = new List<String>(setPuertas);
      puertasordenadas.sort();
      
      List<Integer> puertasordenadasInteger = new List<Integer>();           
      //puertasordenadas
      if(puertasordenadas != null && puertasordenadas.size() > 0 && !puertasordenadas[0].isAlpha()){
      	  for(String puerta : puertasordenadas){
          		puertasordenadasInteger.add(Integer.valueOf(puerta));	
          } 
          puertasordenadasInteger.sort();
      	  puertasordenadas = new List<String>();
          for(Integer puerta : puertasordenadasInteger){
          		puertasordenadas.add(String.valueOf(puerta));	
          }
          //Ordenamos los productos
          Map<Integer, List<Product2>> mapproductosAux = new Map<Integer, List<Product2>>();
          for(Integer piso : lpisos){
              List<Product2> productListAux = new List<Product2>();
              for(String puertaString : puertasordenadas){
                  for(Product2 producto : mapproductos.get(piso)){
                      if(producto.Letra_N_Puerta__c == puertaString){
                          productListAux.add(producto);
                      }
                  }   
              }
              mapproductosAux.put(piso, productListAux);
          }
          mapproductos =  mapproductosAux;   
      }

      List<String> lpuertas = new List<String>();    
      lpuertas = puertasordenadas ;
      
      system.debug('lpisos:::'+lpisos); 
      system.debug('lpuertas:::'+lpuertas);
      lpisosPorPortal.put(portal,lpisos);
      system.debug('lpisosPorPortal: ' + lpisosPorPortal);
      lpuertasPorPortal.put(portal,lpuertas);
      system.debug('lpuertasPorPortal: ' + lpuertasPorPortal);
      mapmapproductos.put(portal, mapproductos);
      system.debug('mapmapproductos: ' + mapmapproductos); 
      mapplantaspisos.put(portal, plantaspisos  + ' ');
      system.debug('mapplantaspisos: ' + mapplantaspisos); 
       
            
      }
      return null;
    }


/****************************************************************************************************
* Method Name: insertarProdPresupuesto                                                                 *
* Description:  método asociado al botón Añadir inmueble que asociada a la Quote un producto de Quote. *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/

    public PageReference insertarProdPresupuesto(){
        system.debug('Entra en insertarProdPresupuesto');
        Id currentUsertId = UserInfo.getUserId();
        Id presupuestoId = ApexPages.currentPage().getParameters().get('Id');
        Id standardPriceBookId = Utils.getStandarPriceBook();
        
  /*  ----------------- QUOTE ------------------------- */
        Quote presupuesto = [SELECT Id, AccountId, Account.Name, OpportunityId, IsSyncing FROM Quote WHERE Id =: presupuestoId];
        
        presupuesto.Pricebook2Id = standardPriceBookId;
        update presupuesto;
        
  /*  ----------------- INMUEBLES ------------------------- */
        //inmuebleSel es el inmueble seleccionado en el castillete
        List<Product2> inmuebleSel = [SELECT Id, Name, Estado__c, UltimoModificadorEstado__c, Promocion__c, Precio__c, Tipo_de_inmueble__r.Tipo__c, Oportunidad__c 
                                      FROM Product2 
                                      WHERE Estado__c = 'Bloqueado Temporalmente' AND UltimoModificadorEstado__c =: UserInfo.getUserId().substring(0, 15) AND Promocion__c =: promSel];
        system.debug('inmuebleSel:::'+inmuebleSel); 
        
        try{
        //inmueblesTotales son los inmuebles asociados al seleccionado en el castillete
        List<Product2> inmueblesTotales = [SELECT Id, Name, Inmueble_asociado__c, Precio__c, Tipo_de_inmueble__r.Tipo__c, Oportunidad__c FROM Product2 WHERE Inmueble_asociado__c =:inmuebleSel[0].Id ];
        
        //Metemos tanto el inmueble principal como los asociados a la lista inmueblesTotales
        if(inmueblesTotales.size() != 0){
        	inmueblesTotales.add(0, inmuebleSel[0]);
        }else{
        	inmueblesTotales.add(inmuebleSel[0]);
        }            
   
        //Comprobamos si hay algún inmueble que no tenga precio   
        String nombresConcatenados = '';
        for(Product2 inmueble: inmueblesTotales){
        	if(inmueble.Precio__c == null || inmueble.Precio__c == 0){
            	nombresConcatenados += ', ' + inmueble.Name;
            }if(inmueble.Tipo_de_inmueble__r.Tipo__c == 'Vivienda'){
                nombresConcatenados = inmueble.Name + nombresConcatenados;
            }
        }    
        
  /*  ----------------- PRODUCTO DE PRESUPUESTO ------------------------- */
        //Creamos un producto de Presupuesto por cada inmueble y lo metemos a prodPresupuestoList  
        prodPresupuestoList = new List<QuoteLineItem>(); 
        for(Product2 inmueble: inmueblesTotales){
            QuoteLineItem prodPresupuestoToInsert;
            if(inmueble.Precio__c == null || inmueble.Precio__c == 0 || inmueble.Tipo_de_inmueble__r.Tipo__c == 'Vivienda'){
                prodPresupuestoToInsert = new QuoteLineItem(QuoteId = presupuesto.Id, Quantity = 1, Product2Id = inmueble.Id, 
                                                                         UnitPrice = inmueble.Precio__c, Description = nombresConcatenados.trim());
            }else{
            	prodPresupuestoToInsert = new QuoteLineItem(QuoteId = presupuesto.Id, Quantity = 1, Product2Id = inmueble.Id,
                                                                         UnitPrice = inmueble.Precio__c, Description = inmueble.Name);
            } 
            prodPresupuestoList.add(prodPresupuestoToInsert);
        }

		system.debug('prodPresupuestoList:::'+prodPresupuestoList);           

        try{

        	Database.SaveResult[] srList2 = Database.insert(prodPresupuestoList, true);
            // Iterate through each returned result
            for (Database.SaveResult sr : srList2) {
            	if (sr.isSuccess()) {
                	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Los inmuebles se han añadido con éxito'));
                    System.debug('La insercion del Quote Line Item ha sido exitosa con ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ha habido un error al insertar los inmuebles: ' + err.getStatusCode() + ': ' + err.getMessage() ));
                        System.debug('The following error has occurred. '+err.getStatusCode() + ': ' + err.getMessage());                    
                    }
                 }
             } 

                

            //si va bien, devolvemos el estado a Libre para que lo puedan meter en otras quotes
            if(!presupuesto.IsSyncing){
                try{
                    for(Product2 inmueble : inmueblesTotales){
                        if(inmueble.Precio__c != null){
                        	inmueble.Estado__c = 'Libre';
                        }
                    }
                //Hacemos el update guardando también si el resultado ha sido exitoso o no con la clase SaveResult
                Database.SaveResult[] srList = Database.update(inmueblesTotales, false);             
                //Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Los inmuebles se han añadido con éxito'));
                        System.debug('La actualización de los inmuebles ha sido exitosa con ID: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ha habido un error al actualizar los inmuebles' + err.getStatusCode() + ': ' + err.getMessage() ));
                            System.debug('The following error has occurred. '+err.getStatusCode() + ': ' + err.getMessage());   
                         }
                     }
                 }
      
                }catch(System.DmlException e){
                    System.debug('showCastilleteController | insertarProdOportunidad() - DmlException: ' + e.getMessage());
                    return null;            
                }                
            }

        }catch(System.DmlException e){
        	System.debug('showCastilleteController | insertarProdOportunidad() - DmlException: ' + e.getMessage());
        	return null;            
        }
        }catch(System.ListException e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No se ha seleccionado inmueble'));
        	System.debug('showCastilleteController | insertarProdOportunidad() - ListException: ' + e.getMessage());
        	return null;              
        }

		return null;
    }


/****************************************************************************************************
* Method Name: insertarOportunidad                                                                        *
* Description: método asociado al botón Crear Oportunidad, que recibe una cuenta y un inmueble y crea una Oportunidad con un producto de Oportunidad . *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/    
    
    
    public PageReference insertarOportunidad(){
        
 /* -------------------- CUENTA ---------------------- */
		accSelected = System.currentPagereference().getParameters().get('accId');
        Account cuenta = new Account();
        try{
            cuenta = [SELECT Id, Name FROM  Account WHERE Id =: accSelected];
            system.debug('cuenta:::'+cuenta);             
        }catch (System.QueryException e){
            System.debug('showCastilleteController | insertarOportunidad() - QueryException: ' + e.getMessage());
            return null;
        }
        
 /* -------------------- PROMOCION ---------------------- */

        Promocion__c promocion = [SELECT Id, Name, Fin_comercializacion_prevista__c FROM Promocion__c WHERE Id =: promSel];
        system.debug('promocion:::'+promocion);
		
 /* -------------------- OPORTUNIDAD ---------------------- */
        Opportunity opportunityToInsert = new Opportunity();
        try{
        opportunityToInsert = new Opportunity(Name = promocion.Name + '-' + cuenta.Name, AccountId = cuenta.Id, CloseDate = promocion.Fin_comercializacion_prevista__c, 
                                                         StageName = 'Presupuesto', Promocion__c = promSel, Pricebook2Id = Utils.getStandarPriceBook() );
        }catch (System.QueryException e){
            System.debug('showCastilleteController | insertarOportunidad() - QueryException: ' + e.getMessage());
            return null;
        }
        
        try{
            system.debug('showCastilleteController | insertarOportunidad() - opportunityToInsert'+opportunityToInsert);
            insert opportunityToInsert; 
 
 /* -------------------- QUOTE ---------------------- */
            Quote presupuestoToInsert = new Quote(Name = promocion.Name + '-' + cuenta.Name, OpportunityId = opportunityToInsert.Id, Pricebook2Id = Utils.getStandarPriceBook());
            system.debug('showCastilleteController | insertarOportunidad() - presupuestoToInsert'+presupuestoToInsert);
            insert presupuestoToInsert;         
 
 /* -------------------- INMUEBLES ---------------------- */
            Id currentUsertId = UserInfo.getUserId();
            List<Product2> inmuebleSel = [SELECT Id, Name, Estado__c, UltimoModificadorEstado__c, Promocion__c, Precio__c, Tipo_de_inmueble__r.Tipo__c, Oportunidad__c 
                                          FROM Product2 
                                          WHERE Estado__c = 'Bloqueado Temporalmente' AND UltimoModificadorEstado__c =: UserInfo.getUserId().substring(0,15) AND Promocion__c =: promSel AND id =: activosSeleccionados ];
            system.debug('showCastilleteController | insertarOportunidad() - inmuebleSel:::'+inmuebleSel);
            system.debug('showCastilleteController | insertarOportunidad() - UserInfo.getUserId().substring(0,15):::'+UserInfo.getUserId().substring(0,15));
            system.debug('showCastilleteController | insertarOportunidad() - promSel:::'+promSel);
//////////////////////////////////////////////////////////////////
		
            if(!inmuebleSel.isEmpty()){
                List<Product2> inmueblesTotales = [SELECT Id, Name, Inmueble_asociado__c, Precio__c, Tipo_de_inmueble__r.Tipo__c, Oportunidad__c FROM Product2 WHERE Inmueble_asociado__c =:inmuebleSel[0].Id ];
                
                //Metemos tanto el inmueble principal como los asociados a la lista inmueblesTotales
                if(inmueblesTotales.size() != 0){
                    inmueblesTotales.add(0, inmuebleSel[0]);
                }else{
                    inmueblesTotales.add(inmuebleSel[0]);
                }
                    
                //Antes de crear el QuoteLineItem tenemos que ver cuales de ellos van sin precio. Esto es porque tanto la vivienda como sus anejos sin precio llevaran en campo Description
                //el nombre de la vivienda mas el nombre de sus anejos sin precio     
                String nombresConcatenados = '';
                for(Product2 inmueble: inmueblesTotales){
                    if((inmueble.Precio__c == null || inmueble.Precio__c == 0) && (inmueble.Tipo_de_inmueble__r.Tipo__c == 'Garaje' || inmueble.Tipo_de_inmueble__r.Tipo__c == 'Trastero')){
                        nombresConcatenados += ', ' + inmueble.Name;
                    }if(inmueble.Tipo_de_inmueble__r.Tipo__c == 'Vivienda'){
                        nombresConcatenados = inmueble.Name + nombresConcatenados;
                    }
                }            
            
 /* -------------------- PRODUCTOS PRESUPUESTO ---------------------- */
            //Una vez que se tiene el pricebook y la descripcion para los productos sin precio, creamos un producto de Presupuesto por cada inmueble y lo metemos a prodPresupuestoList  
            List<QuoteLineItem> prodPresupuestoList = new List<QuoteLineItem>(); 
            for(Product2 inmueble: inmueblesTotales){
                QuoteLineItem prodPresupuestoToInsert;
                if(inmueble.Precio__c == 0 || inmueble.Tipo_de_inmueble__r.Tipo__c == 'Vivienda'){
                    prodPresupuestoToInsert = new QuoteLineItem(QuoteId = presupuestoToInsert.Id, Quantity = 1, Product2Id = inmueble.Id, 
                                                                                     UnitPrice = inmueble.Precio__c, Description = nombresConcatenados.trim());
                }else if(inmueble.Precio__c == null){
                    prodPresupuestoToInsert = new QuoteLineItem(QuoteId = presupuestoToInsert.Id, Quantity = 1, Product2Id = inmueble.Id, 
                                                                                     UnitPrice = 0, Description = nombresConcatenados.trim());        
                }else{
                    prodPresupuestoToInsert = new QuoteLineItem(QuoteId = presupuestoToInsert.Id, Quantity = 1, Product2Id = inmueble.Id, 
                                                                                     UnitPrice = inmueble.Precio__c, Description = inmueble.Name);
                }  
                prodPresupuestoList.add(prodPresupuestoToInsert);
            }
            system.debug('prodPresupuestoList:::'+prodPresupuestoList);
            
            try{
    
            //intentamos insertar el producto de Presupuesto
            Database.SaveResult[] srList2 = Database.insert(prodPresupuestoList, true);
            // Iterate through each returned result
            for (Database.SaveResult sr : srList2) {
                if (sr.isSuccess()) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Los inmuebles se han añadido con éxito'));
                    System.debug('La insercion del Quote Line Item ha sido exitosa con ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ha habido un error al insertar los inmuebles: ' + err.getStatusCode() + ': ' + err.getMessage() ));
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                 }
             } 
    
             //si va bien, devolvemos el estado a Libre para que lo puedan meter en otras quotes
             try{
                String descripcion = '';
                for(Product2 inmueble : inmueblesTotales){
                    inmueble.Estado__c = 'Libre';
                    descripcion += inmueble.Name + ', ';
                }
                if(inmueblesTotales.size() > 1){
                    presupuestoToInsert.Description = 'Inmuebles ' +  descripcion.substring(0, descripcion.length() - 2);
                }else{
                    presupuestoToInsert.Description = 'Inmueble ' +  descripcion.substring(0, descripcion.length() - 2);
                }
                update inmueblesTotales;
                update presupuestoToInsert;
                try{
                    Participante__c participante = new Participante__c(Cliente__c = cuenta.Id, Name = cuenta.Name, Opportunity__c = opportunityToInsert.Id, Porcentaje_de_participacion__c = 100);
                    insert participante;
                }catch(System.DmlException e){
                    System.debug('showCastilleteController | insertarOportunidad() - DmlException: ' + e.getMessage());
                    return null;            
                }	 
            }catch(System.DmlException e){
            System.debug('showCastilleteController | insertarOportunidad() - DmlException: ' + e.getMessage());
            return null;            
            }
            }catch(System.DmlException e){
                System.debug('showCastilleteController | insertarOportunidad() - DmlException: ' + e.getMessage());
                return null;            
            }
            
        }    
            
     	}catch (System.DmlException e){
            System.debug('showCastilleteController | insertarOportunidad() - DmlException: ' + e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ha habido un error al crear la oportunidad: '+ e.getMessage() ));
            return null;
        }
        try{
            //PageReference retUrl = new PageReference('https://grupoavintia--despro.lightning.force.com/'+opportunityToInsert.Id);
            PageReference retUrl = new PageReference(dominio+opportunityToInsert.Id);
            retURL.setRedirect(true);
            return retURL;  
        }catch(System.NullPointerException e){
                System.debug('showCastilleteController | insertarOportunidad() - NullPointerException: ' + e.getMessage());
            	return null;    
        }
  

    }
    
/****************************************************************************************************
* Method Name: loadCastillete                                                                        *
* Description:  Abre la showCastillete mostrando el castillete asociado a la promocion elegida en el combo de la Tab castillete. *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/ 
    
    public PageReference loadCastillete(){
        PageReference retUrl = new PageReference('/apex/showCastillete?Id=' + promSel + '&paginaNueva=true');
        retURL.setRedirect(true);
        return retURL; 
    }

/****************************************************************************************************
* Method Name: buscarCliente                                                                        *
* Description: Busca el cliente asociado al dni introducido en el bloque Buscar Cliente del Castillete que se muestra en Promocion . *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/ 
    
    public PageReference buscarCliente(){
        
        String searchstring2 ='%'+searchstring+'%' ;
        system.debug('searchstring2:::'+searchstring2);
        searchstring2 = searchstring2.replaceAll('[ÀÁÂÃÄÅ]','A');
        searchstring2 = searchstring2.replaceAll('[àá]','a');
        searchstring2 = searchstring2.replaceAll('[ÈÉ]','E');
        searchstring2 = searchstring2.replaceAll('[èé]','e');
        searchstring2 = searchstring2.replaceAll('[ÌÍ]','I');
        searchstring2 = searchstring2.replaceAll('[ìí]','i');
        searchstring2 = searchstring2.replaceAll('[ÒÓ]','O');
        searchstring2 = searchstring2.replaceAll('[òó]','o');
        searchstring2 = searchstring2.replaceAll('[ÙÚ]','U');
        searchstring2 = searchstring2.replaceAll('[ùú]','u');
        
        if(searchstring != ''){
            acc = [SELECT Id, Name, Email__c, PersonEmail, Movil_empresa__c, PersonMobilePhone, N_Documento__c 
                   FROM Account 
                   WHERE Name LIKE: searchstring2 OR N_Documento__c = : searchstring];
            system.debug('showCastilleteController | buscarCliente - acc:::'+acc);            
        }
        return null;
    }    
    
/****************************************************************************************************
* Method Name: getItems                                                                        *
* Description:  Recupera las cuentas asociadas al input de Buscar Cliente en Promocion, para mostrarlas como un radio button seleccionable . *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/ 
    
    public List<SelectOption> getItems() {
       accSelected = null;
       List<SelectOption> options = new List<SelectOption>();
       if(acc != null){
           for (Account cuenta : acc){
               options.add(new SelectOption(cuenta.Id,cuenta.Name));   
           } 
       
       system.debug('showCastilleteController | getItems - accSelected:::'+accSelected);
       system.debug('showCastilleteController | getItems - options:::'+options);
       }
	return options;
    }
    
/****************************************************************************************************
* Method Name: getProm                                                                              *
* Description: Recupera las promociones que existen para mostrar en el combo de la Tab Castillete . *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/  
    
    public List<SelectOption> getProm() {
        Map<Id, Promocion__c> lpromociones =  new Map<Id, Promocion__c>([SELECT id, name FROM Promocion__c LIMIT 100]);
        List<SelectOption> options = new List<SelectOption>();
        Map<Id, UserRecordAccess> perms = new Map<Id, UserRecordAccess>([SELECT HasReadAccess, RecordId FROM UserRecordAccess WHERE RecordId = :lpromociones.keyset() AND UserId = :UserInfo.getUserId()]);

        for(UserRecordAccess ura : perms.values()) {
            if(ura.HasReadAccess){
                Promocion__c promocion = lpromociones.get(ura.RecordId);
                options.add(new SelectOption(promocion.Id, promocion.Name));
            }
        } 

        System.debug('++++++++++++++++++++');
        System.debug(lpromociones.size());
        System.debug(options.size());
        System.debug('--------------------');

        /*List<Promocion__c> lpromociones =  new List<Promocion__c>([SELECT id, name FROM Promocion__c LIMIT 100]);
        List<SelectOption> options = new List<SelectOption>();
        for(Promocion__c promocion : lpromociones) {
            options.add(new SelectOption(promocion.Id, promocion.Name));
        }*/
        
        return options;
    }  
    
/****************************************************************************************************
* Method Name: getTipoInmueble                                                                              *
* Description: Recupera los tipos de inmueble que existen para mostrar en el combo de la Tab Castillete . *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/  
    
    public List<SelectOption> getTipoInmueble(){
    	List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Tipo_de_inmueble__c.Tipo__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
        system.debug('showCastilleteController | getTipoInmueble - options:::'+options);
        return options;
    }

/****************************************************************************************************
* Method Name: getParcela                                                                              *
* Description: Recupera las parcelas que existen para mostrar en el combo del Castillete . *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/  
    
    public List<SelectOption> getParcela(){
		List<Product2> inmueblesList =[Select Parcela__c, Portal__c, Bloque__c, Promocion__c, Oportunidad__c from Product2 where Promocion__c=:promSel];
        system.debug('showCastilleteController | getParcela - inmueblesList:::'+inmueblesList);
        
        //Metemos en una lista las distintas parcelas que hay
        Set<String> parcelasSet = new Set<String>();
        for (Product2 inmueble: inmueblesList) {
            if(inmueble.Parcela__c != null){
            	parcelasSet.add(inmueble.Parcela__c);                
            }
        }        
        
        List<SelectOption> optionsParcela = new List<SelectOption>();
        system.debug('showCastilleteController | getParcela - parcelasSet:::'+parcelasSet);          
        List<String> parcelasList = new List<String>(parcelasSet);
        
        if(parcelasList.size() == 1){
            parcelaSel = parcelasList[0];
        }else{
        for(String parcela : parcelasList){
                optionsParcela.add(new SelectOption(parcela, parcela));
            }            
        }
        system.debug('showCastilleteController | getParcela - optionsParcela:::'+optionsParcela);
        return optionsParcela;

 	}

/****************************************************************************************************
* Method Name: getBloque                                                                              *
* Description: Recupera las parcelas que existen para mostrar en el combo del Castillete . *
* Author: Deloitte                                                                                  *
* **************************************************************************************************/  
    
    public List<SelectOption> getBloque(){
        //Metemos en una lista de opciones los bloques que hay
        List<Product2> inmueblesPorParcelaList =[Select Parcela__c, Portal__c, Bloque__c, Promocion__c, Oportunidad__c from Product2 where Promocion__c=:promSel AND Parcela__c =: parcelaSel];
        system.debug('showCastilleteController | getBloque - inmueblesPorParcelaList:::'+inmueblesPorParcelaList);
        
        //Metemos en una lista las distintas parcelas que hay
        Set<String> bloquesSet = new Set<String>();
        for (Product2 inmueble: inmueblesPorParcelaList) {
            if(inmueble.Bloque__c != null){
                bloquesSet.add(inmueble.Bloque__c);                
            }
        }        

        List<SelectOption> optionsBloque = new List<SelectOption>();
        system.debug('showCastilleteController | getBloque - bloquesSet:::'+bloquesSet);        
        List<String> bloquesList = new List<String>(bloquesSet);
        
        if(bloquesList.size() == 1){
            bloqueSel = bloquesList[0];
        }else{
        	for(String bloque : bloquesList){
                optionsBloque.add(new SelectOption(String.valueOf(bloque), String.valueOf(bloque)));
            	//bloqueSel = bloquesList[0];
            }
		} 
        system.debug('showCastilleteController | getBloque - bloqueSel:::'+bloqueSel);
        system.debug('showCastilleteController | getBloque - optionsBloque:::'+optionsBloque);
        return optionsBloque;

 	}
    
}