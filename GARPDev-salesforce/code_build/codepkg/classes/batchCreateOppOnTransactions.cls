global class batchCreateOppOnTransactions implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
       String strRecurringStatus = 'Recurring';
       Date dtNextTransaction = System.today().addDays(-2);
       return Database.getQueryLocator('select id,ChargentSFA__Payment_Status__c ,ChargentSFA__Tokenization__c,pymt__Payments_Made__c,ChargentSFA__Payment_Count__c,ChargentSFA__Charge_Amount__c,ChargentSFA__Manual_Charge__c,ChargentSFA__Next_Transaction_Date__c,ChargentSFA__Payment_Start_Date__c ,ChargentSFA__Payment_End_Date__c ,ChargentSFA__Payment_Stop__c ,ChargentSFA__Charge_Date__c ,ChargentSFA__Payment_Frequency__c from Opportunity where ChargentSFA__Payment_Status__c =: strRecurringStatus and ChargentSFA__Next_Transaction_Date__c =: dtNextTransaction');
      
     }
    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
    
         List<Opportunity> lstOpportunities = new List<Opportunity>();
         Map<Id,Contract> mapContracts = new Map<Id,Contract>();
         for(Contract objContract : [select id,Membership_Type__c,Opportunity__c from Contract where Opportunity__c in: scope and Status =: 'Activated'])
          mapContracts.put(objContract.Opportunity__c,objContract);
         for(Opportunity obj : scope)
         {
            Opportunity oppNew = new Opportunity();
            oppNew.Cloned_From__c = obj.Id;
            oppNew.Auto_Renew__c = true;
            oppNew.Eligible_for_Membership_Extension__c = true;
            oppNew.StageName = 'New Lead';
            oppNew.ChargentSFA__Payment_Status__c = obj.ChargentSFA__Payment_Status__c;
            oppNew.ChargentSFA__Payment_Frequency__c = obj.ChargentSFA__Payment_Frequency__c;
            oppNew.ChargentSFA__Charge_Date__c = obj.ChargentSFA__Charge_Date__c;
            oppNew.ChargentSFA__Payment_Stop__c = obj.ChargentSFA__Payment_Stop__c;
            oppNew.ChargentSFA__Payment_End_Date__c = obj.ChargentSFA__Payment_End_Date__c;
            oppNew.ChargentSFA__Payment_Start_Date__c = obj.ChargentSFA__Payment_Start_Date__c;
            oppNew.ChargentSFA__Next_Transaction_Date__c = obj.ChargentSFA__Next_Transaction_Date__c;
            oppNew.ChargentSFA__Manual_Charge__c = obj.ChargentSFA__Manual_Charge__c;
            oppNew.ChargentSFA__Charge_Amount__c = obj.ChargentSFA__Charge_Amount__c;
            oppNew.ChargentSFA__Payment_Count__c = obj.ChargentSFA__Payment_Count__c;
            oppNew.pymt__Payments_Made__c = obj.pymt__Payments_Made__c;
            oppNew.ChargentSFA__Tokenization__c = obj.ChargentSFA__Tokenization__c;
            Contract con = mapContracts.get(obj.Id);
            if(con.Membership_Type__c == 'Individual')
              oppNew.ChargentSFA__Charge_Amount__c = 195;
            else if(con.Membership_Type__c == 'Student')
              oppNew.ChargentSFA__Charge_Amount__c = 95;

            //Update OLD opportunity status to Stopped
            obj.ChargentSFA__Payment_Status__c = 'Stopped';

            lstOpportunities.add(oppNew);
            lstOpportunities.add(obj);
         }
        try{
         upsert lstOpportunities;
        }catch(Exception ex){}
        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}