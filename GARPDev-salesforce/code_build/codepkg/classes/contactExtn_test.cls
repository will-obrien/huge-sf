@isTest
public class contactExtn_test {


    static Contract contract;
    static Contract frmContract;
    static Contract mberContract;
    static Contract mberContract1;
    static Account account ;
    static Opportunity opportunity; 
    static Exam_Attempt__c attempt;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    
    static void testData(){ 
            
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'CNY13',GL_Code__c = '4060',Family = 'Hardware');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'MEMF',GL_Code__c = '4040',Family = 'Hardware');
        insert prod1;
        
        Product2 prod2 = new Product2(Name = 'Laptop X200',productCode = 'MEMI',GL_Code__c = '4040',Family = 'Hardware');
        insert prod2;
        
        Product2 prod3 = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware');
        insert prod3;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice2;
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice3;
       
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        PricebookEntry customPrice2 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod2.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice2;
        
        PricebookEntry customPrice3 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod3.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice3;
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = standardPrice.id);
        OpportunityLineItem lineItem1 = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = customPrice1.id);
        
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        insert contract;
        contract.Status = 'Activated';
        update contract;
        
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 1,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert frmContract;
        frmContract.Status = 'Activated';
        update frmContract;
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert mberContract;
        mberContract.Status = 'Activated';
        update mberContract;
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Student',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert mberContract1;
        mberContract1.Status = 'Activated';
        update mberContract1;
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert con;
        con.Status = 'Activated';
        update con;

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
        
        attempt = new Exam_Attempt__c(Opportunity__c = opportunity.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
    }
    
    static testMethod void unitTest_1(){
        
        testData();
        test.startTest();
        contactExtn extn = new contactExtn(new Apexpages.Standardcontroller(attempt));
        contactExtn extn1 = new contactExtn(attempt, '12', false);
        extn.objEA = attempt;
        extn.firstName = 'test';
        extn.lastName = 'TEST';
        extn.nickname = 'TESTEST';
        extn.title = 'testy';
        extn.close = false;
        extn.amount = '123';
        extn.email = 'test1@test.com';
        extn.createContact();
        test.stopTest();
    }

    static testMethod void unitTest_2(){
        
        testData();
        test.startTest();
        contactExtn extn = new contactExtn(new Apexpages.Standardcontroller(attempt));
        contactExtn extn1 = new contactExtn(attempt, '12', false);
        extn.objEA = attempt;
        extn.firstName = 'test';
        extn.lastName = 'TEST';
        extn.nickname = 'TESTEST';
        extn.title = 'testy';
        extn.close = false;
        extn.amount = '123';
        extn.email = 'test@test.com';
        extn.createContact();
        test.stopTest();
    }
    
    static testMethod void unitTest_3(){
        
        testData();
        test.startTest();
        contactExtn extn = new contactExtn(new Apexpages.Standardcontroller(attempt));
        contactExtn extn1 = new contactExtn(attempt, '12', false);
        extn.objEA = attempt;
        extn.firstName = 'test';
        extn.lastName = 'TEST';
        extn.nickname = 'TESTEST';
        extn.title = 'testy';
        extn.close = false;
        extn.amount = '123';
        extn.email = 'test@test.com';
        extn.createOppLineItems(opportunity.Id,'CNY13', '4060', Contact ,  '123');
        extn.createOpportunity(Contact ,  'test', true);
        extn.updateMemberShip();
        extn.mode = 'Event';
        extn.updateMemberShip();
        test.stopTest();
    }
    
    static testMethod void unitTest_4(){
        
        testData();
        test.startTest();
        contactExtn extn = new contactExtn(attempt, '12', false);
        extn.objEA = attempt;
        extn.firstName = 'test';
        extn.lastName = 'TEST';
        extn.nickname = 'TESTEST';
        extn.title = 'testy';
        extn.close = false;
        extn.amount = '123';
        extn.email = 'test@test.com';
        extn.mode = 'Event';
        extn.updateMemberShip();
        test.stopTest();
    }

}