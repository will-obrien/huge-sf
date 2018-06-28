global class Datacompletionbatch3 implements Database.Batchable<SObject>
{
    global string memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    global string cpeRecordType = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
    global string wileyRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Wiley Bookstore');
   global Database.QueryLocator start(Database.BatchableContext BC){
         Set<String> setStatus = new Set<String>{'Expired'};
         Set<String> setRecTypes = new Set<String>{memRecordType,cpeRecordType,wileyRecordType};
         Date dtEndDate = system.today();
        return Database.getQueryLocator('select id,AccountId,StartDate,enddate,All_Requirements_Completed__c,recordTypeId,recordType.Name,Membership_Type__c,ContractTerm,Status from Contract where Status Not in: setStatus and EndDate <: dtEndDate and recordTypeId in: setRecTypes');
        
          
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contract> scope){
        List<Contract> lstCon = new List<Contract>();
        for(Contract obj : scope)
        {
             obj.Status = 'Expired';
             lstCon.add(obj);
            
        }
        
        if(lstCon.size() > 0)
            update lstCon;
        

        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}