public with sharing class CloneOpportunity {

 //Variable to hold current record
    Opportunity currentRecord;
    String currRecID = '';
    
    public CloneOpportunity(ApexPages.StandardController controller) 
    {
      currentRecord = (Opportunity)controller.getRecord();
    }
    
    public PageReference getID() {
      PageReference oppPage = new ApexPages.StandardController(currentRecord).view();
      oppPage.setRedirect(true);
      return oppPage; 
    }
    
    public PageReference cloneRecord()
    {
        //Variable to hold the new record
        Opportunity newRec;
        String oppDescription = '';
        
        //Set savepoint to roll back to incase of error
        Savepoint savePoint = Database.setSavepoint();

        try
        {
            currentRecord = [SELECT id, name, Valid_From__c, Valid_To__c, StageName, CloseDate, AccountID, Site__c, OwnerID,Type, Team__c, Opportunity_Sub_Owner__c 
            FROM Opportunity WHERE id =:currentRecord.id];
            newRec = currentRecord.clone(false);
            
            /*
            * Update the following details for the cloned opportunity:
            *    - Change the valid from/to dates to a year later to avoid overlapping membership
            *    - Keep the current owner of the opportunity
            *    - Set the risk level to 3
            *    - Change the type to renewal if the original opportunity was new business
            *    - Change the stage to qualification
            */
            
            List<OpportunityLineItem> prodlist = new List<OpportunityLineItem>();
            for(OpportunityLineItem prod : [SELECT PricebookEntry.Name FROM OpportunityLineItem WHERE  Opportunity.ID =:currentRecord.id])
            {
              prodlist.add(prod);
            }
            
            // Date validation
            newRec.Valid_From__c = currentRecord.Valid_To__c.addDays(1);
            newRec.Valid_To__c = newRec.Valid_From__c.addDays(currentRecord.Valid_From__c.daysBetween(currentRecord.Valid_To__c));
            
            //Set name of new opportunity
            //get year suffix for new opportunity name YYYYMM-YYYYMM format
            String fromMonth;
            String toMonth;
            if(newRec.Valid_From__c.month() < 10)
              fromMonth = '0' + String.valueOf(newRec.Valid_From__c.month());
            else
              fromMonth = String.valueOf(newRec.Valid_From__c.month());
            
            if(newRec.Valid_To__c.month() < 10)
              toMonth = '0' + String.valueOf(newRec.Valid_To__c.month());
            else
              toMonth = String.valueOf(newRec.Valid_To__c.month());            
              
              
            String nameYear = ': ' + newRec.Valid_From__c.year() + fromMonth + '-' + newRec.Valid_To__c.year() + toMonth;
            
            //Name options
            //If there is no Offer attached, or there are multiple offers attached; set the new name to the old name
            if(prodlist.isEmpty() || prodlist.size() > 1) {
              newRec.Name = currentRecord.Name + nameYear;
              //newRec.Name = currentRecord.Name; 
            }
            
            //There's just one offer. Make that the new name.
            if(prodlist.size() == 1) {
              newRec.Name = prodlist[0].PricebookEntry.Name + nameYear;
              //newRec.Name = prodlist[0].PricebookEntry.Name;
            }
            
            //Update the description in the new Opportunity to tell the user that the Opportunity doesn't have offers. 
            if(prodlist.isEmpty()) {
              oppDescription += '***Cloned Opportunity without any Offers attached***' + '\n';
            }

            newRec.Team__c = currentRecord.Team__c;

            newRec.Opportunity_Sub_Owner__c = currentRecord.Opportunity_Sub_Owner__c;
            
            //Validate owner (can't clone owner if current owner is inactive)
            User user = new User();
            user = [SELECT Id,IsActive FROM User WHERE id =:currentRecord.OwnerId];
            if(user.IsActive)
            {
              newRec.OwnerId = currentRecord.OwnerId;
            }
            else
            {
              newRec.OwnerId = UserInfo.getUserId();
              oppDescription += 'Owner changed as old owner is no longer active.' + '\n';
            }  
            
            newRec.Risk_level__c = '3';

            if(currentRecord.Type == 'New Business')
            {
              newRec.Type = 'Renewal';
            }

            newRec.StageName = 'Qualification';
            
            //Insert cloned opportunity
            newRec.Description = oppDescription;
            insert newRec;
            
            //Copy the related list - OpportunityContactRoles
            List<OpportunityContactRole> oppcontactroles = new List<OpportunityContactRole>();
            for( OpportunityContactRole  oppcontrole : [SELECT Id, Role, IsavePointrimary, OpportunityID, ContactID From OpportunityContactRole  WHERE  OpportunityId =:currentRecord.id])
            {
               OpportunityContactRole newoppcontrole = oppcontrole.clone(false);
               newoppcontrole.OpportunityId = newRec.Id;
               oppcontactroles.add(newoppcontrole);
            }

            //Insert related Contact Roles
            insert oppcontactroles;
            
            //Check if no role, and update description accordingly...
            if(oppcontactroles.isEmpty())
            {
              oppDescription += '***Cloned Opportunity without any Contact Roles attached***' + '\n';
              newRec.Description = oppDescription;
              update newRec;
            }            
            
            //Copy the related list - Offers
            List<OpportunityLineItem> opplineitems = new List<OpportunityLineItem>();
            for( OpportunityLineItem oppli : [Select Id, OpportunityId, SortOrder, PricebookEntryId, Quantity, TotalPrice, ListPrice, ServiceDate, Description, CreatedDate, CreatedById From OpportunityLineItem WHERE  OpportunityId =:currentRecord.id])
            {
              OpportunityLineItem newoppli = oppli.clone(false);
              newoppli.OpportunityId = newRec.Id;
              opplineitems.add(newoppli);
            }
            
            // Insert related line items
            insert opplineitems;
            
        }
        catch(Exception e)
        {
            Database.rollback(savePoint);
            ApexPages.addMessages(e);
            return null;
        }
        return new PageReference('/'+newRec.id);
    }
    
    public PageReference cancel() {
      PageReference sitePage = new ApexPages.StandardController(currentRecord).view();
      sitePage.setRedirect(true);
      return sitePage; 
    }    
}