@isTest
public class updatePRERP_Test {

    static Exam_Attempt__c examattempt;
    static Site__c testsite;
    static Exam_Sites__c examSite;
    static Exam__c exam;
    static Room__c room;
    static Venue__c venue;
    
    static void testdata(){
        
        Account a1 = new Account(name = 'Test Account1');
        insert a1;
        
       Contact c1 = new contact(GARP_Member_ID__c = '1234', lastname = 'Test Contact1', AccountID = a1.ID, email = 'testcontact1@contact.com', KPI_Member__c = True, Membership_Type__c = 'Individual',KPI_Membership_Payment_Status__c ='In Good Standing');
       insert c1;
        
       opportunity opp = new opportunity(Name='ERP Registration',accountid = a1.id,CloseDate=system.today(), StageName = 'closed');
       insert opp;
        
        contract cont  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opp.id,accountId = a1.id); 
        insert cont;
        cont.Status = 'Activated';
        update cont;
        
        Candidate_Requirement__c reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = cont.id;
        reqt.name = 'PASS ERP';
        insert reqt;
        
       exam = new Exam__c(Name='Nov 2015 ERP Exam', Exam__c='ERP', Exam_Code__c ='1111:2015~5');
       exam.Exam_Date__c = Date.newInstance(2015,11,21);
       insert exam; 
        
       testsite = new Site__c(Name='USA, MA, BOSTON',Site_Code__c ='1800-11', Display_Address__c  ='Westborough, Boston , MA, USA');
       insert testsite;
        
       examSite = new Exam_Sites__c(Name='Nov 2015 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
       examSite.Exam__c = exam.id;
       insert examSite;
        

        examattempt = new Exam_Attempt__c(Name='John Doe', Seat_No__c='999', Member__c = c1.id, Cancelled__c = False, Defered__c = 'Pending', Opportunity__c = opp.id, Candidate_Requirement__c = reqt.id);
        examattempt.Exam_Site__c = examSite.id;
        insert examattempt;
    }
    
    static testMethod void Unit_test()
    {
        test.starttest();
        testData();
        updatePRERP erp = new updatePRERP();
        database.executeBatch(erp);
        test.stopTest();
        
    }
    
    
}