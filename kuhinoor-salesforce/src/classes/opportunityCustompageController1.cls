public class opportunityCustompageController1{
    
    public Opportunity oppList;
    public Opportunity opp {get;set;}
    public List<opportunityLineItem> oppLineItemList {get;set;}
    public Integer index{get;set;}
    Public Integer deleteIndex{get;set;}
    public PricebookEntry priceBkEntry {get;set;}
    private Pricebook2 priceBk {get;set;}
    Public list<OpportunityLineItem> pro{get;set;}
    Public List<OpportunityLineItem> lineItemdelete{get;set;}
    Public opportunity oppplist{get;set;}
    // Constructor
   
    public opportunityCustompageController1(apexpages.standardcontroller stndcrtlr){
        lineItemdelete = new  List<OpportunityLineItem>();
        opp = new Opportunity();
        pro = new List<opportunityLineItem>();  
        id oppid= (ID)stndcrtlr.getId();
        opp = [SELECT amount, AccountId,CloseDate, priceBook2Id, ContractId,CreatedById,Description,ExpectedRevenue,ForecastCategoryName,LastModifiedById,LeadSource
                   ,NextStep,Name,OwnerId,CampaignId,IsPrivate,Probability,TotalOpportunityQuantity,StageName,Type, OrderNumber__c,
                    TrackingNumber__c,DeliveryInstallationStatus__c,MainCompetitors__c,CurrentGenerators__c FROM opportunity WHERE id = :oppId LIMIT 1];
        
        priceBk = [SELECT id,IsStandard,Name FROM priceBook2 WHERE isStandard = true LIMIT 1];
        /*opp = new Opportunity();       
        pro = new List<opportunityLineItem>(); 
        pro.add(new OpportunityLineItem());*/
        
        pro = [SELECT id, unitPrice, product3__c,ServiceDate,PricebookEntryId,ListPrice,Description,OpportunityId,Product2Id,Quantity FROM OpportunityLineItem WHERE OpportunityId = :oppId];
        if(pro ==null || pro.size()==0){
           pro.add(new OpportunityLineItem()); 
        }  
    }
     public opportunityCustompageController1(){
         lineItemdelete = new  List<OpportunityLineItem>();
        priceBk = [SELECT id,IsStandard,Name FROM priceBook2 WHERE isStandard = true LIMIT 1];
        opp = new Opportunity();       
        pro = new List<opportunityLineItem>(); 
        pro.add(new OpportunityLineItem());
        
    }
   
    
    // Function To Fill Unit price
    public pagereference fillUnitPrice(){
        System.debug('###################'+index);
        if(index!=null && pro[index].product3__c != null){
             if(pro[index].opportunityId != null){               
                pro[index].product3__c = pro[index].product2Id;
                return null;
            }
            List<Product2> tempProductList = [SELECT id, (SELECT id, product2Id, pricebook2Id,UnitPrice FROM PricebookEntries where pricebook2.isStandard=true) FROM product2 WHERE id = :pro[index].product3__c];
            List<PriceBookEntry> tempList = tempProductList[0].PriceBookEntries;
            if(tempList != null && tempList.size()>0){
             
                   pro[index].UnitPrice = tempList[0].UnitPrice;
                   pro[index].PricebookEntryId = tempList[0].Id;
                  
              
            }else{
               priceBkEntry = new PriceBookEntry();
               priceBkEntry.Product2Id = pro[index].product3__c;
               priceBkEntry.priceBook2Id = priceBk.Id;
               priceBkEntry.IsActive = true;
               priceBkEntry.UnitPrice = 00;
               upsert priceBkEntry;
               pro[index].UnitPrice = priceBkEntry.UnitPrice;
               pro[index].PricebookEntryId = priceBkEntry.Id;
               return null;
           }    
           return null;
        }
        return null;
    }
    // Function to save opportunity and OpportunityLineItme
    public pagereference savepro(){
        for(OpportunityLineItem opplobj : pro){
            if(opplobj.quantity<=0){
                Apexpages.message msg = new apexpages.message(ApexPages.severity.WARNING,'Please enter positive value');
               Apexpages.addmessage(msg);
               return null;
            }
        }
        opp.priceBook2Id = priceBk.Id;
        upsert opp;
        for(opportunityLineItem oppLineItem : pro){
        
            if(oppLineItem.OpportunityId == null)    
                     
                oppLineItem.OpportunityId = opp.id;
        }
        
        if(lineItemdelete.size()>0){
            delete lineItemdelete;
        }
            upsert pro;
        
        return new pagereference('/'+opp.id).setRedirect(true);
    }
    public void del(){
        if(deleteIndex!=null){
         
            OpportunityLineItem tempoppl = pro.get(deleteIndex);
            pro.remove(deleteIndex);
            lineItemdelete.add(tempoppl);
          
        }
    }
    //--------------------------------- Cancel method here--------------------
      Public PageReference cancelmethod(){
        return new pagereference('/'+opp.id);
    }
    
    public void addproduct(){
         pro.add(new OpportunityLineItem());
    }
}