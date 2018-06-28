@isTest
public class onCPEActivityInsertUpdate_test {

    static testMethod void unitTest_1(){
        
        test.startTest();
        Account acc = new Account(name = 'test');
        insert acc;
        CPE_Activity_Type__c  type = new CPE_Activity_Type__c (name = 'test');
        insert type;
        CPE_Activity__c activity = new CPE_Activity__c(Title__c = 'test',Activity_Type_Description__c = 'test',Provider__c = 'test',CPE_Activity_Type__c  = type.id);
        insert activity;
        test.stopTest();
    }
}