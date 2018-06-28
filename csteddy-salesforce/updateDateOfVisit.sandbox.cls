public with sharing class updateDateOfVisit
/*
    This class contains a single method the purpose of which is to update the 
    schedule. It is scheduled to run each week (in fact it must be run every week
    because it doesn't do catch up. All properties marked as inactive are ignored, as
    are properties that are in the database but have yet to be scheduled (i.e. the Week of Next
    Visit has not been specified). The start of the GreenworX working week is Monday, so Week of Next Visit 
    and Week of Previous visit will always be a Monday. The particular day/s in the week that the visit takes
    place is determined by another field - Days (which is a multiple picklist) and the general workload across
    the week.
*/    
{
    public void weeklyUpdateOfDate()
    {
        Date currentWeek = Date.today().toStartofWeek().addDays(1);
        Date nextWeek = currentWeek.addDays(7);
        Integer daysTo;
        Property__c[] props;
        props = [SELECT Id,Week_of_Previous_Visit__c,Week_of_Next_Visit__c,Frequency__c FROM Property__c Where Week_of_Next_Visit__c <> Null AND Inactive__c <> True ];
        For (Property__c p:props) {
                 if(p.Week_of_Next_Visit__c <= currentWeek)
                     {
                         p.Week_of_Previous_Visit__c = p.Week_of_Next_Visit__c;
                         daysTo = integer.valueof(p.Frequency__c) * 7;
                         if (daysTo == 0)
                           p.Week_of_Next_Visit__c = Null;
                         else
                           p.Week_of_Next_Visit__c = p.Week_of_Next_Visit__c.addDays(daysTo);
                     }
        }
        update props;
      
    }
}
