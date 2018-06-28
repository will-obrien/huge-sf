@RestResource(urlMapping='/IEOrganizationService/*')
global without sharing class IE_OrganizationService {
 
    @HttpPost
    global Static IE_IntegrationObjects.IE_OrganizationListResponse doPost(list<IE_IntegrationObjects.IE_Organization> Organizations)
    {
        //disable trigger functionality
        TriggerUtility.limitIeServiceIntegration = true;
        
        IE_IntegrationObjects.IE_OrganizationListResponse response = new IE_IntegrationObjects.IE_OrganizationListResponse();
        response.Organizations = Organizations;
        response.errors = new list<IE_IntegrationObjects.IE_Error>();
        
        System.Debug('::::Organizations::::'+Organizations);
        
        list<Account> accounts = new list<Account>();
        Integer x = 0;
        integer y = 0;
        map<Integer, Address__c> addressMap = new map<Integer, Address__c>();// map the addresses back to the accounts
        list<IE_IntegrationObjects.IE_Address> ieAddressList = new list<IE_IntegrationObjects.IE_Address>();
        IE_Service_Configuration__c serviceConfig = IE_Service_Configuration__c.getInstance();
        for(IE_IntegrationObjects.IE_Organization org : Organizations)
        {
            //create accounts to add to the list
            accounts.add(new Account(IE_ID__c           = org.IEId
                                    ,Name               = org.OrganizationName
                                    ,Phone              = org.PhoneNumber
                                    ,IE_Updated_Date__c = org.LastModifiedDate
                                    ,IE_Account__c      = true
                                    ,RecordTypeId       = serviceConfig.Account_RecordType__c));
            if(org.Address != null)
            {
                addressMap.put(x, new Address__c( Address_Line_1__c = org.Address.AddressLine1
                                                , Address_Line_2__c     = org.Address.AddressLine2
                                                , Address_Line_3__c     = org.Address.AddressLine3
                                                , Address_Line_4__c     = org.Address.AddressLine4
                                                , City__c               = org.Address.City
                                                , Country__c = TriggerUtility.getCountryFromIsoCode(org.Address.Country)
                                                , State_Province__c = TriggerUtility.getStateFromCountryStateIsoCode(org.Address.Country, org.Address.StateCode)
                                                , Country_ISO_Code__c   = org.Address.Country
                                                , State_Province_ISO_Code__c   = org.Address.StateCode
                                                , Postal_Code__c        = org.Address.ZipCode
                                                , IE_ID__c              = org.Address.IEId
                                                , IE_Updated_Date__c    = org.Address.LastModifiedDate
                                                , IE_Address__c         = true
                                                , RecordTypeId          = serviceConfig.Address_RecordType__c
                                                ));
                ieAddressList.add(org.Address);
            }
            x++;
        }
        
        if(accounts.size() > 0)
        {
            list<Database.UpsertResult> results = database.upsert(accounts, false);
            x = 0;
            for(Database.UpsertResult r : results)
            {
                Organizations[x].SFDCId = r.getId();
                if(!r.isSuccess())
                {
                    //r.getErrors()[0].getTypeName();
                    Organizations[x].errors = new list<IE_IntegrationObjects.IE_Error>(); 
                    for(Database.Error err : r.getErrors())
                    {
                        Organizations[x].errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.message));
                        response.errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.message));  
                        
                    }
                }
                x++;
            }
        }
        
        if(addressMap.size() > 0)
        {
            for(Integer i : addressMap.keySet())
            {
                if(Organizations[i].errors != null && Organizations[i].errors.size() > 0 && addressMap.containsKey(i))
                    addressMap.get(i).addError(Organizations[i].errors[0].ErrorMessage);
            }
            
        }
        
        //insert the new addresses 
        x = 0;
        if(addressMap.size() > 0)
        {
            list<Database.SaveResult> results = database.insert(addressMap.values(), false);
            for(Database.SaveResult r : results)
            {
                ieAddressList[x].SFDCId = r.getId();
                if(!r.isSuccess())
                {
                    ieAddressList[x].errors = new list<IE_IntegrationObjects.IE_Error>();
                    for(Database.Error err : r.getErrors())
                    {
                        ieAddressList[x].errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.message)); 
                        response.errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.message)); 
                        
                    }
                }
            }
            x++;
        }
        x = 0;
        list<Account_Address__c> accAddresses = new list<Account_Address__c>(); 
        for(Account a : accounts)
        {
            if(addressMap.containsKey(x) && addressMap.get(x).Id != null)
            {
                accAddresses.add(new Account_Address__c(Account__c = a.Id
                                                       ,Address__c = addressMap.get(x).Id
                                                       ,Mail_To__c = true
                                                       ,Primary_Mail_To__c = true));//default values?
            }
            x++;
        }
        
        //insert account address records
        if(accAddresses.size() > 0)
        {
            list<Database.SaveResult> results = database.insert(accAddresses, true);//not sure how to validate this so roll everything back when there is an error here
            /*for(Database.SaveResult r : results)
            {
                ieAddressList[x].SFDCId = r.getId();
                if(!r.isSuccess())
                {
                    ieAddressList[0].ErrorCode = 'SALESFORCE_DML_ERROR';//r.getErrors()[0].getTypeName();
                    ieAddressList[0].errors = new list<String>();
                    for(Database.Error err : r.getErrors())
                        ieAddressList[0].errors.add(err.message);  
                }
            }*/
        }
        
        //response.Organizations = ieOrgs;
        System.debug('::::RESPONSE:::::'+ response);
        return response;
    }
}