@isTest
private class examRegistration2ContactSync_Test {

	static Exam_Attempt__c attempt;
    static Exam_Group__c objExamGrp;
    static Exam_Group__c objExamGrp1;
    static Exam_Group__c objExamGrp2;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Exam__c exam1;
    static Exam_Sites__c exmSite1;
    static Exam__c exam2;
    static Exam_Sites__c exmSite2;
    static Exam_Attempt__c attempt1;
    static Site__c site;
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Account account ;
    static Opportunity opportunity; 
    
	static void testData(){
		
		chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
		
		site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true; 
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        insert objExamGrp;
        
        objExamGrp1 = new Exam_Group__c();
        objExamGrp1.Active__c = false; 
        Date dt2 = system.today();
        objExamGrp1.Registration_Start_Date__c = dt2.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()-1;
        objExamGrp1.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp1.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        insert objExamGrp1;
        
        objExamGrp2 = new Exam_Group__c();
        objExamGrp2.Active__c = false; 
        Date dt3 = system.today();
        objExamGrp2.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        insert objExamGrp2;
        
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id,Exam_Date__c = system.today()+2);
        insert exmSite; 
        
        exam1 = new Exam__c();
        exam1.Exam_Group__c = objExamGrp1.id;
        exam1.Exam_Date__c = system.today() + 30;
        exam1.exam__c = 'ICBRR'; 
        insert exam1;
        
        exmSite1 = new Exam_Sites__c(Site__c = site.id,exam__c = exam1.id);
        insert exmSite1; 
        
        
        
        
        
	}

    static testMethod void myUnitTest_1() {
		testData();
		
		test.startTest();
		attempt = new Exam_Attempt__c(Result__c = 'Pass',Opportunity__c = opportunity.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
		test.stopTest();
    } 
    
    
    static testMethod void myUnitTest_2() {
		testData();
		attempt = new Exam_Attempt__c(Result__c = 'Pass',Opportunity__c = opportunity.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
		test.startTest();
		update attempt;
		test.stopTest();
    }
    
    static testMethod void myUnitTest_3() {
		testData();
		attempt1 = new Exam_Attempt__c(Result__c = 'Pass',Opportunity__c = opportunity.id, Exam_Site__c = exmSite1.id,Member__c = contact.id,cancelled__c = false );
        insert attempt1;
		test.startTest();
		update attempt1;
		test.stopTest();
    }
    
    static testMethod void myUnitTest_4() {
		testData();
		test.startTest();
		attempt1 = new Exam_Attempt__c(Result__c = 'Pass',Opportunity__c = opportunity.id, Exam_Site__c = exmSite1.id,Member__c = contact.id,cancelled__c = false );
        insert attempt1;
		test.stopTest();
    }
    
    
}