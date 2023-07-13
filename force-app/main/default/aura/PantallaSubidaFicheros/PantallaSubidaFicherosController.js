({
    
    //---------------------------------PickList dependiente --------------------------------
        
        getDependentCategories: function(component, event, helper) {
            var parentCatId = event.getSource().get('v.value');
            var level = parseInt(event.getSource().get('v.name').split('_')[1]) + 1;
            
            helper.getDependentCategories(component, parentCatId, level);
        },
        
    //Controladores para ventana modal ------------------------------------------------------
        
        openModel: function(component, event, helper) {
              //for Display Model,set the "isOpen" attribute to "true"
            component.set("v.isOpen", true);
    
            //Recuperar valores de la picklist
            helper.fetchPickListVal(component, 'Tipo__c', 'inputTipo');
            
            // Obtenemos los campos de categorías
            helper.getCategoryFields(component);
       },
     
       closeModel: function(component, event, helper) {
            // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
            component.set("v.isOpen", false);
           
            //Reiniciar valores de los campos
           	if(component.find("fileId") != undefined){
            	component.find("fileId").set("v.files") == null;
       		}
            component.set('v.NombreArchivo', '');
           	if(component.find("inputTipo") != undefined){
            	component.find("inputTipo").set("v.value") == '--- None ---';
           	}
            component.set('v.Posicion', null);
            component.set('v.descripcion', null);
            component.set('v.CategoriaSeleccionada', null);
            component.set('v.objDetail.Categoria__c', null);
            component.set('v.objDetail.Subcategoria__c', null);
            component.set('v.bDisabledDependentFld', true);
       },
        
        
        
    //Controlador para recuperar valores del tipo de contentVersion --------------------------------
        
        onPicklistChange: function(component, event, helper) {
            
            component.set('v.isMessageOpen', false);
            
            
            if(event.getSource().getLocalId() == 'inputTipo'){
                
                component.set("v.TipoSeleccionado", event.getSource().get("v.value"));
                
                if(event.getSource().get("v.value") == 'Imagen_carrusel'){                
                    component.set('v.isImageCarrusel', true);
                }
                else{
                    component.set('v.isImageCarrusel', false);
                }
            }   
        },
        
    //Controlador para guardar el archivo --------------------------------------------------------
    
        doSave: function(component, event, helper) {
            component.set('v.isMessageOpen', false);
            
            if (component.find("fileId") != undefined && component.find("fileId").get("v.files") != null){
                
                if(component.find("fileId").get("v.files").length > 0){
                    
                    if(component.get("v.TipoSeleccionado") != null 
                       && component.get("v.TipoSeleccionado") != ""
                       && component.get("v.NombreArchivo") != null
                       && component.get("v.NombreArchivo") != ''){
                        
                        component.set("v.isOpenSpinner", true); //Abrir spinner

                        var categoriesFields = component.get('v.categories');
                        helper.setFileNameByCats(component, categoriesFields);
                        helper.uploadHelper(component, event);
                    }
                    else if((component.get("v.TipoSeleccionado") == null || component.get("v.TipoSeleccionado") == "" )
                       &&(component.get("v.NombreArchivo") == null || component.get("v.NombreArchivo") == '')){
                        
                         component.set('v.isMessageOpen', true);
                         component.set('v.type', 'warning');
                         component.set('v.message', 'Debe seleccionar un tipo y un nombre');
                    }
                    else if((component.get("v.TipoSeleccionado") == null 
                       || component.get("v.TipoSeleccionado") == "" )
                       && (component.get("v.NombreArchivo") != null
                       || component.get("v.NombreArchivo") != '')){
                        
                         component.set('v.isMessageOpen', true);
                         component.set('v.type', 'warning');
                         component.set('v.message', 'Debe seleccionar un tipo');
                    }
                    else if((component.get("v.TipoSeleccionado") != null 
                       || component.get("v.TipoSeleccionado") != "" )
                       && (component.get("v.NombreArchivo") == null
                       || component.get("v.NombreArchivo") == '')){
                        
                         component.set('v.isMessageOpen', true);
                         component.set('v.type', 'warning');
                         component.set('v.message', 'Debe rellenar el nombre');
                    }   
                }
                else{
                    
                    component.set('v.isMessageOpen', true);
                    component.set('v.type', 'warning');
                    component.set('v.message', 'Debe seleccionar un archivo válido');
                }   
            } 
            else {
                
               component.set('v.isMessageOpen', true);
               component.set('v.type', 'warning');
               component.set('v.message', 'Debe seleccionar un archivo');
            }
        }
        
    })