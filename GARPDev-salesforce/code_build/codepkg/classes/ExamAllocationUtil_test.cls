@isTest
public class ExamAllocationUtil_test {
    
    static Account account ;
    static Opportunity opportunity; 
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Exam_Attempt__c attempt;
    static Contact contact;
    
    static Venue__c venue;
    static room__c room;
    static room__c room1;
    static ChargentBase__Gateway__c chrgGtway;
    
    static void testData(){
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
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
        
        attempt = new Exam_Attempt__c(Opportunity__c = opportunity.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false );
        insert attempt;
        
        venue = new venue__c(site__c = site.id);
        insert venue;
        
        room = new room__c (Venue__c  = venue.id,Capacity__c = 100);
        insert room;
        
        room1 = new room__c (Venue__c  = venue.id,Capacity__c = 100);
        insert room1;
    }
   
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        List<roomwrapper> wrapperList = new List<roomwrapper>();
        wrapperList.add(new roomwrapper(room));
        wrapperList.add(new roomwrapper(room1));
        map<string,list<Exam_Attempt__c> > mapSiteExamAttempts = new  map<string,list<Exam_Attempt__c> > ();
        mapSiteExamAttempts.put(string.valueOf(site.id),new Exam_Attempt__c[]{attempt} );
        ExamAllocationUtil.assignOneRoom( site.Id, 12,wrapperList, mapSiteExamAttempts,new Exam_Attempt__c[]{attempt}, 10);
        test.stopTest();
        
    }
    
    static testMethod void unitTest_2(){
        testData();
        test.startTest();
        List<roomwrapper> wrapperList = new List<roomwrapper>();
        wrapperList.add(new roomwrapper(room));
        wrapperList.add(new roomwrapper(room1));
        map<string,list<Exam_Attempt__c> > mapSiteExamAttempts = new  map<string,list<Exam_Attempt__c> > ();
        mapSiteExamAttempts.put(string.valueOf(attempt.member__c),new Exam_Attempt__c[]{attempt} );
        ExamAllocationUtil.assignMultipleRooms( string.valueOf(site.Id),12,new roomwrapper(room),mapSiteExamAttempts,new Exam_Attempt__c[]{attempt},10);
        test.stopTest();
        
    }
    
    static testMethod void unitTest_3(){
        testData();
        test.startTest();
        List<roomwrapper> wrapperList = new List<roomwrapper>();
        wrapperList.add(new roomwrapper(room));
        wrapperList.add(new roomwrapper(room1));
        map<string,list<Exam_Attempt__c> > mapSiteExamAttempts = new  map<string,list<Exam_Attempt__c> > ();
        mapSiteExamAttempts.put(string.valueOf(attempt.member__c),new Exam_Attempt__c[]{attempt} );
        map<id,set<id>> map_FRMSiteMembers = new map<id,set<id>>();
        set<id> newset = new set<id>();
        newset.add(attempt.member__c);
        map_FRMSiteMembers.put(site.id,newset);
        ExamAllocationUtil.assignOneRoomFRM12(site.Id, 12, wrapperList, map_FRMSiteMembers, mapSiteExamAttempts, new Exam_Attempt__c[]{attempt}, 10);
        test.stopTest();
        
    }
    
    static testMethod void unitTest_4(){
        testData();
        test.startTest();
        List<roomwrapper> wrapperList = new List<roomwrapper>();
        wrapperList.add(new roomwrapper(room));
        wrapperList.add(new roomwrapper(room1));
        map<string,list<Exam_Attempt__c> > mapSiteExamAttempts = new  map<string,list<Exam_Attempt__c> > ();
        mapSiteExamAttempts.put(string.valueOf(attempt.member__c),new Exam_Attempt__c[]{attempt} );
        map<id,set<id>> map_FRMSiteMembers = new map<id,set<id>>();
        set<id> newset = new set<id>();
        newset.add(attempt.member__c);
        map_FRMSiteMembers.put(site.id,newset);
        ExamAllocationUtil.assignMultipleRoomsFRM12(site.Id, 12, new roomwrapper(room), map_FRMSiteMembers, mapSiteExamAttempts, new Exam_Attempt__c[]{attempt}, 10);
        test.stopTest();
        
    }
    
    static testMethod void unitTest_5(){
        testData();
        test.startTest();
        List<roomwrapper> wrapperList = new List<roomwrapper>();
        wrapperList.add(new roomwrapper(room));
        wrapperList.add(new roomwrapper(room1));
        map<string,list<Exam_Attempt__c> > mapSiteExamAttempts = new  map<string,list<Exam_Attempt__c> > ();
        mapSiteExamAttempts.put(string.valueOf(attempt.member__c),new Exam_Attempt__c[]{attempt} );
        map<id,set<id>> map_FRMSiteMembers = new map<id,set<id>>();
        set<id> newset = new set<id>();
        newset.add(attempt.member__c);
        map_FRMSiteMembers.put(site.id,newset);
        ExamAllocationUtil.assignOneRoomFRM1OR2(string.valueof(site.id),decimal.valueOf(12),wrapperList, map_FRMSiteMembers,mapSiteExamAttempts,new Exam_attempt__c []{attempt},10);
         
        test.stopTest();
        
    }
    
    static testMethod void unitTest_6(){
        testData();
        test.startTest();
        List<roomwrapper> wrapperList = new List<roomwrapper>();
        wrapperList.add(new roomwrapper(room));
        wrapperList.add(new roomwrapper(room1));
        map<string,list<Exam_Attempt__c> > map_SiteExamAttempts = new  map<string,list<Exam_Attempt__c> > ();
        map_SiteExamAttempts.put(string.valueOf(attempt.member__c),new Exam_Attempt__c[]{attempt} );
        map<id,set<id>> map_FRMSiteMembers = new map<id,set<id>>();
        set<id> newset = new set<id>();
        newset.add(attempt.member__c);
        map_FRMSiteMembers.put(site.id,newset);
        ExamAllocationUtil.assignMultipleRoomsFRM1OR2(String.valueOf(site.Id),12,new RoomWrapper(room), map_FRMSiteMembers,map_SiteExamAttempts,new Exam_Attempt__c[]{attempt},10);
        test.stopTest();
        
    }
    
    
}