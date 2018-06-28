@isTest
public class allNotesInOnePage_Test {

    static Account a1;
    static void testData()
    {
        Profile p = [SELECT Id FROM Profile WHERE Id = '00e40000000iraa'];
        
        	User u = new user(TimeZoneSidKey = 'America/New_York',LocaleSidKey = 'en_US', ProfileId = p.Id, Username = 'GARPSYSTEM@garp.com', CommunityNickname = 'GARP SYSTEM',Alias = 'GSystem',CurrencyIsoCode = 'USD', EmailEncodingKey = 'ISO-8859-1',LanguageLocaleKey = 'en_US',LastName = 'System', Email = 'garpsfdcsystem@garp.com');
        	insert u;
        
        	a1 = new Account(name = 'Test Account1', GARP_ID__c  = '101010');
            insert a1;
        
            Contact c1 = new contact(GARP_Member_ID__c = '101010',lastname = 'Garp System', AccountID = a1.ID, email = 'garpsfdcsystem@garp.com', KPI_Member__c = True, Membership_Type__c = 'Individual',KPI_Membership_Payment_Status__c ='In Good Standing');
            insert c1;
        
        	opportunity o1 = new Opportunity( amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,Company__c = 'GARP', accountId = a1.id,stageName = 'Closed',Program__c = 'Print' ,closedate = system.today()+ 15,Pay_By_Wire_Check__c=false);        
            insert o1; 
        
        	
        	Note n = new Note (Title = 'Test Note',body = 'This is a test note to check the code coverage',ParentID = a1.id);
        	insert n;
			
        	Note n1 = new Note (Title = 'Test Note',body = 'This is a test note to check the code coverage',ParentID = c1.id);
        	insert n1;
        
        	Note n2 = new Note (Title = 'Test Note',body = 'This is a test note to check the code coverage',ParentID = o1.id);
        	insert n2;
        
        	Blob b = Blob.valueOf('Test Blob');
        	Attachment a = new Attachment (name = 'abc.txt',body = b,ParentID = a1.id);
        	insert a;
        
			Attachment at = new Attachment (name = 'abc.txt',body = b,ParentID = c1.id);
        	insert at;
        
        	Attachment at1 = new Attachment (name = 'abc.txt',body = b,ParentID = o1.id);
        	insert at1;
        
    }
    static testMethod void Unit_test()
    {
        test.starttest();
        testData();
   		Test.setCurrentPageReference(new PageReference('page.AllNotesInOnePage')); 
		ApexPages.currentPage().getParameters().put('GARPID', a1.GARP_ID__c);
        
        allNotesInOnePage allNotes = new allNotesInOnePage();
        allNotes.getAllNotes();
        test.stopTest();
        
    }
}