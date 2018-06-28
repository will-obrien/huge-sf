global class scheduledCountOfRelatedObjectEMEA  implements Schedulable{
global void execute(SchedulableContext sc) {
  CountOfRelatedObjectBatchClassEMEA b = new CountOfRelatedObjectBatchClassEMEA();
   database.executebatch(b);
  }
}