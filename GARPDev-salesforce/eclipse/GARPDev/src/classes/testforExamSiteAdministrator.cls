@isTest
private class testforExamSiteAdministrator {
   
    static testMethod void testforExamSiteAdministrator()
    {
        Site__c s = testUtility.createSite();
        s.Active__c = true;
        insert s;
        
        Venue__c v = testUtility.createVenue(s);
        insert v;
        
        Room__c r = testUtility.createRoom(v);
        insert r;
        
        Exam__c e = testUtility.createExam();
        insert e;
        
        Exam_Sites__c es = testUtility.createExamSite(e,s);
        insert es;
        
        //Use the PageReference Apex class to instantiate a page
        PageReference pageRef = Page.deepclone;
        Test.setCurrentPage(pageRef);
        
        Exam__c exam = new Exam__c();
        ApexPages.StandardController p = new ApexPages.StandardController(exam);
        //Instantiate and construct the controller class. 
        ApexPages.currentPage().getParameters().put('oId',e.Id);  
        cloneExamDetails con = new cloneExamDetails(p);
        e.Exam_Date__c = System.today()+1;
        e.Israel_Exam_Date__c = System.today()+2;
        con.doCloneExam();        
    }
}