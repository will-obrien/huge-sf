@isTest
public class sfdcAppRemoter_test {

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
    static sfdcAppRemoter.fieldInfo fieldInfo;
    static User user;
    static User user1;
    static Profile profile;
    static Contact contact1;
    static content__c content;
    static Board_Election__c election;
    static EmailTemplate template;
    static Proctor_Registration__c proctor;
    static CPE_Activity_Type__c  type;
    static CPE_Activity__c activity;
    static Chapter_Member__c member;
    static Chapter__c chapter;
    static Product2 prod;
    static Product2 prod1;
    static Product2 prod2;
    
    static void testData(){ 
        fieldInfo = new sfdcAppRemoter.fieldInfo();
        fieldInfo.name = 'firstname';
        fieldInfo.label = 'first name'; 
        fieldInfo.type = 'text'; 
        fieldInfo.maxLength = 20;
        fieldInfo.description = 'test';
        prod = new Product2(FRM_Study_Center__c = true,Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        prod1 = new Product2(ERP_Study_Center__c = true,Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
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
        
       insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        

            
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        insert new UpdateIds__c(Name= 'ICBRR', Record_Id__c = 'a1e40000006sqih');   
        //a1e40000006sqih  a0Cf0000004O778
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
        
        contact = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
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
        tempAccount.eppHelp = true;
        tempAccount.infoExchange = true;
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
        
        contact1 = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship'),lastname = 'Testdhaskd',AccountId = acc.id,email='daghtest@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),Name_As_it_Appears_On_ID__c = 'testtest' ,ID_Number__c = 'dasf123l',ID_Type__c = 'Passport');
        insert contact1;
        profile = [SELECT Id FROM Profile WHERE usertype = 'CspLitePortal' limit 1]; 
        user = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        user1 = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact1.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        
        content = new Content__c();
        content.Content_Type__c = 'News Feed' ;
        content.Status__c = 'Draft' ;
        content.Is_On_Demand__c = true;
        content.Raw_HTML__c = 'test';
        insert content;
        
        election = new Board_Election__c(End_Date__c = system.today() + 12,Start_Date__c = system.today() + 5 );
        insert election;
        
        
        //template = new EmailTemplate (developerName = 'test', TemplateType= 'Text', Name = 'test');
        //insert template;
        
        proctor = new Proctor_Registration__c(contact__c = contact.id,test_site__c = site.id,Exam_Group__c  = objExamGrp.id);
        insert proctor;
        
        type = new CPE_Activity_Type__c (name = 'test');
        insert type;
        
        activity = new CPE_Activity__c(Title__c = 'test',Activity_Type_Description__c = 'test',Provider__c = 'test',CPE_Activity_Type__c  = type.id);
        insert activity;
        
        member = new Chapter_Member__c(Director__c = true,IsPrimary__c = true,Contact__c = contact.id);
        insert member;
        
        chapter = new Chapter__c(LEGACY_Name__c = 'tre',LEGACY_PK_Chapter__c='terw',Location__c = 'e4wrew',Region__c='Americas',status__c='Active',type__c = 'Professional');
        insert chapter;
    }
    
    static testMethod void unitTest_7(){
        testData();
        test.startTest();
        system.runAs(user1){
            sfdcAppRemoter.purchaseCodeData purchaseCodeData = new sfdcAppRemoter.purchaseCodeData();
            purchaseCodeData.prodCode = 'AFREE';
            purchaseCodeData.glCode = '4999';
            purchaseCodeData.price = '123';
            purchaseCodeData.description = 'rew';
            purchaseCodeData.months = 3;
            
            sfdcAppRemoter.purchaseData purchaseData = new sfdcAppRemoter.purchaseData();
            purchaseData.id = prod.id;
            purchaseData.price = '12';
            
            sfdcAppRemoter.addressData addressData = new sfdcAppRemoter.addressData();
            addressData.Address_1 = 'test';
            addressData.Address_2 = 'test';
            addressData.Address_3 = 'test';
            addressData.City = 'test';
            addressData.State_Provence = 'test' ;
            addressData.Postal_Code =  'test';
            addressData.Country = 'test';
            
            sfdcAppRemoter.getUserContactDetails();
            //sfdcAppRemoter.unsubscribe();
            sfdcAppRemoter.updateId('test', 'test', '6578');
            sfdcAppremoter.voteBoardCandidates(contact1.id,  election.Id);
            sfdcAppRemoter.confirmProctor(proctor.id);
            sfdcAppRemoter.attestProctorApplication(proctor.id);
            sfdcAppRemoter.getProctorSiteRoster(proctor.id);
            sfdcAppRemoter.chapterMeetingRegister(String.valueOf(chapMeeting.id), true);
            sfdcAppRemoter.setChapterMeetingConfirm(string.valueOf(meetingReg.Id));
            sfdcAppRemoter.getChapterMeetingRegistrations();
            sfdcAppRemoter.signDirectorCode( chapter.Id);
            
        }
        
        sfdcAppRemoter.getEventContentDocs(12, 2014, false);
        sfdcAppRemoter.getChapterMeetingDetail (string.valueOf(chapMeeting.id));
        sfdcAppRemoter.getChapterMeetingDetails(12, 2014, false);
        sfdcAppRemoter.searchDirectory('test', 'lastname', 'lastname', 'DESC', 1, 0);
        sfdcAppRemoter.fetchChapterMeetingRegister(string.valueOf(meetingReg.id));
        sfdcAppRemoter.submitClaimFromMeeting( string.valueOf(chapMeeting.id),  string.valueOf(contact.Id),  string.valueOf(type.id), string.valueOf(account.id), true);
        sfdcAppRemoter.toggelAttendance(String.valueOf( chapMeeting.id),  string.valueOf(meetingReg.Id));
        
        test.stopTest();
    }
    
    
    static testMethod void unitTest_6(){
        testData();
        test.startTest();
        system.runAs(user1){
            sfdcAppRemoter.purchaseCodeData purchaseCodeData = new sfdcAppRemoter.purchaseCodeData();
            purchaseCodeData.prodCode = 'AFREE';
            purchaseCodeData.glCode = '4999';
            purchaseCodeData.price = '123';
            purchaseCodeData.description = 'rew';
            purchaseCodeData.months = 3;
            
            sfdcAppRemoter.purchaseData purchaseData = new sfdcAppRemoter.purchaseData();
            purchaseData.id = prod.id;
            purchaseData.price = '12';
            
            sfdcAppRemoter.addressData addressData = new sfdcAppRemoter.addressData();
            addressData.Address_1 = 'test';
            addressData.Address_2 = 'test';
            addressData.Address_3 = 'test';
            addressData.City = 'test';
            addressData.State_Provence = 'test' ;
            addressData.Postal_Code =  'test';
            addressData.Country = 'test';
            
            sfdcAppRemoter.buyProductsByCode(new sfdcAppRemoter.purchaseCodeData[] {purchaseCodeData}, 'test');
            sfdcAppRemoter.buyProducts(new sfdcAppRemoter.purchaseData[] {purchaseData});
            sfdcAppRemoter.requestNewChapter('test', 'test', 'test');
            sfdcAppRemoter.submitCreditContent( Type.Id, reqt.id);
            sfdcAppRemoter.setChapters(string.valueOf(chapter.id), string.valueOf(chapter.id));
            sfdcAppRemoter.requestChapterDirector(chapter.id);
            sfdcAppRemoter.fetchContactData();
            sfdcAppRemoter.fetchUserDataInternal(contact1.id);
        }
        
        sfdcAppRemoter.getChapterMembers('ryojhvbnm');
        sfdcAppRemoter.addRefData('Account', 'test');
        
        test.stopTest();     
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        sfdcAppRemoter remoter = new sfdcAppRemoter();
        sfdcAppRemoter.searchResults results = new sfdcAppRemoter.searchResults();
        sfdcAppRemoter.wrapperChapterMeetingDetails wrapperChapterMeetingDetails = new sfdcAppRemoter.wrapperChapterMeetingDetails();
        sfdcAppRemoter.wrapperChapterMemberDetails wrapperChapterMemberDetails = new sfdcAppRemoter.wrapperChapterMemberDetails();
        sfdcAppRemoter.productList productList = new sfdcAppRemoter.productList();
        productList.GLCode =  '4999';
        productList.price= '123';
        productList.ProductCode = 'AFREE';
        productList.Description = 'tuyio';
        sfdcAppRemoter.addressData addressData = new sfdcAppRemoter.addressData();
        sfdcAppRemoter.purchaseCodeData purchaseCodeData = new sfdcAppRemoter.purchaseCodeData();
        sfdcAppRemoter.purchaseData purchaseData = new sfdcAppRemoter.purchaseData();   
        sfdcAppRemoter.contentData contentData = new sfdcAppRemoter.contentData();      
        sfdcAppRemoter.productData productData = new sfdcAppRemoter.productData() ;       
        sfdcAppRemoter.wrapperProductInfo wrapperProductInfo = new sfdcAppRemoter.wrapperProductInfo();
        sfdcAppRemoter.getExperienceData getExperienceData = new sfdcAppRemoter.getExperienceData();
        sfdcAppRemoter.getUserReturnData getUserReturnData = new sfdcAppRemoter.getUserReturnData();        
        sfdcAppRemoter.returnData returnData = new sfdcAppRemoter.returnData();
        fieldInfo = new sfdcAppRemoter.fieldInfo();
        fieldInfo.name = 'firstname';
        fieldInfo.label = 'first name'; 
        fieldInfo.type = 'text'; 
        fieldInfo.maxLength = 20;
        fieldInfo.description = 'test';
        
        sfdcAppRemoter.appData appData = new sfdcAppRemoter.appData();
        sfdcAppRemoter.getChangeExamSites( string.valueOf(attempt.id));
        sfdcAppRemoter.changeExamSite(string.valueOf(attempt.id), exmSite.id);
        sfdcAppRemoter.createOtherexams(new sfdcAppRemoter.productList[]{productList}, tempAccount);
        sfdcAppRemoter.removeOrder(string.valueOf( opp.Id));
        sfdcAppremoter.setContactInfo(tempAccount);
        sfdcAppRemoter.getContactInfo(string.valueOf(contact.id)); 
        
        test.stopTest();
        
    }

    static testMethod void unitTest_8(){
        testData();
        test.starttest();
        sfdcAppRemoter.getLibraryDocs('test');
        sfdcAppRemoter.getFolderDocs('test');
        test.stopTest();    
    
    }

    static testMethod void unitTest_2(){
        testData();
        test.startTest();
        sfdcAppRemoter remoter = new sfdcAppRemoter();
        fieldInfo = new sfdcAppRemoter.fieldInfo();
        fieldInfo.name = 'firstname';
        fieldInfo.label = 'first name'; 
        fieldInfo.type = 'text'; 
        fieldInfo.maxLength = 20;
        fieldInfo.description = 'test';
        sfdcAppRemoter.getExamProducts('test');
        sfdcAppRemoter.autoRenewOff(false);
        sfdcAppRemoter.fetchCompanies();
        sfdcAppRemoter.saveFormData('Contact',string.valueof(contact.id),new sfdcAppremoter.fieldInfo[]{fieldInfo});
        sfdcAppremoter.deleteFormData('Content__c',string.valueof(content.id));
        sfdcAppRemoter.fetchUserDataInside(contact.id);
        sfdcAppRemoter.fetchUserData();
        sfdcAppRemoter.fetchAcademicInstitutions();
        test.stopTest();
        
    }    
    static testMethod void unitTest_3(){
        testData();
        test.startTest();
        try{            
            sfdcAppRemoter.renewContractcheck();
        }catch(Exception ex){}
        try{            
            sfdcAppRemoter.createcontractextension('AFREE');
        }catch(Exception ex){}
        try{            
            sfdcAppRemoter.RecurringFuture(opp.id,'12','2014','Credit Card','VISA','543','543456765');            
        }catch(Exception ex){}
        try{            
            sfdcAppremoter.createoppRecurring('AFREE');
        }catch(Exception ex){}
        try{            
            sfdcAppremoter.VoidRecurring(opp.id);           
        }catch(Exception ex){}
        try{
            sfdcAppRemoter.autoRenew(false, 'AFREE');           
        }catch(Exception ex){}
        try{
        sfdcAppRemoter.getUPSPrice('string strAddress1','string strAddress2','string strCity','string strCountry','string strStateCode','string strZip',new String[] {'MEMI'});
        }catch(Exception ex){}
        try{
            system.runAs(user1){
            sfdcAppRemoter.logError('String errorObject', 'String msg', 'String file', 'String method');
            }
        }catch(Exception ex){}
        try{
        sfdcAppRemoter.updateSite(attempt.id,exmsite.id);
        }catch(Exception ex){}
        try{
        sfdcAppRemoter.Charge(opp.Id,'12','2014','Credit Card','VISA','543','543456765');
        }catch(Exception ex){}
        try{
            sfdcAppRemoter.getUnDefferedExams(attempt.id, 'FRM1S','4999',false);
        }catch(Exception ex){}
        try{
            sfdcAppRemoter.fetchFormData('Contact', contact.id, new string[]{'lastname','firtstname'});
            sfdcAppRemoter.fetchUserDataInside(contact.id);
            sfdcAppRemoter.fetchUserData();
            sfdcAppRemoter.fetchUserDataInternal(contact.id);
            sfdcAppRemoter.fetchContactData();
            sfdcAppRemoter.fetchCompanies();
        }catch(Exception ex){}   
        try{
            sfdcAppRemoter.fetchFormList('Contact', 'Account','AccountID', new string[]{'lastname','firtstname'});
            sfdcAppRemoter.fetchFormData('Contact', contact.id, new string[]{'lastname','firtstname'});
            sfdcAppRemoter.saveFormData('Contact', string.valueOf(contact.id), new sfdcappRemoter.fieldInfo[] {fieldInfo});
            sfdcAppRemoter.deleteFormData('Contact', contact.id);
        }catch(Exception ex){}
        test.stopTest();
        
    }
    
        
    
    static testMethod void unitTest_4(){
        testData();
        test.startTest();
        sfdcAppRemoter.getInvoicePayments(opp.id);
        sfdcAppRemoter.getContentRegistrations(new string[]{'AFREE'});
        sfdcAppRemoter.createContract('Draft',  acc.Id,  opp.Id,  12, 'FRM Program');
        sfdcAppRemoter.Deferred( Attempt.Id,  'AFREE');
        sfdcAppRemoter.deferExam2(Attempt.Id,  'AFREE');
        sfdcAppRemoter.deferExams(attempt.id,  'AFREE', '4999',false);
        sfdcAppRemoter.getProduct2('AFREE', '4999');
        sfdcAppRemoter.getProduct('AFREE', '4999');
        sfdcAppRemoter.encodeString('trewyrte');
        sfdcAppRemoter.getBoardCandidates();
        sfdcAppRemoter.getSwitchDetails();
        sfdcAppRemoter.getOtherexamcodes();
        sfdcAppRemoter.getDefferedExams();
        sfdcAppRemoter.getAccountName();
        sfdcAppRemoter.getParentId(); 
        sfdcAppRemoter.selectProctor( site.Id,  contact.Id, true);
        sfdcAppRemoter.workedProctor(site.id,contact.id,true);
        sfdcAppRemoter.getProctorsBySite( site.Id);
        sfdcAppRemoter.attestCPE( Reqt.Id);
        sfdcAppRemoter.getCPEActivities();
        sfdcAppRemoter.getERPStudyProducts();
        sfdcAppRemoter.getFRMStudyProducts();
        sfdcAppRemoter.getContentPopularDocs('test');
        sfdcAppRemoter.getContentDocs('test');
        sfdcAppremoter.changeCycle(contract.id);
        sfdcAppRemoter.getFRMData(attempt.id);
        sfdcAppRemoter.getChapters();
        sfdcAppRemoter.uploadAttachment('filename', 'fileData', contact.id);
        system.runAs(user1){
        sfdcAppRemoter.getUserContactDetails();
        }
        test.stopTest();
    }
    
    static testMethod void unitTest_5(){
    
        testData();
        test.startTest();
        sfdcAppremoter remoter = new sfdcAppremoter();
        sfdcAppremoter.createorder(tempAccount);
        sfdcAppRemoter.setLead('test@test.com', 'test', 'test', 'Full Time');
        sfdcAppRemoter.CheckExistingMember('test@test.com');
        sfdcAppRemoter.getTestDate();
        sfdcAppRemoter.getRegistrationDate();
        sfdcAppRemoter.getActiveSites();
        system.runAs(user1){
        remoter.filterContentDocs(new Content__c[] {content}, 1) ;
        }
        test.stopTest();
        
    }
    
    
    
        
        
        
    
}