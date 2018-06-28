public class Milestone1_Calendar_Item 
{
    public String aid {get;set;}
    public String name {get;set;}
    public Date theDate {get;set;}
    public String theType {get;set;}
    
    public static final String PROJECT_TYPE = 'PROJECT_TYPE';
    public static final String MILESTONE_TYPE = 'MILESTONE_TYPE';
    public static final String TASK_TYPE = 'TASK_TYPE';
    
    public Milestone1_Calendar_Item(String theId, String theName, Date inputDate, String inType)
    {
        aid = theId;
        name = theName;
        theDate = inputDate;
        theType = inType;
    }
    
    static testMethod void testCalendarItem()
    {
        Milestone1_Calendar_Item calItem = new Milestone1_Calendar_Item('ABCDEFG','UNIT TEST',Date.today(),Milestone1_Calendar_Item.PROJECT_TYPE);
        system.assertEquals('UNIT TEST',calItem.name);
        system.assertEquals('ABCDEFG', calItem.aid);
        system.assertEquals(Date.today(),calItem.theDate);
    }
}