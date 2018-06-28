public class CreateRecurringOpps
{
    public static boolean bIsRecursive = false;
    
    public static void CreateOpps(Set<Id> oppIds,List<ChargentSFA__Transaction__c> lstChargents)
    {
    system.debug('lstChargents == '+lstChargents);
    bIsRecursive = true;    
        List<Opportunity> lstNewOpps = new List<Opportunity>();
    
    //Check opp stage name is recurring intent then call this directly else check for count of of transaction count for this opp and if it has more than one then it should fire
    //Current transaction update opportunity with the clone opp id
    Set<String> setProdCodes = new Set<String>{'MEMI','MEMS','MEMC'};
    Map<String,PriceBookEntry> mapPirceBooks = new Map<String,PriceBookEntry>();
    for(PriceBookEntry objPriceBook : [select unitprice, productcode, product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode in : setProdCodes and isActive = true])
    {
        mapPirceBooks.put(objPriceBook.productcode,objPriceBook);
    }
    
    
    //Check if transaction is already exists for this opp
    Map<Id,ChargentSFA__Transaction__c> mapExistTransactions = new Map<Id,ChargentSFA__Transaction__c>();
    for(ChargentSFA__Transaction__c objCharge : [select id,name,ChargentSFA__Opportunity__c from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c in :oppIds and ChargentSFA__Type__c =: 'Charge' and ChargentSFA__Response_Status__c =: 'Approved'])
    {
        mapExistTransactions.put(objCharge.ChargentSFA__Opportunity__c,objCharge);
    }
    Id memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    Map<Id,Contract> mapContractToOpp = new Map<Id,Contract>();
    for(Contract ct : [select id,Opportunity__c from Contract where Opportunity__c in: oppIds and recordTypeId =: memRecordType])
    {
        mapContractToOpp.put(ct.Opportunity__c,ct);
    }
    Map<Id,Id> mapOppCloneIds = new Map<Id,Id>();
    for(Opportunity objOpp : [select id,name,accountId , Cross_Check__c ,ChargentSFA__Billing_Zip__c,ChargentSFA__Billing_State__c,ChargentSFA__Billing_Postcode__c,ChargentSFA__Billing_Phone__c,ChargentSFA__Billing_First__c,ChargentSFA__Billing_Last__c,ChargentSFA__Billing_Email__c,ChargentSFA__Billing_Fax__c,ChargentSFA__Billing_Company__c,ChargentSFA__Billing_Country__c,ChargentSFA__Billing_Address__c,ChargentSFA__Billing_City__c,ChargentSFA__Payment_Status__c,Cloned_From__c,CloseDate,StageName,Auto_Renew__c,Eligible_for_Membership_Extension__c,ChargentSFA__Charge_Amount__c,ChargentSFA__Tokenization__c from Opportunity where id in : oppIds])
    {
       
        
        if(mapExistTransactions.get(objOpp.Id) != null || objOpp.StageName == 'Recurring Intent')
        {
            Opportunity objClone = objOpp.Clone();
            objClone.Eligible_for_Membership_Extension__c = true;
            objClone.Cross_Check__c = true;
            objClone.Auto_Renew__c = true;
            objClone.ChargentSFA__Payment_Status__c = '';
            objClone.Cloned_From__c = objOpp.Id;
            objClone.accountId = objOpp.accountId;
            objClone.StageName = 'New Lead';
            objClone.ChargentSFA__Tokenization__c = objOpp.ChargentSFA__Tokenization__c;
            objClone.ChargentSFA__Manual_Charge__c = true;
            objClone.CloseDate=system.today();
            objClone.ChargentSFA__Billing_Address__c = objClone.ChargentSFA__Billing_Address__c;
            objClone.ChargentSFA__Billing_City__c    = objClone.ChargentSFA__Billing_City__c;
            objClone.ChargentSFA__Billing_Company__c = objClone.ChargentSFA__Billing_Company__c;
            objClone.ChargentSFA__Billing_Country__c = objClone.ChargentSFA__Billing_Country__c;
            objClone.ChargentSFA__Billing_Email__c   = objClone.ChargentSFA__Billing_Email__c;
            objClone.ChargentSFA__Billing_Fax__c     = objClone.ChargentSFA__Billing_Fax__c;
            objClone.ChargentSFA__Billing_Last__c    = objClone.ChargentSFA__Billing_Last__c;
            objClone.ChargentSFA__Billing_First__c   = objClone.ChargentSFA__Billing_First__c;
            objClone.ChargentSFA__Billing_Phone__c   = objClone.ChargentSFA__Billing_Phone__c;
            objClone.ChargentSFA__Billing_Postcode__c= objClone.ChargentSFA__Billing_Postcode__c;
            objClone.ChargentSFA__Billing_State__c   = objClone.ChargentSFA__Billing_State__c;
            objClone.ChargentSFA__Billing_Zip__c     = objClone.ChargentSFA__Billing_Zip__c;
            
            lstNewOpps.add(objClone);
            
            
        }
        
    }
    system.debug('lstNewOpps == '+lstNewOpps);
    if(lstNewOpps.size() > 0)
        insert lstNewOpps;
        
    List<Opportunity> updateOpps = new List<Opportunity>();
      List<Contract> updateCOntratcs = new List<Contract>();
      Set<Id> setOppsToUpdateStatus = new Set<ID>();
      List<Opportunity> lstOppStatusUpdates = new List<Opportunity>();
    List<OpportunityLineItem> lstNewOppLineItems = new List<OpportunityLineItem>();
    for(Opportunity objClonedOpp : [select id,name,Cloned_From__c,ChargentSFA__Payment_Status__c,CloseDate,StageName,Auto_Renew__c,Eligible_for_Membership_Extension__c,ChargentSFA__Charge_Amount__c from Opportunity where id in : lstNewOpps])
    {
        setOppsToUpdateStatus.add(objClonedOpp.Cloned_From__c);
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = objClonedOpp.Id;
        oppLineItem.Quantity = 1;
        system.debug('objClonedOpp == '+objClonedOpp);
        if(objClonedOpp.ChargentSFA__Charge_Amount__c == 195)
        {
            oppLineItem.PricebookEntryId = mapPirceBooks.get('MEMI').Id;
            oppLineItem.UnitPrice =  mapPirceBooks.get('MEMI').unitprice;
            lstNewOppLineItems.add(oppLineItem);
        }
        else if(objClonedOpp.ChargentSFA__Charge_Amount__c == 95)
        {
            oppLineItem.PricebookEntryId = mapPirceBooks.get('MEMS').Id;
            oppLineItem.UnitPrice =  mapPirceBooks.get('MEMS').unitprice;
            lstNewOppLineItems.add(oppLineItem);
        }
        else if(objClonedOpp.ChargentSFA__Charge_Amount__c == 150)
        {
            oppLineItem.PricebookEntryId = mapPirceBooks.get('MEMC').Id;
            oppLineItem.UnitPrice =  mapPirceBooks.get('MEMC').unitprice;
            lstNewOppLineItems.add(oppLineItem);
        }
        
        if(mapContractToOpp.containsKey(objClonedOpp.Cloned_From__c))
        {
            Contract objCon = mapContractToOpp.get(objClonedOpp.Cloned_From__c);
            objCon.Opportunity__c = objClonedOpp.Id;
            updateCOntratcs.add(objCon);
        }
        
        mapOppCloneIds.put(objClonedOpp.Cloned_From__c,objClonedOpp.Id);
        objClonedOpp.StageName = 'Closed';
        updateOpps.add(objClonedOpp);
    
    }
    system.debug('lstNewOppLineItems == '+lstNewOppLineItems);
     system.debug('updateOpps == '+updateOpps);
    if(lstNewOppLineItems.size() > 0)
        insert lstNewOppLineItems;
        
    if(updateOpps.size() > 0)
        update updateOpps;
        
    if(updateCOntratcs.size() > 0)
        update updateCOntratcs;
     
    for(Opportunity opp : [select id,ChargentSFA__Payment_Status__c,ChargentSFA__Tokenization__c from opportunity where id in: setOppsToUpdateStatus])
    {
        opp.ChargentSFA__Payment_Status__c = 'Stopped';
        opp.ChargentSFA__Tokenization__c = '';
        lstOppStatusUpdates.add(opp);
    }
    
    if(lstOppStatusUpdates.size() > 0)
        update lstOppStatusUpdates;
    system.debug('mapOppCloneIds :'+mapOppCloneIds);
    if(mapOppCloneIds.size() > 0)
    {
        List<ChargentSFA__Transaction__c> lstTransactions = new List<ChargentSFA__Transaction__c>();
        for(ChargentSFA__Transaction__c obj : [select id,ChargentSFA__Opportunity__c from ChargentSFA__Transaction__c where id in: lstChargents])
        {
        system.debug('Transaction :'+obj);
            obj.ChargentSFA__Opportunity__c = mapOppCloneIds.get(obj.ChargentSFA__Opportunity__c);
            lstTransactions.add(obj);
        }
        system.debug('lstTransactions :'+lstTransactions);
        update lstTransactions;
    }
    }
}