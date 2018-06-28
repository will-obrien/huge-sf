global class Datacompletionbatch9 implements Database.Batchable<SObject>
{   
      global Id frmRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
    global Id erpRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
    global Id cpeRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
     global Id cpeCandidateRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','CPE');
     global Id attestCandidateRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Attest');
    list< contract > existingCPEContracts = new List<contract>(); 
      list< contract > newCPEContracts = new List<contract>(); 
      list< Candidate_Requirement__c > newCPERequirements = new List<Candidate_Requirement__c>(); 
      list< Candidate_Requirement__c > newAttestRequirements = new List<Candidate_Requirement__c>(); 
      set< id > newlyCompletedContractIDs = new Set<id>() ; 
      map< id, id > ContractID2reqID = new map< id, id >() ;
      set< id > accountIDsOfMembersWithNewlyCompletedContracts = new Set<id>() ;  
      set< id > accountIDsOfMembersWithExistingCPEContracts = new Set<id>() ;  
      map<string, map<string,id>> recTypeDevName2sObjectType2ID = new map<string, map<string,id>> () ;
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,accountId,All_Requirements_Completed_Date__c from Contract where All_Requirements_Completed_Date__c != null and (recordTypeId =: frmRecordTypeID or recordTypeId =: erpRecordTypeID)');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contract> scope){
        
        Set<Id> setAcc = new Set<Id>();
        for(Contract obj : Scope)
        {
            setAcc.add(obj.accountId);
        }
        Set<Id> setHasCpeRecords = new Set<Id>();
        for(Contract obj1 : [select id,All_Requirements_Completed_Date__c,AccountId,Status, Opportunity__c,recordTypeId,OwnerId from contract where accountId in : setAcc ])
        {
            if(obj1.recordTypeId == cpeRecordTypeID && obj1.Status == 'Activated ( Auto-Renew )')
            {
                setHasCpeRecords.add(obj1.AccountId);
                
            }
        }
        Set<Id> setUnique = new Set<Id>();
        for(Contract obj2 : [select id,All_Requirements_Completed_Date__c,AccountId,Status, Opportunity__c,recordTypeId,OwnerId from contract where accountId not in : setHasCpeRecords and accountId in: setAcc])
        {
            //accountIDsOfMembersWithExistingCPEContracts.add ( obj2.AccountId ) ;
            if(!setUnique.contains(obj2.accountId))
            {
                setUnique.add(obj2.accountId);
                Date today = date.today();
                Date startDt = date.newInstance(date.today().year(), 1, 1 );
             
             if(obj2.All_Requirements_Completed_Date__c != null && obj2.All_Requirements_Completed_Date__c.month() >= 7) {
                startDt = date.newInstance(date.today().year()+1, 1, 1 );
               } 

               
              newCPEContracts.add ( new contract (AccountId = obj2.AccountId,OwnerId = obj2.OwnerId,ContractTerm = 24, Opportunity__c = obj2.Opportunity__c,RecordTypeId = cpeRecordTypeID,StartDate = startDt,Status = 'draft' ) ) ;
            }           
            
        }
        
        Database.SaveResult[] srList = Database.insert(newCPEContracts,false);
        Set<Id> setNewContracts = new Set<Id>();
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                //System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                setNewContracts.add(sr.getId());
            }
        }

          system.debug('After Insert = '+newCPEContracts);
            List<Contact> lstContacts = [select Id, Name, Email_CPE_News__c, MailingCountry from contact where AccountID in :accountIDsOfMembersWithNewlyCompletedContracts];
            for(Contact con :lstContacts) {
                
            //if(con.MailingCountry != 'Canada') {
                    con.Email_CPE_News__c = true;
            //}
            }
            
            update lstContacts;
        List<Contract> lstUpdateStatus = new  List<Contract>();     
        for ( contract c : [select id,Status from contract where id in: setNewContracts] )
        {
                c.status = 'Activated ( Auto-Renew )' ;
                lstUpdateStatus.add(c);
        }
        update lstUpdateStatus ;
          
         for( Contract c: lstUpdateStatus ) {
              newCPERequirements.add ( new Candidate_Requirement__c ( Candidate_Commitment__c = c.id, recordTypeID = cpeCandidateRecordTypeID,Name = 'CPE', Status__c = 'Activated' )) ;    
            }
            insert newCPERequirements ;
            
          
            for ( Candidate_Requirement__c c : newCPERequirements )
              ContractID2reqID.put( c.Candidate_Commitment__c, c.id ) ;

            for ( Contract c: lstUpdateStatus ) {    
              newAttestRequirements.add ( new Candidate_Requirement__c ( Candidate_Commitment__c = c.id, recordTypeID = attestCandidateRecordTypeID,Prerequisite__c = ContractID2reqID.get( c.id ),Name = 'Attest', Status__c = 'Activated' )) ;  
            }    
            insert newAttestRequirements ;


    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}