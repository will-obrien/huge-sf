@isTest
public class SnoozeContactControllerTest{

    public static testMethod void testMethod1() {
        Account theAccount = new Account(
            Name = 'Test Account'
        );
        insert theAccount;
        Contact theContact = new Contact(
            LastName = 'Test Contact',
            AccountId = theAccount.Id
        );
        insert theContact;
        
        ApexPages.currentPage().getParameters().put('id',theContact.Id);
        SnoozeContactController obj = new SnoozeContactController ();
        obj.autoRun();
        Task theTask = [Select id from Task where WhoId = :theContact.Id];
        system.assertNotEquals(theTask,null);
    }
}