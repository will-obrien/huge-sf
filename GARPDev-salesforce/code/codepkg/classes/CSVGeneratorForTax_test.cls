@isTest
public class CSVGeneratorForTax_test {

    static Account account ;
    static Opportunity opportunity; 
    static ChargentBase__Gateway__c chrgGtway;
    static Product_Refunds__c refund;
    static ChargentSFA__Transaction__c payment;
    
    static void testData(){
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 

        payment = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = opportunity.id,ChargentSFA__Type__c= 'Charge', ChargentSFA__Response_Status__c= 'Approved');
        insert payment;


        list<string> codes = new list<string> {'FRM1','FRM1E','FRM1H','SLSTX','SHIP','MEMI','MEMF','FRM2L','FRM2H','FRM2E','FRM1L'}; 
        list<Product2> prodList = new list<Product2>();
        for(string str : codes ){
            Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = str,GL_Code__c = '4999',Family = 'Hardware');
            prodList.add(prod);
        }
        list<string> codes2 = new list<string> {'FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
        list<string> glCodes = new list<string> {'4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};
        
        system.debug('glCodes>>>'+glCodes);  
        system.debug('codes2>>>'+codes2);  
        for(string str : codes){
           Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = str,GL_Code__c = '4999',Family = 'Hardware');
           prodList.add(prod); 
        }
        for(integer i = 0;i<codes2.size();i++){
           Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
           prodList.add(prod); 
        }
        insert prodList;
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Id pricebookId = Test.getStandardPricebookId();
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        for(product2 prod : prodList){
            refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opportunity.id,Payment_Transaction__c= payment.id);
            refundList.add(refund);
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            pricebookEntries.add(standardPrice);
            standardpricebookEntries.add(standardPrice1);
        }       
        insert refundList;
        insert standardpricebookEntries;
        insert pricebookEntries;
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opportunity.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
        }
        insert lineItemList;
    }
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        ApexPages.currentPage().getParameters().put('stDate',string.valueOf(system.today()));
        ApexPages.currentPage().getParameters().put('endDate',string.valueOf(system.today()+20));
        ApexPages.currentPage().getParameters().put('Taxable','true');
        ApexPages.currentPage().getParameters().put('Regular','true');
        
        CSVGeneratorForTax csv = new CSVGeneratorForTax();
        csv.getData();
        test.stopTest();
    }
    
    
    
}