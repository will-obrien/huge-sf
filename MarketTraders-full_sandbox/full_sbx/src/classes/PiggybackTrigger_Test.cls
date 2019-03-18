@isTest
private class PiggybackTrigger_Test {
/*
    static testMethod void testOpp() 
    {
        Account a = new Account();
        a.FirstName = 'test';
        a.LastName = 'acc';
        a.pb_SubBegin_Charting__c = Date.today(); 
        a.pb_CurrSubBeg_Charting__c = Date.today(); 
        a.pb_SubEnd_Charting__c = Date.today(); 
        a.pb_PrevSubEnd_Charting__c = Date.today(); 
        insert a;

        Account a2 = new Account();
        a2.FirstName = 'test';
        a2.LastName = 'acc';
        a2.pb_SubBegin_Charting__c = Date.today(); 
        a2.pb_CurrSubBeg_Charting__c = Date.today(); 
        a2.pb_SubEnd_Charting__c = Date.today(); 
        a2.pb_PrevSubEnd_Charting__c = Date.today(); 
        insert a2;
        
        Profile p = [select id from profile where name='Standard User'];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id,
        timezonesidkey='America/Los_Angeles', username='standarduser@testorg.com');
        
       
        List<Opportunity> l = new List<Opportunity>();
         
        Opportunity o = New  Opportunity();
        o.Name = 'Test opp';
        o.Product__c = 'Charting';
        o.StageName = 'Closed Won';
        o.Sale_Invoice_First_Date_After_Down__c = Date.today();
        o.Sale_Invoice_Qty_Payments_After_Down__c = 1;
        o.Sub_Stage__c = 'Cancelled';
        o.Amount = 200.00;
        o.AccountId = a.id;
        o.CloseDate = Date.today();
        o.Charting_Start__c = Date.today(); 
        o.Charting_Expiration__c = Date.today(); 
        o.Purchase_Amount__c = 1234.56; 
        
        l.add(o);
        insert o;
        
        Opportunity o2 = New  Opportunity();
        o2.Name = 'Test opp';
        o2.Product__c = 'UTP OnDemand';
        o2.StageName = 'Refund';
        o2.Sub_Stage__c = '';
        o2.Amount = 200.00;
        o2.AccountId = a.id;
        o2.CloseDate = Date.today();
        o2.Promotions_Received__c = 'abc; 123; xyz 3;';
        l.add(o2);
        insert l;

        Opportunity o3 = New  Opportunity();
        o3.Name = 'Test opp 3';
        o3.StageName = 'Closed Won';
        o3.Sub_Stage__c = 'Paid';
        o3.Sale_Invoice_First_Date_After_Down__c = Date.today();
        o3.Sale_Invoice_Qty_Payments_After_Down__c = 1;
        o3.Amount = 200.01;
        o3.AccountId = a.id;
        o3.CloseDate = Date.today().addYears(-1);
        o3.Purchase_Amount__c = 1234.51; 
        o3.LeadSource = '1_on_1';
        insert o3;https://cs20.salesforce.com/_ui/common/apex/debug/ApexCSIPage#

        Opportunity o4 = New  Opportunity();
        o4.Name = 'Test opp 4';
        o4.Product__c = 'Charting';
        o4.StageName = 'Closed Won';
        o4.Sub_Stage__c = '';
        o4.Sale_Invoice_First_Date_After_Down__c = Date.today();
        o4.Sale_Invoice_Qty_Payments_After_Down__c = 1;
        o4.Amount = 200.09;
        o4.AccountId = a.id;
        o4.CloseDate = Date.today();
        o4.Charting_Start__c = Date.today(); 
        o4.Charting_Expiration__c = Date.today(); 
        o4.Purchase_Amount__c = 1244.56; 
        l.add(o4);

    }
*/
}