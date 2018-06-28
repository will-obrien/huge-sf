public class CourseDeliveryTriggerHandler {

    //TODO: Review the following static method.
    //It encapsulates the logic that was formerly found the trigger.
    //It is static, so it can be invoked without instantiating the class.
    public static void preventInvalidCourseDeliveries() {
        // Fetch the current holidays.
        // For simplicity's sake, we've assumed no recurring holidays
        Set<Date> allHolidays = new Set<Date>();
        for (List<Holiday> holidays : [SELECT ActivityDate FROM Holiday]) {
            for (Holiday h : holidays) {
                allHolidays.add(h.ActivityDate);
            }
        }
    
        //TODO: Review the following for-loop.
        //Notice we can reference trigger.new in the class, 
        //but we must cast it to the correct type.
        for (CourseDelivery__c courseDelivery : (List<CourseDelivery__c>)Trigger.new) {
            if (courseDelivery.StartDate__c != NULL) {
            //Prevent the invoking DML action if the Start Date is in the allHolidays set.
                if ( allHolidays.contains(courseDelivery.StartDate__c) ) {
                    courseDelivery.addError('Course Delivery cannot be scheduled because it starts on a holiday.');          
                }
            }
        }
    }
}