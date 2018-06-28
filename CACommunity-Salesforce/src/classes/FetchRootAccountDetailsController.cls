// This controller populates null Case fields with Account (Root Certificate) data
// 
global with sharing class FetchRootAccountDetailsController{

   Root_Case__c rootCaseSo;
   List<Account> rootAccountSoLst;
   public  Boolean showGoBackButton {get;set;} 
    
   public FetchRootAccountDetailsController(ApexPages.StandardController stdController) {
                
         // get the record id on which the button was clicked
         this.rootCaseSo= (Root_Case__c)stdController.getRecord();
         
         rootCaseSo = [select name, case_no__c, Root_Certificate_Name_Existing__c, 
                              case_no__r.Link_to_Bugzilla_Bug__c,  
                              Root_Certificate_Name__c, O_From_Issuer_Field__c, OU_From_Issuer_Field__c, 
                              Root_Certificate_Download_URL__c, SHA_1_Fingerprint__c, SHA_256_Fingerprint__c,
                              valid_from__c, valid_to__c, Certificate_Signature_Algorithm__c, Signing_key_Parameters__c,
                              Test_Website_URL_SSL_or_Example_Cert__c, CRL_URL_s__c, OCSP_URL_s__c,
                              Trust_Bits__c, EV_Policy_OID_s__c, Root_Stores_Included_In__c, Mozilla_Applied_Constraints__c,
                              Standard_Audit__c, Standard_Audit_Type__c, Standard_Audit_Statement_Date__c,
                              BR_Audit__c, BR_Audit_Type__c, BR_Audit_Statement_Date__c,
                              EV_Audit__c, EV_Audit_Type__c, EV_Audit_Statement_Date__c,
                              Auditor_Name__c, Auditor_Website__c, Auditor_Qualifications__c,
                              Policy_Documentation__c, CA_Document_Repository__c, CP__c, CPS__c,
                              Publicly_Disclosed_and_Audited_subCAs__c, 
                              NSS_Release_When_First_Included__c, Firefox_Release_When_First_Included__c                             
                              from Root_Case__c where id = :rootCaseSo.id limit 1];
       
         showGoBackButton  = false;
       
         this.rootAccountSoLst =  [select id, type, Certificate_Issuer_Organization__c, Certificate_Issuer_Organizational_Unit__c,
                                   Approval_Bug__c, Root_Certificate_Download_URL__c, SHA_1_Fingerprint__c, SHA_256_Fingerprint__c,
                                   Valid_from_GMT__c, Valid_to_GMT__c, Signature_Algorithm__c, Signing_key_Parameters__c,
                                   URL_to_Test_Website_or_Example_Cert__c, CRL_URL_s__c, OCSP_URL_s__c,
                                   Trust_Bits__c, EV_Policy_OID_s__c, Root_Stores_Included_In__c, Mozilla_Applied_Constraints__c,
                                   Standard_Audit__c, Standard_Audit_Type__c, Standard_Audit_Statement_Date__c,
                                   BR_Audit__c, BR_Audit_Type__c, BR_Audit_Statement_Date__c,
                                   EV_Audit__c, EV_Audit_Type__c, EV_Audit_Statement_Date__c,
                                   Auditor__c,  Auditor_Website__c, Auditor_Qualifications__c,
                                   Policy_Documentation__c, CA_Document_Repository__c, Certificate_Policy_CP__c, 
                                   Certification_Practice_Statement_CPS__c, Publicly_Disclosed_and_Audited_subCAs__c,
                                   NSS_Release_When_First_Included__c, Firefox_Release_When_First_Included__c
                                   from Account where id = :rootCaseSo.Root_Certificate_Name_Existing__c] ;     
    }
    
    public PageReference  showErrorMessage() {
    
      PageReference rootCaseEditURL;
      rootCaseEditURL = new PageReference('/' +this.rootCaseSo.id);
      rootCaseEditURL.setRedirect(true);
        
      return rootCaseEditURL ;   
    }
    
    public PageReference fetchRootAccountDetailsOnRootCase(){
                         
    
      // if no account record is associated with the current record then 
      // show error message to the user
      if(rootAccountSOLst==null || rootAccountSoLst.size() ==0)
         {
          showGoBackButton = true;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'This case record is not associated with any Root Certificate'));
          return null;
         } 
     
     // set the fields on the case record with the values from the account record
     updateRootCaseFieldsWithRootAccountDetails();

     // set the return url to edit mode     
     PageReference  rootCaseEditURL= new PageReference('/' +this.rootCaseSo.id+'/e?retURL='+'/'+this.rootCaseSo.id);
     rootCaseEditURL.setRedirect(true);
     return rootCaseEditURL;
    
    }
    
    public void updateRootCaseFieldsWithRootAccountDetails(){

          // Do not update SHA_1_Fingerprint__c and Link_to_Bugzilla_Bug__c
                  
          if(rootCaseSo.O_From_Issuer_Field__c == Null) 
             rootCaseSo.O_From_Issuer_Field__c = rootAccountSoLst[0].Certificate_Issuer_Organization__c;        
          if(rootCaseSo.OU_From_Issuer_Field__c == Null) 
             rootCaseSo.OU_From_Issuer_Field__c = rootAccountSoLst[0].Certificate_Issuer_Organizational_Unit__c; 
          if(rootCaseSo.Root_Certificate_Download_URL__c == Null) 
             rootCaseSo.Root_Certificate_Download_URL__c = rootAccountSoLst[0].Root_Certificate_Download_URL__c;     
          if(rootCaseSo.SHA_256_Fingerprint__c == Null) 
             rootCaseSo.SHA_256_Fingerprint__c = rootAccountSoLst[0].SHA_256_Fingerprint__c;     
          if(rootCaseSo.valid_from__c== Null) 
             rootCaseSo.valid_from__c = rootAccountSoLst[0].valid_from_GMT__c; 
          if(rootCaseSo.valid_to__c== Null) 
             rootCaseSo.valid_to__c = rootAccountSoLst[0].valid_to_GMT__c;     
          if(rootCaseSo.Certificate_Signature_Algorithm__c== Null) 
             rootCaseSo.Certificate_Signature_Algorithm__c = rootAccountSoLst[0].Signature_Algorithm__c; 
          if(rootCaseSo.Signing_Key_Parameters__c== Null) 
             rootCaseSo.Signing_Key_Parameters__c = rootAccountSoLst[0].Signing_Key_Parameters__c;     
          if(rootCaseSo.Test_Website_URL_SSL_or_Example_Cert__c== Null) 
             rootCaseSo.Test_Website_URL_SSL_or_Example_Cert__c = rootAccountSoLst[0].URL_to_Test_Website_or_Example_Cert__c; 
          if(rootCaseSo.CRL_URL_s__c== Null) 
             rootCaseSo.CRL_URL_s__c = rootAccountSoLst[0].CRL_URL_s__c;     
          if(rootCaseSo.OCSP_URL_s__c== Null) 
             rootCaseSo.OCSP_URL_s__c = rootAccountSoLst[0].OCSP_URL_s__c; 
          if(rootCaseSo.Trust_Bits__c== Null) 
             rootCaseSo.Trust_Bits__c = rootAccountSoLst[0].Trust_Bits__c;     
          if(rootCaseSo.EV_Policy_OID_s__c== Null) 
             rootCaseSo.EV_Policy_OID_s__c = rootAccountSoLst[0].EV_Policy_OID_s__c; 
          if(rootCaseSo.Root_Stores_Included_In__c== Null) 
             rootCaseSo.Root_Stores_Included_In__c = rootAccountSoLst[0].Root_Stores_Included_In__c;     
          if(rootCaseSo.Mozilla_Applied_Constraints__c== Null) 
             rootCaseSo.Mozilla_Applied_Constraints__c = rootAccountSoLst[0].Mozilla_Applied_Constraints__c; 
          if(rootCaseSo.Standard_Audit__c== Null) 
             rootCaseSo.Standard_Audit__c = rootAccountSoLst[0].Standard_Audit__c;     
          if(rootCaseSo.Standard_Audit_Type__c== Null) 
             rootCaseSo.Standard_Audit_Type__c = rootAccountSoLst[0].Standard_Audit_Type__c; 
          if(rootCaseSo.Standard_Audit_Statement_Date__c== Null) 
             rootCaseSo.Standard_Audit_Statement_Date__c = rootAccountSoLst[0].Standard_Audit_Statement_Date__c;     
          if(rootCaseSo.BR_Audit__c== Null) 
             rootCaseSo.BR_Audit__c = rootAccountSoLst[0].BR_Audit__c; 
          if(rootCaseSo.BR_Audit_Type__c== Null) 
             rootCaseSo.BR_Audit_Type__c = rootAccountSoLst[0].BR_Audit_Type__c;     
          if(rootCaseSo.BR_Audit_Statement_Date__c== Null) 
             rootCaseSo.BR_Audit_Statement_Date__c = rootAccountSoLst[0].BR_Audit_Statement_Date__c; 
          if(rootCaseSo.EV_Audit__c == Null) 
             rootCaseSo.EV_Audit__c = rootAccountSoLst[0].EV_Audit__c;     
          if(rootCaseSo.EV_Audit_Type__c == Null) 
             rootCaseSo.EV_Audit_Type__c = rootAccountSoLst[0].EV_Audit_Type__c; 
          if(rootCaseSo.EV_Audit_Statement_Date__c== Null) 
             rootCaseSo.EV_Audit_Statement_Date__c = rootAccountSoLst[0].EV_Audit_Statement_Date__c;  
          if(rootCaseSo.Auditor_Name__c == Null) 
             rootCaseSo.Auditor_Name__c = rootAccountSoLst[0].Auditor__c; 
          if(rootCaseSo.Auditor_Website__c == Null) 
             rootCaseSo.Auditor_Website__c = rootAccountSoLst[0].Auditor_Website__c; 
          if(rootCaseSo.Auditor_Qualifications__c == Null) 
             rootCaseSo.Auditor_Qualifications__c = rootAccountSoLst[0].Auditor_Qualifications__c; 
          if(rootCaseSo.Policy_Documentation__c == Null) 
             rootCaseSo.Policy_Documentation__c = rootAccountSoLst[0].Policy_Documentation__c;  
          if(rootCaseSo.CA_Document_Repository__c == Null) 
             rootCaseSo.CA_Document_Repository__c = rootAccountSoLst[0].CA_Document_Repository__c; 
          if(rootCaseSo.CP__c == Null) 
             rootCaseSo.CP__c = rootAccountSoLst[0].Certificate_Policy_CP__c;  
          if(rootCaseSo.CPS__c == Null) 
             rootCaseSo.CPS__c = rootAccountSoLst[0].Certification_Practice_Statement_CPS__c; 
          if(rootCaseSo.Publicly_Disclosed_and_Audited_subCAs__c == Null) 
             rootCaseSo.Publicly_Disclosed_and_Audited_subCAs__c = rootAccountSoLst[0].Publicly_Disclosed_and_Audited_subCAs__c;  
          if(rootCaseSo.NSS_Release_When_First_Included__c == Null) 
             rootCaseSo.NSS_Release_When_First_Included__c = rootAccountSoLst[0].NSS_Release_When_First_Included__c; 
          if(rootCaseSo.Firefox_Release_When_First_Included__c == Null) 
             rootCaseSo.Firefox_Release_When_First_Included__c = rootAccountSoLst[0].Firefox_Release_When_First_Included__c;  

 
        update rootCaseSo;
    
    }

}