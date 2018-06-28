/*********************************************************************************************************
Name              : WE_UpdateContact
Created By        : Vernon Baas
Created Date      : May 2014
Description       : Updates contact with WealthEngine information
Last Updated      : 2017 July - Justin LaMont - Added update new date field on contact, cleaned up deprecated comments and added header
*********************************************************************************************************/

trigger WE_UpdateContact on WE_FW8_NP__WESearchResult__c (after insert) {
    
    //Set up list of contact Ids and map of results with their corresponding contact ID as a key
    Set<Id> contactIds = new Set <Id>();
    Map<Id,WE_FW8_NP__WESearchResult__c> resultsMap = new Map<Id,WE_FW8_NP__WESearchResult__c>();

    //Get the contact Id and populate the contactId list and resultsMap map.
    for (WE_FW8_NP__WESearchResult__c result : Trigger.New){

        contactIds.add(result.WE_FW8_NP__Contact__c);
        resultsMap.put(result.WE_FW8_NP__Contact__c,result);
    }

    //Query for the contact records of each contact Id in the contactId list and put it in a map.
    Map<Id,Contact> contactsMap= new Map<Id,Contact>([select Id from Contact where Id in:contactIds]);
    
    // Build a list of all records that will be updated at the end
    List<Contact> contactsToUpdate = new List<Contact>(contactsMap.values());
    
    //Get each contact and result record from their corresponding maps using the common contact Id key and set all the values
    for (Id myId : contactsMap.keyset()){
        
        Contact contact = contactsMap.get(myId);
        WE_FW8_NP__WESearchResult__c result = resultsMap.get(myId);

        contact.WE_P2G_Combo__c						= result.WE_FW8_NP__P2G_COMBO__c;
        contact.WE_P2G_Score__c						= result.WE_FW8_NP__P2G_SCORE__c;
        contact.WE_P2G_Score_2__c					= result.WE_FW8_NP__P2G_SCORE2__c;
		contact.WE_Estimated_Giving_Capacity__c     = result.WE_FW8_NP__Estimated_Gift_Capacity__c;
        contact.WE_Estimated_Annual_Donation__c		= result.WE_FW8_NP__EAD__c;					// Not WE_FW8_NP__EADRating__c
        contact.WE_Cash_On_Hand__c					= result.WE_FW8_NP__LiquidityRange__c;		// Not Rating
        contact.WE_Net_Worth__c						= result.WE_FW8_NP__NetworthRange__c;		// Not Rating
        contact.WE_Total_Assets__c					= result.WE_FW8_NP__AssetRange__c;			// Not WE_FW8_NP__AssetRating__c
        contact.WE_Influence__c						= result.WE_FW8_NP__Influence_Quartile__c;	// Not WE_FW8_NP__INFLUENCE_RATING__c
        contact.WE_Inclination__c					= result.WE_FW8_NP__inclinationAffil__c;
        contact.WE_Income__c						= result.WE_FW8_NP__IncomeRange__c;			// Not Rating
        contact.WE_Real_Estate_Value__c				= result.WE_FW8_NP__REAL_ESTATE_VALUE__c; 	// Not WE_FW8_NP__RealEstateValueRating__c
        contact.WE_Stock_Total_Value__c				= result.WE_FW8_NP__TotalStockRange__c;		// Not WE_FW8_NP__TotalStockValueRating__c

		//Update last updated field on contact
		contact.WE_Last_Updated__c                  = date.today();

        // Try to convert the Real Estate Count text value into a number
        try {
        	contact.WE_Property_Count__c			= Integer.valueOf(result.WE_FW8_NP__REAL_ESTATE_COUNT__c);
		} Catch (exception e) {
            
  			// it's not an Integer
  			contact.WE_Property_Count__c = 0;
        }
        
        // Don't attempt to load these, they were data loaded from Club
        //contact.WE_Income_Amount__c
        //contact.WE_Real_Estate_Amount__c
        //contact.WE_Stock_Amount__c
        
    }
update contactsToUpdate;

}