@isTest
public class PerformanceAnalysisPDFControllerTest {

    public static testMethod void testController() {
        
        Exam_Group__c examGroup = new Exam_Group__c();
        examGroup.Active__c = true;
        Date dt1 = System.today();
        examGroup.Registration_Start_Date__c = dt1.addDays(4);
        examGroup.Last_Date_For_Early_Registration__c = system.today() + 1;
        examGroup.Last_Date_For_Standard_Registration__c = system.today() + 9;
        examGroup.Last_Date_For_Late_Registration__c = system.today() + 10;    
        insert examGroup;
        
        Exam__c exam = new Exam__c();
        exam.Exam_Group__c = examGroup.Id;
        exam.Exam_Date__c = System.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        Site__c site = new Site__c(name = 'test', Display_Address__c = 'test', active__c = true, Non_selectable__c = false);
        insert site; 
        
        Exam_Sites__c exmSite = new Exam_Sites__c(Site__c = site.id, Exam__c =  exam.Id);
        insert exmSite;
        
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        Contact contact = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        Exam_Attempt__c attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        attempt.Category_1__c = 'Test';
        attempt.Quartile_1__c = 1;
        insert attempt;
                   
        PageReference pageRef = Page.frmPerformanceAnalysisAsPDF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', attempt.Id);
        
        PerformanceAnalysisPDFController controller = new PerformanceAnalysisPDFController();
        controller.fetchData();
        
        Exam_Attempt__c ea = controller.ea;  
        System.assertEquals(ea.Id, attempt.Id);
        
        List<PerformanceAnalysisPDFController.ExamResult> results = controller.results;
        System.assertEquals(results.size(), 1);
        
        System.assertEquals(results.get(0).Category, 'Test');    
        
  }
}