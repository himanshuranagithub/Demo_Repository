trigger TaskTriggerT on Task (before insert) {
    if(Trigger.isbefore && Trigger.isInsert){
        TaskTriggerHandlerT.updatePriority(Trigger.New);
    }
}