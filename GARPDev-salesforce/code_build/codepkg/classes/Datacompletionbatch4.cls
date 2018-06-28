global class Datacompletionbatch4 implements Database.Batchable<SObject>
{
    global Map <Id,Candidate_Requirement__c> mapDetails = new Map <Id,Candidate_Requirement__c> ();
    global set <Id> setContractIds = new Set <Id> ();
    global Id examRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Exam');
    global Id jobRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Job Experience');
    global Id frmRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
    global Id erpRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Date_of_Completion__c,Status__c, Exam__c,RecordTypeId,Candidate_Commitment__c from Candidate_Requirement__c');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Candidate_Requirement__c> scope){

        for (Candidate_Requirement__c obj : scope) {
        
        if (obj.Status__c == 'Completed' && (obj.RecordTypeId == examRecordTypeID || obj.RecordTypeId == jobRecordTypeID)) {
            
            system.debug('* * * Add CR:' + obj);
            
            setContractIds.add(obj.Candidate_Commitment__c);
            mapDetails.put(obj.Candidate_Commitment__c, obj);  
         }
    }
    
    if (setContractIds.size() > 0) {
        map < Id,boolean > mapAllCompleted = new map < Id, boolean > ();
        for (Candidate_Requirement__c objCandReq : [select id, Status__c, RecordTypeId, Candidate_Commitment__c, Date_of_Completion__c, Name from Candidate_Requirement__c where Candidate_Commitment__c in : setContractIds]) {
            
            system.debug('* * * Loop CR:' + objCandReq);
            
            Boolean comp = mapAllCompleted.get(objCandReq.Candidate_Commitment__c);
            
            if(comp == null)
                mapAllCompleted.put(objCandReq.Candidate_Commitment__c, true);
            
            if (objCandReq.Status__c != 'Completed')
                mapAllCompleted.put(objCandReq.Candidate_Commitment__c, false);
        }
        
        system.debug('* * * mapAllCompleted:' + mapAllCompleted);
        
        List < Contract > lstContracts = new List < Contract > ();
       
        for (Contract objCon : [select id, AccountId, recordTypeId, recordType.Name, Status, Membership_Type__c, ContractTerm, EndDate, StartDate, All_Requirements_Completed__c, All_Requirements_Completed_Date__c from Contract where id in : setContractIds]) {
           
            Candidate_Requirement__c objCR = mapDetails.get(objCon.Id);
            
            system.debug('* * * Loop Contract:' + objCon);
            system.debug('* * * Loop Contract CR:' + objCR);
            
            Boolean allCompleted = mapAllCompleted.get(objCon.Id);
           
            //if (objCR.Name == 'Pass ERP' || objCR.Name == 'Pass FRM2') {
           
            
            if (objCR.RecordTypeId == examRecordTypeID && objCon.RecordTypeId == frmRecordTypeID && objCR.Exam__c == 'FRM Part I') {
                
                system.debug('* * * In 2');
                
                Date dtCurrentDay = objCR.Date_of_Completion__c;
                Date dtEndDate = objCon.StartDate;
                Integer iDiffMnths =dtEndDate.monthsBetween(dtCurrentDay);
                objCon.ContractTerm = iDiffMnths + 48;
                objcon.Status = 'Activated';
            }
             
             else if (objCR.RecordTypeId == examRecordTypeID && (objCon.RecordTypeId == erpRecordTypeID || (objCon.RecordTypeId == frmRecordTypeID && (objCR.Exam__c == 'FRM Part II' || objCR.Exam__c == 'FRM Full')))) {
                
                system.debug('* * * In 1');
                
                Date dtCurrentDay = objCR.Date_of_Completion__c;
                Date dtEndDate = objCon.StartDate;
                Integer iDiffMnths =dtEndDate.monthsBetween(dtCurrentDay);
                 objCon.ContractTerm = iDiffMnths + 60;
                 objcon.Status = 'Activated';
                 
               
            } 
            if (objCR.RecordTypeId == jobRecordTypeID || allCompleted == true) {
                
                system.debug('* * * In 3');
                
                objCon.Status = 'Completed';
                objCon.All_Requirements_Completed__c = true;
                objCon.All_Requirements_Completed_Date__c = objCR.Date_of_Completion__c;
            }
                
            lstContracts.add(objCon);
        }
 
        update lstContracts;
    }
        

        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}