public class AllAccountHierarchyReportController{

 public List<Account> accountSoLst {get;set;}
 
 public List<Account> accountHierarchySoLst {get;set;}
 
 String CurrentDate = ' ';
 

 
 String accountNameStr,revocationStatusStr,StatusStr,recordTypeStr;
  // constructor method for standard controller
    public AllAccountHierarchyReportController() {   

    accountNameStr=   ApexPages.currentPage().getParameters().get('accountName');
    revocationStatusStr=   ApexPages.currentPage().getParameters().get('revocationStatus');
    statusStr=   ApexPages.currentPage().getParameters().get('status');
    recordTypeStr=   ApexPages.currentPage().getParameters().get('recordType');
            accountHierarchySoLst = New List<account>();    
    String queryStr = 'select name, type, record_type_name__c, parentid, Certificate_Issuer_Common_Name__c, Certificate_Issuer_Organization__c, Certificate_Subject_Common_Name__c, Certificate_Subject_Organization__c, SHA_1_Fingerprint__c,Valid_From_YYYY_MMM_DD__c, Valid_To_YYYY_MMM_DD__c, Signing_Key_Parameters__c, Signature_Algorithm__c,Certificate_Policy_CP__c, Certification_Practice_Statement_CPS__c, Standard_Audit__c, BR_Audit__c, Auditor__c,Standard_Audit_Statement_Dt__c From Account where lastmodifieddate!=null  ';                    
    
    String clause1,clause2,clause3,clause4;
    
    if(accountNameStr != null && accountNameStr.length() > 0 ) {
       queryStr = queryStr  + ' and name = :accountNameStr  ';
      }
    
    if(revocationStatusStr != null && revocationStatusStr.length() > 0 ) {
      queryStr = queryStr  + ' and Revocation_Status__c = :revocationStatusStr  ';
    }
    
    if(statusStr!= null && statusStr.length() > 0 ) {
      queryStr = queryStr  +' and status__c = :statusStr  ';
    }
    
    if(recordTypeStr!= null && recordTypeStr.length() > 0 ) {
      queryStr = queryStr  + ' and record_type_name__c = :recordTypeStr';
    }
    else
    {
    queryStr = queryStr  ;
    }
  
     system.debug('queryStr='+queryStr);
    
    accountSoLst= Database.query(queryStr);
    
    
    if(accountSoLst == null || accountSoLst.size() == 0 )                
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Account Not Found, AccountName='+accountNameStr + ', RevocationStatus='+revocationStatusStr+ ', Status='+statusStr + ', RecordType=' + recordTypeStr));
    }
    else
    {
    
     for(Account accountSo: accountSoLst)
     {
            
      if(accountso.record_type_name__c =='CA Owner')
      {       
        accountHierarchySoLst.add(accountSo);
        getChildAccounts(accountSo, accountSoLst);
      }
            
     }
    
    }
    
    }
    
    private void getChildAccounts(Account accountSo, List<account> accountSoLst)
    {
     
       for(Account childAccountSo : accountSoLst)
       {
       
         if(childAccountSo.parentId == accountSo.id)
         {
          accountHierarchySoLst.add(childAccountSo);
          getChildAccounts(childAccountSo, accountSoLst);
         }
        
       }
    
    
    }
    
       // Get current Datetime in long date format   

    public String getCurrentDate() {

      Datetime cDT = System.now();
      CurrentDate = cDT.format('MMMM d, yyyy');

      return CurrentDate;

   }
    
 }