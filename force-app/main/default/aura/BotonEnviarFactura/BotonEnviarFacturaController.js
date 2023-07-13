({
    
    doInit: function(component) {
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
        
        var action = component.get('c.generarFacturaAnulacion');
        action.setParams({facturaId : component.get('v.recordId')});
    

        // set call back 
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
				var idFactura = action.getReturnValue();
                if(idFactura != null){
                    component.set('v.isMessageOpen', true);
                    component.set('v.type', 'success');
                    component.set('v.message', 'Se ha generado la factura correctamente');
                    var dominio = component.get('v.dominio');
                    window.open(dominio.substring(0, dominio.length - 5) + '/lightning/r/Factura__c/' + idFactura + '/view', '_blank');
                    //str.substring(str.length - 1, str.length)
                    //window.open('https://grupoavintia--despro.lightning.force.com/lightning/r/Factura__c/' + idFactura + '/view', '_blank');
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
    
    
	EmitirFactura : function(cmp, event, helper) {
        
       var action = cmp.get("c.generarFactura");
       var boton = event.getSource().get("v.label"); 
        
       action.setParams({ facturaId : cmp.get("v.recordId") });

        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            

            if (state === "SUCCESS") {
                
                if(response.getReturnValue() == true){
                    
                    cmp.set('v.isOpenPDF', false);
                    cmp.set('v.isOpen', true);
                    cmp.set('v.type', 'success');
                    cmp.set('v.message', 'La factura se ha emitido correctamente');
                    
                }
                else{
                    
                    cmp.set('v.isOpenPDF', false);
                    cmp.set('v.isOpen', true);
                    cmp.set('v.type', 'warning');
                    cmp.set('v.message', 'La factura ya ha sido emitida anteriormente');
                    
                    cmp.set("v.ReenviarEmail",true);
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
                
                cmp.set('v.isOpenPDF', False);
                cmp.set('v.isOpen', true);
                cmp.set('v.type', 'error');
                cmp.set('v.message', 'Se ha producido un error');
            }
        });
        $A.enqueueAction(action);
        
	},
    
    openModelPDF: function(component, event, helper) {
      component.set("v.isOpenPDF", true);
        
      component.set("v.isOpen", false);
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
    
    openModelConfirmacion: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isConfirmacionOpen", true);    
   },
    
    closeModelConfirmacion: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isConfirmacionOpen", false);
   },
    
    reenviarEmail: function(cmp, event, helper) {
      

       var action = cmp.get("c.enviarEmail");
       action.setParams({ facturaId : cmp.get("v.recordId") });

        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            

            if (state === "SUCCESS") {
                
                cmp.set('v.type', 'success');
                cmp.set('v.message', 'Se ha reenviado la factura correctamente');
                
                cmp.set("v.ReenviarEmail",false);
                
            }
            else if (state === "INCOMPLETE") {
                
                cmp.set("v.ReenviarEmail",false);
                
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
                
                cmp.set('v.type', 'error');
                cmp.set('v.message', 'Se ha producido un error');
                cmp.set("v.ReenviarEmail",false);
                
            }
        });
        $A.enqueueAction(action);
        
	},
    
})