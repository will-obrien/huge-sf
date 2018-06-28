@isTest
private class MemberMerge_Test {
	
	static Account account ;
    static Opportunity opportunity; 
    static Contact contact;
    static Contract contract;
    static Exam_Attempt__c attempt;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Experience__c exp;
    static ChargentBase__Gateway__c chrgGtway;
    static CPE_Claim__c claim1;
    static CPE_Claim__c claim2;
    static Profile profile;
    static User user;
    
    static void testData() {
    	
    	chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        profile = [SELECT Id FROM Profile WHERE usertype = 'CspLitePortal' limit 1]; 
        user = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
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
        
        exp = new Experience__c ();
        exp.company__c = account.id;
        exp.Contact__c = contact.id;
        exp.CompanyOther__c = 'yteuriskjb';
        exp.Job_Description__c = 'trew';
        exp.Start_Date__c = system.today() +12;
        insert exp;
        
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        insert contract;
        contract.Status = 'Activated';
        update contract;
        		
		Id recType4CPEReq = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'CPE');
        Candidate_Requirement__c  reqt = new Candidate_Requirement__c (Candidate_Commitment__c  = contract.id,recordtypeid= recType4CPEReq);
        insert reqt;
        
        claim2 = new CPE_Claim__c();
        claim2.Candidate_Requirement__c  = reqt.id ;
        claim2.Credits_Earned__c   = 123;
        claim2.Member__c = contact.id;
        insert claim2; 
        
        claim1 = new CPE_Claim__c();
        claim1.Candidate_Requirement__c  = reqt.id ;
        claim1.Credits_Earned__c   = 123;
        claim1.Member__c = contact.id;
        insert claim1;   
            
        attempt = new Exam_Attempt__c(Result__c = 'Pass',Opportunity__c = opportunity.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
    }
    
    
    static testMethod void myUnitTest_1() {
    	testData();
    	test.startTest();
    	MemberMerge mrg = new memberMerge();
    	mrg.cont1lst = mrg.createContWrapper(new List<Contact>{Contact});
    	mrg.cont2lst = mrg.createContWrapper(new List<Contact>{Contact});
    	mrg.acct1Lst = mrg.createAcctWrapper(new List<Account>{Account});
    	mrg.acct2Lst = mrg.createAcctWrapper(new List<Account>{Account});
    	mrg.exp2Lst = mrg.createExpWrapper(new List<Experience__c>{exp});
    	mrg.exp1Lst = mrg.createExpWrapper(new List<Experience__c>{exp});
    	mrg.ea1Lst = mrg.createEaWrapper(new List<Exam_Attempt__c>{attempt});
    	mrg.ea2Lst = mrg.createEaWrapper(new List<Exam_Attempt__c>{attempt});
    	mrg.op1Lst = mrg.createOpWrapper(new List<opportunity>{opportunity});
    	mrg.op2Lst = mrg.createOpWrapper(new List<opportunity>{opportunity});
    	mrg.cpe1Lst = mrg.createCPEWrapper(new List<CPE_Claim__c> {claim1});
    	mrg.cpe2Lst = mrg.createCPEWrapper(new List<CPE_Claim__c> {claim1});
    	mrg.createConWrapper(new List<Contract> {contract});
    	test.stopTest();
    }
    
    
    static testMethod void myUnitTest_2() {
    	testData();
    	test.startTest();
    	MemberMerge mrg = new memberMerge();
    	mrg.cont1lst = mrg.createContWrapper(new List<Contact>{Contact});
    	mrg.cont2lst = mrg.createContWrapper(new List<Contact>{Contact});
    	mrg.acct1Lst = mrg.createAcctWrapper(new List<Account>{Account});
    	mrg.acct2Lst = mrg.createAcctWrapper(new List<Account>{Account});
    	mrg.exp2Lst = mrg.createExpWrapper(new List<Experience__c>{exp});
    	mrg.exp1Lst = mrg.createExpWrapper(new List<Experience__c>{exp});
    	mrg.ea1Lst = mrg.createEaWrapper(new List<Exam_Attempt__c>{attempt});
    	mrg.ea2Lst = mrg.createEaWrapper(new List<Exam_Attempt__c>{attempt});
    	mrg.op1Lst = mrg.createOpWrapper(new List<opportunity>{opportunity});
    	mrg.op2Lst = mrg.createOpWrapper(new List<opportunity>{opportunity});
    	mrg.cpe1Lst = mrg.createCPEWrapper(new List<CPE_Claim__c> {claim1});
    	mrg.cpe2Lst = mrg.createCPEWrapper(new List<CPE_Claim__c> {claim1});
    	mrg.claim1 = claim1;
    	mrg.claim2 = claim2;
    	mrg.cont1lst[0].selected = true;
    	try{
    		mrg.combineContacts();
    	}catch(Exception ex){}
    	mrg.fetchRecords();
    	test.stopTest();
    }
    
    static testMethod void myUnitTest_3() {
    	testData();
    	test.startTest();
    	MemberMerge mrg = new memberMerge();
    	mrg.cont1lst = mrg.createContWrapper(new List<Contact>{Contact});
    	mrg.cont2lst = mrg.createContWrapper(new List<Contact>{Contact});
    	mrg.acct1Lst = mrg.createAcctWrapper(new List<Account>{Account});
    	mrg.acct2Lst = mrg.createAcctWrapper(new List<Account>{Account});
    	mrg.exp2Lst = mrg.createExpWrapper(new List<Experience__c>{exp});
    	mrg.exp1Lst = mrg.createExpWrapper(new List<Experience__c>{exp});
    	mrg.ea1Lst = mrg.createEaWrapper(new List<Exam_Attempt__c>{attempt});
    	mrg.ea2Lst = mrg.createEaWrapper(new List<Exam_Attempt__c>{attempt});
    	mrg.op1Lst = mrg.createOpWrapper(new List<opportunity>{opportunity});
    	mrg.op2Lst = mrg.createOpWrapper(new List<opportunity>{opportunity});
    	mrg.cpe1Lst = mrg.createCPEWrapper(new List<CPE_Claim__c> {claim1});
    	mrg.cpe2Lst = mrg.createCPEWrapper(new List<CPE_Claim__c> {claim1});
    	mrg.claim1 = claim1;
    	mrg.claim2 = claim2;
    	mrg.cont2lst[0].selected = true;
    	try{
    		mrg.combineContacts();
    	}catch(Exception ex){}
    	mrg.fetchRecords();
    	test.stopTest();
    }
}