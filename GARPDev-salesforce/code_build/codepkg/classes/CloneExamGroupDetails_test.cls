@isTest
public class CloneExamGroupDetails_test {
    
    static Account account ;
    static Opportunity opportunity; 
    static Exam_Attempt__c attempt;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Proctor_Registration__c proctor;
    static venue__c venue;
    static room__c room;
        
    static void testData(){ 
           
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true; 
        Date dt1 = system.today();
        objExamGrp.Exam_Date__c = system.today() + 13;
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        insert objExamGrp;
        
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite; 
        
        attempt = new Exam_Attempt__c(Opportunity__c = opportunity.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
        
        proctor = new Proctor_Registration__c(contact__c = contact.id,test_site__c = site.id,Exam_Group__c  = objExamGrp.id);
        insert proctor;
        
        venue = new venue__c(site__c = site.id,active__c = true);
        insert venue;
        
        room = new room__c (Venue__c  = venue.id,Capacity__c = 100);
        insert room;
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        ApexPages.currentPage().getParameters().put('oId',objExamGrp.id);
        cloneExamgroupDetails clonedetails = new cloneExamgroupDetails(new ApexPages.StandardController(objExamGrp));
        clonedetails.tempExamRecord = objExamGrp;
        cloneDetails.doCloneExamGroupHierarchy();
        test.stopTest();
    }
}