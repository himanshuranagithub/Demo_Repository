trigger PreventDuplicateAccounts on Account (before insert) {
    Set<String> accountNames = new Set<String>();
    
    for (Account acc : Trigger.new) {
        accountNames.add(acc.Name);
    }
    
    List<Account> existingAccounts = [SELECT Name FROM Account WHERE Name IN :accountNames];
    
    Set<String> existingAccountNames = new Set<String>();
    for (Account acc : existingAccounts) {
        existingAccountNames.add(acc.Name);
    }
    
   
    for (Account acc : Trigger.new) {
        if (existingAccountNames.contains(acc.Name)) {
            acc.addError('An account with this name already exists.');
        }
    }
}