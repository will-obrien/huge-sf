/* Application: salesforce & Youtube Integration
 * Client: Cognizant
 * Developed by : Subrat Poudyal
*/
public class BatchEnableYoutubeSearch implements Database.Batchable<sObject>,Database.Stateful {

  public List<PermissionSetAssignment>plist = new list<PermissionSetAssignment>();
   BatcYoutubeCurrentTime__c b = BatcYoutubeCurrentTime__c.getInstance('batchquery');
         public datetime d ;
    Id permsnsetId =Id.valueOf(Label.YoutubeEnablePermission);
    //system.debug(permsnsetId);
/*public Ownerchange (String q,String e,String f,String t){
query=q;
email= e;
touserId=t;
fromuserId=f;
}*/


public Database.querylocator start(Database.BatchableContext BC){
       d =b.BatchCurrentTime__c;
    system.debug('--------'+d);
         datetime da = Datetime.valueOf(d.AddDays(1));
    system.debug('da'+da);
string query ='SELECT Id,Name,OwnerId,Type,YoutubeVideo__c FROM Account where type=\'Customer - Channel\' and CreatedDate>=:da';
system.debug('--->query'+query);
  return Database.getQueryLocator(query);
   }
   
public void execute(Database.BatchableContext BC, List<sObject> scope){
system.debug('-------');
List<Account> accns = new List<Account>();

list<PermissionSetAssignment>perlist=[SELECT AssigneeId,Id,PermissionSetId FROM PermissionSetAssignment where PermissionSetId=:permsnsetId];
 Map<id,PermissionSetAssignment> perMap=new Map<id,PermissionSetAssignment>();
    //adding the permission to map
    for(PermissionSetAssignment per:perlist)
     perMap.put(per.assigneeId,per);
    
for(sObject s : scope){
Account a = (Account)s;
    if(a.OwnerId!=null){
a.YoutubeVideo__c='https://c.ap2.visual.force.com/apex/YouTubeSearch';   
accns.add(a);  
    if(permap.get(a.ownerid)==null){      
        system.debug('******');
PermissionSetAssignment p=new PermissionSetAssignment();
p.PermissionSetId=permsnsetId;
p.AssigneeId=a.ownerId;
    plist.add(p);
    }    
    }
}
    
update accns;
    
}
     public void finish(Database.batchableContext bc){
         Insert plist;
        BatcYoutubeCurrentTime__c b = BatcYoutubeCurrentTime__C.getInstance('batchquery');
         b.BatchCurrentTime__c=datetime.valueOf(system.currentTimeMillis());
        // system.debug('plist'+'--->'+accns);
     }


}