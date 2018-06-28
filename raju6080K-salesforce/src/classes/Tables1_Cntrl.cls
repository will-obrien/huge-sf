public with sharing class Tables1_Cntrl {
    public Table__c tab{get;set;}

    public Tables1_Cntrl() {
        tab = new Table__c();
    }
    public pageReference save(){
        insert tab;
        return null;  
    }
    public pageReference cancel() {
        return page.Hotel; 
    }
}