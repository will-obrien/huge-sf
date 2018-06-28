@isTest
public class RoomWrapper_test {
    
    static Site__c site;
    static Venue__c venue;
    static room__c room;
    static room__c room1;
    
    static void testData(){
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        venue = new venue__c(site__c = site.id);
        insert venue;
        
        room = new room__c (Venue__c  = venue.id,Capacity__c = 12);
        insert room;
        
        room1 = new room__c (Venue__c  = venue.id,Capacity__c = 12);
        insert room1;
    }
    static testMethod void unitTest_1(){
        
        test.startTest();
        testData();
        List<roomwrapper> empList = new List<roomwrapper>();
        empList.add(new roomwrapper(room));
        empList.add(new roomwrapper(room1));
        empList.sort();
        test.stopTest();        
    }
}