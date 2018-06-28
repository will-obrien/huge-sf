@isTest
public class Cpestatus_test {


    static testMethod void unitTest_1(){
        
        test.startTest();
        Account acc = new Account(Name = 'test');
        insert acc;
         
        Contact contact = new Contact(LEGACY_PK_PID__c  = '123',lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        insert new UpdateIds__c(Name='Payment', Record_Id__c='a0cf00000041nXB');
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
         
        Opportunity opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo.get('CPE').getRecordTypeId();
        Contract Contract  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12,StartDate = system.today() -15 );
        insert contract;
        contract.Status = 'Activated';
        update contract;
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(ContractTerm =2,startDate = system.today()- 100,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opp.id,accountId = opp.AccountId);
        insert con;
        con.Status = 'Activated';
        update con;
        
        Id recType4CPEReq = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'CPE');
        Candidate_Requirement__c  reqt = new Candidate_Requirement__c (Candidate_Commitment__c  = con.id,recordtypeid= recType4CPEReq);
        insert reqt;
        
        
        CPE_Claim__c claim = new CPE_Claim__c();
        claim.Candidate_Requirement__c  = reqt.id ;
        claim.Credits_Earned__c   = 123;
        claim.Member__c = contact.id;
        insert claim;
        
        
        
        CPEStatus status = new CPEStatus(new ApexPages.StandardController(contact));
        status.goRequirement();
        
        test.stopTest();
    }
    
    
}