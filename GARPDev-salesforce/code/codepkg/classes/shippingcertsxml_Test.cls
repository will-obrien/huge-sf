@isTest
public class shippingcertsxml_Test {

    static certificate_shipping__c cert;
    static void testdata()
    {
        Account a1 = new Account(name = 'Test Account1');
        insert a1;
        Contact c1 = new contact(lastname = 'Doe',firstname='John',AccountID = a1.ID,MailingCity='New York',Mailing_Address_Company__c='1234, New Port Mall',MailingCountry='USA', email = 'JohnDoe@contact.com',OtherPhone='123456789',MailingPostalCode = '07301',MailingState='NJ', KPI_Member__c = True, Membership_Type__c = 'Individual',KPI_Membership_Payment_Status__c ='In Good Standing',GARP_Member_ID__c = '101010');
        insert c1;
        cert = new certificate_shipping__c (Member__c=c1.id,CurrencyIsoCode = 'USD',Ups_Stage__c='Sent to GT',Total_Package_Weight__c = '30',Country_Code_for_UPS__c='US',Customs_Cost__c='15',Duty_Tax_to_Garp__c=True,Garp_id__c='101010');
        insert cert;
    }
    
    static testMethod void unitTest_1(){
        
        testData();
        list<certificate_shipping__c> lstcerts = new list<certificate_shipping__c>{cert};
        test.startTest();
        shippingcertsxml.internationalShipping(lstcerts);
        shippingcertsxml.domesticShipping(lstcerts);
        shippingcertsxml.invoicelessXML(lstcerts);
        test.stopTest();
    }
    
}