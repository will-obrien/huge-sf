/**
  Controller for the PublicIntermediateCerts VF Page
  Shows Intermediate Certs (Non-revoked) in hierarchy
*/
public class PublicIntermediateCertsController{

 public List<Account> allAccountSoLst {get;set;}
 public List<Account> revokedAccountSoLst {get;set;}
 
 public List<Account> accountHierarchySoLst {get;set;}
  public List<Account> accountHierarchySoLst2 {get;set;}
 
 String CurrentDate = ' ';
 
 
    public PublicIntermediateCertsController() {   
    
     // initialize all lists    
     accountHierarchySoLst = New List<account>();   
     allAccountSoLst = New List<account>();   
     revokedAccountSoLst = New List<account>();   
    
    
    String revocationStatus = 'Not Revoked';
    String recordTypeName = 'Intermediate Certificate';

    // query to get intermediate certs
    String queryStr = 'select name, type, record_type_name__c,CA_Owner_ID__c, parentid, Certificate_Issuer_Common_Name__c, Certificate_Issuer_Organization__c, Certificate_Subject_Common_Name__c, Certificate_Subject_Organization__c, SHA_1_Fingerprint__c,Valid_From_YYYY_MMM_DD__c, Valid_To_YYYY_MMM_DD__c, Signing_Key_Parameters__c, Signature_Algorithm__c,Certificate_Policy_CP__c, Certification_Practice_Statement_CPS__c, Standard_Audit__c, BR_Audit__c, Auditor__c,Standard_Audit_Statement_Dt__c, CP_CPS_Same_as_Parent__c, Audits_Same_as_Parent__c, Management_Assertions_By__c From Account where lastmodifieddate!=null and Revocation_Status__c = :revocationStatus and name != \'<Fill in Intermediate Cert Name>\' and technically_constrained__c != true and record_type_name__c = :RecordTypeName order by name  ';                    

    // query which gets all accounts
    String queryStr2 = 'select name, type, record_type_name__c, parentid, Certificate_Issuer_Common_Name__c, Certificate_Issuer_Organization__c, Certificate_Subject_Common_Name__c, Certificate_Subject_Organization__c, SHA_1_Fingerprint__c,Valid_From_YYYY_MMM_DD__c, Valid_To_YYYY_MMM_DD__c, Signing_Key_Parameters__c, Signature_Algorithm__c,Certificate_Policy_CP__c, Certification_Practice_Statement_CPS__c, Standard_Audit__c, BR_Audit__c, Auditor__c,Standard_Audit_Statement_Dt__c, CP_CPS_Same_as_Parent__c, Audits_Same_as_Parent__c, Management_Assertions_By__c From Account where lastmodifieddate!=null  and name != \'<Fill in Intermediate Cert Name>\' and technically_constrained__c != true order by name  ';                    
    
    
    revokedAccountSoLst= Database.query(queryStr);
    allAccountSoLst = Database.query(queryStr2);
    List<Id> ownerAccountIdLst = New List<Id>();
    if(allaccountSoLst == null || allaccountSoLst.size() == 0 )                
    {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No Records found.'));
    }
    else
    {
            // iterate over intermediate certs and get owner 
            for(Account accountSo: revokedAccountSoLst)
                {  
                    // getOwnerAccounts(accountSo, allAccountSoLst);
                    ownerAccountIdLst.add(accountSo.CA_Owner_ID__c);
                }
    }
  

  
  List<Account> ownerAccountLst = [select name, type, record_type_name__c,CA_Owner_ID__c, parentid, Certificate_Issuer_Common_Name__c, Certificate_Issuer_Organization__c, Certificate_Subject_Common_Name__c, Certificate_Subject_Organization__c, SHA_1_Fingerprint__c,Valid_From_YYYY_MMM_DD__c, Valid_To_YYYY_MMM_DD__c, Signing_Key_Parameters__c, Signature_Algorithm__c,Certificate_Policy_CP__c, Certification_Practice_Statement_CPS__c, Standard_Audit__c, BR_Audit__c, Auditor__c,Standard_Audit_Statement_Dt__c, CP_CPS_Same_as_Parent__c, Audits_Same_as_Parent__c, Management_Assertions_By__c from Account where id in :ownerAccountIdLst order by name];
  
  if(ownerAccountlst.size() > 0)
  {
      
    for(Account ownerAccountSo: ownerAccountLst)
    {
            accountHierarchySoLst.add(ownerAccountSo);
            getChildAccounts(ownerAccountSo, allaccountSoLst);
    }
  
  }
  
  
  if(accountHierarchySoLst.size() > 0)
  {
   accountHierarchySoLst2 = New List<Account>();
    Boolean parentFound;
    for(Account accountSo: accountHierarchySoLst)
    {
     
      if(accountSo.record_type_name__c == 'Root Certificate') 
      {
        
        parentFound = false; 
        for(Account childAccountSo: accountHierarchySoLst)
          {
            
           if(childAccountSo.record_type_name__c == 'Intermediate Certificate' && childAccountSo.parentId == accountSo.id)
           {
             parentFound = true;
           }
       
          }
          
          
     }
     if(accountSo.record_type_name__c != 'Root Certificate' || (accountSo.record_type_name__c == 'Root Certificate' && parentFound))
          {
             accountHierarchySoLst2.add(accountSo);
          }

    
    }
   
   accountHierarchySoLst = accountHierarchySoLst2;
  
  }
  
    
 }
   
   
    
    private void getOwnerAccounts(Account accountSo, List<account> allAccountSoLst )
    {
       
      for(Account allAccountSo : allAccountSoLst )
       {
         
         // get the parent account
         if(accountSo.parentId == allAccountSo.id)
         {
            // if the parent is of type owner then get all the child accounts of this owner
            if(allAccountSo.Record_Type_Name__c == 'CA Owner')
              {
                     accountHierarchySoLst.add(allAccountSo);
                     getChildAccounts(allAccountSo, allaccountSoLst);
              }
            else
             {
                // else continue and get the parent account until we dont find the owner
                 getOwnerAccounts(allAccountSo,allAccountSoLst);
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