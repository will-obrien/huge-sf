/*
MergeProcessor

Created by: Mark Maslow
Created on: September, 2014

This is the main driver for the Merge Process.

Look for Merge Requests that do not have any errors, and are not yet complete.

Determine the next step and execute it.

If the step executed is not the final step, submit a new batch to execute the next step.
*/
global class MergeProcessor implements Database.Batchable<sObject> {
    public static final Decimal setupStep = 1; 
    public static final Decimal checkChildrenStep = 2;
    public static final Decimal mergePreferencesStep = 3;
    public static final Decimal mergeContactsStep = 4;
    public static final Decimal deleteObjectsStep = 5;
    public static final Decimal mergeAccountsStep = 6;
    public static final Decimal finalStep = 6;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Decimal stepToComplete = getStepToComplete();
        return Database.getQueryLocator([
            SELECT 
                Id,
                Previous_Account__c,
                Retained_Account__c,
                Previous_Contact__c,
                Retained_Contact__c,
                Last_Step_Completed__c,
                Date_Last_Step_Completed__c, 
                Error_Message__c,
                Has_Error__c,
                Retained_Accounts_Match__c,
                Retained_Contacts_Match__c
            FROM Merge_Request__c
            WHERE Has_Error__c = false AND Last_Step_Completed__c = :stepToComplete
            ORDER BY Previous_Account__c, Previous_Contact__c NULLS LAST
        ]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Merge_Request__c> mergesToProcess = new List<Merge_Request__c>();
        for(sObject obj : scope) {
            Merge_Request__c request = (Merge_Request__c) obj;
            mergesToProcess.add(request);
        }
        Decimal stepToComplete = getStepToComplete();
        Decimal nextStep = stepToComplete + 1;
        
        System.debug('nextStep:' + nextStep);
        System.debug('mergesToProcess.size:' + mergesToProcess.size());
        
        if(nextStep == setupStep) {
            MergeSetup.setUpMerge(mergesToProcess);
        }
        else if(nextStep == checkChildrenStep) {
            MergeCheckChildren.processMerges(mergesToProcess);
        }
        else if(nextStep == mergePreferencesStep) {
            MergePreferences.processPreferences(mergesToProcess);
        }
        else if(nextStep == mergeContactsStep) {
            MergeContacts.processContacts(mergesToProcess);
        }
        else if(nextStep == deleteObjectsStep) {
            MergeDelete.processMerges(mergesToProcess);
        }
        else if(nextStep == mergeAccountsStep) {
        	MergeAccounts.processAccounts(mergesToProcess);
        }
    }

    global void finish(Database.BatchableContext BC){
        Decimal stepToComplete = getStepToComplete();
        if(stepToComplete < finalStep) {
            Database.executeBatch(new MergeProcessor(), 10);
        }
    }
    private Decimal getStepToComplete() {
        AggregateResult[] result = [
            SELECT MIN(Last_Step_Completed__c) min 
            FROM Merge_Request__c
            WHERE Has_Error__c = false AND Last_Step_Completed__c < :finalStep
        ];
        Decimal min = (Decimal)result[0].get('min');
        if(min == null) {
            min = finalStep + 1;
        }
        return min;
    }
    public static String appendMergeError(String existingMessage, String newMessage) {
    	String returnValue;
    	if(existingMessage == null) {
    		existingMessage = '';
    	}
    	returnValue = existingMessage + ' ' + newMessage;
    	if(returnValue.length() > 225) {
    		returnValue = returnValue.substring(0, 225);
    	}
    	return returnValue;
    }
}