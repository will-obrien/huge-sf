/*  This is Apex Trigger to aggregate data of Opportunity (weekly) in Account's custom fields.
*
*   Following Custom Fields used to aggregate the count & id of Opportunity -
*   
*   OpportunitiesCL__c      OpportunitiesCW__c      OpportunitiesOP__c      Opportunities__c  OpportunitiesER__c
*   OpportunityCWIds__c     OpportunityCLIds__c     OpportunityOPIds__c     OpprtunityIds__c  
* 
*   Revision History: 
*
*   Version     Author          Date                Description 
*   1.0         Ksolves         September, 2014     Initial Draft 
*                               October, 2014       Done.
*/

trigger AggregateOppotunity on Opportunity ( After delete, After insert, After update) {
     
    if (Trigger.isAfter) {
        
        /*
         *   This code will run when we create a new opportunity.
         */
        if (Trigger.isInsert) {
            for (Opportunity obj : Trigger.new) { 
                    if( obj.AccountId != null ){
                        
                        // Getting the parent Account of Opportunity
                        Account parAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c    FROM Account WHERE Id =: obj.AccountId LIMIT 1];
                        
                        // Initializing the parent Account's custom fields to default values 
                        if(parAcc != null)
                            parAcc = AggregateHandler.initCustomFields(parAcc);
                        
                        /*
                         *  Incrementing/decrementing the count of Opportuntity after detecting its StageName.
                         *  Adding/removing the Id of Opportuntity after detecting its StageName. 
                         *  Adjusting the Expected revenue of Opportunity. 
                         */
                         
                        if ((obj.StageName).equals('Closed Won')){
                            parAcc.OpportunitiesCW__c++; 
                        }
                        else if((obj.StageName).equals('Closed Lost')){
                            parAcc.OpportunitiesCL__c++;  
                        }
                        else {
                            parAcc.OpportunitiesOP__c++; 
                        }
                          
                        parAcc.OpprtunityIds__c = AggregateHandler.addId(parAcc.OpprtunityIds__c, ''+obj.Id);
                        parAcc.Opportunities__c++;
                        
                        if( obj.Amount != null )
                            parAcc.OpportunitiesER__c = parAcc.OpportunitiesER__c + obj.Amount;
                         
                        try{
                            
                            // Updating the parent Account
                            update parAcc;
                        }catch(Exception e){
                            System.debug('Error '+ e.getMessage());
                        }
                    }
            }
        }
       
        /*
         *   This code will run when we update a new opportunity.
         */
        if (Trigger.isUpdate) { 
            List<Account> accList = new List<Account>();       
             
            // Getting old versions of the parent Account of Opportunity.
            List<Opportunity> prevOpps  = Trigger.old;
            
            // Getting new versions of the parent Account of Opportunity.
            List<Opportunity> currOpps  = Trigger.new;
            
            Opportunity prevOpp, currOpp;
            Account prevAcc, currAcc;
            
                for (Integer i = 0; i < currOpps.size(); i++ ) {
                    
                    prevOpp = prevOpps.get(i);   
                    currOpp = currOpps.get(i);  
                    
                    if(prevOpp.AccountId != null)
                        prevAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: prevOpp.AccountId ]; 
                    if(currOpp.AccountId != null) 
                        currAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: currOpp.AccountId ];
                    
                    // Initializing the old versions parent Account's custom fields to default values 
                    if(prevAcc != null)
                        prevAcc = AggregateHandler.initCustomFields(prevAcc);
                        
                    // Initializing the new versions parent Account's custom fields to default values 
                    if(currAcc != null)
                        currAcc = AggregateHandler.initCustomFields(currAcc);
                     
                    /*
                     *  Incrementing/decrementing the count of Opportuntity after detecting its StageName.
                     *  Adding/removing the Id of Opportuntity after detecting its StageName. 
                     *  Adjusting the Expected revenue of Opportunity. 
                     */                     if(currOpp.AccountId == null && prevOpp.AccountId != null)
                    {   
                        if((prevOpp.StageName).equals('Closed Won')){
                                 prevAcc.OpportunitiesCW__c--;  
                        }
                        else if((prevOpp.StageName).equals('Closed Lost')){
                                 prevAcc.OpportunitiesCL__c--; 
                        }
                        else{
                                 prevAcc.OpportunitiesOP__c--; 
                        }
                        
                        prevAcc.OpprtunityIds__c = AggregateHandler.removeId(prevAcc.OpprtunityIds__c, ''+prevOpp.Id);
                        prevAcc.Opportunities__c--;
                        
                        accList.add(prevAcc);
                    }
                    else if(currOpp.AccountId != null && prevOpp.AccountId == null){ 
                        
                        if((currOpp.StageName).equals('Closed Won')){
                                 currAcc.OpportunitiesCW__c++;  
                        }
                        else if((currOpp.StageName).equals('Closed Lost')){ 
                                 currAcc.OpportunitiesCL__c++;
                        }
                        else{
                                 currAcc.OpportunitiesOP__c++; 
                        }
                        
                        currAcc.OpprtunityIds__c = AggregateHandler.addId(currAcc.OpprtunityIds__c, ''+currOpp.Id);
                        currAcc.Opportunities__c++; 
                        accList.add(currAcc);
                    }
                    else if(currOpp.AccountId != null && prevOpp.AccountId != null ){  
                        if(currOpp.AccountId != prevOpp.AccountId){                             
                             if(!(prevOpp.StageName).equals(currOpp.StageName)) 
                             { 
                                if((prevOpp.StageName).equals('Closed Won'))
                                         prevAcc.OpportunitiesCW__c--; 
                                else if((prevOpp.StageName).equals('Closed Lost'))
                                         prevAcc.OpportunitiesCL__c--;
                                else
                                         prevAcc.OpportunitiesOP__c--;
                                
                                prevAcc.OpprtunityIds__c = AggregateHandler.removeId(prevAcc.OpprtunityIds__c, ''+prevOpp.Id );
                                prevAcc.Opportunities__c--;
                                 
                                 
                                if ((currOpp.StageName).equals('Closed Won'))
                                         currAcc.OpportunitiesCW__c++;
                                else if((currOpp.StageName).equals('Closed Lost'))
                                        currAcc.OpportunitiesCL__c++;
                                else
                                        currAcc.OpportunitiesOP__c++; 
                                 
                                 currAcc.OpprtunityIds__c = AggregateHandler.addId(currAcc.OpprtunityIds__c, ''+currOpp.Id);
                                 currAcc.Opportunities__c++;
                                 
                                }
                                else{
                                if((prevOpp.StageName).equals('Closed Won'))
                                         prevAcc.OpportunitiesCW__c--; 
                                else if((prevOpp.StageName).equals('Closed Lost'))
                                         prevAcc.OpportunitiesCL__c--;
                                else
                                         prevAcc.OpportunitiesOP__c--;
                                    
                                    prevAcc.OpprtunityIds__c = AggregateHandler.removeId(prevAcc.OpprtunityIds__c, ''+prevOpp.Id);
                                    prevAcc.Opportunities__c--;
                                    
                                if ((currOpp.StageName).equals('Closed Won'))
                                         currAcc.OpportunitiesCW__c++;
                                else if((currOpp.StageName).equals('Closed Lost'))
                                        currAcc.OpportunitiesCL__c++;
                                else
                                        currAcc.OpportunitiesOP__c++; 
                                    
                                    currAcc.OpprtunityIds__c = AggregateHandler.addId(currAcc.OpprtunityIds__c, ''+currOpp.Id);
                                    currAcc.Opportunities__c++;
                                }
                            
                                if(prevOpp.Amount != null){
                                    prevAcc.OpportunitiesER__c =   prevAcc.OpportunitiesER__c - prevOpp.Amount;
                                }   
                                
                                if( currOpp.Amount != null){
                                    currAcc.OpportunitiesER__c = currAcc.OpportunitiesER__c + currOpp.Amount ;
                                }
                               
                            accList.add(prevAcc);  
                            accList.add(currAcc);  
                        }
                        else{  
                             if(!(prevOpp.StageName).equals(currOpp.StageName)) { 
                                if((prevOpp.StageName).equals('Closed Won'))
                                         currAcc.OpportunitiesCW__c--; 
                                else if((prevOpp.StageName).equals('Closed Lost'))
                                         currAcc.OpportunitiesCL__c--;
                                else
                                         currAcc.OpportunitiesOP__c--;
                                
                                if ((currOpp.StageName).equals('Closed Won'))
                                         currAcc.OpportunitiesCW__c++;
                                else if((currOpp.StageName).equals('Closed Lost'))
                                        currAcc.OpportunitiesCL__c++;
                                else
                                        currAcc.OpportunitiesOP__c++;
                            }
                            
                            if(currOpp.Amount != null){
                                if( prevOpp.Amount != null)
                                    currAcc.OpportunitiesER__c = currAcc.OpportunitiesER__c + currOpp.Amount - prevOpp.Amount ;
                                else
                                    currAcc.OpportunitiesER__c = currAcc.OpportunitiesER__c + currOpp.Amount;
                            }
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
        }
        
        /*
         *   This code will run when we delete a new opportunity.
         */ 
        if (Trigger.isDelete) {
            for (Opportunity obj : Trigger.old) {
                    if( obj.AccountId != null ){
                        
                        // Getting old versions of the parent Account of Opportunity.
                        Account parAcc = [SELECT Name,  CaseIds__c, Cases__c, ContactIds__c, Contacts__c, OpportunitiesCL__c, OpportunitiesCW__c, OpportunitiesOP__c, Opportunities__c, OpportunityCWIds__c, OpportunityCLIds__c, OpportunityOPIds__c, OpprtunityIds__c, OpportunitiesER__c FROM Account WHERE Id =: obj.AccountId ];
                         
                        // Initializing the old versions parent Account's custom fields to default values 
                        if(parAcc != null)
                            parAcc = AggregateHandler.initCustomFields(parAcc);
  
                        /*
                         *  Incrementing/decrementing the count of Opportuntity after detecting its StageName.
                         *  Adding/removing the Id of Opportuntity after detecting its StageName. 
                         *  Adjusting the Expected revenue of Opportunity. 
                         */
                         
                        if ((obj.StageName).equals('Closed Won')) 
                            parAcc.OpportunitiesCW__c--; 
                        else if((obj.StageName).equals('Closed Lost')) 
                            parAcc.OpportunitiesCL__c--; 
                        else 
                            parAcc.OpportunitiesOP__c--;
                        
                            parAcc.OpprtunityIds__c = AggregateHandler.removeId(parAcc.OpprtunityIds__c, ''+obj.Id); 
                            parAcc.Opportunities__c--;
 
                        if( obj.Amount != null )
                            parAcc.OpportunitiesER__c = parAcc.OpportunitiesER__c - obj.Amount;
                       
                        try{
                            
                            // Updating the parent Account
                            update parAcc;
                        }catch(Exception e){
                            System.debug('Error '+ e.getMessage());
                        }
                    }
                
            }
        }
    }
}