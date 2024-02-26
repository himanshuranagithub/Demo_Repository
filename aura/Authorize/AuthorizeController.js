({
    doInit : function(component, event, helper) {
        
        var recordId = component.get("v.recordId");
        
        var action = component.get("c.getRecord"); 
        action.setParams({
            recordId : recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Handle a successful response
                var result = response.getReturnValue();
                component.set("v.baseURL", result);
                
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
    
    authorize : function (component, event, helper) {
        
        var recordId = component.get("v.recordId");
        var baseURL = component.get("v.baseURL");
        
        var endPointURL = baseURL + '/services/oauth2/authorize?response_type=code&client_id=3MVG9pRzvMkjMb6kEpmq7wptlUtJvzS6joZBxfmYQR2.rUN0Bv_PddbO3y1SeHsv1NzbX4bxggvK1W5Ppmbqo&redirect_uri=https://girikon177-dev-ed--c.develop.vf.force.com/apex/Auth&state='+recordId;
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": endPointURL
        });
        urlEvent.fire();
    },
    
    handleExit : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire() 
    }
})