@isTest(SeeAllData=true)
public class CtestfetchRecordID
{
    public class applicationException extends Exception {}
    
    static testMethod void fetchRecordID_Test()
    {
        try
        {
            PageReference pageRef = Page.OpenPage;
            Test.setCurrentPageReference(pageRef);
                               
            Account aId = [Select id from Account LIMIT 1];    
            
            fetchRecordID fRecordID = new fetchRecordID();
            
            fRecordID.completeURL = null;
            List<Sobject> testId = new Sobject[]{};
            fRecordID.aniValue = '14084211010';
            fRecordID.getRedirectURL();
            
            fRecordID.completeURL = '/apex/openpage?A=123&ANI=9198989898&vf_account_id='+ aId.id;
            ApexPages.currentPage().getParameters().put('vf_account_id','null');
            fRecordID.aniValue = '+14084444444';
            fRecordID.getRedirectURL();
            fRecordID.aniValue = '14084444444';
            fRecordID.getRedirectURL();
            ApexPages.currentPage().getParameters().put('vf_account_id',aId.id);
            List<Sobject> testIds = new Sobject[]{};
            fRecordID.aniValue = '14084444444';
            fRecordID.getRedirectURL();
            fRecordID.Ids.add(aId);
            fRecordID.getRedirectURL();
            testIds=fRecordID.Ids;
            
            fetchRecordID testInstance = new fetchRecordID();
            testInstance.completeURL = '/apex/openpage?A=123&ANI=9198989898&vf_lead_phone=+919999999999';
            ApexPages.currentPage().getParameters().put('vf_lead_phone',' 919999999999');
            testInstance.getRedirectURL();
            
            fetchRecordID testInstance1 = new fetchRecordID();
            testInstance1.completeURL = '/apex/openpage?A=123&ANI=9198989898&vf_lead_company=infogain';
            ApexPages.currentPage().getParameters().put('vf_lead_company','infogain');
            testInstance1.getRedirectURL();
            
            fetchRecordID testInstance2 = new fetchRecordID();
            testInstance2.completeURL = '/apex/openpage?A=123&ANI=9198989898&vf_account_company=';
            testInstance2.aniValue = '';
            testInstance2.getRedirectURL();
        }
        catch(System.DmlException e)
        {
            system.assert(e.getMessage().contains('Error Occured'),e.getMessage());
        }
    }
}