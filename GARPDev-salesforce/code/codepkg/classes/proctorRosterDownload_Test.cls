@isTest
public class proctorRosterDownload_Test {
    
    static Exam_Attempt__c examattempt;
    static Exam_Attempt__c examattempt1;
    static Exam_Attempt__c examattempt2;
    static Site__c testsite;
    static Exam_Sites__c examSite;
    static Exam_Sites__c examSite1;
    static Exam_Sites__c examSite11;
    static Exam_Sites__c examSite2;
    static Exam_Sites__c examSite22;
    static Exam__c exam;
    static Exam__c exam1;
    static Exam__c exam2;
    static Room__c room;
    static Venue__c venue;
    static string session;
    static string sitecode;
    static string name;
    static ProctorRoster__c roster;

    static void testData()
    {
        
        
            Account a1 = new Account(name = 'Test Account1');
            insert a1;
        
            Contact c1 = new contact(GARP_Member_ID__c = '1234', lastname = 'Test Contact1', AccountID = a1.ID, email = 'testcontact1@contact.com', KPI_Member__c = True, Membership_Type__c = 'Individual',KPI_Membership_Payment_Status__c ='In Good Standing');
            insert c1;
        
        exam = new Exam__c(Name='May 2015 ERP Exam', Exam__c='ERP', Exam_Code__c ='1111:2015~5');
        exam.Exam_Date__c = system.today() + 13;
        insert exam;
        
        
        exam1 = new Exam__c(Name='May 2015 FRM Exam', Exam__c='FRM Part 1', Exam_Code__c ='1111:2015~5');
        exam1.Exam_Date__c = system.today() + 13;
        insert exam1;
        
        
        exam2 = new Exam__c(Name='May 2015 FRM Exam', Exam__c='FRM Part 2', Exam_Code__c ='1111:2015~5');
        exam2.Exam_Date__c = system.today() + 13;
        insert exam2;
        
         testsite = new Site__c(Name='USA, MA, BOSTON',Site_Code__c ='1800-11', Display_Address__c  ='Westborough, Boston , MA, USA');
        insert testsite;
        
        examSite = new Exam_Sites__c(Name='May 2015 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
        examSite.Exam__c = exam.id;
        insert examSite;
        
        examSite1 = new Exam_Sites__c(Name='May 2015 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
        examSite1.Exam__c = exam1.id;
        insert examSite1;
        
        examSite2 = new Exam_Sites__c(Name='May 2015 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
        examSite2.Exam__c = exam2.id;
        insert examSite2;
        
        examSite11 = new Exam_Sites__c(Name='May 2015 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
        examSite11.Exam__c = exam1.id;
        insert examSite11;
        
        examSite22 = new Exam_Sites__c(Name='May 2015 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id);
        examSite22.Exam__c = exam2.id;
        insert examSite22;

        
        venue = new Venue__c (Name = 'May 2015 USA, Boston');
        venue.Site__c = testsite.id;
        insert venue;
        
        room = new Room__c (Name ='4000');
        room.Venue__c = venue.id;
        room.Capacity__c = decimal.valueOf(100);
        insert room;
        
        examattempt = new Exam_Attempt__c(Name='John Doe', Seat_No__c='999', Member__c = c1.id, Cancelled__c = False, Defered__c = 'Approved');
        examattempt.Exam_Site__c = examSite.id;
        examattempt.Room__c = room.id;
        insert examattempt;
        
        
        examattempt1 = new Exam_Attempt__c(Name='John Doe', Seat_No__c='999', Member__c = c1.id, Cancelled__c = False, Defered__c = 'Approved');
        examattempt1.Exam_Site__c = examSite1.id;
        examattempt1.Room__c = room.id;
        insert examattempt1;
        
        
        examattempt2 = new Exam_Attempt__c(Name='John Doe', Seat_No__c='999', Member__c = c1.id, Cancelled__c = False, Defered__c = 'Approved');
        examattempt2.Exam_Site__c = examSite2.id;
        examattempt2.Room__c = room.id;
        insert examattempt2;
        
        roster = new ProctorRoster__c(Name = 'ExamName', RosterExamName__c ='May 2015 FRM Exam');
        insert roster;
        
        session = 'AM';
        //sitecode = testsite.Site_Code__c;
        //name = testsite.id;

    }
    static testMethod void Unit_test()
    {
        test.starttest();
        testData();
        Test.setCurrentPageReference(new PageReference('page.proctorRosterDownload')); 
		ApexPages.currentPage().getParameters().put('ID', testsite.ID);
        proctorRosterDownload proctor = new proctorRosterDownload();
   
        proctor.getExamAttempts();
        test.stopTest();
        
    }
}