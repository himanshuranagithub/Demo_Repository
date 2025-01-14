trigger TaskTrigger on Task (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        for(Task taskRecord : Trigger.new){
			taskRecord.Priority='High';            
        }
    }
}