@isTest
public class updateByGarpId_Test {

    Static Shipping_Boxes__c sb;
    Static Shipping_Boxes__c sb1;
    Static Shipping_Boxes__c sb2;
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
    static Proctor_Registration__c proctor1;
    static venue__c venue;
    static room__c room;
    
    Static void testData()
    {

        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test', GARP_ID__c = '101010');
        insert account;
         
        contact = new Contact(lastname = 'Test',GARP_Member_ID__c = '101010',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site; 
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true; 
        objExamGrp.Name ='15-Nov';
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
        
        sb1 = new Shipping_Boxes__c(Proctor_Boxes__c = True,Weight__c='4',Ship_to_last_name__c='Zhao',Shiptofirst_name__c='Jing',SiteName__c = 'Australia, Melbourne',ShipToAddress1__c = 'La Trobe University',ShipToAddress2__c ='La Trobe Business School',Pre_Test_Box_UPS_Stage__c='New Order',Pre_Test_Box_Country_Code_for_UPS__c = 'US');
        insert sb1;
        sb2 = new Shipping_Boxes__c(Proctor_Boxes__c = True,Weight__c='4',Ship_to_last_name__c='Zhao',Shiptofirst_name__c='Jing',SiteName__c = 'Australia, Melbourne',ShipToAddress1__c = 'La Trobe University',ShipToAddress2__c ='La Trobe Business School',Pre_Test_Box_UPS_Stage__c='New Order');
        insert sb2;
        
        proctor = new Proctor_Registration__c(Name = 'pr', Proctor_First_Name__c = 'pfn', Proctor_Last_Name__c = 'pln', Proctor_Email__c = 'test@test.com', Type__c = 'Supervisor', Status__c = 'Approved',Proctor_Type__c = 'GARP', contact__c = contact.id,test_site__c = site.id,Exam_Group__c  = objExamGrp.id);
        insert proctor;
    }
    
    
    static testMethod void unit_test()
    {
        testData();
        test.startTest();
        sb = new Shipping_Boxes__c(GARP_ID__c = '101010', Proctor_Boxes__c = True,Weight__c='4',Ship_to_last_name__c='Zhao',Shiptofirst_name__c='Jing',SiteName__c = 'Australia, Melbourne',ShipToAddress1__c = 'La Trobe University',ShipToAddress2__c ='La Trobe Business School',Pre_Test_Box_UPS_Stage__c='New Order',Pre_Test_Box_Country_Code_for_UPS__c = 'AU');
        insert sb;
        test.stopTest();
        
        
    }

    
}