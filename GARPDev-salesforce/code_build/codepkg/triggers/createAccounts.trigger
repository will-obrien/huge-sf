trigger createAccounts on Contact (after insert) {




    List<Contact> lstContacts = new List<Contact>();
    for(Contact ct : trigger.new)
    {
        if(ct.GARP_Member_ID__c != null)
        {
            lstContacts.add(ct);
        }
    }
    
    
    if(lstContacts.size() > 0)
    {
        List<Account> lstAccounts = new List<Account>();
        Map<String,Account> mapAccounts = new Map<String,Account>();
        for(Contact con : lstContacts)
        {
        
            Account acc = new Account();
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
        }
        
        insert mapAccounts.values();
        List<Contact> lstContactsWithAccounts = [select id,FirstName,LastName,GARP_Member_ID__c from contact where id in: lstContacts];
        for(Contact conUpdate : lstContactsWithAccounts)
        {
            conUpdate.accountId = mapAccounts.get(conUpdate.GARP_Member_ID__c).Id;
            
        }
        
        update lstContactsWithAccounts;
    
    }}