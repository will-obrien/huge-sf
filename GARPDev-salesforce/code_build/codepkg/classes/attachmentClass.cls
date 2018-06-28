public class attachmentClass {

    public PageReference save() {
       
       try
       {
           objDoc.ParentID = getParentId();
           insert objDoc;
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Successfully uploaded file'));
       }
       catch(exception ex)
       {
           objDoc.ParentID  = null;
           objDoc.Name = null;
           objDoc.body = null;
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));

       }
       return null;
    }


    public Attachment objDoc{get;set;}
    
    public attachmentClass()
    {
        objDoc = new Attachment();
        
    
    }
    
    public Id getParentId()
    {
         Id currentUSer = userinfo.getuserid();
        List<Exam_Attempt__c> lstExamAttempt = null;
        try
        {
            User objUser = [select id,email,username,Contactid from user where id =: currentUSer];
            if(objUser.Contactid == null) return null;
            lstExamAttempt = [select id,Candidate_Commitment__c from Exam_Attempt__c where Member__c =: objUser.Contactid limit 1];
            if(lstExamAttempt == null) return null;
            Candidate_Requirement__c objCR = [select id,name from Candidate_Requirement__c where Candidate_Commitment__c =: lstExamAttempt[0].Candidate_Commitment__c and Name =: 'Job Requirement' limit 1];
            return objCR.Id;
            
        }
        catch(exception ex)
        {
            return null;
        }
        return null;
    
    
    }
}