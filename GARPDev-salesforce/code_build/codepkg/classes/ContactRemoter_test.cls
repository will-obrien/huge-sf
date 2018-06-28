@isTest
public class ContactRemoter_test {
    static Exam_Attempt__c attempt;
    static Account acc ;
    static TempAccount tempaccount;
    static Contact contact ;
    static Opportunity opp; 
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static user user1;
    static Contact contact1;
    static User user;
    static Profile profile;
    
    static Contract mberContract;
    static contactRemoter.tempOrder order;
    
    static void testData(){
    
        insert new UpdateIds__c(Name='Payment', Record_Id__c='a0cf00000041nXB');
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        contact = new Contact(GARP_Directory_Opt_In__c = true,lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),KPI_ERP_Certified__c = true,Name_As_it_Appears_On_ID__c = 'testtest' ,ID_Number__c = 'dasf123l',ID_Type__c = 'Passport',KPI_FRM_Certified__c = true);
        insert contact;
        
        contact1 = new Contact(KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship'),KPI_ERP_Certified__c = true,lastname = 'Testdhaskd',AccountId = acc.id,email='daghtest@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),Name_As_it_Appears_On_ID__c = 'testtest' ,ID_Number__c = 'dasf123l',ID_Type__c = 'Passport');
        insert contact1;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
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
        exam.name = 'test';
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite;
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
        
        Exam_Attempt__c attempt1 = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact1.id,cancelled__c = false );
        insert attempt1;
        
        
        profile = [SELECT Id FROM Profile WHERE usertype = 'CspLitePortal' limit 1]; 
        user = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        
        user1 = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact1.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'MEMI',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod1;
        
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
        Pricebook2 customPB1 = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB1;
        
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB1.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opp.id,accountId = opp.AccountId);
        insert mberContract;
        mberContract.Status = 'Activated';
        update mberContract;
        
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
        
        order = new contactRemoter.tempOrder();
        order.TotalPrice = 1;
        order.Name = 'test test';
        order.MailingStreet = 'test';
        order.MailingCountry = 'test';
        order.MailingState = 'test';
        order.MailingCity = 'test';
        order.MailingPostalCode = 'test';
        order.email = 'test1@test1.com' ;
        order.productcodes = new string[]{'MEMI','MEMS'};
        order.tax = 1;
        order.ups = 'test';
    }
    
    static testMethod void unitTest_4(){
        testData();
        test.startTest();
        try{
        contactRemoter.createStoreOrder(order);
        }catch(Exception ex){}
        test.stopTest();
        
    }
    
    static testMethod void unitTest_5(){
        testData();
        test.startTest();
        try{
        contactRemoter.createStoreOrderPortal(order);
        }catch(Exception ex){}
        test.stopTest();
        
    }
    
    static testMethod void unitTest_6(){
        testData();
        test.startTest();
        try{
        contactRemoter.getProductCodes();
        
        
        }catch(exception ex){}
        test.stopTest();
            
        try{
            
            contactRemoter.getChapters();
        }catch(exception ex){}
        
    }
    static testMethod void unitTest_8(){
        testData();
        test.startTest();
        try{
        contactRemoter.getUnDefferedExams(attempt.id,'MEMI','4002');
        
        
        }catch(exception ex){}
        test.stopTest();
            
        
        
    }
    
    static testMethod void unitTest_7(){
        testData();
        test.startTest();
        try{
        contactRemoter.autoRenewOff(true);
        }catch(Exception ex){}
        test.stopTest();
        
        
    }
    static testMethod void unitTest_1(){
        testdata();
        test.startTest();
        
        ContactRemoter remoter = new ContactRemoter();
        ContactRemoter.productList prodList = new ContactRemoter.productList();
        ContactRemoter.searchResults searchResults = new ContactRemoter.searchResults();
        ContactRemoter.wrapperProductInfo wrapperProductInfo = new ContactRemoter.wrapperProductInfo();
        ContactRemoter.getUserReturnData getUserReturnData = new ContactRemoter.getUserReturnData();
        ContactRemoter.getExperienceData getExperienceData = new ContactRemoter.getExperienceData();
        ContactRemoter.productsAndQuantities productsAndQuantities = new ContactRemoter.productsAndQuantities();
        ContactRemoter.tempOrder tempOrder = new ContactRemoter.tempOrder();
        test.stopTest();
        
    }
    
    
    static testMethod void unitTest_2(){
        
        testdata();
        test.startTest();
        ContactRemoter.getAccountName();
        contactRemoter.getParentId();
        contactRemoter.getActiveSites();
        contactRemoter.Registrationdate();
        contactRemoter.testDate();
        //contactRemoter.getProductCodes();
        contactRemoter.getSwitchDetails();
        contactRemoter.getStoreProducts();
        contactRemoter.getStoreDescriptions();
        contactRemoter.getStoreForFrm();
        contactRemoter.getStoreForErp();
        contactRemoter.getFRMCandidate();
        contactRemoter.Deferred(attempt.id,'MEMI','4002');
        contactRemoter.GetMember(tempAccount);
        contactRemoter.SetLead(tempAccount);
        contactRemoter.getProduct('MEMI');
        contactRemoter.createcontractextension('MEMI');
        contactRemoter.getExamProducts('test');
        test.stopTest();
    }
    
    static testMethod void unitTest_3(){
        testData();
        test.startTest();
        contactRemoter.getERPCandidate();
        contactRemoter.getActiveExamsWithContracts();
        contactRemoter.taxCalculation();
        contactRemoter.getDefferedExams();
        
        contactRemoter.fetchUserData();
        
        contactRemoter.searchDirectory('test', 'lastname', 'lastname', 'DESC', 1, 0);
        contactRemoter.findOne(null);
        contact contacts = [select id,GARP_ID__c from Contact where id = :contact.id];
        contactRemoter.findOne(contacts.GARP_ID__c );
        contactRemoter.getContactDetails();
        contactRemoter.sendContactUs('test@test.com',new string []{'testtest@test.com'},'test');
        system.runAs(user1){
        	contactRemoter.fetchUserData();
        }
        test.stopTest();
         
          
    }
}