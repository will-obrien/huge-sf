global class FindDupContactsSchedulable implements Schedulable {
   global void execute(SchedulableContext SC) {
      FindDupContacts D = new FindDupContacts();
      database.executebatch(D,2000); 
   }
}