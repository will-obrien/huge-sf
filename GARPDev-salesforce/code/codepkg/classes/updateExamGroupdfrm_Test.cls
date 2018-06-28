@isTest
public class updateExamGroupdfrm_Test {

    
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
        
       opportunity opp = new opportunity(Name='FRM Registration',accountid = a1.id,CloseDate=system.today(), StageName = 'Closed');
       insert opp;
        
        contract cont  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opp.id,accountId = a1.id); 
        insert cont;
        cont.Status = 'Activated';
        update cont;
        
        Candidate_Requirement__c reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = cont.id;
        reqt.name = 'PASS FRM1';
        insert reqt;
        
         Candidate_Requirement__c reqt1 = new Candidate_Requirement__c();
        reqt1.Candidate_Commitment__c = cont.id;
        reqt1.name = 'PASS FRM2';
        insert reqt1;
        
        
        
        Exam_Group__c eg = new Exam_Group__c(Name = '15-Nov');
        insert eg;
        
       exam = new Exam__c(Name='Nov 2015 FRM Exam Partt I', Exam__c='FRM Part 1', Exam_Group__c = eg.id, Exam_Code__c ='111111:2015~5');
       exam.Exam_Date__c = Date.newInstance(2015, 11, 21);
       insert exam; 
        
       exam2 = new Exam__c(Name='Nov 2015 FRM Exam Partt II', Exam__c='FRM Part 2', Exam_Group__c = eg.id, Exam_Code__c ='111111:2015~5');
       exam2.Exam_Date__c = Date.newInstance(2015, 11, 21);
       insert exam2;  
        
       testsite = new Site__c(Name='USA, MA, BOSTON',Site_Code__c ='1800-11', Display_Address__c  ='Westborough, Boston , MA, USA');
       insert testsite;
        
       examSite = new Exam_Sites__c(Name='Nov 2015 FRM Exam Part I USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
       examSite.Exam__c = exam.id;
       insert examSite;
        
        siteid = examSite.id;
        
        ExamSiteids__c examSiteID = new ExamSiteids__c(Name=examSite.id);
        insert examSiteID;
        
        Set<String> strSection = new Set<String>{'FRM Part 1','FRM Part 2'};
        
        venue = new Venue__c (Name = 'Nov 2015 USA, Boston');
        venue.Site__c = testsite.id;
        insert venue;
        
        room = new Room__c (Name ='4000');
        room.Venue__c = venue.id;
        room.Capacity__c = decimal.valueOf(100);
        insert room;
        
        examattempt = new Exam_Attempt__c(Name='John Doe', Seat_No__c='999', Member__c = c1.id, Cancelled__c = False, Defered__c = 'Pending', Opportunity__c = opp.id, Candidate_Requirement__c = reqt.id);
        examattempt.Exam_Site__c = examSite.id;
        examattempt.Room__c = room.id;
        insert examattempt;
        
        examattempt1 = new Exam_Attempt__c(Name='John Doe',  Seat_No__c='999', Member__c = c1.id, Cancelled__c = False, Defered__c = 'Pending', Opportunity__c = opp.id, Candidate_Requirement__c = reqt1.id);
        examattempt1.Exam_Site__c = examSite.id;
        examattempt1.Room__c = room.id;
        insert examattempt1;

    }
    
    static testMethod void Unit_test()
    {
        test.starttest();
        testData();
        String StrDefered = 'Pending';
        // string id ='a1a40000004FOIJ';
         String oppstatus = 'closed';
         siteid =examSite.id;
         Set<String> setSiteIds = new Set<String>();
         Set<String> strSection = new Set<String>{'FRM Part 1','FRM Part 2'};
             
      system.debug('***** Deferred Status :'+StrDefered);  
      system.debug('***** Opp Status :'+oppstatus);  
       system.debug('***** SiteID Status Test method:'+siteid);  
       system.debug('***** strSection Status :'+strSection); 
        updateExamGroupdfrm frm = new updateExamGroupdfrm();
        database.executeBatch(frm);
        test.stopTest();
        
    }
    
}