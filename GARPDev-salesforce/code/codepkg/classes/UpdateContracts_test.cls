@isTest

public class UpdateContracts_test{

    static Account acc;
    static Opportunity opp;
    static Contract contract;
    static Candidate_Requirement__c reqt;
    
    static void testData(){
        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()- 100);        
        insert opp;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('FRM Program').getRecordTypeId();

        string memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
        string icbrrRecordType = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
        string frmRecordType = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
        string fbrRecordType = RecordTypeHelper.GetRecordTypeId('Contract','FBR Program');
        string erpRecordType = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
        string cpeRecordType = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        
        
        Contract Contract6  = new Contract(recordtypeId = erpRecordType ,Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12,StartDate = opp.CloseDate);
        insert contract6;
        contract6.Status = 'Draft';
        update contract6;
        
               
        Contract Contract7  = new Contract(recordtypeId = cpeRecordType ,Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12,StartDate = opp.CloseDate);
        insert contract7;
        contract7.Status = 'Draft';
        update contract7;
        
        Contract Contract8  = new Contract(recordtypeId = cpeRecordType ,Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12,StartDate = opp.CloseDate);
        insert contract8;
        contract8.Status = 'Activated ( Auto-Renew )';
        update contract8;
        
        Contract Contract4  = new Contract(recordtypeId = frmRecordType ,Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12,StartDate = opp.CloseDate);
        insert contract4;
        contract4.Status = 'Draft';
        update contract4;
        
               
        Contract Contract5  = new Contract(recordtypeId = fbrRecordType ,Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12,StartDate = opp.CloseDate);
        insert contract5;
        contract5.Status = 'Draft';
        update contract5;
        
        Contract Contract3  = new Contract(recordtypeId = icbrrRecordType ,Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12,StartDate = opp.CloseDate);
        insert contract3;
        contract3.Status = 'Draft';
        update contract3;
        
        Contract Contract2  = new Contract(recordtypeId = memRecordType ,Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12,StartDate = opp.CloseDate);
        insert contract2;
        contract2.Status = 'Draft';
        update contract2;
        
        Contract  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12   ,recordtypeID =cpeRecordType  ,StartDate = opp.CloseDate);
        insert contract;

        contract.Status = 'Draft';
        update contract;
        
        Contract Contract1  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12   ,recordtypeID = icbrrRecordType  ,StartDate = opp.CloseDate);
        insert contract1;

        contract1.Status = 'Draft';
        update contract1;
        
        
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        Candidate_Requirement__c reqt1 = new Candidate_Requirement__c();
        reqt1.Candidate_Commitment__c = contract1.id;
        reqt1.name = 'FRM1 test';
        insert reqt1;
        
        Candidate_Requirement__c reqt2 = new Candidate_Requirement__c();
        reqt2.Candidate_Commitment__c = contract2.id;
        reqt2.name = 'FRM1 test';
        insert reqt2;
        
        Candidate_Requirement__c reqt3 = new Candidate_Requirement__c();
        reqt3.Candidate_Commitment__c = contract3.id;
        reqt3.name = 'FRM1 test';
        insert reqt3;
        
        Candidate_Requirement__c reqt4 = new Candidate_Requirement__c();
        reqt4.Candidate_Commitment__c = contract4.id;
        reqt4.name = 'FRM1 test';
        insert reqt4;
        
        Candidate_Requirement__c reqt5 = new Candidate_Requirement__c();
        reqt5.Candidate_Commitment__c = contract5.id;
        reqt5.name = 'FRM1 test';
        insert reqt5;
        
        Candidate_Requirement__c reqt6 = new Candidate_Requirement__c();
        reqt6.Candidate_Commitment__c = contract6.id;
        reqt6.name = 'FRM1 test';
        insert reqt6;
        Candidate_Requirement__c reqt7 = new Candidate_Requirement__c();
        reqt7.Candidate_Commitment__c = contract7.id;
        reqt7.name = 'FRM1 test';
        insert reqt7;
        
        
        
    }
    
    static testMethod void unitTest_1(){
    
        testData();
        test.startTest();
        updateContracts contracts = new updateContracts();
        Database.executebatch(contracts);
        test.stopTest();
    }


}