trigger OpportunityTriggerT on Opportunity (before insert,before update,after insert , after update) {
    if(Trigger.isAfter){
        OpportunityTriggerHandlerT.createTask(Trigger.New);
    }
    if((trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
         OpportunityTriggerHandlerT.updateOpportunity(Trigger.new, Trigger.oldMap);
    }
}