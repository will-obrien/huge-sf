/*********************************************************************
Name : SetCaseOwnerCopy 
Created On : Oct 19, 2012
Created By : JP
Description : Trigger to copy owner to Owner Copy Field
**********************************************************************/

trigger SetCaseOwnerCopy on Case (before insert,before update) {

String TempID= '';

  for(Case ld:trigger.new)
    {
       TempID=ld.OwnerId;   
       system.debug('#---- TempID'+TempID);
  
       if(TempID != null)
         {  system.debug('I am 1');
             
              if(TempID.startsWith('005'))
                  {  system.debug('I am 2');
                          ld.Case_Owner_Copy__c=ld.OwnerID;
                  }
             else
                  { system.debug('I am 3');

                          ld.Case_Owner_Copy__c=null;
                  }
  
  
  }  

  
   }

}