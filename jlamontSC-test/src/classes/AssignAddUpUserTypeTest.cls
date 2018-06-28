@isTest
public class AssignAddUpUserTypeTest {
    
    static testMethod void unitTest() {
        Id entityTypeId = Schema.SObjectType.Club_Entity__c.getRecordTypeInfosByName().get('Club Entity').getRecordTypeId();
        Id hhAcctTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        Id hhContactTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        
        Account a = new Account(Name = 'Test Account', RecordTypeId = hhAcctTypeId);
        insert a;
        
        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', RecordTypeId = hhContactTypeId, AccountId = a.Id);
        insert c;
        
        Club_Entity__c ent = new Club_Entity__c(Name = 'Test Entity', RecordTypeId = entityTypeId, Bypass_Validations__c = true);
        insert ent;
        
        Leader_Position__c lp = new Leader_Position__c(Name = 'Test Position', Code__c = 'LPOS');
        insert lp;
        
        Leader_Position__c lp2 = new Leader_Position__c(Name = 'Test Position 2', Code__c = 'LPOT');
        insert lp2;        
        
        //insert a leadership - Contact should be set to user type 4
        Leadership__c l1 = new Leadership__c(Contact__c = c.Id, Club_Entity__c = ent.Id, Leader_Position__c = lp.Id, Position_Status__c = 'Active');
        insert l1;
		Contact ct = [SELECT Id, AddUP_User_Type__c FROM Contact WHERE Id = :c.Id];        
        System.assertEquals('4 - Local Entity Campaign Creator', ct.AddUP_User_Type__c);
        
		//insert another leadership - Contact should retain user type 4
        Leadership__c l2 = new Leadership__c(Contact__c = c.Id, Club_Entity__c = ent.Id, Leader_Position__c = lp2.Id, Position_Status__c = 'Active');
        insert l2; 
        ct = [SELECT Id, AddUP_User_Type__c FROM Contact WHERE Id = :c.Id];
        System.assertEquals('4 - Local Entity Campaign Creator', ct.AddUP_User_Type__c);
        
		//delete a leadership - Contact should retain user type 4 since there is a second leadership
        delete l1;
        ct = [SELECT Id, AddUP_User_Type__c FROM Contact WHERE Id = :c.Id];
        System.assertEquals('4 - Local Entity Campaign Creator', ct.AddUP_User_Type__c);
        
        //delete second leadership - Contact should not have a user type since no more leaderships remain
        delete l2;
        ct = [SELECT Id, AddUP_User_Type__c FROM Contact WHERE Id = :c.Id];
        System.assertEquals(null, ct.AddUP_User_Type__c);        
       
    }

}