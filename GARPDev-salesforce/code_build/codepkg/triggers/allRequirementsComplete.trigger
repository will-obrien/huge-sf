trigger allRequirementsComplete on contract (after update) {

  list< contract > existingCPEContracts = new List<contract>(); 
  list< contract > newCPEContracts = new List<contract>(); 
  list< contract > newlyCompletedContracts = new List<contract>(); 
  list< Candidate_Requirement__c > newCPERequirements = new List<Candidate_Requirement__c>(); 
  list< Candidate_Requirement__c > newAttestRequirements = new List<Candidate_Requirement__c>(); 
  set< id > newlyCompletedContractIDs = new Set<id>() ; 
  map< id, id > ContractID2reqID = new map< id, id >() ;
  set< id > accountIDsOfMembersWithNewlyCompletedContracts = new Set<id>() ;  
  set< id > accountIDsOfMembersWithExistingCPEContracts = new Set<id>() ;  
  map<string, map<string,id>> recTypeDevName2sObjectType2ID = new map<string, map<string,id>> () ;
  Map<Id,contract> mapContractDetails = new  Map<Id,contract>();
  Set<Id> setOpps = new Set<Id>();
  Set<Id> setOpps1 = new Set<Id>();
  for ( contract c : Trigger.new ) {
    system.debug(' Contact==='+c);
    if ( Trigger.oldMap.get(c.Id).status == 'Activated' && c.All_Requirements_Completed__c == TRUE && c.All_Requirements_Completed__c != Trigger.oldMap.get(c.Id).All_Requirements_Completed__c) {

    
    if( recTypeDevName2sObjectType2ID.get('Candidate_Requirement__c') == NULL || recTypeDevName2sObjectType2ID.get('Contract') == NULL ||recTypeDevName2sObjectType2ID.get('Candidate_Requirement__c').get('CPE') == NULL ||
        
        recTypeDevName2sObjectType2ID.get('Candidate_Requirement__c').get('Attest') == NULL ||recTypeDevName2sObjectType2ID.get('Contract').get('CPE') == NULL ||recTypeDevName2sObjectType2ID.get('Contract').get('ERP_Program') == NULL ||recTypeDevName2sObjectType2ID.get('Contract').get('FRM_Program') == NULL  ) {     
        
  for( RecordType rt : [SELECT id, DeveloperName, SobjectType FROM RecordType WHERE SobjectType = 'Contract' OR SobjectType = 'Candidate_Requirement__c' ] ) {
         
     if( recTypeDevName2sObjectType2ID.get( rt.SobjectType) == NULL )
            recTypeDevName2sObjectType2ID.put( rt.SobjectType, new map<string, id>() );
          recTypeDevName2sObjectType2ID.get( rt.SobjectType).put( rt.DeveloperName, rt.id ) ;
        }}
     
    if (c.RecordTypeId == recTypeDevName2sObjectType2ID.get('Contract').get('ERP_Program') || c.RecordTypeId == recTypeDevName2sObjectType2ID.get('Contract').get('FRM_Program') ) { 
        newlyCompletedContractIDs.add ( c.id ) ;
        accountIDsOfMembersWithNewlyCompletedContracts.add( c.AccountId ) ;
      }}
      system.debug('recTypeDevName2sObjectType2ID ==='+recTypeDevName2sObjectType2ID);
       system.debug('OLD MAP ==='+Trigger.OldMap);
    if(c.Status == 'Activated ( Auto-Renew )'&& c.RecordTypeID == RecordTypeHelper.GetRecordTypeId('Contract','Membership') &&(c.Membership_type__C =='Individual' || c.Membership_type__C =='student'))
    {
        setOpps.add(c.Opportunity__c);
        mapContractDetails.put(c.Opportunity__c,c);
    }

     if(Trigger.oldMap.get(c.Id).status == 'Activated ( Auto-Renew )'&& c.RecordTypeID == RecordTypeHelper.GetRecordTypeId('Contract','Membership') &&(c.Membership_type__C =='Individual' || c.Membership_type__C =='student') && Trigger.oldMap.get(c.Id).status != Trigger.newMap.get(c.Id).status)
    {
        setOpps1.add(c.Opportunity__c);
        
    }
      
    }
   
   if ( newlyCompletedContractIDs.size() > 0 ) {
    
 for( contract c : [SELECT Id,  AccountId, Opportunity__c, OwnerId FROM Contract  WHERE AccountId IN :accountIDsOfMembersWithNewlyCompletedContracts AND ( RecordTypeId = :recTypeDevName2sObjectType2ID.get('Contract').get('CPE') ) AND status = 'Activated ( Auto-Renew )' ] ) 
      accountIDsOfMembersWithExistingCPEContracts.add ( c.AccountId ) ;
      Date today = date.today();
      Date startDt = date.newInstance(date.today().year(), 1, 1 );
     
     if(today.month() >= 7) {
        startDt = date.newInstance(date.today().year()+1, 1, 1 );
       } 

 for ( contract c : [SELECT id, AccountId, OwnerId, Opportunity__c FROM contract WHERE id IN :newlyCompletedContractIDs AND AccountId NOT IN :accountIDsOfMembersWithExistingCPEContracts ] )   
      
      newCPEContracts.add ( new contract (AccountId = c.AccountId,OwnerId = c.OwnerId,ContractTerm = 24, Opportunity__c = c.Opportunity__c,RecordTypeId = recTypeDevName2sObjectType2ID.get('Contract').get('CPE'),StartDate = startDt,Status = 'draft' ) ) ;
      insert newCPEContracts;
  
    List<Contact> lstContacts = [select Id, Name, Email_CPE_News__c, MailingCountry from contact where AccountID in :accountIDsOfMembersWithNewlyCompletedContracts];
    for(Contact con :lstContacts) {
        
    //if(con.MailingCountry != 'Canada') {
            con.Email_CPE_News__c = true;
    //}
    }
    
    update lstContacts;
      
 for ( contract c : newCPEContracts ) c.status = 'Activated ( Auto-Renew )' ;
    update newCPEContracts ;
  
 for( Contract c: newCPEContracts ) {
      newCPERequirements.add ( new Candidate_Requirement__c ( Candidate_Commitment__c = c.id, recordTypeID = recTypeDevName2sObjectType2ID.get('Candidate_Requirement__c').get('CPE'),Name = 'CPE', Status__c = 'Activated' )) ;    
    }
    insert newCPERequirements ;
    
  
    for ( Candidate_Requirement__c c : newCPERequirements )
      ContractID2reqID.put( c.Candidate_Commitment__c, c.id ) ;

    for ( Contract c: newCPEContracts ) {    
      newAttestRequirements.add ( new Candidate_Requirement__c ( Candidate_Commitment__c = c.id, recordTypeID = recTypeDevName2sObjectType2ID.get('Candidate_Requirement__c').get('Attest'),Prerequisite__c = ContractID2reqID.get( c.id ),Name = 'Attest', Status__c = 'Activated' )) ;  
    }    
    insert newAttestRequirements ;
  }
  system.debug(' setOpps==='+setOpps);
  if(setOpps.size() > 0)
  {
  system.debug(' mapContractDetails==='+mapContractDetails);
    List<Opportunity> lstOpps = new List<Opportunity>();
    for(Opportunity objOpp : [select id,ChargentSFA__Payment_Status__c,ChargentSFA__Payment_Frequency__c,ChargentSFA__Payment_Stop__c,ChargentSFA__Next_Transaction_Date__c,ChargentSFA__Manual_Charge__c,ChargentSFA__Charge_Amount__c,ChargentSFA__Payment_Start_Date__c from Opportunity where id in: setOpps])
    {
    system.debug(' objOpp==='+objOpp);
        objOpp.ChargentSFA__Payment_Status__c = 'Recurring';
        objOpp.ChargentSFA__Payment_Frequency__c = 'Annual';
        objOpp.ChargentSFA__Payment_Stop__c = 'Unending';
        objOpp.ChargentSFA__Manual_Charge__c = True;
        Contract con = mapContractDetails.get(objOpp.Id);
      //  objOpp.ChargentSFA__Next_Transaction_Date__c = con.Enddate;
        objOpp.ChargentSFA__Payment_Start_Date__c = con.Enddate;
        if(con.Membership_Type__c == 'Individual')
            objOpp.ChargentSFA__Charge_Amount__c = 195;
        else if(con.Membership_Type__c == 'Student')
            objOpp.ChargentSFA__Charge_Amount__c = 95;
        
        lstOpps.add(objOpp);
    }
    
    system.debug('Updated OPPS == '+lstOpps);
    
    update lstOpps;
  }

   if(setOpps1.size() > 0)
  {
  system.debug(' mapContractDetails==='+mapContractDetails);
    List<Opportunity> lstOpps = new List<Opportunity>();
    for(Opportunity objOpp : [select id,ChargentSFA__Payment_Status__c,ChargentSFA__Payment_Frequency__c,ChargentSFA__Payment_Stop__c,ChargentSFA__Next_Transaction_Date__c,ChargentSFA__Manual_Charge__c,ChargentSFA__Charge_Amount__c,ChargentSFA__Payment_Start_Date__c from Opportunity where id in: setOpps1])
    {
    system.debug(' objOpp==='+objOpp);
        objOpp.ChargentSFA__Payment_Status__c = 'Stopped';
       
        lstOpps.add(objOpp);
    }
    
    system.debug('Updated OPPS == '+lstOpps);
    
    update lstOpps;
  }


}