trigger AccountTrigger on Account (before update) {
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Account acc : Trigger.new){
            if(acc.Industry == 'Agriculture' && Trigger.oldMap.get(acc.Id).Ownership != acc.Ownership && acc.Ownership == 'Private'){
                acc.addError('Ownership cannot be private');
            }
        }
    }

}