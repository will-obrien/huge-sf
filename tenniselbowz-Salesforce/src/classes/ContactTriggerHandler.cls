public without sharing class ContactTriggerHandler {
    
    public static void onAfterInsert(map<Id, Contact> newMap)
    {
        createContactSubscriptions(newMap, null);
        createContactAddress(newMap);
    } 
    
    public static void onAfterUpdate(map<Id, Contact> newMap, map<Id, Contact> oldMap)
    {
        createContactSubscriptions(newMap, oldMap);
    }
    
    public static void onBeforeUpdate(map<Id, Contact> newMap, map<Id, Contact> oldMap)
    {
         
        setIeSyncStatus(newMap.values(), oldMap);
        allOrNoneContactAddresses(newMap.values());
        updateContactAddress(newMap, oldMap);
        
    }
    
    public static void onBeforeInsert(list<Contact> newList)
    {
        
        setIeSyncStatus(newList, null);
        allOrNoneContactAddresses(newList);

    }
    
    public static void onBeforeDelete(map<Id, Contact> oldMap)
    {
        for(Contact c : oldMap.values())
        {
            if( c.Record_Usage__c != null)
                c.addError('This record cannot be deleted because it is integrated with other systems or tied to other critical information within Salesforce.');
                
        }
        
        list<Contact_Subscription__c> contactSubscriptionDeleteList = new list<Contact_Subscription__c>();
        for(Contact_Subscription__c c : [select Id from Contact_Subscription__c where Contact__c in : oldMap.keySet()]) 
            contactSubscriptionDeleteList.add(c);
            
         //delete the associated subscriptions
         if(contactSubscriptionDeleteList.size() > 0)
            delete contactSubscriptionDeleteList;
    } 
    
    @future
    public static void createContactAddress(list<String> contactIds)
    {
        
    }
    public static void createContactAddress(map<Id, Contact> newMap)
    {
        map<Id, Address__c> contactAddressMap = new map<Id, Address__c>();
        list<Contact_Address__c> contactAddresses = new list<Contact_Address__c>();
         
        //iterate through newMap ti find completed addresses
        for(Contact a : [select MailingStreet
                              , MailingCity
                              , MailingCountry
                              , MailingState
                              , MailingPostalCode
                              , Account.Physical_Address__c
                              , Account.Physical_Address__r.Address_Line_1__c
                              , Account.Physical_Address__r.Address_Line_2__c
                              , Account.Physical_Address__r.Address_Line_3__c
                              , Account.Physical_Address__r.Address_Line_4__c
                              , Account.Physical_Address__r.City__c 
                              , Account.Physical_Address__r.Country__c
                              , Account.Physical_Address__r.State_Province__c
                              , Account.Physical_Address__r.Postal_Code__c
                          from Contact
                         where Id in :newMap.keySet()])
        {
            //map the address records to the contact
            Address__c contactMailingAddress = AddressHelper.standardAddressToAddressObject(a.MailingStreet, a.MailingCountry, a.MailingCity, a.MailingPostalCode, a.MailingState);
            
            if(a.MailingStreet != null && a.MailingCity != null && a.MailingCountry != null)
            { 
                if(a.Account.Physical_Address__c != null
                        && (   AddressHelper.equalAddresses(a.Account.Physical_Address__r, contactMailingAddress, false)))
                {
                    /*
                    1) if Contact.Account.Primary_Mailing_Address__c != null, AND the address data is the same
                     - use existing Address record identified by Primary_Mailing_Address__c.Id and Create Contact_Address record
                     - On Contact_Address record, populate the following
                            Active__c = TRUE
                            Primary_Mail_To__c = TRUE
                    */
                    contactAddresses.add(new Contact_Address__c(Contact__c          = a.Id
                                                               ,Address__c          = a.Account.Physical_Address__c
                                                               ,Active__c           = true
                                                               ,Primary_Mail_To__c  = true) );
                }
                else
                {
                    
                    /*
                    2) if Contact.Account.Primary_Mailing_Address__c = null
                     - create Address and Contact_Address record.
                     - For Address, see mapping to left
                     - On Contact, populate MaillingAddress and Primary_Mailing_Address__c (lookup).
                     - On Contact_Address junction, populate the following.
                            Active__c = TRUE
                            Primary_Mail_To__c = TRUE
                    */
                   
                    list<String> addressLines = new list<String>();
                    if(a.MailingStreet != null)
                        addressLines = a.MailingStreet.split('\n');
                        
                    contactAddressMap.put(a.Id, new Address__c( Address_Line_1__c           = addressLines.size() > 0 ? addressLines[0] : null
                                                              , Address_Line_2__c           = addressLines.size() > 1 ? addressLines[1] : null
                                                              , Address_Line_3__c           = addressLines.size() > 2 ? addressLines[2] : null
                                                              , Address_Line_4__c           = addressLines.size() > 3 ? addressLines[3] : null
                                                              , City__c                     = a.MailingCity
                                                              , Country__c                  = a.MailingCountry
                                                              , State_Province__c           = a.MailingState
                                                              , Postal_Code__c              = a.MailingPostalCode
                                                              , RecordTypeId                = '012C0000000HrB3'));
                }
            }
        }
        
        //insert the addresses
        if(contactAddressMap.size() > 0)
        {
            insert contactAddressMap.values();
        }
        
        //iterate throug the contact address map and create the contact address junctions
        for(Contact a : newMap.values())
        {
            if(contactAddressMap.containsKey(a.Id))
            {
                contactAddresses.add(new Contact_Address__c(Contact__c          = a.Id
                                                           ,Address__c          = contactAddressMap.get(a.Id).Id
                                                           ,Active__c           = true
                                                           ,Primary_Mail_To__c  = true) );
            }
        }
        
        //insert the contact address junctions
        if(contactAddresses.size() > 0)
            insert contactAddresses;
    }
    
    
    public static void setIeSyncStatus(list<Contact> newList, map<Id, Contact> oldMap)
    {
        
        
        for(Contact a : newList)
        {
            if(oldMap != null 
               && oldMap.get(a.Id).IE_Updated_Date__c != a.IE_Updated_Date__c
               && a.IE_Updated_Date__c != null 
               && a.IE_Updated_Date__c < oldMap.get(a.Id).LastModifiedDate)
            {
                a.AddError('Salesforce Last Modified Date is more Recent then IE Updates');
            }
        }
        
        
        
        
        for(Contact a : newList )
        {
            if(a.IE_Contact__c && (oldMap == null || oldMap.get(a.Id).IE_Sync_Status__c != 'Pending' )
               && !(TriggerUtility.limitIeServiceIntegration || TriggerUtility.limitIntegrationBatch)){
              a.IE_Sync_Status__c = 'Pending';
            }
                
            
            if(a.IE_Contact__c && (oldMap==null || oldMap.get(a.Id).IE_Contact__c != true))
            {
                if(a.Record_Usage__c != null && !a.Record_Usage__c.contains('IE'))
                    a.Record_Usage__c +=  ';IE';
                else if(a.Record_Usage__c == null)
                    a.Record_Usage__c =  'IE';
            }
            
            if(a.Record_Usage__c == null && a.DTJobGUID__c != null)
            {
                /*
                    Before Contact Update:
                    New Record_Usage__c = null
                    New DTJobGUID__c != null
                    New DTJobGUID__c value comparison to Current DTJobGUID__c value to see if it exists in the Current list of values.
                    
                    Check if DTJobGUID provided value is in DTJobGUID__c field,
                         if found, remove provided DTJobGUID value from DTJobGUID__c
                 */
                 
                 if(oldMap.get(a.Id).DTJobGUID__c != null && oldMap.get(a.Id).DTJobGUID__c.contains(a.DTJobGUID__c))
                 {
                    string guid = oldMap.get(a.Id).DTJobGUID__c;
                    list<string> guids = guid.split(',');
                    Integer i = 0;
                    for(String s : guid.split(','))
                    {
                        if(s == a.DTJobGUID__c)
                         guids.remove(i);
                         
                         i++;
                    } 
                    
                    a.DTJobGUID__c = ''+guids;
                 }
            }
            /*
               If IE_Contact__c != true AND if DTJobGUID__c = null,
                remove Record_Usage__c value (e.g. ""IE"") that was provided in web service from multi-select list
             */
             if(a.IE_Contact__c != true && a.DTJobGUID__c == null && a.Record_Usage__c != null)
             {
                
                if(a.Record_Usage__c.contains(';IE'))
                    a.Record_Usage__c.replace(';IE', '');
                else if(a.Record_Usage__c.contains('IE;'))
                    a.Record_Usage__c.replace('IE;', '');
                else if(a.Record_Usage__c.equals('IE'))
                    a.Record_Usage__c.replace('IE', '');
             }
        }
        
    }
    
    public static void createContactSubscriptions(map<Id, Contact> newMap, map<Id, Contact> oldMap)
    {
        list<Subscription__c> daikinSubscriptions = new list<Subscription__c>();
        for(Subscription__c s : [Select Id, Asset__c from Subscription__c where Type__c = 'Daikin'])
            daikinSubscriptions.add(s);
        
        list<Contact_Subscription__c> contactSubscriptionList = new list<Contact_Subscription__c>();
        list<Contact_Subscription__c> contactSubscriptionDeleteList = new list<Contact_Subscription__c>();
        
        for(Contact_Subscription__c c : [select Id from Contact_Subscription__c where Contact__c in : newMap.keySet() and  Subscription__r.Type__c = 'Daikin']) 
            contactSubscriptionDeleteList.add(c);
            
        for(Contact c : newMap.values())
        {
            if(c.IE_Contact__c == true
                && c.IE_Daikin_Subscription_Role__c != null)
            {
                //itterate through all the Daikin subscriptions
                for(Subscription__c s : daikinSubscriptions)
                {
                    contactSubscriptionList.add(new Contact_Subscription__c(  Role__c           =   c.IE_Daikin_Subscription_Role__c
                                                                            , Asset__c          =   s.Asset__c
                                                                            , Subscription__c   =   s.Id
                                                                            , Contact__c        =   c.Id
                                                                            ));
                }
            }
        }
        
        if(contactSubscriptionDeleteList.size() > 0)
            delete contactSubscriptionDeleteList;
        
        if(contactSubscriptionList.size() > 0)
            insert contactSubscriptionList;
    }
    
    public static void updateContactAddress(map<Id, Contact> newMap, map<Id,Contact> oldMap)
    {
        if(TriggerUtility.limitContactExecution == true || TriggerUtility.syncedAddresses){     
          return;
        } 
        
        map<Id, Address__c> contactAccountPhysicalAddressMap = new map<Id, Address__c>();
        for(Contact c : [select MailingStreet
                              , MailingCity
                              , MailingCountry
                              , MailingState
                              , MailingPostalCode
                              , Account.Physical_Address__c
                              , Account.Physical_Address__r.Address_Line_1__c
                              , Account.Physical_Address__r.Address_Line_2__c
                              , Account.Physical_Address__r.Address_Line_3__c
                              , Account.Physical_Address__r.Address_Line_4__c
                              , Account.Physical_Address__r.City__c 
                              , Account.Physical_Address__r.Country__c
                              , Account.Physical_Address__r.State_Province__c
                              , Account.Physical_Address__r.Postal_Code__c
                              , Account.Physical_Address__r.Country_ISO_Code__c
                          from Contact
                         where Id in :newMap.keySet()])
        {
            if(c.Account.Physical_Address__c != null) 
                contactAccountPhysicalAddressMap.put(c.Id, c.Account.Physical_Address__r);

        }
        map<Id, Address__c> contactAccountPhysicalAddressTranslation = new map<Id, Address__c>();
        for(Contact a : newMap.values())
        {
            if(contactAccountPhysicalAddressMap.containsKey(a.Id) && a.MailingStreet != null && a.MailingCity != null && a.MailingCountryCode != null)
            {
                CountryCodes__c countryCode = CountryCodes__c.getValues(a.MailingCountryCode);
                StateCodes__c stateCode =  a.MailingStateCode != null ? StateCodes__c.getValues(a.MailingCountryCode + '-' + a.MailingStateCode) : null;

                Address__c contactMailingAddress = AddressHelper.standardAddressToAddressObject(a.MailingStreet, countryCode != null ? countryCode.Country__c : null, a.MailingCity, a.MailingPostalCode, stateCode != null ? stateCode.State__c : null);
                
    
                Address__c addr = contactAccountPhysicalAddressMap.get(a.Id);
                if( AddressHelper.equalAddresses(addr, contactMailingAddress, false)
                    && ( !AddressHelper.equalStandardAddress(a, oldMap.get(a.Id), 'Mailing'))
                  )
                {
                    
                    contactAccountPhysicalAddressTranslation.put(a.Primary_Mailing_Address__c, addr); //capture the relationship so that we avoid additional processing
                    a.Primary_Mailing_Address__c = addr.Id;//point to the account's physical address record
                    
                }
            }
        }
        
        
        
        /*
          b) BeforeUpdate, if Mailing Address is changed, then find Address record and update.
                > See new logic added to Address Map & Triggers worksheet (cell K85 red text).
         */
        list<Address__c> addresses= new list<Address__c>();
        map<Id, Address__c> oldAddressMap = new map<Id, Address__c>();
        map<Id, Address__c> newAddrMap = new map<Id, Address__c>();
        map<Id, Address__c> oldAddrMap = new map<Id, Address__c>();
        map<Id,Id> oldAddressContactMap = new map<Id,Id>();
        map<Id, Address__c> mapOfContactToAddress = new map<Id, Address__c>();
        
        //Iterate through the contact records looking for changes in the billing address
        //001M000000ZWR4T
        //003M000000TXn6x
        for(Contact a : newMap.values())
        {
            if( !AddressHelper.equalStandardAddress(a, oldMap.get(a.Id), 'Mailing')
                && a.MailingStreet != null && a.MailingCity != null && a.MailingCountryCode != null
                && !contactAccountPhysicalAddressTranslation.containsKey(a.Primary_Mailing_Address__c)//already transitioned this
              )
             {
                list<String> mailAddressLines = new list<String>();
                if(a.MailingStreet != null)
                    mailAddressLines = a.MailingStreet.split('\n');

                CountryCodes__c countryCode = CountryCodes__c.getValues(a.MailingCountryCode);
                StateCodes__c stateCode =  a.MailingStateCode != null ? StateCodes__c.getValues(a.MailingCountryCode + '-' + a.MailingStateCode) : null;
                    
                Address__c addr = new Address__c(Address_Line_1__c  = mailAddressLines.size() > 0 ? mailAddressLines[0] : null
                                               , Address_Line_2__c  = mailAddressLines.size() > 1 ? mailAddressLines[1] : null
                                               , Address_Line_3__c  = mailAddressLines.size() > 2 ? mailAddressLines[2] : null
                                               , Address_Line_4__c  = mailAddressLines.size() > 3 ? mailAddressLines[3] : null
                                               , City__c            = a.MailingCity
                                               , Country__c         = countryCode != null ? countryCode.Country__c : null
                                               , State_Province__c  = stateCode != null ? stateCode.State__c : null
                                               , Postal_Code__c     = a.MailingPostalCode
                                               , Id                 = a.Primary_Mailing_Address__c);
                
                if(a.Primary_Mailing_Address__c != null)
                {
                    oldAddressMap.put(a.Primary_Mailing_Address__c, addr );
                    oldAddressContactMap.put(a.Primary_Mailing_Address__c, a.Id); 
                }
                else
                {
                    newAddrMap.put(a.Id, addr);
                }
             }
        }
        map<Id, Contact_Address__c> existingContactAddressMap = new map<Id, Contact_Address__c>();
        for(Contact_Address__c aa : [Select Id, Address__c from Contact_Address__c where Contact__c = :newMap.KeySet()])
        {
            existingContactAddressMap.put(aa.Address__c, aa);
        }
        
        
        map<Id, Address__c> originalAddresses = new map<Id, Address__c>();
        
        for(Address__c a : [Select Address_Line_1__c 
                                , Address_Line_2__c
                                , Address_Line_3__c 
                                , Address_Line_4__c
                                , City__c 
                                , Country__c 
                                , State_Province__c
                                , Postal_Code__c
                                , Id 
                                , DCW_ID__c
                                , Warehouse_Id__c
                             from Address__c
                            where Id in :oldAddressMap.keySet()])
        {
            originalAddresses.put(a.Id, a);
        }
        
        
        //attempt to update the billing addresss
        list<Address__c> addressesToUpdate = new list<Address__c>();
        list<Address__c> addressesToInsert = new list<Address__c>();
        
        //attempt to update the mailing addresss
        if(newAddrMap.size() > 0 || oldAddressMap.size() > 0)
        {
            map<Id, String> addressActions = AddressTriggerHandler.validateAddressCanUpdate(originalAddresses, oldAddressMap, null);
            System.Debug('::AddressTriggerHandler.validateAddressCanUpdate::'+addressActions);
            System.Debug('::originalAddresses::'+originalAddresses);
            System.Debug('::oldAddressMap::'+oldAddressMap);
            for(Id i : addressActions.keySet())
            {
                if(addressActions.get(i) == AddressTriggerHandler.PROCEED_WITH_UPDATE)
                    addressesToUpdate.add(oldAddressMap.get(i));
                else
                {
                    Address__c nAddr = oldAddressMap.get(i).clone();
                    //addressesToInsert.add(nAddr);
                    
                    mapOfContactToAddress.put(oldAddressContactMap.get(i), nAddr);
                }
            }

            TriggerUtility.syncedAddresses = true;
            if(addressesToUpdate.size() > 0)
                update addressesToUpdate;
                
            if(mapOfContactToAddress.size() > 0)
            {
                insert mapOfContactToAddress.values();
                
            }
            //create neww addresses in place of addresses that cannot be updated due to relationships to other objects
            if(newAddrMap.size() > 0)
            {
                insert newAddrMap.values();
            }
            TriggerUtility.syncedAddresses = false;

            
            //iterate over the contact records either updating the address Ids with newly created address Ids or adding an associated error
            list<Contact_Address__c> contactAddresses = new list<Contact_Address__c>();
            for(Contact a :  newMap.values())
            {
                if(newAddrMap.containsKey(a.Id))
                {
                    contactAddresses.add(new Contact_Address__c(Contact__c          = a.Id
                                                               ,Address__c          = newAddrMap.get(a.Id).Id
                                                               ,Active__c           = true
                                                               //,Physical__c       = true
                                                               ,Primary_Mail_To__c  = true
                                                               ,Mail_To__c          = true) );
                    a.Primary_Mailing_Address__c = newAddrMap.get(a.Id).Id;
                }
                else if(! existingContactAddressMap.containsKey(a.Primary_Mailing_Address__c))
                {
                    contactAddresses.add(new Contact_Address__c(Contact__c          = a.Id
                                                               ,Address__c          = a.Primary_Mailing_Address__c
                                                               ,Active__c           = true
                                                               //,Physical__c       = true
                                                               ,Primary_Mail_To__c  = true
                                                               ,Mail_To__c          = true) );
                }
                else
                {
                    
                
                    if(addressActions.get(a.Primary_Mailing_Address__c) != AddressTriggerHandler.PROCEED_WITH_UPDATE)
                    {
                        if(mapOfContactToAddress.containsKey(a.Id))
                        {
                            a.Primary_Mailing_Address__c = mapOfContactToAddress.get(a.Id).Id;
                            ContactAddresses.add(new Contact_Address__c(Contact__c          = a.Id
                                                                       ,Address__c          = a.Primary_Mailing_Address__c
                                                                       ,Active__c           = true
                                                                       //,Physical__c       = true
                                                                       ,Primary_Mail_To__c  = true
                                                                       ,Mail_To__c          = true) );
                        }
                    }
                }
                
                if(a.Physical_Address__c == a.Primary_Mailing_Address__c)
                {
                    a.OtherCity         = a.MailingCity;
                    a.OtherCountryCode      = a.MailingCountryCode;
                    a.OtherStateCode        = a.MailingStateCode;
                    a.OtherPostalCode   = a.MailingPostalCode;
                    a.OtherStreet       = a.MailingStreet;
                    
                }
                
                    
            }
            TriggerUtility.limitContactExecution = true;
            if(contactAddresses.size() > 0)
                insert contactAddresses;
        }
        
    }

    private static void allOrNoneContactAddresses(List<Contact> contacts){
      for(Contact c : contacts){
        AddressHelper.allOrNoneStandardAddress(c, 'Mailing','Primary_Mailing_Address__c', true);
        AddressHelper.allOrNoneStandardAddress(c, 'Other', 'Physical_Address__c', true);
      }
    }
}