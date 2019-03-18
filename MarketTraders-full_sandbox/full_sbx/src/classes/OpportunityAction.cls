public class OpportunityAction{

  @InvocableMethod(label='Get First Micro Closed Won Opps' description='Returns Earliest Micro Purchase Closed Won Opportunity Associated with an Account')
  public static List<Opportunity> getFirstMicroClosedWonOpp(List<ID> ids) {
  
    Map<Id, List<Opportunity>> mapAccounttoOpp = new Map<Id, List<Opportunity>>();
    List<Opportunity> returnopps = new List<Opportunity>();
  
    Map<String, OppFieldsforStamping__c> oppfieldmap = OppFieldsforStamping__c.getAll();
    Set<String> fieldlist = new Set<String>{'id','StageName', 'CloseDate', 'Product__c', 'AccountId', 'Amount'};

    for(String os: oppfieldmap.keySet()){
         if(oppfieldmap.get(os).ActiveField__c){
            if(oppfieldmap.get(os).APIName__c != null){
                 if(!fieldlist.contains(oppfieldmap.get(os).APIName__c)){
                    fieldlist.add(oppfieldmap.get(os).APIName__c);       
                }    
            }         
         }      
    }
    
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
        
        querystr += ' from Opportunity where Product__c in :microproductset and AccountId in :ids and Amount > 0 and (StageName = \'Closed Won\' OR  StageName = \'Closed Won - Recovered Bad Debt\')';
        querystr += ' ORDER BY CloseDate ASC LIMIT 50000';
    
  
    Map<String, MicroProductList__c> microproductsmap = MicroProductList__c.getAll();
    Set<String> microproductset = new Set<String>();
    for(String mplkey : microproductsmap.keySet()){
        if(microproductsmap.get(mplkey).Active__c){
            if(microproductsmap.get(mplkey).Full_Product_Name__c != null){
                microproductset.add(microproductsmap.get(mplkey).Full_Product_Name__c);
            }
        }
    }  
    
    if(microproductset.size() > 0){
        List<Opportunity> allOpps = Database.query(querystr);
        /*[Select id, StageName, CloseDate, Product__c from Opportunity where Product__c in :microproductset and AccountId in :ids 
        ORDER BY CloseDate ASC
        LIMIT 50000];*/
        
        
        if(allOpps.size() > 0){
            for(Opportunity opp : allOpps){
                ID acctid = opp.AccountId;
                if(acctid != null){
                    List<Opportunity> tempopps = mapAccounttoOpp.containskey(acctid)? mapAccounttoOpp.get(acctid) : new list<Opportunity>();
                    tempopps.add(opp);
                    mapAccounttoOpp.put(acctid,tempopps);
                }
            }
            
            if(!mapAccounttoOpp.isEmpty()){
                for(ID aid :ids){                    
                        List<Opportunity> acctopps = mapAccounttoOpp.containskey(aid)? mapAccounttoOpp.get(aid) : new List<Opportunity>();
                        
                        if(acctopps.size() > 0){                            
                            returnopps.add(acctopps[0]);                                        
                        }else{
                            returnopps.add(null);
                        }                                  
                }
            }
        
        }
    
    }

       
    return returnopps;
  }



}