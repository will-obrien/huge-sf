global class chargemodificationsonopp implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
       Set<String> setStatus = new Set<String>{'Recurring'};
       
       
       return Database.getQueryLocator('select id,accountId,ChargentSFA__Payment_Status__c ,ChargentSFA__Tokenization__c,ChargentSFA__Payment_Count__c,ChargentSFA__Charge_Amount__c,ChargentSFA__Manual_Charge__c,ChargentSFA__Next_Transaction_Date__c,ChargentSFA__Payment_Start_Date__c ,ChargentSFA__Payment_End_Date__c ,ChargentSFA__Payment_Stop__c ,ChargentSFA__Charge_Date__c ,ChargentSFA__Payment_Frequency__c from Opportunity where ChargentSFA__Payment_Status__c in : setStatus ');
      
     }
    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
    
         List<Opportunity> lstOpportunities = new List<Opportunity>();
         Map<Id,Contract> mapContracts = new Map<Id,Contract>();
          id memRecTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
         Set<Id> setAccIds = new Set<Id>();
         for(Opportunity obj : scope)
         {
            setAccIds.add(obj.accountId);

         }

         AggregateResult[] groupedResults = [select SUM(ContractTerm) term,accountId from Contract where accountId in : setAccIds and recordTypeId = : memRecTypeId and Membership_Type__c = 'Student' group by accountId];

         Map<Id,boolean> mapContacts = new Map<Id,boolean>();

         /*for(Contact objContact : [select id,accountId,KPI_FRM_Certified__c,KPI_ERP_Certified__c from Contact where accountId in: setAccIds])
         {
            if(objContact.KPI_FRM_Certified__c || ObjContact.KPI_ERP_Certified__c)
                mapContacts.put(objContact.accountID,true);
                system.debug('****:'+mapContacts);

         }*/
         Id frmRecType = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
         Id erpRecType = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
   
         for(Contract ct : [select id,name,accountId,Status from contract where accountId =: setAccIds and Status =: 'Completed' and (recordTypeId =: frmRecType or recordTypeId =: erpRecType)])
         {
             mapContacts.put(ct.accountID,true);
         }



        Map<Id,Decimal> mapAccountTerm = new Map<Id,Decimal>();
        for (AggregateResult Result: groupedResults)
        {
            mapAccountTerm.put((Id)Result.get('accountId'),(Decimal) Result.get('term'));

        }
        
        List<Opportunity> lstUpdateOpps = new List<Opportunity>();
        for(Opportunity objUpdate : scope)
        {
            if(mapContacts.get(objUpdate.accountID) != null)
            {
                objUpdate.ChargentSFA__Charge_Amount__c = 150;
                lstUpdateOpps.add(objUpdate);
            }
                
           
           else if( mapAccountTerm.get(objUpdate.accountId) >= 24 )
            {
                objUpdate.ChargentSFA__Charge_Amount__c = 195;
                lstUpdateOpps.add(objUpdate);
            }

           
        }



        try{
         
            update lstUpdateOpps;

        }catch(Exception ex){}
        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}