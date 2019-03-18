trigger Account_BrochureRequestCountryCode on Account (before Insert, before Update) {
    		List <Account> accts = new List<Account>();
          //Set <Id> AccountIds = new Set <Id>();
          //if(BrochureRequestTriggerController.getRunTimesAccount() < 1){ 
              for(Account acc : trigger.new){
                  accts.add(acc);
              }
               //BrochureRequestTriggerController.setRunTimesAccount();
               BrochureRequestTriggerController.BrochureRequest_Account(accts);
          //}
}