@isTest
public class ViewPortalMemberExtension_Test {
    static Contact c;
    
    static void setupData() {
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        Id busRedcordtype = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship');
        Account acc = new Account(name= 'Test Account');
        insert acc;
        c = new Contact(recordtypeId = busRedcordtype,lastname = 'Test',GARP_Member_ID__c ='45678',email='test@gdsfatest.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17),accountId = acc.Id);
        insert c; 
        
        c = [SELECT Id, AccountId, Account.Name FROM Contact WHERE Id = :c.id];
        
        Contract frmContract = new Contract(StartDate=System.today().addDays(-10), ContractTerm=12, Status='Draft', AccountId=c.AccountId);
        Contract erpContract = new Contract(StartDate=System.today().addDays(-10), ContractTerm=12, Status='Draft', AccountId=c.AccountId);
        Contract icbrrContract = new Contract(StartDate=System.today().addDays(-10), ContractTerm=12, Status='Draft', AccountId=c.AccountId);
        Contract fbrContract = new Contract(StartDate=System.today().addDays(-10), ContractTerm=12, Status='Draft', AccountId=c.AccountId);
        List<Contract> contracts = new List<Contract>{ frmContract,erpContract,icbrrContract,fbrContract };
        
        Candidate_Requirement__c frmExamRequirement = new Candidate_Requirement__c(Status__c='Completed',Date_Of_Completion__c=System.today());
        Candidate_Requirement__c frmExperienceRequirement = new Candidate_Requirement__c(Status__c='Completed',Date_Of_Completion__c=System.today());
        Candidate_Requirement__c erpExperienceRequirement = new Candidate_Requirement__c(Status__c='Completed',Date_Of_Completion__c=System.today());
        Candidate_Requirement__c icbrrExperienceRequirement = new Candidate_Requirement__c(Status__c='Completed',Date_Of_Completion__c=System.today());
        List<Candidate_Requirement__c> requirements = new List<Candidate_Requirement__c>{ frmExamRequirement,frmExperienceRequirement,erpExperienceRequirement,icbrrExperienceRequirement };
        
        for (RecordType rt : [SELECT Id, DeveloperName, SObjectType FROM RecordType WHERE (SobjectType = 'Contract' OR SobjectType = 'Candidate_Requirement__c') 
                               AND (DeveloperName like '%frm%' OR DeveloperName like '%erp%' OR DeveloperName like '%icbrr%' OR DeveloperName like '%fbr%' OR DeveloperName like '%exam%' OR DeveloperName like '%Job_Experience%')]) {
       
            if (rt.SObjectType == 'Contract') {
                if (rt.DeveloperName.containsIgnoreCase('frm')) {
                    frmContract.RecordTypeId = rt.id;
                } else if (rt.DeveloperName.containsIgnoreCase('erp')) {
                    erpContract.RecordTypeId = rt.id;
                } else if (rt.DeveloperName.containsIgnoreCase('icbrr')) {
                    icbrrContract.RecordTypeId = rt.id;
                } else if (rt.DeveloperName.containsIgnoreCase('fbr')) {
                    fbrContract.RecordTypeId = rt.id;
                } 
            } else if (rt.SobjectType == 'Candidate_Requirement__c') {
                if (rt.DeveloperName.containsIgnoreCase('exam')) {
                    frmExamRequirement.RecordTypeId = rt.id;
                } else if (rt.DeveloperName.containsIgnoreCase('Job_Experience')) {
                    frmExperienceRequirement.RecordTypeId = rt.id;
                    erpExperienceRequirement.RecordTypeId = rt.id;
                    icbrrExperienceRequirement.RecordTypeId = rt.id;
                }  
            }
        }
        
        insert contracts;
        
        frmExamRequirement.Candidate_Commitment__c = frmContract.id;
        frmExperienceRequirement.Candidate_Commitment__c = frmContract.id;
        erpExperienceRequirement.Candidate_Commitment__c = erpContract.id;
        icbrrExperienceRequirement.Candidate_Commitment__c = icbrrContract.id;
        insert requirements;
        
        Attachment frmExperienceAttachment = new Attachment(Name='Test.txt', Body=Blob.valueOf('test'), ParentId=frmExperienceRequirement.id);
        Attachment erpExperienceAttachment = new Attachment(Name='Test.txt', Body=Blob.valueOf('test'), ParentId=erpExperienceRequirement.id);
        Attachment icbrrExperienceAttachment = new Attachment(Name='Test.txt', Body=Blob.valueOf('test'), ParentId=icbrrExperienceRequirement.id);
        List<Attachment> attachments = new List<Attachment>{ frmExperienceAttachment,erpExperienceAttachment,icbrrExperienceAttachment };
        insert attachments;
        
        for (Contract contract : contracts) {
            contract.Status = 'Activated';
        }
        update contracts; 
        
        Opportunity frmOpp = new Opportunity(ContractId=frmContract.id, AccountId=c.Account.id, Auto_Renew__c=true, ChargentSFA__Payment_Status__c='Recurring', Company__c='GARP', ChargentSFA__Payment_Frequency__c='Once', name='Test Name', StageName='New', CloseDate=system.today().addDays(2), ChargentSFA__Charge_Amount__c=195);
        Opportunity erpOpp = new Opportunity(ContractId=erpContract.id, AccountId=c.Account.id, Auto_Renew__c=true, ChargentSFA__Payment_Status__c='Recurring', Company__c='GARP', ChargentSFA__Payment_Frequency__c='Once', name='Test Name', StageName='New', CloseDate=system.today().addDays(2), ChargentSFA__Charge_Amount__c=195);
        Opportunity icbrrOpp = new Opportunity(ContractId=icbrrContract.id, AccountId=c.Account.id, Auto_Renew__c=true, ChargentSFA__Payment_Status__c='Recurring', Company__c='GARP', ChargentSFA__Payment_Frequency__c='Once', name='Test Name', StageName='New', CloseDate=system.today().addDays(2), ChargentSFA__Charge_Amount__c=195);
        Product2 prod = new Product2(Name='Miscellaneous', productCode='MISC', GL_Code__c='4999', isActive=true);
        insert new List<SObject> { frmOpp,erpOpp,icbrrOpp,prod };
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pe = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=prod.Id, UnitPrice=10000, IsActive=true);
        insert pe;
             
        insert new List<OpportunityLineItem> {
            new OpportunityLineItem(TotalPrice=20, quantity=1, Description='Certificate Replacement', OpportunityId=frmOpp.id, PricebookEntryId=pe.id),
            new OpportunityLineItem(TotalPrice=20, quantity=1, Description='Certificate Replacement', OpportunityId=erpOpp.id, PricebookEntryId=pe.id),
            new OpportunityLineItem(TotalPrice=20, quantity=1, Description='Certificate Replacement', OpportunityId=icbrrOpp.id, PricebookEntryId=pe.id)
        };
        
        Exam__c frm1Exam = new Exam__c(Exam__c='FRM Part 1', Exam_Date__c=System.today());  
        Exam__c frm2Exam = new Exam__c(Exam__c='FRM Part 2', Exam_Date__c=System.today()); 
        Exam__c erpExam = new Exam__c(Exam__c='ERP', Exam_Date__c=System.today()); 
        Exam__c icbrrExam = new Exam__c(Exam__c='ICBRR', Exam_Date__c=System.today());
        List<Exam__c> exams = new List<Exam__c>{ frm1Exam,frm2Exam,erpExam,icbrrExam };
        insert exams;
        
        Site__c site = new Site__c(Name='Test Site');
        insert site;
        
        Exam_Sites__c frm1Site = new Exam_Sites__c(Exam__c=frm1Exam.id, Site__c=site.id);  
        Exam_Sites__c frm2Site = new Exam_Sites__c(Exam__c=frm2Exam.id, Site__c=site.id);  
        Exam_Sites__c erpSite = new Exam_Sites__c(Exam__c=erpExam.id, Site__c=site.id);  
        Exam_Sites__c icbrrSite = new Exam_Sites__c(Exam__c=icbrrExam.id, Site__c=site.id); 
        List<Exam_Sites__c> sites = new List<Exam_Sites__c>{ frm1Site,frm2Site,erpSite,icbrrSite };
        insert sites;  
     
        Exam_Attempt__c frm1Attempt = new Exam_Attempt__c(Candidate_Requirement__c=frmExamRequirement.id, Exam_Site__c=frm1Site.id, Member__c=c.id);
        Exam_Attempt__c frm2Attempt = new Exam_Attempt__c(Candidate_Requirement__c=frmExamRequirement.id, Exam_Site__c=frm2Site.id, Member__c=c.id);
        Exam_Attempt__c erpAttempt = new Exam_Attempt__c(Candidate_Requirement__c=frmExamRequirement.id, Exam_Site__c=erpSite.id, Member__c=c.id);
        Exam_Attempt__c icbrrAttempt = new Exam_Attempt__c(Candidate_Requirement__c=frmExamRequirement.id, Exam_Site__c=icbrrSite.id, Member__c=c.id, Result__c='Pass');
        List<Exam_Attempt__c> attempts = new List<Exam_Attempt__c>{ frm1Attempt,frm2Attempt,erpAttempt,icbrrAttempt };
        insert attempts;  
    }
    
    static testMethod void runTest() {
        setupData();
        Contact theContact = [SELECT Id, AccountId, KPI_FRM_Certified__c, KPI_FRM_Certified_Date__c, KPI_ERP_Certified__c, KPI_ERP_Certified_Date__c, KPI_ICBRR_Result__c FROM Contact WHERE Id = :c.id];
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(theContact);
        ViewPortalMemberExtension extention = new ViewPortalMemberExtension(controller);
        Test.stopTest();
    }
}