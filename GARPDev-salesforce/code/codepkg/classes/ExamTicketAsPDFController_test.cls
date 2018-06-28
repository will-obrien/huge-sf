@isTest
public class ExamTicketAsPDFController_test {
    
    static Account acc ;
    static Opportunity opp; 
    static TempAccount tempaccount;
    static Contact contact;
    static Contact contact1;
    static Exam_Attempt__c attempt;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contract contract;
    static Lead lead;
    static Profile profile;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Candidate_Requirement__c reqt;
    static Chapter_Meeting__c chapMeeting ;
    static Chapter_Meeting_Registration__c meetingReg;
    static User user;
    static User user1;
    static content__c content;
    static Board_Election__c election;
    static EmailTemplate template;
    static Proctor_Registration__c proctor;
    static CPE_Activity_Type__c  type;
    static CPE_Activity__c activity;
    static Chapter_Member__c member;
    static Chapter__c chapter;
    static Product2 prod;
    static Product2 prod1;
    static Product2 prod2;
    static Product2 prod3;
    
    static void testData(){ 
        
        Id pricebookId = Test.getStandardPricebookId();
               
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
           
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        insert new UpdateIds__c(Name= 'ICBRR', Record_Id__c = 'a1e40000006sqih');   
        //a1e40000006sqih  a0Cf0000004O778
        Acc = new Account(Name = 'test');
        insert acc;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('FRM Program').getRecordTypeId();
        contract = new Contract(Opportunity__c = opp.id,AccountId = acc.id,recordTypeId = rtId);
        insert contract;
        
        Contract  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12     ,StartDate = opp.CloseDate        );
        insert contract;

        contract.Status = 'Activated';
        update contract;
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true;
        Date dt1 = system.today();
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
        
        contact = new Contact(KPI_ERP_Certified__c = true,KPI_FRM_Certified__c = true,GARP_Directory_Opt_In__c = true,lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        Venue__c venue = new Venue__c(Name='My Venue', Site__c=site.Id, Address1__c='MyHome', City__c = 'Kinnelon', 
                                      State__c ='NJ', Country__c='USA', Zipcode__c='07405', Venue_Code__c = 'XXX');
        insert venue;
        
        Room__c room = new Room__c(Name='MyRoom', Capacity__c=60, Venue__c=venue.Id);
        insert room;
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false, Room__c=room.Id,
                                     Seat_No__c='21');
        insert attempt;
        
                      
     }
         
    static testMethod void unitTest_1(){
        testData();
                     
        ApexPages.currentPage().getParameters().put('id', attempt.id);
        ExamTicketAsPDFController ticket = new ExamTicketAsPDFController();
        ticket.fetchData();
        ticket.getMorningExamTime();
        ticket.getAfternoonExamTime();
        ticket.getAddress1();
        ticket.getAddress2();
        ticket.getAddress3();
        ticket.getExamTime();
        ticket.getExamDateString();
        ticket.getDoorClosingTimes();
             
    }

}