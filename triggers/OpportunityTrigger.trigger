trigger OpportunityTrigger on Opportunity (after update){
    if(Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHandler.handleActivitiesAfterUpdate(Trigger.new);
        
    }

}