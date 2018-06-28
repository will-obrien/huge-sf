global class updateDateOfVisitSchedulable implements Schedulable
{
   global void execute(SchedulableContext SC) 
   {
      updateDateOfVisit ER  = new updateDateOfVisit();
      ER.weeklyUpdateOfDate(); 
   }
}
