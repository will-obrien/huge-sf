public class cartManager{
    public String cardno{get;set;}
    public list<cartmanager__c> cartno{get;set;}
    public list<modelDemo> products{get;set;}
    public cartmanager(){
        products = new list<modelDemo>();
        cartno = [select productid__c from cartmanager__c];
        for(cartmanager__c val : cartno){
            list<product__c> record = [select product_name__c,price__c,status__c,(select id from attachments) from product__c  where id =: val.productid__c ];
            for(product__c p : record){
                for(Attachment at : p.attachments){
                    modelDemo md = new modelDemo();
                    md.pro = p;
                    md.att = at;
                    products.add(md);
                }

            
            }
           
        }
    }
    public void pay(){
                Transaction__c t = new  Transaction__c();
                t.Cardno__c = cardno;
                insert t;
        
    }
    public class modelDemo{
        public product__c pro{get;set;}
        public Attachment att{get;set;}
    }
}