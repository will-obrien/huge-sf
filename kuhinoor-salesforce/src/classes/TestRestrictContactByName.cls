@isTest
public class TestRestrictContactByName {
    @isTest
    static void unit(){
        Contact c = new Contact();
        c.lastname='INVALIDNAME';
        insert c;
    }
}