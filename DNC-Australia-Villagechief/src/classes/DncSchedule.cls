global with sharing class DncSchedule implements Schedulable{
   private String objectApiName;
   private String[] fieldApiName;
   private Integer ageToRecheck;
   private String filter;
    
   public DncSchedule(String objectApiName, String[] fieldApiName, Integer ageToRecheck, String filter){
        this.objectApiName = objectApiName;
        this.fieldApiName = fieldApiName;
        this.ageToRecheck = ageToRecheck;
        this.filter = filter;
   }
   public DncSchedule(String objectApiName, String fieldApiName, Integer ageToRecheck, String filter){
        this.objectApiName = objectApiName;
        this.fieldApiName = new String[]{fieldApiName};
        this.ageToRecheck = ageToRecheck;
        this.filter = filter;
   }
   
   global void execute(SchedulableContext SC) {
      Date recheckBefore = null;
      if ( ageToRecheck > 0 )
          recheckBefore = System.today() - ageToRecheck;
      
      DncBatchable b = new DncBatchable(objectApiName, fieldApiName, recheckBefore, filter);
      Id batchProcessId = Database.executeBatch(b, 100);    
   }
   
}