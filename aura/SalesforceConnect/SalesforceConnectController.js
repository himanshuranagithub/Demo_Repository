({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.getAuthorizedOrgs"); 
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Handle a successful response
                var result = response.getReturnValue();
                component.set("v.orgOptions", result);
                
            } else if (state === "ERROR") {
                // Handle an error response
                var errors = response.getError();
                if (errors) {
                    for (var error in errors) {
                        console.log("Error message: " + errors[error].message);
                    }
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    orgSelectChange: function (component, event, helper) {
        var selectedOrg = component.get("v.selectedOrg");
        var getMetadataButton = component.find("getMetadataButton");
        
        // Enable the button if a valid option is selected
        if (selectedOrg !== "") {
            getMetadataButton.set("v.disabled", false);
        } else {
            getMetadataButton.set("v.disabled", true);
        }
    },
    
    getSobjects : function(component, event, helper) {
        
        component.set("v.showspinner",true);
        
        var recordId = component.get("v.selectedOrg");
        
        var action = component.get("c.getsObjectList"); 
        
        action.setParams({
            recordId : recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                // Hide spinner
                component.set("v.showspinner",false);
                
                // Hide metadata picklist section
                component.set("v.showmetadatalist",true);
                
                // Handle a successful response
                var result = response.getReturnValue();
                
                // Set response value to metaOrgOptions
                component.set("v.metaOrgOptions", result);
                
                // Show success message
                showSuccess(component, event, 'Success');
                
            } else if (state === "ERROR") {
                component.set("v.showspinner",false);
                component.set("v.showmetadatalist",false);
                // Handle an error response
                var errors = response.getError();
                if (errors) {
                    for (var error in errors) {
                        console.log("Error message: " + errors[error].message);
                    }
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    sObjectChange: function (component, event, helper) {
        
        var selectedobject = component.get("v.selectedsObject");
        var selectedOrg = component.get("v.selectedOrg");
        
        if(selectedobject !== ''){
            
            component.set("v.showspinner",true);
            
            var recordId = component.get("v.selectedOrg");
            
            var action = component.get("c.getsObjecFields"); 
            
            action.setParams({
                recordId : selectedOrg,
                objectName :selectedobject
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    // Hide spinner
                    component.set("v.showspinner",false);
                    
                    // Hide metadata picklist section
                    component.set("v.showmetadatalist",true);
                    
                    // Handle a successful response
                    var result = response.getReturnValue();
                    
                    // Set response value to metaOrgOptions
                    component.set("v.sObjectFields", result);
                    
                    // Show success message
                    showSuccess(component, event, 'Success');
                    
                } else if (state === "ERROR") {
                    component.set("v.showspinner",false);
                    component.set("v.showmetadatalist",false);
                    // Handle an error response
                    var errors = response.getError();
                    if (errors) {
                        for (var error in errors) {
                            console.log("Error message: " + errors[error].message);
                        }
                    }
                }
            });
            
            $A.enqueueAction(action);
        }
    },
    
    selectAll: function (component, event, helper) {
        var selectedRows = component.get("v.selectedRows");
        var allRows = component.get("v.sObjectFields");

        var selectAllCheckbox = component.find("selectAllCheckbox").get("v.value");

        allRows.forEach(function (row) {
            row.selected = selectAllCheckbox;
            if (selectAllCheckbox) {
                selectedRows.push(row);
            } else {
                selectedRows = [];
            }
        });

        component.set("v.selectedRows", selectedRows);
        component.set("v.data", allRows);
    },
    
    showSuccess : function(component, event, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: msg,
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    showError : function(component, event, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: msg,
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    }
})