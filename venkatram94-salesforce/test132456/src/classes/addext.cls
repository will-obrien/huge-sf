public class addext {
public product__c pr {get;set;}
pagereference pref;
    public addext(ApexPages.StandardSetController controller) {
        
    }
    public pagereference AddProduct(){
    pref=new pagereference('/apex/addproduct');
    return pref;
    }

}