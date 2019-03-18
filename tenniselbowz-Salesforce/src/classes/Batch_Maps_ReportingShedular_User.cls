global class Batch_Maps_ReportingShedular_User implements Schedulable {
  global void execute(SchedulableContext SC) {
    Database.executeBatch(new BatchProcess_MAPS_Users());
    /*Database.executeBatch(new BatchProcess_MAPS_Total_User());
    
    Database.executeBatch(new BatchProcess_MAPS_Roles(), 1);*/

  }
  
  static testmethod void testThisClass(){    
      Test.startTest(); 
      //defien the CRON Expression
      String CRON_EXP;
      CRON_EXP = '0 0 2 * * ?';
      Batch_Maps_ReportingShedular_User s = new Batch_Maps_ReportingShedular_User();
      SchedulableContext sc;
      s.execute(sc);
      System.schedule('test-Batch_Maps_ReportingShedularUser', CRON_EXP, s);
      //System.schedule('test-Batch_Maps_ReportingShedular', '0 0 2 * * ?', new Batch_Maps_ReportingShedular());
      Test.stopTest();
   }
}