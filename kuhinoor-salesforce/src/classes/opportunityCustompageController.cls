public class opportunityCustompageController{
    public Opportunity opp {get;set;}
    public List<opportunityLineItem> oppLineItemList {get;set;}
    public Integer index {get;set;}
    Public Integer deleteIndex{get;set;}
    public PricebookEntry priceBkEntry {get;set;}
    private Pricebook2 priceBk {get;set;}
    Public list<OpportunityLineItem> pro{get;set;}
    // Constructor
   
    public opportunityCustompageController(){
        priceBk = [SELECT id,IsStandard,Name FROM priceBook2 WHERE isStandard = true LIMIT 1];
        opp = new Opportunity();       
        pro = new List<opportunityLineItem>(); 
        pro.add(new OpportunityLineItem());
    }
    
   
    
    // Function To Fill Unit price
    public pagereference fillUnitPrice(){
        System.debug('#####################'+index);
        if(index!=null && pro[index].product3__c != null){
            
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
               insert priceBkEntry;
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
        opp.priceBook2Id = priceBk.Id;
        insert opp;
        for(opportunityLineItem oppLineItem : pro){
            if(oppLineItem.OpportunityId == null)           
                oppLineItem.OpportunityId = opp.id;
        }
        
           
            insert pro;
        
        return new pagereference('/'+opp.id).setRedirect(true);
    }
    public void del(){
    
    }
    public void addproduct(){
    
    }
}