/**
 * Class: APTPS_QuoteTriggerHandler
 * Description : Quote/Proposal Trigger Helper. This class will have trigger utility methods.
 * Author : Parth Sevak, @Apttus
 **/
 
 public class APTPS_QuoteTriggerHandler {
     
     //This variable is used Skip the Methods:  insertAtleastOnePrimaryProposal. updateAtleastOnePrimaryProposal when the rule is triggered by the method: PrimaryQuoteUtility.
     public static boolean skipAtleastOneProposalMethod = FALSE;
     //static
     //Retrieve quote record types and hold in map to find out Quote with Latin America
     public static Map<Id, Schema.RecordTypeInfo> quoteRTMap = Schema.getGlobalDescribe().get('Apttus_Proposal__Proposal__c').getDescribe().getRecordTypeInfosById();

     //holds map of price list name and price list record
     public static Map<String, Apttus_Config2__PriceList__c> mapPriceListNameToRecord = new Map<String, Apttus_Config2__PriceList__c>();
          
     /*
       Method : createQuoteLineItems , @paramerter : <list_of_quote>
       Description : It creates quote line items as per associated opportunity line items of existing quote for only Latin America Quote
                      This method is supposed to be called from after insert trigger context.
     */
     public static void createQuoteLineItems(List<Apttus_Proposal__Proposal__c> quoteList) {
         //retreive related opportunity ids
         Set<Id> oppIds = new Set<Id>();
         //Create map of opportunity id with quote id
         Map<Id, Id> mapOppIdIdWithQuoteId = new Map<Id, Id>();
         
         for(Apttus_Proposal__Proposal__c quote : quoteList) {
             // GSMOD:  TEMP:   Bug in XAE prevents the setting of record type - for now will do for all
             if(quote.Apttus_Proposal__Opportunity__c != null ) {
                if(quote.Apttus_Proposal__Opportunity__c != null && quoteRTMap.get(quote.RecordTypeId).getName().containsIgnoreCase('Latin America Proposal')) {
                    oppIds.add(quote.Apttus_Proposal__Opportunity__c);
                    mapOppIdIdWithQuoteId.put(quote.Apttus_Proposal__Opportunity__c, quote.Id);
                }
             }
         }
         if(oppIds.isEmpty()) return;
         System.debug('***LineItem OppIds Size : ' + oppIds.size());
         //retrieve opportunity line items      : Product2.ProductModel,
         List<OpportunityLineItem> listOppLineItem = [Select Id, OpportunityId, DST_ID__c, TAG__c, Product2Id, Vendor_Supplier__c, Product2.Name, Product2.Description, 
             ListPrice, UnitPrice, Multiplier_PAR__c,  ProductCode, Quantity, PAR_Reference_Number__c 
             from OpportunityLineItem WHERE DST_ID__c != NULL AND OpportunityId in : oppIds];
         if(listOppLineItem != null && !listOppLineItem.isEmpty()) {
             System.debug('***LineItem For loop : in ');
             //create quote line items
             List<Apttus_Proposal__Proposal_Line_Item__c> quoteLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
             Apttus_Proposal__Proposal_Line_Item__c qLineItem;
             for(OpportunityLineItem oppLineItem : listOppLineItem) {
                 if(String.isBlank(oppLineItem.DST_ID__c)) continue;
                 System.debug('***LineItem DSTId : ' + oppLineItem.DST_ID__c);
                 qLineItem = new Apttus_Proposal__Proposal_Line_Item__c();
                 qLineItem.Apttus_Proposal__Proposal__c =  mapOppIdIdWithQuoteId.get(oppLineItem.OpportunityId);
                 qLineItem.TAG_ID__c = oppLineItem.TAG__c;
                 qLineItem.Apttus_Proposal__Product__c = oppLineItem.Product2Id;
                 qLineItem.Supplier__c = oppLineItem.Vendor_Supplier__c;
                 qLineItem.Product_Description__c = oppLineItem.Product2.Description;
                 qLineItem.Apttus_QPConfig__ListPrice__c = oppLineItem.ListPrice;
                 // GS:  Changed to Unit Price as this is where the pricing info is
                 qLineItem.List_price_Per_Unit__c = oppLineItem.UnitPrice;
                 qLineItem.Multiplier__c = oppLineItem.Multiplier_PAR__c;
                 // Added by GS
                 qLineItem.Model__c = oppLineItem.ProductCode;
                 qLineItem.Model_Supplier__c = oppLineItem.ProductCode + '-' + oppLineItem.Vendor_Supplier__c + '-' + oppLineItem.Product2.Name;
                 qLineItem.DST_ID__c = oppLineItem.DST_ID__c;
                 qLineItem.Product_Name__c = OppLineItem.Product2.Name;
                 qLineItem.Apttus_Proposal__Product__c = OppLineItem.Product2Id;
                 qLineItem.Apttus_Proposal__Quantity__c = OppLineItem.Quantity;
                 qLineItem.PAR_Reference_Number__c = OppLineItem.PAR_Reference_Number__c;
                 quoteLineItems.add(qLineItem);
                 System.debug('***LineItem Size : ' + quoteLineItems.size());
             }
             
             if(!quoteLineItems.isEmpty()) {
                 try {
                     insert quoteLineItems;
                     System.debug('***LineItems Inserted ...');
                 } catch(System.DMLException e) {
                     System.debug('DML Exception : ' + e.getMessage());
                 }
             }
             
             
         }
     }
		
	/*Method: Make Quote as Primary, @Parameter: List --> Trigger.new
      * 
      */
     private static Boolean isRunOnce = false; //avoid recursion
     public static void primaryQuoteUtility(List<Apttus_Proposal__Proposal__c> quoteList) {		//quoteList List of Trigger.new records
         if(isRunOnce == true) return;		//If this method already executed then exit the method.
         Set<Id> oppIds = new Set<Id>();	//Instantiating a set vvariable. Set is a list of Unique records.
         for(Apttus_Proposal__Proposal__c quote : quoteList) {	//Iterate over the Trigger.New records
             if(quote.RecordTypeId != null &&  //Coindition: If the quote is related to an Opportunity and Primary is True then execute the next statement.
                 quote.Apttus_Proposal__Opportunity__c != null && quote.Apttus_Proposal__Primary__c == true) {
                 oppIds.add(quote.Apttus_Proposal__Opportunity__c);
             }
         }
         if(oppIds.isEmpty()) return;	//If the set: oppIds is empty then exit the loop.
         //retrieve sibling quote and uncheck primary check box if there is.
         List<Apttus_Proposal__Proposal__c> listProposal = [Select Id, Apttus_Proposal__Opportunity__c, Apttus_Proposal__Primary__c from Apttus_Proposal__Proposal__c
             where Apttus_Proposal__Opportunity__c in :oppIds and Id not in :quoteList AND Apttus_Proposal__Primary__c = true];
         List<Apttus_Proposal__Proposal__c> quotesToUpdate = new List<Apttus_Proposal__Proposal__c>();  
         for(Apttus_Proposal__Proposal__c quote : listProposal) {
             quote.Apttus_Proposal__Primary__c  = false;
             quotesToUpdate.add(quote);
         } 
         try {
             if(!quotesToUpdate.isEmpty()) {
                 skipAtleastOneProposalMethod = TRUE;
                 update quotesToUpdate;
                 skipAtleastOneProposalMethod = FALSE;
                 isRunOnce = true;
             }
         } catch(DMLException e) {
             System.debug('***Upadate failed. ' + e.getMessage());
             throw new APTPS_DaikinGlobalException(e.getMessage());
         }
     }

	/* Trigger Context: Before Insert
     * Method Name: insertAtleastOnePrimaryProposal
     * Description: If the Quote is set to NonPrimary, then go and check if the Parent Opportunity has any other Primary Quote.
     * If there is another Primary quote then do nothing.
     * If there is no other Primary Quote then mark the Primary to True even though the user set it to False. 
     */
	private static Boolean runOnceinsertAtleastOnePrimaryProposal = false; //avoid recursion
	public static void insertAtleastOnePrimaryProposal(List<Apttus_Proposal__Proposal__c> quoteList) {
        if(runOnceinsertAtleastOnePrimaryProposal == TRUE || skipAtleastOneProposalMethod == TRUE) return;
        Set<Id> oppOldPrimary = new Set<Id>();	//Set to capture Opportunity Ids
         //Find Opportunities where Quote is changed to Non-Primary from Primary.
         for(Apttus_Proposal__Proposal__c currentQuote : quoteList){
             if(currentQuote.Apttus_Proposal__Primary__c == FALSE && currentQuote.Apttus_Proposal__Opportunity__c!=NULL)
                 oppOldPrimary.add(currentQuote.Apttus_Proposal__Opportunity__c);
         }
         //Find if the above Opportunities have any other Proposal marked as Primary in any other Before triggers.
         List<Apttus_Proposal__Proposal__c> existingPrimaryQuotes = [Select Id, Apttus_Proposal__Primary__c, Apttus_Proposal__Opportunity__c 
            														From Apttus_Proposal__Proposal__c 
            														where Apttus_Proposal__Primary__c = true AND Apttus_Proposal__Opportunity__c in :oppOldPrimary 
            														AND Id not in:quoteList];
         //Now get a Map of Opportunity Id and Proposal record. This is to check if the above Opporunity is in the list of Opportunities with Primary Quotes
         Map<Id, Apttus_Proposal__Proposal__c> newMap = new Map<Id, Apttus_Proposal__Proposal__c> ();
         for(Apttus_Proposal__Proposal__c existingPrimaryQuote: existingPrimaryQuotes){
             newMap.put(existingPrimaryQuote.Apttus_Proposal__Opportunity__c , existingPrimaryQuote);
         }
         //Now iterate over the list of Quotes.
         List<Apttus_Proposal__Proposal__c> insertProposalChanges = new List<Apttus_Proposal__Proposal__c>();
         for(Apttus_Proposal__Proposal__c currentQuote : quoteList){
             if(currentQuote.Apttus_Proposal__Primary__c == FALSE && currentQuote.Apttus_Proposal__Opportunity__c!=NULL)
                 if(!newMap.containsKey(currentQuote.Apttus_Proposal__Opportunity__c)){
                     currentQuote.Apttus_Proposal__Primary__c = TRUE;
                     insertProposalChanges.add(currentQuote);
                 }
         }
         if(insertProposalChanges.size()>0){
             runOnceinsertAtleastOnePrimaryProposal = TRUE;
         }
     }     
	
     /* Trigger Context: Before update
     * Method Name: updateAtleastOnePrimaryProposal
     * Description: If the Quote is set to NonPrimary for the first time(i.e, Set to False from True), then go and check if the Parent Opportunity has any other Primary Quote.
     * If there is another Primary quote then do nothing.
     * If there is no other Primary Quote then mark the Primary to True even though the user set it to False. 
     */
    private static Boolean runOnceupdateatleastOnePrimaryProposal = false; //avoid recursion
    public static void updateAtleastOnePrimaryProposal(List<Apttus_Proposal__Proposal__c> quoteList, Map<Id, Apttus_Proposal__Proposal__c> oldMap) {
        if(runOnceupdateatleastOnePrimaryProposal == TRUE || skipAtleastOneProposalMethod == TRUE) return;
        Set<Id> oppOldPrimary = new Set<Id>();	//Set to capture Opportunity Ids
         //Find Opportunities where Quote is changed to Non-Primary from Primary.
         for(Apttus_Proposal__Proposal__c currentQuote : quoteList){
             if((currentQuote.Apttus_Proposal__Primary__c == FALSE && oldMap.get(currentQuote.id) !=NULL  && oldMap.get(currentQuote.id).Apttus_Proposal__Primary__c ==TRUE))
                 oppOldPrimary.add(currentQuote.Apttus_Proposal__Opportunity__c);
         }
         //Find if the above Opportunities have any other Proposal marked as Primary in any other Before triggers.
         List<Apttus_Proposal__Proposal__c> existingPrimaryQuotes = [Select Id, Apttus_Proposal__Primary__c, Apttus_Proposal__Opportunity__c 
            														From Apttus_Proposal__Proposal__c 
            														where Apttus_Proposal__Primary__c = true AND Apttus_Proposal__Opportunity__c in :oppOldPrimary 
            														AND Id not in:quoteList];
         //Now get a Map of Opportunity Id and Proposal record. This is to check if the above Opporunity is in the list of Opportunities with Primary Quotes
         Map<Id, Apttus_Proposal__Proposal__c> newMap = new Map<Id, Apttus_Proposal__Proposal__c> ();
         for(Apttus_Proposal__Proposal__c existingPrimaryQuote: existingPrimaryQuotes){
             newMap.put(existingPrimaryQuote.Apttus_Proposal__Opportunity__c , existingPrimaryQuote);
         }
         //Now iterate over the list of Quotes.
         List<Apttus_Proposal__Proposal__c> insertProposalChanges = new List<Apttus_Proposal__Proposal__c>();
         for(Apttus_Proposal__Proposal__c currentQuote : quoteList){
             if(currentQuote.Apttus_Proposal__Primary__c == FALSE && oldMap.get(currentQuote.id).Apttus_Proposal__Primary__c ==TRUE)
                 if(!newMap.containsKey(currentQuote.Apttus_Proposal__Opportunity__c)){
                     currentQuote.Apttus_Proposal__Primary__c = TRUE;
                     insertProposalChanges.add(currentQuote);
                 }
         }
         
         if(insertProposalChanges.size()>0){
             runOnceupdateatleastOnePrimaryProposal = TRUE;
         }
     } 
   
     
     /*
         Method : deleteDocLineItemsOfAcceptedQuotes
         Description : This method is supposed to be called from after update trigger context.
                     It will delete document line items, if Quote's approval stage is in 'Accepted'
     */
     private static Boolean isRunDocLinesDeleteAcceptedMethod = false; //avoid recursion
     public static void deleteDocLineItemsOfAcceptedQuotes(List<Apttus_Proposal__Proposal__c> quoteList) {
         if(isRunDocLinesDeleteAcceptedMethod == true) return;
         Set<Id> acceptedQuoteIds = new Set<Id>();
         for(Apttus_Proposal__Proposal__c quote : quoteList) {
             if(quote.Apttus_Proposal__Approval_Stage__c == 'Accepted') {
                 acceptedQuoteIds.add(quote.Id);
             }
         }
         if(acceptedQuoteIds.isEmpty()) return;
         List<APTPS_Document_Line_Item__c> docLineItemsToBeDeleted = [Select Id from APTPS_Document_Line_Item__c 
             where APTPS_Quote_Proposal__c in :acceptedQuoteIds];
         if(docLineItemsToBeDeleted != null && !docLineItemsToBeDeleted.isEmpty()) {
             try {
                 delete docLineItemsToBeDeleted;
                 isRunDocLinesDeleteAcceptedMethod = true;
             } catch(DMLException e) {
                 System.debug('***Excetion while deleting document line items ' + e.getMessage());
                 throw new APTPS_DaikinGlobalException('Error while deleting document lines ' + e.getMessage());
             }
         }    
             
     }
     
     /*
         Method : setQuoteDefaults , parameter : list_of_quote
         Description : This method is supposed to be called from before insert trigger context.
         Requirement for Approval - Set these fields from Owner Record : DM, RO SM, RSM, RGM
     */
     public static void setQuoteDefaults(List<Apttus_Proposal__Proposal__c> quoteList) {
         User currentUser = [Select DM_District_Manager__c, ROSM_Regional_Owner_Sales_Manager__c, 
             RSM_Regional_Service_Manager__c, RGM_Regional_General_Manager__c from User where Id = :UserInfo.getUserId()];
         //call method to populate price list map
         buildUpPriceListMapForNorthAmericaQuotes(quoteList);
         //get map of opp ids with opportunity records
         Map<Id, Opportunity> mapIdToOpportunity =  getMapOfOppIdToOpportunity(quoteList);
         for(Apttus_Proposal__Proposal__c quote : quoteList) {
             if(quote.RecordTypeId != null && quoteRTMap.get(quote.RecordTypeId).getName().containsIgnoreCase('Latin America Proposal')) {
                 continue;
             }
             //default Line of Business Field from associated opportunity
             if(mapIdToOpportunity.get(quote.Apttus_Proposal__Opportunity__c) != null) { 
                quote.Line_of_Business__c = mapIdToOpportunity.get(quote.Apttus_Proposal__Opportunity__c).Line_of_Business__c;
                quote.Estimated_Close_Date__c = mapIdToOpportunity.get(quote.Apttus_Proposal__Opportunity__c).CloseDate;  
             }
             System.debug('***quote.Line_of_Business__c - ' + quote.Line_of_Business__c);
             //user fields
             quote.DM_District_Manager__c = currentUser.DM_District_Manager__c;
             quote.ROSM_Regional_Owner_Sales_Manager__c = currentUser.ROSM_Regional_Owner_Sales_Manager__c;
             quote.RSM_Regional_Service_Manager__c = currentUser.RSM_Regional_Service_Manager__c;
             quote.RGM_Regional_General_Manager__c = currentUser.RGM_Regional_General_Manager__c;
             System.debug('*** RecordTypeId : ' + quote.RecordTypeId);
             System.debug('*** map value ' + quoteRTMap.get(quote.RecordTypeId).getName().containsIgnoreCase('North America Proposal'));
             if(quote.RecordTypeId != null && quoteRTMap.get(quote.RecordTypeId).getName().containsIgnoreCase('North America Proposal')) {
                 //retrieve custom setting to fetch price list name here
                 APTPS_Configurable_Variables__c northAmericaQuoteCS = APTPS_Configurable_Variables__c.getValues('North_America_Quote_Price_List');
                 String northAmericaPLName; //holds price list name
                 if(northAmericaQuoteCS != null) {
                     northAmericaPLName = northAmericaQuoteCS.APTPS_Variable_Value__c;
                 }
                 System.debug('*** northAmericaPLName ' + northAmericaPLName);
                 if(!String.isBlank(northAmericaPLName) && mapPriceListNameToRecord != null && !mapPriceListNameToRecord.isEmpty() &&
                    mapPriceListNameToRecord.get(northAmericaPLName) != null)
                     quote.Apttus_QPConfig__PriceListId__c = mapPriceListNameToRecord.get(northAmericaPLName).Id;
                     System.debug('*** quote pl id ' + quote.Apttus_QPConfig__PriceListId__c);
             }
         }
         
            
             
     }
     
     /*
     Scenario 2 : Quote Synchronization : Delete Opp Lines with DST Id but no corresponding Quote Lines 
     */
     public static void deleteOppLineItemsWithDST(List<Apttus_Proposal__Proposal__c> quoteList, Map<Id, Apttus_Proposal__Proposal__c> oldQuoteMap) {
         List<Apttus_Proposal__Proposal__c> quotes = new List<Apttus_Proposal__Proposal__c>();
         Set<Id> oppIds = new Set<Id>();
         for(Apttus_Proposal__Proposal__c quote : quoteList) {
             if(quote.Apttus_Proposal__Approval_Stage__c == 'Accepted' && oldQuoteMap.get(quote.Id).Apttus_Proposal__Approval_Stage__c != 'Accepted') {
                 //scenario 2
                 quotes.add(quote);
                 oppIds.add(quote.Apttus_Proposal__Opportunity__c);
             }
         }
         //retrieve opp lines
         List<OpportunityLineItem> oppLinesWithDST = [Select Id, DST_ID__c, Product2Id , OpportunityId
            from OpportunityLineItem where OpportunityId in :oppIds AND (DST_ID__c != null OR DST_ID__c != '') ];
         
         //retrieve quote lines
         List<Apttus_Proposal__Proposal_Line_Item__c> quoteLines = [Select Id, Apttus_Proposal__Product__c, Apttus_Proposal__Proposal__c from Apttus_Proposal__Proposal_Line_Item__c Where 
         Apttus_Proposal__Proposal__c in :quotes];
         
         if(oppLinesWithDST.isEmpty()) return; 
         Map <Id, OpportunityLineItem> OppLinesWithQuoteLinesMap = new Map<Id, OpportunityLineItem>();
         for(Apttus_Proposal__Proposal__c quote : quotes) {
             for(OpportunityLineItem oppLine : oppLinesWithDST) {
                 for(Apttus_Proposal__Proposal_Line_Item__c quoteLine : quoteLines) {
                     if(oppLine.OpportunityId == quote.Apttus_Proposal__Opportunity__c && quoteLine.Apttus_Proposal__Proposal__c == quote.Id) {
                         if(oppLine.Product2Id == quoteLine.Apttus_Proposal__Product__c) {
                            OppLinesWithQuoteLinesMap.put(oppLine.Id, oppLine);
                         }
                     }
                 }
            }    
         }
         List<OpportunityLineItem> deprecatedOppLines = new List<OpportunityLineItem>();
         for(OpportunityLineItem oppLine : oppLinesWithDST) {
             if(OppLinesWithQuoteLinesMap.get(oppLine.Id) == null) {
                 deprecatedOppLines.add(oppLine);
             }
         }
         
         if(!deprecatedOppLines.isEmpty()) {
             delete deprecatedOppLines;
         }
           
     }
     
     /*
        Method : getQuotsForSyncOperation , parameters : List<Apttus_Proposal__Proposal__c> quoteList, Map<Id, Apttus_Proposal__Proposal__c> oldQuoteMap
        Descritpion : it returns validated quote list.
     */
     public static List<Apttus_Proposal__Proposal__c> getQuotsForSyncOperation(List<Apttus_Proposal__Proposal__c> quoteList, Map<Id, Apttus_Proposal__Proposal__c> oldQuoteMap) {
         List<Apttus_Proposal__Proposal__c> quotes = new List<Apttus_Proposal__Proposal__c>();
         for(Apttus_Proposal__Proposal__c quote : quoteList) {
             if(quote.Apttus_Proposal__Approval_Stage__c != 'Accepted' &&
                ((quote.Apttus_Proposal__Primary__c == true && oldQuoteMap.get(quote.Id).Apttus_Proposal__Primary__c == false) 
                 ||(quote.Apttus_QPConfig__ConfigurationFinalizedDate__c != oldQuoteMap.get(quote.Id).Apttus_QPConfig__ConfigurationFinalizedDate__c && quote.Apttus_Proposal__Primary__c == true )
                )
                ) {
                 //scenario 1    
                 quotes.add(quote);
             } else if(quote.Apttus_Proposal__Approval_Stage__c == 'Accepted' && oldQuoteMap.get(quote.Id).Apttus_Proposal__Approval_Stage__c != 'Accepted') {
                 //scenario 2
                 System.debug('*** IN ELSE IF SDF - ' + quote);
                 quotes.add(quote);
             }
         }
         return quotes;
     }
     
     /*
        Method : deleteOppLinesWithoutDSTIds , parameters : list_of_quote
        Description : This should be executed before synchronizaOpportunilyLines method . It delets opp lines without DST Ids
     */
     public static void deleteOppLinesWithoutDSTIds(List<Apttus_Proposal__Proposal__c> quotes) {
         Map<Id, Opportunity> mapIdToOpportunity =  getMapOfOppIdToOpportunity(quotes);
         Set<Id> oppLineItemIds = new set<Id>();
         for(Opportunity opp : mapIdToOpportunity.values()) {
            if(opp.OpportunityLineItems != null && !opp.OpportunityLineItems.isEmpty()) {
                for(OpportunityLineItem oppLineItem : opp.OpportunityLineItems) {
                    if(String.isBlank(oppLineItem.DST_ID__c)) {
                        oppLineItemIds.add(oppLineItem.Id);
                    } 
                }
            }
         }
         if(!oppLineItemIds.isEmpty()) APTPS_QuoteTriggerHandlerSupport.deleteOpportunityLineItems(oppLineItemIds);
     }
     
     /*
        Method : updateOpportunitiesWithPricebook , parameter : list_of_quote
        Description : This should be executed before synchronizaOpportunilyLines method. It will assign default price book to opportunity if it's missing. 
     */
     public static void updateOpportunitiesWithPricebook(List<Apttus_Proposal__Proposal__c> quotes) {
         Map<Id, Opportunity> mapIdToOpportunity =  getMapOfOppIdToOpportunity(quotes);
         //update opportunity with pricebook if not
         List<Opportunity> listOpptyToBeUpdated = new List<Opportunity>();
         for(opportunity opp : mapIdToOpportunity.values()) {
             if(opp.Pricebook2Id == null) {
                 listOpptyToBeUpdated.add(opp);
             }
         }
         if(listOpptyToBeUpdated != null && !listOpptyToBeUpdated.isEmpty()) {
             updateOpptyListWithStandardPriceBook(listOpptyToBeUpdated);    
         }
     }
     
      //This class concatenates 8 TK clauses and populates a field on the quote.
    public static void concatenateTKClauses(map<Id, Apttus_Proposal__Proposal__c> quoteList, map<Id, Apttus_Proposal__Proposal__c> oldQuoteMap){
        for(Apttus_Proposal__Proposal__c apLoop: quoteList.values()){
            //Need to add 8 turn key product categories ...... Look at Ancester field and examine how many levels have to check to see if the category is matching. Ancestor is a self relationship field.
            
            if(apLoop.Apttus_QPConfig__ConfigurationFinalizedDate__c !=oldQuoteMap.get(apLoop.id).Apttus_QPConfig__ConfigurationFinalizedDate__c && apLoop.RecordTypeID == '012L00000000eRS')
            apLoop.Included_Line_Item_Categories__c = '';
        }   
    
        for (Apttus_Proposal__Proposal_Line_Item__c qLI2: [SELECT Id, Apttus_QPConfig__ClassificationId__r.Apttus_Config2__AncestorId__r.Name, Apttus_QPConfig__ClassificationHierarchy__c, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.name, Apttus_Proposal__Proposal__c FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c IN:quoteList.Keyset()]){
            system.debug('in second for loop:'+ qLI2.Apttus_Proposal__Product__r.Name);
            if(qLI2.Apttus_QPConfig__ClassificationHierarchy__c != NULL){
                String[] s = qLI2.Apttus_QPConfig__ClassificationHierarchy__c.split(' \\| ', 4);
                System.debug('s1 is'+ s);
                //System.debug('s2 is '+ s[2]);
                    
                    if(((s.size() > 2 && s[2] !=NULL) && (s[2] == 'AC Scroll' || s[2] == 'AC Screw' || s[2] == 'WC Scroll' || s[2] == 'WC Scroll - Heat Recovery' || s[2] == 'WC Screw' || s[2] == 'WC Mag Bearing Cent' || s[2] == 'WC Cent' || s[2] == 'WC Cent - Heat Recovery' || s[2] == 'WC Recip - Heat Recovery' || s[2] == 'RTU' || s[2] == 'AHU' || s[2] == 'Condensing Unit' || s[2] == 'Split system AH')) || qLI2.Apttus_Proposal__Product__r.Name == 'Boilers' || qLI2.Apttus_Proposal__Product__r.Name == 'Air Handler' || qLI2.Apttus_Proposal__Product__r.Name == 'AC Chiller' || qLI2.Apttus_Proposal__Product__r.Name== 'WC Chiller' || qLI2.Apttus_Proposal__Product__r.Name == 'Pumps' || qLI2.Apttus_Proposal__Product__r.Name == 'Pumps - Boiler Feedwater' || qLI2.Apttus_Proposal__Product__r.Name == 'Pumps - Horizontal Split Case' || qLI2.Apttus_Proposal__Product__r.Name == 'Pumps - Vertical Split Case' || qLI2.Apttus_Proposal__Product__r.Name == 'Pumps End Suction' || qLI2.Apttus_Proposal__Product__r.Name == 'Split Systems' || qLI2.Apttus_Proposal__Product__r.Name == 'Sump Pumps')
                    {
                        Apttus_Proposal__Proposal__c Qt = quoteList.get(qLI2.Apttus_Proposal__Proposal__c);
                        if(Qt.Apttus_QPConfig__ConfigurationFinalizedDate__c !=oldQuoteMap.get(Qt.id).Apttus_QPConfig__ConfigurationFinalizedDate__c && Qt.RecordTypeID == '012L00000000eRS'){
                            if(Qt.Included_Line_Item_Categories__c =='' || Qt.Included_Line_Item_Categories__c ==null){
                                if(s.size() > 2 && s[2] !=NULL) {
                                if(s[2] == 'AC Scroll' || s[2] == 'AC Screw')
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Description AC Chiller'; 
                                else if(s[2] == 'WC Scroll' || s[2] == 'WC Scroll - Heat Recovery' || s[2] == 'WC Screw' || s[2] == 'WC Mag Bearing Cent' || s[2] == 'WC Cent' || s[2] == 'WC Cent - Heat Recovery' || s[2] == 'WC Recip - Heat Recovery')
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Description WC Chiller';
                                else if(s[2] == 'RTU')
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Description RTU'; 
                                else if(s[2] == 'AHU' || s[2] == 'Condensing Unit')
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Description AHU';
                                else if(s[2] == 'Split system AH')
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Description Split System';
                                }
                                else if(qLI2.Apttus_Proposal__Product__r.Name == 'Boilers')
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Description Boiler';
                                else if(qLI2.Apttus_Proposal__Product__r.Name == 'Air Handler')
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Descriptions AHU'; 
                                else if(qLI2.Apttus_Proposal__Product__r.Name == 'AC Chiller')
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Description AC Chiller';
                                else if(qLI2.Apttus_Proposal__Product__r.Name== 'WC Chiller')
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Description WC Chiller';
                                else if(qLI2.Apttus_Proposal__Product__r.Name == 'Split Systems')
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Description Split System';
                                else 
                                    Qt.Included_Line_Item_Categories__c = 'Customer Scope Description Pump Install';

                            }
                        
                       
            
                            else if(s.size() > 1 && s[2] !=NULL){
                                if(s[2] == 'AC Scroll' || s[2] == 'AC Screw' || qLI2.Apttus_Proposal__Product__r.Name == 'AC Chiller'){
                                if(!Qt.Included_Line_Item_Categories__c.contains('Customer Scope Description AC Chiller'))
                                    Qt.Included_Line_Item_Categories__c = Qt.Included_Line_Item_Categories__c  +', ' +  'Customer Scope Description AC Chiller';   
                            }
                            
                            else if(s[2] == 'WC Scroll' || s[2] == 'WC Scroll - Heat Recovery' || s[2] == 'WC Screw' || s[2] == 'WC Mag Bearing Cent' || s[2] == 'WC Cent' || s[2] == 'WC Cent - Heat Recovery' || s[2] == 'WC Recip - Heat Recovery' ){
                                if(!Qt.Included_Line_Item_Categories__c.contains('Customer Scope Description WC Chiller'))
                                Qt.Included_Line_Item_Categories__c = Qt.Included_Line_Item_Categories__c  +', ' + 'Customer Scope Description WC Chiller';   
                            }
                            else if(s[2] == 'RTU'){
                                if(!Qt.Included_Line_Item_Categories__c.contains('Customer Scope Description RTU'))
                                Qt.Included_Line_Item_Categories__c = Qt.Included_Line_Item_Categories__c  +', ' + 'Customer Scope Description RTU';   
                            }
                            else if(s[2] == 'AHU' || s[2] == 'Condensing Unit'){
                                if(!Qt.Included_Line_Item_Categories__c.contains('Customer Scope Description AHU'))
                                    Qt.Included_Line_Item_Categories__c = Qt.Included_Line_Item_Categories__c  +', ' + 'Customer Scope Description AHU';   
                            }
                            else if(s[2] == 'Split system AH'){
                                if(!Qt.Included_Line_Item_Categories__c.contains('Customer Scope Description Split System'))
                                    Qt.Included_Line_Item_Categories__c = Qt.Included_Line_Item_Categories__c  +', ' + 'Customer Scope Description Split System';   
                            }
                                }
                            
                            else if(qLI2.Apttus_Proposal__Product__r.Name == 'Boilers'){
                                if(!Qt.Included_Line_Item_Categories__c.contains('Customer Scope Description Boiler'))
                                    Qt.Included_Line_Item_Categories__c = Qt.Included_Line_Item_Categories__c  +', ' + 'Customer Scope Description Boiler';   
                            } 
                            else if(qLI2.Apttus_Proposal__Product__r.Name== 'WC Chiller'){
                                if(!Qt.Included_Line_Item_Categories__c.contains('Customer Scope Description WC Chiller'))
                                    Qt.Included_Line_Item_Categories__c = Qt.Included_Line_Item_Categories__c  +', ' + 'Customer Scope Description WC Chiller';   
                            } 
                            else if(qLI2.Apttus_Proposal__Product__r.Name == 'Split Systems'){
                                if(!Qt.Included_Line_Item_Categories__c.contains('Customer Scope Description Split System'))
                                    Qt.Included_Line_Item_Categories__c = Qt.Included_Line_Item_Categories__c  +', ' + 'Customer Scope Description Split System';   
                            }
                            else if(!Qt.Included_Line_Item_Categories__c.contains('Customer Scope Description Pump Install')){
                                    Qt.Included_Line_Item_Categories__c = Qt.Included_Line_Item_Categories__c  +', ' + 'Customer Scope Description Pump Install';   
                            }
                            
                     
                                
                       
                        }
                    }
                
            }
        }
    }
    
    //This method sychronizes fields between quote and Opportunity After Isert/Update
    public static void syncQuotetoOpportunity(map<Id, Apttus_Proposal__Proposal__c> quoteList, map<Id, Apttus_Proposal__Proposal__c> oldQuoteMap){
        
        List<Opportunity> updateOpps = new List<Opportunity> ();
        //This Query gets field information from Opportunity and related Quote/Proposal through Synced Quote Proposal lookup field on Opportunity
        //Populate the Synced_Quote_Proposal__c in the logic
        //1) Loop through Trigger.newmap Quote pROPOSAL RECORDS AND generate list of Opportunities
        List <Id> opp = new List<Id>();
        for(Apttus_Proposal__Proposal__c q: quoteList.values()){
            if(q.Apttus_Proposal__Primary__c == TRUE && q.RecordTypeId== '012C0000000GTQQ')
            	opp.add(q.Apttus_Proposal__Opportunity__c);
        }
        //List.add(Opp Id from Quote);Here i have to get the Opportunity ID.
        //
        if(opp.size()>0){
        	Map<Id,Opportunity> o = new Map<Id, Opportunity> ([SELECT Id, Synced_Quote_Proposal__c, CloseDate,Apttus_GM__c, GM_Percentage__c, Total_Discount__c, Bulk_Exchange_Rate__c, GM_Approval_Status__c, Local_Currency__c, Opportunity_Quote_Status__c, Total_cost__c from Opportunity WHERE Id IN: opp]);
        	for(Apttus_Proposal__Proposal__c q: quoteList.values()){
            	if(q.Apttus_Proposal__Primary__c == TRUE  && q.RecordTypeId== '012C0000000GTQQ'){
              		opportunity x = o.get(q.Apttus_Proposal__Opportunity__c);
                	if(x!=NULL){
                		x.Synced_Quote_Proposal__c = q.id;
                		//x.CloseDate = q.Estimated_Close_Date__c;
                        x.Apttus_GM__c = q.GM__c;
                        x.GM_Percentage__c = q.GM_Percentage__c;
                        x.Total_Discount__c = q.Total_Discount__c;
                        x.Bulk_Exchange_Rate__c = q.Bulk_Exchange_Rate__c;
                        x.GM_Approval_Status__c = q.Margin_Approval_Status__c;
                        x.Local_Currency__c = q.Local_Currency__c;
                        x.Opportunity_Quote_Status__c = q.Apttus_Proposal__Approval_Stage__c;
                        x.Total_cost__c = q.Sum_Total_Cost__c;
                		updateOpps.add(x);
            		}
            	}
    		}
    	}
        if(updateOpps.size()>0)
        update updateOpps;
    }
    
   
     
     /*
         Method : synchronizeOpportunityLineItems, parameter : list_of_quote
         Description : Module : Quote Synchronization. This method is supposed to be called on After context of trigger.
         1. If Quote is not accepted and quote line item doesn't have DST Id and alternate sets to false, then create opportunity line
          item , else if DST Id is found, then update associated opportunity line item record, else if DST Id is blank on
          Opportunity Line Item, then delete them. 
     */
     public static void synchronizeOpportunityLineItems(List<Apttus_Proposal__Proposal__c> quoteList, Map<Id, Apttus_Proposal__Proposal__c> oldQuoteMap) {
         List<Apttus_Proposal__Proposal__c> quotes = APTPS_QuoteTriggerHandler.getQuotsForSyncOperation(quoteList, oldQuoteMap);
         if(quotes.isEmpty()) return;
         //delete opp lines with DST Ids
         APTPS_QuoteTriggerHandler.deleteOppLineItemsWithDST(quoteList, oldQuoteMap);
         //delete opp lines without DST Ids
         APTPS_QuoteTriggerHandler.deleteOppLinesWithoutDSTIds(quotes);
         //update opportunity with pricebook if not
         APTPS_QuoteTriggerHandler.updateOpportunitiesWithPricebook(quotes);
         
         //holds map of quote id with associated opportunity record
         Map<Id, Opportunity> mapIdToOpportunity =  APTPS_QuoteTriggerHandler.getMapOfOppIdToOpportunity(quotes);
         //update existing line items having DST ID , create map of existing opportunity line items with opportunity 
         Map<Id, List<OpportunityLineItem>> mapOpptyWithLineItemsDST = new Map<Id, List<OpportunityLineItem>>();
         //this loop populated mapOpptyWithLineItemDST to validate which opp line needed to be updated.
         for(Opportunity opp : mapIdToOpportunity.values()) {
            if(opp.OpportunityLineItems != null && !opp.OpportunityLineItems.isEmpty()) {
                for(OpportunityLineItem oppLineItem : opp.OpportunityLineItems) {
                    if(!String.isBlank(oppLineItem.DST_ID__c)) {
                        if(mapOpptyWithLineItemsDST.containsKey(opp.Id)) {
                            mapOpptyWithLineItemsDST.get(opp.Id).add(oppLineItem);
                        } else {
                            mapOpptyWithLineItemsDST.put(opp.Id, new List<OpportunityLineItem>{oppLineItem});
                        }
                    }
                }
            }
         }
         //Sync with line items
         //first get quote line items associated with quotes
         Map<Id, Apttus_Proposal__Proposal__c> quoteMap = new Map<Id, Apttus_Proposal__Proposal__c>(quotes);
         Set<Id> quoteIds = quoteMap.keyset();
         List<Apttus_Proposal__Proposal_Line_Item__c> quoteLineItems = APTPS_QuoteTriggerHandlerSupport.getLineItemsForQuotes(quoteIds);
         if(quoteLineItems.isEmpty()) return;
         
         //Get Set of product ids associated with all quote line items; set of opportunities' pricebook ids and currency codes
         Set<Id> productIds = new Set<Id>();
         Map<Id, Apttus_Proposal__Proposal_Line_Item__c> mapProductIdTOQuoteLine = new Map<Id, Apttus_Proposal__Proposal_Line_Item__c>();
         for(Apttus_Proposal__Proposal_Line_Item__c quoteLineItem : quoteLineItems) {
             System.debug('quoteLineItem.Apttus_Proposal__Product__c - ' + quoteLineItem.Apttus_Proposal__Product__c);
             if(quoteLineItem.Apttus_Proposal__Product__c != null) {
                 productIds.add(quoteLineItem.Apttus_Proposal__Product__c);
                 mapProductIdTOQuoteLine.put(quoteLineItem.Apttus_Proposal__Product__c, quoteLineItem);
             }
         }
         List<Opportunity> finalOpptyList = [Select Id, Pricebook2Id from Opportunity where id in :mapIdToOpportunity.keySet()];
         Map<Id, Opportunity> mapFinalOpptyList = new Map<Id, Opportunity>(finalOpptyList);
         Set<Id> opptyPBIds = new Set<Id>();
         for(Opportunity oppty : finalOpptyList) {
             System.debug('oppty.Pricebook2Id - ' + oppty.Pricebook2Id);
             if(oppty.Pricebook2Id != null) {
                 opptyPBIds.add(oppty.Pricebook2Id);
             }
         }
         System.debug('opptyPBIds.size() - '  +opptyPBIds.size());
         List<Id> listOpptyPBId = new List<Id>(); listOpptyPBId.addAll(opptyPBIds);
         //need to clause with prodcuct id, pricebook2id - seems that Daikin Configure Products don't have associated with PricebookEntry
         Map<Id, PricebookEntry> mapPriceBookToEntry = buildUpMapOfPriceBookWithEntry(productIds, listOpptyPBId);
         //holds variables for dml on opp lines item records
         List<OpportunityLineItem> newOppLineItems = new List<OpportunityLineItem>();
         List<OpportunityLineItem> oppLineItemsToBeUpdated = new List<OpportunityLineItem>();
         Opportunity oppty;
         for(Apttus_Proposal__Proposal__c quote : quotes) {
            OpportunityLineItem oppLineItem;   
             for(Apttus_Proposal__Proposal_Line_Item__c quoteLineItem : quoteLineItems) {
                 oppLineItem = new OpportunityLineItem();
                 if(quoteLineItem.Apttus_Proposal__Proposal__c != quote.Id) continue;
                 System.debug('*** LA Test in for loop');
                 oppLineItem.APTPS_Product_Id__c = quoteLineItem.Apttus_Proposal__Product__c; //apply price book entry if blank
                 if(String.isBlank(quoteLineItem.DST_ID__c) && quoteLineItem.Alternate__c == false) {
                     System.debug('*** LA Test in IF');
                     //create opportunity line item
                     oppty = mapIdToOpportunity.get(quote.Apttus_Proposal__Opportunity__c);
                     //assign pricebook entry to opp line item
                     if(mapPriceBookToEntry != null && !mapPriceBookToEntry.isEmpty()) {
                          if(mapPriceBookToEntry.get(quoteLineItem.Apttus_Proposal__Product__c) != null) {
                              System.debug('*** mapPriceBookToEntry.get(quoteLineItem.Apttus_Proposal__Product__c) - ' + mapPriceBookToEntry.get(quoteLineItem.Apttus_Proposal__Product__c));
                              System.debug('pbEntryId - Get *** ' + mapPriceBookToEntry.get(quoteLineItem.Apttus_Proposal__Product__c));
                              PriceBookEntry pbE1 = mapPriceBookToEntry.get(quoteLineItem.Apttus_Proposal__Product__c);
                              Id pbEntryId = mapPriceBookToEntry.get(quoteLineItem.Apttus_Proposal__Product__c).Id;
                              if(pbE1 != null) {
                                  oppLineItem.priceBookEntryId = pbE1.Id; 
                              }
                              System.debug('*** LA Test in IF Line Item');
                          } else {
                              System.debug('*** no error : price book will be assigned : ' + quoteLineItem.Apttus_Proposal__Product__c);
                              /*
                              //do nothing, price book will be assigned by system to this product.
                              quote.addError('Price book of Product is not in sync with Opportunity.');
                              return;
                              */   
                          }
                          
                     }
                     System.debug('*** oppLineItem.priceBookEntryId ' + oppLineItem.priceBookEntryId);
                     oppLineItem.opportunityId = oppty.Id;
                     oppLineItem = APTPS_QuoteTriggerHandlerSupport.populateOppLineItem(oppLineItem, quoteLineItem);
                     //oppLineItem.Quantity = 1;
                     if(String.isBlank(oppLineItem.Item_Number__c)) oppLineItem.Item_Number__c = '1';
                     oppLineItem.Exchange_Rate__c = 1; //This can't be blank
                     newOppLineItems.add(oppLineItem);
                     System.debug('*** oppLineItem - ' + oppLineItem);
                 } else if(!String.isBlank(quoteLineItem.DST_ID__c)) {
                     //update the corresponding opportunity line item based on DST Id
                     if(mapOpptyWithLineItemsDST != null && !mapOpptyWithLineItemsDST.isEmpty()) {
                         oppty = mapIdToOpportunity.get(quote.Apttus_Proposal__Opportunity__c);
                         List<OpportunityLineItem> oppLineItems = mapOpptyWithLineItemsDST.get(oppty.Id);
                         if(oppLineItems != null && !oppLineItems.isEmpty()) {
                             for(OpportunityLineItem oppLineItem1 : oppLineItems) {
                                 if(oppLineItem1.Product2Id == quoteLineItem.Apttus_Proposal__Product__c) {
                                     oppLineItem1 = APTPS_QuoteTriggerHandlerSupport.populateOppLineItem(oppLineItem1, quoteLineItem);
                                     oppLineItem1.APTPS_Product_Id__c = quoteLineItem.Apttus_Proposal__Product__c;
                                     oppLineItemsToBeUpdated.add(oppLineItem1);
                                     System.debug('*** oppLineItem1 *** - ' + oppLineItem1);
                                 }
                             }
                         }
                     }
                 } else {
                     //do nothing    
                 }
             }
         }
         
         //insert new opportunity line items
         APTPS_QuoteTriggerHandler.saveOppLineItems(newOppLineItems);
         //update existing opportunity line items having dst id
         APTPS_QuoteTriggerHandler.saveOppLineItems(oppLineItemsToBeUpdated);
        
     }
     
     /*
        Method : saveOppLineItems , parameters : list_of_opportunity line item
        Description : it performs upsert operations on opp lines
     */
     public static void saveOppLineItems(List<OpportunityLineItem> oppLineItems) {
         List<OpportunityLineItem> linesWithPBEntry = new List<OpportunityLineItem>();
         Map<Id, OpportunityLineItem> mapProductToLineItem = new Map<Id, OpportunityLineItem>();
         Set<Id> oppIds = new Set<Id>();
         for(OpportunityLineItem oppLineItem : oppLineItems) {
             if(oppLineItem.priceBookEntryId == null && oppLineItem.Product2Id == null) {
                 if(!String.isBlank(oppLineItem.APTPS_Product_Id__c)) {
                     mapProductToLineItem.put(oppLineItem.APTPS_Product_Id__c, oppLineItem);
                     oppIds.add(oppLineItem.OpportunityId);
                 }
             } else {
                 linesWithPBEntry.add(oppLineItem);
             }
         }
         if(!linesWithPBEntry.isEmpty()) upsert linesWithPBEntry;
         if(!mapProductToLineItem.isEmpty()) {
             if(oppIds.isEmpty()) return;
             List<PricebookEntry> existingPBEntries = [Select Id, Product2Id, Pricebook2Id from PricebookEntry where Product2Id in :mapProductToLineItem.keySet()];
             map<Id, PricebookEntry> mapProductIdToPBEntry = new map<Id, PricebookEntry>();
             if(existingPBEntries != null && !existingPBEntries.isEmpty()) {
                for(PricebookEntry pbEntry : existingPBEntries) {
                    mapProductIdToPBEntry.put(pbEntry.Product2Id, pbEntry);
                }
             }
             Map<Id, Opportunity> mapIdToOpp = new Map<Id, Opportunity>([Select Pricebook2Id from Opportunity where Id in :oppIds]);
             Pricebook2 stdPriceBook;
             try {
                stdPriceBook = [SELECT Id, IsStandard, Name, IsActive FROM Pricebook2 WHERE IsStandard = true AND IsActive = true limit 1];
             } catch(QueryException e) { }
             //first assign standard price book
             List<PriceBookEntry> stdPBEntries = new List<PriceBookEntry>();
             //then assign custom price book
             List<PricebookEntry> customPBEntries = new List<PricebookEntry>();
             OpportunityLineItem oppLine;
             for(Id prodId : mapProductToLineItem.keySet()) {
                 oppLine = mapProductToLineItem.get(prodId);
                 if(mapProductIdToPBEntry != null && mapProductIdToPBEntry.get(prodId) != null) continue;
                 if(stdPriceBook != null) {
                    PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = stdPriceBook.Id, Product2Id = prodId, UnitPrice = 10000, IsActive = true); 
                    stdPBEntries.add(standardPrice);
                    if(mapIdToOpp.get(oppLine.OpportunityId).Pricebook2Id == stdPriceBook.Id) continue;
                 }
                 PricebookEntry customPrice = new PricebookEntry();
                 if(mapIdToOpp.get(oppLine.OpportunityId).Pricebook2Id != null) {
                     customPrice.Pricebook2Id = mapIdToOpp.get(oppLine.OpportunityId).Pricebook2Id;
                     customPrice.Product2Id = prodId;
                     customPrice.UnitPrice = 12000;
                     customPrice.IsActive = true;
                     customPBEntries.add(customPrice);
                 }
             }
             //standard 
             Map<Id, PriceBookEntry> stdPBEntriesMap = new Map<Id, PriceBookEntry>();
             if(!stdPBEntries.isEmpty()) {
                 try {
                     if(test.isRunningTest()) {
                     
                     } else {
                         upsert stdPBEntries;
                     }
                 } catch(Exception e) { throw new APTPS_DaikinGlobalException('Error while saving standard prices : ' + e.getMessage());
                 }
                 for(PriceBookEntry stdEntry : stdPBEntries) {
                     stdPBEntriesMap.put(stdEntry.Product2Id, stdEntry);
                 }
             }
             //standard 
             Map<Id, PriceBookEntry> customPBEntriesMap = new Map<Id, PriceBookEntry>();
             if(!customPBEntries.isEmpty()) {
                 try {
                     upsert customPBEntries;
                 } catch(Exception e) { throw new APTPS_DaikinGlobalException('Error while saving custom prices : ' + e.getMessage());}
                 for(PriceBookEntry customEntry : customPBEntries) {
                     customPBEntriesMap.put(customEntry.Product2Id, customEntry);
                 }
             }
             List<OpportunityLineItem> assignedPBLines = new List<OpportunityLineItem>();
             for(OpportunityLineItem oppLineItem : mapProductToLineItem.values()) {
                 if(mapIdToOpp.get(oppLineItem.OpportunityId).Pricebook2Id == stdPriceBook.Id) {
                     if(stdPBEntriesMap != null && !stdPBEntriesMap.isEmpty()) {
                        oppLineItem.PriceBookEntryId = stdPBEntriesMap.get(oppLine.APTPS_Product_Id__c).Id;
                        assignedPBLines.add(oppLineItem);
                     }
                 } else {
                     if(customPBEntriesMap != null && !customPBEntriesMap.isEmpty()) {
                        oppLineItem.PriceBookEntryId = customPBEntriesMap.get(oppLine.APTPS_Product_Id__c).Id;
                        assignedPBLines.add(oppLineItem);
                     }
                 }
                 
             }
             if(!assignedPBLines.isEmpty()) {
                 try {
                     if(!test.isRunningTest())
                     {
                      upsert assignedPBLines;
                     }
                 } catch(Exception e) {
                     throw new APTPS_DaikinGlobalException('Error while saving opportunity lines : ' + e.getMessage());
                 }
             }
            
         }
     }
     
     /*
        Method : deleteOppLineItems , parameters : list_of_opportunity line item
        Description : it performs delete operations on opp lines
     */
     public static void deleteOppLineItems(List<OpportunityLineItem> oppLineItems) {
         if(oppLineItems != null && !oppLineItems.isEmpty()) {
             try {
                 System.debug('*** oppLineItems - ' + oppLineItems.size());
                 delete oppLineItems;
             } catch(Exception e) {
                 System.debug('***Error while deleting  --' + e.getMessage());
                 throw new APTPS_DaikinGlobalException('Error while deleting line item ' + e.getMessage());
             }
         } 
     }
     /*
        Method : syncOldQuotesIfOpportunitiesChanged, parameter : list_of_quotes, map of id with old quotes
        Description : This method contains logic if related opportunity on quote gets updated by user.
        For Old Quotes related opportunities, 
        1. If current quote is not primary, then return.
        2. If Current Quote is primary, then loop through all the opportunity line items of 
        Quote.Old Related Opportunity and delete any item that doesn’t have a DST ID.
     */
     public static void syncOldQuotesIfOpportunitiesChanged(List<Apttus_Proposal__Proposal__c> quoteList, 
        Map<Id, Apttus_Proposal__Proposal__c> oldMap) {
        List<Apttus_Proposal__Proposal__c> oldQuotes = new List<Apttus_Proposal__Proposal__c>();
        for(Apttus_Proposal__Proposal__c currentQuote : quoteList) {
            if(currentQuote.Apttus_Proposal__Opportunity__c != oldMap.get(currentQuote.Id).Apttus_Proposal__Opportunity__c 
             && currentQuote.Apttus_Proposal__Primary__c == true) {
                oldQuotes.add(oldMap.get(currentQuote.Id));
            }
        }
        //1
        if(oldQuotes.isEmpty()) return;
        //holds map of quote id with associated opportunity record
        Map<Id, Opportunity> mapQuoteIdToOpportunity = APTPS_QuoteTriggerHandler.getMapOfOppIdToOpportunity(oldQuotes);
        List<OpportunityLineItem> oppLines = new List<OpportunityLineItem>();
        List<OpportunityLineItem> oppLinesWithoutDSTId = new List<OpportunityLineItem>();
        
        Map<Id, List<OpportunityLineItem>> mapOppIdToLines 
            = APTPS_QuoteTriggerHandler.getMapOfOpptyWithLineItems(oldQuotes);
        //APTPS_QuoteTriggerHandler.getMapOfOpptyWithLineItems(oldQuotes) != null && 
            //!APTPS_QuoteTriggerHandler.getMapOfOpptyWithLineItems(oldQuotes).isEmpty()    
        if(!mapQuoteIdToOpportunity.isEmpty() && mapOppIdToLines != null && !mapOppIdToLines.isEmpty()) {
            //Map<Id, List<OpportunityLineItem>> mapOppIdToLines = APTPS_QuoteTriggerHandler.getMapOfOpptyWithLineItems(oldQuotes);
            for(Opportunity oppty : mapQuoteIdToOpportunity.values()) {
                if(mapOppIdToLines.get(oppty.Id) != null && !mapOppIdToLines.get(oppty.Id).isEmpty()) {
                    for(OpportunityLineItem oppLine : mapOppIdToLines.get(oppty.Id)) {
                        if(String.isBlank(oppLine.DST_Id__c)) {
                            oppLinesWithoutDSTId.add(oppLine);  
                        }
                    }   
                }
            }
            
        }
        if(!oppLinesWithoutDSTId.isEmpty()) 
        APTPS_QuoteTriggerHandler.deleteOppLineItems(oppLinesWithoutDSTId);
        
     }
     
     /*
        Method : updateQuotesToNotPrimary : list_of_quotes, map of id with old quotes
        Description : 
        For New Quotes related Opportunities,
        1. If there was already a quote which was primary and current quote is primary then make 
        other quote as non-primary by looping through all the quotes on current opportunity.
        2. Execute logic of Scenario 1. 
     */
     private static Boolean runOnceupdateQuotesToNotPrimaryAndSyncMethod = false; //avoid recursion
     public static void updateQuotesToNotPrimary(List<Apttus_Proposal__Proposal__c> quoteList, 
        Map<Id, Apttus_Proposal__Proposal__c> oldMap) {
        if(runOnceupdateQuotesToNotPrimaryAndSyncMethod == true) return;    
        Set<Id> newOppIds = new Set<Id>();
        Map<Id, Apttus_Proposal__Proposal__c> newMap = new Map<Id, Apttus_Proposal__Proposal__c>(quoteList);
        for(Apttus_Proposal__Proposal__c currentQuote : quoteList) {
            if(currentQuote.Apttus_Proposal__Opportunity__c != oldMap.get(currentQuote.Id).Apttus_Proposal__Opportunity__c
                && currentQuote.Apttus_Proposal__Primary__c == true) {
                newOppIds.add(currentQuote.Apttus_Proposal__Opportunity__c);
            }
        }
        List<Apttus_Proposal__Proposal__c> existingPrimaryQuotes = [Select Apttus_Proposal__Primary__c 
            from Apttus_Proposal__Proposal__c 
            where Apttus_Proposal__Primary__c = true AND Apttus_Proposal__Opportunity__c in :newOppIds 
            AND Id not in:newMap.keyset()];
        List<Apttus_Proposal__Proposal__c> existingQuotesToNotPrimary = new List<Apttus_Proposal__Proposal__c>();       
        if(existingPrimaryQuotes != null && !existingPrimaryQuotes.isEmpty()) {
            for(Apttus_Proposal__Proposal__c quote : existingPrimaryQuotes) {
                quote.Apttus_Proposal__Primary__c = false;
                existingQuotesToNotPrimary.add(quote);
            }   
        }
        if(!existingQuotesToNotPrimary.isEmpty()) {
             update existingQuotesToNotPrimary;
             runOnceupdateQuotesToNotPrimaryAndSyncMethod = true;
        }
        
     }
     
     
     /*
        Method : getMapOfOpptyWithLineItems , parameter : list_of_quote
        Description : it returns map of oppty with line items of associated quotes 
     */
     public static Map<Id, List<OpportunityLineitem>> getMapOfOpptyWithLineItems(List<Apttus_Proposal__Proposal__c> quotes) {
        //holds map of quote id with associated opportunity record
         Map<Id, Opportunity> mapIdToOpportunity = APTPS_QuoteTriggerHandler.getMapOfOppIdToOpportunity(quotes);
         //update existing line items having DST ID , create map of existing opportunity line items with opportunity 
         Map<Id, List<OpportunityLineItem>> mapOpptyWithLineItems = new Map<Id, List<OpportunityLineItem>>();
         if(mapIdToOpportunity != null && !mapIdToOpportunity.isEmpty()) {
             for(Opportunity opp : mapIdToOpportunity.values()) {
                if(opp.OpportunityLineItems != null && !opp.OpportunityLineItems.isEmpty()) {
                    for(OpportunityLineItem oppLineItem : opp.OpportunityLineItems) {
                        if(mapOpptyWithLineItems.containsKey(opp.Id)) {
                            mapOpptyWithLineItems.get(opp.Id).add(oppLineItem);
                        } else {
                            mapOpptyWithLineItems.put(opp.Id, new List<OpportunityLineItem>{oppLineItem});
                        }
                    }
                }
             }
         }
         return mapOpptyWithLineItems;
     }
     
     /*
         Method : buildUpMapOfPriceBookWithEntry, parameter : set_of_productId, set_of_pricebookId, Set_ofC_currencycode
         Description : It returns the map of associated price book entries with price book
     */
     public static Map<Id, PricebookEntry> buildUpMapOfPriceBookWithEntry(Set<Id> productIds, List<Id> opptyPricebookIds) {
         for(Id pid : productIds) {
            System.debug(' *** product Id in build - ' + pId);
         }
         for(Id opId : opptyPricebookIds) {
            System.debug(' *** price book Id in build - ' + opId);
         }
         //need to clause with prodcuct id, pricebook2id, and currency of quote line items
         List<PricebookEntry> pricebookEntries = [select Id, Name, IsActive, Pricebook2Id, Product2Id, ProductCode,
                    UnitPrice, UseStandardPrice from PricebookEntry WHERE //where Id = '01uL0000006dlRh' limit 1 ];
                    Product2Id in :productIds AND  
                    Pricebook2Id in :opptyPricebookIds];
                    
         /*
         Id pbId = opptyPricebookIds[0];
         List<PricebookEntry> pricebookEntries = [select id, name, Pricebook2id, Product2Id 
            from PriceBookEntry where Pricebook2id = '01uL0000006dlCY' limit 1]; //and Product2Id in :productIds ];
         */
         System.debug('*** pricebookEntries - ' + pricebookEntries.size());
         if(pricebookEntries.isEmpty())  return null;
        
         Map<Id, PricebookEntry> mapPriceBookToEntry = new Map<Id, PricebookEntry>();
         for(PricebookEntry pbEntry : pricebookEntries) {
             System.debug(pbEntry.Pricebook2Id + '*** pbEntry pb2Id');
             System.debug(pbEntry + '*** pbEntry');
             System.debug(pbEntry.Product2Id + '*** pbEntry product');
             mapPriceBookToEntry.put(pbEntry.Product2Id , pbEntry);
         }
         return mapPriceBookToEntry;
     }
     
     /*
         Method : updateOpptyListWithStandardPriceBook
         Description : Method is supposed to be called from within synchronizeOpportunityLineItems method.
                       This contains logic to assign standard price book to the opportunity
     */
     public static void updateOpptyListWithStandardPriceBook(List<Opportunity> opptyList) {
         if(opptyList == null) return;
         // get the standard price book id
         List<Pricebook2> books = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];
         if(Test.isRunningTest()) {
             Pricebook2 testPB = new PriceBook2(IsActive = true, Name = 'Test PB');
             insert testPB;
             books.add(testPB);
         }
         List<Opportunity> updateOpptyList = new List<Opportunity>();
         if(books != null && !books.isEmpty()) {   
             for(Opportunity opp : opptyList) {
                 opp.Pricebook2Id = books[0].Id;
                 updateOpptyList.add(opp);
             }
         }
         
         if(updateOpptyList != null && !updateOpptyList.isEmpty()) {
             try {
                 update updateOpptyList;
             } catch(System.DMLException e) {
                 System.debug('*** oppty failed to be updated ' + e.getMessage());
                 throw new APTPS_DaikinGlobalException('Error while assigning Price book to opportunity ' + e.getMessage());
             }
         }
     }
     
     /*
         Method : createPriceBookEntryForProduct , parameters : Product Id , priceBook Id
         Description : This method will populate price book entry for product if product doesn't have associated with Price book
     */
     /*
     public static PriceBookEntry createPriceBookEntryForProduct(Id productId, Id priceBookId) {
         return new PriceBookEntry(UnitPrice = 0.0, IsActive = true, Pricebook2Id = priceBookId, Product2Id = productId, UseStandardPrice = false);
     }
     */
         
     /*
         Method : buildUpPriceListMapForNorthAmericaQuotes, @parameter : <list_of_quote>
         Description : Utility method to populate Map of price list name with price list.
             This method is supposed to be called internally within scope of class only on need basis 
             1. This is being called from "setQuoteDefaults" to populte default price list for north america quote
     */
     public static void buildUpPriceListMapForNorthAmericaQuotes(List<Apttus_Proposal__Proposal__c> quoteList) {
         List<Apttus_Proposal__Proposal__c> northAmericaQuotes = new List<Apttus_Proposal__Proposal__c>();
         for(Apttus_Proposal__Proposal__c quote : quoteList) {
             if(quote.RecordTypeId != null && quoteRTMap.get(quote.RecordTypeId).getName().containsIgnoreCase('North America Proposal')) {
                 northAmericaQuotes.add(quote);
             }
         }
         if(!northAmericaQuotes.isEmpty()) {
             List<Apttus_Config2__PriceList__c> listPriceList = [Select Name from Apttus_Config2__PriceList__c 
                 WHERE Name != null AND Apttus_Config2__Active__c = TRUE limit 2000];
             if(listPriceList != null && !listPriceList.isEmpty()) {
                 for(Apttus_Config2__PriceList__c pList : listPriceList) {
                     mapPriceListNameToRecord.put(pList.Name, pList);
                 }
             }
         }              
         
     }
     
     /*
         Method : getMapOfOppIdToOpportunity , parameters : list_of_quote
         Description : This method will return mapping of ids and associated opportunities in the current context
     */
     public static Map<Id, Opportunity> getMapOfOppIdToOpportunity(List<Apttus_Proposal__Proposal__c> quoteList) {
         if(quoteList == null) return null;
         Set<Id> oppIds = new Set<Id>();
         for(Apttus_Proposal__Proposal__c quote : quoteList) {
             if(quote.Apttus_Proposal__Opportunity__c != null) oppIds.add(quote.Apttus_Proposal__Opportunity__c);
         }
         if(oppIds != null && oppIds.size() > 0) {
             return new Map<Id, Opportunity>([Select Id, Pricebook2Id,  Name, CloseDate, Line_of_Business__c, 
                 (Select Product2Id, DST_ID__c from OpportunityLineItems) from Opportunity 
                                         WHERE Id in :oppIds]);
         }
         return null;                           
         
     }
     
 }