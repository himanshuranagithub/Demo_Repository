trigger LeadTrigger on Lead (before update,after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
    	LeadTriggerHandler.handleActivitiesAfterUpdate(Trigger.new);
        
    }

    if(Trigger.isUpdate){
        for(Lead leadRecord : Trigger.new){
            leadRecord.Status='Working-Contacted';
        }
    }

}