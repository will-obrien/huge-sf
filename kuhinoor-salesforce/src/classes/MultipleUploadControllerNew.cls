public class MultipleUploadControllerNew  
{     
    //Picklist of tnteger values to hold file count  
    public List<SelectOption> filesCountList {get; set;}  
    //Selected count  
    public String FileCount {get; set;}  
      
    public List<Attachment> allFileList {get; set;}  
      
    public MultipleUploadControllerNew(ApexPages.StandardController controller)  
    {  
        //Initialize    
        filesCountList = new List<SelectOption>() ;  
        FileCount = '' ;  
        allFileList = new List<Attachment>() ;  
          
        //Adding values count list - you can change this according to your need  
        for(Integer i = 1 ; i < 11 ; i++)  
            filesCountList.add(new SelectOption(''+i , ''+i)) ;  
    }  
      
    public Pagereference SaveAttachments()  
    {  
        String accId = System.currentPagereference().getParameters().get('id');  
        if(accId == null || accId == '')  
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'No record is associated. Please pass record Id in parameter.'));  
        if(FileCount == null || FileCount == '')  
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select how many files you want to upload.'));  
  
        List<Attachment> listToInsert = new List<Attachment>() ;  
          
        //Attachment a = new Attachment(parentId = accid, name=myfile.name, body = myfile.body);  
        for(Attachment a: allFileList)  
        {  
            if(a.name != '' && a.name != '' && a.body != null)  
                listToInsert.add(new Attachment(parentId = accId, name = a.name, body = a.body)) ;  
        }  
          
        //Inserting attachments  
        if(listToInsert.size() > 0)  
        {  
            insert listToInsert ;  
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, listToInsert.size() + ' file(s) are uploaded successfully'));  
            FileCount = '' ;  
        }  
        else  
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select at-least one file'));  
              
        return null;  
    }  
      
    public PageReference ChangeCount()  
    {  
        allFileList.clear() ;  
        //Adding multiple attachments instance  
        for(Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)  
            allFileList.add(new Attachment()) ;  
        return null ;  
    }  
}