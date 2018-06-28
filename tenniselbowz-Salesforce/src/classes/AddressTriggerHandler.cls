public without sharing class AddressTriggerHandler {
    
    public static final string CREATE_ADDRESS_AND_INSERT_JUNCTION = 'CREATE_ADDRESS_AND_INSERT_JUNCTION';
    public static final string CREATE_ADDRESS_AND_UPDATE_JUNCTION = 'CREATE_ADDRESS_AND_UPDATE_JUNCTION';
    public static final string PROCEED_WITH_UPDATE = 'PROCEED_WITH_UPDATE';
    
    public static void onBeforeUpdate(map<Id, Address__c> newMap, map<Id, Address__c> oldMap)
    {
        
        validateIeUpdate(newMap, oldMap);
        //===================================================================================================
        // Retrict Address record update if DCW_ID__c != null OR Warehouse_Id__c != null OR IE_ID__c != null 
        // AND not tied to more than 1 other object (contact_address, account_address, asset_address).
        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! NO LONGER VALIDATE? !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        map<Id, String> resultMap = validateAddressCanUpdate(newMap, oldMap, new set<Id>());
        
        setAddressAndParentObjectsPending(newMap.values(), oldMap);
    }
    
    public static void onBeforeDelete(map<Id, Address__c> oldMap) 
    {
        for(Address__c a : oldMap.values())
        {
            if(a.Record_Usage__c != null )
                a.addError('This record cannot be deleted because it is integrated with other systems or tied to other critical information within Salesforce.');
        }
    } 
    
    public static void onBeforeInsert(list<Address__c> newList)
    {
        //setAddressAndParentObjectsPending( newList, null);        
    }

    public static void onAfterUpdate(Map<Id, Address__c> newMap, Map<Id, Address__c> oldMap)
    {
        updateStandardAddresses(newMap, oldMap);
        doIntelSync(newMap, oldMap);
    }
    
    public static void validateIeUpdate(map<Id, Address__c> newMap, map<Id, Address__c> oldMap)
    {
        
        
        for(Address__c a : newMap.values())
        {
            //validate integration update date
            if(oldMap.get(a.Id).IE_Updated_Date__c != a.IE_Updated_Date__c
               && a.IE_Updated_Date__c != null
               && a.IE_Updated_Date__c < oldMap.get(a.Id).LastModifiedDate)
               
            {
                a.AddError('Salesforce Last Modified Date is more Recent then IE Updates');
            }
        }
        
        
        
    }
    
    public static void updateStandardAddresses(Map <Id,Address__c> newMap, map<Id, Address__c> oldMap)
    {

        if(TriggerUtility.syncedAddresses){
            return;
        }

        List<Address__c> changedAddresses = new List<Address__c>();
        for(Address__c addr : newMap.values()){
            if(!AddressHelper.equalAddresses(addr, oldMap.get(addr.Id), false)){
                changedAddresses.add(addr);
            }
        }
        
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();

        for(Address__c addr : [SELECT (SELECT Primary_Ship_To__c,
                                                Physical__c,
                                                Account__r.BillingStreet,
                                                Account__r.BillingCountry,
                                                Account__r.BillingCity,
                                                Account__r.BillingPostalCode,
                                                Account__r.BillingState,
                                                Account__r.ShippingStreet,
                                                Account__r.ShippingCountry,
                                                Account__r.ShippingCity,
                                                Account__r.ShippingPostalCode,
                                                Account__r.ShippingState  
                                            from Account_Addresses__r),
                                            (SELECT Primary_Mail_To__c,
                                                Physical__c,
                                                Contact__r.MailingStreet,
                                                Contact__r.MailingCountry,
                                                Contact__r.MailingCity,
                                                Contact__r.MailingPostalCode,
                                                Contact__r.MailingState,
                                                Contact__r.OtherStreet,
                                                Contact__r.OtherCountry,
                                                Contact__r.OtherCity,
                                                Contact__r.OtherPostalCode,
                                                Contact__r.OtherState  
                                            from Contact_Addresses__r) 
                                    from Address__c where Id IN :changedAddresses]){

            Address__c updatedAddress = newMap.get(addr.Id);

            for(Account_Address__c acctAddr : addr.Account_Addresses__r){
                Boolean updateAccount = false;
                Account acct = acctAddr.Account__r;

                Address__c billingAddr = AddressHelper.standardAddressToAddressObject(acct.BillingStreet, acct.BillingCountry, acct.BillingCity, acct.BillingPostalCode, acct.BillingState);
                if(acctAddr.Physical__c && !AddressHelper.equalAddresses(updatedAddress, billingAddr, false)){
                    AddressHelper.populateStandardAddress(updatedAddress,acct,'Billing');
                    updateAccount = true;
                }

                Address__c shipAddr = AddressHelper.standardAddressToAddressObject(acct.ShippingStreet, acct.ShippingCountry, acct.ShippingCity, acct.ShippingPostalCode, acct.ShippingState);
                if(acctAddr.Primary_Ship_To__c && !AddressHelper.equalAddresses(updatedAddress, shipAddr, false)){
                    AddressHelper.populateStandardAddress(updatedAddress,acct,'Shipping');
                    updateAccount = true;    
                }

                if(updateAccount){
                    accountsToUpdate.add(acct);
                }
            }

            for(Contact_Address__c contAddr : addr.Contact_Addresses__r){
                Boolean updateContact = false;
                Contact cont = contAddr.Contact__r;

                Address__c mailingAddr = AddressHelper.standardAddressToAddressObject(cont.MailingStreet, cont.MailingCountry, cont.MailingCity, cont.MailingPostalCode, cont.MailingState);
                if(contAddr.Primary_Mail_To__c && !AddressHelper.equalAddresses(updatedAddress, mailingAddr, false)){
                    AddressHelper.populateStandardAddress(updatedAddress,cont,'Mailing');
                    updateContact = true;
                }

                Address__c shipAddr = AddressHelper.standardAddressToAddressObject(cont.OtherStreet, cont.OtherCountry, cont.OtherCity, cont.OtherPostalCode, cont.OtherState);
                if(contAddr.Physical__c && !AddressHelper.equalAddresses(updatedAddress, shipAddr, false)){
                    AddressHelper.populateStandardAddress(updatedAddress,cont,'Other');
                    updateContact = true;    
                }

                if(updateContact){
                    contactsToUpdate.add(cont);
                }
            }
        }
        TriggerUtility.syncedAddresses = true;
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
        TriggerUtility.syncedAddresses = false;
    }
    
    
    public static void setAddressAndParentObjectsPending(list<Address__c> newList, map<Id, Address__c> oldMap)
    {
        
        if(TriggerUtility.limitIntegrationBatch || TriggerUtility.limitIeServiceIntegration){ 
                return;
        } 
        
        //executed on the before update event
        list<Contact> contacts = new list<Contact>();
        list<Account> accounts = new list<Account>();
        list<Asset> assets = new list<Asset>();
        
        //list<Address__c> addresses = new list<Address__c>();
        
        set<Id> addressIds = new set<Id>();
        
        
        
        for(Address__c a :newList)
        {
            if(a.IE_Address__c )
            {
                if(a.IE_Address__c && (oldMap == null || oldMap.get(A.Id).IE_Address__c != true))
                {
                    if(a.Record_Usage__c != null && !a.Record_Usage__c.contains('IE'))
                        a.Record_Usage__c +=  ';IE';
                    else if(a.Record_Usage__c == null)
                        a.Record_Usage__c =  'IE';
                }
                if(   !AddressHelper.equalAddresses(a, oldMap.get(a.Id), true))
                {
                    addressIds.add(a.Id);
                }
            }
        }
        
        for(Contact_Address__c c : [Select Contact__r.IE_Sync_Status__c
                                      from Contact_Address__c
                                     where Contact__r.IE_Sync_Status__c != 'Pending'
                                       and Contact__r.IE_Contact__c = true
                                       and Address__c in :addressIds])
        {
            c.Contact__r.IE_Sync_Status__c = 'Pending';
            contacts.add(c.Contact__r);
        }
        
        for(Account_Address__c c : [Select Account__r.IE_Sync_Status__c
                                      from Account_Address__c
                                     where Account__r.IE_Sync_Status__c != 'Pending'
                                       and Account__r.IE_Account__c = true
                                       and Address__c in :addressIds])
        {
            c.Account__r.IE_Sync_Status__c = 'Pending';
            accounts.add(c.Account__r);
        }
        /**LOOK AT ASSETS' ADDRESSES NOT THE JUNCTION**/
        for(Asset_Address__c c : [  Select Asset__r.IE_Sync_Status__c
                                      from Asset_Address__c
                                     where Asset__r.IE_Sync_Status__c != 'Pending'
                                       and Asset__r.IE_Asset__c = true
                                       and Address__c in :addressIds])
        {
            c.Asset__r.IE_Sync_Status__c = 'Pending';
            assets.add(c.Asset__r);
        }
        
        
        if(contacts.size() > 0)
            update contacts;
            
        if(accounts.size() > 0)
            update accounts;
            
        if(assets.size() > 0)
            update assets;
        
    }
    
    public static map<Id, String> validateAddressCanUpdate(map<Id, Address__c> newMap, map<Id, Address__c> oldMap, set<Id> junctionExclusions)
    {
        
        map<Id,Integer> addressJunctionIds = new map<Id,Integer>();
        for(Account_Address__c a : [Select Address__c from Account_Address__c where Address__c in :newMap.keySet() and (NOT( Id in :junctionExclusions) )])
        {
            if(addressJunctionIds.containsKey(a.Address__c))
            {
                Integer x = addressJunctionIds.get(a.Address__c);
                x++;
                addressJunctionIds.put(a.Address__c, x);
            }
            else
            {
                addressJunctionIds.put(a.Address__c, 1);
            }
        }
        /** Change to the Lookup to Address__c from Asset - NOT the Junctionm **/   
        for(Asset a : [Select Asset_Address__c from  Asset where Asset_Address__c in :newMap.keySet() and (NOT( Id in :junctionExclusions) )])
        {
            if(addressJunctionIds.containsKey(a.Asset_Address__c))
            {
                Integer x = addressJunctionIds.get(a.Asset_Address__c);
                x++;
                addressJunctionIds.put(a.Asset_Address__c, x);
            }
            else
            {
                addressJunctionIds.put(a.Asset_Address__c, 1);
            }
        }
        
        for(Opportunity a : [Select job_Address__c from  Opportunity where job_Address__c in :newMap.keySet() and (NOT( Id in :junctionExclusions) )])
        {
            if(addressJunctionIds.containsKey(a.job_Address__c))
            {
                Integer x = addressJunctionIds.get(a.job_Address__c);
                x++;
                addressJunctionIds.put(a.job_Address__c, x);
            }
            else
            {
                addressJunctionIds.put(a.job_Address__c, 1);
            }
        }
            
        for(Contact_Address__c a : [Select Address__c from Contact_Address__c where Address__c in :newMap.keySet() and (NOT( Id in :junctionExclusions) )])
        {
            if(addressJunctionIds.containsKey(a.Address__c))
            {
                Integer x = addressJunctionIds.get(a.Address__c);
                x++;
                addressJunctionIds.put(a.Address__c, x);
            }
            else
            {
                addressJunctionIds.put(a.Address__c, 1);
            }
        } 
            
        map<Id, String> returnVals = new  map<Id, String>();
        for(Address__c a : newMap.values())
        {
            if( !AddressHelper.equalAddresses(a, oldMap.get(a.Id), false))
            {
                System.Debug(':::::DCW_ID__c> '+a.DCW_ID__c + ' ::a.Warehouse_Id__c::'+a.Warehouse_Id__c);
                if(a.DCW_ID__c != null || a.Warehouse_Id__c != null)
                {
                    //create address as well as junction
                    returnVals.put(a.Id, CREATE_ADDRESS_AND_INSERT_JUNCTION);
                }
                else if( addressJunctionIds.containsKey(a.Id) && addressJunctionIds.get(a.Id) > 1)
                {
                    //create address and update junction
                    returnVals.put(a.Id, CREATE_ADDRESS_AND_UPDATE_JUNCTION);
                }
                else
                {
                    //do nothing, proceed
                    returnVals.put(a.Id, PROCEED_WITH_UPDATE);
                }
            }
        }
        
        return returnVals;
    }

    public static void doIntelSync(map<Id, Address__c> newMap, map<Id, Address__c> oldMap) {
        List<Id> addressesChanged = AssetIntegrationService.filterAddressesWhoseAssetsToSync(newMap.values(), oldMap);
        List<Asset> assetsToSync = [ SELECT Id FROM Asset WHERE Asset_Address__c in :addressesChanged ];
        System.debug('^^^ assetsToSync: ' + assetsToSync);
        for (Asset ast : assetsToSync) {
            ID jobID = System.enqueueJob(new SendAssetToIntel(ast.Id));
            System.debug('jobbbbb: ' + jobID);
        }
    }
}