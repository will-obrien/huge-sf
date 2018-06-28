trigger onAIAUProdRefunds on Product_Refunds__c (after insert,after update) {
    List<Product_Refunds__c> lstProdRefunds = new List<Product_Refunds__c>();
    Set<ID> setOpps = new Set<Id>();
    List<MembershipRefundCodes__c > refundCodes = MembershipRefundCodes__c.getall().values();
    for(Product_Refunds__c obj : Trigger.new)
    {
        for(MembershipRefundCodes__c ref : refundCodes)
        {
            if(ref.Product_Code__c == obj.Product_Code__c)
            {
                
               if(obj.Status__c == 'Completed' && obj.Take_Membership__c)
                {
                    lstProdRefunds.add(obj);
                    setOpps.add(obj.Opportunity__c);
                }
            }
        }
        
    }
    
    Set<Id> setAccs = new Set<Id>();
    for(Opportunity opp: [select id,accountId from opportunity where id in: setOpps])
        setAccs.add(opp.accountId);

    
    string memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    List<Contract> lstContracts = new List<Contract>();
    for(Contract con : [select id,EndDate,ContractTerm,Technically_Zero__c from Contract where recordTypeId =: memRecordType and (Status =: 'Activated' or Status =: 'Activated ( Auto-Renew )') and AccountId in: setAccs])
    {
        integer iTerm =  con.ContractTerm - 12;
        if(iTerm <= 0)
        {
            iTerm = 1;
            con.ContractTerm = iTerm;
            con.Technically_Zero__c = true;
            Date dtConEndDate = con.EndDate;
            dtConEndDate = dtConEndDate.addMonths(-12);
            Date dtToday = Date.today();
            if(dtToday > dtConEndDate)
                con.status = 'Expired';
        }
        else
        {
            con.ContractTerm = iTerm;
            Date dtConEndDate = con.EndDate;
            dtConEndDate = dtConEndDate.addMonths(-12);
            Date dtToday = Date.today();
            if(dtToday < dtConEndDate)
           
            con.status = 'Activated';
            
            if(dtToday > dtConEndDate)
                con.status = 'Expired';
        }
        lstContracts.add(con);
        
    }
    
    if(!lstContracts.isEmpty())
        update lstContracts;
    
    

}