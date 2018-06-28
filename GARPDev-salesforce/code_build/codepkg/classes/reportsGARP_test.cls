@isTest
private class reportsGARP_test{

   
    
    static testMethod void myUnitTest_1() {

         //RecordType rt = [select id from RecordType where SobjectType='Opportunity' and IsActive=true limit 1];
         //insert rt;
         insert new Updateids__c(Name='GARP',Record_id__c = 'a0A4000000uA1fU'); 
          // a1lf000000045VS a0A4000000uA1fU 
          Account acc = new Account(name='Test Account');
          insert acc;
          Opportunity opp = new Opportunity(accountId = acc.id,Auto_Renew__c = true,ChargentSFA__Payment_Status__c='Recurring Intent',Company__c = 'GARP',ChargentSFA__Payment_Frequency__c='Once',name='Test Name',StageName='New',CloseDate=system.today().addDays(2),ChargentSFA__Charge_Amount__c=95);
        insert opp;
          ChargentSFA__Transaction__c obj = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.Id,ChargentSFA__Type__c='Charge',ChargentSFA__Response_Status__c='Approved');
        insert obj;
          Contact ct = new Contact(firstName='Fname',LastName='LName',KPI_FRM_Certified__c=true,accountId = acc.Id,Email='Test@Test.com');
          insert ct;
        
        Product_Refunds__c pr = new Product_Refunds__c(Opportunity__c=opp.Id,Payment_Transaction__c=obj.Id);
        insert pr;
        test.startTest();
        reportsGARP rt = new reportsGARP();
        Date start1Date = System.today().addDays(-5);
        Date end1Date = System.today().addDays(2);
        String startDate = '12345678';//string.valueOf(start1Date);
         String endDate = '1234567890';//string.valueOf(end1Date);
        reportsGARP.getRefunds(startDate,endDate);
        reportsGARP.getProducts('01sf00000008rTn');
        reportsGARP.getReportData(startDate,endDate, True, False, False);


        test.stopTest();
    }
}