trigger OnChapterMeetingRegistrationInsertUpdate on Chapter_Meeting_Registration__c (before insert, before update) {

    List<Chapter_Meeting_Registration__c> lstChapMeetReg = new List<Chapter_Meeting_Registration__c>();
    List<Id> lstChapMeetRegId = new List<Id>();
    List<Id> lstContactId = new List<Id>();
    Map<Id, Chapter_Meeting_Registration__c> mapContactReg = new Map<Id, Chapter_Meeting_Registration__c>();
    
    for(Chapter_Meeting_Registration__c obj : trigger.New) {

        if(Trigger.isUpdate) {
            if(obj.Attended__c != Trigger.oldMap.get(Obj.Id).Attended__c) {
                lstChapMeetReg.add(obj);
                lstChapMeetRegId.add(obj.Chapter_Meeting__c);
                lstContactId.add(obj.Contact__c);
                mapContactReg.put(obj.Contact__c, Obj);            
            }
        } else {
            lstChapMeetReg.add(obj);
            lstChapMeetRegId.add(obj.Chapter_Meeting__c);
            lstContactId.add(obj.Contact__c);
            mapContactReg.put(obj.Contact__c, Obj);
        }
    }
    
    //System.debug('mapContactReg' + mapContactReg);
    
    List<Chapter_Meeting__c> lstChapMeetings = [select Id, Name, Topic__c, CPE_Credits__c  from Chapter_Meeting__c where Id in :lstChapMeetRegId];
    List<Contact> lstContact = [select Id,Name,CPE_Current_Program_Requirement__c, KPI_FRM_Certified__c,KPI_ERP_Certified__c from Contact where Id in :lstContactId];
    List<CPE_Activity_Type__c> lstActType = [select Id,Name from CPE_Activity_Type__c where Name = 'Professional Association Meetings'];
    List<Account> lstAccount = [select Id,Name from Account where Name = 'GARP'];
    
    List<CPE_Claim__c> lstClaimAdd = new List<CPE_Claim__c>();
    List<Id> lstClaimDelContactId = new List<Id>();
    List<Id> lstClaimDelReqId = new List<Id>();
    List<String> lstMeetingNameDel = new List<String>();
    
    //System.debug('lstChapMeetings' + lstChapMeetings);
    
    if(lstActType != null && lstActType.size() > 0 && lstAccount != null && lstAccount.size() > 0) {

        for(Contact con :lstContact) {
            if(con.CPE_Current_Program_Requirement__c != Null) {
                Chapter_Meeting_Registration__c chapReg = mapContactReg.get(con.Id);
                Chapter_Meeting__c cmFound;
                
                //System.debug('chapReg' + chapReg);
                
                for(Chapter_Meeting__c cm :lstChapMeetings) {
                    if(cm.Id == chapReg.Chapter_Meeting__c) {
                        cmFound = cm;
                        break;
                    }
                }
                if(chapReg.Attended__c && cmFound != null) {
                    CPE_Claim__c newClaim = new CPE_Claim__c();
                    newClaim.Candidate_Requirement__c = con.CPE_Current_Program_Requirement__c;
                    newClaim.CPE_Activity_Type__c = lstActType[0].Id;
                    newClaim.Date_of_Completion__c = system.today();
                    if(cmFound.CPE_Credits__c != null)
                    	newClaim.Credits_Earned__c = cmFound.CPE_Credits__c;
                    else newClaim.Credits_Earned__c = 1;
                    newClaim.EventTitle__c = cmFound.Name;
                    newClaim.Provider__c = lstAccount[0].Id;
                    newClaim.Area_of_Study__c = cmFound.Topic__c;
                    newClaim.Member__c = con.Id;
                    newClaim.FRM__c = con.KPI_FRM_Certified__c;
                    newClaim.ERP__c = con.KPI_ERP_Certified__c;
                    lstClaimAdd.add(newClaim);
                } else if(cmFound != null) {
                    lstClaimDelContactId.add(con.Id);
                    lstClaimDelReqId.add(con.CPE_Current_Program_Requirement__c);
                    lstMeetingNameDel.add(cmFound.Name);
                }            
            }
        }        
    }
    insert lstClaimAdd;
    
    List<CPE_Claim__c> lstClaimDel = [Select Id, Name, Member__c, EventTitle__c, Candidate_Requirement__c from CPE_Claim__c where Member__c in :lstClaimDelContactId and EventTitle__c in :lstMeetingNameDel and Candidate_Requirement__c in :lstClaimDelReqId];
    delete lstClaimDel;
}