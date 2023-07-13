({
	doInit: function(component) {
        
	    var action = component.get('c.getApproverName');
        action.setParams({promocionId : component.get('v.recordId')});
    
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
        	component.set('v.nombreAprobador', actionResult.getReturnValue());
           
        });
        $A.enqueueAction(action);  
	},
})