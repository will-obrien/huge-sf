global class Batch_Maps_ReportingShedular_Total implements Schedulable {
  global void execute(SchedulableContext SC) {
    integer bsize = 1;
    if(Test.IsRunningTest())bsize=2000;
    Database.executeBatch(new BatchProcess_MAPS_Total(), bsize);

  }
  
  static testmethod void testThisClass(){    
      Test.startTest(); 
      //defien the CRON Expression
      String CRON_EXP;
      CRON_EXP = '0 0 2 * * ?';
      Batch_Maps_ReportingShedular_Total s = new Batch_Maps_ReportingShedular_Total();
      SchedulableContext sc;
      s.execute(sc);
      System.schedule('test-Batch_Maps_ReportingShedularTotal', CRON_EXP, s);
      //System.schedule('test-Batch_Maps_ReportingShedular', '0 0 2 * * ?', new Batch_Maps_ReportingShedular());
      Test.stopTest();
   }
}