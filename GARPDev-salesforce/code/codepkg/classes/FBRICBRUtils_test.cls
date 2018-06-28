@isTest
public class FBRICBRUtils_test {
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
    static User user;
    static Profile profile;
    
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
        
        contact contact1 = new Contact(recordtypeId = recordtypehelper.getRecordtypeID('Contact','Business Relationship'),lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact1;
        profile = [SELECT Id FROM Profile WHERE usertype = 'CspLitePortal' limit 1]; 
        user = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact1.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        
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
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        list<exam_Sites__c> lstExamSites = new exam_sites__c[]{exmSite};
        list<Candidate_requirement__C> lstCandReqs = new candidate_requirement__c []{reqt};
        FBRICBRUtils.registerExam(lstExamSites, contact.id, lstCandReqs, Contract.ID, opp.Id);
        test.stopTest();
    }
    
    static testMethod void unitTest_2(){
        testData();
        test.startTest();
        
        system.runAs(user){
            FBRICBRUtils.getProductCodes();
        }
        test.stopTest();
    }

    static testMethod void unitTest_3(){
        testData();
        test.startTest();
        map<string,string[]> mapProdDetails = new map<string,string[]>();
        mapProdDetails.put('MEMI',new string []{'MEMI'});
        system.runAs(user){
        FBRICBRUtils.generateOrders(mapProdDetails, tempAccount);
        }
        test.stopTest();
    }
   
    static testMethod void unitTest_5(){
        testData();
        test.startTest();
        map<string,string[]> mapProdDetails = new map<string,string[]>();
        mapProdDetails.put('MEMI',new string []{'MEMI'});
        FBRICBRUtils.createOpportunity(mapProdDetails, contact, tempAccount);
        test.stopTest();
    }
    
    static testMethod void unitTest_6(){
        testData();
        test.startTest();
        map<string,string[]> mapProdDetails = new map<string,string[]>();
        mapProdDetails.put('AFREE',new string []{'AFREE','AFREE','AFREE','AFREE'});
        FBRICBRUtils.createOppLineItems(opp.Id, mapProdDetails);
        test.stopTest();
    }
    
    static testMethod void unitTest_7(){
        testData();
        test.startTest();
        map<string,string[]> mapProdDetails = new map<string,string[]>();
        mapProdDetails.put('MEMI',new string []{'MEMI'});
        FBRICBRUtils.createExamAttempts(mapProdDetails, contact.ID, acc.ID, opp.Id, true);
        test.stopTest();
    }
    
    static testMethod void unitTest_8(){
        testData();
        test.startTest();
        map<string,string[]> mapProdDetails = new map<string,string[]>();
        mapProdDetails.put('MEMI',new string []{'MEMI'});
        FBRICBRUtils.checkContractExist(mapProdDetails, acc.id);
        test.stopTest();
    }
}