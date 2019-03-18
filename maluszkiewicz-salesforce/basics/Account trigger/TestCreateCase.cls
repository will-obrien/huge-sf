@IsTest
public class TestCreateCase {
    static testMethod void accountCreator() {
        Account acc = new Account();
        acc.Name = 'Konrad Account';
        insert acc;
    }
}