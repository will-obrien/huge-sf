trigger limitNumLSRRules on UnfollowRule__c (before Insert, before Update) {
    Integer ruleLimit=100;
    List<UnfollowRule__c> activeRules=[SELECT Id, Active__C FROM UnfollowRule__c WHERE Active__c=True];
    Integer numActiveRules=activeRules.size();
    Boolean overRuleLimit=(numActiveRules>ruleLimit);

    UnfollowRule__c ur = new UnfollowRule__c();
    
    for (Integer i=0;i<trigger.new.size();i++){//for
        ur=trigger.new[i];
        if(Trigger.isInsert){//if 1
            if(ur.Active__c==True){//if 2
                numActiveRules++;
                overRuleLimit=(numActiveRules>ruleLimit);
                if(overRuleLimit==True){//if 3
                    ur.adderror('Error: Active Unfollow Rule limit of ' + ruleLimit + ' rules exceeded.  To create a new rule, first deactivate or delete another active rule.');
                }//if 3   
            }//if 2    
        }//if 1
        if(Trigger.isUpdate){//if 1
            UnfollowRule__c urOld=trigger.old[i];
            if(urOld.Active__c==True){//if 2
                if(overRuleLimit==True&&ur.Active__c==True){//if 3
                        ur.adderror('Error: Active Unfollow Rule limit of ' + ruleLimit + ' rules exceeded.  To edit any Active rules, first deactivate or delete another active rule.');
                }//if 3        
            }else if(urOld.Active__c==False){
                if(ur.Active__c==True){//if 3
                    numActiveRules++;
                    overRuleLimit=(numActiveRules>ruleLimit);
                    if(overRuleLimit==True){//if 5
                        ur.adderror('Error: Active Unfollow Rule limit of ' + ruleLimit + ' rules exceeded.  To edit any Active rules, first deactivate or delete another active rule.');
                    }//if 4    
                }//if 3        
            }//if 2
        }//if 1      
    }//for   
}