@istest
public class opportunityTriggerUtils_test {
    static Contract contract;
    static Contract frmContract;
    static Contract mberContract;
    static Contract mberContract1;
     static Contract wileyontract;
      static Contract cotractt;
    static Account account ;
    static Opportunity opportunity; 
    static Opportunity shipOpportunity;
    static Exam_Attempt__c attempt;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    
    static void testData(){ 
            
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4999',Family = 'Hardware');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'ENC',GL_Code__c = '4999',Family = 'Hardware');
        insert prod1;
        
        Product2 shipProduct = new Product2(Name = 'SHIP',productCode = 'SHIP',GL_Code__c = '4999',Family = 'Hardware',Product_ID__c='1111',Weight__c=2);
        insert shipProduct;
        
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
        PricebookEntry shipPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = shipProduct.Id,UnitPrice = 10000, IsActive = true);
        insert shipPrice;
       
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        PricebookEntry shipPrice1 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = shipProduct.Id, UnitPrice = 12000, IsActive = true);
        insert shipPrice1;
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15,Pricebook2Id = customPB.Id);        
        insert opportunity; 
        
        shipOpportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15,Pricebook2Id = customPB.Id,Shipping_Street__c='test/ntest1/ntest2',Shipping_Country__c='US');        
        insert shipOpportunity; 
        
        insert new CountryCodes__c(name='US',Country_Code__c='USA');
        
        
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = customPrice1.id,Quantity=1,UnitPrice=234);
        OpportunityLineItem lineItem1 = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = customPrice1.id,Quantity=1,UnitPrice=234);
        OpportunityLineItem shipLine = new OpportunityLineItem(OpportunityId = shipOpportunity.id,PricebookEntryId = shipPrice1.id,Quantity=1,UnitPrice=234);
        insert lineItem;
        insert lineItem1;
        insert shipLine;
        OpportunityLineItem shipLine1 = new OpportunityLineItem(OpportunityId = shipOpportunity.id,PricebookEntryId = shipPrice1.id,Quantity=1,UnitPrice=234);
        insert shipLine1;
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
        
        
         wileyontract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Wiley Bookstore') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert wileyontract;
        
        cotractt  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert cotractt;
       // mberContract.Status = 'Activated';
        //update mberContract;
        
        
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
     
    
    
    
    
   
    
    static testMethod void unitTest_9(){
        
        testData();
        test.startTest();
        set<Opportunity> oppids = new set<Opportunity>();
        oppids.add(Opportunity);
        //opportunityTriggerUtils.createProducts(oppids);
        test.stopTest();
    
    }
    
     static testMethod void createContractTest(){
        
        testData();
        test.startTest();
        //opportunityTriggerUtils.createContract(opportunity,System.today(),memberRecordTypeID,'New','Test',1);
        test.stopTest();
    
    }
     static testMethod void updateExamAttemptsTest(){
        
        testData();
        test.startTest();
        opportunityTriggerUtils.updateExamAttempts(new Set<Id>{attempt.Id},new Set<Id>{attempt.Id});
        test.stopTest();
        
    }
    
    
    static testMethod void unitTest_10(){
        
        testData();
        test.startTest();
        set<id> setAccountIds = new set<id>();
        setAccountIds.add(account.id);
        
        set<id> setOpps = new set<id>();
        setOpps.add(opportunity.id);
        
        Set<String> setProdCodes = new set<string>();
        setProdCodes.add('AFREE');
        setProdCodes.add('MEMI');
        setProdCodes.add('MEMS');
        setProdCodes.add('MEMF');
        
        Map<Id,Set<String>> mapProdCodesWithAccount = new Map<Id,Set<String>> ();
        mapProdCodesWithAccount.put(account.id,setProdCodes);
        try{
            opportunityTriggerUtils.updteRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);
            opportunityTriggerUtils.updteRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);
            opportunityTriggerUtils.updteRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);
            opportunityTriggerUtils.updteRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);
        }catch(Exception ex){}
        test.stopTest();  
    
    }
    
    static testMethod void unitTest_11(){
        
        testData();
        test.startTest();
        Map<Id,Opportunity> oppmap = new Map<Id,Opportunity>  ();
        oppmap.put(shipOpportunity.id,shipOpportunity);
        opportunityTriggerUtils.updateShipService( oppMap);
        test.stopTest();
    
    }
    
    static testMethod void unitTest_12(){
        
        testData();
        test.startTest();
        opportunityTriggerUtils.getUPSCode('UPS 2nd Day Air A.M.');
        opportunityTriggerUtils.getUPSCode('UPS 2nd Day Air');
        opportunityTriggerUtils.getUPSCode('UPS 3 Day Select');
        opportunityTriggerUtils.getUPSCode('UPS Ground');
        opportunityTriggerUtils.getUPSCode('UPS Next Day Air Early A.M.');
        opportunityTriggerUtils.getUPSCode('UPS Next Day Air Saver');
        opportunityTriggerUtils.getUPSCode('UPS Next Day Air');
        opportunityTriggerUtils.getUPSCode('UPS Saver');
        opportunityTriggerUtils.getUPSCode('UPS Standard');
        opportunityTriggerUtils.getUPSCode('UPS Worldwide Expedited');
        opportunityTriggerUtils.getUPSCode('UPS Worldwide Express Plus');
        opportunityTriggerUtils.getUPSCode('UPS Worldwide Express');
        opportunityTriggerUtils.getUPSCode('UPS Next Day Air');
        opportunityTriggerUtils.getUPSCode('Error');
        test.stopTest();
    }
    
    static testMethod void unitTest_13(){
        
        testData();
        test.startTest();
        list<Opportunity> opps = new List<Opportunity>  ();
        opps.add(opportunity);
        opportunityTriggerUtils.updateShippingInfo( opps);
        test.stopTest();
    
    }
    
    static testMethod void unitTest_14(){
        
        testData();
        test.startTest();
        set<id> accIds = new set<id>();
        accIds.add(account.id);
        opportunityTriggerUtils.updateautorenew(accIds);
        test.stopTest();
    
    }
    
    
}