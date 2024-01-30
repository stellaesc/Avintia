public with sharing class GeneradorPDFMejorasController {

    private final Opportunity opp;
    public static List<WrapperMejorasElement2> lWrapperMejorasNivel = new List<WrapperMejorasElement2>();
    // Related Improvement Records
    private final List<MejoraOportunidad__c> lImpOpp;
    private final List<Mejora__c> lImpTipoInmueble;
    private final List<OpportunityLineItem> lstOppLI;
    private final List<MejorasViviendas__c> lImpVivienda;
    private final List<Mejora__c> lImp;
    private final List<WrapperMejorasElement> lMejorasParsed = new List<WrapperMejorasElement>();
    public Id oppAux{get; set;}
    private Map<Id,List<WrapperMejorasElement>> mejorasMappedByMejoraHoja = new Map<Id,List<WrapperMejorasElement>>();
    public Map<Id,List<WrapperMejorasElement2>> mejorasMappedByMejoraHoja2;
    public static List<List<WrapperMejorasElement2>> lstLstMejoras{GET;SET;}
    public Promocion__c promocion{get;set;}
    public String FormaPagoMejoras{get;set;}
    public StaticResource sr {get;set;}
    private Map<Id, Mejora__c> mapImpIds;
    public GeneradorPDFMejorasController(){
        
        mejorasMappedByMejoraHoja2 = new Map<Id,List<WrapperMejorasElement2>>();
        //Opportunity oppAux = (Opportunity)stdController.getRecord();
        oppAux= ApexPages.CurrentPage().getParameters().get('id');
        this.opp = [Select Id, Promocion__c, FormaPagoMejoras__c from Opportunity where Id = :oppAux limit 1];
        this.FormaPagoMejoras = this.opp.FormaPagoMejoras__c;
        this.lstOppLI = [SELECT Product2.Tipo_de_inmueble__c FROM OpportunityLineItem where OpportunityId = :this.opp.Id AND Product2.Tipologia_Vivienda_Garaje_Trastero_Local__c = 'Vivienda'];
        System.debug('setTipoInmueble :: '+this.lstOppLI);
        Set<Id> setTipoInmueble = new Set<Id>();
        for(OpportunityLineItem o: this.lstOppLI){
            setTipoInmueble.add(o.Product2.Tipo_de_inmueble__c);
        }
        this.lImpTipoInmueble = [SELECT Id, MejoraPadre__c, Precio__c, DescripcionMejora__c, Name FROM Mejora__c WHERE ID IN(Select Mejora__c from MejorasTiposInmueble__c where TipoInmueble__c IN :setTipoInmueble AND Mejora__r.FechaLimiteContratacion__c > TODAY AND Mejora__r.Activa__c=TRUE)];
        System.debug('query lImpTipoInmueble :: '+This.lImpTipoInmueble);
        List<String> lstIdPadre = new List<String>();
        List<String> lstImpVivienda = new List<String>();
        for(Mejora__c mi: this.lImpTipoInmueble){
            lstIdPadre.add(mi.MejoraPadre__c);
            
        }
        
        this.lImpVivienda = [SELECT Mejora__r.Id, Mejora__r.MejoraPadre__c, Precio__c, Mejora__r.DescripcionMejora__c, Mejora__r.Name from MejorasViviendas__c where Vivienda__c IN (SELECT Product2Id FROM OpportunityLineItem where OpportunityId = :this.opp.Id AND Product2.Tipologia_Vivienda_Garaje_Trastero_Local__c = 'Vivienda')AND Mejora__r.FechaLimiteContratacion__c > TODAY AND Mejora__r.Activa__c=TRUE];
        System.debug('query lImpVivienda :: '+this.lImpVivienda);
        for(MejorasViviendas__c mi: this.lImpVivienda){
            lstIdPadre.add(mi.Mejora__r.MejoraPadre__c);
            lstImpVivienda.add(mi.Mejora__c);
        }
        
        System.debug('lstImpVivienda : '+lstImpVivienda);
        this.lImp = [SELECT Id, MejoraPadre__c, Precio__c, DescripcionMejora__c, Name from Mejora__c where Promocion__c = :this.opp.Promocion__c AND ((MejoraPadre__c=NULL AND Id IN :lstIdPadre) OR Id IN :lstImpVivienda)];        
        for(Mejora__c m: this.lImp){
            for(MejorasViviendas__c mi: this.lImpVivienda){
                if(m.Id == mi.Mejora__c){
                    system.debug('precio :: '+mi.Precio__c);
                    m.Precio__c = mi.Precio__c;
                }
            }
        }
        system.debug('TEST CONTENT MAP 1 : ' + this.lImp);
        Promocion__c promo = [SELECT Tipo_via__c, Nombre_via__c, Id, Name, Provincia__c, Localidad__r.Name, N_Via__c, Comercializa__c FROM Promocion__c WHERE Id = :this.opp.Promocion__c LIMIT 1];
        System.debug('lImpTipoInmueble : '+lImpTipoInmueble);
        system.debug('promo ' + promo);
        List<MejorasTiposInmueble__c> auxLstTipoInmueble = [Select Precio__c, Mejora__c from MejorasTiposInmueble__c where Mejora__c IN :lImpTipoInmueble]; 
        this.promocion = promo;
        system.debug('auxLstTipoInmueble :: '+auxLstTipoInmueble);
        for(Mejora__c m: this.lImpTipoInmueble){
            for(MejorasTiposInmueble__c mi: auxLstTipoInmueble){
                if(m.Id == mi.Mejora__c){
                    system.debug('precio :: '+mi.Precio__c);
                    m.Precio__c = mi.Precio__c;
                }
            }
        }
        for(Mejora__c m: this.lImpTipoInmueble){
            if(!this.lImp.contains(m)){
                this.lImp.add(m);
            }
        }
        try{
            sr= [SELECT Id, Body FROM StaticResource WHERE Name = :promocion.Name.replace(' ','').replace(',','').replace('.','') LIMIT 1];
        }catch(Exception e){
            system.debug('error : '+e.getMessage());
        }
            
            
        mapImpIds = new Map<Id, Mejora__c>(this.lImp);
        for(Id key: mapImpIds.keySet()){
            this.enterRecIterate2(mapImpIds.get(key).Id);
        }
        
        for(Id key :mejorasMappedByMejoraHoja2.keySet()){
            system.debug('TEST CONTENT MAP 3 : ' + key + ' - ' + mejorasMappedByMejoraHoja2.get(key));
        }
        System.debug('test : '+test);
        for(Id key: mejorasMappedByMejoraHoja2.keySet()){
            for(WrapperMejorasElement2 t: mejorasMappedByMejoraHoja2.get(key)){
                for(Id key2: mejorasMappedByMejoraHoja2.keySet()){
                    
                    if(t.IdPadre!=null 
                    && test.get(key2) != null
                    && test.get(key2).contains(t.IdPadre) 
                    && mejorasMappedByMejoraHoja2.get(key)!= null
                    && mejorasMappedByMejoraHoja2.get(key).size()==1 
                    ){
                    
                        System.debug('test.get(key) : '+test.get(key2));
                        System.debug('entra t : '+t);
                        List<String> padreId = getKey(test, key).split('-');
                        t.nivel=2;
                        System.debug('posicion hijo : '+padreId[1]);
                        System.debug(mejorasMappedByMejoraHoja2.get(key2).size());
                        if(Integer.valueOf(padreId[1])!=mejorasMappedByMejoraHoja2.get(key2).size()-1){
                            mejorasMappedByMejoraHoja2.get(key2).add(Integer.valueOf(padreId[1])+1, t);
                        }else{
                            mejorasMappedByMejoraHoja2.get(key2).add(t);
                        }
                        test.remove(t.IdPadre);
                        mejorasMappedByMejoraHoja2.remove(t.IdPadre);
                    } 
                }
                 
            }
            
        }
        List<List<WrapperMejorasElement2>> lstLstMejoras2 = new List<List<WrapperMejorasElement2>>();
        Integer contadorFamilia = 1;
        for(Id key :mejorasMappedByMejoraHoja2.keySet()){
            system.debug('TEST CONTENT MAP 4 : ' + key + ' - ' + mejorasMappedByMejoraHoja2.get(key));
            lstLstMejoras2.add(mejorasMappedByMejoraHoja2.get(key));
            Double contador = 0;
            for(WrapperMejorasElement2 e: mejorasMappedByMejoraHoja2.get(key)){
                Double contador2 = 0.0;
                if(e.IdPadre != key){
                    contador2 = contador2 + 0.1;
                    e.Indice = contador + contador2; 
                }else{
                    contador++;
                    contador2 = 1;
                    e.Indice = contador; 
                }
                e.contadorFamilia='OPO'+contadorFamilia;
            }
            contadorFamilia++;
        }
        lstLstMejoras = lstLstMejoras2;
    }

    Boolean listContains(Object[] source, Object target) {
        return (new Set<Object>(source)).contains(target);
    }

    private static String getKey(Map<Id, List<String>> test, String id){
        for(Id key: test.keySet()){
            if(test.get(key).contains(id) && key != id){
                return key+'-'+test.get(key).indexOf(id);
            }
        }
        return null;
    }
 
    public class WrapperMejorasElement{
        String DescripcionMejora;
        Decimal Precio;
        String Name;
        Integer Nivel;
        Boolean Tabulacion;
        Boolean NodoOrigen;
    }
    public class WrapperMejorasElement2{
        public Id Id {get;set;}
        public Id IdPadre {get;set;}
        public String DescripcionMejora {get;set;}
        public Decimal Precio {get;set;}
        public String Name {get;set;}
        public Integer Nivel {get;set;}
        public Double Indice {get; set;}
        public String contadorFamilia{get;set;}
    }
    
    Map<Id, List<String>> test = new Map<Id, List<String>>();
    List<String> test2 = new List<String>();

    private void enterRecIterate2(Id impId){
        Mejora__c imp = mapImpIds.get(impId);
        WrapperMejorasElement2 mejoraElementWrapped = new WrapperMejorasElement2();
        
        mejoraElementWrapped.DescripcionMejora = imp.DescripcionMejora__c!=NULL?imp.Name+' - '+ imp.DescripcionMejora__c:imp.Name;
        system.debug('imp : '+imp);
        mejoraElementWrapped.Precio = imp.Precio__c;
        mejoraElementWrapped.Name = imp.Name;
        mejoraElementWrapped.Id = imp.Id;
        //es el padre
        if(imp.MejoraPadre__c == null){
            mejoraElementWrapped.nivel=0;
            List<WrapperMejorasElement2> lWrapperMejorasNivel = mejorasMappedByMejoraHoja2.get(imp.Id);
            List<String> test2 = test.get(imp.Id);
            if(lWrapperMejorasNivel != null && test2 != null){
                lWrapperMejorasNivel.add(mejoraElementWrapped);
                test2.add(imp.Id);
            }
            else{
                lWrapperMejorasNivel = new List<WrapperMejorasElement2>{mejoraElementWrapped};
                test2 = new List<String>{imp.Id};
            }
            mejorasMappedByMejoraHoja2.put(imp.Id, lWrapperMejorasNivel);
            test.put(imp.Id, test2);
        }else{
            mejoraElementWrapped.IdPadre = imp.MejoraPadre__c;
            mejoraElementWrapped.nivel = 1;
            List<WrapperMejorasElement2> lWrapperMejorasNivel = mejorasMappedByMejoraHoja2.get(imp.MejoraPadre__c);
            List<String> test2 = test.get(imp.MejoraPadre__c);
            if(lWrapperMejorasNivel != null && test2 != null){
                lWrapperMejorasNivel.add(mejoraElementWrapped);
                test2.add(imp.Id);
            }
            else{
                lWrapperMejorasNivel = new List<WrapperMejorasElement2>{mejoraElementWrapped};
                test2 = new List<String>{imp.Id};
                
            }
            mejorasMappedByMejoraHoja2.put(imp.MejoraPadre__c, lWrapperMejorasNivel);
            test.put(imp.MejoraPadre__c, test2);
        }
        
        return;
    }
}