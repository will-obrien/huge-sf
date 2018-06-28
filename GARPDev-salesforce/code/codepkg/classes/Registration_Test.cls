@isTest
public class Registration_Test{
    
    static void setup(){
        insert new UpdateIds__c(Name='Payment', Record_Id__c='a0cf00000041nXB');
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');
    }
    
    static testMethod void testChapterMeetingRegister(){
        setup();
        String contactId = [Select Id,ContactId from User where Id = :UserInfo.getUserId()].ContactId;
        Chapter_Meeting__c meeting = new Chapter_Meeting__c(Name='Test Chapter Meeting', Start__c=System.now().addDays(15), End__c=System.now().addDays(15).addHours(2));
        insert meeting;
        //Register for meeting
        System.assertEquals(true, Registration.chapterMeetingRegister(contactId, meeting.id, true), 'Chapter meeting register not successful');
        List<Chapter_Meeting_Registration__c> registrations = [select Id, Name from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :meeting.id and Contact__c = :contactId];
        System.assertEquals(1, registrations.size(), 'Number of chapter meeting registrations not as expected');
        //Unregister for meeting
        System.assertEquals(true, Registration.chapterMeetingRegister(contactId, meeting.id, false), 'Chapter meeting unregister not successful');
        registrations = [select Id, Name from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :meeting.id and Contact__c = :contactId];
        System.assertEquals(0, registrations.size(), 'Number of chapter meeting registrations not as expected');
    }
}