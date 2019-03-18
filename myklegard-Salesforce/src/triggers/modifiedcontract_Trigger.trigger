trigger modifiedcontract_Trigger on Modify_Contract__c (after insert, after update,after delete) {
	List<Modify_Contract__c> modifycontract = new List<Modify_Contract__c>();
	List<Contracts__c> changeContracts = new List<Contracts__c>();    
    for(Modify_Contract__c mcObj: Trigger.new){
        modifycontract = [select Id,Status__c,Amount__c,Terms_Conditions__c,Project_Completion_Date__c,Project_Funding__c,Use_of_Funds__c from Modify_Contract__c where Id =: mcObj.Id];
    }
            
  for(Modify_Contract__c mc:modifycontract)
  {  
     List<Contracts__c> con =[select Id,Amount__c,Project_Completion_Date__c,Terms_Conditions__c from Contracts__c where Id=:mc.Use_of_Funds__c ];
      for(Contracts__c c:con)  
      {
	       if(mc.Status__c=='Approved'){
	      c.Amount__c=mc.Amount__c;
	      c.Project_Completion_Date__c=mc.Project_Completion_Date__c;
	      c.Terms_Conditions__c=mc.Terms_Conditions__c;
	       changeContracts.add(c);
           }
      }
  }
  
  if(changeContracts.size()>0){
  	update changeContracts;
  }
 }