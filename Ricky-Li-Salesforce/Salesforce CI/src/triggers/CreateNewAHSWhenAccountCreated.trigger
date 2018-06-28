trigger CreateNewAHSWhenAccountCreated on Account (after insert) {

List <AccountHistoricalSummary__c> listAHS = new list <AccountHistoricalSummary__c>();
    for (Account a : trigger.new)
    {
      if(a.IsPersonAccount == True)
      {  
               AccountHistoricalSummary__c AHS = new AccountHistoricalSummary__c();
 
                AHS.Account_id__c = a.Id;
                AHS.Name = 'SummaryObject1';
                AHS.Add_ons__c = False;
                AHS.Average_Tour_Length__c = 0;
                AHS.Average_Tour_Price__c = 0;
                AHS.Booked_Air_in_the_Past__c = False;
                AHS.Lifetime_Value__c = 0;
                AHS.Number_of_Tours__c = 0;
                AHS.Preferred_Comfort_Level__c = '';
                AHS.Preferred_Trip_Style__c = '';
                AHS.Client_Type__c = 'Prospect';
                insert AHS;
               /*
               listAHS.add(AHS);  
                
                if (listAHS.size() == 9900)
                {
                    //insert listAHS
                    insert listAHS;
                    //clear listAHS
                    listAHS.clear();   
                }*/  
           }
      }
    
    //insert listAHS;
}