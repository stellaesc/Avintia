({
    getUserInfo : function(cmp, event) {
        var action= cmp.get("c.getProfileInfo");
        var params = {
            recordId : cmp.get("v.recordId")
        }
        action.setParams(params);
		action.setCallback(this, function(response) {
        	var state = response.getState();
          	if(state == "SUCCESS" && cmp.isValid()){
                console.log(response.getReturnValue());
                cmp.set("v.setView", response.getReturnValue());
     		}else{
         		console.error("Getting user info failed: " + response.getError()[0].message); 
        	}
       	});
      	$A.enqueueAction(action);
    },
    
    fileSave : function(cmp, event) {
        cmp.set("v.loading", true);
        var params = {
            recordId : cmp.get("v.recordId"),
            cdocs : cmp.get("v.cdocs")
        }
        var action = cmp.get('c.saveFile');
        action.setParams(params);
    	var self = this;
    	action.setCallback(this, function(result) {
            if(result.getState() === "SUCCESS"){
              	var sb = false;
                result.getReturnValue().forEach(function(cdoc){
                    cdoc.ps.forEach(function(prd){
                        if(prd.bad) sb = true;
                    });
                });
                if(sb) cmp.set("v.showSave", false);
                else cmp.set("v.isOpen", false);
                cmp.set("v.cdocs", result.getReturnValue());
        		cmp.set("v.loading", false);
            }else{
         		console.error("CSV data save failed: " + response.getError()[0].message); 
        	}
        });
        $A.enqueueAction(action); 
    },
    
	fileProcessing : function(cmp, event) {
        var params = {
            recordId : cmp.get('v.recordId'),
            cdocs : event.getParam("files")
        }
        
        var action = cmp.get('c.fileProcessing');
        action.setParams(params);
    	var self = this;
    	action.setCallback(this, function(result) {
            if(result.getState() === "SUCCESS"){
            	var sb = false;
                result.getReturnValue().forEach(function(cdoc){
                    cdoc.ps.forEach(function(prd){
                        if(prd.bad) sb = true;
                    });
                });
                if(sb) cmp.set("v.showSave", false);
                else cmp.set("v.showSave", true);
                
                cmp.set("v.cdocs", result.getReturnValue());
                cmp.set("v.isOpen", true);
            }else{
         		console.error("CSV data processing failed: " + result.getError()[0].message); 
        	}
        });
        $A.enqueueAction(action); 
	},
    
    deleteFileOnDiscard : function(cmp, event) {
        cmp.set("v.loading", true);
        var params = {
            cdocs : cmp.get("v.cdocs")
        }
        var action = cmp.get('c.deleteFile');
        action.setParams(params);
    	var self = this;
    	action.setCallback(this, function(result) {
            if(result.getState() === "SUCCESS"){
        		cmp.set("v.isOpen", false);
        		cmp.set("v.loading", false);
            }else{
         		console.error("CSV data delete failed: " + result.getError()[0].message); 
        	}
        });
        $A.enqueueAction(action); 
    },
    
    getProducts : function(cmp, event, helper) {
        cmp.set("v.loading", true);
        var params = {
            recordId : cmp.get('v.recordId')
        }
        
        var action = cmp.get('c.getProducts');
        action.setParams(params);
    	var self = this;
    	action.setCallback(this, function(result) {
            cmp.set("v.loading", false);
            if(result.getState() === "SUCCESS"){
                var stockData = result.getReturnValue();
                if(stockData == null || stockData.length == 0) return;
                
                var csv = helper.sObjectsToCSV(cmp, stockData);
                if (csv == null) return; 
                
                var hiddenElement = document.createElement('a');
                hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                hiddenElement.target = '_self'; 
                hiddenElement.download = 'Tarifario-' + Date.now() + '.csv';
                document.body.appendChild(hiddenElement);
                hiddenElement.click();
            }else{
         		console.error("Downloading csv failed: " + result.getError()[0].message); 
        	}
        });
        $A.enqueueAction(action);
    },
    
    sObjectsToCSV : function(component, objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider, parentKey;
        
        if (objectRecords == null || !objectRecords.length) return null;
        
        columnDivider = ';';
        lineDivider =  '\n';
        
        keys = ['Id', 'Name', 'Precio_propuesto__c', 'Precio_Comercial__c'];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            for(var sTempkey in keys) {
                var skey = keys[sTempkey];
                if(counter > 0) csvStringResult += columnDivider;
                csvStringResult += (objectRecords[i][skey] == null || objectRecords[i][skey] == undefined) ? '' : ('' + objectRecords[i][skey].toString() + '');
                counter++;
            }     
            csvStringResult += lineDivider;
        }
        return csvStringResult;        
    }
})