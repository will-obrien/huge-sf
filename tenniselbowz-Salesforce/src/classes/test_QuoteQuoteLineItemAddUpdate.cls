@isTest 

private class test_QuoteQuoteLineItemAddUpdate {

static testMethod void testQuoteQuoteLineItemAddUpdate(){

/*Account a = [select Id from Account limit 1];*/
Account a = new Account();
a.Name = 'Test Account';
a.Type = 'Architect';
a.Industry = 'Healthcare';

insert a; 

PricebookEntry pb = [select Id,Pricebook2Id from PricebookEntry where IsActive = true limit 1];
Opportunity o = new Opportunity();
OpportunityLineItem oi = new OpportunityLineItem();
Quote q = new Quote();
QuoteLineItem qi = new QuoteLineItem();

o.AccountId = a.ID;
o.Name = 'test';
o.StageName = 'D-Proposal/Bid-Not Daikin Specified';
o.CloseDate = date.today();
o.Vertical_Market__c = 'Healthcare';
insert o;

oi.OpportunityId = o.Id;
oi.Quantity = 1;
oi.UnitPrice = 2.00;
oi.PricebookEntryId = pb.Id;

insert oi;

o.StageName= 'Order-Won-Crdt Release, Submittal signed';
o.Won_Lost_Reason__c = 'Price';
update o;

oi.Quantity = 2;
update oi;

q.Name = 'test';
q.OpportunityId = o.Id;
q.Pricebook2Id = pb.Pricebook2Id;
q.Equipment_With_F_L__c = 1.00;
q.Local_Equipment_With_F_L__c = 1.00;
q.Total_Logistics_Add_On__c = 1.00;
q.Total_Outsource_Add_On__c = 1.00;
q.Total_Start_up_Add_On__c = 1.00;
q.Total_Service_Add_On__c = 1.00;
q.Total_Equipment_Price_FOB__c = 1.00;
q.Total_Base_Equipment_Cost__c = 1.00;

insert q;

qi.QuoteId = q.Id;
qi.PricebookEntryId = pb.Id;
qi.Quantity = 2;
qi.UnitPrice = 2.00;
qi.Local_Currency__c = 'USD';
qi.Selling_Unitary_Freight_Logistic__c = 1.00;
qi.Unitary_Selling_Price_w_Log_Disc__c = 1.00;
qi.Total_Selling_Price_w_Log_Disc__c = 1.00;
qi.Selling_Unitary_Equipment_Price_FOB__c = 1.00;
qi.Selling_Total_Equip_Price_FOB__c = 1.00;
qi.Equipment_With_F_L__c = 1.00;

insert qi;

qi.Quantity = 3;
qi.UnitPrice = 4000.00;
qi.Local_Currency__c = 'MEX';
qi.Selling_Unitary_Freight_Logistic__c = 2000.00;
qi.Unitary_Selling_Price_w_Log_Disc__c = 2000.00;
qi.Total_Selling_Price_w_Log_Disc__c = 2000.00;
qi.Selling_Unitary_Equipment_Price_FOB__c = 2000.00;
qi.Selling_Total_Equip_Price_FOB__c = 2000.00;
qi.Equipment_With_F_L__c = 2000.00;

update qi;

q.Name = 'test-update';
q.Equipment_With_F_L__c = 2000000.00;
q.Local_Equipment_With_F_L__c = 2000000.00;
q.Total_Logistics_Add_On__c = 2000000.00;
q.Total_Outsource_Add_On__c = 2000000.00;
q.Total_Start_up_Add_On__c = 2000000.00;
q.Total_Service_Add_On__c = 2000000.00;
q.Total_Equipment_Price_FOB__c = 2000000.00;
q.Total_Base_Equipment_Cost__c = 2000000.00;

update q;

delete qi;
update q;
delete q;
delete oi;
delete o;

}
}