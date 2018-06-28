@isTest
public class onUpdateAttachment_test {

    static testMethod void unitTest_1(){
        
        test.startTest();
        
        insert new UpdateIds__c(Name='Payment', Record_Id__c='a0cf00000041nXB');
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        
        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Account Acc = new Account(Name = 'test');
        insert acc;
         
        Opportunity opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('FRM Program').getRecordTypeId();
        
        Contract Contract  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12     ,StartDate = opp.CloseDate        );
        insert contract;
        contract.Status = 'Activated';
        update contract;
        
        Id jobRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Job Experience');
        
        Candidate_Requirement__c reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        reqt.RecordTypeId = jobRecordTypeID;
        insert reqt;

        Attachment att = new attachment (parentId = reqt.id,body=blob.valueof('b'),Name='attachment');
        insert att;
        
        test.stopTest();
    }
}