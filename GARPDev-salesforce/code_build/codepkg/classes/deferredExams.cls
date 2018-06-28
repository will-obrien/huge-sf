public class deferredExams
{
    public Exam_Attempt__c objEA{get;set;}
    public List<Exam_Attempt__c> lstEA{get;set;}
    public List<deferredWrap> lstDeferredWrap{get;set;}
    
    public deferredExams(Apexpages.StandardController std)
    {
        objEA = new Exam_Attempt__c();
    }
    
    public pageReference examAttemptDetails()
    {
        lstDeferredWrap = new List<deferredWrap>();
        for(Exam_Attempt__c objEA : [select id,name,Member__c,Result__c,Exam_Site__r.Name,Exam_Site__r.Site__r.Name,Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where Exam_Site__r.Exam__r.Exam_Group__r.Active__c =: true and Member__c =: objEA.Member__c and Defered__c =: null])
        {
            lstDeferredWrap.add(new deferredWrap(objEA));
        }
        return null;
    
    }
    
    public pageReference updateDeffered()
    {
        Integer iCount = 0;
        String strPaymentId = '';
        for(deferredWrap objWrap : lstDeferredWrap)
        {
            if(objWrap.isDeferred)
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
            for(deferredWrap objWrap : lstDeferredWrap)
            {
                if(objWrap.isDeferred)
                {
                    strPaymentId = portalClass.checkExamAttempts(objWrap.ObjEA.Id,'ENC','4020',true);
                    //strPaymentId = portalClass.checkExamAttempts(objWrap.ObjEA.Id,'FRM1','4020',true);
                
                }
            }
        }
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Deferred process has been initiated, customer needs to make a payment.Please contact account team.');
            ApexPages.addMessage(myMsg);
        
        return null;
    
    }
    
    
    public class deferredWrap
    {
        public Exam_Attempt__c objEA{get;set;}
        public boolean isDeferred{get;set;}
        
        public deferredWrap(Exam_Attempt__c objExamAttempt)
        {
            objEA = objExamAttempt;
            isDeferred = false;
        }
    
    }
    
}