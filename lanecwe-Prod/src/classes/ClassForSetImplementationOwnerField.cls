public class ClassForSetImplementationOwnerField{
  
  public static Boolean stopRecursion;
  
  public ClassForSetImplementationOwnerField(){
      stopRecursion = false;
  }
  
  @future
  public static void UpdateOwnerField(List<id> OppIds, List<id> ImpSerRecordIds){
  
    system.debug('Inside future...ImpSerRecordIds '+ImpSerRecordIds);
    List<Opportunity> OppList= new List<Opportunity>(); 
    map<id, Implementation_Services__c> MatchingImpSerMap ;
    Implementation_Services__c ImpObj= new Implementation_Services__c();
    List<Opportunity> OppUpsertList= new List<Opportunity>(); 
  
    OppList=[Select Implementation_Owner__c,Related_Implementation_Record__c from Opportunity where id IN:OppIds];
 
    MatchingImpSerMap = new map<id, Implementation_Services__c>([SELECT id,Implementation_Owner__c FROM Implementation_Services__c where id IN:ImpSerRecordIds]);
     
     

  for(Opportunity opp:oppList)
  {
  ImpObj=MatchingImpSerMap.get(opp.Related_Implementation_Record__c);  
  
  if(ImpObj != null)
  {    opp.Implementation_Owner__c=ImpObj.Implementation_Owner__c;
       opp.Apex_Update__c = true;
       OppUpsertList.add(opp);
  }
  
  }
  
  if(OppUpsertList.size()>0){ 
      stopRecursion = true;
      update OppUpsertList;
  
  } 
        

  }
   
  }