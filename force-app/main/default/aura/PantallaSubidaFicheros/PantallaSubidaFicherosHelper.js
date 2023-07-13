({
    MAX_FILE_SIZE: 25000000, //Max file size 25 MB 
    CHUNK_SIZE: 250000,      //Chunk Max size 750Kb 
    
    //Helper para obtener valores de una picklist ------------------------------------------------------------------
    
    getCategoryFields: function(component) {
        var action = component.get('c.getCategoryFields');
        var opts = [];

        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var categoriesFields = response.getReturnValue();
                if(categoriesFields != null && categoriesFields[0] != undefined) {
                    categoriesFields[0]['options'].unshift({'text': '--- None ---', value: ''});
                    component.set('v.categories', categoriesFields);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getDependentCategories: function(component, parentCatId, level) {
        var categoriesFields = component.get('v.categories');
        var self = this;
        
        if(level - 1 < categoriesFields.length) {
            categoriesFields.forEach(function(element) {
                if(parentCatId.length == 0 && element['level'] > level - 1) element['options'] = [];
                else if(element['level'] > level - 1) element['options'] = [];
                if(element['level'] > level || (parentCatId.length == 0 && element['level'] >= level)) element['disabled'] = true;
            });
            component.set('v.categories', categoriesFields);
            
            var action = component.get('c.getDependentOptsByParentCat');
            action.setParams({
                'parentCategoryId': parentCatId
            });
            action.setCallback(this, function(response) {
                if(response.getState() == 'SUCCESS') {
                    var options = response.getReturnValue();
                    categoriesFields[level - 1]['disabled'] = false;
                    categoriesFields[level - 1]['options'] = options;
                    categoriesFields[level - 1]['options'].unshift({'text': '--- None ---', value: ''});
                    component.set('v.categories', categoriesFields);
                    self.setFileNameByCats(component, categoriesFields);
                }
            });
            $A.enqueueAction(action);
        } else self.setFileNameByCats(component, categoriesFields);
    },

    fetchPickListVal: function(component, fieldName, elementId) {
        
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                if(component.find(elementId) != undefined) {
                	component.find(elementId).set("v.options", opts);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    //helpers para guardar un archivo ------------------------------------------------------------------

    setFileNameByCats: function (component, categoriesFields) {
        var self = this;
        var fileName = '';
        var nDoc = null;
        var docCode = null;
        var parentCatName = null;
        var catName = null;
        var folderName = null;
        var catLvl1Name = null;
        var curYear = new Date().getFullYear() +'';
        var fy = curYear.charAt(2) + curYear.charAt(3);
        var files;
        if(component.find('fileId') != undefined) {
            files = component.find("fileId").get("v.files");
        }
        var fileExt = '';
        if(files.length > 0) {
            var fileNameComponents = files[0].name.split('.');
            var extPos = fileNameComponents.length - 1;
            fileExt = fileNameComponents[extPos];
        }
        
        var selectedCategories = [];
        categoriesFields.forEach(function(element) {
            var selectedOpt = element.value;
            if(selectedOpt != '') {
                element.options.forEach(function(option) {
                    if(option.value == selectedOpt) {
                        selectedCategories.push({ 
                            'level': option.level,
                            'folderName': option.folderName,
                            'docCode': option.docCode, 
                            'value': option.value, 
                            'text': option.text 
                        });
                    }
                });
            }
        });

        var prevCatName = null;
        selectedCategories.forEach(function (element) {
            if(element.level == 1) {
                catLvl1Name = element.text;
                folderName = element.folderName;
            }
            docCode = element.docCode;
            if(prevCatName != null && prevCatName != element.text) parentCatName = prevCatName + '-';
            else parentCatName = '';
            catName = element.text;
            prevCatName = element.text;
        });

        fileName = docCode + '-' + parentCatName + catName + '-' + folderName + '_' + catLvl1Name + '-' + fy + '.' + fileExt;
        component.set("v.NombreArchivo", fileName);
        
    },

    getSelectedFieldOpt: function(fieldElement) {
        var result = null;
        if(fieldElement.options != null && fieldElement.options.length > 0) {
            fieldElement.options.forEach(function(element) {
                if(fieldElement.value == element.value) {
                    result = element;
                    return;
                }
            });
        }
        return result;
    },
    
    uploadHelper: function(component, event) {
       
        // get the selected files using aura:id [return array of files]
        var fileInput;
        if(component.find("fileId") != undefined) {
            fileInput = component.find("fileId").get("v.files");
        }
        
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            
            //mensage de error
            component.set("v.nombreArchivo", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
 
        // create a FileReader object 
        var objFileReader = new FileReader();
        
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 
            fileContents = fileContents.substring(dataStart);
            
            // call the uploadProcess method 
            self.upload(component, file, fileContents);
        });
 
        objFileReader.readAsDataURL(file);
    },

    upload: function(component, file, fileContents) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE); 
        this.uploadProcess(component, file, fileContents, fromPos, toPos, '', false);
    },
 
    uploadProcess: function(component, file, fileContents, fromPos, toPos, fileId, completed) {
        var chunk = (fileContents != '') ? fileContents.substring(fromPos, toPos) : '';
       
        var params = {
            parentId: component.get("v.recordId"),
            nombreArchivo: component.get("v.NombreArchivo"),
            base64Data: encodeURIComponent(chunk),
            contentType: file.type,
            tipo: component.get("v.TipoSeleccionado"),
            posicion: component.get("v.Posicion"),
            descripcion: component.get("v.descripcion"),
            fileId: fileId,
            completed: completed
        };
        
        var categoriesFields = component.get('v.categories');
        var selectedCategories = [];
        categoriesFields.forEach(function(element) {
            var selectedOpt = element.value;
            element.options.forEach(function(option) {
                if(option.value == selectedOpt) {
                    selectedCategories.push({ 'value': option.value, 'text': option.text });
                }
            });
        });
        params['categories'] = selectedCategories;
        
        var action = component.get("c.guardarArchivo");
        action.setBackground();
        action.setParams(params);
 	
        // set call back 
        var self = this;
        action.setCallback(this, function(response) {
            fileId = response.getReturnValue();
            var state = response.getState();
            
            if (state === "SUCCESS") {
                fromPos = toPos;
                toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);

                if(fromPos < toPos) {
                    self.uploadProcess(component, file, fileContents, fromPos, toPos, fileId, false);
                } else {
                    if(!completed) self.uploadProcess(component, file, '', fromPos, toPos, fileId, true);
                    component.set("v.isOpenSpinner", false); //Cerrar spinner
                    component.set('v.isMessageOpen', true);
                    component.set('v.type', 'success');
                    component.set('v.message', 'Se ha guardado el archivo correctamente');
                    self.resetFields(component);
                }
                     
            }  else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
                self.resetFields(component);
            } else if (state === "ERROR") {
                component.set("v.isOpenSpinner", false); //Cerrar spinner
                component.set('v.isMessageOpen', true);
                component.set('v.type', 'error');
                component.set('v.message', 'Se ha producido un error');

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                self.resetFields(component);
            }
           
        });
        // enqueue the action
        $A.enqueueAction(action);
    },

    resetFields: function(component) {
        //Reiniciar valores de los campos
        if(component.find("fileId") != undefined) {
            component.find("fileId").set("v.files", null);
        }
        component.set('v.NombreArchivo', '');
        if(component.find("inputTipo") != undefined) {
        	component.find("inputTipo").set("v.value", '--- None ---');
        }
        component.set('v.Posicion', null);
        component.set('v.descripcion', null);
        component.set('v.CategoriaSeleccionada', null);
        component.set('v.objDetail.Categoria__c', null);
        component.set('v.objDetail.Subcategoria__c', null);
        component.set('v.bDisabledDependentFld', true);
    }
 
 
})