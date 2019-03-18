@isTest
public with sharing class SampleAccountTriggerTest {
// test
    public static testmethod void t1() {
        helloMethod();

        Account acc = new Account(Name= 'fred');
        insert acc; // hit the trigger abc

        // Check that the trigger properly set the phone field:
        Account retAcc = [select id, phone from Account where id=:acc.id][0];
        System.assertEquals(getPhone(), retAcc.phone);
    }

    public static String getPhone() {
        return 'SamplePhone#';
    }
    
    public static void helloMethod() {
        System.debug('Hello World');
    }
}