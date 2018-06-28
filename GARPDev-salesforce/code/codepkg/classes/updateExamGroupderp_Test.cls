@isTest
public class updateExamGroupderp_Test {

    
    static Exam_Attempt__c examattempt;
    static Exam_Attempt__c examattempt1;
    static Site__c testsite;
    static Exam_Sites__c examSite;
    static Exam__c exam;
    static Exam__c exam2;
    static Room__c room;
    static Venue__c venue;
    static string siteid;
    
    static void testdata(){
        
        
        
        Account a1 = new Account(name = 'Test Account1');
        insert a1;
        
       Contact c1 = new contact(GARP_Member_ID__c = '1111234', lastname = 'Test Contact1', AccountID = a1.ID, email = 'testcontact1@contact.com', KPI_Member__c = True, Membership_Type__c = 'Individual',KPI_Membership_Payment_Status__c ='In Good Standing');
       insert c1;
        
       opportunity opp = new opportunity(Name='ERP Registration',accountid = a1.id,CloseDate=system.today(), StageName = 'Closed');
       insert opp;
        
        contract cont  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opp.id,accountId = a1.id); 
        insert cont;
        cont.Status = 'Activated';
        update cont;
        
        Candidate_Requirement__c reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = cont.id;
        reqt.name = 'Pass ERP';
        insert reqt;
        
     /*    Candidate_Requirement__c reqt1 = new Candidate_Requirement__c();
        reqt1.Candidate_Commitment__c = cont.id;
        reqt1.name = 'PASS ERP1';
        insert reqt1;  */
        
        
        
        Exam_Group__c eg = new Exam_Group__c(Name = '15-Nov');
        insert eg;
        
        Exam_Group__c eg1 = new Exam_Group__c(Name = '16-May');
        insert eg1;
        
       exam = new Exam__c(Name='Nov 2015 ERP Exam', Exam__c='ERP', Exam_Group__c = eg.id, Exam_Code__c ='111111:2015~5');
       exam.Exam_Date__c = Date.newInstance(2015, 11, 21);
       insert exam; 
        
       exam2 = new Exam__c(Name='May 2016 ERP Exam Part I', Exam__c='ERP Part 1', Exam_Group__c = eg1.id, Exam_Code__c ='111111:2015~5');
       exam2.Exam_Date__c = Date.newInstance(2016, 05, 21);
       insert exam2;  
        
       Exam__c exam3 = new Exam__c(Name='May 2016 ERP Exam Part II', Exam__c='ERP Part 2', Exam_Group__c = eg1.id, Exam_Code__c ='111111:2015~5');
       exam3.Exam_Date__c = Date.newInstance(2016, 05, 21);
       insert exam3;  
        
       testsite = new Site__c(Name='USA, MA, BOSTON',Site_Code__c ='1800-11', Display_Address__c  ='Westborough, Boston , MA, USA');
       insert testsite;
        
       examSite = new Exam_Sites__c(Name='Nov 2015 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
       examSite.Exam__c = exam.id;
       insert examSite;
        
                
       Exam_Sites__c examSite1 = new Exam_Sites__c(Name='May 2016 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
       examSite1.Exam__c = exam2.id;
       insert examSite1;
       
       Exam_Sites__c examSite2 = new Exam_Sites__c(Name='May 2016 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
       examSite2.Exam__c = exam3.id;
       insert examSite2;
        
        siteid = examSite.id;
        
        ExamSiteids__c examSiteID = new ExamSiteids__c(Name=examSite.id);
        insert examSiteID;
        
        ERPsplit__c erpSplit = new ERPsplit__c (Name = examSite.id, ERP1__c = examSite1.id, ERP2__c= examSite2.id);
        insert erpSplit;
        
        Set<String> strSection = new Set<String>{'ERP'};
        
        venue = new Venue__c (Name = 'Nov 2015 USA, Boston');
        venue.Site__c = testsite.id;
        insert venue;
        
        room = new Room__c (Name ='4000');
        room.Venue__c = venue.id;
        room.Capacity__c = decimal.valueOf(100);
        insert room;
        
        examattempt = new Exam_Attempt__c(Name='John Doe', Seat_No__c='999', Member__c = c1.id, Cancelled__c = False, Defered__c = 'Pending', Opportunity__c = opp.id, Candidate_Requirement__c = reqt.id, Candidate_Commitment__c = cont.id);
        examattempt.Exam_Site__c = examSite.id;
        examattempt.Room__c = room.id;
        insert examattempt;
        
      /*  examattempt1 = new Exam_Attempt__c(Name='John Doe',  Seat_No__c='999', Member__c = c1.id, Cancelled__c = False, Defered__c = 'Pending', Opportunity__c = opp.id, Candidate_Requirement__c = reqt1.id, Candidate_Commitment__c = cont.id);
        examattempt1.Exam_Site__c = examSite.id;
        examattempt1.Room__c = room.id;
        insert examattempt1;  */

    }
    
    static testMethod void Unit_test()
    {
        test.starttest();
        testData();
        updateExamGroupderp erp = new updateExamGroupderp();
        database.executeBatch(erp);
        test.stopTest();
        
    }
    
}