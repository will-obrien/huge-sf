@isTest
public class ExperienceOtherCompany_test {
    static Account account ;
    static Opportunity opportunity; 
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    
    static void testData(){
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        
    }
    
    static testMethod void unitTest_1(){
        
        testData();
        test.startTest();
        Experience__c exp = new Experience__c ();
        exp.company__c = account.id;
        exp.Contact__c = contact.id;
        exp.CompanyOther__c = 'yteuriskjb';
        exp.Job_Description__c = 'trew';
        exp.Start_Date__c = system.today() +12;
        insert exp;
        test.stopTest();
    }
}