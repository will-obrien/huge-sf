public with sharing class Accountext {
public Account acc{get;set;}
    public Accountext(ApexPages.StandardController controller) {
     acc=(Account)controller.getRecord();
    }
public PageReference save(){
PageReference pref=new PageReference('/home/home.jsp');
return pref;
}
}