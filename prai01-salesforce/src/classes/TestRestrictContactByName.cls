@isTest
public class TestRestrictContactByName {

    @isTest static void testContactLastName(){
        Contact cont = new Contact(FirstName = 'Prakash', LastName = 'INVALIDNAME');
        Test.startTest();
        insert cont;
        Test.stopTest();
        
        System.assertEquals('The Last Name INVALIDNAME is not allowed for DML', 'The Last Name INVALIDNAME is not allowed for DML');
    }
}