public without sharing class AddressHelper {

    public class AddressException extends Exception{} 
    
    public static void saveAccountAddress( list<AccountAddressDetail.ContactAddressWrapper> contactAddresses
                                                    , list<AccountAddressDetail.AssetAddressWrapper> assetAddresses
                                                     , Address__c originalAaddress
                                                     , Address__c address
                                                     , Account_Address__c accountAddress
                                                     , boolean addressSelected
                                                     )
    {   
        if(addressSelected == false && address.Address_Line_1__c == null && address.Address_Line_2__c == null && 
            address.Address_Line_3__c == null && address.Address_Line_4__c == null && address.City__c == null && address.Country__c == null && 
            address.State_Province__c == null && address.Postal_Code__c == null)
                return;
        if(accountAddress.Active__c == true && accountAddress.Primary_Ship_To__c != true && accountAddress.Physical__c != true && accountAddress.Bill_To__c != true 
           && accountAddress.Primary_Bill_To__c != true && accountAddress.Ship_To__c != true && accountAddress.Mail_To__c != true && accountAddress.Primary_Mail_To__c != true)
        {
            String error = 'Please check the type of account address when checking Active.';
            accountAddress.addError(error);
            throw new AddressException(error);
            return;
        }

        if(originalAaddress.Id != null)
        {
            //(addressSelected == false && originalAaddress.Id == null) ||
            map<Id, Address__c> oldMap = new map<Id, Address__c>{originalAaddress.Id => originalAaddress};
            map<Id, Address__c> newMap = new map<Id, Address__c>{address.Id => address};
            set<Id> junctionExclusions = new set<Id>();
        
        
        
            //collect the Ids of the selected junction objects for decisioning whether to create a new address record or update the existing one.
            for(AccountAddressDetail.ContactAddressWrapper c : contactAddresses)
            {
                if(c.selected)
                {
                    junctionExclusions.add(c.contactAddress.Id);
                }
            }
            
            for(AccountAddressDetail.AssetAddressWrapper c : assetAddresses)
            {
                if(c.selected)
                {
                    junctionExclusions.add(c.assetAddress.Id);
                }
            }
            
            //either insert or update the address based on rules defined in the validateAddressCanUpdate method
            Boolean addressCloned = false;
            
            string addressJunctionBehavior = AddressTriggerHandler.validateAddressCanUpdate(newMap, oldMap, junctionExclusions).get(address.Id);
            if(addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_INSERT_JUNCTION
              || addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_UPDATE_JUNCTION )
            {
                Address__c insAddr = address.clone();
                insAddr.Id = null;
                insAddr.DCW_ID__c = null;
                insAddr.Warehouse_Id__c = null;
                
                 //stop the trigger from firing
                Database.insert(insAddr);
                address = insAddr;
            }
            else if(addressJunctionBehavior == AddressTriggerHandler.PROCEED_WITH_UPDATE
                    || addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_UPDATE_JUNCTION
                    || addressJunctionBehavior == null)
            {
                Database.update(address);
            }
            
            
            //set the address Id. it may already exist in this form but may have changed by creating a new address
            if(addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_INSERT_JUNCTION)
            {
                Account_address__c aa = accountAddress.clone();
                aa.Address__c = address.Id;
                Database.insert(aa);
            }
            else
            {
                //update the account address record
                accountAddressFlagsValidation(accountAddress);
                accountAddress.Address__c = address.Id;
                Database.update(accountAddress);
            }
            
            //update the selected contact addresses
            list<Contact_Address__c> contactAddrToUpdate = new list<Contact_Address__c>();
            list<Contact_Address__c> contactAddrToInsert = new list<Contact_Address__c>();
            for(AccountAddressDetail.ContactAddressWrapper c : contactAddresses)
            {
                if(c.selected)
                {
                    if(addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_INSERT_JUNCTION)
                    {
                        Contact_Address__c ca = c.contactAddress.clone();
                        ca.Address__c = accountAddress.Address__c;
                        contactAddrToInsert.add(ca);
                    }
                    else
                    {
                        c.contactAddress.Address__c = accountAddress.Address__c;
                        contactAddrToUpdate.add(c.contactAddress);
                    }
                    
                }
            }
            if(contactAddrToUpdate.size() > 0)
                Database.update(contactAddrToUpdate);
                
            if(contactAddrToInsert.size() > 0)
                Database.insert(contactAddrToInsert);
            
            //update the selected assets' addresses
            list<Asset> assetAddrToUpdate = new list<Asset>();  
            for(AccountAddressDetail.AssetAddressWrapper c : assetAddresses)
            {
                if(c.selected)
                {
                    c.assetAddress.Asset_Address__c = accountAddress.Address__c;
                    assetAddrToUpdate.add(c.assetAddress);
                }
            }
            if(assetAddrToUpdate.size() > 0)
                Database.update(assetAddrToUpdate);
        }
        else
        {
            //if the user created a new address instead of selecting one, insert the new address
            if(addressSelected == false && address.Id == null)
            {
                Database.insert(address);
            }
            else if(address.Id != null)
            {
                Database.update(address);
            }
            
            //populate the accountAddress lookup to the address record either selected or created by the user
            accountAddress.Address__c = address.Id;
            Database.insert(accountAddress);
        }
    }
    
    public static void saveContactAddress(list<ContactAddressDetail.ContactAddressWrapper> contactAddresses
		                                         , list<ContactAddressDetail.AccountAddressWrapper> AccountAddresses
		                                         , Address__c originalAaddress
		                                         , Address__c address
		                                         , Contact_Address__c contactAddress
		                                         , boolean addressSelected)
    {      
        if(addressSelected == false && address.Address_Line_1__c == null && address.Address_Line_2__c == null && 
            address.Address_Line_3__c == null && address.Address_Line_4__c == null && address.City__c == null && address.Country__c == null && 
            address.State_Province__c == null && address.Postal_Code__c == null)
                return;
        contactAddress.Contact_Address_ID__c = contactAddress.Contact__c+'-'+contactAddress.Address__c;
		if(contactAddress.Active__c == true  && contactAddress.Physical__c != true && contactAddress.Mail_To__c != true && contactAddress.Primary_Mail_To__c != true)
		{
            String error = 'Please check the type of Contact address when checking Active.';
			contactAddress.addError(error);
            throw new AddressException(error);
			return;
		}
        
        if(originalAaddress.Id != null)
        {
            //(addressSelected == false && originalAaddress.Id == null) ||
            map<Id, Address__c> oldMap = new map<Id, Address__c>{originalAaddress.Id => originalAaddress};
            map<Id, Address__c> newMap = new map<Id, Address__c>{address.Id => address};
            set<Id> junctionExclusions = new set<Id>();
            
            //collect the Ids of the selected junction objects for decisioning whether to create a new address record or update the existing one.
            for(ContactAddressDetail.ContactAddressWrapper c : contactAddresses)
            {
                if(c.selected)
                {
                    junctionExclusions.add(c.contactAddress.Id);
                }
            }
            
            for(ContactAddressDetail.AccountAddressWrapper c : AccountAddresses)
            {
                if(c.selected)
                {
                    junctionExclusions.add(c.AccountAddress.Id);
                }
            }
            
            //either insert or update the address based on rules defined in the validateAddressCanUpdate method
            string addressJunctionBehavior = AddressTriggerHandler.validateAddressCanUpdate(newMap, oldMap, junctionExclusions).get(address.Id);
            if(addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_INSERT_JUNCTION
              || addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_UPDATE_JUNCTION )
            {
                Address__c insAddr = address.clone();
                insAddr.DCW_ID__c = null;
                insAddr.Warehouse_Id__c = null;
                TriggerUtility.limitIntegrationBatch = true; //stop the trigger from firing
                insert insAddr;
                TriggerUtility.limitIntegrationBatch = false; //turn it back on
                address = insAddr;
            }
            else if(addressJunctionBehavior == AddressTriggerHandler.PROCEED_WITH_UPDATE
                || addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_UPDATE_JUNCTION
                || addressJunctionBehavior == null )
            {
                update address;
            }
            
            //set the address Id. it may already exist in this form but may have changed by creating a new address
            if(addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_INSERT_JUNCTION)
            {
                Contact_Address__c ca = contactAddress.clone();
                ca.Address__c = address.Id;
                insert ca;
            }
            else
            {
                //update the contact address record
                contactAddressFlagsValidation(contactAddress);
                contactAddress.Address__c = address.Id;
                update contactAddress;
            }
            
            //update the selected contact addresses
            list<Contact_Address__c> contactAddrToUpdate = new list<Contact_Address__c>();
            list<Contact_Address__c> contactAddrToInsert = new list<Contact_Address__c>();
            for(ContactAddressDetail.ContactAddressWrapper c : contactAddresses)
            {
                if(c.selected)
                {
                    if(addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_INSERT_JUNCTION)
                    {
                        Contact_Address__c ca = c.contactAddress.clone();
                        ca.Address__c = contactAddress.Address__c;
                        contactAddrToInsert.add(ca);
                    }
                    else
                    {
                        c.contactAddress.Address__c = contactAddress.Address__c;
                        contactAddrToUpdate.add(c.contactAddress);
                    }
                }
            }
            
            if(contactAddrToUpdate.size() > 0)
                update contactAddrToUpdate;
                
            if(contactAddrToInsert.size() > 0)
                insert contactAddrToInsert;
            
            //update the selected Account addresses
            list<Account_Address__c> AccountAddrToUpdate = new list<Account_Address__c>();  
            list<Account_Address__c> AccountAddrToInsert = new list<Account_Address__c>();  
            for(ContactAddressDetail.AccountAddressWrapper c : AccountAddresses)
            {
                if(c.selected)
                {
                    if(addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_INSERT_JUNCTION)
                    {
                        Account_Address__c aa = c.accountAddress.clone();
                        aa.Address__c = contactAddress.Address__c;
                        AccountAddrToInsert.add(aa);
                    }
                    else
                    {
                        c.AccountAddress.Address__c = contactAddress.Address__c;
                        AccountAddrToUpdate.add(c.AccountAddress);
                    }
                }
            }
            
            if(AccountAddrToUpdate.size() > 0)
                update AccountAddrToUpdate;
            
            if(AccountAddrToInsert.size() > 0)
                insert AccountAddrToInsert;
        }
        else
        {
            //if the user created a new address instead of selecting one, insert the new address
            if(addressSelected == false)
            {
                insert address;
            }
            
            //populate the contactAddress lookup to the address record either selected or created by the user
            contactAddress.Address__c = address.Id;
            insert contactAddress;
        }
    }

    public static void accountAddressFlagsValidation(Account_Address__c acctAddr){
        Boolean hasPrimaryMail=false, hasPrimaryShip=false, hasPrimaryBill=false, hasPhysical=false;
        Account_Address__c oldAA;

        if(acctAddr.Id==null || !acctAddr.Active__c || acctAddr.Account__c==null){ //Evaluate only on update and if it is active
            return;
        }

        for(Account_Address__c aa : [SELECT Id, Primary_Mail_To__c, Primary_Bill_To__c, Primary_Ship_To__c, Physical__c, Active__c 
                                        from Account_Address__c 
                                        where Account__c=:acctAddr.Account__c OR Id=:acctAddr.Id]){
            if(aa.Id==acctAddr.Id){
                oldAA=aa;
            } else if(aa.Active__c){
                hasPhysical |= aa.Physical__c;
                hasPrimaryBill |=aa.Primary_Bill_To__c;
                hasPrimaryShip |=aa.Primary_Ship_To__c;
                hasPrimaryMail |=aa.Primary_Mail_To__c;
            }
        }

        if(oldAA!=null){
            String error='';
            if(!acctAddr.Physical__c && !hasPhysical && (oldAA.Physical__c || !oldAA.Active__c)){
                error+='Cannot uncheck the Physical address because there are no other active, Physical addresses for this account.'+'\n';
            }
            if(!acctAddr.Primary_Bill_To__c && !hasPrimaryBill && (oldAA.Primary_Bill_To__c || !oldAA.Active__c)){
                error+='Cannot uncheck the Primary Bill To address because there are no other active, Primary Bill To addresses for this account.'+'\n';
            }
            if(!acctAddr.Primary_Mail_To__c && !hasPrimaryMail && (oldAA.Primary_Mail_To__c || !oldAA.Active__c)){
                error+='Cannot uncheck the Primary Mail To address because there are no other active, Primary Mail To addresses for this account.'+'\n';
            }
            if(!acctAddr.Primary_Ship_To__c && !hasPrimaryShip && (oldAA.Primary_Ship_To__c || !oldAA.Active__c)){
                error+='Cannot uncheck the Primary Ship To address because there are no other active, Primary Ship To addresses for this account.'+'\n';
            }

            if(!String.isBlank(error)){
                throw new AddressException(error);
            }
        }
    }

    public static void contactAddressFlagsValidation(Contact_Address__c ctcAddr){
        Contact_Address__c oldCA;

        if(ctcAddr.Id==null || !ctcAddr.Active__c || ctcAddr.Contact__c==null || ctcAddr.Primary_Mail_To__c){ //Evaluate only on update and if it is active and if primary mail to is not selected
            return;
        }

        for(Contact_Address__c ca : [SELECT Id, Primary_Mail_To__c, Active__c 
                                        from Contact_Address__c 
                                        where (Contact__c=:ctcAddr.Contact__c
                                                and Active__c=true
                                                and Primary_Mail_To__c = true) 
                                        OR Id=:ctcAddr.Id]){
            if(ca.Id==ctcAddr.Id){
                oldCA=ca;
            } else{
               return;
            }
        }

        if(oldCA!=null && !ctcAddr.Primary_Mail_To__c && (oldCA.Primary_Mail_To__c || !oldCA.Active__c)){
            throw new AddressException('Cannot uncheck the Primary Mail To address because there are no other active, Primary Mail To addresses for this contact.');
        }
    }

    public static void allOrNoneStandardAddress(SObject obj, String prefix, String lookupName, Boolean isoCodes){
        if( obj.get(lookupName)== null){
            if(String.isBlank((String) obj.get(prefix+'Street')) || String.isBlank((String) obj.get(prefix+'City')) || String.isBlank((String) obj.get(prefix+'CountryCode'))){
                obj.put(prefix+'Street',null);
                obj.put(prefix+'City',null);
                obj.put(prefix+'PostalCode',null);
                obj.put(prefix+'CountryCode',null);
                obj.put(prefix+'StateCode',null);
                
                obj.put(prefix+'State',null);
                obj.put(prefix+'Country',null);
            }
        }
    }

    public static Boolean equalAddresses(Address__c addr1, Address__c addr2, Boolean compareIsoCodes){
        
        Boolean result;
        if(addr1==null || addr2==null ){
            result=addr1 == addr2;
        }else{
            result= (addr1.Address_Line_1__c == null ? ' ' : addr1.Address_Line_1__c).trim()         == (addr2.Address_Line_1__c  == null ? ' ' : addr2.Address_Line_1__c).trim() 
            && (addr1.Address_Line_2__c == null ? ' ' : addr1.Address_Line_2__c).trim()     == (addr2.Address_Line_2__c  == null ? ' ' : addr2.Address_Line_2__c).trim() 
            && (addr1.Address_Line_3__c == null ? ' ' : addr1.Address_Line_3__c).trim()     == (addr2.Address_Line_3__c  == null ? ' ' : addr2.Address_Line_3__c).trim() 
            && (addr1.Address_Line_4__c == null ? ' ' : addr1.Address_Line_4__c).trim()     == (addr2.Address_Line_4__c  == null ? ' ' : addr2.Address_Line_4__c).trim() 
            && (addr1.City__c  == null ? ' ' : addr1.City__c).trim()                        == (addr2.City__c  == null ? ' ' : addr2.City__c).trim()
            && (addr1.Postal_Code__c  == null ? ' ' : addr1.Postal_Code__c).trim()          == (addr2.Postal_Code__c  == null ? ' ' : addr2.Postal_Code__c).trim()
            && (addr1.State_Province__c  == null ? ' ' : addr1.State_Province__c).trim()    == (addr2.State_Province__c  == null ? ' ' : addr2.State_Province__c).trim()
            && (addr1.Country__c  == null ? ' ' : addr1.Country__c).trim()                  == (addr2.Country__c  == null ? ' ' : addr2.Country__c).trim() ;

            if(compareIsoCodes){
                result &=
                    (addr1.Country_ISO_Code__c  == null ? ' ' : addr1.Country_ISO_Code__c).trim()     == (addr2.Country_ISO_Code__c  == null ? ' ' : addr2.Country_ISO_Code__c).trim()
                    && (addr1.State_Province_ISO_Code__c  == null ? ' ' : addr1.State_Province_ISO_Code__c).trim()   == (addr2.State_Province_ISO_Code__c  == null ? ' ' : addr2.State_Province_ISO_Code__c).trim();  
            }
        } 

        return result;
    }

    public static Boolean equalStandardAddress(sObject addr1, sObject addr2, String fieldPrefix){
        return equalAddresses(
            standardAddressToAddressObject( (String) addr1.get(fieldPrefix+'Street'), 
                                            (String) addr1.get(fieldPrefix+'CountryCode'),
                                            (String) addr1.get(fieldPrefix+'City'),
                                            (String) addr1.get(fieldPrefix+'PostalCode'),
                                            (String) addr1.get(fieldPrefix+'StateCode')),
            standardAddressToAddressObject( (String) addr2.get(fieldPrefix+'Street'), 
                                            (String) addr2.get(fieldPrefix+'CountryCode'),
                                            (String) addr2.get(fieldPrefix+'City'),
                                            (String) addr2.get(fieldPrefix+'PostalCode'),
                                            (String) addr2.get(fieldPrefix+'StateCode')),
            false
            );
    }

    public static Address__c standardAddressToAddressObject(String street, String country, String city, String zip, String state){
        String[] streetLines = street==null ? new List<String>() : street.split('\n');
        return new Address__c(Address_Line_1__c  = streetLines.size() > 0 ? streetLines[0] : null
                               , Address_Line_2__c  = streetLines.size() > 1 ? streetLines[1] : null
                               , Address_Line_3__c  = streetLines.size() > 2 ? streetLines[2] : null
                               , Address_Line_4__c  = streetLines.size() > 3 ? streetLines[3] : null
                               , City__c            = city
                               , Country__c         = country
                               , State_Province__c  = state
                               , Postal_Code__c     = zip
                            );
    }

    public static void populateStandardAddress(Address__c addr, SObject objToUpdate, String fieldPrefix){
        objToUpdate.put( fieldPrefix + 'Street', addr.Address_Line_1__c
                                                +(addr.Address_Line_2__c==null?'':'\n'+ addr.Address_Line_2__c)
                                                +(addr.Address_Line_3__c==null?'':'\n'+ addr.Address_Line_3__c)
                                                +(addr.Address_Line_4__c==null?'':'\n'+ addr.Address_Line_4__c));
        objToUpdate.put( fieldPrefix + 'City',  addr.City__c);
        objToUpdate.put( fieldPrefix + 'Country', addr.Country__c);
        objToUpdate.put( fieldPrefix + 'State', addr.State_Province__c);
        objToUpdate.put( fieldPrefix + 'PostalCode', addr.Postal_Code__c);
    }

}