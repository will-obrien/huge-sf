@isTest
public class ERPRoomBatch_Test {

     Static Void testdata()
    {
        	Site__c testSite = new Site__c(Name = 'USA, TX, Houston',Active__c=True,Site_Code__c='111',Display_Address__c='USA, TX, Houston');
        	insert testSite;
            ExamSiteids__c siteIds = new ExamSiteids__c(Name = testSite.id);
            insert siteIds;
            Exam_Date__c examDate = new Exam_Date__c(Name = 'ERP',Date_String__c = '2015-05-16');
        	insert examDate;
        
        	Exam_Group__c examGroup = new Exam_Group__c(Name='15-May');
        	insert examGroup;
        	Exam__c exam = new Exam__c(Name='May 2015 ERP Exam',Exam__c='ERP',Exam_Group__c=examGroup.id,Exam_Date__c=date.newInstance(2015,5,16));
        	insert exam;
        	Exam_Sites__c examSites = new Exam_Sites__c(Name='May 2015 ERP Exam USA, TX, Houston',Exam__c = exam.id,Exam_Date__c = date.newInstance(2015,5,16),Site__c=testSite.id, CurrencyIsoCode = 'USD' );
        	insert examSites;
        
        	Exam_Sites__c examSitesMay = new Exam_Sites__c(Name='May 2015 ERP Exam USA, MA, BOSTON',Exam__c = exam.id,Exam_Date__c = date.newInstance(2015,5,16),Site__c=testSite.id, CurrencyIsoCode = 'USD' );
        	insert examSitesMay;
        
        	Account a1 = new Account(name = 'Test Account1');
            insert a1;
        
        	opportunity o1 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,Company__c = 'GARP', accountId = a1.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today(),Pay_By_Wire_Check__c=false);        
            insert o1;
        
        	contract cont = new contract(AccountID=a1.id,Status='Draft',StartDate=system.today(),ContractTerm = 12);
        	insert cont;
        	cont.status='Activated';
        	update cont;
        
        	Venue__c venue = new Venue__c(Name = 'May 2015 USA, TX, Houston',Site__c =testSite.id,Active__c=true );
        	insert venue;
        	Room__c room = new Room__c(Name='Salon  A',Capacity__c = 25, Venue__c = venue.id, Priority__c = 1, Active__c = true);
        	insert room;

        
        	Exam_Attempt__c examRegMay = new Exam_Attempt__c(Exam_Site__c=examSitesMay.id);
        	insert examRegMay;
        	Exam_Attempt__c examReg = new Exam_Attempt__c(Exam_Site__c=examSites.id,Seat_No__c='',Room__c=room.id,Other_Exam_Registrations__c=examRegMay.id,Defered__c='Approved',Cancelled__c = False, Candidate_Commitment__c = cont.id);
			insert examReg;
        
        
            
        
    }
    
    Static testMethod Void unit_test1()
    {
        testdata();
        test.startTest();
        ERPRoomBatch b = new ERPRoomBatch();
        database.executeBatch(b);
        test.stopTest();
    }
 
   
}