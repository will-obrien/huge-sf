public class joinQueryHotelManageController{
    public list<Booking__c> details{get;set;}
        public joinQueryHotelManageController(){
            details = [select customer__c,room__c,Status__c,customer__r.Email__c,customer__r.First_Name__c,customer__r.Last_Name__c,room__r.price__c from booking__c];
        }

}