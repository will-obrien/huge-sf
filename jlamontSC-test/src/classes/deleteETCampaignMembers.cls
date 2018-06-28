global class deleteETCampaignMembers implements Database.Batchable<sObject>{
//global class deleteSubscribers implements Database.Batchable<sObject>{

    global final String theQuery;

    global deleteETCampaignMembers(String q){
        theQuery = q;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(theQuery);
    }

    global void execute(Database.BatchableContext BC,List<CampaignMember> scope){
        delete scope;
    }

    global void finish(Database.BatchableContext BC){}
}