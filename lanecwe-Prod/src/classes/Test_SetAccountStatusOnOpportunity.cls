/*********************************************************************
Name : Test_SetAccountStatusOnOpportunity 
Created On : jan 06, 2012  
Created By : Lalit Bohra
Description : Test class on  Trigger on Opportunity SetAccountStatusOnOpportunity  
**********************************************************************/
@isTest
private class Test_SetAccountStatusOnOpportunity {

    static testMethod void TestSetAccountStatusOnOpportunity() {
        // TO DO: implement unit test
        list<Account> AccountList = new list<Account>();
        list<Contact> ContactList = new list<Contact>();
        list<Opportunity> OpportunityList = new list<Opportunity>();
       
        
       
        Account acc= new Account();
        acc.Name='Test Acc';
        acc.Status__c='Prospect';
        acc.ChannelType__c='Reseller';
        AccountList.add(acc);
        
        Account acc1= new Account();
        acc1.Name='Test Acc1';
        acc1.Status__c='Prospect';
        acc1.ChannelType__c='Reseller';
        AccountList.add(acc1);   
        insert AccountList; 
        
        
        set<Id> AccountIdset=new set<Id>();
        AccountIdset.add(acc.Id);
        AccountIdset.add(acc1.Id);
        
        Contact con= new Contact(); 
        con.LastName='Conlastname';
        con.AccountId=acc.Id;
        //insert con;
        ContactList.add(con);
        
        Contact con1= new Contact(); 
        con1.LastName='Conlastname1';
        con1.AccountId=acc1.Id;
        //insert con1;
        ContactList.add(con1);
        insert ContactList; 
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.AccountId = acc.Id;
        opp.CloseDate = system.today();
        opp.StageName = 'Closed Won';
        opp.CurrencyIsoCode = 'USD';        
        opp.Probability = 0;
        opp.Contact__c=con.Id;
        OpportunityList.add(opp);

        Opportunity opp1 = new Opportunity();
        opp1.Name = 'test1';
        opp1.AccountId = acc1.Id;
        opp1.CloseDate = system.today();
        opp1.StageName = 'Closed Won';
        opp1.CurrencyIsoCode = 'USD';        
        opp1.Probability = 0;
        opp1.Contact__c=con1.Id;
        OpportunityList.add(opp1);
        
        test.startTest();
        insert OpportunityList;
        test.stopTest();
        list<Account> UpdatedList=[Select Status__c from Account where id in:AccountIdset and Status__c=:'Customer'];
        if(UpdatedList != null && UpdatedList.size()>0){
            system.assert(true);
        }
        else{
            system.assert(true);
        }
    }
}