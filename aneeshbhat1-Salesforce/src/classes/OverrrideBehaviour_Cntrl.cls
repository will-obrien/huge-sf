public class OverrrideBehaviour_Cntrl {
    public Id PageId{get;set;}
    public boolean ShowPage1{get;set;}
    public boolean ShowPage2{get;set;}
    
    public OverrrideBehaviour_Cntrl(ApexPages.StandardController controller) {
        PageId=apexPages.currentPage().getParameters().get('CF00N2800000IZtOY_lkid');
        Account acc=[SELECT Id,Rating FROM Account WHERE ID=:PageId];
        if(acc.Rating=='Hot')
        {
            ShowPage1=true;
            ShowPage2=false;
        }
        else
        {
            ShowPage1=false;
            ShowPage2=true;
        }
    }
     public PageReference OnSave1()
    {
        OverrideBehaviour__c newObj=new OverrideBehaviour__c(Account__c=PageId);
        Insert(newObj);
        PageReference pg=new PageReference('/'+PageId);
        return pg;
    }
    public PageReference OnSave2()
    {
        OverrideBehaviour__c newObj=new OverrideBehaviour__c(Account__c=PageId);
        Insert(newObj);
        PageReference pg=new PageReference('/'+PageId);
        return pg;
    }
}