/**
This is the controller class for the MassUpdateAuditCPPSData VF page.
When the "Mass Update Audit/CP/CPS Data" button is clicked from any Root Certificate 
(Account record where Record Type = Root Certificate) or Intermediate certificate 
(Account record where Record Type = Intermediate Certificate), 
the user is redirected to  MassUpdateAuditCPPSData VF page. 

This controller iterates through all records related to the Parent Account and updates
the Audit, CP/CPS fields upon users response.
**/

global with sharing class MassUpdateAuditCPCPSDataController {

    public Account sourceAccountSo{get; set;}
    public Account targetAccountSo{get; set;}
    List<Account> lstSiblingAccounts;   
    public Integer recordIndex{get; set;}
    public Integer totaltargetAccountCount {get; set;}
    public Boolean showConfirmation{get; set;}
    public Boolean showMessage{get; set;}
    public Boolean hasError{get; set;}
    public Boolean isValidPortalUser{get; set;}
    public String title{get; set;}  
            
    Boolean updateBRAuditFields=FALSE;
    Boolean updateEVAuditFields=FALSE;
    
    static List<String> fields = new List<String>();
    static{
        fields.add('Audits_Same_as_Parent__c');
        fields.add('Standard_Audit__c');
        fields.add('Standard_Audit_Type__c');
        fields.add('Standard_Audit_Statement_Date__c');       
        fields.add('BR_Audit__c');
        fields.add('BR_Audit_Type__c');
        fields.add('BR_Audit_Statement_Date__c');
        fields.add('EV_Audit__c');
        fields.add('EV_Audit_Type__c');
        fields.add('EV_Audit_Statement_Date__c');
        fields.add('Auditor__c');
        fields.add('Auditor_Website__c');
        fields.add('Auditor_Qualifications__c');
        fields.add('Management_Assertions_By__c');
        fields.add('CP_CPS_Same_as_Parent__c');
        fields.add('Policy_Documentation__c');
        fields.add('CA_Document_Repository__c');
        fields.add('Certificate_Policy_CP__c');
        fields.add('Certification_Practice_Statement_CPS__c');
    }
    // constructor method for standard controller
    public MassUpdateAuditCPCPSDataController(ApexPages.StandardController stdController) {
                
         // get the record id on which the button was clicked
         this.sourceAccountSo = (Account)stdController.getRecord();      
         lstSiblingAccounts = new List<Account>();
         this.recordIndex = 0;
         this.showConfirmation = true;
         this.showMessage = false;
         this.hasError = false;
         this.title = 'No more certificates to update';
         this.isValidPortalUser = true;
         
         try{
        
         this.sourceAccountSo = [select Id, Name, ParentId, Parent.Name, Type, EV_Policy_OID_s__c, Trust_bits__c,
                                   Audits_Same_as_Parent__c, Standard_Audit__c, 
                                   Standard_Audit_Type__c, Standard_Audit_Statement_Date__c,
                                   BR_Audit__c, BR_Audit_Type__c, BR_Audit_Statement_Date__c,
                                   EV_Audit__c, EV_Audit_Type__c, EV_Audit_Statement_Date__c,
                                   Auditor__c, Auditor_Website__c, Auditor_Qualifications__c, Management_Assertions_By__c,
                                   CP_CPS_Same_as_Parent__c, Policy_Documentation__c, CA_Document_Repository__c,
                                   Certificate_Policy_CP__c, Certification_Practice_Statement_CPS__c,
                                   Status__c from Account 
                                   where id = :this.sourceAccountSo.id limit 1];        
        
        
        if(this.sourceAccountSo.Status__c == 'Removed'){
            this.title = 'Source Certificate has been removed. You cannot run mass update.';
            this.showMessage = true;
            this.hasError = true;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This certificate had been removed. You cannot run mass update.'));
        }
          
          for(Account targertAcc : [select Id, ParentId, Name, Type, EV_Policy_OID_s__c, Trust_bits__c,
                                    Audits_Same_as_Parent__c, Standard_Audit__c, 
                                    Standard_Audit_Type__c, Standard_Audit_Statement_Date__c, BR_Audit__c, 
                                    BR_Audit_Type__c, BR_Audit_Statement_Date__c, EV_Audit__c, EV_Audit_Type__c,
                                    EV_Audit_Statement_Date__c, Auditor__c, Auditor_Website__c, Auditor_Qualifications__c, Management_Assertions_By__c,
                                    CP_CPS_Same_as_Parent__c, Policy_Documentation__c, CA_Document_Repository__c,
                                    Certificate_Policy_CP__c, Certification_Practice_Statement_CPS__c, Status__c
                                    from Account
                                    where ParentId = :sourceAccountSo.ParentId AND Id != :sourceAccountSo.Id]){
              if(isDiffAccount(sourceAccountSo, targertAcc)){
                  continue;
              }
              
              lstSiblingAccounts.add(targertAcc);
          }
                            
         }catch(Exception exp){
             this.hasError = true;
             this.showMessage = true;
             this.title = 'Unexpected Error Occurred, Please contact your administrator.';
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected Error Occurred, Please contact your administrator.'));
         }                     
                              
        if(lstSiblingAccounts != null && lstSiblingAccounts.size() > 0){
            this.totaltargetAccountCount = lstSiblingAccounts.size();
            this.targetAccountSo = lstSiblingAccounts[recordIndex];
            // recordIndex++; commented by Poonam
        }else{
            this.hasError = true;
            this.targetAccountSo = new Account();
            this.showMessage = true;
            this.title = 'No certs to update.';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ''));
        }  
    }

    
    public void checkPortalUserValidation(){
        
        CreateIntermediateCertController objToCheckUserValidation = new CreateIntermediateCertController(new ApexPages.standardController(this.sourceAccountSo));
        if(!objToCheckUserValidation.isValidPortalUser()){
            this.hasError = true;
            this.isValidPortalUser = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Root Cert or Intermediate Cert owned by ' + objToCheckUserValidation.userAccountName));    
        }
        
    }
    
    private Boolean isDiffAccount(sObject source, sObject target){
        for(String fieldApi : fields){
            // System.debug('source: '+source.get(fieldApi)+' --> target: '+target.get(fieldApi));
            if(source.get(fieldApi) != target.get(fieldApi)){
                return false;
            }
        }
        
        return true;
    }
    
    public pagereference redirectToAccount(){
        return new PageReference('/'+this.sourceAccountSo.Id);
    }
    
    
   // update the parent account and redirect to same page showing that the record got updated successfully
   public void syncAccount() {
         
         this.showConfirmation = false;
         
         this.targetAccountSo.Audits_Same_as_Parent__c                = this.sourceAccountSo.Audits_Same_as_Parent__c;
         this.targetAccountSo.Standard_Audit__c                       = this.sourceAccountSo.Standard_Audit__c;
         this.targetAccountSo.Standard_Audit_Type__c                  = this.sourceAccountSo.Standard_Audit_Type__c;   
         this.targetAccountSo.Standard_Audit_Statement_Date__c        = this.sourceAccountSo.Standard_Audit_Statement_Date__c;
         
         // If the (target) root cert has "Trust Bits" field does not have "Websites", then don't copy the BR Audit info    
      
         updateBRAuditFields = (this.targetAccountSo.type == 'Intermediate Certificate' ||
                                (this.targetAccountSo.type == 'Root' && 
                                this.targetAccountSo.trust_bits__c != null &&
                                this.targetAccountSo.trust_bits__c.length()>0 &&
                                this.targetAccountSo.trust_bits__c.contains('Websites'))) ? true : false;                        
               
         if (updateBRAuditFields) {
         this.targetAccountSo.BR_Audit__c                             = this.sourceAccountSo.BR_Audit__c;
         this.targetAccountSo.BR_Audit_Type__c                        = this.sourceAccountSo.BR_Audit_Type__c;   
         this.targetAccountSo.BR_Audit_Statement_Date__c              = this.sourceAccountSo.BR_Audit_Statement_Date__c;
         }                                     
         
         // If the (target) root cert has "EV Policy OID(s)" field "Not EV", then don't copy the EV audit info.
         
         updateEVAuditFields = (this.targetAccountSo.type == 'Intermediate Certificate' || 
                                (this.targetAccountSo.type == 'Root' && 
                                this.targetAccountSo.EV_Policy_OID_s__c != null &&
                                this.targetAccountSo.EV_Policy_OID_s__c != 'Not EV')) ? true : false;
         
         if (updateEVAuditFields) {
             this.targetAccountSo.EV_Audit__c                         = this.sourceAccountSo.EV_Audit__c;
             this.targetAccountSo.EV_Audit_Type__c                    = this.sourceAccountSo.EV_Audit_Type__c;   
             this.targetAccountSo.EV_Audit_Statement_Date__c          = this.sourceAccountSo.EV_Audit_Statement_Date__c;
         }
        
         // System.debug('DEBUGSOURCE: '+sourceAccountSo);
         // System.debug('DEBUGSOURCE: '+targetAccountSo);
                 
         this.targetAccountSo.Auditor__c                              = this.sourceAccountSo.Auditor__c;
         this.targetAccountSo.Auditor_Website__c                      = this.sourceAccountSo.Auditor_Website__c;
         this.targetAccountSo.Auditor_Qualifications__c               = this.sourceAccountSo.Auditor_Qualifications__c; 
         this.targetAccountSo.Management_Assertions_By__c             = this.sourceAccountSo.Management_Assertions_By__c;  
         this.targetAccountSo.CP_CPS_Same_as_Parent__c                = this.sourceAccountSo.CP_CPS_Same_as_Parent__c;
         this.targetAccountSo.Policy_Documentation__c                 = this.sourceAccountSo.Policy_Documentation__c;
         this.targetAccountSo.CA_Document_Repository__c               = this.sourceAccountSo.CA_Document_Repository__c;
         this.targetAccountSo.Certificate_Policy_CP__c                = this.sourceAccountSo.Certificate_Policy_CP__c;
         this.targetAccountSo.Certification_Practice_Statement_CPS__c = this.sourceAccountSo.Certification_Practice_Statement_CPS__c;
        
        try{
            update targetAccountSo;
        }catch(Exception exp){
            this.hasError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Occurred while updating the account.'));
        }
    }
    
    
    public void redirectToNextAccount(){
        skipAccount();
        this.showConfirmation = true;
    }
    
    public PageReference redirectTosourceAccount(){
        return new PageReference('/'+this.sourceAccountSo.Id);
    }
    
    public void skipAccount(){
        
        recordIndex = recordIndex + 1;
        // system.debug('record Index: '+recordIndex+' -> size: '+this.lstSiblingAccounts.size());
        
        if(recordIndex < this.lstSiblingAccounts.size()){ 
             this.targetAccountSo = this.lstSiblingAccounts[recordIndex];
        }
        else{
            this.showMessage = true;
            this.recordIndex = this.lstSiblingAccounts.size();
        }  
        
    }
}