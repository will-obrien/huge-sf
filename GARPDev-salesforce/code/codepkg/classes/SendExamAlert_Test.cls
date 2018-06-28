@isTest
private class SendExamAlert_Test {

    static Exam_Attempt__c attempt;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Account account ;
    static Opportunity opportunity; 
    static Exam_Alert__c alert;
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
        
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id,Exam_Date__c = system.today()+2);
        insert exmSite; 
        
        alert = new Exam_Alert__c( Name = 'Test', Text__c ='test', Sound__c= false);
        insert alert;
        
        Exam_Alert_Site__c alertSite = new Exam_Alert_Site__c( Name ='test', Exam_Site__c = exmSite.id,Exam_Alert__c = alert.id);
        insert alertSite;
        
        FRM_App_Setting__c appSettings = new FRM_App_Setting__c(Name = 'test', Contact__c = contact.id, examId__c = exam.id);
        insert appSettings;
	}
	
	
	
	static testMethod void unitTest_1(){
		testData();
		test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
		ApexPages.currentPage().getParameters().put('id',alert.id);
		SendExamAlert alertt = new SendExamAlert();
		test.stopTest();
		
		
		
		
	}
}