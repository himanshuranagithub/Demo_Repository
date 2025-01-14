trigger TriggerOnLead on Lead (before insert, after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        List<Task> tskList = new List<Task>();
        for (Lead ld : Trigger.new) {
            Task t = new Task();
            t.OwnerId = ld.OwnerId;
            t.Status = 'Open';
            t.Subject = 'Related to new Opportunity';
            t.Description = 'This task is related to the new Lead created.';
            t.WhatId = ld.Id;
            tskList.add(t);
        }
        if (!tskList.isEmpty()) {
            insert tskList;
        }
    }
}