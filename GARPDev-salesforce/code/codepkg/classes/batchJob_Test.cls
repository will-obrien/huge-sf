@isTest
public class  batchJob_Test{

    Static Account acc;
      
     static void testData()
     {
        acc = new Account(name = 'Test Account1', Calculated_Expire_Date__c = system.today(), Last_Contract_Exp_Calc__c = system.today());
        insert acc;
         
        Contact contact = new Contact(LEGACY_PK_PID__c  = '123',lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact; 
         
        contract program = new contract (AccountID = acc.id, status = 'Draft', CurrencyIsoCode = 'USD');
        insert program;
        
        Id recType4CPEReq = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'CPE');
        Candidate_Requirement__c progreq = new Candidate_Requirement__c(recordtypeid= recType4CPEReq, Name = 'XYZ', Candidate_Commitment__c = program.id, CurrencyIsoCode ='USD');
        insert progreq;
        
        CPE_Activity_Type__c cpdactivitytype = new CPE_Activity_Type__c (Name='New CPD Activity', CurrencyIsoCode = 'USD' );
        insert cpdactivitytype;
        
        CPE_Claim__c cpdclaim = new CPE_Claim__c (Approved__c = True, Approved_Date__c=null, Candidate_Requirement__c = progreq.id, CPE_Activity_Type__c = cpdactivitytype.id, Credits_Earned__c = 1, Member__c = contact.id);
        insert cpdclaim;  
     }
     
     static testMethod void UnitTest_1()
    {
        testData();
        test.startTest();
        batchJob b = new batchJob('mode');
        database.executeBatch(b);
        test.stopTest();
    }

}