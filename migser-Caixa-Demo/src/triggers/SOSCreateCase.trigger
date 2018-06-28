trigger SOSCreateCase on SOSSession (before insert) {
    List<SOSSession> sosSess = Trigger.new;
    List<SOS_Create_Case__c> triggerEnabled = [SELECT enabled__c FROM SOS_Create_Case__c];
    if (!triggerEnabled.isEmpty() && triggerEnabled[0].enabled__c) {
        for (SOSSession s : sosSess) {
            try{
                Case caseToAdd = new Case();
                caseToAdd.Subject = 'SOS Video Chat';
                if (s.ContactId != null) {
                    caseToAdd.ContactId = s.ContactId;
                } else {
                    List<Contact> contactInfo = [SELECT Id from Contact WHERE Email = :s.AppVersion];
                    if (!contactInfo.isEmpty()) {
                        caseToAdd.ContactId = contactInfo[0].Id;
                        s.ContactId = contactInfo[0].Id;
                    }
                }
                insert caseToAdd; s.CaseId = caseToAdd.Id;
            }catch(Exception e){}
        }
    }
}