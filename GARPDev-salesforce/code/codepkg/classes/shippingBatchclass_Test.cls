@isTest
public class shippingBatchclass_Test {
    static ChargentBase__Gateway__c chrgGtway;
    static Account account ;
    static Opportunity opportunity;
    static Contact contact;
    
     static List<Opportunity> lstDomesticOpps;
     static List<Opportunity> lstInternationalOpps;
     static List<Opportunity> lstInvoiceLessOpps;
    static  set<String> setInvoiceLessCountries = new set<String>{'AS', 'AU', 'AT', 'AZ', 'BE', 'KH', 'CA', 'IC', 'CN', 'CK', 'HR', 'CY', 'CZ', 'DK','DO', 'EN', 'EE', 'FJ', 'FI', 'FR', 'PF', 'DE', 'GU', 'GG', 'HO', 'HK', 'HU', 'IN','ID', 'IE', 'IT', 'JP', 'JE', 'KI', 'KO', 'LV', 'LI', 'LT', 'LU', 'MO', 'M3', 'MY','MV', 'MT', 'MH', 'MX', 'FM', 'MC', 'MN', 'NP', 'NL', 'NC', 'NZ', 'NB', 'MP', 'NO','PW', 'PG', 'PH', 'PL', 'PO', 'PT', 'PR', 'RO', 'RT', 'SP', 'SF', 'SG', 'SK', 'SI','SB', 'ZA', 'KR', 'ES', 'SX', 'UV', 'VL', 'SE', 'CH', 'SY', 'TA', 'TW', 'TH', 'TL','TI', 'TO', 'TU', 'TV', 'GB', 'VI', 'VU', 'VA', 'VN', 'WL', 'WF', 'WS', 'YA'};

    
    static void testData() {
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'Payment', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity opp = new Opportunity(Shipping_Street__c ='test\n test',amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'closed',UPS_Service_Code_For_Xml__c='GND',Program__c = 'Print',Product_Ids__c='2504' ,closedate = system.today()+ 15,Country_Code_for_UPS__c = 'US',Ups_Stage__c ='New Order',Has_Books__c = true,Cancel_Books__c =false);        
        insert opp;
        //lstDomesticOpps.add(opp.id) ;
         
        opportunity opp1 = new Opportunity(Shipping_Street__c ='test\n test',amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'closed',UPS_Service_Code_For_Xml__c='EX',Program__c = 'Print',Product_Ids__c='2504' ,closedate = system.today()+ 15,Country_Code_for_UPS__c = 'GR',Ups_Stage__c ='New Order',Has_Books__c = true,Cancel_Books__c =false);        
        insert opp1; 
       // lstInternationalOpps.add(opp1);
         
        opportunity opp2 = new Opportunity(Shipping_Street__c ='test\n test',amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'closed',UPS_Service_Code_For_Xml__c='SV',Program__c = 'Print',Product_Ids__c='2504',closedate = system.today()+ 15,Country_Code_for_UPS__c = 'IN',Ups_Stage__c ='New Order',Has_Books__c = true,Cancel_Books__c =false);        
        insert opp2; 
        //lstInternationalOpps.add(opp2);
    }
    
    static testMethod void unitTest_1(){
        
       
        test.startTest();
         testdata();
        shippingBatchclass datapoint = new shippingBatchclass();
         ID batchprocessid  = Database.executeBatch(datapoint);      
        test.stopTest();
              
        
    }
}