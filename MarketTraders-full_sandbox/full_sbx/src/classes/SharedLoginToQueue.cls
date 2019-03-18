public class SharedLoginToQueue { 
	public static Boolean testchanged = false; 

	public static void queueCallouts(Map<ID,Account> oldaccts, Map<ID,Account> newaccts ){
		List<Account> acctsUpdated = newaccts.values();
		List<ID> acctsqueued = new List<ID>();
		Integer index = 0;
       	Integer total = 0;
       	
       	for (Account acct : acctsUpdated) {
       		Boolean changed = false;
           	//check forex date changed
           	changed = (oldaccts.get(acct.id).PB_SubEnd_UCSForex__c != acct.PB_SubEnd_UCSForex__c) ? true : changed;
           	
           	System.debug(LoggingLevel.ERROR,'@@@@ changed due to UCS Forex Sub End: ' + changed);
         
            //check stocks date changed
           	changed = (oldaccts.get(acct.id).PB_SubEnd_UCSStocks__c != acct.PB_SubEnd_UCSStocks__c) ? true : changed;

			System.debug(LoggingLevel.ERROR,'@@@@ changed due to UCS Stocks Sub End: ' + changed);
			
			//changed = acct.Update_UCS_Back_Office_Web__c;
			
			System.debug(LoggingLevel.ERROR,'@@@@ changed due to Sub End UCS Web Charting (Forex): ' + changed);
			
			// MSM NEW
			changed = (oldaccts.get(acct.id).Sub_End_Ultimate_Charting_Pro_Forex__pc != acct.Sub_End_Ultimate_Charting_Pro_Forex__pc) ? true : changed;
			System.debug(LoggingLevel.ERROR,'@@@@ old ucs web forex: ' + oldaccts.get(acct.id).Sub_End_Ultimate_Charting_Pro_Forex__pc);
			System.debug(LoggingLevel.ERROR,'@@@@ new ucs web forex: ' + acct.Sub_End_Ultimate_Charting_Pro_Forex__pc);
			System.debug(LoggingLevel.ERROR,'@@@@ Ultimate Charting Pro (Forex Feed): ' + changed);
			
			changed = (oldaccts.get(acct.id).Sub_End_Ultimate_Charting_Pro_Stocks__pc != acct.Sub_End_Ultimate_Charting_Pro_Stocks__pc) ? true : changed;
			System.debug(LoggingLevel.ERROR,'@@@@ old ucs web stocks: ' + oldaccts.get(acct.id).Sub_End_Ultimate_Charting_Pro_Stocks__pc);
			System.debug(LoggingLevel.ERROR,'@@@@ new ucs web stocks: ' + acct.Sub_End_Ultimate_Charting_Pro_Stocks__pc);
			System.debug(LoggingLevel.ERROR,'@@@@ changed due to UCS Web Stocks Sub End: ' + changed);
			
			
			// END MSM NEW
			
			
            //check all date changed
           	//changed = (oldaccts.get(acct.id).PB_SubEnd_UCSALL__c != acct.PB_SubEnd_UCSALL__c) ? true : changed;
           	total++;
           	if (changed || testchanged) {
               	acctsqueued.add(acct.id);
               	if (index == 5 || total == acctsUpdated.size()) { //limit of callouts - 2 callouts per job
                   	ID jobID = System.enqueueJob(new SharedLoginQueueable(acctsqueued));
                   	System.debug(LoggingLevel.ERROR,'@@@@ SharedLoginToQueue : job id = ' + jobID + ' and acctsqueued size of ' + acctsqueued.size());
                   	index = 0;
                   	acctsqueued = new List<ID>();
               	}
               	else {
                	index++;                   
               	}
           	}       
       	}
   	}
}