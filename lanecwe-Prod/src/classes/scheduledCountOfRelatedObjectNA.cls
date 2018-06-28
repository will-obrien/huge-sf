global class scheduledCountOfRelatedObjectNA  implements Schedulable{
global void execute(SchedulableContext sc) {
  CountOfRelatedObjectBatchClassNA  b = new CountOfRelatedObjectBatchClassNA();
   database.executebatch(b);
  }
}