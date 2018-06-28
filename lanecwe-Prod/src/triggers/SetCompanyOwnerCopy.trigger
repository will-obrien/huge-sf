trigger SetCompanyOwnerCopy on Company__c(before insert,before update) {

String TempID= '';

  for(Company__c ld:trigger.new)
    {
       TempID=ld.OwnerId;   
       system.debug('#---- TempID'+TempID);
  
       if(TempID != null)
         {  system.debug('I am 1');
             
              if(TempID.startsWith('005'))
                  {  system.debug('I am 2');
                          ld.Owner_Copy__c=ld.OwnerID;
                  }
             else
                  { system.debug('I am 3');

                          ld.Owner_Copy__c=null;
                  }
  
  
  }  

  
   }

}