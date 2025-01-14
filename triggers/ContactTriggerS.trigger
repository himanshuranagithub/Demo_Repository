trigger ContactTriggerS on Contact (before insert,before update,after insert, after update) {
   
        //ContactTriggerHandlerS.updateLastName(Trigger.new);
        //ContactTriggerHandlerS.preventDuplicateRecord(Trigger.new);
        //ContactTriggerHandlerS.firstNameNotEqualLastName(Trigger.new);
        //ContactTriggerHandlerS.preventDuplicateRecord1(Trigger.new);
    if(Trigger.isAfter && Trigger.isInsert){
        ContactTriggerHandlerS.countAccountOfContact(Trigger.new);
    }
        
        
        
    
    
}