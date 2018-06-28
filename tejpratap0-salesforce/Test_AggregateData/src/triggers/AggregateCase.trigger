trigger AggregateCase on Case ( after delete, after insert, after update)  {
  if (Trigger.isAfter) {
    	if (Trigger.isInsert) {
             for (Case obj : Trigger.new) { 
                 	Account parAcc;
                    Case CaseId;
                	if( obj.AccountId != null ){
                        parAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: obj.AccountId LIMIT 1];
                        
                        if(parAcc != null)
                            parAcc = AggregateHandler.initCustomFields(parAcc);
                        
                            parAcc.CaseIds__c = AggregateHandler.AddId(parAcc.CaseIds__c, ''+obj.Id);
                            parAcc.Cases__c++;
                        try{
                            update parAcc;
                        }catch(Exception e){ 
                            System.debug('Error '+ e.getMessage());
                        }
                    }
             }
        }
   
      if (Trigger.isUpdate) {
          	List<Account> accList = new List<Account>();          
          	List<Case> prevCases  = Trigger.old;
          	List<Case> currCases  = Trigger.new;
          	Case prevCase, currCase;
            Account prevAcc, currAcc;
                
                for (Integer i = 0; i < currCases.size(); i++ ) {
                    prevCase = prevCases.get(i); 
                	currCase = currCases.get(i); 
                   
                    prevAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: prevCase.AccountId ];
                    currAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: currCase.AccountId ];
                    
					if(prevAcc != null)
                            prevAcc = AggregateHandler.initCustomFields(prevAcc);
                    
                    if(currAcc != null)
                            currAcc = AggregateHandler.initCustomFields(currAcc);
                    
                    if(currCase.AccountId == null && prevCase.AccountId != null)
                    {   
                 	   	prevAcc.CaseIds__c = AggregateHandler.removeId( prevAcc.CaseIds__c, ''+prevCase.Id);
                        prevAcc.Cases__c--;
                        accList.add(prevAcc);
                    }
                    else if(currCase.AccountId != null && prevCase.AccountId == null){  
                        currAcc.CaseIds__c = AggregateHandler.removeId( currAcc.CaseIds__c, ''+currCase.Id);
                        currAcc.Cases__c++;
                        accList.add(currAcc);
                    }
                    else if(currCase.AccountId != null && prevCase.AccountId != null && currCase.AccountId != prevCase.AccountId)  
                    { 
                         prevAcc.CaseIds__c = AggregateHandler.removeId( prevAcc.CaseIds__c, ''+prevCase.Id);
                         prevAcc.Cases__c--;
                         currAcc.CaseIds__c = AggregateHandler.removeId( currAcc.CaseIds__c, ''+currCase.Id);
                         currAcc.Cases__c++;
                         accList.add(prevAcc);
                         accList.add(currAcc); 
                    }	    
            }
 			 try{   
                        if( !accList.isEmpty())
                     		update accList ;
                       }
                    catch(Exception e){
                     System.debug('Error '+ e.getMessage());
                   } 
          
        }
      
        if (Trigger.isDelete) {
            for (Case obj : Trigger.old) { 
                	if( obj.AccountId != null ){
                        Account parAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: obj.AccountId LIMIT 1];
                        
                         if(parAcc != null)
                            parAcc = AggregateHandler.initCustomFields(parAcc);
                        
                        	parAcc.CaseIds__c = AggregateHandler.removeId( parAcc.CaseIds__c, ''+obj.Id);
                            parAcc.Cases__c--;
                         try{
                            update parAcc;
                        }catch(Exception e){
                            System.debug('Error '+ e.getMessage());
                        }
                    }
             }
        }
    }
}