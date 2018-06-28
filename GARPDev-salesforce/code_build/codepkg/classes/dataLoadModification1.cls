global class dataLoadModification1 implements Database.Batchable<SObject>
{
    
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        Set<Id> setRecordTypes = new Set<Id>();
        setRecordTypes.add(RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program'));
        setRecordTypes.add(RecordTypeHelper.GetRecordTypeId('Contract','FRM Program'));
        setRecordTypes.add(RecordTypeHelper.GetRecordTypeId('Contract','FBR Program'));
        setRecordTypes.add(RecordTypeHelper.GetRecordTypeId('Contract','ERP Program'));
        setRecordTypes.add(RecordTypeHelper.GetRecordTypeId('Contract','CPE'));

        return Database.getQueryLocator('select id, Status, RecordTypeId,Name from contract where recordTypeId in: setRecordTypes');
        
     }
    
    
    global void execute(Database.BatchableContext BC, List<contract> scope){
    
       
        
        List<Contract> lstContract = new List<Contract>();
        for(Contract objContract : scope)
        {
            objContract.Status = 'Activated ( Auto-Renew )';
            lstContract.add(objContract);
            
        }
        
        update lstContract;
        
    }
   
    
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}