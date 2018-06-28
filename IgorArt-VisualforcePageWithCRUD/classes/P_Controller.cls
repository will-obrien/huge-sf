public with sharing class P_Controller {
public Date startDT {get;set;}
public Date endDT {get;set;}
public String SearchProductKeyword { get; set; }
public Integer noOfRecords{get; set;}
public List<Product__c> Products { get{
return (List<Product__c>)setCon.getRecords();
} set; }
public Integer size{get;set;}
//Wrapper logic
public List<Product_Wrapper> wrappers {get; set;}
 public static Integer toDelIdent {get; set;}
 public static Integer addCount {get; set;}
 private Integer nextIdent=0;
 public P_Controller()
 {
  wrappers=new List<Product_Wrapper>();  
  for (Integer idx=0; idx<5; idx++)
  {
   wrappers.add(new Product_Wrapper(nextIdent++));
  }
 }
  public void delWrapper()
 {
  Integer toDelPos=-1;
  for (Integer idx=0; idx<wrappers.size(); idx++)
  {
   if (wrappers[idx].ident==toDelIdent)
   {
    toDelPos=idx;
   }
  }
  if (-1!=toDelPos)
  {
   wrappers.remove(toDelPos);
  }
 }
  public void addRows()
 {
  for (Integer idx=0; idx<addCount; idx++)
  {
   wrappers.add(new Product_Wrapper(nextIdent++));
  }
 }  
 public PageReference save()
 {
  List<Product__c> prs=new List<Product__c>();
  for (Product_Wrapper wrap : wrappers)
  {
   prs.add(wrap.pr);
  }
   
  insert prs;
   
  return new PageReference('/' + Schema.getGlobalDescribe().get('Product__c').getDescribe().getKeyPrefix() + 

'/o');
 }
 //Search and Pagination logic
public ApexPages.StandardSetController setCon {

 get{

    if(setCon == null){
    size = 10;
    string SearchProductKeywordCreteria = '%'+(SearchProductKeyword == null ? '' : SearchProductKeyword)+'%';
    List<Product__c> ProductList = [SELECT Id, Name,Price__c,Type__c, Amount__c, Date_Added__c,Release_Date__c,Available__c  FROM Product__c WHERE Name  LIKE :SearchProductKeywordCreteria 

AND (Date_Added__c>=:startDT)  AND  (Date_Added__c<=:endDT)  LIMIT 10000]; 
    setCon = new ApexPages.StandardSetController(ProductList);
    setCon.setPageSize(size);
    noOfRecords = setCon.getResultSize();
}
return setCon;
}set;
}
public void SearchProducts() {
setCon = null;
setCon.setPageNumber(1);
}

}