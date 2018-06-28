@istest
public class ContractSyncUtil_Test {
	
	static Contract contract;
    static Contract frmContract;
    static Contract mberContract;
    static Contract mberContract1;
    static Account account ;
    static Opportunity opportunity; 
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Candidate_Requirement__c reqt;
    static Candidate_Requirement__c reqt1;
    static Candidate_Requirement__c reqt2;
    
    static void testData_1(){ 
            
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        
        Opportunity opp = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2009, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp;
        
        list<Product2> prodList = new list<Product2>();
        list<string> codes2 = new list<string> {'AFREE','FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
        list<string> glCodes = new list<string> {'4040','4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};

        system.debug('glCodes>>>'+glCodes);  
        system.debug('codes2>>>'+codes2);  

        for(integer i = 0;i<codes2.size();i++){
           Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
           prodList.add(prod); 
        }
        insert prodList;        
        
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Id pricebookId = Test.getStandardPricebookId();
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund.put(refund.Id, refund);
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            pricebookEntries.add(standardPrice);
            standardpricebookEntries.add(standardPrice1);
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList;
        insert standardpricebookEntries;
        insert pricebookEntries;
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
        }
        insert lineItemList;
        
        
        
        
        
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
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert con;
        con.Status = 'Activated';
        update con;

        Contract con1  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert con1;
        con1.Status = 'Canceled';
        update con1;

        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;

        Candidate_Requirement__c reqtJ = new Candidate_Requirement__c();
        reqtJ.Candidate_Commitment__c = contract.id;
        reqtJ.name = 'Job';
        reqtJ.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ.Status__c = 'Initial';
        insert reqtJ;

        Candidate_Requirement__c reqtJ1 = new Candidate_Requirement__c();
        reqtJ1.Candidate_Commitment__c = contract.id;
        reqtJ1.name = 'Job1';
        reqtJ1.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ1.Status__c = 'Ready For Review';
        insert reqtJ1;

        Candidate_Requirement__c reqtJ2 = new Candidate_Requirement__c();
        reqtJ2.Candidate_Commitment__c = contract.id;
        reqtJ2.name = 'Job2';
        reqtJ2.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ2.Status__c = 'Failed Review';
        insert reqtJ2;

        Candidate_Requirement__c reqt3 = new Candidate_Requirement__c();
        reqt3.Candidate_Commitment__c = con1.id;
        reqt3.name = 'CPE';
        insert reqt3;

        
    }
	
	static void testData_2(){ 
            
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        insert contract;
        contract.Status = 'Canceled';
        update contract;
        
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 1,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert frmContract;
        frmContract.Status = 'Canceled';
        update frmContract;
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert mberContract;
        mberContract.Status = 'Expired';
        update mberContract;

        Contract wberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Wiley Bookstore') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert wberContract;
        wberContract.Status = 'Activated';
        update wberContract;
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Student',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert mberContract1;
        mberContract1.Status = 'Canceled';
        update mberContract1;
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert con;
        con.Status = 'Canceled';
        update con;

        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        reqt1 = new Candidate_Requirement__c();
        reqt1.Candidate_Commitment__c = con.id;
        reqt1.name = 'FRM1 test';
        insert reqt1;
	}

   	static void testData_3(){ 
            
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 

        Opportunity opp = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2009, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp;
        
        list<Product2> prodList = new list<Product2>();
        list<string> codes2 = new list<string> {'AFREE','FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
        list<string> glCodes = new list<string> {'4040','4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};

        system.debug('glCodes>>>'+glCodes);  
        system.debug('codes2>>>'+codes2);  

        for(integer i = 0;i<codes2.size();i++){
           Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
           prodList.add(prod); 
        }
        insert prodList;        
        
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Id pricebookId = Test.getStandardPricebookId();
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund.put(refund.Id, refund);
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            pricebookEntries.add(standardPrice);
            standardpricebookEntries.add(standardPrice1);
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList;
        insert standardpricebookEntries;
        insert pricebookEntries;
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
        }
        insert lineItemList;

        Opportunity opp1 = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2010, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp1;

        list<Product_Refunds__c> refundList1 = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund1 = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB1 = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB1;
        //Id pricebookId = Test.getStandardPricebookId();
        pricebookEntries = new list<pricebookEntry>();
        standardpricebookEntries = new list<pricebookEntry>();
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp1.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund1.put(refund.Id, refund);
            //PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            //PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            //pricebookEntries.add(standardPrice);
            //standardpricebookEntries.add(standardPrice1);
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList1;
        //insert standardpricebookEntries;
        //insert pricebookEntries;
        lineItemList = new list<OpportunityLineItem>();        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp1.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
        }
        insert lineItemList;

        
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        insert contract;
        contract.Status = 'Canceled';
        update contract;
        
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 1,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert frmContract;
        frmContract.Status = 'Canceled';
        update frmContract;
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert mberContract;
        mberContract.Status = 'Expired';
        update mberContract;
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Student',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert mberContract1;
        mberContract1.Status = 'Canceled';
        update mberContract1;
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert con;
        con.Status = 'Canceled';
        update con;

        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        reqt1 = new Candidate_Requirement__c();
        reqt1.Candidate_Commitment__c = con.id;
        reqt1.name = 'FRM1 test';
        insert reqt1;
	}

	static testMethod void unitTest_1(){
		
		testData_1();
		test.startTest();
		Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
		mapAccountIds.put(account.id,contract);
		mapAccountIds.put(account.id,frmContract);
		mapAccountIds.put(account.id,mberContract);
		mapAccountIds.put(account.id,mberContract1);		
		
		contractSyncUtil.updateContracts( mapAccountIds);
		test.stopTest();
		
	}
	static testMethod void unitTest_2(){
		
		testData_2();
		test.startTest();
		Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
		mapAccountIds.put(account.id,contract);
		mapAccountIds.put(account.id,frmContract);
		mapAccountIds.put(account.id,mberContract);
		mapAccountIds.put(account.id,mberContract1);		
		
		contractSyncUtil.updateContracts( mapAccountIds);
		test.stopTest();
		
	}
	static testMethod void unitTest_3(){
		
		testData_3();
		test.startTest();
		Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
		mapAccountIds.put(account.id,contract);
		mapAccountIds.put(account.id,frmContract);
		mapAccountIds.put(account.id,mberContract);
		mapAccountIds.put(account.id,mberContract1);		
		
		contractSyncUtil.updateContracts( mapAccountIds);
		test.stopTest();
		
	}

}