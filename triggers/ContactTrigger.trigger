trigger ContactTrigger on Contact (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        for(Contact conRecord : Trigger.new){
            if(conRecord.AccountId == null){
                conRecord.addError('Parent Info is Mandatory for contact creation');
            }
        }
    }
}