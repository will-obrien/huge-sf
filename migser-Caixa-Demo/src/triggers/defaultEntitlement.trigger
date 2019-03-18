trigger defaultEntitlement on Case (Before Insert, Before Update) {
   /*
   If the Entitlement Name is not set then, check to see if the Contact on the Case has an active Entitlement
    and select the first one.  If not then check to see if the Account on the Case has an active Entitlement.
   */
   List<Id> contactIds = new List<Id>();
   List<Id> acctIds = new List<Id>();
   for (Case c : Trigger.new){
      if (c.EntitlementId == null && c.ContactId != null && c.AccountId != null){
         contactIds.add(c.ContactId);
         acctIds.add(c.AccountId);
      }
   }
   if(contactIds.isEmpty()==false || acctIds.isEmpty()==false){
      /* Added check for active entitlement */
      List <EntitlementContact> entlContacts = [Select e.EntitlementId,e.ContactId,e.Entitlement.AssetId From EntitlementContact e
                                                Where e.ContactId in :contactIds
                                                And e.Entitlement.EndDate >= Today And e.Entitlement.StartDate <= Today];
      if(entlContacts.isEmpty()==false){
         for(Case c : Trigger.new){
            if(c.EntitlementId == null && c.ContactId != null){
               for(EntitlementContact ec:entlContacts){
                  if(ec.ContactId==c.ContactId){
                     c.EntitlementId = ec.EntitlementId;
                     if(c.AssetId==null && ec.Entitlement.AssetId!=null)
                        c.AssetId=ec.Entitlement.AssetId;
                     break;
                  }
               } // end for
            }
         } // end for
      } else{
         List <Entitlement> entls = [Select e.StartDate, e.Id, e.EndDate, e.AccountId, e.AssetId
                                     From Entitlement e
                                     Where e.AccountId in :acctIds And e.EndDate >= Today And e.StartDate <= Today];
         if(entls.isEmpty()==false){
            for(Case c : Trigger.new){
               if(c.EntitlementId == null && c.AccountId != null){
                  for(Entitlement e:entls){
                     if(e.AccountId==c.AccountId){
                        c.EntitlementId = e.Id;
                        if(c.AssetId==null && e.AssetId!=null)
                           c.AssetId=e.AssetId;
                        break;
                     }
                  } // end for
               }
            } // end for
         }
      }
   } // end if(contactIds.isEmpty()==false)
}

/* Old Code API Ver 18.0 02/25/15 change
trigger defaultEntitlement on Case (Before Insert, Before Update) {
    List<Id> contactIds = new List<Id>();
    for (Case c : Trigger.new){
        if (c.EntitlementId == null && c.ContactId != null)
            contactIds.add(c.ContactId);
    }
    if(contactIds.isEmpty()==false){
        List <EntitlementContact> entlContacts = [Select e.EntitlementId, e.entitlement.primary__c, e.entitlement.name, e.ContactId From EntitlementContact e
                                                  Where e.ContactId in :contactIds And e.Entitlement.EndDate >= Today
                                                  And e.Entitlement.StartDate <= Today];
        if(entlContacts.isEmpty()==false){
            for(Case c : Trigger.new){
                if(c.EntitlementId == null && c.ContactId != null){
                    for(EntitlementContact ec:entlContacts){
                        if(ec.ContactId==c.ContactId && ec.entitlement.primary__c==true){
                            c.EntitlementId = ec.EntitlementId;
                            break;
                        }
                    } // end for
                }
            } // end for
        }
    } // end if(contactIds.isEmpty()==false)
}
*/