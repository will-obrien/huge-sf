public with sharing class product_catalog_cls {
    public List<Familia_de_productos__c> prodFamilyList{get;set;}
    public List<Familia_de_productos__c> childFamilyProductsList{get;set;}
    public List<Product2> childProductsList{get;set;}
    public Familia_de_productos__c selProd{get;set;}
    public String ParentProdId {get;set;}
    public Boolean showParentPanel {get;set;}
    public Boolean searchRes{get;set;}
    public Boolean detailsPanel{get;set;}
    public Boolean prod2{get;set;}
    public String searchTxt{get;set;}
    public List<searchResultCls> searchResultList{get;set;}
    public String selProdId{get;set;}
    public Product2 prod{get;set;}
    public Familia_de_productos__c FDprod{get;set;}
    public CollaborationGroup cGroup{get;set;}
    public List<ContentDocumentLink> gFilesList{get;set;}
    
    public product_catalog_cls(){
        prodFamilyList = [select Id, Name, Imagen__c from Familia_de_productos__c where Familia__c = : null];
        showParentPanel = true;
        searchRes = false;
        detailsPanel = false;
    }
    
    public void childProducts(){
        detailsPanel = false;
        searchRes = false;
        try{
            selProd = [select Id, Name, Imagen__c from Familia_de_productos__c where id = : ParentProdId];
        }catch(Exception e){}
        
        childFamilyProductsList = [select Id, Name, Imagen__c, Familia__r.Name from Familia_de_productos__c where Familia__c = : ParentProdId];
        system.debug('childFamilyProductsList size: '+childFamilyProductsList.size());
        
        childProductsList = [select Id, Name, ProductImageRelatedList__c, purl__c from Product2 where Familia_de_productos__c =: ParentProdId];
        system.debug('childProductsList size: '+childProductsList.size());
        
        if(childProductsList.size() == 0 && childFamilyProductsList.size() == 0){
            selProdId = ParentProdId;
            prodDetails();
        }
        
        showParentPanel = false;
    }
    public void showHome(){
        searchRes = false;
        showParentPanel = true;
        childProductsList = null;
        childFamilyProductsList = null;
        detailsPanel = false;
    }
    public void searchProd(){
        if(searchTxt == ''){
            searchRes = false;
        }else{
            searchRes = true;
            detailsPanel = false;
            searchResultList = new List<searchResultCls>();
            String srchStr = '%'+searchTxt+'%';
            for(Familia_de_productos__c prodFamilyRes : [select Id, Name, Imagen__c from Familia_de_productos__c where Familia__c != null and Name Like : srchStr]){
                searchResultList.add(new searchResultCls(prodFamilyRes.Id, prodFamilyRes.Name, prodFamilyRes.Imagen__c));
            }
            for(Product2 prodRes : [select Id, Name, ProductImageRelatedList__c, purl__c from Product2 where Name Like : srchStr]){
                searchResultList.add(new searchResultCls(prodRes.Id, prodRes.Name, prodRes.purl__c));
            }
        }
    }
    
    public void prodDetails(){
        detailsPanel = true;
        String prodName = '';
        try{
            prod = [select Id, Name, Item_Long_Description__c from Product2 where Id =: selProdId];
            prod2 = true;
            prodName = prod.Name;
        }catch(Exception e){
            FDprod = [select Id, Name, Item_Long_Description__c from Familia_de_productos__c where Id =: selProdId];
            prod2 = false;
            prodName = FDprod.Name;
        }
        try{
	        cGroup = [select Id, Name from CollaborationGroup where name =: prodName];
            gFilesList = [SELECT ContentDocumentId, ContentDocument.Id, ContentDocument.Title, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId = : cGroup.Id];
        }catch(Exception e){}
    }
    
    public class searchResultCls{
        public String pId{get;set;}
        public String pName{get;set;}
        public String pImg{get;set;}
        
        public searchResultCls(String pId, String pName, String pImg){
            this.pId = pId;
            this.pName = pName;
            this.pImg = pImg;
        }
    }
}