({
    doInit: function(component) {
	    var action = component.get('c.getCuotas');
        action.setParams({oportunidadId : component.get('v.recordId'), tipoCuota : 'Cuota'});
        
        /*var action2 = component.get('c.getCuotas');
        action2.setParams({oportunidadId : component.get('v.recordId'), tipoCuota : 'Cuota'});*/ //SCA
    
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
            //SCA
            var facturasListTotal = actionResult.getReturnValue();
            var importeTotalAbonos = 0;
            
            //console.log('facturasListTotal: ' + facturasListTotal.length);
            for(var j = 0; j < facturasListTotal.length; j++){
                if(facturasListTotal[j].Concepto__c == 'Factura Auxiliar Abono'){
                    importeTotalAbonos = facturasListTotal[j].Importe__c;
                    //facturasListTotal.remove(j);
                    facturasListTotal.splice(j, 1);
                }
            }
            //console.log('importe total abonos: ' + importeTotalAbonos);
        	component.set('v.facturasCuotaList', facturasListTotal);
			var facturasCuotaList = component.get('v.facturasCuotaList');
            //console.log('facturasCuotaList: ' + facturasCuotaList.length);
            
            var pendienteCobro = 0;
            var sumatorioCobradas = 0;
            var SumaFacturasPendientes = 0;
            for (var i = 0; i < facturasCuotaList.length; i++) { 
                if(facturasCuotaList[i].Fecha_de_emision__c != null){
              		facturasCuotaList[i].Fecha_de_emision__c = facturasCuotaList[i].Fecha_de_emision__c.substring(5, 7) +'/'+ facturasCuotaList[i].Fecha_de_emision__c.substring(0, 4);                    
                }
                if(facturasCuotaList[i].Estado_de_la_factura__c =='Pendiente de emisión'){
                	SumaFacturasPendientes += facturasCuotaList[i].Importe__c;                    
                }
                
                if( (facturasCuotaList[i].Estado_plan_de_pagos__c == 'Activo' && ( facturasCuotaList[i].Estado_de_la_factura__c == 'Cobrada' || facturasCuotaList[i].Estado_de_la_factura__c == 'Volcada y Emitida') ) 
                   || (facturasCuotaList[i].Estado_plan_de_pagos__c == 'Inactivo' &&  facturasCuotaList[i].Estado_de_la_factura__c == 'Cobrada') ){
                    sumatorioCobradas += facturasCuotaList[i].Importe__c;
                }
            }
            
			pendienteCobro = component.get('v.record.Importe_plan_de_pagos_real__c') - sumatorioCobradas - importeTotalAbonos; //SCA se resta el importeTotalAbonos porque es un valor negativo.

            component.set('v.pendienteCobro', pendienteCobro);
            component.set('v.pendienteCobroFijo', pendienteCobro);
            //component.set('v.descuadre', component.get('v.pendienteCobro') - component.get('v.pendienteCobroFijo'));
            component.set('v.descuadre', Math.round(( SumaFacturasPendientes - component.get('v.pendienteCobroFijo'))*100 ) / 100 ) ;
            component.set('v.tamanoFacturasCuotaList', facturasCuotaList.length);
            //SCA
            /*console.log('pendienteCobro: ')
            console.log(component.get('v.pendienteCobro'))
            console.log('pendienteCobroFijo: ')
            console.log(component.get('v.pendienteCobroFijo'))
            console.log('sumatorioCobradas: ')
            console.log(sumatorioCobradas);
            console.log('importeTotalAbonos: ')
            console.log(importeTotalAbonos);
            console.log('SumaFacturasPendientes: ')
            console.log(SumaFacturasPendientes);*/
           
        });
        $A.enqueueAction(action);  
	},
    
	doInit2: function(component) {
	    var action = component.get('c.getCuotas');
        action.setParams({oportunidadId : component.get('v.recordId'), tipoCuota : 'Cuota Extra'});
    
    	// Set up the callback
    	var self = this;
    	action.setCallback(this, function(actionResult) {
        	component.set('v.facturasCuotaExtraList', actionResult.getReturnValue());
			var facturasCuotaExtraList = component.get('v.facturasCuotaExtraList');
            
            var pendienteCobro = 0;
            for (var i = 0; i < facturasCuotaExtraList.length; i++) { 
                if(facturasCuotaExtraList[i].Fecha_de_emision__c != null){
              		facturasCuotaExtraList[i].Fecha_de_emision__c = facturasCuotaExtraList[i].Fecha_de_emision__c.substring(5, 7) +'/'+ facturasCuotaExtraList[i].Fecha_de_emision__c.substring(0, 4);                   
                }
                if(facturasCuotaExtraList[i].Estado_de_la_factura__c =='Pendiente de emisión'){
                	pendienteCobro += facturasCuotaExtraList[i].Importe__c;                    
                }
            }
            
            component.set('v.pendienteCobroExtra', pendienteCobro);
            component.set('v.pendienteCobroFijoExtra', pendienteCobro);
            component.set('v.descuadreExtra', component.get('v.pendienteCobroExtra') - component.get('v.pendienteCobroFijoExtra'));
            component.set('v.tamanoFacturasCuotaExtraList', facturasCuotaExtraList.length);
			//SCA
            /*console.log('pendienteCobroExtra: ')
            console.log(component.get('v.pendienteCobroExtra'))
            console.log('pendienteCobroFijoExtra: ')
            console.log(component.get('v.pendienteCobroFijoExtra'))*/
            
           
        });
        $A.enqueueAction(action);           
        
        
        
	},
})