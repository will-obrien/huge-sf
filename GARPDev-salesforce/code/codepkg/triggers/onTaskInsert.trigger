trigger onTaskInsert on Task (before insert,before update) {
    
    Map<Id, String> taskMap = new Map<Id, String>();
    Map<Id, String> taskAmountMap = new Map<Id, String>();
    Map<Id, String> taskBalanceAmountMap = new Map<Id, String>();
    
    
    for (Task t : trigger.new) {
        if (t.WhoId != null) {
            if(t.Subject.indexOf('Registration:') > -1) {
                List<String> parts = t.Subject.split(':', 4);
                if(parts.size() > 1) {
                taskMap.put(t.WhoId, parts[1]);  
                taskAmountMap.put(t.WhoId, parts[2]);  
                taskBalanceAmountMap.put(t.WhoId, parts[3]);  
                }
            }
        }        
    }

    
  
  
    
    system.debug('* * * taskMap:'+ taskMap);
    system.debug('* * * taskAmountMap:'+ taskAmountMap);
    
    List<Contact> lstContact = [select ID, Name, CVent_Contact_Type__c from Contact where Id in :taskMap.keySet()];
    for(Contact con : lstContact) {
        String setMember = taskMap.get(con.Id).trim();
        system.debug('setMember>>>'+setMember);
        system.debug('con>>>'+con);
        if(con.CVent_Contact_Type__c == 'Non-Member' && setMember == 'Member') {
            //con.Content_Type__c = 'Member';
            Exam_Attempt__c objEAIn = new Exam_Attempt__c();
            objEAIn.Member__c = con.Id;
            
            system.debug('* * * objEAIn:'+ objEAIn);
            String amt = taskAmountMap.get(con.id);
            String bal = taskBalanceAmountMap.get(con.id);
            contactExtn conExt = new contactExtn(objEAIn, amt, false);
            if(bal != null && bal != '0.00') {
                conExt = new contactExtn(objEAIn, amt, false);    
            } else {
                conExt = new contactExtn(objEAIn, amt, true);
            }
            
            conExt.updateMemberShip();
        }
    }
    //update lstContact;

}