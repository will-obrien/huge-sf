@isTest
private class PortalClass_test { 

    static Exam_Attempt__c attempt;
    static Account acc ;
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
    
    static void testData(){
    
        insert new UpdateIds__c(Name='Payment', Record_Id__c='a0cf00000041nXB');
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),Name_As_it_Appears_On_ID__c = 'testtest' ,ID_Number__c = 'dasf123l',ID_Type__c = 'Passport',KPI_FRM_Certified__c = true);
        insert contact;
        
        contact1 = new Contact(recordtypeid = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship'),lastname = 'Testdhaskd',AccountId = acc.id,email='daghtest@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),Name_As_it_Appears_On_ID__c = 'testtest' ,ID_Number__c = 'dasf123l',ID_Type__c = 'Passport',KPI_FRM_Certified__c = true);
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
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite;
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
        
        
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
        
    }

    static testMethod void myUnitTest_1() {
        
        testdata();
        test.starttest();
        PortalClass.checkExamAttempts(attempt.id,'AFREE','4999',false);
        test.stopTest();
        
    }
    
    static testMethod void myUnitTest_2() {
        
        testdata();
        test.starttest();
        try{
        system.runAs(user1){
            PortalClass.getContactDetails();
        }
        system.runAs(user1){
            PortalClass.extendMembership('AFREE','',False);
        }}
        catch(exception ex){}
        test.stopTest();
        
    }
    
    static testMethod void myUnitTest_3() {
        
        testdata();
        test.starttest();
        try{
        PortalClass.getMembershipTypeCodes(mberContract,contact1);
        system.debug('>>>'+user1);
        system.debug('>>>'+[select id ,name from user where usertype = 'CspLitePortal' and Accountid =: contact1.Accountid]);
        system.runAs(user1){
        Portalclass.checkrenewMemberShip();
        }
        
        Portalclass.unDeferrExamAttempts(attempt.id,'AFREE','4001',false);
        }catch(Exception ex){}
        test.stopTest();


    }
    static testMethod void myUnitTest_4(){
        testData();
        test.startTest();
        try{
        portalClass.checkAccountExists('test');
        }catch(Exception ex){}
        try{
        portalClass.checkAccountExists('test1');
        }catch(Exception ex){}
        
        portalClass.createOppLineItems(opp.id, 'AFREE',Contact,'',False); 
        portalClass.getContactDetails();
        portalClass.extendMembership('AFREE','',False);
        test.stopTest(); 
        
    }
    
    static testMethod void myUnitTest_5(){
        testData();
        test.startTest();
        portalClass.getAccountName();
        
        portalclass.getParentId();
        portalClass.getActiveExams();
        portalClass.getDefferedExams();
        portalClass.checkrenewMemberShip();
        test.stopTest();              
        
    }
    
    static testMethod void myUnitTest_6(){
        testData();
        test.startTest();
        portalclass.checkFRMDeferredStats(RecordTypeHelper.getRecordTypeId('Contract','FRM Program'),user);
        portalclass.checkERPDeferredStats(RecordTypeHelper.getRecordTypeId('Contract','ERP Program'),user);
        portalClass.checkSwitch(user);
        portalClass.checkSwithforERP(user);
        portalClass.checkSwithforFRM(user);
        portalClass.unDeferrExamAttempts(attempt.id,'AFREE','4999',false);
        test.stopTest();
    
        
        
        
    }
    
    
}