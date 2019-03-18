trigger createNewAccountOpportunity on Account (after update){  
   

    for (Account oAccount : trigger.new) {
        
        
        
        
        try {
   

    // Add a Opportunity to this account.
    Opportunity con = new Opportunity(
         Name = oAccount.Name,
        AccountId = oAccount.Id,
        StageName = 'Proposal',
        Type = 'New Customer',
        CloseDate = System.today() + 30 );
        
    insert con;
    
    
} catch(DmlException e) {
    System.debug('An unexpected error has occurred: ' + e.getMessage());
}
    }

   
}