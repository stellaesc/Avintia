({
    doInit: function(component) {
        
        var action= component.get("c.getProfileInfo");
		action.setCallback(this, function(response) {
        	var state = response.getState();
          	if(state == "SUCCESS" && component.isValid()){
				var result = response.getReturnValue();
                console.log(result);
                console.log(result.FirstName);
                component.set("v.prof", result);
                if(component.get("v.record.PruebaPublicada__c") && component.get("v.prof.Name") != "Comercial API")
                {
                    let button = component.find('disablebuttonid');
                    button.set('v.disabled',false);
                }
                
     		}else{
         		console.error("Getting Profile Failed: " + response.getError()[0].message); 
        	}
       	});
      	$A.enqueueAction(action);
    },
    
	obtenerFase : function(component, event, helper) {

        alert(component.get('v.record.Fase__c'));
	},
    publicarWeb : function (component, event, helper){
        component.set('v.isCargando',true);
        if(component.get("v.record.WebAvinita__c"))
        {
            
            var action= component.get("c.publicarWebAvintia");
        	action.setParams({PromoId:component.get("v.recordId"),esPrueba:"true"});
            
            var action1 = component.get("c.UpdateCurrWeb");
       		action1.setParams({Prom:component.get("v.record")});
        	            
           var self = this; 
    		action.setCallback(this, function(actionResult) {
        	var resultado= actionResult.getReturnValue();
            if(resultado=='OK'){
                let button = component.find('disablebuttonid');
    			button.set('v.disabled',false);
                component.set('v.isCargando',false);
                
                component.find('notifLib').showToast({
                "variant": "success",
                "mode": "sticky",
                "title": "",
                "message": "La promoción se ha publicado correctamente en el entorno",
            	}); 
                
                
            }
            else
            {
                let errors = actionResult.getError();
                let errMessage = 'Al publicar la promoción en el entorno';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errMessage = errors[0].message;
                }

                component.set('v.isCargando',false);
                component.find('notifLib').showToast({
                "variant": "Error",
                "mode": "sticky",
                "title": "Error",
                "message": errMessage,
            	}); 
            }
                
           
        });
            $A.enqueueAction(action); 
        }
        else
        {
           	 component.set('v.isCargando',false);
             component.find('notifLib').showToast({
                "variant": "error",
                "mode": "sticky",
                "title": "Error",
                "message": "No se puede realizar el envío, ya que no está marcado para publicar",
            }); 
        }
        action1.setCallback(this, function(actionResult) {
            var state = response.getState();
            var result = actionResult.getReturnValue();
          	if(result === "OK"){
                component.set('v.isCargando', false);
            } else {
                component.set('v.isCargando', false);
                component.find('notifLib').showToast({
                    "variant": "Error",
                    "mode": "sticky",
                    "title": "Error",
                    "message": result,
                });
            }
            });
        $A.enqueueAction(action1);    
    	
        
	},
    publicarWebProduccion : function (component, event, helper){
        component.set('v.isCargando',true);
        if(component.get("v.record.WebAvinita__c"))
        {
            
            var action= component.get("c.publicarWebAvintia");
            action.setParams({PromoId:component.get("v.recordId"), esPrueba:"false"});
        	            
            
            var action1 = component.get("c.UpdateCurrWeb");
       		action1.setParams({Prom:component.get("v.record")});
        	   
        	            
           var self = this; 
    		action.setCallback(this, function(actionResult) {
        	var resultado= actionResult.getReturnValue();
                console.log("RESULTADO: " + resultado);
            if(resultado=='OK'){
                component.set('v.isCargando',false);
                component.find('notifLib').showToast({
                "variant": "success",
                "mode": "sticky",
                "title": "",
                "message": "La promoción se ha publicado correctamente en el entorno",
            	});  
            }
            else
            {
                let errors = actionResult.getError();
                let errMessage = 'Al generar la promoción';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errMessage = errors[0].message;
                }
                component.set('v.isCargando',false);
                component.find('notifLib').showToast({
                "variant": "Error",
                "mode": "sticky",
                "title": "Error",
                "message": errMessage,
            	}); 
            }
                
           
        });
            $A.enqueueAction(action); 
        }
        else
        {
           	 component.set('v.isCargando',false);
             component.find('notifLib').showToast({
                "variant": "error",
                "mode": "sticky",
                "title": "Error",
                "message": "No se puede realizar el envío, ya que no está marcado para publicar",
            }); 
        }
            
        action1.setCallback(this, function(actionResult) {
            var result = actionResult.getReturnValue();
            if(result === "OK"){
                component.set('v.isCargando', false);
            } else {
                component.set('v.isCargando', false);
                component.find('notifLib').showToast({
                    "variant": "Error",
                    "mode": "sticky",
                    "title": "Error",
                    "message": result,
                });
            }
        });
        $A.enqueueAction(action1);  
    	
        
	},
    publicarFotocasa : function (component, event, helper){
        component.set('v.isCargando',true);
        if(component.get("v.record.Fotocasa__c"))
        {
            
            var action= component.get("c.publicacionPortalesFotocasa");
        	action.setParams({PromoId:component.get("v.recordId"),esPrueba:"true"});
            
            var action1 = component.get("c.UpdateCurrWeb");
       		action1.setParams({Prom:component.get("v.record")});
        	            
           var self = this; 
    		action.setCallback(this, function(actionResult) {
        	var resultado= actionResult.getReturnValue();
            if(resultado=='OK'){
                let button = component.find('disablebuttonid');
    			button.set('v.disabled',false);
                component.set('v.isCargando',false);
                
                component.find('notifLib').showToast({
                "variant": "success",
                "mode": "sticky",
                "title": "",
                "message": "La promoción se ha publicado correctamente en el entorno",
            	}); 
                
                
            }
            else
            {
                let errors = actionResult.getError();
                let errMessage = 'Al publicar la promoción en el entorno';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errMessage = errors[0].message;
                }

                component.set('v.isCargando',false);
                component.find('notifLib').showToast({
                "variant": "Error",
                "mode": "sticky",
                "title": "Error",
                "message": errMessage,
            	}); 
            }
                
           
        });
            $A.enqueueAction(action); 
        }
        else
        {
           	 component.set('v.isCargando',false);
             component.find('notifLib').showToast({
                "variant": "error",
                "mode": "sticky",
                "title": "Error",
                "message": "No se puede realizar el envío, ya que no está marcado para publicar",
            }); 
        }
        action1.setCallback(this, function(actionResult) {
            var state = response.getState();
            var result = actionResult.getReturnValue();
          	if(result === "OK"){
                component.set('v.isCargando', false);
            } else {
                component.set('v.isCargando', false);
                component.find('notifLib').showToast({
                    "variant": "Error",
                    "mode": "sticky",
                    "title": "Error",
                    "message": result,
                });
            }
            });
        $A.enqueueAction(action1);    
	},
    publicarIdealista: function (component, event, helper) {
        console.log('TEST Idealista: ' + component.get("v.record.Idealista__c"));
        component.set('v.isCargando',true);
        if(component.get("v.record.Idealista__c"))
        {
            
            var action= component.get("c.publicacionPortalesIdealista");
        	action.setParams({PromoId:component.get("v.recordId"),esPrueba:"true"});
            
            var action1 = component.get("c.UpdateCurrWeb");
       		action1.setParams({Prom:component.get("v.record")});
        	            
           var self = this; 
    		action.setCallback(this, function(actionResult) {
        	var resultado= actionResult.getReturnValue();
            if(resultado=='OK'){
                let button = component.find('disablebuttonid');
    			button.set('v.disabled',false);
                component.set('v.isCargando',false);
                
                component.find('notifLib').showToast({
                "variant": "success",
                "mode": "sticky",
                "title": "",
                "message": "Documento generado",
            	}); 
                
            }
            else if(resultado=='DUPLICATED'){
                let button = component.find('disablebuttonid');
    			button.set('v.disabled',false);
                component.set('v.isCargando',false);
                
                component.find('notifLib').showToast({
                "variant": "success",
                "mode": "sticky",
                "title": "",
                "message": "Documento previamente generado - No ha sufrido cambios",
            	}); 
            }
            else
            {
                let errors = actionResult.getError();
                let errMessage = 'Al publicar la promoción en el entorno';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errMessage = errors[0].message;
                }

                component.set('v.isCargando',false);
                component.find('notifLib').showToast({
                "variant": "Error",
                "mode": "sticky",
                "title": "Error",
                "message": errMessage,
            	}); 
            }
                
           
        });
            $A.enqueueAction(action); 
        }
        else
        {
           	 component.set('v.isCargando',false);
             component.find('notifLib').showToast({
                "variant": "error",
                "mode": "sticky",
                "title": "Error",
                "message": "No se puede realizar el envío, ya que no está marcado para publicar",
            }); 
        }
        action1.setCallback(this, function(actionResult) {
            var state = response.getState();
            var result = actionResult.getReturnValue();
          	if(result === "OK"){
                component.set('v.isCargando', false);
            } else {
                component.set('v.isCargando', false);
                component.find('notifLib').showToast({
                    "variant": "Error",
                    "mode": "sticky",
                    "title": "Error",
                    "message": result,
                });
            }
            });
        $A.enqueueAction(action1); 
    }
})