public with sharing class showSchdeule {

    public showSchdeule(ApexPages.StandardSetController controller) {

    }


    public List<Schedule__c> sList{get;set;}
    private id dID;
    
    public showSchdeule(ApexPages.StandardController controller) {
     
       sList = new List<Schedule__c>();
       sList = [select Day__c, Time__c from Schedule__c where id =: dID];
       
    }
    
   
}