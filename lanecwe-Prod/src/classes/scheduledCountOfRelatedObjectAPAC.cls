global class scheduledCountOfRelatedObjectAPAC  implements Schedulable{
global void execute(SchedulableContext sc) {
  CountOfRelatedObjectBatchClassAPAC b = new CountOfRelatedObjectBatchClassAPAC();
   database.executebatch(b);
  }
}