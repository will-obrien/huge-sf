@isTest
public class testCandidateTrigger {
    static testMethod void insert_cand(){
        	Candidate__c can = new Candidate__c();
        	can.First_Name__c ='Sank';
            can.Last_Name__c ='Dam';   
     insert can;   
    }
 
    
}