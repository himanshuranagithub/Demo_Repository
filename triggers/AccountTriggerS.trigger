trigger AccountTriggerS on Account (after update, before insert, after delete) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        //AccountTriggerHandlerS.updatebillingAddress(Trigger.new);
        //AccountTriggerHandlerS.updateEmail(Trigger.new);
        AccountTriggerHandlerS.updateMailingAddress(Trigger.new);
    }
    
    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandlerS.matchBillingAddress(Trigger.new);
    }
    
    if (Trigger.isBefore && Trigger.isDelete) {
        AccountTriggerHandlerS.deleteContactAndOpportunity(Trigger.old);
    }
}