global with sharing class JRA_BatchLegislatorUpdate implements Database.Batchable<SObject>, Database.AllowsCallouts {
/*
PNC June 2015
To enable legisaltor updates in batch, we provide a simple bacth interface that expects to receive contact records
sQuery can use any filter, but should be include following fields:
Id 
Legislator_Data_Status__c 
MailingPostalCode 

It should only include records that have a valid zip - typically marked by trigger as "Ready to Process" 
*/

global String sQuery;

    global Database.QueryLocator start (Database.BatchableContext context) {
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext context, List<Contact> scope) {
        JRA_ContactUpdateService JRACUS = new JRA_ContactUpdateService();
        JRACUS.executecallout(scope);
        JRACUS.executeupdate();
    }
    
    global void finish(Database.BatchableContext context) {
       
    }
}