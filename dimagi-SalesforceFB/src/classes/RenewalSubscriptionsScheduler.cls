/**
 * Schedules RenewalSubscriptionsBatch job for creating new Opps and Fogbugz cases.
 */
public without sharing class RenewalSubscriptionsScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
       Database.executeBatch(new RenewalSubscriptionsBatch(), 50);
    }
}