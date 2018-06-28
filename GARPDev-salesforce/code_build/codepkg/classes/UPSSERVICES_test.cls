@isTest
public class UPSSERVICES_test {

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
    static user user1;
    static user user;
    static Profile profile;
    static Profile profile1;
    
    
    static void testData(){ 
            
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4999',Family = 'Hardware',weight__c = 12);
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'ENC',GL_Code__c = '4999',Family = 'Hardware',weight__c = 12);
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
        
        
        profile = [SELECT Id FROM Profile WHERE name = 'System Administrator' limit 1]; 
        
        profile1 = [SELECT Id FROM Profile WHERE usertype = 'CspLitePortal' limit 1]; 
        
        user1 = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile1.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        
        user = new User(Alias = 'newUser', Email='newuser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');

    }
    
    static testMethod void unitTest_1(){
        //testData(); 
        test.startTest();
        UPSSERVICES ups = new UPSSERVICES();
		UPSSERVICES.prepPriceXML('53','4234',123);
		UPSSERVICES.prepXML('us','usa','usa','usa','1234', '56');
		UPSSERVICES.getUPSDesc('123');
		UPSSERVICES.calDiscount(12,5,'USA');
		UPSSERVICES.getWeightByProdCodes(new String[] {'FRM1','ENC'});
        test.stopTest();
        
    }
    
    
    static testMethod void unitTest_2(){
        //testData();

        UPSSERVICES ups = new UPSSERVICES();

			Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_2());
			UPSSERVICES.getUPSPrice('rew','re','yuk','tyui', 'NJ','5678',new String[] {'FRM1','ENC'});


    }
    
    static testMethod void unitTest_3(){
        //testData();
        test.startTest();
        UPSSERVICES ups = new UPSSERVICES();
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_2());
		UPSSERVICES.getWebResponse('rew','rew','tryu','tyu','5678', 'NJ');
    }
    
    static testMethod void unitTest_4(){
        //testData();

        UPSSERVICES ups = new UPSSERVICES();
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_2());

			UPSSERVICES.getPriceWebResponse('tewr','yui','yui','6778', 'nj',new String[] {'FRM1','ENC'});


        
    }
    
    static testMethod void unitTest_5(){
        //testData();

        UPSSERVICES ups = new UPSSERVICES();

			Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_2());
			Map<String,Decimal> mapUPSPrice = new map<string,decimal> ();
			mapUPSPrice.put('65',123);
			UPSSERVICES.prepareWrapper(mapUPSPrice,'CA');
			UPSSERVICES.prepareWrapper(mapUPSPrice,'NJ');
			UPSSERVICES.isSuccess(UPSSERVICES.getWebResponse('rew','rew','tryu','tyu','5678', 'NJ'));


        
    }
}