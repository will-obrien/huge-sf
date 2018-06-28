@isTest
public class EmployeeTriggerTests {
    @testsetup static void setup() {
        Id p = [select id from profile where name='System Administrator'].id;
       
        User user = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
       
        insert user;
        
        List<Business_Unit__c> businessUnits = new List<Business_Unit__c>();
        businessUnits.add(new Business_Unit__c(Name = 'Test Business Unit 1'));
        businessUnits.add(new Business_Unit__c(Name = 'Test Business Unit 2'));
        insert businessUnits;
    }
    
    @isTest static void testBusinessUnitNameUpdate() {
        List<Business_Unit__c> businessUnits = [Select Id, Name From Business_Unit__c];

        test.startTest();
        SFDC_Employee__c emp = new SFDC_Employee__c(
            Name = 'test employee', 
            Email_Address__c = 'tester@noemail.com', 
            Business_Unit__c = businessUnits[0].Id,
            Salary__c = 5000,
            Exchange_Rate__c = 10,
            Effective_Salary_Date__c = Date.newInstance(2016, 2, 24),
            Effective_Exchange_Rate_Date__c = Date.newInstance(2016, 2, 24)
        );
        insert emp;

        emp = [Select Id, SF_User__c, Email_Address__c, Business_Unit__c, Business_Unit__r.Name From SFDC_Employee__c Where Id =: emp.Id];
        User user = [Select Id, Business_Unit_Name__c From User Where Username =: emp.Email_Address__c];
        system.assertEquals(emp.SF_User__c, user.Id);
        system.assertEquals(emp.Business_Unit__r.Name, user.Business_Unit_Name__c);
        
        emp.Business_Unit__c = businessUnits[1].Id;
        emp.SF_User__c = null;
        update emp;
        
        emp = [Select Id, SF_User__c, Email_Address__c, Business_Unit__c, Business_Unit__r.Name From SFDC_Employee__c Where Id =: emp.Id];
        user = [Select Id, Business_Unit_Name__c From User Where Username =: emp.Email_Address__c];
        system.assertEquals(emp.SF_User__c, user.Id);
        system.assertEquals(emp.Business_Unit__r.Name, user.Business_Unit_Name__c);
        test.stopTest();
        
    }
}