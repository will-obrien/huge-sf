trigger onAIAUProdRefunds on Product_Refunds__c (after insert,after update) {
    List<Product_Refunds__c> lstProdRefunds = new List<Product_Refunds__c>();
    Set<ID> setOpps = new Set<Id>();
    List<MembershipRefundCodes__c > refundCodes = MembershipRefundCodes__c.getall().values();
    Set<Id> setCancelEbooksOppIds = new Set<Id>();
    Set<Id> setCancelERPOppIds = new Set<Id>();
    Set<Id> setCancelFRMOppIds = new Set<Id>();
    Set<Id> setCancelFRMEAoppIds1 = new Set<Id>();
    Set<Id> setCancelFRMEAoppIds2 = new Set<Id>();
    Set<Id> setCancelERPEAOppIds = new Set<Id>();
    Set<Id> setCancelERPEAoppIds1 = new Set<Id>();
    Set<Id> setCancelERPEAoppIds2 = new Set<Id>();
    
    for(Product_Refunds__c obj : Trigger.new)
    {
        for(MembershipRefundCodes__c ref : refundCodes)
        {
            if(ref.Product_Code__c == obj.Product_Code__c)
            {
                if(trigger.isUpdate)
                {
                     if((obj.Status__c != trigger.oldMap.get(obj.Id).Status__c) && obj.Status__c == 'Completed' && (obj.Take_Membership__c || obj.Charge_Back__c))
                    {
                        lstProdRefunds.add(obj);
                        setOpps.add(obj.Opportunity__c);
                    }
                }
                else
                {
                     if(obj.Status__c == 'Completed' && (obj.Take_Membership__c || obj.Charge_Back__c))
                    {
                        lstProdRefunds.add(obj);
                        setOpps.add(obj.Opportunity__c);
                    }
                }
               
            }
        }
        
        if(obj.Cancel_E_book__c && obj.Status__c == 'Completed')
        {
            setCancelEbooksOppIds.add(obj.Opportunity__c);
        }
        
        if(obj.Cancel_ERP_Enrollment__c&& obj.Status__c == 'Completed')
            setCancelERPOppIds.add(obj.Opportunity__c);
        
         if(obj.Cancel_FRM_Enrollment__c && obj.Status__c == 'Completed')
            setCancelFRMOppIds.add(obj.Opportunity__c);
            
        if((obj.Cancel_FRM1__c ) && obj.Status__c == 'Completed')
            setCancelFRMEAoppIds1.add(obj.Opportunity__c);
       
        if((obj.Cancel_FRM2__c) && obj.Status__c == 'Completed')
            setCancelFRMEAoppIds2.add(obj.Opportunity__c);
        
        if(obj.Cancel_ERP__c && obj.Status__c == 'Completed')
            setCancelERPEAOppIds.add(obj.Opportunity__c);
           
        if(obj.Cancel_ERP1__c && obj.Status__c == 'Completed')
            setCancelERPEAoppIds1.add(obj.Opportunity__c);
            
        if(obj.Cancel_ERP2__c && obj.Status__c == 'Completed')
            setCancelERPEAoppIds2.add(obj.Opportunity__c);
           
    }
    
    Set<Id> setAccs = new Set<Id>();
    for(Opportunity opp: [select id,accountId from opportunity where id in: setOpps])
        setAccs.add(opp.accountId);
    if(!updateContractByRefunds.bRecursive)
        updateContractByRefunds.updateContractTerm(setAccs);
        
    if(!setCancelEbooksOppIds.isEmpty())
    {
        List<eBook_Key__c> lstEbooks = new List<eBook_Key__c>();
        for(eBook_Key__c eBook : [select id,Cancelled__c,Opportunity__c from eBook_Key__c where Opportunity__c in: setCancelEbooksOppIds])
        {
            eBook.Cancelled__c = true;
            lstEbooks.add(eBook);
        }
        
        if(!lstEbooks.isEmpty())
            update lstEbooks;
        
    } 
    
    if(!setCancelERPOppIds.isEmpty())
    {
        Set<Id> setAccountIds = new Set<Id>();
        for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelERPOppIds])
        {
            setAccountIds.add(opp.accountId);
        }
       // Id frmRecType = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
        Id erpRecType = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
        List<Contract> lstContracts = new List<Contract>();
        for(Contract ct : [select id,Status from contract where Status = 'Activated ( Auto-Renew )' and (recordTypeID =:erpRecType) and accountID in: setAccountIds])
        {
            ct.Status = 'Canceled';
            lstContracts.add(ct);
        }
        if(!lstContracts.isEmpty())
            update lstContracts;
    }   
    
     if(!setCancelFRMOppIds.isEmpty())
    {
        Set<Id> setAccountIds = new Set<Id>();
        for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelFRMOppIds])
        {
            setAccountIds.add(opp.accountId);
        }
        Id frmRecType = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
        //Id erpRecType = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
        List<Contract> lstContracts = new List<Contract>();
        for(Contract ct : [select id,Status from contract where Status = 'Activated ( Auto-Renew )' and (recordTypeID =:frmRecType) and accountID in: setAccountIds])
        {
            ct.Status = 'Canceled';
            lstContracts.add(ct);
        }
        if(!lstContracts.isEmpty())
            update lstContracts;
    }   
    
    if(!setCancelFRMEAoppIds1.isEmpty())
    {
       Set<Id> setoppids = new Set<Id>();
       List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
       
        for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelFRMEAoppIds1])
        {
            setoppids.add(opp.Id);
        }
       
        for(Exam_Attempt__c ea : [select id,Cancelled__c,Section__c,opportunity__C from Exam_Attempt__c where opportunity__C in: setoppids and Section__c ='FRM Part 1'])
        {
            ea.Cancelled__c = true;
            lstEA.add(ea);
        }
        if(!lstEA.isEmpty())
            update lstEA;
    }   
    
     if(!setCancelFRMEAoppIds2.isEmpty())
    {
       Set<Id> setoppids = new Set<Id>();
       List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
       
        for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelFRMEAoppIds2])
        {
            setoppids.add(opp.Id);
        }
       
        for(Exam_Attempt__c ea : [select id,Cancelled__c, Section__c ,opportunity__C from Exam_Attempt__c where opportunity__C in: setoppids and Section__c ='FRM Part 2'])
        {
            ea.Cancelled__c = true;
            lstEA.add(ea);
        }
        if(!lstEA.isEmpty())
            update lstEA;
    }   


     if(!setCancelERPEAoppIds1.isEmpty())
    {
       Set<Id> setoppids = new Set<Id>();
       List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
       
        for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelERPEAoppIds1])
        {
            setoppids.add(opp.Id);
        }
       
        for(Exam_Attempt__c ea : [select id,Cancelled__c,Section__c,opportunity__C from Exam_Attempt__c where opportunity__C in: setoppids and Section__c ='ERP Exam Part I'])
        {
            ea.Cancelled__c = true;
            lstEA.add(ea);
        }
        if(!lstEA.isEmpty())
            update lstEA;
    }   
    
     if(!setCancelERPEAoppIds2.isEmpty())
    {
       Set<Id> setoppids = new Set<Id>();
       List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
       
        for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelERPEAoppIds2])
        {
            setoppids.add(opp.Id);
        }
       
        for(Exam_Attempt__c ea : [select id,Cancelled__c, Section__c ,opportunity__C from Exam_Attempt__c where opportunity__C in: setoppids and Section__c ='ERP Exam Part II'])
        {
            ea.Cancelled__c = true;
            lstEA.add(ea);
        }
        if(!lstEA.isEmpty())
            update lstEA;
    }   
    
    
    if(!setCancelERPEAOppIds.isEmpty())
    {
        Set<Id> setoppids = new Set<Id>();
         List<Exam_Attempt__c> lstEA = new List<Exam_Attempt__c>();
        for(Opportunity opp : [select id,accountId from opportunity where id in: setCancelERPEAOppIds])
        {
            setoppids.add(opp.id);
        }
       
        for(Exam_Attempt__c ea : [select id,Cancelled__c,opportunity__C from Exam_Attempt__c where opportunity__C in: setoppids])
        {
            ea.Cancelled__c = true;
            lstEA.add(ea);
        }
        if(!lstEA.isEmpty())
            update lstEA;
    }   
    
}