@isTest
private class Test_MemberShipAutoRenew {

    static Account acc;
    static Opportunity opp;
    static Contract mberContract;
    static User user;
    static Profile profile;
    static Contact contact;
    static PricebookEntry  standardPrice2 ;
    
    static void testData(){
        
        insert new UpdateIds__c(Name='Payment', Record_Id__c='a0cf00000041nXB');
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opp.id,accountId = opp.AccountId);
        insert mberContract;
        mberContract.Status = 'Activated';
        update mberContract;
        
        profile = [SELECT Id FROM Profile WHERE usertype = 'CspLitePortal' limit 1]; 
        user = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware');
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
    
    }
    
    static testMethod void myUnitTest_1() {
        testData(); 
        test.startTest();
        id recId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
        system.runas(user){
        MemberShipAutoRenew.autoRenewOff(true);
        }
        test.stopTest(); 
   }
   
   
   
   static testMethod void myUnitTest_2() {
        testData(); 
        test.startTest();
        system.runAs(user){
            MemberShipAutoRenew.autorenew(true,'AFREE');
        }
        test.stopTest(); 
   }
   
   
   
   static testMethod void myUnitTest_3() {
        testData(); 
        test.startTest();
        try{
        system.runAs(user){
            MemberShipAutoRenew.RecurringFuture(opp.id,'10','2014','Credit Card','VISA','432','2134564532');
        }
        }catch(Exception ex){}
        test.stopTest(); 
   }
   
   static testMethod void myUnitTest_4() {
        testData(); 
        test.startTest();
        id recId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
        system.runAs(user){
            MemberShipAutoRenew.createOpportunity(contact,acc,recId,standardPrice2,mberContract );
        }
        test.stopTest(); 
   }
   
}