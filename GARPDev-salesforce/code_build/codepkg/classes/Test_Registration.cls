@isTest
private class Test_Registration {
    
    
    static Account acc ;
    static Opportunity opp; 
    static ChargentSFA__Transaction__c chargentTrans;
    static TempAccount tempaccount;
    static Contact contact;
    static Exam_Attempt__c attempt;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contract contract;
    static Lead lead;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Candidate_Requirement__c reqt;
    static Chapter_Meeting__c chapMeeting ;
    static Chapter_Meeting_Registration__c meetingReg;
    
    static void testData(){ 
    	
    	Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        Product2 prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod2; 
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
    	
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        pymt__Settings__c pymtSettings = new pymt__Settings__c();
        
        pymt__Processor_Connection__c pymtConnection = new pymt__Processor_Connection__c();
    	
        insert new UpdateIds__c(Name='Payment', Record_Id__c='a0cf00000041nXB');
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('FRM Program').getRecordTypeId();
        contract = new Contract(Opportunity__c = opp.id,AccountId = acc.id,recordTypeId = rtId);
        insert contract;
        
        Contract  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12     ,StartDate = opp.CloseDate        );
        insert contract;

        contract.Status = 'Activated';
        update contract;
        
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
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite;
        
        contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
        
        lead = new Lead(lastname = 'test',firstName = 'test' ,status = 'Open',email= 'test@test.com',company = acc.id);
        insert lead;
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        chapMeeting = new Chapter_Meeting__c();
        insert chapMeeting;
        
        meetingReg = new Chapter_Meeting_Registration__c();
        meetingReg.Chapter_Meeting__c = chapMeeting.id;
        meetingReg.contact__c = contact.id;
        insert meetingReg;
        
        tempAccount = new tempAccount();
        tempAccount.id = contact.id;
        tempAccount.contactId = contact.id;
        tempAccount.FirstName = 'test';
        tempAccount.LastName = 'test';
        tempAccount.Email = 'test@test.com';
        tempAccount.Membership_Type = 'AFREE';
        tempAccount.garpMembership_Type = 'AFREE';
        tempAccount.ACCA = false;
        tempAccount.CA = false;
        tempAccount.CFA = false;
        tempAccount.CMA = false;
        tempAccount.CPA = false;
        tempAccount.InSchool = false;
        tempAccount.OtherDesignation = false;
        tempAccount.PMP = false;
        tempAccount.autoRenew = false;
        tempAccount.erpSwitch = false;
        tempAccount.frmSwitch = false;
        tempAccount.graduationDate = 'Invalid Date';
        tempAccount.hasBooks = false;
        tempAccount.isErpChecked = false;
        tempAccount.isFbrChecked = false;
        tempAccount.isFrmChecked = false;
        tempAccount.isIcbrChecked = false;
        tempAccount.isStudentChecked = false;
        tempAccount.productcode = new List<String>(); 
        TempAccount.productDefinition productDefition = new TempAccount.productDefinition();
        productDefition.GLCode = '4999';
        productDefition.ProductCode = 'AFREE';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ productDefition };   
        tempAccount.siteName = 'undefined';
        tempAccount.isWorking = false;
        tempAccount.jobTarget = false;       
        tempAccount.referral = 'Bloomberg Terminal'; 
        tempAccount.sameShip = 'true';
        tempAccount.switchFeeEnabled = false;
        tempAccount.ShippingOptionsString = 'test:12,test:12,test:12';
        tempAccount.BillingStreetTwo = 'test';
        tempAccount.BillingStreetThree = 'test';
        tempAccount.MailingStreetTwo = 'test';
        tempAccount.MailingStreetThree = 'test';
        tempAccount.isFrmChecked = true;
        tempAccount.OtherDesignation = true;
        tempAccount.isStudentChecked = true;
        tempAccount.taxPrice = 123;
        tempAccount.isIcbrChecked = true;
        tempAccount.siteName = 'test';
    }
    
    static testMethod void myUnitTest_1() {

        testData();
        
        test.startTest();
        
        registration reg = new registration();
        registration.wrapperSetLead wrpLead = new registration.wrapperSetLead();
        registration.wrapperCheckExistingMember wrpExstMbr = new registration.wrapperCheckExistingMember();
        registration.wrapperCreateOrder wrpOrder = new registration.wrapperCreateOrder();
        registration.wrapperGetContact wrpGetCon = new registration.wrapperGetContact(); 
        registration.wrapperProductInfo wrpPrdInfo = new registration.wrapperProductInfo();     
        
        registration.removeOrder(wrpGetCon.TempAccount,opp.id); 
        registration.CheckExistingMember('test1@test1.com'); 
        registration.setLead('test2@test2.com','test','test','Individual'); 
        tempAccount.Email = 'test@test2.com';
        registration.GetMember(tempAccount);
        registration.checkLead(tempAccount);
        tempAccount.contactId = null;
        tempAccount.id = lead.id;
        registration.returnBool(true);    
        tempAccount.productDefinition prd = new tempAccount.productDefinition ();           
        prd.ProductCode = 'MEMI';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd };  
        tempAccount.wiley = 'true';
        registration.CreateMemberShipContract(tempAccount,acc.id,opp.id,contract.id);
        test.stopTest();     
        
    }
    
    static testMethod void myUnitTest_2() {

        testData();
        test.startTest();
        
        registration reg = new registration();
        registration.wrapperSetLead wrpLead = new registration.wrapperSetLead();
        registration.wrapperCheckExistingMember wrpExstMbr = new registration.wrapperCheckExistingMember();
        registration.wrapperCreateOrder wrpOrder = new registration.wrapperCreateOrder();
        registration.wrapperGetContact wrpGetCon = new registration.wrapperGetContact(); 
        registration.wrapperProductInfo wrpPrdInfo = new registration.wrapperProductInfo();     
        registration.setContactInfo(TempAccount);
        registration.getContactInfo(contact.id);
        registration.CheckExistingMember('test@test.com');
        registration.setLead('test@test.com','test','test','Individual');
        registration.registrationDate();
        registration.testDate();
        tempAccount.Email = 'test@test.com';
        registration.GetMember(tempAccount);
        registration.checkLead(tempAccount);
        registration.setLead(tempAccount);
        //registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true);
        tempAccount.wiley = 'true';
        registration.CreateMemberShipContract(tempAccount,acc.id,opp.id,contract.id);
        test.stopTest();
    } 
    
     
    static testMethod void myUnitTest_3() {

        testData();
        test.startTest();
        registration.updateOpportunityInfo1(tempAccount,opp.id);
        tempAccount.autoRenew = true;
        registration.updateOpportunityinfoForMembers(opp.id,tempAccount);
        registration.getActiveSites();
        registration.returnBool(null);
        registration.updateContactInfo(tempAccount,contact.id);
        registration.updateAccountInfo(tempAccount,Acc.id);
        registration.updateOpportunityInfo(tempAccount,opp.id,true,true);
        
        try{
        registration.createOppLineItems(opp.id,tempAccount);
        }catch(Exception ex){}
        //registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true);
        registration.createContract(acc.id,tempAccount,opp.id,contact.id);
        registration.createopportunity(contact);    
        registration.returnBool(true);
        tempAccount.productDefinition prd = new tempAccount.productDefinition ();       
        prd.ProductCode = 'MEMS';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd };  
        tempAccount.wiley = 'true';
        registration.CreateMemberShipContract(tempAccount,acc.id,opp.id,contract.id);
        test.stopTest();
    }
    
    
    static testMethod void myUnitTest_4() { 

        testData();
        test.startTest();
        registration.updateContactInfo(tempAccount,contact.id);
        tempAccount.productDefinition prd = new tempAccount.productDefinition ();
        prd.ProductCode = 'MEMI';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd };  
        tempAccount.MailingCountry = 'US';      
        registration.updateContactInfo(tempAccount,contact.id);
        tempAccount.productDefinition prd1 = new tempAccount.productDefinition ();
        prd1.ProductCode = 'MEMS';
        tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd1 };   
        tempAccount.MailingCountry = 'US';
        registration.updateContactInfo(tempAccount,contact.id); 
        list<Exam__c> exams = new list<Exam__c>();
        exams.add(exam);    
        registration.getExamFee(exams);
        tempAccount.isErpChecked = true;
        registration.createContract(acc.id,tempAccount,opp.id,contact.id);
        test.stopTest();
    }
    
    static testMethod void myUnitTest_5() { 
        testdata();
        test.starttest();
        try{ 
            tempAccount.productDefinition prd1 = new tempAccount.productDefinition ();
            prd1.ProductCode = 'FRM1E';
            tempAccount.productcode1 = new TempAccount.productDefinition[]{ prd1 }; 
            tempAccount.isIcbrChecked = false;
            registration.createExamAttempts(tempAccount,contact.id,acc.id,opp.id,true);//hardcoding in main class
        }catch(Exception ex){}
        
        try{
            tempAccount.isFBRChecked = true;
            tempAccount.isFrmChecked = true;
            registration.createOrder(tempAccount);//hardcoding in main class
        }catch(Exception ex){}
        tempAccount.contactId = null;
        
        try{
            registration.createOrder(tempAccount);//hardcoding in main class
        }catch(Exception ex){}
        
        test.stoptest(); 
    }
    
    
    static testMethod void myUnitTest_6() { 
        testdata();
        test.starttest();
        try{
        tempaccount.Wiley = 'true';
        tempaccount.isFBRChecked = true;
        tempaccount.isFrmChecked = false;
        registration.createCandidateRequirements(contract.id,tempAccount);
        registration.CreateContract(acc.id,tempAccount,opp.id,contact.id);
        }catch(Exception ex){}
        
        test.stoptest(); 
    }
    
    static testMethod void myUnitTest_7() { 
        testdata();
        test.starttest();
        try{
        tempaccount.Wiley = 'true';
        tempaccount.isFBRChecked = false;
        tempaccount.isFrmChecked = false;
        tempaccount.isIcbrChecked = true;
        registration.createCandidateRequirements(contract.id,tempAccount);
        registration.CreateContract(acc.id,tempAccount,opp.id,contact.id);
        }catch(Exception ex){}
        registration.chapterMeetingRegister(contact.id,null,true);
        registration.getPrice('GL0008');
        
        test.stoptest(); 
    }
    
    static testMethod void myUnitTest_8() { 
        testdata();
        test.starttest();
        registration reg = new registration();
        try{
        tempaccount.Wiley = 'true';
        tempaccount.isFBRChecked = false;
        tempaccount.isFrmChecked = false;
        tempaccount.isIcbrChecked = false;
        tempaccount.isErpChecked = true;
        registration.createCandidateRequirements(contract.id,tempAccount);
        registration.CreateContract(acc.id,tempAccount,opp.id,contact.id);
        }catch(Exception ex){}
        
        registration.updateSelfRelations(new Candidate_Requirement__c []{ reqt },tempAccount);
        registration.getCandidatesReqByName(new Candidate_Requirement__c []{ reqt });
        registration.registerExam(new  Exam_Sites__c [] {exmSite}, contact.ID, new Candidate_Requirement__c [] {reqt}, contract.id,  opp.Id);
        registration.Charge( opp.Id,'03','1988','Credit Card','VISA','721','123432156788765');
        registration.chapterMeetingRegister(contact.id,chapMeeting.id,false);
        test.stoptest();  
    }
    
    //in progress
    static testMethod void myUnitTest_9() { 
        testdata();
        test.starttest();
        try{
        registration.getProductCodesBasedOnFilters1(new Exam_Attempt__c [] {attempt},new user(id = userinfo.getUserId()));
        registration.getFRMExams(new user(id = userinfo.getUserId()));
        registration.getERPExams(new user(id = userinfo.getUserId()));
        registration.getFBRICBRProductCodes('fbr');
        registration.getExamFee1(new Exam__c[] {exam});
        registration.getPrice('');
        
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    
    //in progress
    static testMethod void myUnitTest_10() { 
        testdata();
        test.starttest();
        try{
        registration.getProductCodes1('frm');
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    
    //in progress
    static testMethod void myUnitTest_11() { 
        testdata();
        test.starttest();
        try{
            registration.getProductCodes1('frm');
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    //in progress
    static testMethod void myUnitTest_12() { 
        testdata();
        test.starttest();
        try{
            registration.getFBRICBRProductCodes('fbr');
            registration.getFBRICBRProductCodes('ICBRR');
            registration.getFBRICBRProductCodes('WILEY');
            registration.getFBRICBRProductCodes('INDIVIDUAL');
            registration.getFBRICBRProductCodes('STUDENT');
        }catch(Exception ex){}
        test.stoptest();  
    }
    
            
    
    //in progress
    static testMethod void myUnitTest_13() { 
        testdata();
        test.starttest();
        try{
        Profile p = [SELECT Id FROM Profile WHERE usertype = 'CspLitePortal' limit 1]; 
        User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        attempt.Candidate_Commitment__c = contract.id;
        update attempt;
        System.runAs(u2) {
            tempAccount.contactId = contact.id;     
            registration.getProductCodes();
            registration.getFRMExams(u2);
        }
        }catch(Exception ex){}
        test.stoptest();   
    }
    
    //in progress
    static testMethod void myUnitTest_14() { 
        testdata();
        test.starttest();
        try{
            registration.getMiscellaneousProdCodes(null);
        }catch(Exception ex){}
        test.stoptest();  
    }
    
    //in progress
    static testMethod void myUnitTest_15() { 
        testdata();
        test.starttest();
        try{
        Profile p = [SELECT Id FROM Profile WHERE usertype = 'CspLitePortal' limit 1]; 
        User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        attempt.Candidate_Commitment__c = contract.id;
        update attempt;
        System.runAs(u2) {
            Id erpRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            contract.recordtypeId = erpRecordTypeId;
            update contract;
            registration.getERPExams(u2);
        }
        }catch(Exception ex){}
        try{
        registration.createExamAttemptsForICBR(TempAccount , contact.ID, acc.ID,  opp.Id, new  Candidate_Requirement__c [] {reqt},  contract.ID);
        }catch(Exception ex){}
        test.stoptest();   
    }
    

}