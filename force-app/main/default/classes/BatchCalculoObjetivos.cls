/**
@description
<pre>
Creación diaria de objetivos</br>
DATE       	AUTHOR     	DESCRIPTION<br/>                 
11/01/2021 	LCS - BCF   Created.                         
</pre>
@author Leadclic Solutions
@date 11/01/2021
*/
global class BatchCalculoObjetivos implements Database.Batchable<sObject>, Schedulable{
    
    Map<Id, Set<Product2>> mProductoPromocion = new Map<Id, Set<Product2>>(); //Mapa Promocion, lista de Product2
    Map<Id, Set<RelacionVendedorProductoOportunidad__c>> mProductoVendedor = new Map<Id, Set<RelacionVendedorProductoOportunidad__c>>(); //Mapa Promocion, lista de productos de vendedor
    Map<Objetivo__c, Set<Product2>> mProductosObjetivos = new Map<Objetivo__c, Set<Product2>>();//Mapa objetivos, productos
    Map<Objetivo__c, Set<RelacionVendedorProductoOportunidad__c>> mProductoVendedorObjetivos = new Map<Objetivo__c, Set<RelacionVendedorProductoOportunidad__c>>();//Mapa objetivos, productos
	Map<Id, Set<DefinicionComision__c>> mVendedorDefiniciones = new Map<Id, Set<DefinicionComision__c>>(); //Mapa Vendedor, lista de Definiciones de Comision
    Map<Id, Set<DetalleComision__c>> mVendedorDetalles = new Map<Id, Set<DetalleComision__c>>(); //Mapa Vendedor, lista de Detalles de Comision
    Map<Id, RelacionVendedorProductoOportunidad__c> mProducto = new Map<Id, RelacionVendedorProductoOportunidad__c>(); //Mapa productos
    Map<Id, Comision__c> mComisionVendedor = new Map<Id, Comision__c>(); //Mapa Vendedor, Comision
    
    global void execute(SchedulableContext sc){
        BatchCalculoObjetivos b = new BatchCalculoObjetivos();
        Database.executebatch(b, 2000);
    }
    
    global List<sObject> start(Database.BatchableContext bc) {
        
        List<sObject> lScope = new List<sObject>();
        //Añadimos objetivos
        lScope.addAll([SELECT id, ObjetivoImporte__c, ObjetivoCumplido__c, ViviendasAlcanzadas__c, GarajesAlcanzados__c, TrasterosAlcanzados__c, LocalesAlcanzados__c, 
                       FechaLimiteObjetivo__c, Vendedor__c, Promocion__c, ImporteAlcanzado__c, ComisionReservas__c, ComisionContrato__c, ComisionEscritura__c, ComisionPosventa__c
                       FROM Objetivo__c 
                       WHERE FechaLimiteObjetivo__c >= TODAY AND Promocion__c != null]);
        
        //Añadimos Productos
        lScope.addAll([SELECT id, Estado__c, Tipologia_Vivienda_Garaje_Trastero_Local__c, Precio__c, Promocion__c 
                       FROM Product2 
                       WHERE (Estado__c = 'Entregado' OR Estado__c = 'Contrato' OR Estado__c = 'Bloqueado') AND Promocion__c != null]);
        
        //Añadimos Productos Relacionados
        lScope.addAll([SELECT id, Titular__c, vendedor__c, ProductoOportunidad__r.Product2.Estado__c, ProductoOportunidad__r.Product2.Tipologia_Vivienda_Garaje_Trastero_Local__c, 
                       ProductoOportunidad__r.Product2.Precio__c, ProductoOportunidad__r.Product2.Promocion__c , PorcentajeComision__c, ProductoOportunidad__c
                       FROM RelacionVendedorProductoOportunidad__c 
                       WHERE (ProductoOportunidad__r.Product2.Estado__c = 'Entregado' OR ProductoOportunidad__r.Product2.Estado__c = 'Contrato' OR ProductoOportunidad__r.Product2.Estado__c = 'Bloqueado') 
                       AND Titular__c = true AND vendedor__c != null AND ProductoOportunidad__r.Opportunity.StageName !='Cancelada']);
        
        String mesActual = Date.today().month().format();
        String yearActual = Date.today().year().format();
        
        //Añadimos Definición de Comisiones
        lScope.addAll([SELECT Id, PorcentajeReserva__c, PorcentajeContrato__c, PorcentajeEscrituracion__c, PorcentajePosventa__c, Vendedor__c, Promocion__c, Mes__c, Year__c, Activo__c
                       FROM DefinicionComision__c 
                       WHERE /*Mes__c = :mesActual AND Year__c = :yearActual AND*/ Activo__c = true AND Vendedor__c != null AND Promocion__c != null AND Mes__c != null AND Year__c != null]);
       
        //Añadimos Detalle Comision
        lScope.addAll([SELECT id, Name, Vendedor__c, Mes__c, Year__c, Importe__c, ProductoOportunidad__c, Promocion__c, ImporteContrato__c, ImporteEscrituracion__c, ImportePosventa__c, ImporteReserva__c
                       FROM DetalleComision__c 
                       WHERE ((Mes__c != :mesActual AND Year__c = :yearActual) OR (Year__c != :yearActual)) AND Tipo__c = 'Fija' AND Vendedor__c != null AND Promocion__c != null AND Mes__c != null AND Year__c != null]);
        
        //Añadimos Comision
        lScope.addAll([SELECT id, Name, Vendedor__c, Mes__c, Year__c
                       FROM Comision__c 
                       WHERE Mes__c = :mesActual AND Year__c = :yearActual AND Vendedor__c != null AND Mes__c != null AND Year__c != null]);
        
        return lScope;
    }
    
    private void filtrarQuery(Set<Product2> productosPromocion, Set<RelacionVendedorProductoOportunidad__c> productosVendedor){
        
        //Filtrar por promocion
        for(Product2 producto: productosPromocion){
            if(mProductoPromocion.containsKey(producto.Promocion__c)){
                Set<Product2> sProductPromocion = mProductoPromocion.get(producto.Promocion__c);
                sProductPromocion.add(producto);
                mProductoPromocion.put(producto.Promocion__c, sProductPromocion);
            }
            else{
                Set<Product2> sProductPromocion = new Set<Product2>();
                sProductPromocion.add(producto);
                mProductoPromocion.put(producto.Promocion__c, sProductPromocion);
            }
        }

        //Filtrar por vendedor
        for(RelacionVendedorProductoOportunidad__c producto: productosVendedor){
            if(mProductoVendedor.containsKey(producto.ProductoOportunidad__r.Product2.Promocion__c)){
                Set<RelacionVendedorProductoOportunidad__c> sProductVendedor = mProductoVendedor.get(producto.ProductoOportunidad__r.Product2.Promocion__c);
                sProductVendedor.add(producto);
                mProductoVendedor.put(producto.ProductoOportunidad__r.Product2.Promocion__c, sProductVendedor);
            }
            else{
                Set<RelacionVendedorProductoOportunidad__c> sProductVendedor = new Set<RelacionVendedorProductoOportunidad__c>();
                sProductVendedor.add(producto);
                mProductoVendedor.put(producto.ProductoOportunidad__r.Product2.Promocion__c, sProductVendedor);
            }
        }
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        
        Set<Objetivo__c> sObjetivo = new Set<Objetivo__c>();
        Set<Product2> sProductoPromocion = new Set<Product2>();
        Set<RelacionVendedorProductoOportunidad__c> sProductoVendedor = new Set<RelacionVendedorProductoOportunidad__c>();
        Set<DefinicionComision__c> sDefinicionComision = new Set<DefinicionComision__c>();
        Set<DetalleComision__c> sDetalleComision = new Set<DetalleComision__c>();
        Set<Comision__c> sComision = new Set<Comision__c>();            
            
        for(sObject sco : scope){
            switch on sco{
                when Objetivo__c obj{
                    sObjetivo.add(obj);
                }
                when Product2 prod{
                    sProductoPromocion.add(prod);
                }
                when RelacionVendedorProductoOportunidad__c prodVendedor{
                    sProductoVendedor.add(prodVendedor);
                }
                when DefinicionComision__c def{
                    sDefinicionComision.add(def);
                }
                when DetalleComision__c det{
                    sDetalleComision.add(det);
                }
                when Comision__c com{
                    sComision.add(com);
                }
            }
        }
        
        this.filtrarQuery(sProductoPromocion, sProductoVendedor);
        
        Set<Objetivo__c> sObjPromocion = new Set<Objetivo__c>(); //Objetivos de Promoción
        Set<Objetivo__c> sObjVendedor = new Set<Objetivo__c>(); //Objetivos de Vendedor
        
        //Filtrar por tipo de objetivo Vendedor o Promoción
        for(Objetivo__c obj: sObjetivo){
            if(obj.Vendedor__c != null){
                sObjVendedor.add(obj);
            }else{
                sObjPromocion.add(obj);
            }
        }
        
        sObjPromocion = this.ObjetivosPromocion(sObjPromocion);
        sObjVendedor = this.ObjetivosVendedor(sObjVendedor);
        
        //Objetivos cumplidos de vendedores
        Set<Objetivo__c> sObjCumplido = new Set<Objetivo__c>(); 
        for(Objetivo__c obj : sObjVendedor){
            if(obj.ObjetivoCumplido__c){
                sObjCumplido.add(obj);
            }
        }
        
        //Mapa Vendedor lista de definiciones de comision
        for(DefinicionComision__c def : sDefinicionComision){
            if(mVendedorDefiniciones.containsKey(def.Vendedor__c)){
             	Set<DefinicionComision__c> sDefiniciones = mVendedorDefiniciones.get(def.Vendedor__c);
                sDefiniciones.add(def);
                mVendedorDefiniciones.put(def.Vendedor__c, sDefiniciones);
            }
            else{
                Set<DefinicionComision__c> sDefiniciones = new Set<DefinicionComision__c>();
                sDefiniciones.add(def);
                mVendedorDefiniciones.put(def.Vendedor__c, sDefiniciones);
            }
        } 

        //Mapa vendedor, lista detalle comisiones
        for(DetalleComision__c det : sDetalleComision){
            if(mVendedorDetalles.containsKey(det.Vendedor__c)){
             	Set<DetalleComision__c> sDetalles = mVendedorDetalles.get(det.Vendedor__c);
                sDetalles.add(det);
                mVendedorDetalles.put(det.Vendedor__c, sDetalles);
            }
            else{
                Set<DetalleComision__c> sDetalles = new Set<DetalleComision__c>();
                sDetalles.add(det);
                mVendedorDetalles.put(det.Vendedor__c, sDetalles);
            }
        }
        
        //Mapa Id Producto, relacion vendedor producto oportunidad
        for(RelacionVendedorProductoOportunidad__c producto : sProductoVendedor){
            if(!mProducto.containsKey(producto.ProductoOportunidad__c)){
                mProducto.put(producto.ProductoOportunidad__c, producto);
            }
        }
        
        //Mapa Vendedor, Comision
        for(Comision__c comision : sComision){
            mComisionVendedor.put(comision.Vendedor__c, comision);
        }

        Set<DefinicionComision__c> sDefinicionUpdate = new Set<DefinicionComision__c>();
        Set<DefinicionComision__c> sDefinicionNueva = new Set<DefinicionComision__c>();
        Set<DefinicionComision__c> sDefinicionAntigua = new Set<DefinicionComision__c>();
        Set<DetalleComision__c> sDetallesNuevos = new Set<DetalleComision__c>();
        
        for(Objetivo__c obj : sObjCumplido){
            
            Double sumaTotal = 0; //Total retroactivo
            
            for(DefinicionComision__c def : mVendedorDefiniciones.get(obj.Vendedor__c)){ //definiciones del vendedor del objetivo
                Integer mes = integer.valueOf(def.Mes__c); //Convertimos a int la variable mes (String)
                
                if(obj.Promocion__c == def.Promocion__c && mes >= Date.today().month() && def.Year__c == Date.today().year().format()){ //Definiciones futuras
                    def.Activo__c = false; 
                    sDefinicionUpdate.add(def);//Hacer update de esta lista
                    
                } else if(obj.Promocion__c == def.Promocion__c && ((mes < Date.today().month() && def.Year__c == Date.today().year().format()) || def.Year__c != Date.today().year().format() )){ //Definiciones antiguas
                    sDefinicionAntigua.add(def);
                }
            }
        }
        
        sDefinicionNueva = this.objetivosCumplidos(sObjCumplido, sDefinicionUpdate); //Método retroactivo insert nuevas definiciones 
        sDetallesNuevos = this.DetallesRetroactivo(sObjCumplido, sDefinicionAntigua); //Método retroactivo insert nuevas detalles
        
        List<Objetivo__c> lObjPromocion = new List<Objetivo__c>();
        lObjPromocion.addAll(sObjPromocion);
        
        List<Objetivo__c> lObjVendedor = new List<Objetivo__c>();
        lObjVendedor.addAll(sObjVendedor);
                
        List<DefinicionComision__c> lDefinicionUpdate = new List<DefinicionComision__c>();
        lDefinicionUpdate.addAll(sDefinicionUpdate);
        
        List<DefinicionComision__c> lDefinicionInsert = new List<DefinicionComision__c>();
        lDefinicionInsert.addAll(sDefinicionNueva);
        
        List<DetalleComision__c> lDetalleInsert = new List<DetalleComision__c>();
        lDetalleInsert.addAll(sDetallesNuevos);
        
        update lObjPromocion;
        update lObjVendedor;
        update lDefinicionUpdate;
        insert lDefinicionInsert;
        insert lDetalleInsert;
        
    }
    
    private Set<Objetivo__c> ObjetivosPromocion(Set<Objetivo__c> sObjPromocion){
        
		//mapa <objetivos promocion, lista de productos> con misma promocion
        for(Objetivo__c obj: sObjPromocion){
            if(mProductoPromocion.containsKey(obj.Promocion__c)){
                Set<Product2> sProductos = mProductoPromocion.get(obj.Promocion__c);
            	mProductosObjetivos.put(obj, sProductos);
            }
        }
        
        //Calcular suma importes de productos y número de cada tipo de producto
        for(Objetivo__c obj: sObjPromocion){
            
            if(mProductosObjetivos.get(obj) != null){
                Set<Product2> sProducts = mProductosObjetivos.get(obj);
                
                obj.ImporteAlcanzado__c = 0;
                obj.ViviendasAlcanzadas__c = 0;
                obj.GarajesAlcanzados__c = 0;
                obj.TrasterosAlcanzados__c = 0;
                obj.LocalesAlcanzados__c = 0;
                
                for(Product2 product: sProducts){
                    if(product.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Vivienda') {
                        obj.ImporteAlcanzado__c += product.Precio__c;
                        obj.ViviendasAlcanzadas__c += 1;
                    }else if(product.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Garaje'){
                        obj.ImporteAlcanzado__c += product.Precio__c;
                        obj.GarajesAlcanzados__c += 1;
                    }else if(product.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Trastero'){
                        obj.ImporteAlcanzado__c += product.Precio__c;
                        obj.TrasterosAlcanzados__c += 1;
                    }else if(product.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Local'){
                        obj.ImporteAlcanzado__c += product.Precio__c;
                        obj.LocalesAlcanzados__c += 1;
                    }
                }
            }
            
        }
        return sObjPromocion;
    }
    
    private Set<Objetivo__c> ObjetivosVendedor(Set<Objetivo__c> sObjVendedor){
        
        //mapa <objetivos vendedor, lista de productos> con misma promocion
        for(Objetivo__c obj: sObjVendedor){
            
            if(mProductoVendedor.containsKey(obj.Promocion__c)){
                Set<RelacionVendedorProductoOportunidad__c> sProductos = mProductoVendedor.get(obj.Promocion__c);
                Set<RelacionVendedorProductoOportunidad__c> sProductosVendedor = new Set<RelacionVendedorProductoOportunidad__c>();
                for(RelacionVendedorProductoOportunidad__c producto : sProductos){
                    if(producto.Vendedor__c == obj.Vendedor__c){
                        sProductosVendedor.add(producto);
                    }
                }
                mProductoVendedorObjetivos.put(obj, sProductosVendedor);
            }            
        }
        
        //Calcular suma importes de productos de vendedor y número de cada tipo de producto de vendedor        
        for(Objetivo__c obj: sObjVendedor){
            
            if(mProductoVendedorObjetivos.get(obj) != null){
                Set<RelacionVendedorProductoOportunidad__c> sProducts = mProductoVendedorObjetivos.get(obj);
                
                obj.ImporteAlcanzado__c = 0;
                obj.ViviendasAlcanzadas__c = 0;
                obj.GarajesAlcanzados__c = 0;
                obj.TrasterosAlcanzados__c = 0;
                obj.LocalesAlcanzados__c = 0;
                
                for(RelacionVendedorProductoOportunidad__c product: sProducts){
                    if(product.ProductoOportunidad__r.Product2.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Vivienda') {
                        obj.ImporteAlcanzado__c += product.ProductoOportunidad__r.Product2.Precio__c;
                        obj.ViviendasAlcanzadas__c += 1;
                    }else if(product.ProductoOportunidad__r.Product2.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Garaje'){
                        obj.ImporteAlcanzado__c += product.ProductoOportunidad__r.Product2.Precio__c;
                        obj.GarajesAlcanzados__c += 1;
                    }else if(product.ProductoOportunidad__r.Product2.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Trastero'){
                        obj.ImporteAlcanzado__c += product.ProductoOportunidad__r.Product2.Precio__c;
                        obj.TrasterosAlcanzados__c += 1;
                    }else if(product.ProductoOportunidad__r.Product2.Tipologia_Vivienda_Garaje_Trastero_Local__c == 'Local'){
                        obj.ImporteAlcanzado__c += product.ProductoOportunidad__r.Product2.Precio__c;
                        obj.LocalesAlcanzados__c += 1;
                    }
                }
            }
            
        }
        return sObjVendedor;
    }
    
    private Set<DefinicionComision__c> objetivosCumplidos(Set<Objetivo__c> sObjCumplido, Set<DefinicionComision__c> sDefinicionComision){
        
        Set<DefinicionComision__c> sDefinicionNueva = new Set<DefinicionComision__c>(); //lista nuevas definiciones de comision
        //Set<DetalleComision__c> sNuevosDetalles = new Set<DetalleComision__c>(); //lista nuevos detalles de comision
        
        for(Objetivo__c obj : sObjCumplido){
            Double sumaTotal = 0; //Total retroactivo
            for(DefinicionComision__c def : sDefinicionComision){ //Definiciones del mismo vendedor
                
                if(obj.Promocion__c == def.Promocion__c && obj.Vendedor__c == def.Vendedor__c){ //Definiciones posteriores con misma promocion
                                       
                    DefinicionComision__c nueva = new DefinicionComision__c();
                    nueva.Activo__c = true;
                    nueva.Vendedor__c = def.Vendedor__c;
                    nueva.Promocion__c = def.Promocion__c;
                    nueva.PorcentajeReserva__c = obj.ComisionReservas__c;
                    nueva.PorcentajeContrato__c = obj.ComisionContrato__c;
                    nueva.PorcentajeEscrituracion__c = obj.ComisionEscritura__c;
                    nueva.PorcentajePosventa__c = obj.ComisionPosventa__c;
                    nueva.Mes__c = def.Mes__c;
                    nueva.Year__c = def.Year__c;
                    
                    sDefinicionNueva.add(nueva);
                    
                }
        	}
            
        }
        return sDefinicionNueva;
    }    
    
    private Set<DetalleComision__c> DetallesRetroactivo(Set<Objetivo__c> sObjCumplido, Set<DefinicionComision__c> sDefinicionAntigua){
        
        Set<DetalleComision__c> sNuevosDetalles = new Set<DetalleComision__c>(); //lista nuevos detalles de comision
        
        for(Objetivo__c obj : sObjCumplido){
            Double sumaTotal = 0; //Total retroactivo
            
            for(DefinicionComision__c def : sDefinicionAntigua){
                if(obj.Vendedor__c == def.Vendedor__c && obj.Promocion__c == def.Promocion__c){
                    Double restaReserva = obj.ComisionReservas__c - def.PorcentajeReserva__c;
                    Double restaContrato = obj.ComisionContrato__c - def.PorcentajeContrato__c;
                    Double restaEscritura = obj.ComisionEscritura__c - def.PorcentajeEscrituracion__c;
                    Double restaPosventa = obj.ComisionPosventa__c - def.PorcentajePosventa__c;
                    
                    for(DetalleComision__c det : mVendedorDetalles.get(obj.Vendedor__c)){
                        
                        if(det.Promocion__c == def.Promocion__c){
                            sumaTotal += restaReserva * mProducto.get(det.ProductoOportunidad__c).PorcentajeComision__c *  mProducto.get(det.ProductoOportunidad__c).ProductoOportunidad__r.Product2.Precio__c;
                            sumaTotal += restaContrato * mProducto.get(det.ProductoOportunidad__c).PorcentajeComision__c *  mProducto.get(det.ProductoOportunidad__c).ProductoOportunidad__r.Product2.Precio__c;
                            sumaTotal += restaEscritura * mProducto.get(det.ProductoOportunidad__c).PorcentajeComision__c *  mProducto.get(det.ProductoOportunidad__c).ProductoOportunidad__r.Product2.Precio__c;
                            sumaTotal += restaPosventa * mProducto.get(det.ProductoOportunidad__c).PorcentajeComision__c *  mProducto.get(det.ProductoOportunidad__c).ProductoOportunidad__r.Product2.Precio__c;
                        }
                    }
                    
                    DetalleComision__c nuevoDetalle = new DetalleComision__c();
                    nuevoDetalle.Vendedor__c = def.Vendedor__c;
                    nuevoDetalle.Promocion__c = def.Promocion__c;
                    nuevoDetalle.Mes__c = Date.today().month().format();
                    nuevoDetalle.Year__c = Date.today().year().format();
                    nuevoDetalle.Tipo__c = 'Extra';
                    nuevoDetalle.Comision__c = mComisionVendedor.get(def.Vendedor__c).Id;
                    nuevoDetalle.Importe__c = sumaTotal;
                    nuevoDetalle.Concepto__c = 'Suma retroactiva por cumplir con el objetivo';
                    
                    sNuevosDetalles.add(nuevoDetalle);
                }
                
            }
        }
          
        return sNuevosDetalles;
    }
    
    global void finish(Database.BatchableContext bc){}
   
}