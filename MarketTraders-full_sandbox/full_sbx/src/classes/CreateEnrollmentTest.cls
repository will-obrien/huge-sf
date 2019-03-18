@isTest(SeeAllData=false)
private class CreateEnrollmentTest {
    
    static testMethod void testCreateEnrollmentOnInsert() {
        Test.startTest();
        // create custom settings
        List<PB_Course__c> customSettings = new List<PB_Course__c> {
            new PB_Course__c(Name='PB_Client_Art_Of_Yen_Course__c', Course_API_Name__c='PB_Client_Art_Of_Yen_Course__c')
        };
        insert customSettings;
        // create courses
        List<Course__c> courses = new List<Course__c> {
            new Course__c(Course_API_Name__c='PB_Client_Art_Of_Yen_Course__c')
        };
        insert courses;
        
        Set<ID> courseIds = new Set<Id>();
        for(Course__c cr : courses) {
            System.debug('## --> ' + cr.ID);
            courseIds.add(cr.ID);
        }
        
        // create account
        Account acc = new Account(FirstName='FirstTester', LastName='LastTest', RecordTypeId = getRecordTypeId(),
                                 PersonEmail ='johnsmith@test.com', Country_List__c='United States of America');
        acc.PB_Client_Art_Of_Yen_Course__c = true;
        insert acc;
        
        acc.PB_Client_Art_Of_Yen_Course__c = false;
        update acc;                
        
        acc.PB_Client_Art_Of_Yen_Course__c = true;
        update acc; 
        
        //List<Enrollment__c> enList = [SELECT Id FROM Enrollment__c WHERE Course__c IN :courseIds];
        //System.assertEquals(courses.size(), enList.size());
        
        Test.stopTest();
    }
    
    private static String getRecordTypeId(){
        return [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName='PersonAccount'].Id;
    }
}