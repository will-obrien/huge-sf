public class Demo {
  public list<account> a { get; set; }
  public list<string> CPE_Name { get; set; }
  public list<CPE_Provider_Activity__c> CPE_Acts { get; set; }
  

  public Demo () {
    CPE_Name = new list<string>() ;
    CPE_Acts = new list<CPE_Provider_Activity__c>() ;
    a = [
     SELECT Id, Name, RecordTypeId, (
       SELECT name, CPE_Activity_Type__c, Start_Date__c, End_Date__c, web_Description__c FROM CPE_Provider_Activities__r) 
     FROM Account 
     WHERE RecordTypeId= '01240000000UVewAAG'];
     list< string > CPE_Names = new list<string> () ;
     
     for ( account aItem : a ) {
       for ( CPE_Provider_Activity__c CPE : aItem.CPE_Provider_Activities__r ) {
         CPE_Name.add(CPE.name) ;
         CPE_Acts.add(CPE) ;
       }
     }
  
  }
}