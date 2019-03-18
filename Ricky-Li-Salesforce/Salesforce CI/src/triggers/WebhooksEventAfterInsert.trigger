trigger WebhooksEventAfterInsert on Webhooks_Event__c (after insert) {
   
    for(Webhooks_Event__c we: Trigger.new){
        // Set the endpoint URL.
        String endpoint = we.href__c;
        JSONParserUtil.parseJSONResponse(endpoint);
    }   
}