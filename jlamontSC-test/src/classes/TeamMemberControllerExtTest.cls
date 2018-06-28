@isTest
public class TeamMemberControllerExtTest {
    
    private static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static Id teamTypeId = Schema.SObjectType.Club_Entity__c.getRecordTypeInfosByName().get('Team').getRecordTypeId();
    
    static testMethod void myUnitTest() {
        
        Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
        );
        insert account1;
        
        Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            Email = 'test1.contact1@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );           
        insert contact1;
        
        Club_Entity__c entity = new Club_Entity__c(
            Name = 'Test Entity',
            RecordTypeId = teamTypeId,
            Entity_Category__c = 'Conservation Dept',
            Entity_Type__c = 'Organizing Teams'
        );
        insert entity;
        
        Leader_Position__c pos = new Leader_Position__c(
            Name = 'Test Position',
            Code__c = 'TEST',
            Active__c = true,
            Entity_Types__c = 'Organizing Teams'
        );        
        insert pos;
      
        Leadership__c lead = new Leadership__c(Club_Entity__c = entity.Id, Contact__c = contact1.id, Leader_Position__c = pos.id);
        insert lead;
        
        PageReference PageRef = Page.NewAction;
        Test.setCurrentPage(PageRef);   
        TeamMemberControllerExt controller = new TeamMemberControllerExt(new ApexPages.StandardController(lead));
        controller.getPositionOptions();
        
    }    

}