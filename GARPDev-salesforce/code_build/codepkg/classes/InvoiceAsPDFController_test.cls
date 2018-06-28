@isTest
public class InvoiceAsPDFController_test {
    
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
    static ChargentSFA__Transaction__c payment1;
    static ChargentSFA__Transaction__c payment2;
    
    static void testData(){ 
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        Product2 prod1 = new Product2(Name = 'fax',productCode = 'AFREE',Family = 'Hardware',isActive = true);
        Product2 prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        Product2 prod3 = new Product2(Name = 'Laptop X200',productCode = 'PRFEE',GL_Code__c = '6110',Family = 'Hardware',isActive = true);
        Product2 prod4 = new Product2(Name = 'Laptop X200',productCode = 'CBRHI',GL_Code__c = '4000',Family = 'Hardware',isActive = true);
        insert new Product2[]{ prod,prod1,prod2,prod3,prod4 };
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 10000, IsActive = true);
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id,UnitPrice = 10000, IsActive = true);
        insert new PricebookEntry[] { standardPrice,standardPrice1,standardPrice2,standardPrice3,standardPrice4 };
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert new PricebookEntry[]{ customPrice,customPrice1 };
         
        
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
       
        OpportunityLineItem lineItem1 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice.id);
        OpportunityLineItem lineItem2 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice1.id);
        OpportunityLineItem lineItem3 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice2.id);
        OpportunityLineItem lineItem4 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice3.id, Description='credit card by fax');
        OpportunityLineItem lineItem5 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice3.id, Description='wire');
        OpportunityLineItem lineItem6 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice4.id);
        insert new OpportunityLineItem[]{ lineItem1,lineItem2,lineItem3,lineItem4,lineItem5,lineItem6 };
        
         payment1 = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = opp.id,ChargentSFA__Type__c= 'Charge', ChargentSFA__Response_Status__c= 'Approved',ChargentSFA__Amount__c =60, ChargentSFA__Payment_Method__c='Credit Card');
         payment2 = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = opp.id,ChargentSFA__Type__c= 'Charge', ChargentSFA__Response_Status__c= 'Approved',ChargentSFA__Amount__c =60, ChargentSFA__Payment_Method__c='Cash');
        insert new ChargentSFA__Transaction__c[]{ payment1,payment2 };
    }
    
    static void testData2(){ 
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        Product2 prod1 = new Product2(Name = 'fax',productCode = 'AFREE',Family = 'Hardware',isActive = true);
        Product2 prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        Product2 prod3 = new Product2(Name = 'Laptop X200',productCode = 'PRFEE',GL_Code__c = '6110',Family = 'Hardware',isActive = true);
        Product2 prod4 = new Product2(Name = 'Laptop X200',productCode = 'CBRHI',GL_Code__c = '4000',Family = 'Hardware',isActive = true);
        insert new Product2[]{ prod,prod1,prod2,prod3,prod4 };
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 10000, IsActive = true);
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id,UnitPrice = 10000, IsActive = true);
        insert new PricebookEntry[] { standardPrice,standardPrice1,standardPrice2,standardPrice3,standardPrice4 };
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert new PricebookEntry[]{ customPrice,customPrice1 };
         
        
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
       
        OpportunityLineItem lineItem1 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice.id);
        OpportunityLineItem lineItem2 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice1.id);
        OpportunityLineItem lineItem3 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice2.id);
        OpportunityLineItem lineItem4 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice3.id, Description='credit card by fax');
        OpportunityLineItem lineItem5 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice3.id, Description='wire');
        OpportunityLineItem lineItem6 = new OpportunityLineItem(TotalPrice = 20,quantity = 1,OpportunityId = opp.id,PricebookEntryId = standardPrice4.id);
        insert new OpportunityLineItem[]{ lineItem1,lineItem2,lineItem3,lineItem4,lineItem5,lineItem6 };
        
         payment1 = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = opp.id,ChargentSFA__Type__c= 'Charge', ChargentSFA__Response_Status__c= 'Approved',ChargentSFA__Amount__c =60, ChargentSFA__Payment_Method__c='Credit Card');
         payment2 = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = opp.id,ChargentSFA__Type__c= 'Charge', ChargentSFA__Response_Status__c= 'Approved',ChargentSFA__Amount__c =60, ChargentSFA__Payment_Method__c='Cash');
        insert new ChargentSFA__Transaction__c[]{ payment1,payment2 };
    }

    static testMethod void unitTest_1(){
        testData();
        test.startTest();               
        ApexPages.currentPage().getParameters().put('id',opp.id);
        InvoiceAsPDFController invoice = new InvoiceAsPDFController();
        invoice.getNow();
        invoice.fetchData();
        test.stopTest();
    }

    static testMethod void unitTest_2(){
        testData();
        test.startTest();               
        ApexPages.currentPage().getParameters().put('id',opp.id);
        InvoiceAsPDFController invoice = new InvoiceAsPDFController();
        invoice.getNow();
        invoice.fetchData();
        test.stopTest();
    }

}