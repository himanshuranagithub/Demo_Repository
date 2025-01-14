trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> tasksToCreate = new List<Task>();

    for (Opportunity opp : Trigger.new) {
        if (opp.StageName == 'Closed Won' && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(opp.Id).StageName != 'Closed Won'))) {
            Task followUpTask = new Task(
                Subject = 'Follow Up Test Task',
                WhatId = opp.Id,
                Status = 'Not Started',
                Priority = 'Normal'
            );
            tasksToCreate.add(followUpTask);
        }
    }

    if (!tasksToCreate.isEmpty()) {
        insert tasksToCreate;
    }
}