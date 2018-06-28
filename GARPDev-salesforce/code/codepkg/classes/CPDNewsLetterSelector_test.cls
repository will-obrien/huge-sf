@isTest
public class CPDNewsLetterSelector_test {
    
   
   public static void setup() {
   
       CPE_Activity_Type__c type = new CPE_Activity_Type__c();
       type.Name = 'Selected Readings';
       insert type;
   
       CPE_Activity__c activity = new CPE_Activity__c();
       activity.Description__c = 'xxx';
       activity.Outreach_Start_Date__c = Date.today().addDays(-1);
       activity.Outreach_End_Date__c = Date.today().addDays(1);
       activity.CPE_Activity_Type__c = type.Id;
       insert activity;
        
       activity = new CPE_Activity__c();
       activity.Description__c = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
       activity.Outreach_Start_Date__c = Date.today().addDays(-1);
       activity.Outreach_End_Date__c = Date.today().addDays(1);
       activity.CPE_Activity_Type__c = type.Id;
       insert activity;
       
       //select Id, Name, Title__c, Description__c, CPE_Activity_Type__c, CPE_Activity_Type__r.Name, Activity_Type_Description__c, Area_of_Study__c, Credit__c, Date_Description__c, 
       //Organization__c, Provider__c, Publication__c, URL__c, Outreach_Start_Date__c, Outreach_End_Date__c, Activity_Date__c from CPE_Activity__c 
       //where Outreach_Start_Date__c <= :startDate.Published_Date__c and Outreach_End_Date__c >= :startDate.Published_Date__c order by Activity_Date__c desc, Name
   }   
   
   static testmethod void testCPDNewsLetterSelector() {
       setup();
       CPDNewsLetterSelector s = new CPDNewsLetterSelector();
       s.startDate.Published_Date__c = Date.today();
       //s.endDate.Published_Date__c = Date.today().addDays(1);
       s.fetchRecords();
       s.publish();          
   } 
    
}