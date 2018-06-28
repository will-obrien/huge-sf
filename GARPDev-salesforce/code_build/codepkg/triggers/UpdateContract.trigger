trigger UpdateContract on Candidate_Requirement__c(after update) {

    Map < Id,Candidate_Requirement__c > mapDetails = new Map < Id,Candidate_Requirement__c > ();
    set < Id > setContractIds = new Set < Id > ();
    
    Id examRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Exam');
    Id jobRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Job Experience');
    Id frmRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
    Id erpRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
    
    for (Candidate_Requirement__c obj : trigger.new) {
        
   // if (obj.Status__c == 'Completed' && (obj.RecordTypeId == examRecordTypeID || obj.RecordTypeId == jobRecordTypeID)) {
   //if (obj.Status__c == 'Completed' && trigger.oldMap.get(obj.Id).Status__c != obj.Status__c && (obj.RecordTypeId == examRecordTypeID || obj.RecordTypeId == jobRecordTypeID)) {
   if((trigger.oldMap.get(obj.Id).Status__c != obj.Status__c && (obj.RecordTypeId == examRecordTypeID || obj.RecordTypeId == jobRecordTypeID)) ||
      (trigger.oldMap.get(obj.Id).Certificate_Sent_Date__c != obj.Certificate_Sent_Date__c)){
            
            system.debug('* * * Add CR:' + obj);
            
            setContractIds.add(obj.Candidate_Commitment__c);
            mapDetails.put(obj.Candidate_Commitment__c, obj);  
         }
    }
    
    if (setContractIds.size() > 0) {
        map < Id,boolean > mapAllCompleted = new map < Id, boolean > ();
        map < Id,Candidate_Requirement__c > dbCR = new map < Id, Candidate_Requirement__c > ();
        for (Candidate_Requirement__c objCandReq : [select id, Name, Status__c, RecordTypeId, Candidate_Commitment__c, Certificate_Sent_Date__c, Date_of_Completion__c, Date_of_Ready_for_Review__c, Date_of_Failed_Review__c from Candidate_Requirement__c where Candidate_Commitment__c in : setContractIds]) {
            
            system.debug('* * * Loop CR:' + objCandReq);
            dbCR.put(objCandReq.Id, objCandReq);
            
            Boolean comp = mapAllCompleted.get(objCandReq.Candidate_Commitment__c);
            
            
            if(objCandReq.RecordTypeId == jobRecordTypeID && objCandReq.Status__c == 'Completed') {
                mapAllCompleted.put(objCandReq.Candidate_Commitment__c, true);            
            }

        }
        
        system.debug('* * * mapAllCompleted:' + mapAllCompleted);
        
        List < Contract > lstContracts = new List < Contract > ();
        MAP <ID, Candidate_Requirement__c> mapFRMAccountCR = new MAP <ID, Candidate_Requirement__c>();
        MAP <ID, Candidate_Requirement__c> mapERPAccountCR = new MAP <ID, Candidate_Requirement__c>();
        
        for (Contract objCon : [select id, AccountId, recordTypeId, recordType.Name, Status, Membership_Type__c, ContractTerm, EndDate, StartDate, All_Requirements_Completed__c, All_Requirements_Completed_Date__c from Contract where id in : setContractIds]) {
           
            Candidate_Requirement__c objCR = mapDetails.get(objCon.Id);
            
            if(objCR.Status__c == 'Completed') {
            
                system.debug('* * * Loop Contract:' + objCon);
                system.debug('* * * Loop Contract CR:' + objCR);
                
                Boolean allCompleted = mapAllCompleted.get(objCon.Id);
               
                //if (objCR.Name == 'Pass ERP' || objCR.Name == 'Pass FRM2') {
                if (objCR.RecordTypeId == examRecordTypeID && (objCon.RecordTypeId == erpRecordTypeID || (objCon.RecordTypeId == frmRecordTypeID && (objCR.Exam__c == 'FRM Part II' || objCR.Exam__c == 'FRM Full')))) {
                    
                    system.debug('* * * In 1');
                    
                    Date dtCurrentDay = objCR.Date_of_Completion__c;
                    Date dtEndDate = objCon.StartDate;
                    Integer iDiffMnths =dtEndDate.monthsBetween(dtCurrentDay);
                     objCon.ContractTerm = iDiffMnths + 60;
                     objcon.Status = 'Activated';
                     
                   
                } 
                
                else if (objCR.RecordTypeId == examRecordTypeID && objCon.RecordTypeId == frmRecordTypeID && objCR.Exam__c == 'FRM Part I') {
                    
                    system.debug('* * * In 2');
                    
                    Date dtCurrentDay = objCR.Date_of_Completion__c;
                    Date dtEndDate = objCon.StartDate;
                    Integer iDiffMnths =dtEndDate.monthsBetween(dtCurrentDay);
                    objCon.ContractTerm = iDiffMnths + 48;
                    objcon.Status = 'Activated';
                }
                
                if (objCR.RecordTypeId == jobRecordTypeID || allCompleted == true) {
                    
                    system.debug('* * * In 3');
                    
                    objCon.Status = 'Completed';
                    objCon.All_Requirements_Completed__c = true;
                    objCon.All_Requirements_Completed_Date__c = objCR.Date_of_Completion__c;
                }
            }  
            
            if(objCR.RecordTypeId == jobRecordTypeID && objCon.RecordTypeId == frmRecordTypeID && (objCon.status.indexof('Activated') > -1 || objCon.status.indexof('Completed') > -1)) {
                system.debug('* * * In 4');
                mapFRMAccountCR.put(objCon.AccountId, objCR);
            }
            if(objCR.RecordTypeId == jobRecordTypeID && objCon.RecordTypeId == erpRecordTypeID && (objCon.status.indexof('Activated') > -1 || objCon.status.indexof('Completed') > -1)) {
                system.debug('* * * In 5');
                mapERPAccountCR.put(objCon.AccountId, objCR);
            }
            
            lstContracts.add(objCon);
        }
        update lstContracts;
        
        system.debug('* * * mapFRMAccountCR:' + mapFRMAccountCR);
        system.debug('* * * mapERPAccountCR:' + mapERPAccountCR);
        
        if(mapFRMAccountCR.size() > 0 || mapERPAccountCR.size() > 0) {
            List<Contact> lstCont = [select Id, Name, AccountId, KPI_FRM_Resume_Program_Requirement_ID__c, KPI_ERP_Resume_Program_Requirement_ID__c, KPI_FRM_Resume_Status__c, KPI_FRM_Resume_Status_Date__c, KPI_FRM_Resume_Certificate_Sent_Date__c, KPI_ERP_Resume_Status__c, KPI_ERP_Resume_Status_Date__c, KPI_ERP_Resume_Certificate_Sent_Date__c from Contact where AccountId in :mapFRMAccountCR.keySet() or AccountId in :mapERPAccountCR.keySet()];
            List<Candidate_Requirement__c> lstCR = new List<Candidate_Requirement__c>();
            for(Contact objContact :lstCont) {
                Candidate_Requirement__c c = mapFRMAccountCR.get(objContact.AccountId); 
                if(c != null) {
                    
                    Candidate_Requirement__c cr = dbCR.get(c.Id); 
                    
                    if(cr != null) {
                        objContact.KPI_FRM_Resume_Status__c = cr.Status__c;
                        objContact.KPI_FRM_Resume_Program_Requirement_ID__c = cr.Id;
                        
                        if(cr.Status__c == 'Completed') {
                            if(trigger.oldMap.get(cr.Id).Status__c != cr.Status__c) {
                               cr.Date_of_Completion__c = date.today();
                               lstCR.add(cr);
                            }
                            objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Completion__c;
                        }                    
                            
                        if(cr.Status__c == 'Ready For Review') {
                            if(trigger.oldMap.get(cr.Id).Status__c != cr.Status__c) {
                               cr.Date_of_Ready_for_Review__c = date.today();
                               lstCR.add(cr);
                            }
                            objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Ready_for_Review__c;
                        }
                            
                        if(cr.Status__c == 'Failed Review') {
                            if(trigger.oldMap.get(cr.Id).Status__c != cr.Status__c) {
                               cr.Date_of_Failed_Review__c = date.today();
                               lstCR.add(cr);
                            }
                            objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Failed_Review__c;
                        }
                            
                        if(cr.Certificate_Sent_Date__c != null) {
                            objContact.KPI_FRM_Resume_Certificate_Sent_Date__c = cr.Certificate_Sent_Date__c;
                        }
                            
                    }
                    cr = mapERPAccountCR.get(objContact.AccountId); 
                    if(cr != null) {
                        objContact.KPI_ERP_Resume_Status__c = cr.Status__c;
                        objContact.KPI_ERP_Resume_Program_Requirement_ID__c = cr.Id;
                        
                        if(cr.Status__c == 'Completed') {
                            if(trigger.oldMap.get(cr.Id).Status__c != cr.Status__c) {
                               cr.Date_of_Completion__c = date.today();
                               lstCR.add(cr);
                            }
                            objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Completion__c;
                        }                    
                            
                        if(cr.Status__c == 'Ready For Review') {
                            if(trigger.oldMap.get(cr.Id).Status__c != cr.Status__c) {
                               cr.Date_of_Ready_for_Review__c = date.today();
                               lstCR.add(cr);
                            }
                            objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Ready_for_Review__c;
                        }
                            
                        if(cr.Status__c == 'Failed Review') {
                            if(trigger.oldMap.get(cr.Id).Status__c != cr.Status__c) {
                               cr.Date_of_Failed_Review__c = date.today();
                               lstCR.add(cr);
                            }
                            objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Failed_Review__c;
                        }
                            
                        if(cr.Certificate_Sent_Date__c != null) {
                            objContact.KPI_ERP_Resume_Certificate_Sent_Date__c = cr.Certificate_Sent_Date__c;
                        }
                    }
                }
            }
            update lstCont;
            update lstCR;
        }
    }
}