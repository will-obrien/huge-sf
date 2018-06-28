/**
 * Batch job for deleting unused Internal Properties custom object.
 */
public class UnusedInternalPropertiesDeleteBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id, (SELECT Id FROM Domain__r) FROM Internal_Properties__c');
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Internal_Properties__c> unusedIntProp = new List<Internal_Properties__c>();
        System.debug('Size : ' + scope.size());
        for (sObject obj : scope) {
            Internal_Properties__c inProp = (Internal_Properties__c) obj;
            if (inProp.Domain__r == null || inProp.Domain__r.size() == 0) {
                unusedIntProp.add(inProp);
            }
        }

        if (unusedIntProp.size() > 0) {
            delete unusedIntProp;
        }
    }

    public void finish(Database.BatchableContext context) {

    }
}