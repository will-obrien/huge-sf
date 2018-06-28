global class DeleteNotation implements Schedulable {
   global void execute(SchedulableContext SC) {
      Notation__c notation = [SELECT Note__c FROM Notation__c];
      notation.Note__c = '';
      update notation;
   }
}
