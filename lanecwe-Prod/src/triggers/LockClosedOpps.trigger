trigger LockClosedOpps on Opportunity (before update) {
    for (Opportunity opp : Trigger.new) {
        Opportunity oldOpp = Trigger.oldMap.get(opp.id);
        //Opportunity newOpp = Trigger.newMap.get(opp.id);
        Id profileId = userinfo.getProfileId();
        if (opp.Apex_Update__c == false && oldOpp.Opp_Stage_Is_Closed__c == true 
           && (profileId == '00e30000001s1BT' //PGi Sales Mgr - NA
           || profileId == '00e13000001dswg' //PGi Sales Mgr - NA Linkedin
           || profileId == '00e13000001dswl' //PGi Sales User - NA Linkedin
           || profileId == '00e30000001rSOW' //PGi Sales User - NA
           || profileId == '00ea0000001sdfi' //PGi Sales User - NA - Zoominfo
           || profileId == '00e30000001s4o1' //PGi Sales User - Partner NA
           || profileId == '00ea0000001shw5' //PGi Sales User - Partner NA - Zoom
           || profileId == '00ea0000001shvl' //PGi Sales Mgr - NA - Zoom
           || profileId == '00ea0000001shvq' //PGi Sales User - Ecommerce - Zoom
           || profileId == '00e30000001sVaU' //PGi Sales User - GCS Diamond
           || profileId == '00ea0000001shvv' //PGi Sales User - GCS Diamond - Zoom
           || profileId == '00ea0000001sZgU' //PGi Sales User - GCS Diamond Support
           || profileId == '00e30000001s6EK' //PGi Expert/Engineer - NA
           || profileId == '00ea0000001shes' //PGi Sales User - AAE
           || profileId == '00ea0000001shet' //PGi Sales User - Canada
           || profileId == '00ea0000001shvW' //PGi Sales User - Canada - Zoom
           || profileId == '00e30000001rSOR' //PGi Marketing User
           || profileId == '00ea0000001shvb' //PGi Marketing User - Zoom
           || profileId == '00e30000001s1BO' //PGi Sales Mgr - EMEA
           || profileId == '00e30000001s6EP' //PGi Expert/Engineer - EMEA
           || profileId == '00e30000001rdQx' //PGi Sales User - EMEA
           || profileId == '00e30000001s4o6' //PGi Sales User - Partner EMEA
           || profileId == '00ea0000001sduQ' //PGi Sales User - EMEA - Zoom
           || profileId == '00ea0000001shw0' //PGi Sales User - Partner EMEA - Zoom
           || profileId == '00ea0000001shvg' //PGi Sales Mgr - EMEA - Zoom
           )) {
            opp.addError('This Opportunity has been closed. No updates are permitted.');
        }
    }
}