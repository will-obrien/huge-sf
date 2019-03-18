public without sharing class SalesforceDocuments {
    
     public SalesforceDocuments(ApexPages.StandardController stdController) {
        this.sd = (Salesforce_Documents__c)stdController.getRecord();
    }

    public Salesforce_Documents__c sd{get;set{
      sd =[select id from Salesforce_Documents__c limit 1];  
        }
                                     }
    public String name {get;set;}
    public string fname{get;set;}
    public blob attachDoc {get;set;}
    public string description {get;set;}
    public boolean errormessage{get;set;}    
    
    public Attachment attachment {get;set;
  }
    

    /*public pagereference Items(){
        String str  ='%'+name+'%';
        items= [SELECT Id,Name,description,contentType FROM Attachment where name like :str];
        /*if(items.isEmpty()){
            system.debug('items are '+items);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'NO Record Found'));
            
        return null;
        }
      
        
        return null;
    }   
    */
    public pagereference UploadDoc(){
        String t='a082800000LPh6N';
       attachment = new Attachment();
     attachment.OwnerId = UserInfo.getUserId();
    attachment.ParentId = Label.Salesforce_Documents;
   // attachment.IsPrivate = true;
     attachment.ContentType='application/msword';
        attachment.Name= fname;
        attachment.Body=attachDoc;
        attachment.Description=description;
       
        try{
            insert attachment;
           }catch(Exception e){
               system.debug('exc__'+e);
               errormessage=true;
        return null;
    // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please choose a file'));              
           } 
        
        return ApexPages.currentPage().setRedirect(true);
    } 
  
    
}