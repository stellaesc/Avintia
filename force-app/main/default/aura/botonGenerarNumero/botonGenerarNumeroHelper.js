({
    execute : function(component, event, helper) {
        
        component.set('v.isCargando',true);
        
        var action= component.get("c.generador");
        action.setCallback(this, function(response) {
        	var state = response.getState();
          	if(state == "SUCCESS"){
                component.set('v.isCargando', false);
                console.log("Success");
                component.find('notifLib').showToast({
                "variant": "success",
                "mode": "sticky",
                "title": "",
                "message": "El proceso se ha ejecutado correctamente.",
            	}); 
     		}else{
                component.set('v.isCargando', false);
                component.find('notifLib').showToast({
                "variant": "error",
                "mode": "sticky",
                "title": "",
                "message": "Ha ocurrido un problema. Por favor contacte con su administrador.",
            	});
        	}
       	});
      	$A.enqueueAction(action);
	}
})