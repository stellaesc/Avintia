({
     doInit: function(component) {
        if(component.get("v.record.IdPromocionBabonlab__c")!=null && component.get("v.record.IdPromocionBabonlab__c")!='')
        {
            let button1 = component.find('disablebuttonid1');
    			button1.set('v.disabled',true);
            let button2 = component.find('disablebuttonid2');
    			button2.set('v.disabled',false);
        }
        if(component.get("v.record.PublicacionViviendasBaboonlab__c"))
        {
            let button1 = component.find('disablebuttonid4');
    			button1.set('v.disabled',true);
            let button2 = component.find('disablebuttonid3');
    			button2.set('v.disabled',false);
        }
         
        
    },
	enviarPromocionBabonLab : function (component, event, helper){
        component.set('v.isCargando',true);
            
            var action= component.get("c.enviarPromocion");
        	action.setParams({PromoId:component.get("v.recordId")});
        	            
           var self = this; 
    		action.setCallback(this, function(actionResult) {
        	var resultado= actionResult.getReturnValue();
            if(resultado=='OK'){
                let button1 = component.find('disablebuttonid1');
    			button1.set('v.disabled',true);
            	let button2 = component.find('disablebuttonid2');
    			button2.set('v.disabled',false);
                component.set('v.isCargando',false);
                
                component.find('notifLib').showToast({
                "variant": "success",
                "mode": "sticky",
                "title": "",
                "message": "La promoción se ha enviado correctamente a BabonLab",
            	}); 
                
                
            }
            else
            {
                component.set('v.isCargando',false);
                component.find('notifLib').showToast({
                "variant": "Error",
                "mode": "sticky",
                "title": "Error",
                "message": "Al enviar la promoción a BabonLab",
            	}); 
            }
                
           
        });
            $A.enqueueAction(action);             
    	
        
	},
    enviarModificacionPromocionBabonLab : function (component, event, helper){
        component.set('v.isCargando',true);
            
        var action= component.get("c.actualizarPromocion");
        action.setParams({PromoId:component.get("v.recordId"),idBabonlab:component.get("v.record.IdPromocionBabonlab__c")});

        	            
           var self = this; 
    		action.setCallback(this, function(actionResult) {
        	var resultado= actionResult.getReturnValue();
            if(resultado=='OK'){
                let button1 = component.find('disablebuttonid1');
    			button1.set('v.disabled',true);
            	let button2 = component.find('disablebuttonid2');
    			button2.set('v.disabled',false);
                component.set('v.isCargando',false);
                
                component.find('notifLib').showToast({
                "variant": "success",
                "mode": "sticky",
                "title": "",
                "message": "La promoción se ha modificado correctamente en BabonLab",
            	}); 
                
                
            }
            else
            {
                component.set('v.isCargando',false);
                component.find('notifLib').showToast({
                "variant": "Error",
                "mode": "sticky",
                "title": "Error",
                "message": "Al enviar la modificación de la promoción a BabonLab",
            	}); 
            }
                
           
        });
            $A.enqueueAction(action);             
    	
        
	},
    enviarAltaViviendasBabonLab : function (component, event, helper){
        component.set('v.isCargando',true);
            
        var action= component.get("c.enviarViviendas");
        action.setParams({PromoId:component.get("v.recordId")});

        	            
           var self = this; 
    		action.setCallback(this, function(actionResult) {
        	var resultado= actionResult.getReturnValue();
            if(resultado=='OK'){
                let button1 = component.find('disablebuttonid4');
    			button1.set('v.disabled',true);
            	let button2 = component.find('disablebuttonid3');
    			button2.set('v.disabled',false);
                component.set('v.isCargando',false);
                
                component.find('notifLib').showToast({
                "variant": "success",
                "mode": "sticky",
                "title": "",
                "message": "Las viviendas asociadas a la promoción se han enviado correctamente a BabonLab",
            	}); 
                
                
            }
            else
            {
                component.set('v.isCargando',false);
                component.find('notifLib').showToast({
                "variant": "Error",
                "mode": "sticky",
                "title": "Error",
                "message": "Al enviar las viviendas asociadas a la promoción a BabonLab",
            	}); 
            }
                
           
        });
            $A.enqueueAction(action);             
    	
        
	},
    enviarActualizacionViviendasBabonLab : function (component, event, helper){
        component.set('v.isCargando',true);
            
        var action= component.get("c.actualizarViviendas");
        action.setParams({PromoId:component.get("v.recordId")});

        	            
           var self = this; 
    		action.setCallback(this, function(actionResult) {
        	var resultado= actionResult.getReturnValue();
            if(resultado=='OK'){
                component.set('v.isCargando',false);
                
                component.find('notifLib').showToast({
                "variant": "success",
                "mode": "sticky",
                "title": "",
                "message": "Las viviendas asociadas a la promoción se han actualizado correctamente a BabonLab",
            	}); 
                
                
            }
            else
            {
                component.set('v.isCargando',false);
                component.find('notifLib').showToast({
                "variant": "Error",
                "mode": "sticky",
                "title": "Error",
                "message": "Al actualizar las viviendas asociadas a la promoción a BabonLab",
            	}); 
            }
                
           
        });
            $A.enqueueAction(action);             
    	
        
	}
})