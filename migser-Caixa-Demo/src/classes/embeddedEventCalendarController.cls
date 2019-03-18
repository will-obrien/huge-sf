public class embeddedEventCalendarController {
	@AuraEnabled
    public Static List<event> getEvents(String recId){
        return [select Id, ActivityDate, StartDateTime, EndDateTime from Event where WhatId =: recId];
    }
    
    @AuraEnabled
    public static List<Event> dayEvent(String selDate, String recId){
        List<String> newDateString = selDate.split('/');
        Integer month = Integer.valueOf(newDateString[0]);
        Integer day = Integer.valueOf(newDateString[1]);
        Integer year = Integer.valueOf(newDateString[2]);
        
        date myDate = date.newInstance(year, month, day);
        
        return [select Id, subject, Who.Name, Description, ActivityDate, StartDateTime, EndDateTime from Event where (ActivityDate =: myDate or (StartDateTime <=:myDate and EndDateTime>=:myDate)) and WhatId =: recId];
    }
}