/*********************************************************************
Name : SetAccountOnCompany 
Created On : Mar 02, 2012     
Created By : Lalit Bohra
Description : Trigger on Account for updating the accountid On company using the matched of TESLA_IntlCompanyID__c
Task :T-35430
**********************************************************************/
trigger SetAccountOnCompany on Account (after insert) {
    if(!(Test.isRunningTest())){
	Bypassrules__c profileCustomSetting = Bypassrules__c.getInstance(UserInfo.getUserId());
    if(profileCustomSetting.Trigger_Objects__c != null){    
	system.debug('user:'+UserInfo.getUserId());
	system.debug('profileCustomSetting:'+profileCustomSetting);
	if(!(profileCustomSetting.Trigger_Objects__c.contains('Account')
       && profileCustomSetting.Disable_Triggers__c)){
    map<String,Id> AccountMap= new map<String,Id>();
    list<Company__c> CompanyList= new list<Company__c>();
    for(Account acc:trigger.new){
        if(acc.TESLA_IntlCompanyID__c != null && acc.TESLA_IntlCompanyID__c !=''){
            if(!AccountMap.containsKey(acc.TESLA_IntlCompanyID__c)){
                AccountMap.put(acc.TESLA_IntlCompanyID__c,acc.Id);
            }           
        }
    }
    if(AccountMap != null && AccountMap.size()>0){
        Boolean isInActiveTrigger = false;
        // query form Custom setting
        for(Trigger_Settings__c ts : [Select InactivateSetAccountOnCompany__c From Trigger_Settings__c]){
            // Set settting into veriable
            isInActiveTrigger = ts.InactivateSetAccountOnCompany__c;
        }
        if(isInActiveTrigger == false){
            // query user region field
             map<Id,Account> UnMatchBucket=new map<Id,Account>([Select id,Name from Account where 
             (Name =:'NA Unmatch' or Name =:'APAC Unmatch' or Name =:'EMEA Unmatch' or Name =:'Unidentified Region Account')]);
            for(Company__c Company:[Select Account__c,TESLA_IntlCompanyID__c from Company__c where TESLA_IntlCompanyID__c in:AccountMap.keyset()]){
                if(AccountMap.ContainsKey(Company.TESLA_IntlCompanyID__c) && (UnMatchBucket.containskey(Company.Account__c) ||Company.Account__c==null)){
                    Company.Account__c=AccountMap.get(Company.TESLA_IntlCompanyID__c);
                    CompanyList.add(Company);
                }
            }
            if(CompanyList != null && CompanyList.size()>0){
                update CompanyList;
            }
        }       
    }
}
}
}
}