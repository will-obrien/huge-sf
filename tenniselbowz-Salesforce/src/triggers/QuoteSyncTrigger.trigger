trigger QuoteSyncTrigger on Apttus_Proposal__Proposal__c (after insert, after update) {
    
    
    
     /*
    if(Trigger.isBefore && Trigger.isInsert){                  //before Insert
        
    } 
  */
    /*
    if(Trigger.isBefore && Trigger.isUpdate){                  //before update
      
    }
  */
    
     
    /*if(Trigger.isBefore && Trigger.isdelete){                  //before update
      QuoteProposalTriggerHandler.deleteOppSyncFieldswhenQuoteDeletedbefore(Trigger.NewMap);
    }*/
  
    
  
    if(Trigger.isAfter && Trigger.isInsert){                  //After Insert
       QuoteProposalTriggerHandler.syncQuotetoOpportunity(Trigger.newmap, Trigger.oldmap);
    }
  
    
    if(Trigger.isAfter && Trigger.isUpdate){                  //After Update
      QuoteProposalTriggerHandler.syncQuotetoOpportunity(Trigger.newmap, Trigger.oldmap);
    }
    
    /*if(Trigger.isAfter && Trigger.isDelete){
       QuoteProposalTriggerHandler.deleteOppSyncFieldswhenQuoteDeleted(Trigger.oldmap); 
    }*/
}