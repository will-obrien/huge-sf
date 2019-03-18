/**
 *  
 *  QuoteSupport
 *   
 *  @2013-2014 Apttus Inc. All rights reserved.
 */
public with sharing class APTS_QuoteSupport {
  
  // line status
  public static final String STATUS_CANCELLED = 'Cancelled';
  public List<ID> lineitemids {get; set;}
  public Id cartid {get;set;}
  public Id proposalId {get;set;}

  
  
  /**
   * Compoutes tax for the given quote/proposal asynchronously
     * @param quoteId the id of the quote to compute tax for
     */
 /*   @future
    public static void computeTaxAsync(ID quoteId) {
      // compte tax
      computeTax(quoteId);
      
    }  */
     
  /**
   * Compoutes tax for the given quote/proposal
     * @param quoteId the id of the quote to compute tax for
     */

    public APTS_QuoteSupport () {
        lineitemids = new List<ID>();
        List<Apttus_Proposal__Proposal_Line_Item__c > itemlines = new List<Apttus_Proposal__Proposal_Line_Item__c >();
        proposalId = ApexPages.currentPage().getParameters().get('Id');
        List<Apttus_Config2__ProductConfiguration__c > cartIdLst  = [select Id from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c = :proposalId and Apttus_Config2__Status__c ='Finalized' order by LastModifiedDate  desc];
        if(cartIdLst!=null && cartIdLst.size()>0)
        {
        cartId = cartIdLst[0].id;
        //tempid = ApexPages.currentPage().getParameters().get('configRequestId');
        itemlines =  [select id, Apttus_Proposal__Proposal__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_QPConfig__ConfigurationId__c = :cartid];
        for(Apttus_Proposal__Proposal_Line_Item__c item : itemlines) {
            lineitemids.add(item.id);
        }
     }   
    }



    public pagereference computeTax() {
        
        APTS_AvalaraTaxHelper.computeLineItemTaxFuture(lineitemids);
//        pagereference pg = new pagereference('/apex/Apttus_Config2__CartDetailView?id='+cartid+'&configRequestId='+tempid);
        pagereference pg = new pagereference('/'+proposalId);
        pg.setredirect(true);
        return pg;
    }
}