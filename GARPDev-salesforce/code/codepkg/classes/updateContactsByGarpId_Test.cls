@isTest
public class updateContactsByGarpId_Test {

	static Account a1;
    static Contact c1;
    static certificate_shipping__c cert;
    static certificate_shipping__c cert1;
    static void testdata()
    {
        a1 = new Account(name = 'Test Account1');
        insert a1;
        c1 = new contact(lastname = 'Doe',firstname='John',AccountID = a1.ID,MailingCity='New York',Mailing_Address_Company__c='1234, New Port Mall',MailingCountry='US', email = 'JohnDoe@contact.com',OtherPhone='123456789',MailingPostalCode = '07301',MailingState='NJ', KPI_Member__c = True, Membership_Type__c = 'Individual',KPI_Membership_Payment_Status__c ='In Good Standing',GARP_Member_ID__c='101010');
        insert c1;
    }
    
    static testMethod void unitTest_1(){
        
        testdata();
        test.startTest();
        cert = new certificate_shipping__c (Member__c=c1.id,CurrencyIsoCode = 'USD',Ups_Stage__c='New Order',Total_Package_Weight__c = '30',Country_Code_for_UPS__c='US',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True,Garp_id__c='101010');
        insert cert;
        cert1 = new certificate_shipping__c (Member__c=c1.id,CurrencyIsoCode = 'USD',Ups_Stage__c='New Order',Total_Package_Weight__c = '30',Country_Code_for_UPS__c='US',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True);
        insert cert1;
        test.stopTest();
              
        
    }
    
    
}