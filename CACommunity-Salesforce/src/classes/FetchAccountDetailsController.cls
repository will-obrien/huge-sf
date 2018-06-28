// This controller populates null Case fields with Account (CA Owner) data
// 
global with sharing class FetchAccountDetailsController{

   Case caseSo;
   List<Account> accountSoLst;
   public  Boolean showGoBackButton {get;set;} 
    
   public FetchAccountDetailsController(ApexPages.StandardController stdController) {
                
         // get the record id on which the button was clicked
         this.caseSo= (Case)stdController.getRecord();
         
         caseSO = [select id, accountid, CA_Email_Alias_1__c, CA_Email_Alias_2__c,
                          Link_to_Bugzilla_Bug__c , Company_Website__c, Organizational_Type__c, 
                          Primary_Market_Customer_Base__c, Geographic_Focus__c, Status
                   from case where id = :caseSO.id limit 1];
       
         showGoBackButton  = false;
       
         this.accountSoLst =  [select id, CA_Email_Alias_1__c, CA_Email_Alias_2__c,
                                      Approval_Bug__c, Company_Website__c, Organizational_Type__c, 
                                      Primary_Market_Customer_Base__c, Geographic_Focus__c, Status__c
                               from Account where id = :caseSo.accountId] ;     
    }
    
    public PageReference  showErrorMessage() {
    
      PageReference caseEditURL;
      caseEditURL = new PageReference('/' +this.caseSo.id);
      caseEditURL.setRedirect(true);
        
      return caseEditURL ;   
    }
    
    public PageReference fetchAccountDetailsOnCase(){
    
      // if no account record is associated with the current record then 
      // show error message to the user
      if(accountSOLst==null || accountSoLst.size() ==0)
         {
          showGoBackButton = true;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'This case record is not associated with any CA Owner'));
          return null;
         } 
     
     // set the fields on the case record with the values from the account record
     updateCaseFieldsWithAccountDetails();

     // set the return url to edit mode     
     PageReference  caseEditURL= new PageReference('/' +this.caseSo.id+'/e?retURL='+'/'+this.caseSO.id);
     caseEditURL.setRedirect(true);
     return caseEditURL;
    
    }
    
    public void updateCaseFieldsWithAccountDetails(){
        
        if(caseSO.CA_Email_Alias_1__c == Null) 
           caseSo.CA_Email_Alias_1__c = accountSoLst[0].CA_Email_Alias_1__c;
        if(caseSO.CA_Email_Alias_2__c == Null)
           caseSo.CA_Email_Alias_2__c = accountSoLst[0].CA_Email_Alias_2__c;
        // if(caseSO.Link_to_Bugzilla_Bug__c == Null)
        //    caseSo.Link_to_Bugzilla_Bug__c = accountSoLst[0].Approval_Bug__c;
        if(caseSO.Company_Website__c == Null)
           caseSo.Company_Website__c = accountSoLst[0].Company_Website__c;
        if(caseSO.Organizational_Type__c == Null)
           caseSo.Organizational_Type__c = accountSoLst[0].Organizational_Type__c;
        if(caseSO.Geographic_Focus__c == Null)
           caseSo.Geographic_Focus__c = accountSoLst[0].Geographic_Focus__c;
        if(caseSO.Primary_Market_Customer_Base__c == Null)
           caseSo.Primary_Market_Customer_Base__c = accountSoLst[0].Primary_Market_Customer_Base__c;
       
        update caseSo;
    
    }

}