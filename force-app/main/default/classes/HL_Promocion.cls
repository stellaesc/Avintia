public class HL_Promocion {

    public static void AfterInsert(Map<id, Promocion__c> newMap, List<Promocion__c> newVar){
        CrearRitmoVentas(newMap);
        createSharePointDirsAfterInsertContext(newVar);
    }
    
    public static void AfterUpdate(Map<id, Promocion__c> newMap, Map<id, Promocion__c> oldMap, List<Promocion__c> newVar){
        ModificarRitmoVentas(newMap, oldMap);
        createSharePointDirsAfterModifyContext(newVar);
        updateContentDocumentMarketing(Trigger.new, Trigger.old);
        
    }

/********************* Métodos auxiliares *****************/  
    
    private static void CrearRitmoVentas(Map<id, Promocion__c> newMap){
        
		map<integer, Ritmo_ventas__c> MapRitmoVentas = new map<integer, Ritmo_ventas__c>();
        
        Integer semanaInicio;
        Integer semanaFin;

        Integer NumSemanas;
        
        for(Id pro : newMap.keyset()){
            

            semanaInicio = getNumeroSemana(newMap.get(pro).Inicio_comercializacion_prevista__c);
            /*system.debug('FECHA INICIO '+newMap.get(pro).Inicio_comercializacion_prevista__c);
            system.debug('SEMANA INICIO '+semanaInicio);*/
            
            semanaFin = getNumeroSemana(newMap.get(pro).fin_comercializacion_prevista__c);
            /*system.debug('FECHA FIN '+newMap.get(pro).fin_comercializacion_prevista__c);
            system.debug('SEMANA FIN '+semanaFin);*/
            
            NumSemanas = (newMap.get(pro).Inicio_comercializacion_prevista__c.toStartOfWeek().daysBetween(newMap.get(pro).fin_comercializacion_prevista__c.toStartOfWeek()))/7; 
            
			integer contador = 0;
            Date fechaInicioSemana = newMap.get(pro).Inicio_comercializacion_prevista__c.toStartOfWeek();
            
            
            for(integer i = 0; i <= NumSemanas; i++){
                

                Ritmo_ventas__c ritmoVentas = new Ritmo_ventas__c();
                ritmoVentas.promocion__c = pro;
                
                //Primera semana
                if(contador == 0){
                    
                    ritmoVentas.Fecha_inicio_periodo__c = newMap.get(pro).Inicio_comercializacion_prevista__c;
                    
                    //Si es la misma semana
                    if(newMap.get(pro).Inicio_comercializacion_prevista__c.toStartOfWeek() == newMap.get(pro).fin_comercializacion_prevista__c.toStartOfWeek()){
                        
                        ritmoVentas.Fecha_fin_periodo__c = newMap.get(pro).fin_comercializacion_prevista__c;
                    }
                    else{
                        
                        ritmoVentas.Fecha_fin_periodo__c = fechaInicioSemana.addDays(6);
                    }
                    
                    ritmoVentas.N_semana__c = getNumeroSemana(newMap.get(pro).Inicio_comercializacion_prevista__c);
                    ritmoVentas.N_Viviendas_previstas_venta__c = newMap.get(pro).N_Unidades_iniciales_ritmo_de_ventas__c;
                    ritmoVentas.Importe_viviendas_previstas_venta__c = newMap.get(pro).Importe_de_ventas__c;
 
                }
                else{

                    ritmoVentas.N_semana__c = getNumeroSemana(newMap.get(pro).Inicio_comercializacion_prevista__c.addDays(7*contador));
                    
                    ritmoVentas.Fecha_inicio_periodo__c = fechaInicioSemana.addDays(7*contador);
                    ritmoVentas.N_Viviendas_previstas_venta__c = newMap.get(pro).ritmo_de_ventas__c;
                    ritmoVentas.Importe_viviendas_previstas_venta__c = newMap.get(pro).Importe_de_ventas__c;
                    
                    
                    if(fechaInicioSemana.addDays((7*contador)+6)< newMap.get(pro).fin_comercializacion_prevista__c){
                        
                        ritmoVentas.Fecha_fin_periodo__c = fechaInicioSemana.addDays((7*contador)+6);
                        
                    }
                    else{

                    	ritmoVentas.Fecha_fin_periodo__c = newMap.get(pro).fin_comercializacion_prevista__c;
                    }   
                }
             	//Limita el tamaño del nombre de la promoción para no exceder el límite de 80 caracteres en el campo name.
                ritmoVentas.name =  ritmoVentas.N_semana__c + ' '+ ritmoVentas.Fecha_inicio_periodo__c.year();
                MapRitmoVentas.put(contador,ritmoVentas);
                contador += 1;
            }   
        }
        insert MapRitmoVentas.values();
    }
    
    
    private static void ModificarRitmoVentas(Map<id, Promocion__c> newMap, Map<id, Promocion__c> oldMap){
        
        
        set<id> setPromociones = new Set<id>();
        set<id> setRitmosABorrar = new Set<id>();
        
        List<ritmo_ventas__c> ListRitmosABorrar = new  List<ritmo_ventas__c>();
        List<ritmo_ventas__c> ListRitmosACrear = new  List<ritmo_ventas__c>();
        
        
        //Se almacenan los IDs de las promociones modificadas en un conjunto
        for(id pro : newMap.keyset()){
            
            setPromociones.add(pro);
        }
        
        //Se obtienen los ritmos de ventas de las promociones modificadas
        map<id, Ritmo_ventas__c> MapRitmoVentas = new map<id, Ritmo_ventas__c>(
            [SELECT id, name,Fecha_inicio_periodo__c, Fecha_fin_periodo__c, N_semana__c, promocion__c 
             FROM Ritmo_ventas__c WHERE promocion__c IN : setPromociones]);
        

        Integer contador = 0;
        Integer NumSemanas;
        
        
        for(Id pro : newMap.keyset()){
            
            Date fechaInicioSemana = newMap.get(pro).Inicio_comercializacion_prevista__c.toStartOfWeek();
            
            NumSemanas = (newMap.get(pro).Inicio_comercializacion_prevista__c.toStartOfWeek().daysBetween(newMap.get(pro).fin_comercializacion_prevista__c))/7;
            
            
            //Si cambia la fecha de inicio de comercialización prevista 
            if(newMap.get(pro).Inicio_comercializacion_prevista__c != oldMap.get(pro).Inicio_comercializacion_prevista__c ){
                
                //Si se atrasa (+ tiempo)
                if(newMap.get(pro).Inicio_comercializacion_prevista__c > oldMap.get(pro).Inicio_comercializacion_prevista__c){
                    						System.debug('SE ATRASA LA FECHA DE INICIO DE COMERCIALZIACION');
                    
           
                    for(id rit : MapRitmoVentas.keyset()){
                        
                        if(MapRitmoVentas.get(rit).promocion__c == pro){
                            
                            if(MapRitmoVentas.get(rit).Fecha_inicio_periodo__c.toStartOfWeek() < newMap.get(pro).Inicio_comercializacion_prevista__c.toStartOfWeek()){
                                
                                setRitmosABorrar.add(rit);
                            }    
                            //Si es la misma semana
                            else if(MapRitmoVentas.get(rit).Fecha_inicio_periodo__c.toStartOfWeek() == newMap.get(pro).Inicio_comercializacion_prevista__c.toStartOfWeek()){
                                					System.debug('SE ADELANTA DENTRO DE LA MISMA SEMANA');
                               MapRitmoVentas.get(rit).Fecha_inicio_periodo__c = newMap.get(pro).Inicio_comercializacion_prevista__c;
                                
                            }
                        }
                	}//Fin for ritmoVentas
                }
                //Si se adelanta
                else{
                    									System.debug('SE ADELANTA LA FECHA DE INICIO DE COMERCIALIZACION');
                    for(id rit : MapRitmoVentas.keyset()){
                        
                        if(MapRitmoVentas.get(rit).promocion__c == pro){
                            
                            //Si se atrasa en la misma semana
                            if(MapRitmoVentas.get(rit).Fecha_inicio_periodo__c.toStartOfWeek() == newMap.get(pro).Inicio_comercializacion_prevista__c.toStartOfWeek()){
                                					System.debug('SE adelanta DENTRO DE LA MISMA SEMANA');
                               MapRitmoVentas.get(rit).Fecha_inicio_periodo__c = newMap.get(pro).Inicio_comercializacion_prevista__c;
                            }
                            
                            //El registro que tenía la primera semana debe cambiar su fecha de inicio de periodo al lunes anterior
                            else if(MapRitmoVentas.get(rit).Fecha_inicio_periodo__c.toStartOfWeek() == oldMap.get(pro).Inicio_comercializacion_prevista__c.toStartOfWeek()){
                                
                                MapRitmoVentas.get(rit).Fecha_inicio_periodo__c = MapRitmoVentas.get(rit).fecha_Inicio_Periodo__c.toStartofWeek();
                                
                            }
                        }
                	}//Fin for ritmoVentas
                    
                   Integer SemanasAtraso = newMap.get(pro).Inicio_comercializacion_prevista__c.daysbetween(oldMap.get(pro).Inicio_comercializacion_prevista__c)/7;
         
                    
                    //Se crean los ritmos de ventas nuevos
                            for(integer i = 0; i < SemanasAtraso; i++){
                                system.debug('semana atraso '+i);
                                Ritmo_ventas__c ritmoVentas = new Ritmo_ventas__c();
                                ritmoVentas.promocion__c = pro;
                                
                                if(contador == 0){
                                    
                                    ritmoVentas.Fecha_inicio_periodo__c = newMap.get(pro).Inicio_comercializacion_prevista__c;
                                    ritmoVentas.Fecha_fin_periodo__c = fechaInicioSemana.addDays(6);
                                    ritmoVentas.N_semana__c = getNumeroSemana(newMap.get(pro).Inicio_comercializacion_prevista__c);
                                    ritmoVentas.N_Viviendas_previstas_venta__c = newMap.get(pro).N_Unidades_iniciales_ritmo_de_ventas__c;
                                }
                                else{
                                    
                                    ritmoVentas.Fecha_inicio_periodo__c = fechaInicioSemana.addDays(7*contador);
                                    ritmoVentas.Fecha_fin_periodo__c = ritmoVentas.Fecha_inicio_periodo__c.addDays(6);
                                    ritmoVentas.N_semana__c = i;
   
                                }
                                ritmoVentas.name =  ritmoVentas.N_semana__c + ' '+ ritmoVentas.Fecha_inicio_periodo__c.year();
                                contador += 1;
                                ListRitmosACrear.add(ritmoVentas);
                                
                                
                            }//Fin for Ritmos de ventas nuevos
                }
                contador = 0;
 
    		}//Fin if cambia fecha comercialización prevista
            
            
            
            //Si cambia la fecha de fin de comercialización prevista
            if(newMap.get(pro).Fin_comercializacion_prevista__c != oldMap.get(pro).Fin_comercializacion_prevista__c ){
                
                 //Si es antes de lo previsto
                if(newMap.get(pro).fin_comercializacion_prevista__c < oldMap.get(pro).fin_comercializacion_prevista__c){
                    						
                    for(id rit : MapRitmoVentas.keyset()){
                        
                        if(MapRitmoVentas.get(rit).promocion__c == pro){
                            if(MapRitmoVentas.get(rit).Fecha_inicio_periodo__c.toStartOfWeek() > newMap.get(pro).fin_comercializacion_prevista__c.toStartOfWeek()){
                                
                                setRitmosABorrar.add(rit);
                            }    
                            //Si es la misma semana
                            else if(MapRitmoVentas.get(rit).Fecha_fin_periodo__c.toStartOfWeek() == newMap.get(pro).fin_comercializacion_prevista__c.toStartOfWeek() ){
                                					System.debug('SE ADELANTA DENTRO DE LA MISMA SEMANA');
                               MapRitmoVentas.get(rit).Fecha_fin_periodo__c = newMap.get(pro).fin_comercializacion_prevista__c;
                                
                            }
                            
                        }
                	}//Fin for ritmoVentas
                }
                //Si es despues de lo previsto
                else if(newMap.get(pro).fin_comercializacion_prevista__c > oldMap.get(pro).fin_comercializacion_prevista__c){
                    
                    System.debug('Es despues de lo previsto');
                    
                    for(id rit : MapRitmoVentas.keyset()){
                        
                        if(MapRitmoVentas.get(rit).promocion__c == pro){
                            if(MapRitmoVentas.get(rit).Fecha_fin_periodo__c.toStartOfWeek() == newMap.get(pro).fin_comercializacion_prevista__c.toStartOfWeek() ){
                                					System.debug('SE ATRASA DENTRO DE LA MISMA SEMANA');
                               MapRitmoVentas.get(rit).Fecha_fin_periodo__c = newMap.get(pro).fin_comercializacion_prevista__c;
                            }
                            
                            //El registro que tenía la última semana debe cambiar su fecha de fin de periodo al Domingo siguiente
                           else if(MapRitmoVentas.get(rit).Fecha_fin_periodo__c.toStartOfWeek() == oldMap.get(pro).fin_comercializacion_prevista__c.toStartOfWeek()){
                                
                                MapRitmoVentas.get(rit).Fecha_fin_periodo__c = MapRitmoVentas.get(rit).fecha_Inicio_Periodo__c.toStartofWeek().addDays(6);
                                
                            }
                        }
                	}//Fin for ritmoVentas
                    
                    contador=1;
                    Date fechaFinOld = oldMap.get(pro).fin_comercializacion_prevista__c.toStartofWeek();
                    Integer SemanasAtraso = oldMap.get(pro).fin_comercializacion_prevista__c.daysbetween(newMap.get(pro).fin_comercializacion_prevista__c)/7;
                    							
                    //Se crean los ritmos de ventas nuevos
                            for(integer i = 0; i < SemanasAtraso; i++){
                                						
                                Ritmo_ventas__c ritmoVentas = new Ritmo_ventas__c();
                                
                                ritmoVentas.promocion__c = pro;
                                ritmoVentas.Fecha_inicio_periodo__c = fechaFinOld.addDays(7*contador);
                                ritmoVentas.N_semana__c = getNumeroSemana(ritmoVentas.Fecha_inicio_periodo__c);
   
                                if(i == SemanasAtraso-1){
                                    
                                    ritmoVentas.Fecha_fin_periodo__c = newMap.get(pro).fin_comercializacion_prevista__c;
                                }
                                else{
                                    ritmoVentas.Fecha_fin_periodo__c = ritmoVentas.Fecha_inicio_periodo__c.addDays(6);
                                }
                                
                                ritmoVentas.name =  ritmoVentas.N_semana__c + ' '+ ritmoVentas.Fecha_fin_periodo__c.year();
								contador += 1;
                                ListRitmosACrear.add(ritmoVentas);
                                
                                
                            }//Fin for Ritmos de ventas nuevos
                }
  
            }
    	}//Fin for
        

        for(id rit : MapRitmoVentas.keyset()){
            
            if(setRitmosABorrar.contains(rit)){
                
                ListRitmosABorrar.add(MapRitmoVentas.get(rit));
            }
        }
        
        insert ListRitmosACrear;
        update MapRitmoVentas.values();
        delete ListRitmosABorrar;
    }
    
    
    private static void createSharePointDirsAfterModifyContext(List<Promocion__c> newVar) {
        List<String> foldersList = new List<String>();
        List<AggregateResult> results = [SELECT ParentDirectoryName__c  FROM DocumentCategory__c WHERE ParentDirectoryName__c != '' GROUP BY ParentDirectoryName__c];
        for(AggregateResult r : results) {
            foldersList.add((String) r.get('ParentDirectoryName__c'));
        }

        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        String parentDir = spCustomSettings.spParentDir__c;
        String baseDirPath = spCustomSettings.spSiteUrl__c;
        baseDirPath = baseDirPath != null ? spCustomSettings.spSiteUrl__c.replace(spCustomSettings.spSiteDomain__c, '') : '';

        if(spCustomSettings.spModifyPromotionTrigger__c && !Test.isRunningTest()) {
            for(Promocion__c promocion : newVar) {
                String parentDirPath = baseDirPath + parentDir + '/' + promocion.Name;
                FutureSharePointConnector.createFolders(parentDirPath, foldersList);
            }
        }
    }

    private static void createSharePointDirsAfterInsertContext(List<Promocion__c> newVar) {
        List<String> foldersList = new List<String>();
        List<AggregateResult> results = [SELECT ParentDirectoryName__c  FROM DocumentCategory__c WHERE ParentDirectoryName__c != '' GROUP BY ParentDirectoryName__c];
        for(AggregateResult r : results) {
            foldersList.add((String) r.get('ParentDirectoryName__c'));
        }

        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        String parentDir = spCustomSettings.spParentDir__c;
        String baseDirPath = spCustomSettings.spSiteUrl__c;
        baseDirPath = baseDirPath != null ? spCustomSettings.spSiteUrl__c.replace(spCustomSettings.spSiteDomain__c, '') : '';

        for(Promocion__c promocion : newVar) {
            if(!Test.isRunningTest()) {
                String parentDirPath = baseDirPath + parentDir + '/' + promocion.Name;
                FutureSharePointConnector.createFolders(parentDirPath, foldersList);
            }
        }
    }
    
    //Formula para obtener el número de la semana de una fecha concreta
    private static integer getNumeroSemana(Date fecha){
        Date fechaAux = date.newInstance(fecha.year(), 01, 01);
        integer diasTrancurridos = fechaAux.daysBetween(fecha);
        return math.mod(math.floor(diasTrancurridos/7).intValue(), 52)+1;
    }
    
    public static void updateContentDocumentMarketing(List<Promocion__c> promocionNew, List<Promocion__c> promocionOld) {
        List<Id> promocionIdList = new List<Id>();
        Map<Id, Id> mapOldUserNewUser = new Map<Id, Id>();
        for(Integer i = 0; i < promocionNew.size(); i++){
            if(promocionOld[i].Marketing__c != promocionNew[i].Marketing__c){
                mapOldUserNewUser.put(promocionOld[i].Marketing__c, promocionNew[i].Marketing__c);
                promocionIdList.add(promocionOld[i].Id);
            }
            if(promocionOld[i].Director_Comercial__c != promocionNew[i].Director_Comercial__c){
                mapOldUserNewUser.put(promocionOld[i].Director_Comercial__c, promocionNew[i].Director_Comercial__c);
                promocionIdList.add(promocionOld[i].Id);
            }
            if(promocionOld[i].Director_Negocio__c != promocionNew[i].Director_Negocio__c){
                mapOldUserNewUser.put(promocionOld[i].Director_Negocio__c, promocionNew[i].Director_Negocio__c);
                promocionIdList.add(promocionOld[i].Id);
            }
            if(promocionOld[i].Director_Promociones__c != promocionNew[i].Director_Promociones__c){
                mapOldUserNewUser.put(promocionOld[i].Director_Promociones__c, promocionNew[i].Director_Promociones__c);
                promocionIdList.add(promocionOld[i].Id);
            }
            if(promocionOld[i].Tecnico__c != promocionNew[i].Tecnico__c){
                mapOldUserNewUser.put(promocionOld[i].Tecnico__c, promocionNew[i].Tecnico__c);
                promocionIdList.add(promocionOld[i].Id);
            }
            if(promocionOld[i].Responsable_Comercial__c != promocionNew[i].Responsable_Comercial__c){
                mapOldUserNewUser.put(promocionOld[i].Responsable_Comercial__c, promocionNew[i].Responsable_Comercial__c);
                promocionIdList.add(promocionOld[i].Id);
            }
            if(promocionOld[i].Tecnico_Aprobador__c != promocionNew[i].Tecnico_Aprobador__c){
                mapOldUserNewUser.put(promocionOld[i].Tecnico_Aprobador__c, promocionNew[i].Tecnico_Aprobador__c);
                promocionIdList.add(promocionOld[i].Id);
            }
        }
        
        if(promocionIdList.size() > 0){
            List<ContentDocumentLink> cdlPromocionList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN: promocionIdList];
             
            Set<Id> contentDocumentIdList = new Set<Id>();
            for(ContentDocumentLink contentDocumentLink : cdlPromocionList)
                contentDocumentIdList.add(contentDocumentLink.ContentDocumentId);
            
            if(!cdlPromocionList.isEmpty()) {
                List<ContentDocumentLink> cdlContentDocumentList = [SELECT ContentDocumentId, LinkedEntityId, ShareType FROM ContentDocumentLink WHERE ContentDocumentId IN: contentDocumentIdList];
                
                Set<Id> linkedUsers = new Set<Id>();
                for(ContentDocumentLink cdl : cdlContentDocumentList)
                    if(cdl.LinkedEntityId.getSObjectType() == Schema.User.getsObjectType() && !linkedUsers.contains(cdl.LinkedEntityId)) linkedUsers.add(cdl.LinkedEntityId);

                List<ContentDocumentLink> cdlToInsert = new List<ContentDocumentLink>();
                List<ContentDocumentLink> cdlToDelete = new List<ContentDocumentLink>();
                
                for(ContentDocumentLink cdlContentDocument : cdlContentDocumentList){
                    if(mapOldUserNewUser.keySet().contains(cdlContentDocument.LinkedEntityId) && cdlContentDocument.ShareType == 'C'){
                        if(mapOldUserNewUser.get(cdlContentDocument.LinkedEntityId) != null){
                            ContentDocumentLink contentDocumentLinkAux = new ContentDocumentLink();
                            contentDocumentLinkAux.LinkedEntityId = mapOldUserNewUser.get(cdlContentDocument.LinkedEntityId); 
                            contentDocumentLinkAux.ContentDocumentId = cdlContentDocument.ContentDocumentId;
                            contentDocumentLinkAux.ShareType = 'C';
                            if(!linkedUsers.contains(contentDocumentLinkAux.LinkedEntityId)) cdlToInsert.add(contentDocumentLinkAux);
                        }
                        cdlToDelete.add(cdlContentDocument);
                    }
                }
                
                if(!cdlToInsert.isEmpty()) insert cdlToInsert;
                if(!cdlToDelete.isEmpty()) delete cdlToDelete;
            }            
        }


    }

    
}