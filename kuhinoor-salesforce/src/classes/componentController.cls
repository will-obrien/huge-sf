public class componentController{
    public String sid{get;set;}
    public list<student__c> getstudents(){
    
        list<Student__c> std=[select first_name__c,phone_no__c,email_id__c from Student__c where id=:sid];
        return std;
    }
   
        
   
}