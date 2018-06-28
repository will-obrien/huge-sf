// ========================================================================================================
// CaseTriggerHelper: Trigger for the Case object which handles all the events and based on the event delegates the task 
// to the corresponding trigger handler method in the CaseTriggerHelper class.
// ========================================================================================================
// SetAccountStatusField : Update related Account Status whenever a new Case is created. 
// ========================================================================================================
// EnforeAccountRules : In edit mode - do not allow user to modify Account Name/Owner 
// ========================================================================================================
// SetAllFieldsVerifiedField: Following updates and checks are performed in this trigger when 
// a Root Case record is inserted or updated. Set 'All Fields Verified?' field to 'Yes' if all 
// 'Verified' fields Case object are 'Verified' or 'Not Applicable' 
// ========================================================================================================
// EnforceRequestStatusRulesForInserts : New Cases must be saved with Request Status "Initial Request Received"
// ========================================================================================================
// EnforceRequestStatusRulesForUpdates : Displays error messages when following conditions are not met.
// 1) "Ready for Public Discussion" can only be selected after all of the Verified fields either
//    "Verified" or "Not Applicable" and all corresponding Root Cases have Request status 
//    of one of "Ready For Public Discussion", "On Hold", "Denied" 
// 2) "In Public Discussion" can only be selected after "Ready for Public Discussion" 
//     and all corresponding Root Cases have Request status 
//    of one of "In Public Discussion", "On Hold", "Denied" 
// 3) "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items
//    from Discussion" and all corresponding Root Cases have Request status 
//    of one of "Pending Approval", "On Hold", "Denied" 
// 4) "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected 
//    after "Pending Approval"
// 5) "Included, Pending EV" can only be selected after either "Pending Approval" or 
//    "Approved, Pending Inclusion and EV"
// 6) "On Hold" and "Denied" requires a short explanation in the public comments section
// 7) "Complete" can only be selected after "Approved, Pending Inclusion" or 
//    "Approved, Pending Inclusion and EV" or "Included, Pending EV"
// 8) A Case can have Request Status as 'Included, Pending EV' or 'Complete' 
//    only when all related root cases are 'On Hold' or 'Denied' or 
//   'Included, Pending EV' or 'Complete'
// 9) When Case.Request_Status is 'Complete' change Case.Status to 'Closed' when all related 
//     Root Cases have  Root_Cases.Request_Status = 'Included, Pending EV' or 
//     'Denied' or 'Complete'
// 10) When Case.Request Status is 'On Hold' set Case.Status to 'On Hold'
// ========================================================================================================

public class CaseTriggerHelper {

 
 // this method is invoked whenever a new case is created
 // the requirement is to set the status on the related account as "Change Requested"
 public static void SetAccountStatusField(List<Case> caseSoLst) {

   // set which holds the IDs of the account whose status needs to be set as "Change Requested" 
   Set<Id> accountIdLst = New Set<Id>();
   
   // loop over all the cases which were inserted
   for(Case caseSo : caseSoLst)
    {
        // add the account Id to the list so that they could be queried in the next step (bulkified!)
        accountIdLst.add(caseSo.accountId);
    }
   
   // if there is atleast one account
   if(accountIdLst.size() > 0)
   {
    
     // list which holds all the accountSo
     List<Account> accountSoToBeUpdatedLst = New List<Account>();
    
     // query the accounts and iterate over the each accountSo
     for(Account accountSo : [select status__c from account where id in :accountIdLst])
     {
        // set the status and add the Sobject to the list
         if (accountSo.status__c != 'Not Yet Included') {
             accountSo.status__c = 'Change Requested';
         }
         accountSoToBeUpdatedLst.add(accountSo);
     }
     
     // if there is at least one account that need to be updated then execute the DML
     if(accountSoToBeUpdatedLst.size() > 0)
       {
         update accountSoToBeUpdatedLst;
       }
    
     }
     
    }
    
    public static void EnforceAccountRules (List<Case> caseSoLst,  Map<Id, Case> oldcaseSoLst) {
        
        // loop over all the cases which were updated
   		for(Case caseSO : caseSoLst)
   		{
           
         // Set oldcaseSo to trigger.old value        
         Case oldcaseSO = oldcaseSOLst.get(caseSo.Id); 
        
         // EnforeAccountRules : In edit mode - do not allow user to modify Account Name/Owner
       
          if (caseSO.AccountID != oldcaseSO.AccountID) {
                  caseSO.addError('Cannot make changes to the CA Owner Name');
             }
        }
    }   

    public static void SetAllFieldsVerifiedField (List<Case> caseSoLst) {
        
    // loop over all the cases which were updated
   	for(Case caseSo : caseSoLst)
   	{
            
         // Set 'All Fields Verified?' field to 'Yes' if all 'Verified' fields
         // in Root Case object are 'Verified' or 'Not Applicable'  
         
        caseSO.All_Fields_Verified__c = 'Yes'; // initialize
       
        if (caseSO.Company_Website_Verified__c != 'Verified' && 
              caseSO.Company_Website_Verified__c != 'Not Applicable' ) {
                  caseSO.All_Fields_Verified__c = 'No';}

        if (caseSO.Organizational_Type_Verified__c != 'Verified' && 
              caseSO.Organizational_Type_Verified__c != 'Not Applicable' ) {
                  caseSO.All_Fields_Verified__c = 'No';}

        if (caseSO.Organizational_Type_Others_Verified__c != 'Verified' && 
              caseSO.Organizational_Type_Others_Verified__c != 'Not Applicable' ) {
                  caseSO.All_Fields_Verified__c = 'No';}

        if (caseSO.Geographic_Focus_Verified__c != 'Verified' && 
              caseSO.Geographic_Focus_Verified__c != 'Not Applicable' ) {
                  caseSO.All_Fields_Verified__c = 'No';}

        if (caseSO.Primary_Market_Customer_Base_Verified__c != 'Verified' && 
              caseSO.Primary_Market_Customer_Base_Verified__c != 'Not Applicable' ) {
                  caseSO.All_Fields_Verified__c = 'No';}

        if (caseSO.Impact_to_Mozilla_Users_Verified__c != 'Verified' && 
              caseSO.Impact_to_Mozilla_Users_Verified__c != 'Not Applicable' ) {
                  caseSO.All_Fields_Verified__c = 'No';}

        if (caseSO.CA_s_Reponse_to_Recom_Prac_Verified__c != 'Verified' && 
              caseSO.CA_s_Reponse_to_Recom_Prac_Verified__c != 'Not Applicable' ) {
                  caseSO.All_Fields_Verified__c = 'No';}

        if (caseSO.CA_s_Response_to_Prob_Prac_Verified__c != 'Verified' && 
              caseSO.CA_s_Response_to_Prob_Prac_Verified__c != 'Not Applicable' ) {
                  caseSO.All_Fields_Verified__c = 'No';}           
            
        }      
    }
    
    public static void EnforceRequestStatusRulesForInserts (List<Case> caseSoLst)
    {
        // loop over all the cases which were inserted
   		for(Case caseSo : caseSoLst)
   		{
            if (!caseSO.Request_Status__c.equals('Initial Request Received')) {           
                  caseSO.addError('New Case must be saved with Request Status "Initial Request Received"');
            }          
        } 
    }

     public static void EnforceRequestStatusRulesForUpdates (List<Case> caseSoLst,  Map<Id, Case> oldcaseSoLst) {
 
        // loop over all the cases which were updated
   		for(Case caseSo : caseSoLst)
   		{
           
         // Set oldcaseSo to trigger.old value        
         Case oldcaseSo = oldcaseSOLst.get(caseSo.Id); 
         
 
             
         // Get Root Case info in a list        
        List<Root_Case__c> RootCaseLst = [select request_status__c from Root_Case__c where case_no__c = :caseSo.ID];
  
            
         // check for request_status field only if this field was modified
         if (!caseSO.Request_Status__c.equals(oldcaseSO.Request_Status__c))
         {
             
         // "Ready for Public Discussion" can only be selected after all of the Verified fields either 
         // "Verified" or "Not Applicable", and all corresponding Root Cases have Request status 
         // of one of "Ready For Public Discussion", "On Hold", "Denied" 
          
         if (caseSO.Request_Status__c.equals('Ready for Public Discussion')) 
         {
             if (caseSO.All_Fields_Verified__c.equals('No')) {
                  caseSO.addError('Request Status "Ready for Public Discussion" can only be selected after all of the Verified fields either "Verified" or "Not Applicable" ');
             }
             else {
                 
                // list which holds all the selected RootCaseSo
                List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
                for(Root_Case__c RootCaseSo : RootCaseLst)
                {
                    if (RootCaseSo.request_status__c != 'On Hold' && RootCaseSo.request_status__c != 'Denied' && RootCaseSo.request_status__c != 'Ready For Public Discussion' ) {
                    
                         RootcaseSoToBeCheckedLst.add(RootCaseSo);
                    }
                }
    
                // if there is at least one Root Case in the list then flag error
                if(RootCaseSoToBeCheckedLst.size() > 0)
                {       
                     caseSO.addError('Request Status "Ready for Public Discussion" can only be selected when all related Root Cases are "On Hold" or "Denied" or "Ready for Public Discussion"');
                }                
                 
             }
         }
         
          // "In Public Discussion" can only be selected after "Ready for Public Discussion"
          //  and all corresponding Root Cases have Request status of one of "Pending Approval", "On Hold", "Denied" 

         if (caseSO.Request_Status__c.equals('In Public Discussion')) {
             if (!oldcaseSO.Request_Status__c.equals('Ready for Public Discussion')) {
                  caseSO.addError('Request Status "In Public Discussion" can only be selected after "Ready for Public Discussion"');
             }
             else {
                 
                // list which holds all the selected RootCaseSo
                List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
                for(Root_Case__c RootCaseSo : RootCaseLst)
                {
                    if (RootCaseSo.request_status__c != 'On Hold' && RootCaseSo.request_status__c != 'Denied' && RootCaseSo.request_status__c != 'In Public Discussion' ) {
                    
                         RootcaseSoToBeCheckedLst.add(RootCaseSo);
                    }
                }
    
                // if there is at least one Root Case in the list then flag error
                if(RootCaseSoToBeCheckedLst.size() > 0)
                {       
                     caseSO.addError('Request Status "In Public Discussion" can only be selected when all related Root Cases are "On Hold" or "Denied" or "In Public Discussion"');
                }                
                 
             }
         }
         
         // "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items from Discussion" 
         // and all corresponding Root Cases have Request status of one of "Pending Approval", "On Hold", "Denied" 

         if (caseSO.Request_Status__c.equals('Pending Approval')) {
             if (!oldcaseSO.Request_Status__c.equals('In Public Discussion') && !oldcaseSO.Request_Status__c.equals('CA Action Items from Discussion')) {
                  caseSO.addError('Request Status "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items from Discussion"');
             }
             else {
                 
                // list which holds all the selected RootCaseSo
                List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
                for(Root_Case__c RootCaseSo : RootCaseLst)
                {
                    if (RootCaseSo.request_status__c != 'On Hold' && RootCaseSo.request_status__c != 'Denied' && RootCaseSo.request_status__c != 'Pending Approval' ) {
                    
                         RootcaseSoToBeCheckedLst.add(RootCaseSo);
                    }
                }
    
                // if there is at least one Root Case in the list then flag error
                if(RootCaseSoToBeCheckedLst.size() > 0)
                {       
                     caseSO.addError('Request Status "Pending Approval" can only be selected when all related Root Cases are "On Hold" or "Denied" or "Pending Approval"');
                }                
                 
             }
         }
         
         // "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected after "Pending Approval"

        if (caseSO.Request_Status__c.equals('Approved, Pending Inclusion') || caseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV')) {
             if (!oldcaseSO.Request_Status__c.equals('Pending Approval')) {
                  caseSO.addError('Request Status "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected after "Pending Approval"');
             }
             else {
                 
                // list which holds all the selected RootCaseSo
                List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
                for(Root_Case__c RootCaseSo : RootCaseLst)
                {
                    if (RootCaseSo.request_status__c != 'On Hold' && RootCaseSo.request_status__c != 'Denied' 
                        && RootCaseSo.request_status__c != 'Approved, Pending Inclusion' && RootCaseSo.request_status__c != 'Approved, Pending Inclusion and EV') {
                    
                         RootcaseSoToBeCheckedLst.add(RootCaseSo);
                    }
                }
    
                // if there is at least one Root Case in the list then flag error
                if(RootCaseSoToBeCheckedLst.size() > 0)
                {       
                     caseSO.addError('Request Status "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected when all related Root Cases are "On Hold" or "Denied" or "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV"');
                }                
                 
             }
         }
         
         // "Included, Pending EV" can only be selected after either "Pending Approval" or "Approved, Pending Inclusion and EV"

        if (caseSO.Request_Status__c.equals('Included, Pending EV')) {
             if (!oldcaseSO.Request_Status__c.equals('Pending Approval') && !oldcaseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV')) {
                  caseSO.addError('Request Status "Included, Pending EV" can only be selected after either "Pending Approval" or "Approved, Pending Inclusion and EV"');
             }
         }
         
 
         // "On Hold" and "Denied" requires a short explanation in the public comments section
         
         if (caseSO.Request_Status__c.equals('On Hold') || caseSO.Request_Status__c.equals('Denied')) {
             if ((caseSO.Comments__c == NULL) && (caseSO.Internal_Comments_on_Case__c == NULL)) {
                  caseSO.addError('Request Status "On Hold" and "Denied" requires a short explanation in the Internal/Public comments section');
             }
         }
           
         // "Complete" can only be selected after "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" or "Included, Pending EV"

         if (caseSO.Request_Status__c.equals('Complete')) {
             if (!oldcaseSO.Request_Status__c.equals('Approved, Pending Inclusion') && !oldcaseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV') && !oldcaseSO.Request_Status__c.equals('Included, Pending EV')) {
                  caseSO.addError('Request Status "Complete" can only be selected after "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" or "Included, Pending EV"');
             }
         }
        
          //  A Case can have Request Status as 'Included, Pending EV' or 'Complete' 
          //  only when all related root cases are 'On Hold' or 'Denied' or 
          //  'Included, Pending EV' or 'Complete'
            
         if (caseSO.Request_Status__c.equals('Included, Pending EV') || caseSO.Request_Status__c.equals('Complete')) {  
      
            // list which holds all the related RootCaseSo
            List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
            // query the Root Case and iterate over the each RootCaseSo
            for(Root_Case__c RootCaseSo : RootCaseLst) 
            {
                if (RootCaseSo.request_status__c != 'On Hold' && RootCaseSo.request_status__c != 'Denied' 
                    && RootCaseSo.request_status__c != 'Included, Pending EV' && RootCaseSo.request_status__c != 'Complete' ) {
                    
                     RootcaseSoToBeCheckedLst.add(RootCaseSo);
               }
            }
    
            // if there is at least one Root Case in the list then flag error
            
            if(RootCaseSoToBeCheckedLst.size() > 0)
            {       
                caseSO.addError('Request Status "Included, Pending EV" or "Complete" can only be selected when all related Root Cases are "On Hold" or "Denied" or "Included, Pending EV" or "Complete"');
            }
          }
         }
            
          // When Case.Request_Status is 'Complete', change Case.Status to 'Closed' when all related 
          // Root Cases have  Root_Cases.Request_Status = 'Denied' or 'Complete'
           
            if (caseSO.Request_Status__c.equals('Complete')) {  
      
            // list which holds all the related RootCaseSo
            List<Root_Case__c> RootCaseSoToBeCheckedLst = New List<Root_Case__c>();
      
            // query the Root Case and iterate over the each RootCaseSo
            for(Root_Case__c RootCaseSo : RootCaseLst) 
            {
                if (RootCaseSo.request_status__c != 'Denied' 
                    && RootCaseSo.request_status__c != 'Included, Pending EV' 
                    && RootCaseSo.request_status__c != 'Complete' ) 
                {
                    RootcaseSoToBeCheckedLst.add(RootCaseSo);
                }
            }
   
            if(RootCaseSoToBeCheckedLst.size() > 0) {
                
                caseSO.addError('Request Status "Complete" can only be selected when all related Root Cases are "Included, Pending EV" or "Denied" or "Complete"');
            }
            else {
                caseSO.Status = 'Closed';
            }
         }
          
          // When Request Status is 'On Hold' set Status to 'On Hold' 
          
          if (caseSO.Request_Status__c.equals('On Hold')) {
                 caseSO.Status = 'On Hold';              
            }
            else if (!caseSO.Request_Status__c.equals('Complete')) {
                caseSO.Status = 'Open';
            }
   
       }
    }
}