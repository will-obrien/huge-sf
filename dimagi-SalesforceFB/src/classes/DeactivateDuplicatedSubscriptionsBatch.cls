public class DeactivateDuplicatedSubscriptionsBatch implements Database.Stateful, Database.Batchable<Domain__c> {

    public List<Domain__c> start(Database.BatchableContext context) {
       AggregateResult[] groupedResults = [SELECT Accounting_subscriber_domain__c, COUNT(Id) FROM Accounting_Subscription__c
                        WHERE Accounting_subscriber_domain__c != null AND Accounting_subscriber_domain__c != '' AND
                        is_active__c = true GROUP BY Accounting_subscriber_domain__c HAVING COUNT(Id) > 1];

        Set<Id> domainsId = new Set<Id>();
        for (AggregateResult result : groupedResults) {
            Id domainId = (Id) result.get('Accounting_subscriber_domain__c');
            domainsId.add(domainId);
        }

        return [SELECT Id, Name, Server_Name__c FROM Domain__c WHERE Id IN: domainsId];
    }

    public void execute(Database.BatchableContext context, List<Domain__c> domains) {
        String message = '';
        for (Domain__c domain : domains) {
            message += (' Domain Name: ' + domain.Name + ' Server Name: ' + domain.Server_Name__c
                                + ' Domain ID:  ' + domain.Id + '</br>');
        }
        if (!Test.isRunningTest() && message != '') {
            EmailHelper.sendEmail(BatchDefaultSettings__c.getOrgDefaults().Error_Emails__c.split(','),
                        'Duplicacted Subscriptions found', message);
        }
    }

    public void finish(Database.BatchableContext context) {

    }
}