global class Datacompletionbatch11 implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        date dtToday = system.today();
        if(!test.isRunningTest()){
            return Database.getQueryLocator('select AccountId,id,FirstName,LastName,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,GARP_Member_ID__c from Contact where GARP_Member_ID__c != null');
        }
        return Database.getQueryLocator('select id,accountId,createdDate,FirstName,LastName,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,GARP_Member_ID__c from Contact where GARP_Member_ID__c != null and && con.accountId == null limit 10');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        List<Account> lstAccounts = new List<Account>();
        Map<String,Account> mapAccounts = new Map<String,Account>();
        List<Contact> lstCons = new List<Contact>();
        for(Contact con : scope)
        {
            //if(con.GARP_Member_ID__c != null && con.createdDate == system.today() && con.accountId == null)
            //{
                Account acc = new Account();
                if(con.accountId != null)  acc.Id = con.accountId;
                acc.Name = con.FirstName+con.LastName;
                acc.BillingStreet = con.MailingStreet;
                acc.BillingCity = con.MailingCity;
                acc.BillingState = con.MailingState;
                acc.BillingPostalCode = con.MailingPostalCode;
                acc.BillingCountry = con.MailingCountry;
                acc.ShippingStreet = con.MailingStreet;
                acc.ShippingCity = con.MailingCity;
                acc.ShippingState = con.MailingState;
                acc.ShippingPostalCode = con.MailingPostalCode;
                acc.ShippingCountry = con.MailingCountry;
                acc.GARP_ID__c = con.GARP_Member_ID__c;
                mapAccounts.put(acc.GARP_ID__c ,acc);
                //lstCons.add(con);
            //}
        }
        
        upsert mapAccounts.values();
        List<Contact> lstContactsWithAccounts = [select id,accountId,FirstName,LastName,GARP_Member_ID__c from contact where id in: scope];
        for(Contact conUpdate : lstContactsWithAccounts)
        {
            conUpdate.accountId = mapAccounts.get(conUpdate.GARP_Member_ID__c).Id;
            
        }
        
        update lstContactsWithAccounts;

    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}