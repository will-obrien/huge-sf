@isTest
public class SwitchLayer_test {

    static profile profile1;
    static user user1;
    static account acc;
    static opportunity opp;
    static contact contact1;
    static PricebookEntry customPrice;
    static Product2 prod7 ;
    static exam_attempt__c attempt;
    static exam_attempt__c attempt1;
    static exam__c exam;
    static Contract contract1;
    static contact contact;
    
    static void testData(){
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        Contract1  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12     ,StartDate = opp.CloseDate        );
        insert contract1;
        contract1.Status = 'Activated';
        update contract1;
        contact1 = new Contact(recordtypeid = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship'),firstname = 'test1',lastname = 'test2',AccountId = acc.id,email='testtest@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact1;
        
        contact = new Contact(firstname = 'test1',lastname = 'test2',AccountId = acc.id,email='sdftesttest@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        profile1 = [SELECT Id FROM Profile WHERE usertype = 'CspLitePortal' limit 1]; 
        user1 = new User(Alias = 'newUser', Email='newuser@testorg.com',contactId = contact1.id,EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile1.Id, TimeZoneSidKey='America/Los_Angeles', UserName='testnewuser@testorg.com');
        
        prod7 = new Product2(Name = 'Laptop X200',productCode = 'GL0051',GL_Code__c = '4002',Family = 'Hardware',isActive = true);
        insert prod7;
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice7 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod7.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice7;
        
    
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod7.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Site__c site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false);
        insert site;
        
        Exam_Group__c objExamGrp = new Exam_Group__c();
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
        exam.name = 'FRM Part 1';
        insert exam;
        exam__c exam1 = new Exam__c();
        exam1.Exam_Group__c = objExamGrp.id;
        exam1.Exam_Date__c = system.today() + 30;
        exam1.exam__c = 'FRM Part 2'; 
        exam1.name = 'FRM Part 2';
        insert exam1;
        
        Exam_Sites__c exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite;
        
        attempt = new Exam_Attempt__c(Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact1.id,cancelled__c = false );
        insert attempt;
        
        attempt1 = new Exam_Attempt__c(Result__c = 'Pass',Opportunity__c = opp.id, Exam_Site__c = exmSite.id,Member__c = contact1.id,cancelled__c = false  );
        attempt1.Candidate_Commitment__c  = contract1.id;
        insert attempt1;
        
        
        
    }
    
    static testMethod void unitTest_1(){
      
        test.startTest();
        testData();
        system.runAs(user1){
            SwitchLayer.swithcLogic();
        }
        test.stopTest();
        
    }
    
    static testMethod void unitTest_2(){
               
        test.startTest();
        testData();
        switchlayer.lstExamDetails = new Exam__c []{exam};
        map<string,pricebookentry> mapPriceBookDetails = new map<string,pricebookentry>();
        mapPriceBookDetails.put(prod7.Name,customPrice);
        SwitchLayer.checkERPDetails(true, new exam_attempt__c[]{attempt}, mapPriceBookDetails);
        SwitchLayer.checkFRMDetails(true, new exam_attempt__c[]{attempt}, mapPriceBookDetails);
        SwitchLayer.getProductCodeByMonth(mapPriceBookDetails, exam.name, 12, 'Completed');
        test.stopTest();
        
    }
}