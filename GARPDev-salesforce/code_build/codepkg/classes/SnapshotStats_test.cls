@isTest
private class SnapshotStats_test{

   
    
    static testMethod void myUnitTest_1() {

         //RecordType rt = [select id from RecordType where SobjectType='Opportunity' and IsActive=true limit 1];
         //insert rt;
         //insert new Updateids__c(Name='GARP',Record_id__c = 'a1lf000000045VS'); 
          Account acc = new Account(name='Test Account');
          insert acc;
          Contact ct = new Contact(firstName='Fname',LastName='LName',KPI_FRM_Certified__c=true,accountId = acc.Id,Email='Test@Test.com');
          insert ct;
        
        test.startTest();
        SnapshotStats st = new SnapshotStats();
        st.SnapshotStats();
        test.stopTest();
    }
}