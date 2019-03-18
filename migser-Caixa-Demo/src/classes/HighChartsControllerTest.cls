@isTest
public class HighChartsControllerTest {

    private static Contact createContact(){
        Contact con = new Contact(lastName='contact', firstName='name', 
            interest1__c=5, interest2__c=3, interest3__c=4, interest4__c=2, interest5__c=5, interest6__c=4);
        Database.upsert(con);
        return con;    
    }

    @IsTest
    private static void testGetRadarValues(){
        Contact contact = createContact();
        List<String> fieldArray = new List<String>{'interest1__c', 'interest2__c', 'interest3__c', 'interest4__c', 'interest5__c', 'interest6__c'};
        List<Decimal> interests = HighChartsController.getRadarFieldValues(contact.Id, 'Contact', 'id', fieldArray);
         System.assertEquals(interests.size(), fieldArray.size());
    }
    
    
    @IsTest
    private static void testGetActivityGaugeValues(){
        Contact contact = createContact();
        List<String> fieldArray = new List<String>{'pointsEarned1__c'};
        List<Decimal> points = HighChartsController.getActivityGaugeFieldValues(contact.Id, 'Contact', 'id', fieldArray);
        System.assertEquals(points.size(), fieldArray.size());
    }
    
    private static List<DigitalActivities__c> createActivities(Id contactId){
        List<DigitalActivities__c> activities = new List<DigitalActivities__c>();
        List<String> sources = new List<String>{'Website', 'Twitter', 'Line', 'Rakuten', 'Facebook'};
        List<String> types = new List<String>{'viewed product', 'case-related', 'bought product'};
        for(String source : sources){
            for(String type : types){
                activities.add(new DigitalActivities__c(contact__c=contactId, source__c=source, type__c=type));
            }
        }
        insert activities;
        return activities;
    }

    @IsTest
    private static void testGetAreaChartGroupValuesEmpty(){
        Contact contact = createContact();
        String objectName = 'DigitalActivities__c';
        String recordIdFieldName = 'contact__c';
        String group1Field = 'source__c';
        String group2Field = 'type__c';
        List<String> group1 =  HighChartsController.getAreaChartGroupValues(contact.Id, objectName, recordIdFieldName, group1Field);
        List<String> group2 =  HighChartsController.getAreaChartGroupValues(contact.Id, objectName, recordIdFieldName, group2Field);
        List<ChartDataWrapper> values = HighChartsController.getAreaChartYFieldValues(contact.Id, objectName, recordIdFieldName, 
            'count(id)', group1Field, group2Field, group1, group2);
    }
    @IsTest
    private static void testGetAreaChartGroupValuesNoGroupedInput(){
        Contact contact = createContact();
        List<DigitalActivities__c> activities = createActivities(contact.id);
        String objectName = 'DigitalActivities__c';
        String recordIdFieldName = 'contact__c';
        String group1Field = 'source__c';
        String group2Field = 'type__c';
        List<String> group1 =  HighChartsController.getAreaChartGroupValues(contact.Id, objectName, recordIdFieldName, group1Field);
        List<String> group2 =  HighChartsController.getAreaChartGroupValues(contact.Id, objectName, recordIdFieldName, group2Field);
        List<ChartDataWrapper> values = HighChartsController.getAreaChartYFieldValues(contact.Id, objectName, recordIdFieldName, 
            'id', group1Field, group2Field, group1, group2);

    }
    @IsTest
    private static void testGetAreaChartSingleGroupValues(){
        Contact contact = createContact();
        List<DigitalActivities__c> activities = createActivities(contact.id);
        String objectName = 'DigitalActivities__c';
        String recordIdFieldName = 'contact__c';
        String group1Field = 'source__c';
        List<String> group1 =  HighChartsController.getAreaChartGroupValues(contact.Id, objectName, recordIdFieldName, group1Field);
        List<ChartDataWrapper> values = HighChartsController.getAreaChartYFieldValues(contact.Id, objectName, recordIdFieldName, 
            'count(id)', group1Field, '', group1, new List<String>());
    }

    @IsTest
    private static void testGetAreaChartMultipleGroupValues(){
        Contact contact = createContact();
        List<DigitalActivities__c> activities = createActivities(contact.id);
        String objectName = 'DigitalActivities__c';
        String recordIdFieldName = 'contact__c';
        String group1Field = 'source__c';
        String group2Field = 'type__c';
        List<String> group1 =  HighChartsController.getAreaChartGroupValues(contact.Id, objectName, recordIdFieldName, group1Field);
        List<String> group2 =  HighChartsController.getAreaChartGroupValues(contact.Id, objectName, recordIdFieldName, group2Field);
        List<ChartDataWrapper> values = HighChartsController.getAreaChartYFieldValues(contact.Id, objectName, recordIdFieldName, 
            'count(id)', group1Field, group2Field, group1, group2);
    }    
    
}