trigger TestTrigger on Zuora__Subscription__c (before delete) {
   Zuora__Subscription__c[] subscriptions = Trigger.old;
   
   for (zuora__Subscription__c s :subscriptions){
     System.debug('Delete trigger:'+s.Name);
   }
}