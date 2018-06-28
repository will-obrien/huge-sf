@isTest
public class DataloadModification1_test {

    static Contract contract;
    static Contract frmContract;
    static Contract mberContract;
    static Contract mberContract1;
    static Account account ;
    static Opportunity opportunity; 
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    
    
    static void testData(){ 
            
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4999',Family = 'Hardware');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'ENC',GL_Code__c = '4999',Family = 'Hardware');
        insert prod1;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
       
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
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
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        dataLoadModification1 dataload = new dataLoadModification1();
        database.executeBatch(dataload);
        test.stoptest();
        
    }
    
  
}