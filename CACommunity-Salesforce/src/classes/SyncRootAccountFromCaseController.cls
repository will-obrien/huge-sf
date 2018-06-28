/**

This is the controller class for the SyncRootAccountFromCase VF page. The user gets redirected to this page after
fields displayed on the SyncParentAccountFromCase VF Page are synced(or may not be)  with the parent account.
Here the user has two options: 
1. Either to update the displayed fields from the Root Case record to the Root Account record
   a. if the root account record is not found (We do the lookup using the root case name) then we
      create a new root case account
   b. if the root account record is found then it is updated.
2. Do not perform any update and go through the next root case 
3. if the user has reviewed all the root cases then redirect the user to sync contact details page. 
**/

global with sharing class SyncRootAccountFromCaseController{

    // flag that indicates whether the record was updated. 
    // the next actions that a user could perform are presented on the screen based on the value of this flag
    Boolean isRecordUpdated=false;

    // flag that indicates whether the user rejected to update the parent account
    // the next actions that a user could perform are presented on the screen based on the value of this flag
    Boolean isUpdateCancelled = false;

    // flag that indicates that a root account with the name = root case name exists
    Public Boolean rootAccountExists { get; set;}
      
    // object that holds the id of the record that was passed as parameter to the page    
    Root_Case__c rootCaseSo   { get; set;}

    // object that holds all the details which are fetched using SOQL
    Root_Case__c rootCaseDetailsSo  { get; set;} 

    // the root account object whose name is same as the root case name.
    Account rootAccountSo  { get; set;}

    // this variable holds the count of total number of root cases. this is displayed on the page
    Integer totalRootCaseCount { get; set;}
    
    // this variable holds the sequence number of the current account ex: 2 of 4 
    Integer currentRecordCount { get; set;}
    
    // boolean flag to indicate that if the cookie is already read.
    public static boolean readOriginalRootCaseIdCookie = false;

    // list which holds all the root case ids
    List<String> rootCaseIdLst; 

     // constructor method for standard controller    
    public SyncRootAccountFromCaseController(ApexPages.StandardController stdController) {
         
         String rootCaseIdCookieValueStr; 
         
         rootAccountExists = true;
         
         totalRootCaseCount =1;
         
         // get the record id on which the button was clicked
         this.rootCaseSo= (Root_Case__c)stdController.getRecord();
         
         // get the cookie from the page
         Cookie rootCaseIDCookie= ApexPages.currentPage().getCookies().get('OriginalSyncRootCaseIDCookie');
         
         Map<Id,Integer> rootCaseCountMap = new Map<Id,Integer>();
         
         

        try{
        
                if(rootCaseIDCookie!=null && !readOriginalRootCaseIdCookie)
                    {
                        rootCaseIdCookieValueStr = rootCaseIDCookie.getValue();
                        readOriginalRootCaseIdCookie = true;
             
                        if(rootCaseIdCookieValueStr!=null && rootCaseIdCookieValueStr.length() > 0 && rootCaseIdCookieValueStr.contains(','))
                            {
                                rootCaseIdLst = rootCaseIdCookieValueStr.split(',');
                                
                                Integer rootCaseCount =2;
                                
                                for(Id rootCaseId : rootCaseIdLst)
                                    {
                                        rootCaseCountMap.put(rootCaseId,rootCaseCount++);
                                    }
                                
                                totalRootCaseCount = rootCaseIdLst.size() + 1;
                            }
                        else if(rootCaseIdCookieValueStr!=null && rootCaseIdCookieValueStr.length() > 0 && !rootCaseIdCookieValueStr.contains(','))
                            {
                                totalRootCaseCount = 2;
                            }
                   }
         } catch(Exception ex)
           {
              system.debug('###ex='+ex.getMessage());
           }
         
         // this block of code is executed when there is only one root case is associated with the current case
         if(totalRootCaseCount == 1)
         {
                   currentRecordCount = 1;
         }
         // this block of code is executed when there are two root cases associated with the current case
         // and the current root case is the first one
         else if(totalRootCaseCount== 2 && rootCaseSO.id!=rootCaseIdCookieValueStr)
         {
           currentRecordCount = 1;
         }
         // this block of code is executed when there are two root cases associated with the current case
         // and the current root case is the second  one
         else if(totalRootCaseCount== 2 && rootCaseSO.id==rootCaseIdCookieValueStr)
         {
           currentRecordCount = 2;
         }
         // this block of code is executed when there are more than two root cases associated with the current case
         else
         {
             currentRecordCount = rootCaseCountMap.get(rootCaseSo.id) == null ? 1 : rootCaseCountMap.get(rootCaseSo.id);
         }
         
         
         // query all the details for this record
         rootCaseDetailsSo = [select name, case_no__c, case_no__r.accountid, case_no__r.Link_to_Bugzilla_Bug__c,  
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

         // check if the record is updated, this is determined by the additional parameter in the URL
         if( ApexPages.currentPage().getParameters().get('isRecordUpdated')!=null)
          {
             if(ApexPages.currentPage().getParameters().get('isRecordUpdated')=='true')
             {
                isRecordUpdated = true;
             }
          }

        // check if the update operation is cancelled by the user, this is determined by the additional parameter in the URL
         if( ApexPages.currentPage().getParameters().get('isUpdateCancelled')!=null)
          {
             if(ApexPages.currentPage().getParameters().get('isUpdateCancelled')=='true')
             {
                isUpdateCancelled= true;
             }
          }

         
         
         if(rootCaseDetailsSo.name!=null)
         {
           try{
                   // check if parent account exists , if it does not then throw an exception
                   rootAccountSo= [select type, name, Certificate_Issuer_Organization__c, Certificate_Issuer_Organizational_Unit__c,
                                   Approval_Bug__c, Root_Certificate_Download_URL__c, SHA_1_Fingerprint__c, SHA_256_Fingerprint__c,
                                   Valid_from_GMT__c, Valid_to_GMT__c, Signature_Algorithm__c, Signing_key_Parameters__c,
                                   URL_to_Test_Website_or_Example_Cert__c, CRL_URL_s__c, OCSP_URL_s__c,
                                   Trust_Bits__c, EV_Policy_OID_s__c, Root_Stores_Included_In__c, Mozilla_Applied_Constraints__c,
                                   Standard_Audit__c, Standard_Audit_Type__c, Standard_Audit_Statement_Date__c,
                                   BR_Audit__c, BR_Audit_Type__c, BR_Audit_Statement_Date__c,
                                   EV_Audit__c, EV_Audit_Type__c, EV_Audit_Statement_Date__c,
                                   Auditor__c, Auditor_Website__c, Auditor_Qualifications__c,
                                   Policy_Documentation__c, CA_Document_Repository__c, Certificate_Policy_CP__c, 
                                   Certification_Practice_Statement_CPS__c, Publicly_Disclosed_and_Audited_subCAs__c,
                                   NSS_Release_When_First_Included__c, Firefox_Release_When_First_Included__c
                                   from account where name =:rootCaseDetailsSo.Root_Certificate_Name__c 
                                                  and SHA_1_Fingerprint__c = :rootCaseDetailsSo.SHA_1_Fingerprint__c
                                                  and type ='Root'];            
              }
             catch(Exception ex)
               {
                    // if no such account record found then create a new account 
                    createNewAccountSoInstance();
               }
         }
         else
         {
            // if no such account record found then create a new account 
            createNewAccountSoInstance();
         }
    }
    
    // this method is invoked when the root case contains the account name which does not exists
    // in that case we need to create a new root account
    public void createNewAccountSoInstance()
    {
            rootAccountSo = new Account();
            
            rootAccountSo.name = rootCaseDetailsSo.Root_Certificate_Name__c;
            rootAccountSo.RecordTypeID = [Select Id, SobjectType, Name 
                                          From RecordType 
                                          where Name ='Root Certificate' 
                                          and SobjectType ='Account'  limit 1].Id;
            rootAccountSo.parentId = rootCaseDetailsSo.case_no__r.accountid; 
            rootAccountExists = false;
    }
    
  
  // update the root account and redirect the user to the same page but this time append a flag which indicates that the 
  // record was updated. this flag will be used by the VF page to determine if the acknoledgement message needs to be displayed    
   public PageReference syncAccount()
    {
         PageReference rootCaseSoPageRef = new PageReference('/apex/SyncRootAccountFromCase?id=' +this.rootCaseSo.id+'&isRecordUpdated=true');
         if(ApexPages.currentPage().getParameters().get('isFinalRecord')!=null)
         {
         
         rootCaseSoPageRef = new PageReference('/apex/SyncRootAccountFromCase?id=' +this.rootCaseSo.id+'&isRecordUpdated=true&isFinalRecord=true');
         }
         rootCaseSoPageRef.setRedirect(true);      
        
         this.rootAccountSo.type= 'Root';
         this.rootAccountSo.Certificate_Issuer_Organization__c= this.rootCaseDetailsSo.O_From_Issuer_Field__c;
         this.rootAccountSo.Certificate_Issuer_Organizational_Unit__c= this.rootCaseDetailsSo.OU_From_Issuer_Field__c; 
         this.rootAccountSo.Root_Certificate_Download_URL__c= this.rootCaseDetailsSo.Root_Certificate_Download_URL__c;
         this.rootAccountSo.SHA_1_Fingerprint__c= this.rootCaseDetailsSo.SHA_1_Fingerprint__c; 
         this.rootAccountSo.SHA_256_Fingerprint__c= this.rootCaseDetailsSo.SHA_256_Fingerprint__c; 
         this.rootAccountSo.valid_from_GMT__c= this.rootCaseDetailsSo.valid_from__c;
         this.rootAccountSo.valid_to_GMT__c= this.rootCaseDetailsSo.valid_to__c;       
         this.rootAccountSo.Signature_Algorithm__c= this.rootCaseDetailsSo.Certificate_Signature_Algorithm__c; 
         this.rootAccountSo.Signing_Key_Parameters__c= this.rootCaseDetailsSo.Signing_Key_Parameters__c; 
         this.rootAccountSo.URL_to_Test_Website_or_Example_Cert__c= this.rootCaseDetailsSo.Test_Website_URL_SSL_or_Example_Cert__c; 
         this.rootAccountSo.CRL_URL_s__c= this.rootCaseDetailsSo.CRL_URL_s__c; 
         this.rootAccountSo.OCSP_URL_s__c= this.rootCaseDetailsSo.OCSP_URL_s__c; 
         this.rootAccountSo.Trust_Bits__c= this.rootCaseDetailsSo.Trust_Bits__c; 
         this.rootAccountSo.EV_Policy_OID_s__c= this.rootCaseDetailsSo.EV_Policy_OID_s__c; 
         if(this.rootCaseDetailsSo.Root_Stores_Included_In__c == Null) {
             this.rootAccountSo.Root_Stores_Included_In__c = 'Mozilla';
         }
         else {
             if(this.rootCaseDetailsSo.Root_Stores_Included_In__c.contains('Mozilla')) {
                 this.rootAccountSo.Root_Stores_Included_In__c= this.rootCaseDetailsSo.Root_Stores_Included_In__c;                
             }
             else {
                 this.rootAccountSo.Root_Stores_Included_In__c = this.rootCaseDetailsSo.Root_Stores_Included_In__c + '; Mozilla'; 
             }
         }      
         this.rootAccountSo.Mozilla_Applied_Constraints__c= this.rootCaseDetailsSo.Mozilla_Applied_Constraints__c; 
         this.rootAccountSo.Standard_Audit__c= this.rootCaseDetailsSo.Standard_Audit__c; 
         this.rootAccountSo.Standard_Audit_Type__c= this.rootCaseDetailsSo.Standard_Audit_Type__c; 
         this.rootAccountSo.Standard_Audit_Statement_Date__c= this.rootCaseDetailsSo.Standard_Audit_Statement_Date__c; 
         this.rootAccountSo.BR_Audit__c= this.rootCaseDetailsSo.BR_Audit__c; 
         this.rootAccountSo.BR_Audit_Type__c= this.rootCaseDetailsSo.BR_Audit_Type__c; 
         this.rootAccountSo.BR_Audit_Statement_Date__c= this.rootCaseDetailsSo.BR_Audit_Statement_Date__c; 
         this.rootAccountSo.EV_Audit__c= this.rootCaseDetailsSo.EV_Audit__c; 
         this.rootAccountSo.EV_Audit_Type__c= this.rootCaseDetailsSo.EV_Audit_Type__c;
         this.rootAccountSo.EV_Audit_Statement_Date__c= this.rootCaseDetailsSo.EV_Audit_Statement_Date__c;
         this.rootAccountSo.Auditor__c= this.rootCaseDetailsSo.Auditor_Name__c;
         this.rootAccountSo.Auditor_Website__c= this.rootCaseDetailsSo.Auditor_Website__c;
         this.rootAccountSo.Auditor_Qualifications__c= this.rootCaseDetailsSo.Auditor_Qualifications__c;
         this.rootAccountSo.Policy_Documentation__c= this.rootCaseDetailsSo.Policy_Documentation__c;
         this.rootAccountSo.CA_Document_Repository__c= this.rootCaseDetailsSo.CA_Document_Repository__c;
         this.rootAccountSo.Certificate_Policy_CP__c= this.rootCaseDetailsSo.CP__c;
         this.rootAccountSo.Certification_Practice_Statement_CPS__c= this.rootCaseDetailsSo.CPS__c;
         this.rootAccountSo.Publicly_Disclosed_and_Audited_subCAs__c= this.rootCaseDetailsSo.Publicly_Disclosed_and_Audited_subCAs__c;
         this.rootAccountSo.NSS_Release_When_First_Included__c = this.rootCaseDetailsSo.NSS_Release_When_First_Included__c;
         this.rootAccountSo.Firefox_Release_When_First_Included__c = this.rootCaseDetailsSo.Firefox_Release_When_First_Included__c;
         this.rootAccountSo.Approval_Bug__c = this.rootCaseDetailsSo.case_no__r.Link_to_Bugzilla_Bug__c;
         this.rootAccountSo.Last_Sync_Case_No__c = this.rootCaseDetailsSo.Case_No__c;
         this.rootAccountSo.Last_Sync_Date_Time__c = System.now();
         this.rootAccountSo.Status__c ='Included' ; 
         upsert rootAccountSo;
         // this.rootAccountSo.Status__c ='Included' ; 
         // update rootAccountSo;
        
         isRecordUpdated= true;
        
        
        // Lastly, set Sync execution date/time on Root Case record
        this.rootCaseDetailsSo.Last_Sync_Date_Time__c = System.now();
        update rootCaseDetailsSo;          
               
 
         return rootCaseSoPageRef;
    }
   
   // before redirecting the user to syncContact page check if there are more root cases to be reviewed
   // if there are more root cases then present the next root case to the user
   public PageReference redirectToSyncContact()
    {
      PageReference rootCaseSoPageRef;    
      
      Cookie rootCaseIDCookie= ApexPages.currentPage().getCookies().get('SyncRootCaseIDCookie');

      String idLstCSV = '';
      String rootCaseIdCookieValueStr; 
      List<String> updatedRootCaseIdLst;
      Cookie syncRootCaseIDCookie;
      
        // the page paramater of isFinalRecord tells us that the current record is the last root case
        // hence the user needs to be redirected to the synccontact page (this is done in the else part)
         if(rootCaseIDCookie!=null && rootCaseIDCookie.getValue()!=null && rootCaseIDCookie.getValue().length()>0 && ApexPages.currentPage().getParameters().get('isFinalRecord')==null)
         {
             // if the current record is not the final record then we need to get 
             // the id of the next root case from the page cookie
             rootCaseIdCookieValueStr = rootCaseIDCookie.getValue();
             
            // if there are more than one root case ids then we need to split this value coz
            // the would be separated by a comma
             if(rootCaseIdCookieValueStr!=null && rootCaseIdCookieValueStr.length() > 0 && rootCaseIdCookieValueStr.contains(','))
             {
                updatedRootCaseIdLst = rootCaseIdCookieValueStr.split(',');
              
             }
        
          // if there are more than one root cases pending to be iterated
         if(updatedRootCaseIdLst!=null &&  updatedRootCaseIdLst.size()>0)
         {
          // set the page ref to the next root case
          rootCaseSoPageRef = new PageReference('/apex/SyncRootAccountFromCase?id=' + updatedRootCaseIdLst.get(0));
            
            // if there are more than one root cases pending then we 
            // need to prepare the new csv with the next root case id truncated
            if(updatedRootCaseIdLst.size() > 1)
            {
             for(integer i=1; i <updatedRootCaseIdLst.size(); i++)
             {
                 idLstCSV = idLstCSV  +  updatedRootCaseIdLst.get(i) + ',';
                 
             }
             
             // set the values back in cookie
             if(idLstCSV.length() > 0)
             {
               idLstCSV =  idLstCSV.removeEnd(',');
               syncRootCaseIDCookie=new Cookie('SyncRootCaseIDCookie',idLstCSV,null,-1,false);
               ApexPages.currentPage().setCookies(new Cookie[]{syncRootCaseIDCookie});       
             }
          }
         
   
         }
         else
         {
          // if there is no comma in the cookie string it means there is only root case pending
          // reset the cookie value and set the flag that this is the final record
          syncRootCaseIDCookie=new Cookie('SyncRootCaseIDCookie',idLstCSV,null,-1,false);
          ApexPages.currentPage().setCookies(new Cookie[]{syncRootCaseIDCookie});        
          rootCaseSoPageRef = new PageReference('/apex/SyncRootAccountFromCase?id=' + rootCaseIdCookieValueStr+'&isFinalRecord=true');

         }

    }
         // redirect the user to the synccontact page
         else
         {
           rootCaseSoPageRef = new PageReference('/apex/SyncContactFromCase?id=' +this.rootCaseDetailsSo.case_no__c);
         }
         rootCaseSoPageRef.setRedirect(true);
         return rootCaseSoPageRef;        
    }
     
   // when the user does not want to create/update root account, redirect to same page with a flag that indicates that 
   // the user cancelled the operation. this flag is used by the VF page to display the corresponding acknowledgement message.
   // also the user is redirect to the next root case
   
   public PageReference cancelSyncAccount()
    {
      PageReference rootCaseSoPageRef;    
        
      // get the cookie value from the current page
      Cookie rootCaseIDCookie= ApexPages.currentPage().getCookies().get('SyncRootCaseIDCookie');

      String idLstCSV = '';
      String rootCaseIdCookieValueStr; 
      List<String> updatedRootCaseIdLst;
      Cookie syncRootCaseIDCookie;
      
         // the page paramater of isFinalRecord tells us that the current record is the last root case
        // hence the user needs to be redirected to the synccontact page (this is done in the else part)
         if(totalRootCaseCount!=1 && rootCaseIDCookie!=null && rootCaseIDCookie.getValue()!=null && rootCaseIDCookie.getValue().length()>0 && ApexPages.currentPage().getParameters().get('isFinalRecord')==null)
         {
            // if the current record is not the final record then we need to get 
            // the id of the next root case from the page cookie
             rootCaseIdCookieValueStr = rootCaseIDCookie.getValue();
            
            // if there are more than one root case ids then we need to split this value coz
            // the would be separated by a comma
             if(rootCaseIdCookieValueStr!=null && rootCaseIdCookieValueStr.length() > 0 && rootCaseIdCookieValueStr.contains(','))
             {
                updatedRootCaseIdLst = rootCaseIdCookieValueStr.split(',');
              
             }
        
         
         // if there are more than one root cases pending to be iterated
         if(updatedRootCaseIdLst!=null &&  updatedRootCaseIdLst.size()>0)
         {
           // set the page ref to the next root case 
           rootCaseSoPageRef = new PageReference('/apex/SyncRootAccountFromCase?id=' + updatedRootCaseIdLst.get(0));

            // if there are more than one root cases pending then we 
            // need to prepare the new csv with the next root case id truncated
            if(updatedRootCaseIdLst.size() > 1)
            {
             for(integer i=1; i <updatedRootCaseIdLst.size(); i++)
             {
                 idLstCSV = idLstCSV  +  updatedRootCaseIdLst.get(i) + ',';
                 
             }
               if(idLstCSV.length() > 0)
             {
             idLstCSV =  idLstCSV.removeEnd(',');
             
            
            syncRootCaseIDCookie=new Cookie('SyncRootCaseIDCookie',idLstCSV,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{syncRootCaseIDCookie});       
             }
          }
         
   
         }
         else
         {
         
          syncRootCaseIDCookie=new Cookie('SyncRootCaseIDCookie',idLstCSV,null,-1,false);
          ApexPages.currentPage().setCookies(new Cookie[]{syncRootCaseIDCookie});        
          rootCaseSoPageRef = new PageReference('/apex/SyncRootAccountFromCase?id=' + rootCaseIdCookieValueStr+'&isFinalRecord=true');

         }

    }
          // if there is no comma in the cookie string it means there is only root case pending
          // reset the cookie value and set the flag that this is the final record

         else
         {
           rootCaseSoPageRef = new PageReference('/apex/SyncContactFromCase?id=' +this.rootCaseDetailsSo.case_no__c);
         }
         rootCaseSoPageRef.setRedirect(true);
         return rootCaseSoPageRef;        
     
 
    //   PageReference rootCaseSoPageRef = new PageReference('/apex/SyncRootAccountFromCase?id=' +this.rootCaseSo.id+'&isUpdateCancelled=true');
    //   rootCaseSoPageRef.setRedirect(true);
    //   isUpdateCancelled = true;
    //   return rootCaseSoPageRef;  
    }
    
  // eventually take the user back the root case record
   public PageReference redirectToRootCase()
    {
         PageReference rootCaseSoPageRef = new PageReference('/' +this.rootCaseSo.id);
         rootCaseSoPageRef.setRedirect(true);
         return rootCaseSoPageRef;        
    }
    
   public Boolean getIsUpdateCancelled()  { return this.isUpdateCancelled;  }
    
   public Root_Case__c getRootCase()  { return this.rootCaseDetailsSo;  }
    
   public Account getParentAccount()     { return this.rootAccountSo;  }
  
   public Boolean getRootAccountExists() { return this.rootAccountExists;  }
    
   public Boolean getIsRecordUpdated()  {   return this.isRecordUpdated;  }
  
   public Integer getTotalRootCaseCount() {   return this.totalRootCaseCount;  }
   
   public Integer getCurrentRecordCount()  {   return this.currentRecordCount;  }  
 
}