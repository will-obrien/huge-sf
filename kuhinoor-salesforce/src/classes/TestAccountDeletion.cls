@isTest
public class TestAccountDeletion{
    Static testMethod void unit(){
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'testlname';
        con.accountid = acc.id;
        insert con;   
         
        // Perform test
        Test.startTest();
        Database.DeleteResult result = Database.delete(acc, false); 
        Test.stopTest();
              
        system.debug('#######'+result.getErrors()[0].getMessage());
        system.assert(!result.isSuccess());
        system.assert(result.getErrors().size()>0); 
        System.assertEquals(result.getErrors()[0].getMessage(),'CanNot delete this Account');       
    }
}