@isTest
private class AfterPayment_test{

   
    
    static testMethod void myUnitTest_1() {

         //RecordType rt = [select id from RecordType where SobjectType='Opportunity' and IsActive=true limit 1];
         //insert rt;
       test.startTest();
         insert new Updateids__c(Name='GARP',Record_id__c = 'a0A4000000uA1fU'); 
         //01sf00000008rTn a0A4000000uA1fU
          Account acc = new Account(name='Test Account');
          insert acc;
        Opportunity opp = new Opportunity(accountId = acc.id,Auto_Renew__c = true,ChargentSFA__Payment_Status__c='Recurring',Company__c = 'GARP',ChargentSFA__Payment_Frequency__c='Once',name='Test Name',StageName='New',CloseDate=system.today().addDays(2),ChargentSFA__Charge_Amount__c=195);
        insert opp;

       
        
    
        ChargentSFA__Transaction__c obj = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.Id,ChargentSFA__Type__c='Charge',ChargentSFA__Response_Status__c='Approved');
        insert obj;

         ChargentSFA__Transaction__c obj1 = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.Id,ChargentSFA__Type__c='Void',ChargentSFA__Response_Status__c='Approved');
        insert obj1;
        
       
        
        test.stopTest();
    }
}