// This is the batch job which iterates over all the CA Owner account with status 'Included' or
// 'change Requested' and determines the list to send out reminder email notification to 
// the email alias on the parent acccount. If the email alias info is not available on the parent account
// then we need to send out the email notification to the Contact whose record type is Primary POC in 
// the TO address and all other contacts whose record type is POC in the CC address
 

global class AuditReminderBatch implements Database.Batchable<sObject>
{

    // this method fetches the records for which the execute method would be executed. 
    // we fetch all the root accounts where reminder days is greater than zero
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id, CA_Email_Alias_1__c, CA_Email_Alias_2__c,name FROM Account where Type=\'Owner\' and  status__c in (\'Included\',\'Change Requested\')  ';
        system.debug('query='+query);
        return Database.getQueryLocator(query);
    }
     
    // this method is executed for each batch of records returned by the start() method.
    // we delegate the batch to the helper class which takes care of the logic to 
    // send out email notification based on the data available on parent/root account 
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        
         AuditReminderBatchHelper.processRootAccount(scope);
     
    }   
    
    // implementation of the finish method . As of now we do not do 
    // any processing once the batch is finished executing
    global void finish(Database.BatchableContext BC)  { 
    
    }
    
   
}