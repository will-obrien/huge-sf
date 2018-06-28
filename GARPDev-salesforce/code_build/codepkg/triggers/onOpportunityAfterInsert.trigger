trigger onOpportunityAfterInsert on Opportunity (after insert) {
    
    //List < Opportunity > opps = Trigger.new;
    //List<ID> ids = new List<ID>();
    
    List<Opportunity> lstOpps =  [select Id, name, RecordTypeId, Display_Invoice_Number__c, GARP_Invoice_Number__c from Opportunity where ID in :Trigger.new];

    Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity', 'Automated');
    
    for(Opportunity op :lstOpps) {
        if (op.RecordTypeId == recordTypeID) {
            op.Display_Invoice_Number__c = 'W' + op.GARP_Invoice_Number__c;
        } else {
            op.Display_Invoice_Number__c = 'P' + op.GARP_Invoice_Number__c;
        }
    }
    update lstOpps;
}