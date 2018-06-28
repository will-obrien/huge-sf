@isTest
private class testforAllRequirementsCompleteTrigger {
   
      static testMethod void testforAllRequirementsCompleteTrigger(){
      id recType4CPEContracts = [SELECT id FROM RecordType WHERE SobjectType = 'Contract' and DeveloperName = 'CPE' LIMIT 1 ].id ;
      id recType4ERPContracts = [SELECT id FROM RecordType WHERE SobjectType = 'Contract' and DeveloperName = 'ERP_Program' LIMIT 1 ].id ;
      id recType4FRMContracts = [SELECT id FROM RecordType WHERE SobjectType = 'Contract' and DeveloperName = 'FRM_Program' LIMIT 1 ].id ;
    
          
          // Create an account so that we can create a member
          account a = new account(
            name = 'test account' ) ;
          insert a ;
          
          // Create a member for test
          contact c = new contact( 
            lastName = 'last',
            account = a ) ;
          insert c ;
          
          //  Create new contract 
          contract contract = new contract (
            AccountId = a.Id,
            ContractTerm = 24,
            RecordTypeId = recType4CPEContracts,
            StartDate = date.newInstance(date.today().year(), 1, 1 ),
            Status = 'draft'  ) ;
          insert contract ;

          // Create new requirement
          Candidate_Requirement__c req = new Candidate_Requirement__c ( 
            Candidate_Commitment__c = contract.id, 
            Name = 'CPE', 
            Status__c = 'Activated' ) ;
          insert req ;

          //Now insert data causing the Venue SetRoomSatus trigger to fire.
          Test.startTest();

          req.Status__c = 'Completed' ;
          update req ;

          Test.stopTest();   
      }  
  }