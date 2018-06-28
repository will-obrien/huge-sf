public class detail {
    private string op;
    private List<Product__c>  i;
    public string  getop(){
    return op;
    }
    public  void setop(){
    i=[select Product_Price__c, Quantity__c from Product__c where Product__c.name=:'crocin'];
    op=''+i;
    }
}