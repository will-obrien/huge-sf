@isTest
private class CreateRecurringOpps_test{

   
    
    static testMethod void myUnitTest_1() {

         //RecordType rt = [select id from RecordType where SobjectType='Opportunity' and IsActive=true limit 1];
         //insert rt;
         insert new Updateids__c(Name='GARP',Record_id__c = 'a0A4000000uA1fU'); 
          Account acc = new Account(name='Test Account');
          insert acc;
        Opportunity opp = new Opportunity(accountId = acc.id,Auto_Renew__c = true,ChargentSFA__Payment_Status__c='Recurring',Company__c = 'GARP',ChargentSFA__Payment_Frequency__c='Once',name='Test Name',StageName='New',CloseDate=system.today().addDays(2),ChargentSFA__Charge_Amount__c=195);
        insert opp;

         Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'MEMI',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
       
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
    
        ChargentSFA__Transaction__c obj = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.Id,ChargentSFA__Type__c='Charge',ChargentSFA__Response_Status__c='Approved');
        insert obj;
        
        test.startTest();
        CreateRecurringOpps.CreateOpps(new Set<Id>{opp.Id},new List<ChargentSFA__Transaction__c>{obj});
        test.stopTest();
    }
}