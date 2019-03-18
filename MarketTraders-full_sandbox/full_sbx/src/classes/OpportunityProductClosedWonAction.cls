/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       10/21/2015
*   Author:             Asha Calderon
*   Last Modified:      10/27/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
public class OpportunityProductClosedWonAction{

/**
 * @innerclass: ClosedWonOppsOutput
 * @description: inner class of invocable variables to allow for return of a list of opportunities mapped to one account id
 * 
 **/
public class ClosedWonOppsOutput{
    @InvocableVariable(
               Label='First Closed Won Opportunity'
               Description='Optional, null if no closed won opps'
               Required=False)
    public List<Opportunity> EarliestOpps;
    @InvocableVariable(
              Label='Latest Closed Won Opportunity' Description='Optional, null if no closed won opps; '
              Required=False)
    public List<Opportunity> LatestOpps;
}

/**
 * @method: getFirstandLastClosedWonOpp
 * @description: Returns First and Latest Product Purchase For Closed Won Opportunity Associated with an Account
 * EarliestOpps contains a list of all the first closed won opps for each record type
 * LatestOpps contains a list of all the last closed won opps for each record type
 * @param: ids - account ids
 **/
  @InvocableMethod(label='Get First Product and Last Product Closed Won Opps' description='Returns Earliest and Latest Product Purchase For Closed Won Opportunity Associated with an Account')
  public static List<ClosedWonOppsOutput> getFirstandLastClosedWonOpp(List<ID> ids) {
    
    List<ClosedWonOppsOutput> clsdwonopps = new List<ClosedWonOppsOutput>();
    
    Map<Id, Map<String,List<Opportunity>>> mapAccountToOpp = new Map<Id, Map<String,List<Opportunity>>>();
    List<Opportunity> returnopps = new List<Opportunity>();
  
   //@info:add the fields to be stamped to the query through the custom setting allowing access to fields in the flow
    Map<String, OppFieldsforStamping__c> oppfieldmap = OppFieldsforStamping__c.getAll();
    Set<String> fieldlist = new Set<String>{'id','StageName', 'CloseDate', 'Product_Vertical__c', 'RecordTypeID', 'Product__c', 'AccountId', 'Amount'};

    for(String os: oppfieldmap.keySet()){
         if(oppfieldmap.get(os).ActiveField__c){
            if(oppfieldmap.get(os).APIName__c != null){
                 if(!fieldlist.contains(oppfieldmap.get(os).APIName__c)){
                    fieldlist.add(oppfieldmap.get(os).APIName__c);       
                }    
            }         
         }      
    }
     //@info:build query string 
      String querystr = 'Select ';
        Integer x = 1;
        for(String s:fieldlist){
            if(!s.contains('isdeleted')|| !s.contains('systemmodstamp') || !s.contains('lastreferenceddate') || !s.contains('lastvieweddate')){
                querystr += s;
                if(x < fieldlist.size()){
                  querystr += ', ';
                } 
                x++;
            }
        }
        
        
         Map<String, ID> oppschemamap = new Map<String, ID>();
        Schema.DescribeSObjectResult describeopp = Schema.SObjectType.Opportunity;
        List<Schema.RecordTypeInfo> rtInfos = describeopp.getRecordTypeInfos();
        
        for(Schema.RecordTypeInfo rtInfo : rtInfos){ 
            oppschemamap.put(rtInfo.getName(), rtInfo.getRecordTypeId());
        }
        
        //@info: because micro product include a few equitities products then a distinction needs to be included for micros w/ product_verticals = Equitities
        
        String microrectypeid = oppschemamap.get('Micro');
        String microequitiesrectype = 'micro_equities';
        String usoprectypeid = oppschemamap.get('Stock');
        String optionsrectypeid = oppschemamap.get('Options');
        /* aac maybe to add rectype to query as filter
        List<String> opprectypes = new List<String>();
        opprectypes.add(microrectypeid);
        opprectypes.add(microrectypeid);
        opprectypes.add(microrectypeid); 
        */
                        
        //querystr += ' from Opportunity where Product__c in :oppproducts and AccountId in :ids and Amount > 0 and (StageName = \'Closed Won\' OR  StageName = \'Closed Won - Recovered Bad Debt\')';
       querystr += ' from Opportunity where AccountId in :ids and Amount > 0 and (StageName = \'Closed Won\' OR  StageName = \'Closed Won - Recovered Bad Debt\')';
       querystr += ' ORDER BY CloseDate ASC LIMIT 50000';
    
    
    /* aac 10.21.15 removing custom setting
    Map<String, OppProductList__c> oppproductsmap = OppProductList__c.getAll();
    Map<String, String> productToCategory = new Map<String, String>();
    Set<String> oppproducts = new Set<String>();
    for( String oplkey : oppproductsmap.keySet() ){
        if(oppproductsmap.get(oplkey).Active__c){
            if(oppproductsmap.get(oplkey).Full_Product_Name__c != null){
                oppproducts.add(oppproductsmap.get(oplkey).Full_Product_Name__c);
                productToCategory.put( oppproductsmap.get(oplkey).Full_Product_Name__c, oppproductsmap.get(oplkey).Category__c);
            }
        }
    }  
    */
    
   // if( oppproducts.size() > 0 ){
        List<Opportunity> allOpps = Database.query(querystr);
        // @info: expanded query also would include api names
        /*[Select id, StageName, CloseDate, Product__c from Opportunity where Product__c in :oppproducts and AccountId in :ids 
        ORDER BY CloseDate ASC
        LIMIT 50000];
        */
       
        
        if(allOpps.size() > 0){
           // if(!productToCategory.isEmpty()){  aac removee - map to rectype instead of vertical from custom setting  
                for(Opportunity opp : allOpps){
                System.debug('@asha:@debug: OpportunityProductClosedWonAction: Opportunity : Record Type='+ opp.RecordTypeID+' product='+opp.Product__c);
                    ID acctid = opp.AccountId;
                    String productvertical  = (opp.Product_Vertical__c != null)? opp.Product_Vertical__c : 'Forex';
                    if(acctid != null){
                        Map<String,List<Opportunity>> tempmap = mapAccounttoOpp.containskey(acctid)? mapAccounttoOpp.get(acctid) : new Map<String,List<Opportunity>>();
                        String opprectype = (opp.RecordTypeID.equals(microrectypeid) && productvertical.equals('Equities'))? microequitiesrectype : opp.RecordTypeID;
                        opprectype = (opprectype.equals(optionsrectypeid))? usoprectypeid : opprectype;
                        
                        //aac removed - String category = productToCategory.containskey(opp.product__c)? productToCategory.get(opp.product__c) : null;
                        if(opprectype != null){
                            //@info: get the existing list of opps for the product opprectype and already mapped to an account
                            List<Opportunity> tempopps = tempmap.containskey(opprectype) ? tempmap.get(opprectype) : new list<Opportunity>();
                            tempopps.add(opp);
                            tempmap.put(opprectype, tempopps);
                        }                   
                        mapAccounttoOpp.put(acctid,tempmap);
                    }
                }
            //}
            if(!mapAccounttoOpp.isEmpty()){
                for(ID aid :ids){                    
                        Map<String,List<Opportunity>> tempmap = mapAccounttoOpp.containskey(aid)? mapAccounttoOpp.get(aid) :  new Map<String,List<Opportunity>>();
                                
                                List<Opportunity> earlyopps =  new List<Opportunity>();
                                List<Opportunity> lateopps = new List<Opportunity>();                               
                                ClosedWonOppsOutput outputopps = null;
                        if(!tempmap.isEmpty()){
                            for(String tmkey : tempmap.keyset()){
                                List<Opportunity> templist = tempmap.get(tmkey);
                                if(templist.size() > 0){
                                    earlyopps.add(templist[0]);
                                    lateopps.add(templist[templist.size() - 1]);
                                }
                            }                   
                        }
                        
                        if(earlyopps.size() > 0 || lateopps.size() > 0 ){
                            
                            outputopps = new ClosedWonOppsOutput();
                            
                            outputopps.EarliestOpps = earlyopps;
                            outputopps.LatestOpps = lateopps;
                            System.debug('@asha:@debug: OpportunityProductClosedWonAction: Adding to outputopps EarliestOpps-:'+ outputopps.EarliestOpps.size() + ' latestopps:'+outputopps.LatestOpps.size());
                        }
                        clsdwonopps.add(outputopps);                    
                               
                }   
                                                
            }
        
        }
    
   // }

       
    return clsdwonopps;
  }
}