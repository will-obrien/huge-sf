@isTest
private class examptAttempts_test{

   
    
    static testMethod void myUnitTest_1() {

         //RecordType rt = [select id from RecordType where SobjectType='Opportunity' and IsActive=true limit 1];
         //insert rt;
         insert new Updateids__c(Name='GARP',Record_id__c = 'a1lf000000045VS'); 
          Account acc = new Account(name='Test Account');
          insert acc;
          Contact ct = new Contact(firstName='Fname',LastName='LName',KPI_FRM_Certified__c=true,accountId = acc.Id,Email='Test@Test.com');
          insert ct;
        /*Opportunity opp = new Opportunity(accountId = acc.id,Auto_Renew__c = true,ChargentSFA__Payment_Status__c='Recurring Intent',Company__c = 'GARP',ChargentSFA__Payment_Frequency__c='Once',name='Test Name',StageName='New',CloseDate=system.today().addDays(2),ChargentSFA__Charge_Amount__c=95);
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
        insert obj;*/

        Site__c site = new Site__c(Name='Test Site',Display_Address__c='Test');
        insert site;
        Date dtToday = system.today();
        Exam__c objExam = new Exam__c(Name='Test Name',Exam__c='ERP',Exam_Date__c=dtToday);
        insert objExam;
        
        Exam_Sites__c examSite = new Exam_Sites__c(Name='Test',Exam__c=objExam.Id,Site__c=site.id);
        insert examSite;
        Exam_Attempt__c attempt = new Exam_Attempt__c(Name='test Name',Exam_Site__c=examSite.Id,Member__c=ct.Id,Defered__c='Approved');
        insert attempt;
        test.startTest();
        examptAttempts obj = new examptAttempts();
        obj.getExamAttempts(new set<String>{site.Id});
        test.stopTest();
    }
}