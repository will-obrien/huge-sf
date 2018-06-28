// ========================================================================================================
// AccountTriggerHelper: Trigger for the Account object which handles all the events and based 
// on the event delegates the task to the corresponding trigger handler method in the AccountTriggerHelper class.
// ========================================================================================================
// SetAccountStatusField : Update related Account Status whenever a new Account is created. 
// ========================================================================================================
// updateCAOwnerFields: This method set the ultimate parent to CA Owner and CA Owner Ids fields for all 
// account hiearachy levels. If the user makes account name change or parent id it is reflected in the hiearrchy. 
// ========================================================================================================

public class AccountTriggerHelper {
    
 // define a static boolean variable to avoid recursive trigger update
 public static boolean isAccountTriggerRunning = false;
 
  /* // method to extract info from cert checker utility
 // this is executed when the record is inserted for the first time
 // note at this time we do not have the record id available and hence a separate method
 public static void extract509CertificateBeforeInsert(List<Account> newAccountSoLst) {
 
  List<Account> accountSoLst = New List<Account>();
  
  // loop over all the accounts and add them to the list if the PEM info is available
  for(Account accountSo : newAccountSoLst)
  {
    if(accountSo.X_509_Certificate_PEM__c!=null && accountSo.X_509_Certificate_PEM__c.length() > 0)  
     {
       accountSoLst.add(accountSo);
     }
  }
  
  // if there are accounts to be processed
  if(AccountSoLst.size() > 0)
  {
    // we have to create a new list of type String as 
    // future method accept olny primitive type as input paramters
    List<String> accountSoStrLst = New List<String>();
           
           // loop over all the accounts for which we need to fetch the infor
           // from cert checker utility and serialize them into String 
           Account tempAccountSo;
           List<Account> updateAccountSoLst = New List<Account>();
           
           // the future method would take some time to update the records
           // hence we set a flag as true so that a message is displayed to the user
           for(Account accountSO : AccountSoLst)
           {
             tempAccountSo = New Account(id = accountSo.id,Display_Message_or_Warning__c =true);
             updateAccountSoLst.add(tempAccountSo);
            
             accountSoStrLst.add(JSON.serialize(accountSo));
           }
          
           if(updateAccountSoLst.size () > 0 )
           {
              update updateAccountSoLst;
           }
           
           // invoke the future method which makes the HTTP callout 
           // and updates the account record with the response
           x509CertCheckerUtility.x509CertChecker(accountSoStrLst);
  }

 } 

  // method to extract info from cert checker utility
  // this is executed when the PEM info on existing record is updated
   public static void extract509CertificateAfterUpdate(List<Account> oldAccountSoLst, List<Account> newAccountSoLst,Map<id,Account> oldMap, Map<Id,Account> newMap) {

     
        List<Account> updatedAccountSoLst= new List<Account>();
              
        if(Trigger.isUpdate)
        {
          // loop over all the account records and get only those accounts 
          // whose PEM info is updated and the current PEM info is not same as the previous PEM info
          for(Account newAccountSo: newAccountSoLst){
              Account oldAccountSo= oldMap.get(newAccountSo.Id);
         
             if( newAccountSo.X_509_Certificate_PEM__c!=null && newAccountSo.X_509_Certificate_PEM__c.length()>0 && 
               ((
                  (oldAccountSo.X_509_Certificate_PEM__c== null ||
                     (oldAccountSo.X_509_Certificate_PEM__c!=null && oldAccountSo.X_509_Certificate_PEM__c.length()==0) 
                  ) && 
                    newAccountSo.X_509_Certificate_PEM__c!=null && newAccountSo.X_509_Certificate_PEM__c.length() > 0
                ) || 
                ( 
                   !oldAccountSo.X_509_Certificate_PEM__c.equals(newAccountSo.X_509_Certificate_PEM__c))
               )
               )
                {
                    updatedAccountSoLst.add(newMap.get(newAccountSo.Id));                 
                } // end if
           } // end for 
        } // end if
        else
        {
          updatedAccountSoLst = newAccountSoLst;
        }
         
         if(updatedAccountSoLst.size()> 0) 
         {
           List<String> accountSoStrLst = New List<String>();
           
           Account tempAccountSo;
           List<Account> updateAccountSoLst = New List<Account>();
           
           // loop over all the accounts for which we need to fetch the infor
           // from cert checker utility and serialize them into String 
               
           // the future method would take some time to update the records
           // hence we set a flag as true so that a message is displayed to the user
           for(Account accountSO : updatedAccountSoLst)
           {
            if(accountSo.X_509_Certificate_PEM__c!=null && accountSo.X_509_Certificate_PEM__c.length() > 0)
            {
             tempAccountSo = New Account(id = accountSo.id,Display_Warning_or_Message__c =true,Display_Webservice_Not_Available__c=false,Display_Webservice_Failed_Message__c=false);
             updateAccountSoLst.add(tempAccountSo);
             
             accountSoStrLst.add(JSON.serialize(accountSo));
            }
           }

           // update the flag on the account record
           if(updateAccountSoLst.size () > 0 )
           {
             update updateAccountSoLst;
           }
        
           // invoke the future method
           if(accountSoStrLst.size() > 0 )
           {
            x509CertCheckerUtility.x509CertChecker(accountSoStrLst);
           }
           
         }
         
         // get proposals of finalized configs
         // and set flag to false approva status flag
 }
     
     */
  // this method is invoked whenever a new account is created
  // the requirement is to set the status on account as 'Not Yet Included'
  public static void SetAccountStatusFieldonInsert(List<Account> accountSoLst) {
   
   // loop over all the account which were inserted
   for(Account accountSo : accountSoLst)
    {   
        if(accountSo.status__c==null || accountSo.status__c.length()==0)
        {
         accountSo.status__c = 'Not Yet Included';
        }
        
     
    }
      
  }
   
  public static void validateParentAccountForIntermediateCA(List<Account> accountSoLst) {
  
   // get the record type ID of the intermediate CA records
   Id intermediateCARecTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeId();

   // get the record type ID of the root certificate records 
   Id rootCARecTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeId();

   // get the record type ID of the root certificate records 
   Id ownerCARecTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeId();

   // get the ID of the current user
   Id currentUserId =    UserInfo.getUserId();

   // query the user details and check if it is a portal user and get the Owner account ID for that user
   List<User> userSoLst = [select IsPortalEnabled,contact.account.id,contact.account.name from user where id = :currentUserId];
    
   // intermediate cert can have only root/inter certs as their parents. this 
   // validation is done only for portal users
   if(userSoLst!=null && userSoLst.size() > 0 && userSoLst[0].isPortalEnabled)
   //if(userSoLst!=null && userSoLst.size() > 0 )
   {
     
    // set which holds list of all valid parentIDs 
    Set<Id> rootCAIDSet = New Set<Id>();
    
    List<Account> rootAccountSOLst = New List<Account>();
    
    // special case to handle the exceptional scenario for Symantec Accounts
    // When a portal user for any of Symantec Accounts (symantec or sy-geotrust or sy-verisign) 
    // logs in and creates an intermediate CA, they should be able to select the root certificate of any of these owner accounts
     Map<Id,Account> symantecAccountMap ;
     List<ID> currentParent      = new List<ID>{};
    // check if the portal user is associated with any of the symantec accounts
    if(userSoLst[0].contact!=null && userSoLst[0].contact.account.name.startsWith('Symantec'))
    {
      // get all the symantec owner accounts
       symantecAccountMap = New Map<Id,Account>([select id from account where name like 'Symantec%' and recordTypeId=:ownerCARecTypeId]);
     
      
      // get all the root CAs for these owner accounts
      rootAccountSOLst  = [select name from Account where parentId in :symantecAccountMap.keySet() and (recordTypeId=:rootCARecTypeId or recordTypeId = :intermediateCARecTypeId)  ];
      for(Id accountId : symantecAccountMap.keySet())
      {
        currentParent.add(accountId );      
      }
      
    }
    else
    {
      
      // non-symantec accounts 
      rootAccountSoLst = [select name from Account where parentId = :userSoLst[0].contact.accountid  and (recordTypeId=:rootCARecTypeId   or recordTypeId = :intermediateCARecTypeId )];
      currentParent.add(userSoLst[0].contact.accountid );
    }
    system.debug('##currentParent='+currentParent);
    
/*
     //loop over each root certificate and put it in the map
     for(Account accountSo : rootAccountSoLst )
     {
       rootCAIdSet.add(accountSo.id);
     }

     for(Account accountSo: accountSoLst)
    {
      if(accountSo.recordTypeId == intermediateCARecTypeId)
      {
       accountSo.CA_Owner_For_Inter_Cert__c = userSoLst[0].contact.account.name;
      }
    }
          
    List<Account> interCaAccountsLst ;
    
    // get all the intermediate certs where the roots are their parents
    interCaAccountsLst = [select name from Account where parentId in :rootCAIdSet and recordTypeId = :intermediateCARecTypeId];

     for(Account accountSo : interCaAccountsLst )
     {
       rootCAIdSet.add(accountSo.id);
     }
    */ 
     Boolean endOfStructure = false;

      List<Account> al            = new List<Account>{};
           Set<Id> recordIdSet= new Set<Id>(currentParent);
     while ( !endOfStructure ){


       al = [ SELECT id FROM Account a WHERE a.ParentID IN : CurrentParent ORDER BY a.Name ];            

            if( al.size() == 0 ){
                endOfStructure = true;
            }
            else{
                currentParent.clear();
                for ( Integer i = 0 ; i < al.size(); i++ ){
                    //Change below
                    Account a = al[i];
                    currentParent.add( a.id );
                    recordIdSet.add(a.id);
                }
           }
         }  

     
    system.debug('##recordIdset='+recordIdSet);
     // loop over the existing records which are inserted/updated
      for(Account accountSo: accountSoLst)
        {
          // for each intermediate CA record if the parentId does not exist in the map of valid rootCA then throw an error.
          //if(accountSo.recordTypeId == intermediateCARecTypeId && (!rootCAIdSet.contains(accountSo.ParentId) || (Trigger.isUpdate && accountSo.parentId == accountso.id)))
           if(accountSo.recordTypeId == intermediateCARecTypeId && (!recordIdSet.contains(accountSo.ParentId) || (Trigger.isUpdate && accountSo.parentId == accountso.id)))
            {
              accountSo.addError('Invalid selection made for Parent CA Owner/Certificate. Please select a Root Cert or Intermediate Cert owned by ' + userSoLst[0].contact.account.name);
            }
            
        } 
      
   }
  
  }
    
    /*
    * recrusive method, will set CA Owner Info to all its children records
    */
    public static List<Account> defaultCA_OwnerOnChildRecords(Set<Id> parentAccId, String ultimateParentAccName, String ultimateParentAccId, List<Account> thisList){
        System.debug('in recursive call..');
        //List<Account> lstAccountToUpdate = new List<Account>();
        Set<Id> parentRecordIds = new Set<Id>();
        
        List<Account> childrenRecords = [SELECT Id, ParentId FROM Account WHERE ParentId IN :parentAccId];
        
        if(childrenRecords.isEmpty()){
            System.debug('end of recursive call..');
            return thisList;
        }
        
        for(Account acc : childrenRecords){
            system.debug('**child record: '+acc.Id);
            thisList.add(new Account(Id = acc.Id, CA_Owner__c = ultimateParentAccName, CA_Owner_ID__c = ultimateParentAccId));
            parentRecordIds.add(acc.Id);
        }
        
        return defaultCA_OwnerOnChildRecords(parentRecordIds, ultimateParentAccName, ultimateParentAccId, thisList);
    }
    
    /*
    * Recursive method, to get ULTIMATE parent account
    */
    public static Account getUltimateParent(Id parentAccountId, String ultimateParentRecordTypeId){
        
        List<Account> parentRecord = [SELECT Id, Name, RecordTypeId, ParentId FROM Account WHERE Id = :parentAccountId];
        
        if(parentRecord.size() > 0){
            
            if(ultimateParentRecordTypeId == parentRecord[0].RecordTypeId){
                
                return parentRecord[0];
            }
            
            return getUltimateParent(parentRecord[0].ParentId, ultimateParentRecordTypeId);
        }
        
        return null;//should never reach here..
    }
    
    /*
    * method called from Trigger - contains Logic to populate CA Owner Info of current + child records.
    */
    public static void updateCAOwnerFields(Account newAccount, Account oldAccount){
        
        String caOwnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeId();
        String rootCertRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Root Certificate').getRecordTypeId();
        String intermediateCertRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Intermediate Certificate').getRecordTypeId();
        
        //Case-I if there is an update in CA Owner Account's Name, update all it's child records with correcr CA Owner Name
        if(Trigger.isBefore && Trigger.isUpdate && newAccount.Name != oldAccount.Name && newAccount.RecordTypeId == caOwnerRecordTypeId){
            
            system.debug('CASE-I change in account name of CA Owner Account.');
            
            newAccount.CA_Owner__c = newAccount.Name;
            newAccount.CA_Owner_ID__c = newAccount.Id;
            
            List<Account> lstAccountToUpdate = defaultCA_OwnerOnChildRecords(new Set<Id>{newAccount.Id}, newAccount.Name, newAccount.Id, new List<Account>{});
            system.debug('list to update: '+lstAccountToUpdate.size());
            if(lstAccountToUpdate.size() > 0){
                
                update lstAccountToUpdate;
            }
            
            return;
        }
        
        //Case-II if there is a change in ParentId in any "intermediate" or "Root" accounts.
        if(Trigger.isBefore && Trigger.isUpdate && newAccount.RecordTypeId != caOwnerRecordTypeId && newAccount.ParentId != oldAccount.ParentId && newAccount.ParentId != null){
            
            system.debug('CASE-II update in parent Id');
            //Two sub-cases
            //1. change in parent Id of Root Certificate ->  
                //I. get the Immediate Parent -update in the CA Owner and CA Owner Id field
                //II. get all the child records - update will correct CA Owner & CA Owner Id fields.
            
            if(rootCertRecordTypeId == newAccount.RecordTypeId){
                
                //get Immediate Parent - hope "Root Cert" can we child of "CA Owner" Only if not then ignore - check with Poonamji and confirm
                List<Account> parentAccount = [SELECT Id, Name FROM Account WHERE Id = :newAccount.ParentId AND RecordTypeId = :caOwnerRecordTypeId];
                system.debug('CASE-II - subcase - I.  update in parent Id of root cert');
                if(parentAccount.size() > 0){
                    //I.
                    newAccount.CA_Owner__c = parentAccount[0].Name;
                    newAccount.CA_Owner_ID__c = parentAccount[0].Id;
                    //II.
                    List<Account> lstAccountToUpdate = defaultCA_OwnerOnChildRecords(new Set<Id>{newAccount.Id}, parentAccount[0].Name, parentAccount[0].Id, new List<Account>{});
                    system.debug('list to update: '+lstAccountToUpdate.size());
                    if(lstAccountToUpdate.size() > 0){
                        update lstAccountToUpdate;
                    }
                    
                    return;
                }
            }
            
            //2. change in the parent Id of Intermediate Certificate -> 
                //I. get the ULTIMATE Parent - update CA Owner and CA Owner Id field
                //II. get all the child records - update will correct CA Owner & CA Owner Id fields.
            
            if(intermediateCertRecordTypeId == newAccount.RecordTypeId){
                
                //I.
                Account ultimanteParent = getUltimateParent(newAccount.ParentId, caOwnerRecordTypeId);
                
                if(ultimanteParent != null){
                    newAccount.CA_Owner__c = ultimanteParent.Name;
                    newAccount.CA_Owner_ID__c = ultimanteParent.Id;
                    
                    //II.
                    List<Account> lstAccountToUpdate = defaultCA_OwnerOnChildRecords(new Set<Id>{newAccount.Id}, ultimanteParent.Name, ultimanteParent.Id, new List<Account>{});
                    if(lstAccountToUpdate.size() > 0){
                        update lstAccountToUpdate;
                    }
                    
                    return;
                }
            }
        }
        
        //Case-III if root record inserted then update its "CA Owner" and "CA Owner Id" field of the same account
        if(Trigger.isAfter && Trigger.isInsert && newAccount.RecordTypeId == caOwnerRecordTypeId){
            
            system.debug('CASE-III new CA Owner ACcount inserted');
            Account selfUpdate = new Account(Id = newAccount.Id, CA_Owner__c = newAccount.Name, CA_Owner_ID__c = newAccount.Id);
            update selfUpdate;
        }
        
        //Case-IV
        if(Trigger.isBefore && Trigger.isInsert && newAccount.RecordTypeId != caOwnerRecordTypeId && newAccount.ParentId != null){
            system.debug('CASE-IV Insert new intermediate or root certificate');
            
            //I. If Root Certificate inserted - get Immediate Parent & update correct CA Owner and CA Owner Id
            if(rootCertRecordTypeId == newAccount.RecordTypeId){
                List<Account> parentAccount = [SELECT Id, Name FROM Account WHERE Id = :newAccount.ParentId AND RecordTypeId = :caOwnerRecordTypeId];
                
                if(parentAccount.size() > 0){
                    //I.
                    newAccount.CA_Owner__c = parentAccount[0].Name;
                    newAccount.CA_Owner_ID__c = parentAccount[0].Id;
                }
                
                return;
            }
            
            //II. If Intermediate Certificate inserted - get ULTIMATE parent and update
            if(intermediateCertRecordTypeId == newAccount.RecordTypeId){
                
                Account ultimanteParent = getUltimateParent(newAccount.ParentId, caOwnerRecordTypeId);
                
                if(ultimanteParent != null){
                    newAccount.CA_Owner__c = ultimanteParent.Name;
                    newAccount.CA_Owner_ID__c = ultimanteParent.Id;
                }
                
                return;
            }
        }
    }
    
    public static String checkDeleteValidation(Account deletedAccount){
        
        Integer hasChildRecords = [SELECT COUNT() FROM Account WHERE ParentId = :deletedAccount.Id];
        
        if(hasChildRecords > 0){
            //deletedAccount.addError('You can\'t delete this record, please delete child records first.');
            return 'You can\'t delete this record, please delete child records first.';
        }
        
        return null;
    }
  
}