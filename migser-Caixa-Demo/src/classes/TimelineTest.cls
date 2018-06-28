@isTest
public class TimelineTest {

    private static List<Campaign> createCampaigns(){
        List<Campaign> recordList = new List<Campaign>();
        recordList.add(new Campaign(
            Name='abd', startDate=Date.today(), endDate=Date.today().addDays(2), 
            Description='abc description', mediaUrl__c='/abc.jpg'));
        Database.upsert(recordList);
        return recordList;
    }
    @IsTest
    private static void testCampaignObject(){
        List<Campaign> recordList = createCampaigns();
        String objectName = 'Campaign';
        String headlineField = 'Name';
        String dateStartField = 'startDate';
        String dateEndField = 'endDate';
        String textField = 'Description';
        String urlField = 'mediaUrl__c';
        String captionField = '';
        List<TimelineEvent> timelineEventsList = TimelineController.getTimelineEvents(objectName, dateStartField, dateEndField, textField, captionField, headlineField, urlField);
        System.assertEquals(recordList.size(), timelineEventsList.size());    
    }
    private static List<Event> createEvents(){
        List<Event> recordList = new List<Event>();
        recordList.add(new Event(Subject='abd', startDateTime=Date.today(), Description='abc description', DurationInMinutes=60));
        Database.upsert(recordList);
        return recordList;
    }
    @IsTest
    private static void testEventObject(){
        List<Event> recordList = createEvents();
        String objectName = 'Event';
        String headlineField = 'Subject';
        String dateStartField = 'startDateTime';
        String dateEndField = '';
        String textField = 'Description';
        String urlField = '';
        String captionField = '';
        List<TimelineEvent> timelineEventsList = TimelineController.getTimelineEvents(objectName, dateStartField, dateEndField, textField, captionField, headlineField, urlField);
        System.assertEquals(recordList.size(), timelineEventsList.size());    
    }
    private static List<Opportunity> createOpportunities(){
        List<Opportunity> recordList = new List<Opportunity>();
        recordList.add(new Opportunity(Name='abc', Description='abc description', 
            StageName='Qualification', CloseDate=Date.today().addMonths(1)));
        Database.upsert(recordList);
        return recordList;
    }
    @IsTest
    private static void testOpportunityObject(){
        List<Opportunity> recordList = createOpportunities();
        String objectName = 'Opportunity';
        String headlineField = 'Name';
        String dateStartField = 'createdDate';
        String dateEndField = 'closeDate';
        String textField = 'Description';
        String urlField = '';
        String captionField = '';
        List<TimelineEvent> timelineEventsList = TimelineController.getTimelineEvents(objectName, dateStartField, dateEndField, textField, captionField, headlineField, urlField);
        System.assertEquals(recordList.size(), timelineEventsList.size());    
    }
}