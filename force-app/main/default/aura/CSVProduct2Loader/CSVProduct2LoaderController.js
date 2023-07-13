({
    doInit : function(cmp, event, helper) {
        helper.getUserInfo(cmp, event);
    },
    
	handleUploadFinished : function (cmp, event, helper) {
        helper.fileProcessing(cmp, event);
    },
    
    closeModal : function(cmp, event, helper) {
    	helper.deleteFileOnDiscard(cmp, event);
    },
    
    uploadCSV : function(cmp, event, helper) {
    	helper.fileSave(cmp, event);
    },
    
    downloadCSV : function (cmp, event, helper) {
        helper.getProducts(cmp, event, helper);
    }
})