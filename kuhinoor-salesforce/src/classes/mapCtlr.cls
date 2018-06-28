public Class mapCtlr{
Public Map<String,list<contact>> mapData{get;set;}
Public List<String> conList{get;set;}
    Public mapCtlr(){
    conList = new  List<String>();
    mapData = new  Map<String,list<contact>>();
    for(Account c : [ select name,(select account.name,lastname from contacts) from Account]){
        if(c.contacts.size()>0){
             conList.add(c.id);
        }       
        mapData.put(c.id,c.contacts);
    }
    }
}