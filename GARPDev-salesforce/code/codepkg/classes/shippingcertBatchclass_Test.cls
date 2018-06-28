@isTest
public class shippingcertBatchclass_Test {

     
    static Account a1;
    static Contact c1;
    static certificate_shipping__c cert;
    static certificate_shipping__c cert1;
    static certificate_shipping__c cert2;
    
    
    // static List<Opportunity> lstDomesticOpps;
    // static List<Opportunity> lstInternationalOpps;
    // static List<Opportunity> lstInvoiceLessOpps;
   // static  set<String> setInvoiceLessCountries = new set<String>{'AS', 'AU', 'AT', 'AZ', 'BE', 'KH', 'CA', 'IC', 'CN', 'CK', 'HR', 'CY', 'CZ', 'DK','DO', 'EN', 'EE', 'FJ', 'FI', 'FR', 'PF', 'DE', 'GU', 'GG', 'HO', 'HK', 'HU', 'IN','ID', 'IE', 'IT', 'JP', 'JE', 'KI', 'KO', 'LV', 'LI', 'LT', 'LU', 'MO', 'M3', 'MY','MV', 'MT', 'MH', 'MX', 'FM', 'MC', 'MN', 'NP', 'NL', 'NC', 'NZ', 'NB', 'MP', 'NO','PW', 'PG', 'PH', 'PL', 'PO', 'PT', 'PR', 'RO', 'RT', 'SP', 'SF', 'SG', 'SK', 'SI','SB', 'ZA', 'KR', 'ES', 'SX', 'UV', 'VL', 'SE', 'CH', 'SY', 'TA', 'TW', 'TH', 'TL','TI', 'TO', 'TU', 'TV', 'GB', 'VI', 'VU', 'VA', 'VN', 'WL', 'WF', 'WS', 'YA'};

    
    static void testData() {
        
        a1 = new Account(name = 'Test Account1');
        insert a1;
        c1 = new contact(lastname = 'Doe',firstname='John',AccountID = a1.ID,MailingCity='New York',Mailing_Address_Company__c='1234, New Port Mall',MailingCountry='US', email = 'JohnDoe@contact.com',OtherPhone='123456789',MailingPostalCode = '07301',MailingState='NJ', KPI_Member__c = True, Membership_Type__c = 'Individual',KPI_Membership_Payment_Status__c ='In Good Standing',GARP_Member_ID__c='101010');
        insert c1;
        
        cert = new certificate_shipping__c (Member__c=c1.id,CurrencyIsoCode = 'USD',Ups_Stage__c='New Order',Total_Package_Weight__c = '30',Country_Code_for_UPS__c='US',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True,Garp_id__c='101010');
        insert cert;
        
        cert1 = new certificate_shipping__c (Member__c=c1.id,CurrencyIsoCode = 'USD',Ups_Stage__c='New Order',Total_Package_Weight__c = '30',Country_Code_for_UPS__c='GR',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True,Garp_id__c='101010');
        insert cert1;
        
        cert2 = new certificate_shipping__c (Member__c=c1.id,CurrencyIsoCode = 'USD',Ups_Stage__c='New Order',Total_Package_Weight__c = '30',Country_Code_for_UPS__c='IN',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True,Garp_id__c='101010');
        insert cert2;
        
        
    }
    
    static testMethod void unitTest_1(){
        
       
        test.startTest();
        testdata();
        shippingcertBatchclass b = new shippingcertBatchclass();
        ID batchprocessid  = Database.executeBatch(b);      
        test.stopTest();
              
        
    }
    
}