/*
    Test class for Employee insert update trigger
*/
@isTest
public class EmployeeInsertUpdateTriggerTest {
    
    static testMethod void mapEmployeeContactTest(){

        Country__c country = new Country__c();
        country.Name = 'USA';
        insert country;

        Country__c country2 = new Country__c();
        country2.Name = 'UK';
        insert country2;
        
        //Create Account
        Account acc = new Account();
        acc.Name = 'Test dimagi';
        insert acc;

        Account acc2 = new Account();
        acc2.Name = 'Test dimagi 2';
        insert acc2;

        //Create Contact
        Contact reportsTo = new Contact();        
        reportsTo.AccountId = acc.Id;
        reportsTo.Title = 'Test Title';
        reportsTo.MobilePhone = '9856254175';
        reportsTo.Department = 'Account';
        reportsTo.FirstName = 'Test';
        reportsTo.LastName = 'Contact';
        reportsTo.Skype__c = 'test123';
        reportsTo.Email = 'test@test.com';
        reportsTo.Country__c = country.Id;
        insert reportsTo;
        
        //Create Contact
        Contact contact = new Contact();        
        contact.AccountId = acc.Id;
        contact.Title = 'Test Title';
        contact.MobilePhone = '9856254175';
        contact.Department = 'Account';
        contact.FirstName = 'Test';
        contact.LastName = 'Contact';
        contact.Skype__c = 'test123';
        contact.Email = 'test@test.com';
        contact.ReportsToId = reportsTo.Id;
        contact.Country__c = country.Id;
        insert contact;

        //Create Employee
        SFDC_Employee__c emp = new SFDC_Employee__c();
        emp.Name = 'Test employee';
        emp.Contact__c = contact.Id;
        emp.Salary__c = 5000;
        emp.Exchange_Rate__c = 10;
        emp.Effective_Salary_Date__c = Date.newInstance(2016, 2, 24);
        emp.Effective_Exchange_Rate_Date__c = Date.newInstance(2016, 2, 24);
        Test.startTest();

        insert emp;

        List<SFDC_Employee__c> employees = [SELECT Id, Title__c, Emergency_Contact_Phone__c, Sub_Unit__c, Field_Location__c
                                            ,Country__c
                                            FROM SFDC_Employee__c WHERE Id =:emp.Id];

        List<Contact> contacts = [Select Id, Title, MobilePhone From Contact where Id = :contact.Id];  
        
        System.assertNotEquals(employees, null);
        System.assertNotEquals(contacts, null);
        
        if(employees != null && !employees.isEmpty()){
            if(contacts != null && !contacts.isEmpty()){
                System.assertEquals(employees[0].Title__c, contacts[0].Title);              
            }
        }                                       
        
        Test.stopTest();
        
        //Update Employee
        //emp.Entity__c = 'Dimagi, Inc.';
        emp.Title__c = 'Test Title';
        emp.Sub_Unit__c = 'Tech';
        emp.Name = 'Test Employee 123';
        emp.Skype_ID__c = 'test12345';
        emp.Email_Address__c = 'test123@test.com';
        emp.Direct_Manager_Lookup__c = null;
        emp.Country__c = country2.Id;
        update emp;
        
        CheckRecursive.firstRun=true;
        contact.AccountId = acc2.Id;
        contact.Title = 'Test Title 2';
        contact.MobilePhone = '98562541756';
        contact.Department = 'Mgmt';
        contact.FirstName = 'Test 1';
        contact.LastName = 'Contact 1';
        contact.Skype__c = 'test12389';
        contact.Email = 'test789@test.com';
        contact.Country__c = country2.Id;
        update contact;
        
        //System.assertEquals(emp.Title__c, contact.Title); 
        
    } 
    
}