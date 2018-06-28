// ========================================================================================================
// RootCaseTriggerHelper: Trigger for the RootCase object which handles all the events and
// based on the event delegates the task to the corresponding trigger handler method in 
// the RootCaseTriggerHelper class.
// ========================================================================================================
// SetAccountStatusField :  This method is invoked whenever a new RootCase is created
// the requirement is to set the status on the related account as "Change Requested" when 
// Root Certificate Name and SHA1 Fingerprint matches the record in Account object where the Account Type is 'Root'
// ========================================================================================================
// SetAllFieldsVerifiedField: Following updates and checks are performed in this trigger when 
// a Root Case record is inserted or updated. Set 'All Fields Verified?' field to 'Yes' if all 
// 'Verified' fields RootCase object are 'Verified' or 'Not Applicable' 
// ========================================================================================================
// SetBlankAuditFieldsToNONE: Set audit fields to NONE!
// If trust bits includes 'Websites' and BR Audit is blank, set BR Audit to 'NONE!'
// If trust bits includes 'Websites'  and EV Policy OID(s) not blank and EV Policy OID(s) not 'Not EV' and
// EV Audit blank then set EV Audit to 'NONE!' 
// ========================================================================================================
// EnforceRequestStatusRulesForInserts : New Root Cases must be saved with Request Status "Initial Request Received"
// ========================================================================================================
// EnforceRequestStatusRulesForUpdates : Displays error messages when following conditions are not met.
// 1) "Ready for Public Discussion" can only be selected after all of the Verified fields either
//    "Verified" or "Not Applicable" 
// 2) "In Public Discussion" can only be selected after "Ready for Public Discussion"
// 3) "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items
//    from Discussion"
// 4) "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected 
//    after "Pending Approval"
// 5) "Included, Pending EV" can only be selected after either "Pending Approval" or 
//    "Approved, Pending Inclusion and EV"
// 6) "On Hold" and "Denied" requires a short explanation in the public comments section
// 7) "Complete" can only be selected after "Approved, Pending Inclusion" or 
//    "Approved, Pending Inclusion and EV" or "Included, Pending EV"
// 8) Request Status cannot be "Complete" or Included, Pending EV” if 'NSS Release When First Included'
//    and 'Firefox Release When First Included' fields are blank.
// ========================================================================================================

public class RootCaseTriggerHelper { 
    
    
   // This method is invoked whenever a new RootCase is created
   // the requirement is to set the status on the related account as "Change Requested" when 
   // Root Certificate Name and SHA1 Fingerprint matches
    
   public static void SetAccountStatusField(List<Root_Case__c> rootCaseSoLst) {

      // list to hold the accountIds
      List<Id> accountIdLst = New List<Id>();

      for (Root_Case__c rootCaseSo :rootCaseSoLst) 
      {	
         // add the account id to the list 
         // we will use this list to fetch all the accounts
         
         // for later enhancements use accountIdLst.add(rootCaseSo.Root_Certificate_Name_Existing__c) 
         // when this 'Existing fields are populated by user
         
         accountIdLst.add(rootCaseSo.Root_Certificate_Name_Existing__c);
      }

     // fetch all the accounts into a map where the key is the "parent" accountId and the value is accountSo
     Map<Id,Account> accountSoMap = New Map<Id,Account>([select SHA_1_Fingerprint__c, status__c 
                                                         from Account where id in :accountIdLst]);

     // if there are more than one records
     if(accountSoMap!=null && accountSoMap.size() > 0)
     {
         Account tempAccountSo;
         List<Account> toBeUpdatedAccountsLst = New List<Account>();
  
         // loop over each root case
         for (Root_Case__c rootCaseSo :rootCaseSoLst) 
         {
	         // fetch the corresponding account from the map that we prepared earlier.
	         // Send in the accountId that we have on the rootCase as the key and get the 
	         // corresponding accountSo
             tempAccountSo =  accountSoMap.get(rootCaseSo.Root_Certificate_Name_Existing__c);
	   
	         // if an accountSo is returned from the Map and if the SHA of the current 
	         // rootCase matches the SHA of that account then update the account status
	         if(tempAccountSo!=null && tempAccountSo.SHA_1_Fingerprint__c == rootCaseSo.SHA_1_Fingerprint__c)
	         {
	             tempAccountSo.Status__c = 'Change Requested';
		 
         		 // this account will need to be updated and hence we add it to another list
		         // which would hold all the accountSos that we would be updating
		         toBeUpdatedAccountsLst.add(tempAccountSo);
	         }
       
             // system.debug('account.id'+owneraccountSo.id);
             // system.debug('account.name'+owneraccountSo.name);
             // system.debug('account.SHA_1_Fingerprint__c'+owneraccountSo.SHA_1_Fingerprint__c);
   
          }
   
        // if there are more than 1 records in this list then execute the DML
       if(toBeUpdatedAccountsLst.size() > 0)
       {
           update toBeUpdatedAccountsLst;
       }
 }
 
 }    

   public static void SetAllFieldsVerifiedField (List<Root_Case__c> RootCaseSoLst) {
        
    // loop over all the RootCases which were updated
    for(Root_Case__c RootCaseSo : RootCaseSoLst)
    {
            
         // Set 'All Fields Verified?' field to 'Yes' if all 'Verified' fields
         // in Root RootCase object are 'Verified' or 'Not Applicable'  
         
          RootCaseSO.All_Fields_Verified__c = 'Yes'; // initialize

               
          if (RootCaseSO.O_From_Issuer_Field_Verified__c != 'Verified' && 
              RootCaseSO.O_From_Issuer_Field_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
          if (RootCaseSO.OU_From_Issuer_Field_Verified__c != 'Verified' && 
              RootCaseSO.OU_From_Issuer_Field_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Certificate_Summary_Verified__c != 'Verified' && 
             RootCaseSO.Certificate_Summary_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Root_Certificate_Download_URL_Verified__c != 'Verified' && 
             RootCaseSO.Root_Certificate_Download_URL_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.SHA_1_Fingerprint_Verified__c != 'Verified' && 
             RootCaseSO.SHA_1_Fingerprint_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.SHA_256_Fingerprint_Verified__c != 'Verified' && 
             RootCaseSO.SHA_256_Fingerprint_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Valid_From_Verified__c != 'Verified' && 
              RootCaseSO.Valid_From_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Valid_To_Verified__c != 'Verified' && 
             RootCaseSO.Valid_To_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Certificate_Version_Verified__c != 'Verified' && 
             RootCaseSO.Certificate_Version_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Cert_Signature_Algorithm_Verified__c != 'Verified' && 
             RootCaseSO.Cert_Signature_Algorithm_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Signing_Key_Parameters_Verified__c != 'Verified' && 
             RootCaseSO.Signing_Key_Parameters_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.TestWebsiteURLSSLorExCert_Verified__c != 'Verified' && 
             RootCaseSO.TestWebsiteURLSSLorExCert_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}        
         if (RootCaseSO.CRL_URL_Verified__c != 'Verified' && 
             RootCaseSO.CRL_URL_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.OCSP_URL_Verified__c != 'Verified' && 
             RootCaseSO.OCSP_URL_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Revocation_Tested_Verified__c != 'Verified' && 
             RootCaseSO.Revocation_Tested_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}                      
         if (RootCaseSO.Trust_Bits_Verified__c != 'Verified' && 
             RootCaseSO.Trust_Bits_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.SSL_Validation_Type_Verified__c != 'Verified' && 
             RootCaseSO.SSL_Validation_Type_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_Policy_OID_s_Verified__c != 'Verified' && 
             RootCaseSO.EV_Policy_OID_s_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_Tested_Verified__c != 'Verified' && 
             RootCaseSO.EV_Tested_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Root_Stores_Included_In_Verified__c != 'Verified' && 
             RootCaseSO.Root_Stores_Included_In_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Mozilla_Applied_Constraints_Verified__c != 'Verified' && 
             RootCaseSO.Mozilla_Applied_Constraints_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.CA_Hierarchy_Verified__c != 'Verified' && 
             RootCaseSO.CA_Hierarchy_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Externally_Operated_SubCAs_Verified__c != 'Verified' && 
             RootCaseSO.Externally_Operated_SubCAs_Verified__c!= 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Cross_Signing_Verified__c != 'Verified' && 
             RootCaseSO.Cross_Signing_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Tech_Cons_on_3rd_party_Iss_Verified__c != 'Verified' && 
             RootCaseSO.Tech_Cons_on_3rd_party_Iss_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Policy_Documentation_Verified__c != 'Verified' && 
             RootCaseSO.Policy_Documentation_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.CA_Document_Repository_Verified__c != 'Verified' && 
             RootCaseSO.CA_Document_Repository_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.CP_Verified__c != 'Verified' && 
             RootCaseSO.CP_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.CPS_Verified__c != 'Verified' && 
              RootCaseSO.CPS_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Other_Relevant_Documents_Verified__c != 'Verified' && 
             RootCaseSO.Other_Relevant_Documents_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Auditor_Name_Verified__c != 'Verified' && 
             RootCaseSO.Auditor_Name_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Auditor_Website_Verified__c != 'Verified' && 
             RootCaseSO.Auditor_Website_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Auditor_Qualifications_Verified__c != 'Verified' && 
             RootCaseSO.Auditor_Qualifications_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Standard_Audit_Verified__c != 'Verified' && 
             RootCaseSO.Standard_Audit_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Standard_Audit_Type_Verified__c != 'Verified' && 
             RootCaseSO.Standard_Audit_Type_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Standard_Audit_Statement_Dt_Verified__c != 'Verified' && 
             RootCaseSO.Standard_Audit_Statement_Dt_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.BR_Audit_Verified__c != 'Verified' && 
             RootCaseSO.BR_Audit_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.BR_Audit_Type_Verified__c != 'Verified' && 
             RootCaseSO.BR_Audit_Type_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.BR_Audit_Statement_Date_Verified__c != 'Verified' && 
             RootCaseSO.BR_Audit_Statement_Date_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}       
         if (RootCaseSO.EV_Audit_Verified__c != 'Verified' && 
             RootCaseSO.EV_Audit_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_Audit_Type_Verified__c != 'Verified' && 
             RootCaseSO.EV_Audit_Type_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_Audit_Statement_Date_Verified__c != 'Verified' && 
             RootCaseSO.EV_Audit_Statement_Date_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.BR_Commitment_to_Comply_Verified__c != 'Verified' && 
             RootCaseSO.BR_Commitment_to_Comply_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.SSL_Verification_Procedures_Verified__c != 'Verified' && 
             RootCaseSO.SSL_Verification_Procedures_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.EV_SSL_Verification_Proc_Verified__c != 'Verified' && 
             RootCaseSO.EV_SSL_Verification_Proc_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Org_Verification_Procedure_Verified__c != 'Verified' && 
             RootCaseSO.Org_Verification_Procedure_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Email_Addr_Verification_Proc_Verified__c != 'Verified' && 
             RootCaseSO.Email_Addr_Verification_Proc_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Code_Signing_Subs_Verif_Proc_Verified__c != 'Verified' && 
             RootCaseSO.Code_Signing_Subs_Verif_Proc_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Multi_Factor_Authentication_Verified__c != 'Verified' && 
             RootCaseSO.Multi_Factor_Authentication_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Network_Security_Verified__c != 'Verified' && 
             RootCaseSO.Network_Security_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';}
         if (RootCaseSO.Publ_Discl_Audited_subCAs_Verified__c != 'Verified' && 
             RootCaseSO.Publ_Discl_Audited_subCAs_Verified__c != 'Not Applicable' ) {
                  RootCaseSO.All_Fields_Verified__c = 'No';} 
            
        }      
    }
    
    public static void SetBlankAuditFieldsToNONE (List<Root_Case__c> RootCaseSoLst)
    {             
       // loop over all the RootCases which were inserted
        for(Root_Case__c RootCaseSo : RootCaseSoLst)
        {
            // If trust bits includes 'Websites' and BR Audit is blank, set BR Audit to 'NONE!'
            if (RootCaseSO.trust_bits__c != null && RootCaseSO.trust_bits__c.contains('Websites') && RootCaseSO.BR_Audit__c == null) {           
                  RootCaseSO.BR_Audit__c = 'NONE!';
            } 
            // If trust bits includes 'Websites' and EV Policy OID(s) not blank and EV Policy OID(s) not 'Not EV' and
            // EV Audit blank then set EV Audit to 'NONE!'
            if (RootCaseSO.trust_bits__c != null && RootCaseSO.trust_bits__c.contains('Websites') 
                && RootCaseSO.EV_Policy_OID_s__c != null && RootCaseSO.EV_Policy_OID_s__c != 'Not EV' 
                && RootCaseSO.EV_Audit__c == null) {           
                  RootCaseSO.EV_Audit__c = 'NONE!';
            } 
        } 

    }
    public static void EnforceRequestStatusRulesForInserts (List<Root_Case__c> RootCaseSoLst)
    {
        // loop over all the RootCases which were inserted
        for(Root_Case__c RootCaseSo : RootCaseSoLst)
        {
            if (!RootCaseSO.Request_Status__c.equals('Initial Request Received')) {           
                  RootCaseSO.addError('New Root Case must be saved with Request Status "Initial Request Received"');
            }          
        } 
    }

     public static void EnforceRequestStatusRulesForUpdates (List<Root_Case__c> RootCaseSoLst, 
                                                             Map<Id, Root_Case__c> oldRootCaseSoLst) {
 
        // loop over all the RootCases which were updated
       for(Root_Case__c RootCaseSo : RootCaseSoLst)
       {
           
         // Set oldRootCaseSo to triggeRootCaseSO.old value
         
         Root_Case__c oldRootCaseSo = oldRootCaseSOLst.get(RootCaseSo.Id); 
           
        // check for request_status field only if this field was modified
           
         if (!RootCaseSO.Request_Status__c.equals(oldRootCaseSO.Request_Status__c)) {
         
         // "Ready for Public Discussion" can only be selected after all of the Verified fields either 
         // "Verified" or "Not Applicable", and all corresponding Root RootCases have Request status 
         // of one of "Ready For Public Discussion", "On Hold", "Denied" 
          
         if (RootCaseSO.Request_Status__c.equals('Ready for Public Discussion')) {
             if (RootCaseSO.All_Fields_Verified__c.equals('No')) {
                  RootCaseSO.addError('Request Status "Ready for Public Discussion" can only be selected after all of the Verified fields either "Verified" or "Not Applicable" ');
             }
         }
         
          // "In Public Discussion" can only be selected after "Ready for Public Discussion"

         if (RootCaseSO.Request_Status__c.equals('In Public Discussion')) {
             if (!oldRootCaseSO.Request_Status__c.equals('Ready for Public Discussion')) {
                  RootCaseSO.addError('Request Status "In Public Discussion" can only be selected after "Ready for Public Discussion"');
             }
         }
         
         // "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items from Discussion"

         if (RootCaseSO.Request_Status__c.equals('Pending Approval')) {
             if (!oldRootCaseSO.Request_Status__c.equals('In Public Discussion') && !oldRootCaseSO.Request_Status__c.equals('CA Action Items from Discussion')) {
                  RootCaseSO.addError('Request Status "Pending Approval" can only be selected after "In Public Discussion" or "CA Action Items from Discussion"');
             }
         }
         
         // "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected after "Pending Approval"

        if (RootCaseSO.Request_Status__c.equals('Approved, Pending Inclusion') || RootCaseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV')) {
             if (!oldRootCaseSO.Request_Status__c.equals('Pending Approval')) {
                  RootCaseSO.addError('Request Status "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" can only be selected after "Pending Approval"');
             }
         }
         
         // "Included, Pending EV" can only be selected after either "Pending Approval" or "Approved, Pending Inclusion and EV"

        if (RootCaseSO.Request_Status__c.equals('Included, Pending EV')) {
             if (!oldRootCaseSO.Request_Status__c.equals('Pending Approval') && !oldRootCaseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV')) {
                  RootCaseSO.addError('Request Status "Included, Pending EV" can only be selected after either "Pending Approval" or "Approved, Pending Inclusion and EV"');
             }
         }
         
 
         // "On Hold" and "Denied" requires a short explanation in the public comments section
         
         if (RootCaseSO.Request_Status__c.equals('On Hold') || RootCaseSO.Request_Status__c.equals('Denied')) {
             if ((RootCaseSO.Comments__c == NULL) && (RootCaseSO.Comments_by_Mozilla_on_Root_Case__c == NULL)) {
                  RootCaseSO.addError('Request Status "On Hold" and "Denied" requires a short explanation in the Internal/Public comments section');
             }
         }
           
         // "Complete" can only be selected after "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" or "Included, Pending EV"

         if (RootCaseSO.Request_Status__c.equals('Complete')) {
             if (!oldRootCaseSO.Request_Status__c.equals('Approved, Pending Inclusion') && !oldRootCaseSO.Request_Status__c.equals('Approved, Pending Inclusion and EV') && !oldRootCaseSO.Request_Status__c.equals('Included, Pending EV')) {
                  RootCaseSO.addError('Request Status "Complete" can only be selected after "Approved, Pending Inclusion" or "Approved, Pending Inclusion and EV" or "Included, Pending EV"');
             }
          }
        }     
                                                                 
       // Request Status cannot be "Complete" or Included, Pending EV” if 'NSS Release When First Included'
       // and 'Firefox Release When First Included' fields are blank.
       if (RootCaseSO.Request_Status__c.equals('Complete') || RootCaseSO.Request_Status__c.equals('Included, Pending EV')) {
         if (RootCaseSO.NSS_Release_When_First_Included__c == Null) {
              RootCaseSO.addError('Request Status "Complete" or "Included, Pending EV" can only be selected after filling in "NSS Release When First Included"');
         }
         if (RootCaseSO.Firefox_Release_When_First_Included__c == Null) {
              RootCaseSO.addError('Request Status "Complete" or "Included, Pending EV" can only be selected after filling in "Firefox Release When First Included"');
         }
       }
     }
   }
}