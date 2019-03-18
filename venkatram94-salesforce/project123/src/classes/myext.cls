public class myext {
public Team__c te;
public Team__c tem{get; set;}
    public myext(ApexPages.StandardController controller) {
tem=(Team__c)controller.getRecord();
    }
    public Pagereference save(){
    insert tem;
    pagereference pref=new pagereference('/apex/Team_Success');
    return pref;
}
}