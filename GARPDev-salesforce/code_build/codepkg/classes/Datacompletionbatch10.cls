global class Datacompletionbatch10 implements Database.Batchable<SObject>
{   
     
    global Id cpeRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
    global Id attestRecType = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Attest');
   
    global Database.QueryLocator start(Database.BatchableContext BC){
        String strStatus = 'Activated ( Auto-Renew )';
        //Date strDate = system.today();
        //date today = date.newInstance(strDate.year(), strDate.month(), strDate.day());


        String strCRStatus = 'Completed';

        return Database.getQueryLocator('select id,Status__c,Candidate_Commitment__c,Candidate_Commitment__r.EndDate from Candidate_Requirement__c where Candidate_Commitment__r.recordTypeId =: cpeRecordTypeID and Status__c =:  strCRStatus and recordTypeId =: attestRecType');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Candidate_Requirement__c> scope){
        system.debug('scope == '+scope);
         Date strDate = system.today();
        date today = date.newInstance(strDate.year(), strDate.month(), strDate.day());
         Set<Id> setId = new Set<Id>();
        for(Candidate_Requirement__c obj : scope)
        {
            System.debug('obj.Candidate_Commitment__r.EndDate == '+obj.Candidate_Commitment__r.EndDate);
            System.debug('system.today() == '+system.today());
            if(obj.Candidate_Commitment__r.EndDate <= today)
            {
                System.debug('IN the Loop');
                setId.add(obj.Candidate_Commitment__c);
            }
            
            //System.debug('Conditon == '+obj.Candidate_Commitment__r.EndDate <= today);
        }
        List<Contract> lstCons = new List<Contract>();
       
        /*for(Candidate_Requirement__c obj : scope)
        {
            setId.add(obj.Candidate_Commitment__c);

            
        }*/

        for(Contract ct : [select id,Status from Contract where id in: setId])
        {

            ct.Status = 'Completed';
            lstCons.add(ct);
        }

        if(lstCons.size() > 0)
            update lstCons;


    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}