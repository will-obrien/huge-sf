global class scheduledBatchable implements Schedulable {
   public static String CRON_EXP = '0 0 12 * * ?';
   global void execute(SchedulableContext sc) {
     
     String query;
     String field;
     String value;
     query='SELECT ID, Name, Description ' +
              'FROM Account ';
     field='Description';
     DateTime myDateTime = (DateTime) System.today();
     String dayOfWeek = myDateTime.format('E');
     value=dayOfWeek;
     SearchAndReplace SandR = new SearchAndReplace(query,field,value);
       
    
     database.executebatch(SandR);
   }
   public static void startJob(){
        System.schedule('test', CRON_EXP, new scheduledBatchable());
    }
}