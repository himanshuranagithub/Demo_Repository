trigger CaseTrigger on Case (before insert) {
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Case caseRecord : Trigger.new){
            if(caseRecord.Origin == 'Phone'){
                caseRecord.Priority='High';
            }else{
                caseRecord.Priority='Low';
            }
        }
    }
}