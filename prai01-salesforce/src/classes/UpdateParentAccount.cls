/*
Since @future methods are limited to primitive data types (or arrays or collections of primitives), queueable Apex is an ideal choice.

*/
public class UpdateParentAccount implements Queueable {

    private List<Account> accounts;
    private Id parent;
    
    public UpdateParentAccount(List<Account> records, ID id) {
        this.accounts = records;
        this.parent = id;    
    }
    
    public void execute(QueueableContext context) {
        for (Account account: accounts) {
            account.parentId = parent;
            //perform other processing or callout
            }
        update accounts;
      }
}

/*
--Run this Apex code in anonymous window

try
{
List<Account> accounts = [SELECT Id FROM account WHERE billingState != 'NY' and name != 'ACME Corp'];
Id parentId = [SELECT Id from account where name = 'ACME Corp'][0].Id;
UpdateParentAccount updateJob = new UpdateParentAccount(accounts, parentId);
Id jobId = System.enqueueJob(updateJob);

System.debug('jobId=' + jobId);
    
} catch (Exception e) {
    System.debug('Encountered Error:' + e.getMessage());
}

*/