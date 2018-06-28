public class transferExams
{
    public String strCodeIdentifier{get;set;}
    Exam_Sites__c objExamSites;
    public List<examSitesWrap> lstExamSitesWrap{get;set;}
    public transferExams(Apexpages.StandardController std)
    {
        objExamSites = (Exam_Sites__c)std.getRecord();
    }
    
    public pageReference examSiteDetails()
    {
        lstExamSitesWrap = new List<examSitesWrap>();
        system.debug('strCodeIdentifier == '+strCodeIdentifier);
        system.debug('objExamSites == '+objExamSites);
        for(Exam_Sites__c objES : [select id,name,Exam_Site_Code_idetifier__c from Exam_Sites__c where Exam__r.Exam_Group__r.Active__c =: true and Exam_Site_Code_idetifier__c =: strCodeIdentifier and id !=: objExamSites.Id])
        {
            
            lstExamSitesWrap.add(new examSitesWrap(objES));
        }
        if(lstExamSitesWrap.size() <= 0)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No matching records returned');
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;
    
    }
    
    public pageReference transferExams()
    {
        Integer iCount = 0;
        String strTransferTo;
        for(examSitesWrap objWrap : lstExamSitesWrap)
        {
            if(objWrap.selected)
                iCount++;
        }
        if(iCount >= 2)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select only one.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        else
        {
            for(examSitesWrap objWrap : lstExamSitesWrap)
            {
                if(objWrap.selected)
                {
                    strTransferTo = objWrap.objES.Id;
                }
            }
        }
        
        if(strTransferTo == null) return null;
        List<Exam_Attempt__c> lstExamAttempts = new List<Exam_Attempt__c>();
        for(Exam_Attempt__c objEA : [select id,Exam_Site__c from Exam_Attempt__c where Exam_Site__c =: objExamSites.Id])
        {
            objEA.Exam_Site__c = strTransferTo;
            lstExamAttempts.add(objEA);
        }
        try
        {
            if(!lstExamAttempts.isEmpty()) update lstExamAttempts;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Succesfully transferred exams.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        catch(exception ex)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error occured while transferring');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        return null;
    
    }
    
    
    public class examSitesWrap
    {
        public Exam_Sites__c objES{get;set;}
        public boolean selected{get;set;}
        
        public examSitesWrap(Exam_Sites__c objExamSite)
        {
            objES = objExamSite;
            selected = false;
        }
    
    }
    
}