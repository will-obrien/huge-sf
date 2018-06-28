@isTest public class CaseToPdfTest {

    @isTest
    static void testPageReference() {
        CaseToPdf ctp = new CaseToPdf();
        PageReference pageRef = ctp.save();
        
        System.assertEquals(pageRef ,null);
    }
    
    @isTest
    static void testInputDate() {
        CaseToPdf ctp = new CaseToPdf();
        ctp.InputDate = 'test';
        System.assertEquals(ctp.InputDate,'test');
    }
    
    @isTest
    static void testErrorMsg() {
        CaseToPdf ctp = new CaseToPdf();
        ctp.errorMsg = 'test';
        System.assertEquals(ctp.errorMsg ,'test');
    }

    @isTest
    static void testGetCaseID() {
        CaseToPdf ctp = new CaseToPdf();

        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('caseID','50024000002GubW');
    
        System.assertEquals(ctp.getCaseID(), '50024000002GubW');
    }
    
    @isTest
    static void testGenerateBothNULL() {
        CaseToPdf ctp = new CaseToPdf();
    
        ctp.inputDate = NULL;
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('caseID',NULL);
        
        System.assertEquals(ctp.generate(),NULL);
    }
    
    @isTest
    static void testGenerateCaseNULL() {
        CaseToPdf ctp = new CaseToPdf();
    
        ctp.inputDate = '20/12/2013';
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('caseID',NULL);
        
        System.assertEquals(ctp.generate(),NULL);
    }
    
    @isTest
    static void testGenerateCaseBothOK() {
        CaseToPdf ctp = new CaseToPdf();
    
        ctp.inputDate = '20/12/2013';
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('caseID','50024000002GubW');
        
        PageReference pr = new PageReference('/apex/generated?activityDate='+ ctp.inputDate + '&caseID='+ ctp.getCaseID());
        
        System.assertEquals(ctp.generate().getParameters(),pr.getParameters());
    }
    
    @isTest
    static void testGenerateActivityDateNULL() {
        CaseToPdf ctp = new CaseToPdf();
    
        ctp.inputDate = NULL;
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('caseID','50024000002GubW');
        
        System.assertEquals(ctp.generate(),NULL);
    }
    
    @isTest
    static void testGenerateCaseBadDateFormat() {
        CaseToPdf ctp = new CaseToPdf();
        ctp.inputDate = 'bad date';
        
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('caseID','50024000002GubW');
        
        System.assertEquals(ctp.generate(),NULL);
        System.assertEquals(ctp.errorMsg,'Please provide proper data...'); 
    }
}