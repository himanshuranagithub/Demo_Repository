({
    changeStatus : function(component, event, helper) {
        var selectedOption = component.find("mytaskSelect").get("v.value");
        console.log('Selected option: ', selectedOption);
    }
})