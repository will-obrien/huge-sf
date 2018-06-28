global class deleteBUContactAddresses implements Database.Batchable<sObject>{

    global final String theQuery;

    global deleteBUContactAddresses(String q){
        theQuery = q;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(theQuery);
    }

    global void execute(Database.BatchableContext BC,List<rC_Bios__Contact_Address__c> scope){
        delete scope;
    }

    global void finish(Database.BatchableContext BC){}
}