trigger SetImplementationOwnerField on Opportunity (after insert, after update) { 

List<Id> oppIds = new List<Id>();
List<Id> ImpSerRecordIds= new List<Id>();

//Get oppids and implmntatn ids
for(Opportunity opp:trigger.new){ 
    if(opp.Related_Implementation_Record__c !=null )
   {  
      oppIds.add(opp.Id);
      ImpSerRecordIds.add(opp.Related_Implementation_Record__c); 
    
   }
}
 if(ImpSerRecordIds.size()>0 && oppIds.size()>0 )
 {
    //call future method(oppiDs, implmntn ids);
    if(ClassForSetImplementationOwnerField.stopRecursion != true){
        system.debug('calling future');
        ClassForSetImplementationOwnerField.UpdateOwnerField(oppIds,ImpSerRecordIds);
    }
 }   
system.debug('future class invoked');

}