@isTest
public class UpdateClosedDateTriggerTest {
           
    static testmethod void closedDateTestMethod(){
        Defect__c def = new Defect__c(Status__c = 'Open-In Review', Subject__c = 'abcd', Detailed_Description__c = 'New Test', 
                                      Environment__c = 'sandbox');
        insert def;
        def.Status__c = 'Closed';
        update def;
        
    }
    
    static testmethod void closedDateTestMethod2(){
        Defect__c def1 = new Defect__c(Status__c = 'Closed', Subject__c = 'defg', Detailed_Description__c = 'New Test1', 
                                      Environment__c = 'prod');
        insert(def1);
        def1.Status__c = 'Open-In Review';
        update def1;
        
    }
   
    
}