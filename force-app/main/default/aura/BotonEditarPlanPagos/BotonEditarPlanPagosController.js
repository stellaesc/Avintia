({

   openModelPDF: function(component, event, helper) {
      
      component.set("v.isOpenPDF", true);
	  helper.doInit(component, event, helper);
      helper.doInit2(component, event, helper);


   },
    
    closeModelPDF: function(component, event, helper) {
      component.set("v.isOpenPDF", false);
      
   },
    

	borrarCuota : function(component, event, helper) {
      var numCuota = parseInt(event.getSource().get("v.name"));
	  var factura = document.getElementById(numCuota);
      if(numCuota >= 1000){
        	var facturasCuotaList = component.get('v.facturasCuotaExtraList');
          	var numCuotaReal = numCuota - 1000; 
      }else{
            var facturasCuotaList = component.get('v.facturasCuotaList');
          	var numCuotaReal = numCuota; 
      }

      
      var listaActualizada = [];
        
      for(var i = 0; i < facturasCuotaList.length; i++){
          if(i != numCuotaReal){
              listaActualizada.push(facturasCuotaList[i]);
          }
	  }
	  
      var pendienteCobro = 0;
      for (var i = 0; i < listaActualizada.length; i++) {
          if(listaActualizada[i].Estado_de_la_factura__c =='Pendiente de emisión'){
          	   pendienteCobro += listaActualizada[i].Importe__c;
          }
      }
      
      if(numCuota >= 1000){
          component.set('v.pendienteCobroExtra', pendienteCobro); 
          component.set('v.descuadreExtra', Math.round( (component.get('v.pendienteCobroExtra') - component.get('v.pendienteCobroFijoExtra')) *100) / 100 );          
          component.set('v.facturasCuotaExtraList', listaActualizada);
          component.set('v.tamanoFacturasCuotaExtraList', listaActualizada.length);  
      }else{
          component.set('v.pendienteCobro', pendienteCobro);
          component.set('v.descuadre', Math.round( (component.get('v.pendienteCobro') - component.get('v.pendienteCobroFijo')) *100) /100 );          
          component.set('v.facturasCuotaList', listaActualizada);
          component.set('v.tamanoFacturasCuotaList', listaActualizada.length);  
      }

       
	},
    
	crearCuota : function(component, event, helper) {
      var nombreBoton = event.getSource().get("v.name");  
      if(nombreBoton == 'botonCrearCuota') {
        	var facturasCuotaList = component.get('v.facturasCuotaList');
      }else if(nombreBoton == 'botonCrearCuotaExtra'){
        	var facturasCuotaList = component.get('v.facturasCuotaExtraList');
      }

      var factura = {
          Fecha_de_emision__c: null, 
          Importe__c: null, 
          Estado_de_la_factura__c: 'Pendiente de emisión', 
          Tipo_de_factura__c : facturasCuotaList[0].Tipo_de_factura__c,
          Tipologia__c : facturasCuotaList[0].Tipologia__c,
          Referencia__c : facturasCuotaList[0].Referencia__c,
          Descripcion__c : facturasCuotaList[0].Descripcion__c,
          Sociedad__c : facturasCuotaList[0].Sociedad__c,
          Condicion_Cobro__c : facturasCuotaList[0].Condicion_Cobro__c,
          Metodo_de_cobro__c : facturasCuotaList[0].Metodo_de_cobro__c,
          Pago_o_Cuota__c : facturasCuotaList[0].Pago_o_Cuota__c,
          Oportunidad__c : facturasCuotaList[0].Oportunidad__c,
          Origen__c : facturasCuotaList[0].Origen__c        
      };
      facturasCuotaList.push(factura); 
      
      if(nombreBoton == 'botonCrearCuota') {
          component.set('v.facturasCuotaList', facturasCuotaList);
          component.set('v.tamanoFacturasCuotaList', facturasCuotaList.length);
      }else if(nombreBoton == 'botonCrearCuotaExtra'){
          component.set('v.facturasCuotaExtraList', facturasCuotaList);
          component.set('v.tamanoFacturasCuotaExtraList', facturasCuotaList.length);
      }

	},

    recalcular : function(component, event) {
      	var facturasCuotaList = component.get('v.facturasCuotaList');
        var importeNuevo = parseInt(event.getSource().get("v.value"));
        
        var pendienteCobro = 0;
      	for (var i = 0; i < facturasCuotaList.length; i++) {
            if(facturasCuotaList[i].Estado_de_la_factura__c =='Pendiente de emisión'){
                pendienteCobro += facturasCuotaList[i].Importe__c;
            }     	
      	}
        
        var suma = pendienteCobro;
        component.set('v.pendienteCobro', suma);
        component.set('v.descuadre',   Math.round((component.get('v.pendienteCobro') - component.get('v.pendienteCobroFijo')) * 100) / 100  );
        console.log('descuadre nuevo: ')
            console.log(component.get('v.descuadre'))
	},
    
    recalcularExtra : function(component, event) {
      	var facturasCuotaList = component.get('v.facturasCuotaExtraList');
        var importeNuevo = parseInt(event.getSource().get("v.value"));

        var pendienteCobro = 0;
      	for (var i = 0; i < facturasCuotaList.length; i++) {
            if(facturasCuotaList[i].Estado_de_la_factura__c =='Pendiente de emisión'){
            	pendienteCobro += facturasCuotaList[i].Importe__c;  
            }
      	}
        
        var suma = pendienteCobro;
        component.set('v.pendienteCobroExtra', suma);
        component.set('v.descuadreExtra', Math.round((component.get('v.pendienteCobroExtra') - component.get('v.pendienteCobroFijoExtra')) * 100) / 100);
        
	},
    
    handleError : function (cmp, evt, helper){
        alert("An error was found in your input.");
    },
    
    validarFecha : function(component, event) {
		var fechaNueva = event.getSource().get("v.value");
        
    	// date length should be 7 characters (no more no less) 
    	if (fechaNueva.length !== 7 || fechaNueva.substring(2, 3) !== '/') { 
        	    component.find('notifLib').showToast({
                "variant": "ERROR",
                "mode": "sticky",
                "title": "ERROR",
                "message": 'La fecha debe tener el siguiente formato: MM/YYYY',
                }); 
    	} 
        var month = parseInt(fechaNueva.substring(0, 2)); // because months in JS start from 0 
        //alert('month:::'+month);
    	var year = parseInt(fechaNueva.substring(3, 7)); 
        //alert('year:::'+year);
        var today = new Date();
        if(month > 12 || month < 1){
                component.find('notifLib').showToast({
                "variant": "ERROR",
                "mode": "sticky",
                "title": "ERROR",
                "message": 'El mes debe ser un número entre 1 y 12',
                });
        }/*
        if(year < today.getFullYear() || (month < today.getMonth() && year == today.getFullYear()) ){
                component.find('notifLib').showToast({
                "variant": "ERROR",
                "mode": "sticky",
                "title": "ERROR",
                "message": 'La fecha de emisión no puede ser anterior a la actual',
                }); 
        }*/

    },
    
    guardarNuevoPlanPagos : function(component, event, helper) {
        /*var facturasCuotaList = component.get('v.facturasCuotaExtraList');
      	for (var i = 0; i < facturasCuotaList.length; i++) {
             if(facturasCuotaList[i].Fecha_de_emision__c != null)        	
      	}*/

		var facturasCuotaList = component.get('v.facturasCuotaList');
        var facturasCuotaExtraList = component.get('v.facturasCuotaExtraList');
		var fechaFormatoIncorrecto = false;
        
        for (var i = 0; i < facturasCuotaList.length; i++) {
            if(facturasCuotaList[i].Fecha_de_emision__c != null && facturasCuotaList[i].Fecha_de_emision__c.length == 7){
        		facturasCuotaList[i].Fecha_de_emision__c = facturasCuotaList[i].Fecha_de_emision__c.substring(3, 7)+'-'+facturasCuotaList[i].Fecha_de_emision__c.substring(0, 2)+'-'+'10';                
            }else{
                fechaFormatoIncorrecto = true;
            }
        } 
        
        
        if(facturasCuotaExtraList != null){
            for (var i = 0; i < facturasCuotaExtraList.length; i++) { 
                if(facturasCuotaExtraList[i].Fecha_de_emision__c != null && facturasCuotaExtraList[i].Fecha_de_emision__c.length == 7){
                	facturasCuotaExtraList[i].Fecha_de_emision__c = facturasCuotaExtraList[i].Fecha_de_emision__c.substring(3, 7)+'-'+facturasCuotaExtraList[i].Fecha_de_emision__c.substring(0, 2)+'-'+'15';
                }else{
                    fechaFormatoIncorrecto = true;
                }
            }            
        }

        if(fechaFormatoIncorrecto == false){
            var accionARealizar = event.getSource().get("v.name");
            var action = component.get('c.crearPlanPagos');
            
            action.setParams({oportunidadId : component.get('v.recordId'), 
                              facturasList : facturasCuotaList, 
                              descuadre : component.get('v.descuadre'), 
                              accionBoton : accionARealizar,
                              facturasExtraList : facturasCuotaExtraList, 
                              descuadreExtra : component.get('v.descuadreExtra')
                             });
            
            // Set up the callback
            var self = this;
            action.setCallback(this, function(actionResult) {
                var response = actionResult.getReturnValue();
                    
                if(response[0] === 'success') {
                    component.find('notifLib').showToast({
                    "variant": response[0],
                    "mode": "sticky",
                    "title": response[1],
                    "message": response[2],
                    });
                    component.set("v.isOpenPDF", false);
                } else {
                    component.find('notifLib').showToast({
                    "variant": response[0],
                    "mode": "sticky",
                    "title": response[1],
                    "message": response[2],
                });
    
                }
       
            });
            $A.enqueueAction(action);          
        }else{
            
           for (var i = 0; i < facturasCuotaList.length; i++) { 
                if(facturasCuotaList[i].Fecha_de_emision__c != null && facturasCuotaList[i].Fecha_de_emision__c.length == 10){
              		facturasCuotaList[i].Fecha_de_emision__c = facturasCuotaList[i].Fecha_de_emision__c.substring(5, 7) +'/'+ facturasCuotaList[i].Fecha_de_emision__c.substring(0, 4);                    
                }
           }
            
            for (var i = 0; i < facturasCuotaExtraList.length; i++) { 
                if(facturasCuotaExtraList[i].Fecha_de_emision__c != null && facturasCuotaExtraList[i].Fecha_de_emision__c.length == 10){
              		facturasCuotaExtraList[i].Fecha_de_emision__c = facturasCuotaExtraList[i].Fecha_de_emision__c.substring(5, 7) +'/'+ facturasCuotaExtraList[i].Fecha_de_emision__c.substring(0, 4);                   
                }
            }
            
       		component.find('notifLib').showToast({
                "variant": "ERROR",
                "mode": "sticky",
                "title": "ERROR",
                "message": 'La fecha debe tener el siguiente formato: MM/YYYY.',
                });
        }

	},
    

    
})