global class updateContracts implements Database.Batchable<SObject>
{
    global string memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    global string icbrrRecordType = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
    global string frmRecordType = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
    global string fbrRecordType = RecordTypeHelper.GetRecordTypeId('Contract','FBR Program');
    global string erpRecordType = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
    global string cpeRecordType = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
    Set<String> setStatus = new Set<String>{'Activated','Activated ( Auto-Renew )'};
    Date dtEndDate = system.today();    
    
    if(!test.isRunningTest())
        return Database.getQueryLocator('select id,AccountId,StartDate,enddate,All_Requirements_Completed__c,recordTypeId,recordType.Name,Membership_Type__c,ContractTerm,Status,ActivatedDate from Contract where Status  in: setStatus and EndDate <: dtEndDate  and ActivatedDate !=null');
    else
        return Database.getQueryLocator('select id,AccountId,StartDate,enddate,All_Requirements_Completed__c,recordTypeId,recordType.Name,Membership_Type__c,ContractTerm,Status from Contract  ');
        
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contract> scope){
    
       List<Contract> lstContract = new List<Contract>();
     
        for(Contract con : scope)
        {
           
       if(con.recordTypeId == memRecordType)
            {
               
                if(con.Membership_Type__c == 'Affiliate')
                    con.ContractTerm += 24;
                else if((con.Membership_Type__c == 'Student' || con.Membership_Type__c == 'Individual') && (con.Status == 'Activated' || con.Status=='Activated ( Auto-Renew )'))
                {
                    if(con.Status=='Activated ( Auto-Renew )')
                    {
                        Date endDate = con.Enddate;
                        Date todayDate = system.today();
                        Integer numberDaysDue = endDate.daysBetween(todayDate);
                        if(numberDaysDue >= 4)
                            con.Status = 'Expired';
                    }
                    else
                        con.Status = 'Expired';
                }
                
                lstContract.add(con);
            }
           
        else if(con.recordTypeId == icbrrRecordType || con.recordTypeId == frmRecordType || con.recordTypeId == fbrRecordType ||  con.recordTypeId == erpRecordType)
       {
           if((con.recordTypeId == frmRecordType ||  con.recordTypeId == erpRecordType &&(con.Status=='Activated ( Auto-Renew )')) )
           
            con.ContractTerm += 12;
           
         else    
                con.Status = 'Expired';
               lstContract.add(con);
             }
        }
        update lstContract;
        }
     
    global void finish(Database.BatchableContext BC){
         
       
    }

}