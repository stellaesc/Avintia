({
    getTask: function(component, event) {
        var action = component.get('c.searchTask');
        action.setParams({
            idTask : component.get("v.recordId")
        }); 
        action.setCallback(this, function(actionResult){
            if(actionResult.getReturnValue() == true){
                let boton = component.find('disablebuttonid');
    			boton.set('v.disabled',true);
            }
        });
        $A.enqueueAction(action);
    },
    
	crearRecordatorio : function(component, event) {
        component.set('v.isCargando',true);
		var action= component.get("c.pendiente");
        action.setParams({
            idTask : component.get("v.recordId")
        });
        
        action.setCallback(this, function(actionResult){
        	if(actionResult.getState() === 'SUCCESS'){
                component.set('v.isCargando',false);
                component.set('v.record', actionResult.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
	},
    
    publicarEnWeb : function(component, event) {
    	component.set('v.isCargando',true);
        var action= component.get("c.publicarWebAvintia");
        action.setParams({PromoId:component.get("v.record.Promocion__c"),esPrueba:"true"});
        
        var self = this; 
        action.setCallback(this, function(actionResult) {
            var resultado= actionResult.getReturnValue();
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
})