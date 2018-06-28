/**
 * Class: APTPS_QuoteLineItemTriggerHandler
 * Description : Quote/Proposal Line Item Trigger Helper. This class will have trigger utility methods.
 * Author : Parth Sevak, @Apttus
 **/
public class APTPS_QuoteLineItemTriggerHandler {
    
    //Retrieve quote line item record types and hold in map to find out Quote line item with Latin America
    public static Map<Id, Schema.RecordTypeInfo> quoteLineItemRTMap = Schema.getGlobalDescribe().get('Apttus_Proposal__Proposal_Line_Item__c').getDescribe().getRecordTypeInfosById();
    public static Map<String, Schema.RecordTypeInfo> quoteLineItemRTMapByName = 
        Schema.getGlobalDescribe().get('Apttus_Proposal__Proposal_Line_Item__c').getDescribe().getRecordTypeInfosByName();

    
    /*
        Method : assignRecordTypeOnQuoteLineFromParentQuote , parameter : set_qf_quote_line
        Description : This should be called form before insert context of trigger. It sets the record type as per parent quote's RT
    */
    public static void assignRecordTypeOnQuoteLineFromParentQuote(List<Apttus_Proposal__Proposal_Line_Item__c> quoteLineItems) {
        //record types 
        String latinAmericaRTQuote = 'Latin_America_Proposal'; //APTPS_DaikinConstants.APTPS_Quote_RT_Latin_America ;
        String northAmericaRTQuote = 'North_America_Proposal'; //APTPS_DaikinConstants.APTPS_Quote_RT_North_America ;
        String latinAmericaRTQuoteLine = 'Latin America Proposal'; //APTPS_DaikinConstants.APTPS_QuoteLineItem_RT_Latin_America ;
        String northAmericaRTQuoteLine = 'North America Proposal'; //APTPS_DaikinConstants.APTPS_QuoteLineItem_RT_North_America ;
        //Id latinAmericaRTIdForQL = Schema.SObjectType.Account.getRecordTypeInfosByName().get(latinAmericaRTQuote).getRecordTypeId();
        //Id northAmericaRTIdForQL = Schema.SObjectType.Account.getRecordTypeInfosByName().get(northAmericaRTQuote).getRecordTypeId();
     
        Set<Id> quoteIds = new Set<Id>();
 
        for(Apttus_Proposal__Proposal_Line_Item__c quoteLineItem : quoteLineItems) {
            quoteIds.add(quoteLineItem.Apttus_Proposal__Proposal__c); 
        }
        Map<Id, Apttus_Proposal__Proposal__c> quoteMap = new map<Id, Apttus_Proposal__Proposal__c>([Select RecordType.DeveloperName, RecordType.Name from 
            Apttus_Proposal__Proposal__c where Id in :quoteIds]);
        //assign record type
        for(Apttus_Proposal__Proposal_Line_Item__c quoteLineItem : quoteLineItems) {
            System.debug('Quote RT - Developer Name ' + quoteMap.get(quoteLineItem.Apttus_Proposal__Proposal__c).RecordType.DeveloperName);
            if(quoteMap.get(quoteLineItem.Apttus_Proposal__Proposal__c).RecordType.DeveloperName.equalsIgnoreCase(latinAmericaRTQuote)) {
                quoteLineItem.RecordTypeId = quoteLineItemRTMapByName.get(latinAmericaRTQuoteLine).getRecordTypeId();
            } else if(quoteMap.get(quoteLineItem.Apttus_Proposal__Proposal__c).RecordType.DeveloperName.equalsIgnoreCase(northAmericaRTQuote)) {
                quoteLineItem.RecordTypeId = quoteLineItemRTMapByName.get(northAmericaRTQuoteLine).getRecordTypeId();
            } else {
                //do nothing
            }
        } 
        
    } 
    
    
    /*
        Method : setConfigFinalizedDateOnQuotes , parameter : list_of_quote_line_item
        Description : Method is supposed to be called form after update/delete context of Quote Line Item trigger.
            This method contains logic to set Config Finalized Date on Quote specifically for Latin America Proposal only
    */
    public static void setConfigFinalizedDateOnQuotes(List<Apttus_Proposal__Proposal_Line_Item__c> quoteLineItems) {
        Set<Id> quoteIds = new Set<Id>();
    
        for(Apttus_Proposal__Proposal_Line_Item__c qLineItem : quoteLineItems) {
            if(qLineItem.Apttus_Proposal__Proposal__c != null && 
                quoteLineItemRTMap.get(qLineItem.RecordTypeId).getName().containsIgnoreCase('Latin America Proposal'))
            quoteIds.add(qLineItem.Apttus_Proposal__Proposal__c);
        }
        
        List<Apttus_Proposal__Proposal__c> quoteListToBeUpdated = new List<Apttus_Proposal__Proposal__c>();
            
        if(quoteIds != null && !quoteIds.isEmpty()) {
            List<Apttus_Proposal__Proposal__c> listQuote = [Select Id, Apttus_QPConfig__ConfigurationFinalizedDate__c from 
                Apttus_Proposal__Proposal__c where Id in :quoteIds];
            Map<Id, Apttus_Proposal__Proposal__c> mapIdToQuote = new Map<Id, Apttus_Proposal__Proposal__c>(listQuote);
            Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
            for(Apttus_Proposal__Proposal_Line_Item__c qLineItem : quoteLineItems) {
                quote = mapIdToQuote.get(qLineItem.Apttus_Proposal__Proposal__c);
                quote.Apttus_QPConfig__ConfigurationFinalizedDate__c = System.Now();
                //quote.APTPS_Run_Validation_Rules__c = false; //avoid validation rule execution withour user updates
                quoteListToBeUpdated.add(quote);
            }  
        }
        
        if(quoteListToBeUpdated != null && !quoteListToBeUpdated.isEmpty()) {
            Set<Apttus_Proposal__Proposal__c> quoteSet = new Set<Apttus_Proposal__Proposal__c>();
            quoteSet.addAll(quoteListToBeUpdated);
            List<Apttus_Proposal__Proposal__c> finalQuoteList = new List<Apttus_Proposal__Proposal__c>();
            finalQuoteList.addAll(quoteSet);
            update finalQuoteList;
        }
        
  /* GS: Disabled due to errors with duplicate line ID's      
        if(quoteListToBeUpdated != null && !quoteListToBeUpdated.isEmpty()) {
            update quoteListToBeUpdated;
        }
 */   
    }
    
    
}