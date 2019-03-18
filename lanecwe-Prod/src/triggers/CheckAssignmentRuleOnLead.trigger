/*********************************************************************
Name : CheckAssignmentRuleOnLead 
Created On : dec 30, 2011  
Created By : Lalit Bohra
Description : Trigger on Lead for changing the owner of lead thru assignments rules.
Task :T-20274
**********************************************************************/

trigger CheckAssignmentRuleOnLead on Lead (after insert) {
    if(!(Test.isRunningTest())){
    Bypassrules__c profileCustomSetting = Bypassrules__c.getInstance(UserInfo.getUserId());
    if(profileCustomSetting.Trigger_Objects__c != null){    

        system.debug('profileCustomSetting:'+profileCustomSetting );
    if(!(profileCustomSetting.Trigger_Objects__c.contains('Lead')
       && profileCustomSetting.Disable_Triggers__c)){
    //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
    // getting the PGI ntegration User Id for updating the lead.LeadSource when ever record is being inserted by PGI ntegration User.
    if(test.isRunningTest() || UserInfo.GetUserId() == PGIAppConstants.PGI_INTEGRATION_USERID){    
        Boolean isInActiveTrigger = false;
        if(!Test.isRunningTest()){
          isInActiveTrigger = Trigger_Settings__c.getInstance(UserInfo.getProfileId()).InactivateCheckAssignmentRuleOnLead__c;
        }
        
        if(isInActiveTrigger == false){
            list<Lead> LeadUpdateList = new list<Lead>();   
            set<String> LeadSalesRepEmailSet = new set<String>();
            map<String,Id> UserEmailMap = new map<String,Id>();     
            for(Lead objLead:trigger.new){ 
                // this trigger will run for only pgi integration users
                //if(test.isRunningTest() || PGIntegrationUserId != null && objLead.OwnerId==PGIntegrationUserId){
  
                  //  system.debug('----------------- objLead.LeadSource'+ objLead.LeadSource);
                  //  system.debug('----------------- objLead.OwnerId'+ objLead.OwnerId);
                    // storing all the Lead IM_SALESREP_EMAIL__c in set for fetching all the users 
                    if(objLead.IM_SALESREP_EMAIL__c != null && objLead.IM_SALESREP_EMAIL__c !=''){
                        LeadSalesRepEmailSet.add(objLead.IM_SALESREP_EMAIL__c);
                    }
                //}
            } 
                
                if(LeadSalesRepEmailSet != null && LeadSalesRepEmailSet.size()>0){
                    // creatng a user map for updating the owner of new leads  
                    for(User user:[Select Id,UserName from User where UserName in:LeadSalesRepEmailSet]){
                        if(!UserEmailMap.containsKey(user.UserName)){
                            UserEmailMap.put(user.UserName,user.Id);
                        }
                    }
                   // system.debug('------------ UserEmailMap'+UserEmailMap);     
                }
                
                // Assignment of sales rep to as owner of Lead.  
                List<Lead> lstLead = new List<Lead>();    
                for(Lead objLead : trigger.new){           
                     if(!UserEmailMap.ContainsKey(objLead.IM_SALESREP_EMAIL__c)){
                       Lead updateLead = new Lead(Id = objLead.Id);
                        database.DMLOptions dmo = new database.DMLOptions();     
                        dmo.AssignmentRuleHeader.UseDefaultRule= true; 
                        updateLead.setOptions(dmo);
                        lstLead.add(updateLead); 
                    }
                }
                if(lstLead.size() > 0){
                    update lstLead; 
                }                       
            //}
        }
    }
}
}
}
}