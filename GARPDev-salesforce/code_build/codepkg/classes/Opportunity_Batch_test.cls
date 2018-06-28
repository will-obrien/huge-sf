@isTest
private class Opportunity_Batch_test {

    static Account account;
    static Opportunity opp;
    static Exam_Attempt__c attempt;
    static Contact contact;
    static Exam_Group__c objExamGrp;
    static Site__c site;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static ChargentBase__Gateway__c chrgGtway;
    
    static void testData(){
        insert new UpdateIds__c(Name='Payment', Record_Id__c='a0cf00000041nXB');
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');  
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
    
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'FRM2',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        Product2 prod2 = new Product2(Name = 'Laptop X200',productCode = 'ENC',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod2;
        
        Product2 prod3 = new Product2(Name = 'Laptop X200',productCode = 'FRM1L',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod3;
        
        Product2 prod4 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod4;
        
        Product2 prod5 = new Product2(Name = 'Laptop X200',productCode = 'FRM1E',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod5;
        
        Product2 prod6 = new Product2(Name = 'Laptop X200',productCode = 'FRM2L',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod6;
        
        Product2 prod7 = new Product2(Name = 'Laptop X200',productCode = 'ENCS',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod7;
        
        List<sObject> myList = Test.loadData(Opportunity.sObjectType, 'oppdata');
        
        Id pricebookId = Test.getStandardPricebookId();
        system.debug('pricebookId>>>'+pricebookId+ '<<<01s40000000ALvbAAG');
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice2;
        
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice3;
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice4;
        PricebookEntry standardPrice5 = new PricebookEntry(Pricebook2Id = (id)myList[0].get('Pricebook2Id'), Product2Id = prod5.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice5;
        
        PricebookEntry standardPrice6 = new PricebookEntry(Pricebook2Id = (id)myList[0].get('Pricebook2Id'), Product2Id = prod6.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice6;
        
        PricebookEntry standardPrice7 = new PricebookEntry(Pricebook2Id = (id)myList[0].get('Pricebook2Id'), Product2Id = prod7.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice7;
        
        
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        PricebookEntry customPrice2 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod2.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice2;
        
        PricebookEntry customPrice3 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod3.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice3;
        
        PricebookEntry customPrice4 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod4.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice4;
        
        PricebookEntry customPrice5 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod5.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice5;
        
        
        account = new Account(Name = 'test');
        insert account;
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
         
        opp = new Opportunity(Pricebook2Id=pricebookId,amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp; 
        
        Opportunity opp1 = new Opportunity(Pricebook2Id = customPB.id,amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp1;
        
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = standardPrice.id,Quantity = 1,TotalPrice = 12);
        insert lineItem;
        
        OpportunityLineItem lineItem1 = new OpportunityLineItem(OpportunityId = opp1.id,PricebookEntryId = customPrice1.id,Quantity =1,TotalPrice = 12);
        insert lineItem1;
        
        OpportunityLineItem lineItem2 = new OpportunityLineItem(OpportunityId = myList[0].id,PricebookEntryId = standardPrice5.id,Quantity =1,TotalPrice = 12);
        insert lineItem2;
        
        OpportunityLineItem lineItem3 = new OpportunityLineItem(OpportunityId = myList[0].id,PricebookEntryId = standardPrice6.id,Quantity =1,TotalPrice = 12);
        insert lineItem3;
        
        OpportunityLineItem lineItem4 = new OpportunityLineItem(OpportunityId = myList[0].id,PricebookEntryId = standardPrice7.id,Quantity =1,TotalPrice = 12);
        insert lineItem4;
        
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
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite;
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
    
    }

    static testMethod void myUnitTest() {
        testData();
        test.startTest();
        try{
        database.executeBatch(new opportunity_Batch());
        }catch(Exception ex){}
        test.stoptest();
    }
}