({
    authorize : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9pRzvMkjMb6kEpmq7wptlUtJvzS6joZBxfmYQR2.rUN0Bv_PddbO3y1SeHsv1NzbX4bxggvK1W5Ppmbqo&redirect_uri=https://girikon177-dev-ed--c.develop.vf.force.com/apex/Auth"
        });
        urlEvent.fire();
    },
    
    test: function (component, event, helper) {
        var consumerKey = component.get("v.consumerKey");
        var consumerSecret = component.get("v.consumerSecret");
        var username = component.get("v.username");
        var password = component.get("v.password");
        var securityToken = component.get("v.securityToken");
        alert('s');
        var action = component.get("c.authenticate");
        action.setParams({
            "consumerKey": consumerKey,
            "consumerSecret": consumerSecret,
            "username": username,
            "password": password,
            "securityToken": securityToken
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Handle success, e.g., show a confirmation message
                alert("Authorization successful!");
            } else {
                // Handle errors, e.g., display an error message
                alert("Authorization failed: " + response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    }
})