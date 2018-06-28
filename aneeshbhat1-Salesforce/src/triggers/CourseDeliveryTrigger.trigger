trigger CourseDeliveryTrigger on CourseDelivery__c (before insert,before update) {
    
   CourseDeliveryTriggerHandler.preventInvalidCourseDeliveries();
}