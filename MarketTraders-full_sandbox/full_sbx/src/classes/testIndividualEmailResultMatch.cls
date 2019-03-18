@IsTest
private class testIndividualEmailResultMatch {

    private static testMethod void defaultTest() {
        integer testSize = 200;
        
        mti_TestFactory testFactory = new mti_TestFactory();
        list<Account> testAccounts = testFactory.getTestPersonAccounts(testSize, true);
        map<Id,Account> accountMap = new Map<Id,Account>(testAccounts);
        map<Id,Contact> contactMap = new map<Id,Contact>([SELECT Id,AccountId FROM Contact WHERE AccountId IN :accountMap.keySet()]);
        map<Id,Id> contactToAccountMap = new map<Id,Id>();
        for(Contact con : contactMap.values()){
            contactToAccountMap.put(con.Id,con.AccountId);
        }
        String jobId = testFactory.getRandomNumberAsString(8);
        et4ae5__SendDefinition__c testSendDefinition = testFactory.getTestSendDefinition(jobId,true);
        list<et4ae5__IndividualEmailResult__c> testIndividualEmailResults = testFactory.getTestIndividualEmailResults(contactMap.keySet(),testSendDefinition,true);
        
        Webinar_Credentials__c testCredentials = testFactory.getWebinarCredentials(true);
        Webinar__c testWebinar = testFactory.getWebinar(testCredentials, true);
        
        list<Webinar_Attendance__c> testWebinarAttendances = testFactory.getWebinarAttendances(testWebinar,'Scheduled',accountMap.keySet(),false);
        for(Webinar_Attendance__c attendance : testWebinarAttendances){
            attendance.ET_Job_ID__c = decimal.valueOf(jobId);
        }
        Database.insert(testWebinarAttendances);

        test.startTest();
        	Batch_AttendanceEmailSync testBatch = new Batch_AttendanceEmailSync();
        	Database.executeBatch(testBatch,200);
        test.stopTest();
        
        list<Webinar_Attendance__c> updatedAttendance = [SELECT Id,IER_et4ae5_SendDefinition__c FROM Webinar_Attendance__c WHERE Individual_Email_Result_Linked__c != NULL];
        system.assertEquals(200,updatedAttendance.size());
     	system.assertEquals(testSendDefinition.Id,updatedAttendance[0].IER_et4ae5_SendDefinition__c);   
        
    }
    
}