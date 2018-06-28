global class MySchedulableClass implements Schedulable
{
    global void execute(SchedulableContext ctx)
    {
        CronTrigger ct = [Select Id,CronExpression,TimesTriggered,NextFireTime
                         From CronTrigger WHERE Id=:ctx.getTriggerId()];
        
        system.debug(ct.CronExpression);
        system.debug(ct.TimesTriggered);
        
        Merchandise__c m = new Merchandise__c( 
            		Name ='Scheduled Job Item' , Quantity__c=1,Price__c = 2, Warehouse__c='a0E280000004fpg');
        
        insert m;
    }

}