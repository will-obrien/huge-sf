public with sharing class CommunityTestController {
   
      public  Id recordId ;
      public String recordName {get; set; }
      public Custom_Object11__c record {get; set;}
 
      public CommunityTestController() {
          record = [select Id, Name from Custom_Object11__c limit 1];
          recordId = record.Id ;
          recordName = record.Name ;
      }
       
      
      public PageReference refresh() {
          record = [select Id, Name from Custom_Object11__c limit 1];
          
          return null;
      }
   
  }