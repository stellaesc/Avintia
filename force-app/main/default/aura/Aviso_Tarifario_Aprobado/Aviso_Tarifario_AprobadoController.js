({
    doInit : function(component, event, helper) {
        helper.getTask(component, event);
    }, 
    
    creaRecordat : function (component, event, helper){
        helper.crearRecordatorio(component, event);
    },
    
    publicarWeb : function (component, event, helper){
        helper.publicarEnWeb(component, event); 
    }
})