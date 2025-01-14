public class QueueableExample implements Queueable {
    
    public void execute(QueueableContext QB){
        List<Contact> con=[Select Id,LastName from Contact where Status__c != 'Closed'];
        for(Contact c : con){
            c.Status__c='Closed';
        }
        update con;
    }

}