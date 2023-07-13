({
    getMejorasInit : function(component, event) {
		var action = component.get('c.getMejoras');
        action.setParams({
        	quoteId : component.get('v.recordId')
        });
    	action.setCallback(this, function(actionResult) {
            if (actionResult.getState() === 'SUCCESS') {
                component.set('v.mejoras', actionResult.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    
	getMejoras : function(component, event) {
		var action = component.get('c.getMejoras');
        action.setParams({
        	quoteId : component.get('v.recordId')
        });
    	action.setCallback(this, function(actionResult) {
            if (actionResult.getState() === 'SUCCESS') {
                component.set('v.mejoras', actionResult.getReturnValue());
        		component.set("v.isOpen", true);
            }
        });
        $A.enqueueAction(action);
	},
    
    saveMejoras : function(component, event) {
        var action = component.get('c.saveMejoras');
        action.setParams({
        	quoteId : component.get('v.recordId'),
            mejoras : component.get('v.mejoras')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    }
})