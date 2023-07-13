({
    
	doInit: function(component) {
	    var action = component.get('c.getTipoInmueble');
        action.setParams({quoteId : component.get('v.recordId')});
    
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
        	component.set('v.tipoInmueble', actionResult.getReturnValue());
           
        });
        $A.enqueueAction(action);  
	},
	    doInit2: function(component) {
       var action = component.get('c.getUrl');
          var self = this;
          action.setCallback(this, function(actionResult) {
          component.set('v.dominio', actionResult.getReturnValue());
        });
    	$A.enqueueAction(action);
    }, 
    
    openModelPDF: function(component, event, helper) {
      
      var record = component.get('v.recordId');
      //var etapa = component.get('v.record.StageName');
      var tipoInmueble = component.get('v.tipoInmueble');

      if(tipoInmueble != null  && tipoInmueble.lenght != 0){  
          component.set("v.isOpenPDF", true);
          component.set("v.isOpen", false);
          component.set("v.url", component.get('v.dominio')+'/apex/VF_Ficha_Forma_pago?id=');
          }
   }, 
    
    GenerarContrato: function(cmp, event, helper) {
      var action = cmp.get("c.generarContrato");
      action.setParams({ quoteId : cmp.get("v.recordId") ,  estado : cmp.get("v.record.StageName") });

        
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
                
                cmp.set('v.isOpenPDF', False);
                cmp.set('v.isOpen', true);
                cmp.set('v.type', 'error');
                cmp.set('v.message', 'Se ha producido un error');
            }
        });
        $A.enqueueAction(action);
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
    
    
})