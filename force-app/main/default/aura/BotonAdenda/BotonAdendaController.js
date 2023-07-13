({
    
    doInit: function(component) {
       var action = component.get('c.getUrl');
          var self = this;
          action.setCallback(this, function(actionResult) {
          component.set('v.dominio', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
        /*
        var action = component.get('c.getCongaURL');
          var self = this;
         action.setParams({RecordId : component.get('v.recordId')});
          action.setCallback(this, function(actionResult) {
          component.set('v.CongaSolUrl', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);*/
    }, 
    
    //Adenda
	openModelPDF: function(component, event, helper) {
      var record = component.get('v.recordId');
      var etapa = component.get('v.record.Oportunidad__r.StageName');
	  /////////CONTRATO - ADENDA
      if(etapa == 'Contrato' || etapa == 'Plan de pagos'){
          var plantillaAdenda = component.get('v.record.Oportunidad__r.Promocion__r.Plantilla_de_adenda__c');
          component.set("v.isOpenPDF", true);
          component.set("v.isOpen", false);
          component.set("v.plantilla", plantillaAdenda);
          component.set("v.nombreFichero", 'Adenda');
          component.set("v.url", component.get('v.dominio')+plantillaAdenda+'?id=');//component.get('v.CongaSolUrl'));
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
        action.setParams({ oportunidadId : cmp.get("v.record.Oportunidad__c") ,  estado : cmp.get("v.record.Oportunidad__r.StageName"), plantilla : cmp.get("v.plantilla"),
                          nombreFichero : cmp.get("v.nombreFichero")});

        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            

            if (state === "SUCCESS") {
                
                if(response.getReturnValue() == true){
                    
                    cmp.set('v.isOpenPDF', false);
                    cmp.set('v.isOpen', true);
                    cmp.set('v.type', 'success');
                    cmp.set('v.message', 'La adenda se ha guardado correctamente');
                    
                }
                else{
                    
                    cmp.set('v.isOpenPDF', false);
                    cmp.set('v.isOpen', true);
                    cmp.set('v.type', 'warning');
                    cmp.set('v.message', 'La adenda ya ha sido guardado anteriormente');
                    
                    
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