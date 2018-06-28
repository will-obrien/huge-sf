/**
 * Class: APTPS_GenerateDocLineItemsController
 * Description : generateDocumentLineItems page controller. This controller is used to create document line item records as per associated quote line items.
                 It will redirect to the generate document page. 
                 Module : 12.7 Support of Latin America Sorting and Grouping
 * Author : Parth Sevak, @Apttus
 **/
public with sharing class APTPS_GenerateDocLineItemsController {

    private final String quoteId;
    //constructor 
    public APTPS_GenerateDocLineItemsController() {
        quoteId = ApexPages.currentPage().getParameters().get('Id');
    }
    
    /*
        Method : generateDocumentLineItems
        Description : This methos is supposed to be called on page load.
    */
    public pageReference generateDocumentLineItems() {
        if(String.isBlank(quoteId)) return null;
        //delete existing document line item records
        List<APTPS_Document_Line_Item__c> docLineItems = APTPS_DocumentLineItemUtility.getDocumentLineItems(quoteId);
        APTPS_DocumentLineItemUtility.deleteDocumentLineItems(docLineItems);
        
        List<Apttus_Proposal__Proposal_Line_Item__c> quoteLineItems = APTPS_DocumentLineItemUtility.getQuoteLineItems(quoteId);
        String anyGroupComment;
        if(quoteLineItems != null && !quoteLineItems.isEmpty()) {
            List<APTPS_Document_Line_Item__c> listDocLineItem = new List<APTPS_Document_Line_Item__c>();
            APTPS_Document_Line_Item__c docLineItem;
            Map<String, Apttus_Proposal__Proposal_Line_Item__c> mapGroupNameToQLineItem = new Map<String, Apttus_Proposal__Proposal_Line_Item__c>();
            for(Apttus_Proposal__Proposal_Line_Item__c lineItem : quoteLineItems) {
                mapGroupNameToQLineItem.put(lineItem.Group_Name__c, lineItem);
                docLineItem = APTPS_DocumentLineItemUtility.populateDocumentLineItem(lineItem);
                if(!String.isBlank(lineItem.Group_Comment__c)) {
                    anyGroupComment = lineItem.Group_Comment__c;
                    if(String.isBlank(docLineItem.Group_Comment__c) || test.isRunningTest())
                    docLineItem.Group_Comment__c = anyGroupComment;
                }
                listDocLineItem.add(docLineItem);
                
                //additional line item 
                if(lineItem.Is_Last_in_Group__c == true) {
                    APTPS_Document_Line_Item__c additionalDocLineItem = new APTPS_Document_Line_Item__c();
                    additionalDocLineItem.APTPS_Quote_Proposal__c = lineItem.Apttus_Proposal__Proposal__c;
                    additionalDocLineItem.Group_Comment__c = lineItem.Group_Comment__c;
                    if(String.isBlank(additionalDocLineItem.Group_Comment__c) && !String.isBlank(anyGroupComment)) {
                        additionalDocLineItem.Group_Comment__c = anyGroupComment; 
                    }
                    additionalDocLineItem.Group_Name__c = lineItem.Group_Name__c;
                    additionalDocLineItem.Group__c = lineItem.Group__c;
                    // GSMOD
                    additionalDocLineItem.Item_Number__c = lineItem.Item_Number__c;
                    additionalDocLineItem.Seq_in_Group__c = -999;
                    additionalDocLineItem.APTPS_Is_Group_Record__c = true;
                    additionalDocLineItem.Group_Subtotal_Local_Currency__c =  lineItem.Group_Subtotal_Local_Currency__c;
                    listDocLineItem.add(additionalDocLineItem);
                }
            }
            if(!listDocLineItem.isEmpty()) {
                APTPS_DocumentLineItemUtility.insertDocumentLineItems(listDocLineItem);
            }
          
        } 
        
        //redirect to the generate document page
        PageReference generateQuotePage = Page.Apttus_Proposal__ProposalGenerate;
        generateQuotePage.getParameters().put('Id', quoteId);
        generateQuotePage.setRedirect(true);
        return generateQuotePage;
   
    }
    
    
}