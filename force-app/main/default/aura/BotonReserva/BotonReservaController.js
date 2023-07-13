({
    
    ///////////////////////// MÉTODOS INICIALES PARA RELLENAR TIPO VIVIENDA, TIPO INMUEBLE Y DOMINIO URL ///////////////////////////////////
	doInit: function(component) {
        
	    var action = component.get('c.getTipoVivienda');
        action.setParams({oportunidadId : component.get('v.recordId')});
    
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
        	component.set('v.tipoVivienda', actionResult.getReturnValue());
           
        });
        $A.enqueueAction(action);  
	},
    
	doInit2: function(component) {
	    var action = component.get('c.getTipoInmueble');
        action.setParams({oportunidadId : component.get('v.recordId')});
    
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
        	component.set('v.tipoInmueble', actionResult.getReturnValue());
           
        });
        $A.enqueueAction(action);  
	},
    
    doInit3: function(component) {
       var action = component.get('c.getUrl');
          var self = this;
          action.setCallback(this, function(actionResult) {
          component.set('v.dominio', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    

	///////////////////////////////////////////// MÉTODOS PARA GENERAR FACTURAS Y VERLAS EN MODAL //////////////////////////////////////////////////
    generarFactura : function(component, event, helper){
        
        component.set('v.isConfirmacionOpen', false);
        
        var action = component.get('c.generarFacturaAbono');
        action.setParams({oportunidadId : component.get('v.recordId')});
    

        // set call back 
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var idFactura = action.getReturnValue();
                component.set('v.idFactura', idFactura);
                if(idFactura != null){
                    component.set('v.isMessageOpen', true);
                    component.set('v.type', 'success');
                    component.set('v.message', 'Se ha generado la factura correctamente');
                }else{
                    component.set('v.isMessageOpen', true);
                    component.set('v.type', 'error');
                    component.set('v.message', 'No existe un depósito cobrado');    
                }

                //Refrescar la página
                $A.get('e.force:refreshView').fire();
                     
            } 
            else if (state === "INCOMPLETE") {
                
               
            } 
            else if (state === "ERROR") {
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                
                component.set('v.isMessageOpen', true);
                component.set('v.type', 'error');
                component.set('v.message', 'Se ha producido un error');
            }

        });
        // enqueue the action
        $A.enqueueAction(action);
        
    },
    
    verFactura : function(component, event, helper) {
        
        var facturaId = component.get('v.idFactura');
        var tipoVivienda = component.get('v.tipoVivienda');
        var tipoInmueble = component.get('v.tipoInmueble');
        var etapa = component.get('v.record.StageName');
       
        if(facturaId != null && facturaId != ''){
            window.open(component.get('v.dominio')+facturaId);
        }
        else{
            	component.set('v.isMessageOpen', true);
                component.set('v.type', 'error');
                component.set('v.message', 'Se ha producido un error');
        }
        
        
	},
    
   closeModelDeposito: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
       component.set("v.isMessageOpen", false);
   },
    
    openModelConfirmacion: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isConfirmacionOpen", true);    
   },
    
    closeModelConfirmacion: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isConfirmacionOpen", false);
   },

    setIdiomaCastellano: function(component, event, helper) { 
        component.set("v.idioma", 'Castellano');
    },

    setIdiomaIngles: function(component, event, helper) { 
        component.set("v.idioma", 'Ingles');
    },

    setIdiomaAleman: function(component, event, helper) { 
        component.set("v.idioma", 'Aleman');
    },
    
/////////////////////////////////METODOS PARA GENERAR DOCUMENTOS RESERVA, COMPRAVENTA,... EN MODAL //////////////////////////////////////////
   openModelPDF: function(component, event, helper) {
      var record = component.get('v.recordId');
      var etapa = component.get('v.record.StageName');
      var tipoInmueble = component.get('v.tipoInmueble');

      var idioma = component.get('v.idioma');

      var plantillaReserva      = component.get('v.record.Promocion__r.Plantilla_de_contrato_de_reserva__c');
      var plantillaCompraventa  = component.get('v.record.Promocion__r.Plantilla_de_contrato_de_compraventa__c');
             
      switch(idioma) {
        case "Castellano":
            var plantillaReservaIdioma = plantillaReserva.concat('_ES');
            var plantillaCompraventaIdioma = plantillaCompraventa.concat('_ES');
        break;
        case "Ingles":
            var plantillaReservaIdioma = plantillaReserva.concat('_EN');
            var plantillaCompraventaIdioma = plantillaCompraventa.concat('_EN');
        break;
        case "Aleman":
            var plantillaReservaIdioma = plantillaReserva.concat('_DE');
            var plantillaCompraventaIdioma = plantillaCompraventa.concat('_DE');
        break;
      }
	  /////////RESERVA
      if(etapa == 'Reserva' && tipoInmueble == 'Vivienda'){
          //var plantillaReserva = component.get('v.record.Promocion__r.Plantilla_de_contrato_de_reserva__c');
          component.get('v.record.Promocion__r.Plantilla_de_contrato_de_reserva__c');
          component.set("v.isOpenPDF", true);
          component.set("v.isOpen", false);
          //component.set("v.plantilla", plantillaReserva);
          component.set("v.plantilla", plantillaReservaIdioma);
          component.set("v.nombreFichero", 'FichaReserva');
          
          //component.set("v.url", component.get('v.dominio')+plantillaReserva+'?id=');
          component.set("v.url", component.get('v.dominio')+plantillaReservaIdioma+'?id=');
      
      }else if(etapa == 'Reserva' && tipoInmueble == 'Local'){
          var plantillaReserva = 'ReservaLocal';
          component.set("v.isOpenPDF", true);
          component.set("v.isOpen", false);
          component.set("v.plantilla", plantillaReserva);
          component.set("v.nombreFichero", 'FichaReserva');
   
          component.set("v.url", component.get('v.dominio')+plantillaReserva+'?id=');          
      
      /////////CONTRATO
      }
      else if(etapa == 'Contrato' && tipoInmueble != null  && tipoInmueble.lenght != 0){ 

          var tipoVivienda = component.get('v.tipoVivienda');
          var tipoInmueble = component.get('v.tipoInmueble');
          
          if(tipoVivienda == 'Libre'){
                component.set("v.isOpenPDF", true);
          		component.set("v.isOpen", false);
                //var plantillaCompraventa = component.get('v.record.Promocion__r.Plantilla_de_contrato_de_compraventa__c');
                //component.set("v.plantilla", plantillaCompraventa);
                component.set("v.plantilla", plantillaCompraventaIdioma);
              	component.set("v.nombreFichero", 'ContratoCompraventa');
              
                //component.set("v.url", component.get('v.dominio')+plantillaCompraventa+'?id=');
                component.set("v.url", component.get('v.dominio')+plantillaCompraventaIdioma+'?id=');

          }else if(tipoVivienda == 'VPT'){
                component.set("v.isOpenPDF", true);
          		component.set("v.isOpen", false);
                var plantillaCompraventa = component.get('v.record.Promocion__r.Plantilla_de_contrato_de_compraventa_VPT__c'); 
                component.set("v.plantilla", plantillaCompraventa);
                component.set("v.nombreFichero", 'ContratoCompraventaVPT');

                component.set("v.url", component.get('v.dominio')+plantillaCompraventa+'?id=');

          }else if(tipoVivienda == 'VPO'){
                component.set("v.isOpenPDF", true);
          		component.set("v.isOpen", false);
                var plantillaCompraventa = component.get('v.record.Promocion__r.Plantilla_de_contrato_de_compraventa_VPO__c'); 
                component.set("v.plantilla", plantillaCompraventa);
                component.set("v.nombreFichero", 'ContratoCompraventaVPO');
              
                component.set("v.url", component.get('v.dominio')+plantillaCompraventa+'?id=');

          }else if(tipoInmueble != 'Vivienda'){
                component.set("v.isOpenPDF", true);
          		component.set("v.isOpen", false);
                var plantillaCompraventa = component.get('v.record.Promocion__r.Plantilla_contrato_CV_No_Vivienda__c'); 
                component.set("v.plantilla", plantillaCompraventa);
                component.set("v.nombreFichero", 'ContratoCompraventaNoAsociados');
                
                component.set("v.url", component.get('v.dominio')+plantillaCompraventa+'?id=');

          }else{
                component.find('notifLib').showToast({
                "variant": "ERROR",
                "mode": "sticky",
                "title": "ERROR",
                "message": 'El campo Tipo de Vivienda de la vivienda asociada a la oportunidad debe estar relleno.',
                }); 
          }        
      
      /////////CANCELADA    
        } else if(etapa == 'Cancelada' && tipoInmueble != null  && tipoInmueble.lenght != 0){

            if(component.get('v.record.Mostrar_Resolucion_Reserva__c')) {
                component.set("v.isOpenPDF", true);
                component.set("v.isOpen", false);
                var tipoVivienda = component.get('v.tipoVivienda');
                var plantillaResolucion = component.get('v.record.Promocion__r.Plantilla_cancelacion_reserva__c');
                component.set("v.plantilla", plantillaResolucion);
                component.set("v.nombreFichero", 'ResoluciónReserva');
                
                component.set("v.url", component.get('v.dominio')+plantillaResolucion+'?id=');

            } else if(component.get('v.record.Mostrar_Resolucion_Compraventa__c')) {
                component.set("v.isOpenPDF", true);
                component.set("v.isOpen", false);
                var tipoVivienda = component.get('v.tipoVivienda');
                var plantillaResolucion = component.get('v.record.Promocion__r.Plantilla_cancelacion_compraventa__c');
                
                component.set("v.plantilla", plantillaResolucion);
                component.set("v.nombreFichero", 'ResoluciónCompraventa');
                
                component.set("v.url", component.get('v.dominio')+plantillaResolucion+'?id=');
            }
                    
        
      ////////ESCRITURACION
   	    } else if(etapa == 'Escrituración' && tipoInmueble != null  && tipoInmueble.lenght != 0){   
            component.set("v.isOpenPDF", true);
            component.set("v.isOpen", false);
            var plantillaEscrituracion = component.get('v.record.Promocion__r.Plantilla_de_escrituracion__c');
            component.set("v.plantilla", plantillaEscrituracion);
            component.set("v.nombreFichero", 'FichaEscrituración');
            
            component.set("v.url", component.get('v.dominio')+plantillaEscrituracion+'?id=');
        }
   },
    

    //Adenda
	openModelPDF2: function(component, event, helper) {
      var record = component.get('v.recordId');
      var etapa = component.get('v.record.StageName');
      var tipoInmueble = component.get('v.tipoInmueble');

      var idioma = component.get('v.idioma');

      var plantillaCompraventa  = component.get('v.record.Promocion__r.Plantilla_de_contrato_de_compraventa__c');
      
      switch(idioma) {
        case "Castellano":  
            var plantillaCompraventaIdioma = plantillaCompraventa.concat('_ES');
        break;
        case "Ingles":
            var plantillaCompraventaIdioma = plantillaCompraventa.concat('_EN');
        break;
        case "Aleman":
            var plantillaCompraventaIdioma = plantillaCompraventa.concat('_DE');
        break;
      }

	  /////////CONTRATO - ADENDA
      if(etapa == 'Contrato'){
          var plantillaAdenda = component.get('v.record.Promocion__r.Plantilla_de_adenda__c');
          component.set("v.isOpenPDF", true);
          component.set("v.isOpen", false);
          component.set("v.plantilla", plantillaAdenda);
          component.set("v.nombreFichero", 'Adenda');
          component.set("v.url", component.get('v.dominio')+plantillaAdenda+'?id=');
      
       }else if(etapa == 'Reserva' && tipoInmueble != null  && tipoInmueble.lenght != 0){   
          var tipoVivienda = component.get('v.tipoVivienda');
          if(tipoVivienda == 'Libre'){
                //var plantillaCompraventa = component.get('v.record.Promocion__r.Plantilla_de_contrato_de_compraventa__c');
                component.set("v.isOpenPDF", true);
          		component.set("v.isOpen", false);
                //component.set("v.plantilla", plantillaCompraventa);
                component.set("v.plantilla", plantillaCompraventaIdioma);
              	component.set("v.nombreFichero", 'BorradorContratoCompraventa');
              
                //component.set("v.url", component.get('v.dominio')+plantillaCompraventa+'?id=');
                component.set("v.url", component.get('v.dominio')+plantillaCompraventaIdioma+'?id=');
          }else if(tipoVivienda == 'VPT'){
                component.set("v.isOpenPDF", true);
          		component.set("v.isOpen", false);
                var plantillaCompraventa = component.get('v.record.Promocion__r.Plantilla_de_contrato_de_compraventa_VPT__c'); 
                component.set("v.plantilla", plantillaCompraventa);
                component.set("v.nombreFichero", 'BorradorContratoCompraventaVPT');
				 
                component.set("v.url", component.get('v.dominio')+plantillaCompraventa+'?id=');    
          }else if(tipoVivienda == 'VPO'){
                component.set("v.isOpenPDF", true);
          		component.set("v.isOpen", false);
                var plantillaCompraventa = component.get('v.record.Promocion__r.Plantilla_de_contrato_de_compraventa_VPO__c'); 
                component.set("v.plantilla", plantillaCompraventa);
                component.set("v.nombreFichero", 'BorradorContratoCompraventaVPO');
				component.set("v.url", component.get('v.dominio')+plantillaCompraventa+'?id=');
          }else{
                component.find('notifLib').showToast({
                "variant": "ERROR",
                "mode": "sticky",
                "title": "ERROR",
                "message": 'El campo Tipo de Vivienda de la vivienda asociada a la oportunidad debe estar relleno.',
                }); 
          } 
    
          
   		}
        
   },
 

    closeModelPDF: function(component, event, helper) {
      component.set("v.isOpenPDF", false);
   },
   
    
    openModel: function(component, event, helper) {
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      component.set("v.isOpen", false);
   },
    
    GenerarContrato: function(cmp, event, helper) {
      var action = cmp.get("c.generarContrato");
        action.setParams({ oportunidadId : cmp.get("v.recordId") ,  estado : cmp.get("v.record.StageName"), plantilla : cmp.get("v.plantilla"),
                          nombreFichero : cmp.get("v.nombreFichero")});

        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            

            if (state === "SUCCESS") {
                
                if(response.getReturnValue() == true){
                    
                    cmp.set('v.isOpenPDF', false);
                    cmp.set('v.isOpen', true);
                    cmp.set('v.type', 'success');
                    cmp.set('v.message', 'El contrato se ha guardado correctamente');
                    
                }
                else{
                    
                    cmp.set('v.isOpenPDF', false);
                    cmp.set('v.isOpen', true);
                    cmp.set('v.type', 'warning');
                    cmp.set('v.message', 'El contrato ya ha sido guardado anteriormente');
                    
                    
                }
                
                
            }
            else if (state === "INCOMPLETE") {
                
                cmp.set('v.isOpenPDF', false);
                cmp.set('v.isOpen', true);
                cmp.set('v.type', 'error');
                cmp.set('v.message', 'Se ha producido un error');
                
            }
            else if (state === "ERROR") {
                
                var errors = response.getError();
                
                if (errors) {
                    
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
                else {
                        console.log("Unknown error");
                    }
                
                cmp.set('v.isOpenPDF', false);
                cmp.set('v.isOpen', true);
                cmp.set('v.type', 'error');
                cmp.set('v.message', 'Se ha producido un error');
            }
        });
        $A.enqueueAction(action);
   },
    

})