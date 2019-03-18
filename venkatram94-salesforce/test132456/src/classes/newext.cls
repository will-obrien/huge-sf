public class newext {
public product__c pr {get;set;}
pagereference pref;
    public newext(ApexPages.StandardSetController controller) {
        
    }
    public pagereference add(){
    pref=new pagereference('/apex/addproduct/');
    return pref;
    }

}