({
    
    doInit : function(component, event, helper) {
        helper.getMejorasInit(component, event);
    },
    
    add : function(component, event, helper) {
       
    },
    
    save : function(component, event, helper) {
        helper.saveMejoras(component, event);
        component.set("v.isOpen", false);
    },
    
    openModal : function(component, event, helper) {
        helper.getMejoras(component, event);
    },
    
    closeModal : function(component, event, helper) {
        component.set("v.isOpen", false);
    }
    
})