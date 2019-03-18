trigger SetImplementationOwnerOnOpportunity on Implementation_Services__c (after insert,after update) {

String ImplementationServiceID;
String RelatedOpportunityID;
String ImplmentationOwner;
List<Implementation_Services__c> ISList= new List<Implementation_Services__c>();
List<Opportunity> OList= new List<Opportunity>();
List<Opportunity> OppListToBeUpdated= new List<Opportunity>();


for(Implementation_Services__c I:trigger.new)
{ if(I.id !=null || I.id != '')
    {ImplementationServiceID=I.id;
    } 
    
     if(I.Related_Opportunity__c !=null || I.Related_Opportunity__c != '')
    {RelatedOpportunityID=I.Related_Opportunity__c;
    }
       
    system.debug('####--ImplementationServiceID--'+ImplementationServiceID);
     system.debug('####--RelatedOpportunityID--'+RelatedOpportunityID);
     
 
}

ISList=[SELECT Implementation_Owner__c FROM Implementation_Services__c where id=:ImplementationServiceID Limit 1];
 system.debug('####--ISList--'+ISList);
 
 OList=[Select id,Implementation_Owner__c  from Opportunity where id=:RelatedOpportunityID];

 
 system.debug('####--OList--'+OList);

 
 if(ISList.size()>0 && OList.size()>0)
 {  system.debug('####--I am here ---');
    for(Opportunity opp:OList){
         
             opp.Implementation_Owner__c=ISList[0].Implementation_Owner__c;
             opp.Apex_Update__c = true;
             OppListToBeUpdated.add(opp);
           
   }
 }
 
 
  


if(OppListToBeUpdated != null && OppListToBeUpdated.size()>0)
 {  system.debug('####--Updating Opportunity ---');
 Update OppListToBeUpdated;
 }





}