public class shoppingCartController{
    public list<modelDemo> products{get;set;}
    Attachment att{get;set;}
    Integer listsize=1;
    Integer counter =0;
    public id proid{get;set;}
    
    
    public shoppingCartController(){
    
    products = new list<modelDemo>(); 
    att = new Attachment ();
    System.debug('***'+listsize+'*********'+counter);
    list<product__c> records  = [select product_name__c,price__c,status__c,description__c,Display__c,processor__c,ram__c,sim__c,bluetooth__c,wifi__c,internet_features__c,camera__c,(select id from attachments) from product__c limit :listsize offset : counter ];
    products.clear();
    for(product__c p : records  ) {
        for(Attachment at : p.attachments){
            modelDemo md = new modelDemo();
            md.pro = p;
            md.att=at;
            products.add(md); 
        }
    }  
    
    }
   public pageReference next(){
     counter+=listsize;
    
      list<product__c> records  = [select product_name__c,price__c,status__c,description__c,Display__c,processor__c,ram__c,sim__c,bluetooth__c,wifi__c,internet_features__c,camera__c,(select id from attachments) from product__c limit :listsize offset : counter ];
    products.clear();
    for(product__c p : records  ) {
        for(Attachment at : p.attachments){
            modelDemo md = new modelDemo();
            md.pro = p;
            md.att=at;
            products.add(md); 
        }
    }  
    
     return null;
     
   }
    public pageReference pre(){
     counter-=listsize;
    
      list<product__c> records  = [select product_name__c,price__c,status__c,(select id from attachments) from product__c limit :listsize offset : counter ];
    products.clear();
    for(product__c p : records  ) {
        for(Attachment at : p.attachments){
            modelDemo md = new modelDemo();
            md.pro = p;
            md.att=at;
            products.add(md); 
        }
    }  
    
     return null;
     
   }
   
   
   public pageReference addcart(){
   System.debug('**************************************apexid='+proid);
   
        cartmanager__c cm = new cartmanager__c();
        cm.productId__c = proid;  
        insert cm;
     /* list<cartmanager__c> checkId = [select productid__c from cartmanager__c];
      for( cartmanager__c obj : checkId){
          if(obj.productid__c != proid ){
            
            
          }
      }*/
    
       return null;
   }
   public class modelDemo{
       public product__c pro{get;set;}
       public Attachment att{get;set;}
   
   
   }
}