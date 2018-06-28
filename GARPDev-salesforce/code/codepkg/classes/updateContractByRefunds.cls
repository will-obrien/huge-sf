public class updateContractByRefunds
{
    public static boolean bRecursive = false;
    
    public static void updateContractTerm(Set<id> setAccounts)
    {
    bRecursive = true;
        string memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
        
         List<Contract> lstContracts = new List<Contract>();
            for(Contract con : [select id,EndDate,ContractTerm,Technically_Zero__c from Contract where recordTypeId =: memRecordType and (Status =: 'Activated' or Status =: 'Activated ( Auto-Renew )') and AccountId in: setAccounts])
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
             system.debug('lstContracts == '+lstContracts);
            if(!lstContracts.isEmpty())
                update lstContracts;    
        
    }
}