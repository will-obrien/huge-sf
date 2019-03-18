public without sharing class AssetTriggerHandler {
    
    public static void onBeforeUpdate(list<Asset> newList, map<Id, Asset> oldMap)
    {
        
        setIeSyncStatus(newList, oldMap);
    }
    
    public static void onAfterUpdate(map<Id, Asset> newMap, map<Id, Asset> oldMap)
    {
        
        processGatewayAsset(newMap);
        //processSubscriptions(newMap,oldMap); 
        doIntelSync(newMap, oldMap);
    }
    
    public static void onBeforeInsert(list<Asset> newList)
    {
        
        setIeSyncStatus(newList, null);
    }
    
    public static void onAfterInsert(map<Id, Asset> newMap)
    {
    
        processGatewayAsset(newMap);
        //processSubscriptions(newMap, null);
        
    } 
    
    public static void onBeforeDelete(map<Id, Asset> oldMap)
    {
        for(Asset a : oldMap.values())
        {
            if( a.Record_Usage__c != null)
                a.addError('This record cannot be deleted because it is integrated with other systems or tied to other critical information within Salesforce.');
                
        }
        
    } 
     
    public static void setIeSyncStatus(list<Asset> newList, map<Id, Asset> oldMap)
    {
        set<Id> productIds = new set<Id>();
        map<Id, Boolean> productIsIeMap = new map<Id, Boolean>();
        for(Asset a : newList)
        {
            if(oldMap != null && oldMap.get(a.Id).IE_Updated_Date__c != a.IE_Updated_Date__c
               && a.IE_Updated_Date__c != null
               && oldMap.get(a.Id).IE_Updated_Date__c < oldMap.get(a.Id).LastModifiedDate)
            {
                a.AddError('Salesforce Last Modified Date is more Recent then IE Updates');
            }
            
            productIds.add(a.Product2Id);
        }
        
        for(Product2 p : [Select Id, IE__c from Product2 where Id in :productIds])
        {
            productIsIeMap.put(p.Id, p.IE__c);
        }
        
        if(TriggerUtility.limitIeServiceIntegration || TriggerUtility.limitIntegrationBatch){
                
                return;
        } 
        
        for(Asset a : newList)
        {
            if(a.IE_Asset__c && a.IE_Sync_Status__c != 'Pending' && ((oldMap == null || oldMap.get(A.Id).IE_Sync_Status__c != 'Pending')
                                                                     || productIsIeMap.get(a.Product2Id)) )
            {
                a.IE_Sync_Status__c = 'Pending';
            }
            
            if(a.IE_Asset__c && (oldMap==null || oldMap.get(a.Id).IE_Asset__c != true))
            {
                if(a.Record_Usage__c != null && !a.Record_Usage__c.contains('IE'))
                    a.Record_Usage__c +=  ';IE';
                else if(a.Record_Usage__c == null)
                    a.Record_Usage__c =  'IE';
            }
        }
        
    }
    
    public static void processSubscriptions(map<Id, Asset> newMap, map<Id, Asset> oldMap)
    {
        /**
         When Asset.Commissioned__c = true,
            Where Asset.Subscription__c.StartDate__c = null
            Set Subscription__c.Start_Date__c = today
            Set Subscription__c.End_Date__c = today + 456 days
            
            @TODO - Do Not create Duplicate Subscriptions
            @TODO - When Creating Subscriptions do not set the IE Subscription Flag
         */ 
         
         set<Id> assetIdSet = new set<Id>();
         set<Id> commissionedAssetIdSet = new set<Id>();
         
         for(Asset a : newMap.values())
         {
            if(a.Commissioned__c == true && (oldMap != null && oldMap.get(a.Id).Commissioned__c == false) )
                commissionedAssetIdSet.add(a.Id);
                
            if(a.IE_Asset__c == true && (oldMap == null || oldMap.get(a.Id).IE_Asset__c == false))
                assetIdSet.add(a.Id);
         }
         list<Subscription__c> subscriptionList = new list<Subscription__c>();
         list<Subscription__c> existingSubscriptionList = new list<Subscription__c>();
         list<Contact_Subscription__c> contactSubscriptions = new list<Contact_Subscription__c>();
         list<Contact> daiknContacts = new list<Contact>();
         
         for(Subscription__c s : [Select Id, Term_Years__c, Type__c
                                    from Subscription__c
                                   where Asset__c in :commissionedAssetIdSet 
                                     and Asset__c != null
                                     and Type__c  != 'Daikin']) 
         {
            s.Start_Date__c = System.today();
            s.End_Date__c = System.today().addDays((Integer.valueOf(365 * (s.Term_Years__c==null?0:s.Term_Years__c)) ));
            existingSubscriptionList.add(s);
         }
         
         
         if(existingSubscriptionList.size() > 0)
            update existingSubscriptionList;
         
        /*
           - ** NON GATEWAY ASSETS ** Create Daikin Subscription Record using "Daikin" Account and Contacts flagged as to be included(contacts flagged, 
                contact custom setting)
            -- When there are no existing Daikin Subscriotions and the IE_Asset__c flag is true and was previously false
        
         */
         map<Id, Id> ExistingDaikinSubscriptionMap = new map<Id,Id>();
         
         for(Subscription__c s : [Select Id, Asset__c from Subscription__c where Asset__c in :assetIdSet and Type__c  = 'Daikin'])
            ExistingDaikinSubscriptionMap.put(s.Asset__c, s.Id);
            
         for(Id assetId : assetIdSet)   
         {
            if(!ExistingDaikinSubscriptionMap.containsKey(assetId))
            {
                subscriptionList.add(new Subscription__c(Asset__c = assetId
                                                        ,Buyer_Id__c = IE_Service_Configuration__c.getInstance().DaikinAccountId__c
                                                        ,Type__c  = 'Daikin'
                                                        ,Active__c = true));
            }
         }
            
         if(subscriptionList.size() > 0)
            insert subscriptionList;
            
         //create contact subscriptions
         
         //retrieve the "Daikin" account and then the flagged contacts
         for(Contact c : [Select Id, IE_Daikin_Subscription_Role__c
                            from Contact
                           where IE_Daikin_Subscription_Role__c != null
                             and AccountId = :IE_Service_Configuration__c.getInstance().DaikinAccountId__c ])
         {
             list<String> roleList = c.IE_Daikin_Subscription_Role__c.split(';');
             for(Subscription__c s : subscriptionList)
             {
                
                    contactSubscriptions.add(new Contact_Subscription__c(Contact__c = c.Id
                                                                        ,Subscription__c = s.Id
                                                                        ,Asset__c = s.Asset__c
                                                                        ,Role__c = c.IE_Daikin_Subscription_Role__c));
                                                                        
                                                                        
             }
         }
         
         if(contactSubscriptions.size() > 0)
            insert contactSubscriptions;
         
    }
    
    
    public static void processGatewayAsset(map<Id, Asset> newMap)
    {
        /*
        Gateway Asset AfterInsert Trigger:

          - Check for existing gateway asset on current gateway asset's parent equipment asset (using UnitSerialNumber). If one is found, set status to obsolete
          - ** FLAG THE PARENT AS AN IE ASSET
        */
        
        system.debug(':::::::processGatewayAsset::::::'+newMap);
        set<Id> newIdSet = new set<Id>();
        for(Asset a : newMap.values())
        {
            if(a.Status != 'Obsolete')
                newIdSet.add(a.Id);
        }
        set<Id> parentAssetIds = new set<Id>();
        list<Asset> obsoleteAssets = new list<Asset>();
        list<Asset> parentAssets = new list<Asset>();
        
        //collect the IE Gateway Assets
        for(Asset a : [Select Id, Parent_Asset__c 
                         from Asset 
                        where Id in :newIdSet 
                          and Product2.Product_Group__c = 'IE Gateway' 
                          and Status != 'Obsolete'])
        {
            if(a.Parent_Asset__c != null)
                parentAssetIds.add(a.Parent_Asset__c);
        }
            
        //pull the parent Assets' existing gateway assets that are not the current gateway assets
        if(parentAssetIds.size() > 0)
        {
            for(Asset a : [Select Id 
                             from Asset 
                            where Parent_Asset__c in :parentAssetIds 
                              and Parent_Asset__c != null
                              and (NOT( Id in :newIdSet) )
                              and Status != 'Obsolete'
                              and Product2.Product_Group__c = 'IE Gateway'])    
            {
                    a.Status = 'Obsolete';
                    obsoleteAssets.add(a);
            }
        }
        
        
        set<Id> EMMparentAssetIds = new set<Id>();
        //collect the IE EMM Assets
        for(Asset a : [Select Id, Parent_Asset__c 
                         from Asset 
                        where Id in :newIdSet 
                          and Product2.Product_Group__c = 'IE EMM' 
                          and Status != 'Obsolete'])
        {
            EMMparentAssetIds.add(a.Parent_Asset__c);
        }
            
        //pull the parent Assets' existing IE EMM assets that are not the current IE EMM assets and mark them as Obsolete
        if(EMMparentAssetIds.size() > 0)
        {
            for(Asset a : [Select Id,  Parent_Asset__c
                             from Asset 
                            where Parent_Asset__c in :EMMparentAssetIds 
                              and Parent_Asset__c != null
                              and (NOT( Id in :newIdSet) )
                              and Status != 'Obsolete'
                              and Product2.Product_Group__c = 'IE EMM'])    
            {
                    a.Status = 'Obsolete';
                    obsoleteAssets.add(a);
                    parentAssetIds.add(a.Parent_Asset__c);
            }
        }
        
        
        
        //pull the parent Assets so their IE flag can be set
        if(parentAssetIds.size() > 0)
        {
            for(Asset a : [Select Id 
                             from Asset 
                            where Id in :parentAssetIds 
                              and (IE_Asset__c = false or IE_Sync_Status__c != 'Pending')]) 
            {
                    a.IE_Asset__c = true;
                    a.IE_Sync_Status__c = 'Pending';
                    parentAssets.add(a);
            }
        }
        
        //update the obsolete assets
        if(obsoleteAssets.size() > 0)
            update obsoleteAssets;
            
        //update the obsolete assets
        if(parentAssets.size() > 0)
            update parentAssets;
        
    }

    public static void doIntelSync(map<Id, Asset> newMap, map<Id, Asset> oldMap) {
        List<Asset> assetsToSync = AssetIntegrationService.filterAssetsToSync(newMap.values(), oldMap, AssetIntegrationService.filterFields);
        System.debug('^^^ assetsToSync: ' + assetsToSync);
        for (Asset ast : assetsToSync) {
            ID jobID = System.enqueueJob(new SendAssetToIntel(ast.Id));
            System.debug('jobbbbb: ' + jobID);
        }
    }
 
}