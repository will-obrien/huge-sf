/*
Developer      : Keerthi Chandra,Rashmitha
Date           : 5-20-2016
Status         : Developed
Description    : Create new post with attachments.
*/
public class Salesforcedocs 
{    
    public Salesforcedocs(ApexPages.StandardController controller) {

    }
    
    // To hold the salesforce documents record.
    public Salesforce_Documents__c sDoc{
    get {
      if (sDoc == null)
        sDoc = new Salesforce_Documents__c();
      return sDoc;
    }
    set;
  }
   
    ///<OBJECTIVE>
    /// page redirect to home page and to save the post.
    ///</OBJECTIVE>
    public pagereference Save()
    {
        try{
        INSERT sDoc;
        }
        catch(Exception ex){}
        PageReference pageRef = new PageReference(system.label.POCUrl);
        pageRef.setRedirect(false);
        return pageRef; 
    }
    
    ///<OBJECTIVE>
    /// page redirect to home page.
    ///</OBJECTIVE>
    
    public pagereference Cancel()
    {
        PageReference pageRef = new PageReference(system.label.POCUrl);
        pageRef.setRedirect(false);
        return pageRef;  
    }
}