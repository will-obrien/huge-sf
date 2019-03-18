@isTest
public class UpdateReopenedCountTriggerTest {
    
    static testmethod void UpdateReopenedCountTestMethod1(){
        Defect__c newDef = new Defect__c(Status__c = 'Failed Retest', Subject__c = 'efgh', Detailed_Description__c = 'New Test',Times_Reopened__c=0);
        insert(newDef);
        newDef.Status__c = 'Expected Behaviour';
        update newDef;
    }
    
    static testmethod void UpdateReopenedCountTestMethod2(){
        Defect__c newDef2 = new Defect__c(Status__c = 'Closed', Subject__c = 'efgh', Detailed_Description__c = 'New Test');
        insert(newDef2);
        newDef2.Status__c = 'Resolved';
        update newDef2;
    }

    static testmethod void UpdateReopenedCountTestMethod3(){
        Defect__c newDef2 = new Defect__c(Status__c = 'In Progress', Subject__c = 'efgh', Detailed_Description__c = 'New Test');
        insert(newDef2);
        newDef2.Status__c = 'RE-OPENED';
        newDef2.Retest_Status__c='Open';
        newDef2.Retesting_Comments__c = 'XYZ';
        update newDef2;
    }
}