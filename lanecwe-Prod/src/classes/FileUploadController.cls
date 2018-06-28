/********************************************************************************
Name:  FileUploadController
Copyright 2012 @ PGi 
======================================================
======================================================
Purpose:
-------
This is the controller for create a case from Public Site with an Attachment related to the Case Object
======================================================
======================================================
History 
-------
VERSION  AUTHOR                DATE        DETAIL              
  1.0  - CG DEV TEAM        5/29/2012   INITIAL DEVELOPMENT  
**********************************************************************************/

public class FileUploadController 
{ 

    public Case c { get; set; }
    public String fileName {get; set;}
    public Integer fileSize {get; set;}
    public Blob fileBody {get; set;} 
     public String Email{ get; set; }
    public String Subject { get; set; }
    public String Description { get; set; }
    String CaseOrigin='VF Ticket'; 
 // constructor
public FileUploadController () {  

c = new Case();  

}  
  


  
    public FileUploadController(ApexPages.StandardController controller){}

  /*******************************************************************
    Purpose     : Insert Case Details entered by User into Case Object in 'SFDC Support' record type .
    Parameters  : None
    Returns     : None
    ********************************************************************/
  public Database.SaveResult insertCase()
    {      
       
         
         RecordType RT=new RecordType();       
         RT = [Select id from RecordType where sObjecttype ='Case' and name='SFDC Support' limit 1];     // Get the Record Type ID to insert the record.
     
  // Old Code AD-06-21  AssignmentRule AR = new AssignmentRule();
  // Old Code AD-06-21  AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
     
   // Andy Modified code for Email notifications on case assignment rules firing
     
      List<Contact> ContactList= null;        
      ContactList=[SELECT id,Name,Email FROM Contact CC WHERE CC.Email=:Email];
      Integer size = ContactList.size();
     
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.useDefaultRule = true;
                dmlOpts.EmailHeader.triggerUserEmail = true;
                c.setOptions(dmlOpts);
                
 // Old Code AD-06-21       Database.DMLOptions dmlOpts = new Database.DMLOptions();
 // Old Code AD-06-21        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
    
       if (size==1)
        {
        For(Contact Cont:ContactList)
          {   
        
                  c.Contactid=Cont.id;             
                  c.Subject=Subject ;
                   c.Description=Description ; 
                   c.SuppliedEmail=Email;
                   c.Origin=CaseOrigin;
                   c.RecordTypeId=RT.id;          
                   c.setOptions(dmlOpts);   
                
 
                 
    
              }

}
else
{
         c.Subject=Subject ;
          c.Description=Description ; 
          c.SuppliedEmail=Email;
          c.Origin=CaseOrigin;
          c.RecordTypeId=RT.id;  
          c.setOptions(dmlOpts);
         
  }    
       return Database.insert(c);  
         
      
        
    }
    
     /*******************************************************************
    Purpose     : Insert Attachment with the Case created by the user.
    Parameters  : Id
    Returns     : None
    ********************************************************************/ 
    public Database.SaveResult insertAttachment(Id parentId)
    {
        Database.SaveResult result;
                
        Attachment attachment = new Attachment();
        attachment.Body = this.fileBody;
        attachment.Name = this.fileName;
        attachment.ParentId = parentId;
        
        result = Database.insert(attachment);

        fileBody = Blob.valueOf('  ');
        return result;
       
    }
    
    
 
  /*******************************************************************
    Purpose     : Method which gets called when user clicks on Submit Button. 
    Parameters  : None
    Returns     : None
    ********************************************************************/
    
 public PageReference Upload() {
 
 // Validation Check before entering data into the SFDC System
 
         if (Email== '')
         {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Email'));
           return null;
         }
       
          if ( Subject == '')
         {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Subject'));
           return null;
         }  
         if (Description== '')
         {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the Description'));
            return null;
         } 
           
         
     // Try Block    
         try
        {  // If user does not select any file to be attached with the case then only  method insertCase() gets called.
        
        
        if (fileName== null || fileName=='')
        {
        Database.SaveResult result = insertCase();
            
            if (result == null || !result.isSuccess())
            {
                return null;
            }
        
        
        }
        else{
        // If user  selects a file to be attached with the case then the method insertCase() and insertAttachment()gets called.
        
            Database.SaveResult result = insertCase();
            
            if (result == null || !result.isSuccess())
            {
                return null;
            }
    
                
            result = insertAttachment(result.getId());

            if (result == null || !result.isSuccess())
            {
                return null;
            }
            }
  // If the insert Case is successful it redirects          
           return page.Congratulations;
        }
        
  // Catch Block      
        catch (Exception e)
        {
                ApexPages.AddMessages(e);
                
        }

       return null;
    }

    
  /*******************************************************************
    Purpose     : Method which gets called when user clicks on Reset Button
    Parameters  : None
    Returns     : None
    ********************************************************************/

     public PageReference Reset()
     {
         PageReference newpage = new PageReference(System.currentPageReference().getURL());
            newpage.setRedirect(true);
           return newpage;
           
     }

   /*******************************************************************
    Purpose     : Test Methods
    ********************************************************************/  
   
  // Test Method for Upload Method 
   testMethod static void test_Upload(){
   
      test.starttest();
      FileUploadController  fileUpload=new FileUploadController ();
      fileUpload.Email='abc@cc.com';
     fileUpload.Subject ='test';
     fileUpload.C.Type ='Training';
     fileUpload.C.Users_Impacted__c='Team(3-10)';
     fileUpload.C.Priority='Low';
     fileUpload.C.Region__c='NA';
     fileUpload.Description='test';
     fileUpload.fileName='';
     
     FileUploadController  fileUpload1=new FileUploadController ();
     fileUpload.Email='abc@cc.com';
     fileUpload.Subject ='test';
     fileUpload.C.Type ='Training';
     fileUpload.C.Users_Impacted__c='Team(3-10)';
     fileUpload.C.Priority='Low';
     fileUpload.C.Region__c='NA';
     fileUpload.Description='test';
     fileUpload1.fileName='testName';
     
      FileUploadController  fileUpload2=new FileUploadController ();
      fileUpload2.Email='';
      
      FileUploadController  fileUpload3=new FileUploadController ();
      fileUpload3.Subject='';
      
      FileUploadController  fileUpload4=new FileUploadController ();
      fileUpload4.Description='';
      

      
     system.assert(fileUpload.Upload()!=null);
     system.assert(fileUpload1.Upload()==null);
     system.assert(fileUpload2.Upload()==null);
     system.assert(fileUpload3.Upload()==null);
     system.assert(fileUpload4.Upload()==null);
 
      
     test.stoptest();
 
}

// Test Method for Reset Method

    testMethod  static void test_Reset()
    {
     test.starttest();
      PageReference myPage = new Pagereference('/apex/SubmitIssuesforSFDC_support_team');
      Test.setCurrentPage(myPage);
      FileUploadController  fileUpload=new FileUploadController ();
      system.assert(fileUpload.Reset()!=null);
      test.stoptest();
   }
}