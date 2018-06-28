global class createaffiliatecontract implements Database.Batchable<SObject>
{
    global set <Id> setContractIds = new Set <Id> ();
    global Id memRecType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    global Id memberRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact','Member');
    Date dt = Date.today().addmonths(-6);
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator('select id,accountId,Date_Joined__c from Contact where GARP_Member_ID__c!=null and recordTypeId =: memberRecordTypeId and  accountId != null and  createddate >: dt order by accountId ASC ');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){

        Map<Id,Date> mapAcct = new Map<Id,Date>();
        for(Contact ct : scope)
            mapAcct.put(ct.accountId,ct.Date_Joined__c);

        system.debug('mapAcct == '+mapAcct);
        List<Contract> lstContract = new List<Contract>();
        decimal dCount = 0;
        Id recType = null;
        Map<Id,Id> mapAcctsWithOutMemership = new Map<Id,Id>();
        Set<Id> setIgnoreAccountIds = new Set<Id>();
        Map<Id,Id> mapAccountIds = new Map<Id,Id>();
        for(Contract cont : [select id,accountId,recordTypeId,ActivatedDate from Contract where accountId in:  mapAcct.keyset() and recordTypeId =:memRecType])
        {
         
         if(cont.ActivatedDate != null)
         {
            setIgnoreAccountIds.add(cont.accountId);
         }
         else
         {
            if(!setIgnoreAccountIds.contains(cont.accountId))
                mapAccountIds.put(cont.accountId,cont.accountId);
         }
            
        

        }
        system.debug('mapAccountIds == '+mapAccountIds);
        List<Opportunity> lstOpps = new List<Opportunity>();
        for(Id acc : mapAcct.keySet())
        {
            //Check if this account has already member ship contract then dont create a new contract
            if(!setIgnoreAccountIds.contains(acc))
            {
                Contract cont = new Contract();
                
                cont.accountId = acc;
                Date startDate = date.newInstance(1999, 01, 01);
                cont.StartDate = mapAcct.get(acc) == null ?  startDate : mapAcct.get(acc);
                Date dtToday = System.today();

                 Date dtStartDate = cont.StartDate; 
                 Integer iDiffMnths =dtStartDate.monthsBetween(dtToday); 
                 system.debug('iDiffMnths== '+iDiffMnths);
                 cont.ContractTerm = iDiffMnths + 12; 
                 system.debug('cont.ContractTerm == '+cont.ContractTerm);
                cont.Membership_Type__c ='Affiliate';
                cont.recordTypeId = memRecType;
                lstContract.add(cont);
                
                Opportunity opp = new Opportunity(StageName='New Lead',accountId=acc,Name='Garp Purchase',CloseDate=system.today());
                lstOpps.add(opp);
            }
        }
        system.debug('lstContract == '+lstContract);
        
        Map<Id,Opportunity> mapOppByAccount = new Map<Id,Opportunity>();
        if(lstOpps.size() > 0)
        {
            insert lstOpps;
            PriceBookEntry PricebookEntryId = [select unitprice, productcode, product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode = 'AFREE' and product2.Gl_Code__c = '4999' and isActive = true];
            List<OpportunityLineItem> lstOppLines = new List<OpportunityLineItem>();
            for(Opportunity opp : lstOpps)
            {
                mapOppByAccount.put(opp.accountId,opp);
                OpportunityLineItem oppLine = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId  = PricebookEntryId.Id,Quantity =1,TotalPrice =0);
                lstOppLines.add(oppLine);
            }
            
            if(lstOppLines.size() > 0)
                insert lstOppLines;
        }
        
        if(lstContract.size() > 0)
        {
            for(Contract ct : lstContract)
                ct.Opportunity__c = mapOppByAccount.get(ct.accountId).Id;
                
            insert lstContract;
        }

        List<Contract> lstActivateContracts = new List<Contract>();
        List<Contract> lstActivateContracts1 = [select id,ActivatedDate,Status,Clone_from__c,accountId from Contract where Id in: lstContract and Status =: 'Draft' ];
        
        for(Contract objCon : lstActivateContracts1)
        {
            
            objCon.Status = 'Activated ( Auto-Renew )';
            lstActivateContracts.add(objCon);
        
        }
       
       update lstActivateContracts;
    }
        
    global void finish(Database.BatchableContext BC){
         
       
    }

}