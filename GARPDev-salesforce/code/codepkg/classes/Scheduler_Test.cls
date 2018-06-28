@isTest
private class Scheduler_Test{

  
    static testMethod void testM() {

        //testData();
        test.startTest();
        scheduleChargemodificationsonopp s1 = new scheduleChargemodificationsonopp();
         scheduleShippingBatchclass s2 = new scheduleShippingBatchclass();
          scheduleUpdateContracts s3 = new scheduleUpdateContracts();
           createOppForRecurrings s4 = new createOppForRecurrings();
        test.stopTest();
    }
}