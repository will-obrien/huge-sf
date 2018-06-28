/**
 * Class: APTPS_DocumentLineItemUtility.cls
 * Description : This class will have generic methods for Document_Line_Item__c
                 Module : 12.7 Support of Latin America Sorting and Grouping
 * Author : Parth Sevak, @Apttus
 **/
public class APTPS_DocumentLineItemUtility {
    
    //retreive quote line items as per passed quote id
    public static List<Apttus_Proposal__Proposal_Line_Item__c> getQuoteLineItems(Id quoteId) {
        List<Apttus_Proposal__Proposal_Line_Item__c> quoteLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        try {
            quoteLineItems = [select Id, Group_Comment__c, Group_Name__c, Group__c, Group_Subtotal_Local_Currency__c,Is_Last_in_Group__c,
                Item_Number__c, Seq_in_Group__c, Apttus_Proposal__Proposal__c, Selling_Price_Total__c,
                TAG_ID__c, Model__c, Product_Description__c, Additional_Description_Info__c,
                Apttus_Proposal__Quantity__c, List_price_Per_Unit__c, List_Price_Total__c, Discount__c,
                Discount_USD__c, Selling_Price_Per_Unit__c, Selling_Price_per_Unit_Local_Currency__c,
                 Selling_Price_Total_Local_Currency__c, Total_Freight__c, Total_Freight_Local_Currency__c              
                from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c = :quoteId];
        } catch(QueryException e) {
            System.debug('QueryException : ' + e.getMessage());
        }
        return quoteLineItems;
    }
    
    //retreive document line items as per passed quote id
    public static List<APTPS_Document_Line_Item__c> getDocumentLineItems(Id quoteId) {
        List<APTPS_Document_Line_Item__c> docLineItems = new List<APTPS_Document_Line_Item__c>();
        try {
            docLineItems = [select Id, Group_Comment__c, Group_Name__c, Group__c, Group_Subtotal_Local_Currency__c,Is_Last_in_Group__c, 
                Item_Number__c, Seq_in_Group__c from APTPS_Document_Line_Item__c where APTPS_Quote_Proposal__c = :quoteId];
        } catch(QueryException e) {
            System.debug('docLineItems : ' + e.getMessage());
        }
        return docLineItems;
    }
    
    public static void deleteDocumentLineItems(List<APTPS_Document_Line_Item__c> docLineItems) {
        if(docLineItems.isEmpty()) return;
        Set<Id> documentLineItemIds = new Map<Id, APTPS_Document_Line_Item__c>(docLineItems).keySet(); 
        try {
            delete [Select Id from APTPS_Document_Line_Item__c where Id in :documentLineItemIds];
        } catch(DMLException e) {
            System.debug('Delete Operation Failed. ' + e.getMessage());
        }
    }
    
    public static void insertDocumentLineItems(List<APTPS_Document_Line_Item__c> documentLineItems) {
        if(documentLineItems.isEmpty()) return;
        try {
            insert documentLineItems;
        } catch(DMLException e) {
            System.debug('Insert Failed. ' + e.getMessage());
        }
    }     
    
    public static APTPS_Document_Line_Item__c populateDocumentLineItem(Apttus_Proposal__Proposal_Line_Item__c quoteLineItem) {
        APTPS_Document_Line_Item__c docLineItem = new APTPS_Document_Line_Item__c();
        docLineItem.APTPS_Quote_Proposal__c = quoteLineItem.Apttus_Proposal__Proposal__c;
        docLineItem.Group_Comment__c = quoteLineItem.Group_Comment__c;
        docLineItem.Group_Name__c = quoteLineItem.Group_Name__c;
        docLineItem.Group__c = quoteLineItem.Group__c;
        // GSMOD
        docLineItem.Group_Subtotal_Local_Currency__c = quoteLineItem.Group_Subtotal_Local_Currency__c;
        docLineItem.Is_Last_in_Group__c = quoteLineItem.Is_Last_in_Group__c;
        // GSMOD
        docLineItem.Item_Number__c = quoteLineItem.Item_Number__c;
        docLineItem.Seq_in_Group__c = quoteLineItem.Seq_in_Group__c;
        docLineItem.Tag_ID__c = quoteLineItem.TAG_ID__c;
        docLineItem.Model__c = quoteLineItem.Model__c;
        docLineItem.Total_Freight__c = quoteLineItem.Total_Freight__c;
        docLineItem.Total_Freight_Local_Currency__c = quoteLineItem.Total_Freight_Local_Currency__c;
        docLineItem.Selling_Price_per_Unit_Local_Currency__c = quoteLineItem.Selling_Price_per_Unit_Local_Currency__c; 
        docLineItem.Total_Freight_Local_Currency__c = quoteLineItem.Total_Freight_Local_Currency__c;
        docLineItem.Selling_Price_Total__c = quoteLineItem.Selling_Price_Total__c;
        docLineItem.Selling_Price_Total_Local_Currency__c = quoteLineItem.Selling_Price_Total_Local_Currency__c;
        //GSMOD
        docLineItem.Product_Description__c = quoteLineItem.Product_Description__c;
        docLineItem.Additional_Description_Info__c = quoteLineItem.Additional_Description_Info__c;
        docLineItem.Quantity__c = quoteLineItem.Apttus_Proposal__Quantity__c;
        // GSMOD
        docLineItem.List_price_Per_Unit__c = quoteLineItem.List_price_Per_Unit__c;
        // GSMOD
        docLineItem.List_Price_Total__c = quoteLineItem.List_Price_Total__c; 
        docLineItem.Discount__c = quoteLineItem.Discount__c;
        docLineItem.Discount_USD__c = quoteLineItem.Discount_USD__c;
        docLineItem.Selling_Price_Per_Unit__c = quoteLineItem.Selling_Price_Per_Unit__c;
        //docLineItem.Production_Weeks__c = quoteLineItem.Production_Weeks__c;
       
        return docLineItem;
    }
    
 
 }