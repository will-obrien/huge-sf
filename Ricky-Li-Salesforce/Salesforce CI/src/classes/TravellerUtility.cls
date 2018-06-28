public class TravellerUtility {
 
    public static string getHighestOccurences(Map<String, Integer> mapInput)
    {
        
        System.Debug('=====>TravellerUtility.getHighestOccurences - MapInput: ' + mapInput);
        Map<Integer, String> mapReverse = new Map<Integer, String>();
        
        for(string s : mapInput.keySet()){
            mapReverse.put(mapInput.get(s), s);
        }
            
        List<Integer> listOccurences = mapInput.Values();
        listOccurences.sort();
        
        string highestOccurences = '';
        if(listOccurences.size() > 0){   
            highestOccurences = mapReverse.get(listOccurences[listOccurences.size() - 1]);
        }        
        System.Debug('=====>TravellerUtility.getHighestOccurences - highestOccurences: ' + highestOccurences);
        return highestOccurences;
        
    }
    
    
    
    public static void updateTravellersValidPromotion(Set<Id> TravellerIds, Set<Id> CampaignIds){
        
        try{
            System.Debug('====>GAdv TravellerIds: ' + travellerIds);
            
            List<Account> listTravellers = [Select Id, Valid_Promotion__c, 
                                                (Select Id, CampaignId From PersonCampaignMembers) 
                                                From Account a
                                                where Id in : TravellerIds];
            for(Account t : listTravellers){
                for(CampaignMember cm : t.PersonCampaignMembers)
                {
                    CampaignIds.add(cm.CampaignId);
                }
            }
            
            System.Debug('====>GAdv CampaignIds: ' + CampaignIds);
            
            Map<Id, Campaign> CampaignMap = new Map<Id, Campaign>([select Id, Status, StartDate, EndDate, IsActive 
                                                                    from Campaign 
                                                                    where Id in : CampaignIds]);
            
            for(Account t : listTravellers){
                
                boolean validPromotion = false;
                System.Debug('====>GAdv PersonCampaignMembers: ' + t.PersonCampaignMembers);
        
                for(CampaignMember cm : t.PersonCampaignMembers)
                {
                    
                    if(CampaignMap.get(cm.CampaignId).IsActive)
                    {
                        validPromotion = true;
                    }
                    
                }
                
                System.Debug('====>GAdv - Set Traveller: ' + t.Id + ' Valid_Promotion to ' + validPromotion);
                t.Valid_Promotion__c = validPromotion;  
            }
            
            update listTravellers;      
                        
                
        }
        catch(System.DMLException e)
        {
            System.debug('===>GAdentures: Error at TravellerUtility.updateTravellersValidPromotion');
            for (Integer i = 0; i < e.getNumDml(); i++) {
                System.debug(e.getDmlMessage(i)); 
            }
        }
        
    }
    
//When a service is updated, this method is called

@future   
public static void updateTravellers_OnAfterServiceUpdate(Set<Id> TravellerIds, Set<Id> ServiceIds){
    system.debug('##################');
    try{    //ServiceIds contains the Id of the service that is updated
            //TravellerIds contains the Ids of the Travellers that are on that service
            
            List <Account> listTravellers = [Select Name,(Select Service__r.Name, Service__r.Service_Type__c, 
                                                     Service__r.Gross_per_PAX_CAD__c, Service__r.Number_Of_Days__c,
                                                     Service__r.Extras_Added__c, Service__r.Supplier_Style__c, Service__r.Service_Level__c from TS__r 
                                                     where Service__r.Service_Status__c = 'Confirmed' Order by Service__r.Confirmation_Date_Time__c desc),
                                                      (Select Number_Of_Tours__c, Lifetime_Value__c, 
                                                       Average_Tour_Length__c, Average_Tour_Price__c, Add_ons__c, Preferred_Comfort_Level__c, Preferred_Trip_Style__c,
                                                       Booked_Air_in_the_Past__c from AccountHistoricalSummary__r) 
                                             from Account where Id in: TravellerIds];
            
            List <AccountHistoricalSummary__c> listAHS = [Select Number_Of_Tours__c, Average_Tour_Price__c,
                                                          Average_Tour_Length__c, Preferred_Trip_Style__c,
                                                          Preferred_Comfort_Level__c, Add_ons__c, 
                                                          Booked_Air_in_the_Past__c, Lifetime_Value__c, 
                                                          Client_Type__c, Last_Agency_Used__c 
                                                          from AccounthistoricalSummary__c where Account_id__c in : listTravellers];
            if(listAHS.size()==0){
                System.Debug('The list is empty');
            }
            else{
            System.Debug('This is the list of all the travellers'+ listTravellers);
            
              List <Double> listNumberOfTours = new list <Double>();
              List <Double> listTotalTourPrice = new list <Double>();
              List <Double> listTotalTourLength = new list <Double>();
              List <Double> listLifeTimeValue = new list <Double>();
              List <String> listPreferredTripStyle = new list <String>();
              List <String> listPreferredComfortLevel = new list <String>();
              List <Boolean> listAddOns = new list <Boolean>();
              List <Boolean> listBookedAirInThePast = new list <Boolean>();
              Map <Account, List <Id>> mapAccountServicesTypeTour = new map <Account, List <Id>>();
                  for(Account t: listTravellers){
                     List <Id> listServicesTypeTour = new list <Id>();
                     Double totalTourPrice=0;
                     Double totalTourLength=0;
                     Double lifeTimeValue=0; 
                     String preferredTripStyle;
                     String preferredComfortLevel;
                     Boolean boolAddOns = false;
                     Boolean boolBookedAirinthePast = false;
                     Map<String, Integer> mapTripStyle = new Map<String, Integer>();
                     Map<String, Integer> mapServiceLevel = new Map<String, Integer>();
                         for(TravellerServices__c ts: t.TS__r){
                             if(ts.Service__r.Service_Type__c == 'tour'){
                                 //numberOfTours
                                 listServicesTypeTour.add(ts.Service__r.Id);
                                 //TotalTourPrice
                                 if(ts.Service__r.Gross_per_PAX_CAD__c > 0.00){
                                     totalTourPrice += ts.Service__r.Gross_per_PAX_CAD__c;
                                 }
                                 //TotalTourLength
                                 if(ts.Service__r.Number_Of_Days__c > 0){
                                     totalTourLength += ts.Service__r.Number_Of_Days__c;
                                 }
                                 //Preferred Trip Style
                                 if(ts.Service__r.Supplier_Style__c !=null){
                                    if(mapTripStyle.containsKey(ts.Service__r.Supplier_Style__c)){
                                       integer occurences = mapTripStyle.get(ts.Service__r.Supplier_Style__c);
                                       mapTripStyle.put(ts.Service__r.Supplier_Style__c, occurences+1);        
                                    }
                                    else{
                                       mapTripStyle.put(ts.Service__r.Supplier_Style__c, 1);       
                                    }
                                 }
                                 preferredTripStyle = TravellerUtility.getHighestOccurences(mapTripStyle);
                                 
                                 //Preferred Comfort Level
                                 if(ts.Service__r.Service_Level__c != null){
                                   if(mapServiceLevel.containsKey(ts.Service__r.Service_Level__c)){
                                       integer occurences = mapServiceLevel.get(ts.Service__r.Service_Level__c);
                                       mapServiceLevel.put(ts.Service__r.Service_Level__c, occurences + 1);
                                   }
                                   else{
                                       mapServiceLevel.put(ts.Service__r.Service_Level__c, 1);
                                   }
                                 }
                                 preferredComfortLevel = TravellerUtility.getHighestOccurences(mapServiceLevel);
                             }
                             else if(ts.Service__r.Service_Type__c == 'Air'){
                                 boolBookedAirinthePast = true;
                             }
                             if(ts.Service__r.Extras_Added__c!=null){
                                 boolAddOns = true;
                             }
                             if(ts.Service__r.Gross_per_PAX_CAD__c > 0){
                                 lifeTimeValue += ts.Service__r.Gross_per_PAX_CAD__c;
                             }
                             
                          }   
                         for(AccountHistoricalSummary__c ahs: t.AccountHistoricalSummary__r){
                            listNumberOfTours.add(listServicesTypeTour.size());
                            listTotalTourPrice.add(totalTourPrice);
                            listTotalTourLength.add(totalTourLength);
                            listPreferredTripStyle.add(preferredTripStyle);
                            listPreferredComfortLevel.add(preferredComfortLevel);
                            listBookedAirInThePast.add(boolBookedAirinthePast);
                            listAddOns.add(boolAddOns);
                            listLifeTimeValue.add(lifeTimeValue);
                         }
                         
                    mapAccountServicesTypeTour.put(t, listServicesTypeTour);
                  } 
                  
                  for(integer i = 0; i< listTravellers.size(); i++){
                        listAHS[i].Number_Of_Tours__c = listNumberOfTours[i];
                        if(listNumberOfTours[i]>0){
                            listAHS[i].Average_Tour_Price__c = listTotalTourPrice[i]/listNumberOfTours[i];
                            listAHS[i].Average_Tour_Length__c = listTotalTourLength[i]/listNumberOfTours[i];
                            listAHS[i].Preferred_Trip_Style__c = listPreferredTripStyle[i];
                            ListAHS[i].Preferred_Comfort_Level__c = listPreferredComfortLevel[i];
                            listAHS[i].Lifetime_Value__c = listLifeTimeValue[i];
                        }
                        else{
                            listAHS[i].Average_Tour_Price__c = 0;
                            listAHS[i].Average_Tour_Length__c = 0;
                            listAHS[i].Preferred_Trip_Style__c = '';
                            ListAHS[i].Preferred_Comfort_Level__c = '';
                            listAHS[i].Lifetime_Value__c = 0;
                            listAHS[i].Client_Type__c = 'Prospect';
                            listAHS[i].Last_Agency_Used__c = '';
                        }
                        
                        if(listBookedAirInThePast[i] == true)
                                listAHS[i].Booked_Air_in_the_Past__c = true;
                        if(listAddOns[i] == true)
                                listAHS[i].Add_Ons__c = true;
                        
                    }     

          update listAHS;
         }
    }
    catch(System.DMLException e){
        System.debug('===>GAdventures: Error at TravellerUtility.updateTravellers');
            for (Integer i = 0; i < e.getNumDml(); i++){
                System.debug(e.getDmlMessage(i));
            }
    }
}
                 
        
//When a TS is Deleted this method is called  
public static void updateTravellers_OnAfterTSDelete(Set<Id> TravellerIds){
      
      try{
            System.Debug(TravellerIds);
              //List of AHS
             List <AccountHistoricalSummary__c> Test = [Select Client_Type__c, Last_Agency_Used__c, Lifetime_Value__c, Average_Tour_Length__c, 
                                                        Average_Tour_Price__c, Number_Of_Tours__c, 
                                                        Preferred_Trip_Style__c, Preferred_Comfort_Level__c,
                                                        Booked_Air_in_the_Past__c, Add_ons__c 
                                                        from AccountHistoricalSummary__c where Account_Id__c in : TravellerIds];

              
             List <Service__c> listServicesConfirmed = new list <Service__c>();
             List <TravellerServices__c> listServicesForTraveller = [Select Service__c from TravellerServices__c where Account__c in : TravellerIds];
             System.Debug('listServicesForTraveller' + listServicesForTraveller);
             
          if(listServicesForTraveller.size() > 0){
             List <String> strlistServicesForTraveller = new list <String> ();
             for (integer i = 0; i < listServicesForTraveller.size(); i++){
                     strlistServicesForTraveller.add(listServicesForTraveller[i].Service__c);
                 }
             
             System.Debug(strlistServicesForTraveller);
             
             listServicesConfirmed = [Select Id from Service__c where Service_Status__c = 'Confirmed' and Id in : strlistServicesForTraveller];
             System.Debug(listServicesConfirmed);
           }
           
           if(listServicesConfirmed.size() >= 1){
               System.Debug('The Confirmed Services are more than 1');
           }
           else{
              if(Test.size() ==1){
                 Test[0].Lifetime_Value__c = 0.00; 
                 Test[0].Add_Ons__c = False;
                 Test[0].Average_Tour_Length__c = 0;
                 Test[0].Average_Tour_Price__c = 0;
                 Test[0].Booked_Air_in_the_Past__c = False;
                 Test[0].Number_of_Tours__c = 0;
                 Test[0].Preferred_Trip_Style__c = '';
                 Test[0].Preferred_Comfort_Level__c = '';
                 Test[0].Client_Type__c = 'Prospect';
                 Test[0].Last_Agency_Used__c = '';                        
                update Test[0];
                }
              else{
                  System.Debug('Test is empty');
              }  
           }
 }
 
  catch(System.DMLException e){
             System.debug('===>GAdventures: Error at TravellerUtility.updateTravellers');
                for (Integer i = 0; i < e.getNumDml(); i++){
                    System.debug(e.getDmlMessage(i));
                }
            }
 
}

//UpdateClient Type
public static void updateClientType(Set<Id> TravellerIds, Set<Id> ServiceIds){

system.debug('***************');
        try{
                //Get the number of travellers
                //for all the travellers 
                    //get the list of confirmed services
                    //get the last service
                    //from the last service get the booking stuff
                    
                 Integer i;
                 List <Account> listTravellers = [Select Id, Name, (Select Service__r.Id, Service__r.Booking__c from TS__r where Service__r.Service_Status__c = 'confirmed' and Service__r.Service_Type__c = 'Tour' and Service__r.Confirmation_Date_Time__c != NULL and Service__r.Cancellation_Date_Time__c = NULL ORDER BY Service__r.Confirmation_Date_Time__c DESC Limit 1) from Account where Id in : TravellerIds];
                 System.Debug('list Travellers' + listTravellers);
                 
                 List <String> stringBookings = new list <String>();
                 //for all the booking Ids add the travellers to that set
                 Map <String, list <Account>> listMap = new Map <String, list <Account>>();
                 Map <String, list <Account>> mapServiceAccount = new Map <String, list <Account>>();
                 
                 list <Account> listAccountTravellersDirect = new list <Account>();
                 list <Account> listAccountTravellersAgent = new list <Account>();
                 list <Account> listAgencyName = new list <Account>();
                 
                     for(Account t: listTravellers){
                      for(TravellerServices__c ts: t.TS__r){
                           stringBookings.add(ts.Service__r.Booking__c);
                             if(listMap.containsKey(ts.Service__r.Booking__c)){
                               List <Account> listAccount = new list <Account>();
                                 listAccount = listMap.get(ts.Service__r.Booking__c);
                                 listAccount.add(t);
                                 listMap.put(ts.Service__r.Booking__c, listAccount);
                                
                             }
                             else{
                                  List <Account> listAccount = new list <Account>();
                                      listAccount.add(t);
                                      listMap.put(ts.Service__r.Booking__c, listAccount);
                             }    
                         }
                         
                     }
                     System.Debug('Final Map' + listMap);
                
             
                //If this map is empty
                if(listMap.size() == 0){
                    //for(i=0; i < listAHS.size(); i++){
                       // listAHS[i].Client_Type__c = 'Prospect';
                       // listAHS[i].Last_Agency_Used__c = '';
                  //  }
                }
                 
                 
               List <Booking__c> listAgencyCategory = [Select Agent__r.Account.Agency_Category__c, Agent__r.Account.Name from Booking__c where Id in: listMap.KeySet()];
                  
               List <String> listAgencies = new list <String>();    
               Map <Id, String> mapCategory = new Map <Id, String>();
               Map<Id, String> mapAgencyName = new Map <Id, String>();
                 for(Booking__c booking : listAgencyCategory){
                     mapCategory.put(booking.Id, booking.Agent__r.Account.Agency_Category__c);
                     mapAgencyName.put(booking.Id, booking.Agent__r.Account.Name);
                 }
                
                   
                 
                 System.Debug('This is the map Category' + mapCategory);
                 System.Debug('This is the map Agency Name' + mapAgencyName);
                 
                 Map <String, list <Account>> mapSetClientType= new Map <String, list<Account>>();
                   for(String s : mapCategory.keySet()){
                      if(mapSetClientType.containsKey(mapCategory.get(s))){
                           List <Account> listAccountTest = new list <Account>();
                               System.Debug(listMap.get(s));
                               listAccountTest = mapSetClientType.get(mapCategory.get(s));
                               listAccountTest.addAll(listMap.get(s)); 
                               mapSetClientType.put(mapCategory.get(s), listAccountTest);
                      }
                      else{
                      List <Account> listAccountTest = new list <Account>();
                        listAccountTest.addAll(listMap.get(s));
                        mapSetClientType.put(mapCategory.get(s), listAccountTest);
                      }
                    }
                 
                 System.Debug('This is the map Client type' + mapSetClientType);
                 Map <Id, String> mapAccountSetAHS = new Map <Id, String>();
                     
                     for(String s : mapSetClientType.keySet()){
                        if(s != 'Direct'){
                           listAccountTravellersAgent.addAll(mapSetClientType.get(s));
                        }
                        else{
                           listAccountTravellersDirect.addAll(mapSetClientType.get(s));
                        }
                     }
                
                    System.Debug('List Agency Name Direct' + listAccountTravellersDirect);
                    System.Debug('List Agency Name Agent' + listAccountTravellersAgent);
                 
              
                  //Equate the listMap's Value to mapAgencyName's value
                     //For all the keySet in listMap
                     //get the value
                     //for the value - get the respective AHS
                     //for the same keyset in mapAgencyName
                     //get the value
                     
                     //Last Agency Used
                     List <Account> test = new list <Account>();
                     List <String> strTest = new list <String>();
                     for(String s : listMap.keySet()){
                        List <AccountHistoricalSummary__c> listAHS = [Select Last_Agency_Used__c from AccountHistoricalSummary__c where Account_id__c in : listMap.get(s)];
                        System.Debug('This is the list AHS' + listAHS);
                        
                            for(i =0; i < listAHS.size(); i++){
                                listAHS[i].Last_Agency_Used__c = mapAgencyName.get(s);
                            }
                          System.Debug('This is the list AHS after' + listAHS);
                          update listAHS;
                        }  
                     System.Debug('This is the list of Accounts' + test);
                     System.Debug('This is the list of Agency Name' + strTest); 
                        
                        
                       List <AccountHistoricalSummary__c> listAHSDirect = [Select Client_Type__c from AccountHistoricalSummary__c where Account_id__c in : listAccountTravellersDirect];
                            System.Debug(listAHSDirect.size());
                            
                            for(i=0; i < listAHSDirect.size(); i++){
                                listAHSDirect[i].Client_Type__c = 'Direct';
                            }
                          
                       List <AccountHistoricalSummary__c> listAHSAgent = [Select Client_Type__c , Last_Agency_Used__c from AccountHistoricalSummary__c where Account_id__c in : listAccountTravellersAgent];
                            System.Debug(listAHSAgent.size());
                         for(i=0; i < listAHSAgent.size(); i++){
                                listAHSAgent[i].Client_Type__c = 'Agency';
                         }
                            
                   System.Debug('List AHS Direct' + listAHSDirect);
                   System.Debug('List AHS Agent' + listAHSAgent);
                   
                   update listAHSDirect;
                   update listAHSAgent;  
            }
       
       catch(System.DMLException e){
             System.debug('===>GAdventures: Error at TravellerUtility.updateTravellers');
                for (Integer i = 0; i < e.getNumDml(); i++){
                    System.debug(e.getDmlMessage(i));
            }
        }
    }      
}