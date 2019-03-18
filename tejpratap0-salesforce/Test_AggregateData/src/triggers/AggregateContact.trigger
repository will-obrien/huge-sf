trigger AggregateContact on Contact  ( after delete, after insert, after update)  {
    if (Trigger.isAfter) {
        
        if (Trigger.isInsert) {
            for (Contact obj : Trigger.new) {
                
                if( obj.AccountId != null ){
                    Account parAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: obj.AccountId LIMIT 1];
                    if(parAcc != null)
                            parAcc = AggregateHandler.initCustomFields(parAcc);
                    
                    parAcc.Contacts__c++;
                   /* 
                    if(parAcc.ContactIds__c != null && parAcc.ContactIds__c != '')
                        parAcc.ContactIds__c = parAcc.ContactIds__c +',' +obj.Id;
                    else
                        parAcc.ContactIds__c = obj.Id;
					*/
                 
                    parAcc.ContactIds__c = AggregateHandler.addId( parAcc.ContactIds__c, ''+obj.Id );
                    try{
                        update parAcc;  
						System.debug('#Account# '+parAcc);
                    }catch(Exception e){
                        System.debug('Error '+ e.getMessage());
                    }
                }
            }
        }
        
        if (Trigger.isUpdate) {
            List<Account> accList = new List<Account>();          
            List<Contact> prevContacts  = Trigger.old;
            List<Contact> currContacts  = Trigger.new;
            Contact prevContact,currContact;
            Account prevAcc, currAcc;
                
            for (Integer i = 0; i < currContacts.size(); i++ ) {
                prevContact = prevContacts.get(i); 
                currContact = currContacts.get(i);
                
                prevAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: prevContact.AccountId ];
                currAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: currContact.AccountId ];
                
                if(prevAcc != null)
                    prevAcc = AggregateHandler.initCustomFields(prevAcc);
                
                if(currAcc != null)
                    currAcc = AggregateHandler.initCustomFields(currAcc);
                
                
                if(currContact.AccountId == null && prevContact.AccountId != null)
                {   
                    prevAcc.ContactIds__c = AggregateHandler.removeId(prevAcc.ContactIds__c, ''+prevContact.Id);
                    prevAcc.Contacts__c--;
                    accList.add(prevAcc);
                }
                else if(currContact.AccountId != null && prevContact.AccountId == null){  
                    currAcc.ContactIds__c = AggregateHandler.AddId(currAcc.ContactIds__c, ''+currContact.Id);
                    currAcc.Contacts__c++;
                    accList.add(currAcc);
                }
                else if(currContact.AccountId != null && prevContact.AccountId != null && currContact.AccountId != prevContact.AccountId)  
                { 
                    prevAcc.ContactIds__c = AggregateHandler.removeId(prevAcc.ContactIds__c, ''+prevContact.Id);
                    prevAcc.Contacts__c--;
                    currAcc.ContactIds__c = AggregateHandler.AddId(currAcc.ContactIds__c, ''+currContact.Id);
                    currAcc.Contacts__c++;
                    
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
            for (Contact obj : Trigger.old) { 
                if( obj.AccountId != null ){ 
                    
                    Account parAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: obj.AccountId LIMIT 1];
                    if(parAcc != null)
                            parAcc = AggregateHandler.initCustomFields(parAcc);
                    
                    parAcc.Contacts__c--;
                    parAcc.ContactIds__c = AggregateHandler.removeId(parAcc.ContactIds__c, ''+obj.Id);
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