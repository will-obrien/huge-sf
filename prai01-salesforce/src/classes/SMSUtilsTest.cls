@isTest
private class SMSUtilsTest {
    
    private class Result{
        String status;
        String value;
    }

    @isTest
    private static void testSendSms(){
        Test.setMock(HttpCalloutMock.class, new SMSUtilsCalloutMock());
        Test.startTest();
            SMSUtils.sendSMSAsync('7202317361','7209825150','Test message');
        Test.stopTest();
        
        //runs callout and check results
        List<SMS_Log__c> logs = [SELECT msg__c FROM SMS_Log__c];    
        System.assertEquals(1, logs.size(),'Expected one entry in the log');
        String strLog = (String)logs[0].msg__c;
        Result response = (Result)JSON.deserializeStrict(strLog , Result.class);

        System.assertEquals('success', response.status,'Expected success');
    }


}