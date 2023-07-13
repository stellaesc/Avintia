({
    doInit: function(cmp, event, helper) {
        /*var action = cmp.get("c.getCurrentProfile");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                cmp.set('v.profile', result);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "mode": 'sticky',
                            "title": "¡Error!",
                            "message": errors[0].message
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);

        action = cmp.get("c.getAmlCheckOldAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accounts = response.getReturnValue();
                console.log(accounts);
                cmp.set('v.oldAccounts', accounts);
            } else if (state === "INCOMPLETE") {
                
            } else if (state === "ERROR") {  
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "mode": 'sticky',
                            "title": "¡Error!",
                            "message": errors[0].message
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

	sendAmlCheck : function(cmp, event, helper) {
        var action = cmp.get("c.envioClienteAmlCheckFuture");
        var accsIds = [cmp.get('v.recordId')];
        action.setParams({ accsIds : accsIds, isInsert: true });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('TODO OK');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "¡Insertado con éxito!",
                    "message": 'Se ha insertado la cuenta correctamente en la base de datos de AML. Por favor, refresca la página para ver reflejados los cambios'
                });
                toastEvent.fire();
            } else if (state === "INCOMPLETE") {
                
            } else if (state === "ERROR") {  
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "mode": 'sticky',
                            "title": "¡Error!",
                            "message": errors[0].message
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    sendAmlCheckAllOld: function(cmp, event, helper) {
        var accounts = cmp.get('v.oldAccounts');

        var confirmed = confirm('Esta opción se ejecutará en segundo plano y actuará sobre los registros que tengan rellenos al menos uno de los siguientes campos: CNO, CNAE o Situación laboral. ¿Quieres continuar?');
        if(confirmed) {
            accounts.forEach(function(value, index) {
                var action = cmp.get("c.envioClienteAmlCheckFuture");
                action.setParams({ accsIds: value, isInsert: true });
                action.setBackground();
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        console.debug('[AML] Cuenta ' + value + ' insertada en AML');
                    } else if (state === "INCOMPLETE") {
                        
                    } else if (state === "ERROR") {  
                        var errors = response.getError();
                        if (errors) {
                            console.debug('[AML] Cuenta ' +  value + ' no se ha podido insertar en AML por un error, comprueba los logs.')
                            if (errors[0] && errors[0].message) {
                                console.debug("[AML] Error message: " + errors[0].message);
                                /*var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "mode": 'sticky',
                                    "title": "¡Error!",
                                    "message": errors[0].message
                                });
                                toastEvent.fire();*/
     /*                       }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                });

                $A.enqueueAction(action);
            });
        }*/
    }
})