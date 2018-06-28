@isTest
private class chargemodificationsonopp_test{

   
    
    static testMethod void myUnitTest_1() {

         //RecordType rt = [select id from RecordType where SobjectType='Opportunity' and IsActive=true limit 1];
         //insert rt;
         insert new Updateids__c(Name='GARP',Record_id__c = 'a0A4000000uA1fU');
         // a1lf000000045VS a0A4000000uA1fU 
          Account acc = new Account(name='Test Account');
          insert acc;
          Contact ct = new Contact(firstName='Fname',LastName='LName',KPI_FRM_Certified__c=true,accountId = acc.Id,Email='Test@Test.com');
          insert ct;
        Opportunity opp = new Opportunity(accountId = acc.id,Auto_Renew__c = true,ChargentSFA__Payment_Status__c='Recurring Intent',Company__c = 'GARP',ChargentSFA__Payment_Frequency__c='Once',name='Test Name',StageName='New',CloseDate=system.today().addDays(2),ChargentSFA__Charge_Amount__c=95);
        insert opp;
        Id memRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
        Contract  cpeCon = new Contract();
            cpeCon.Name = 'Test Contract';
            cpeCon.accountId = acc.Id;
            cpeCon.startDate = system.today();
            cpeCon.recordTypeId = memRecordTypeID;
            cpeCon.Status = 'Draft';
            cpeCon.Membership_Type__c = 'Student';
            insert cpeCon;

            //cpeCon.Status = 'Activated ( Auto-Renew )';
            //update cpeCon;
        ChargentSFA__Transaction__c obj = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.Id,ChargentSFA__Type__c='Charge',ChargentSFA__Response_Status__c='Approved');
        insert obj;
        
        test.startTest();
        Database.ExecuteBatch(new chargemodificationsonopp());
        test.stopTest();
    }
}