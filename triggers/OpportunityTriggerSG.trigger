trigger OpportunityTriggerSG on Opportunity (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        OppertunityTriggerHandlerSG.updateDescription(Trigger.new);
    }
}