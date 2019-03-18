public class assignmentFiveController{
    public list<contact> contacts{get;set;}
    public list<contact> contactupdate{get;set;}
    public assignmentFiveController(){
    contactupdate = new list<contact>();
  id urlid=apexpages.currentpage().getParameters().get('id');
        contacts= [ select firstname,lastname,email from contact where contacted__c =false and accountid= :urlid];
    }
    public pageReference matched(){
        for(contact c : contacts){
            c.contacted__c = true;
            contactupdate.add(c);
        }
        update contactupdate;
        return new pageReference('/apex/assignmentFive?id={!contacts.aaccountid}');
       
    }
}