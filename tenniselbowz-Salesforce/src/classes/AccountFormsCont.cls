public with sharing class AccountFormsCont {
    public Account_Address__c accountAddress{
    	get{
    		if(accountAddress == null){
    			accountAddress = new Account_Address__c(Primary_Mail_To__c = true, Active__c = true, Physical__c = true);
    		}
    		return accountAddress;
    	}
    	set;
    }
    public Address__c originalAddress{
    	get{
    		if(originalAddress == null){
    			originalAddress = new Address__c();
    		}
    		return originalAddress;
    	}
    	set;
    }
    public Address__c address{
    	get{
    		if(address == null){
    			address = new Address__c();
    			addressSelected = false;
    		}
    		return address;
    	}
    	set;
    }
    public boolean addressSelected{get;set;}

    public boolean redirectPage{
    	get{
    		if(redirectPage == null) return false;
    		else return redirectPage;
    	}
    	set;
    }

    public Boolean recordSaved {
    	get{
    		return recordSaved == null? false : recordSaved;
    	} set;
    }

	public ApexPages.StandardController sc{
		get{
			return new ApexPages.StandardController(new Account());
		}
	}

    public Account mainAccount{
    	get;
    	set{
	    	if(value != null && value.Id != null){
	    		if(mainAccount != null && mainAccount.Id == value.Id ) return;
		    	mainAccount = Database.query('SELECT ' + String.escapeSingleQuotes(queryFields) + ' FROM Account WHERE Id = \''+value.Id+'\' LIMIT 1');
		    	loadAddressData(mainAccount.Id); 	
	    	} else if(value != null && value.Id == null){
	    		if(mainAccount == value) return;
	    		mainAccount = value;
	    		accountAddress = null;
	    		address = null;
	    	} else {
	    		mainAccount = value;
	    	}
    	}
    }

    // Pulls primary Account address and it's corresponding address object from database
    public void loadAddressData(Id accountId){
    	List<Account_Address__c> acctAddrs = [SELECT Id, Name, Account__c, Address__c, Active__c, Bill_To__c, Mail_To__c, Physical__c, Ship_To__c, 
										    	Primary_Bill_To__c, Primary_Mail_To__c, Primary_Ship_To__c, Address__r.Address_Line_1__c, Address__r.Address_Line_2__c, 
										    	Address__r.Address_Line_3__c, Address__r.Address_Line_4__c, Address__r.City__c, Address__r.Country__c, Address__r.State_Province__c, 
										    	Address__r.Postal_Code__c, Address__r.Name, Address__r.OwnerId, Address__r.Address_Name__c, Address__r.Id, 
										    	Address__r.DCW_ID__c, Address__r.Warehouse_Id__c, Address__r.IE_ID__c, Address__r.State_Province_ISO_Code__c, 
										    	Address__r.Country_ISO_Code__c, Address__r.LastModifiedBy.Name, Address__r.LastModifiedDate, LastModifiedBy.Name, LastModifiedDate
											 FROM Account_Address__c
											 WHERE Account__c = :accountId AND Primary_Mail_To__c = true];
		if(acctAddrs.size() == 1) accountAddress = acctAddrs[0];
		else {accountAddress = null; return;}
		address = accountAddress.Address__r;
		addressSelected = true;
		originalAddress = new Address__c(  Address_Line_1__c = accountAddress.Address__r.Address_Line_1__c
										  , Address_Line_2__c = accountAddress.Address__r.Address_Line_2__c
										  , Address_Line_3__c = accountAddress.Address__r.Address_Line_3__c
										  , Address_Line_4__c = accountAddress.Address__r.Address_Line_4__c
										  , City__c = accountAddress.Address__r.City__c
										  , Country__c =  accountAddress.Address__r.Country__c
										  , State_Province__c = accountAddress.Address__r.State_Province__c
										  , Postal_Code__c = accountAddress.Address__r.Postal_Code__c
										  , Address_Name__c = accountAddress.Address__r.Address_Name__c
									  	  , IE_ID__c = accountAddress.Address__r.IE_ID__c
									  	  , DCW_ID__c = accountAddress.Address__r.DCW_ID__c
									  	  , Warehouse_Id__c = accountAddress.Address__r.Warehouse_Id__c
										  , State_Province_ISO_Code__c = accountAddress.Address__r.State_Province_ISO_Code__c
										  , Country_ISO_Code__c = accountAddress.Address__r.Country_ISO_Code__c
										  , Id = accountAddress.Address__r.Id);


    }


    // Gets all fields used in the page for querying
    public String queryFields{
    	get{
    		if(queryFields == null){
    			// Fields not in fieldsets can be added here, separated by commas
    			queryFields = 'LA_Strategic_Account__c, Client_Profile__c, Client_Business_Objectives_Initiatives__c, Position_Strategy__c, Attack_Strategy__c';
    			List<Schema.FieldSetMember> allFieldSets = new List<Schema.FieldSetMember>();
    			allFieldSets.addAll(SObjectType.Account.FieldSets.Account_Information.getFields());
    			//allFieldSets.addAll(SObjectType.Account.FieldSets.Strategic_Account_Management.getFields());
    			allFieldSets.addAll(SObjectType.Account.FieldSets.Additional_Information.getFields());
    			allFieldSets.addAll(SObjectType.Account.FieldSets.Rep_Information_DCW.getFields());
    			allFieldSets.addAll(SObjectType.Account.FieldSets.System_Information.getFields());
    			for(Integer i = 0; i < allFieldSets.size(); i++){
    				if(!String.isEmpty(queryFields)) queryFields += ', ';
    				queryFields += allFieldSets[i].getFieldPath();
    			}
    		}
    		return queryFields;
    	}
    	set;
    }

    public PageReference selectAddress()
    {
        if(accountAddress.Address__c != null)
        {
        address = [select Address_Line_1__c
                    , Address_Line_2__c
                    , Address_Line_3__c
                    , Address_Line_4__c
                    , City__c
                    , Country__c
                    , State_Province__c
                    , Postal_Code__c
                    , Name
                    , OwnerId 
                    , Address_Name__c
                    , DCW_ID__c
                    , Warehouse_Id__c
                  , IE_ID__c
                  , State_Province_ISO_Code__c
                  , Country_ISO_Code__c
                    , LastModifiedBy.Name
                    , LastModifiedDate
                  from Address__c
                 where Id = :accountAddress.Address__c];
                 
          addressSelected = true;
          accountAddress.Active__c = true;
        }
        else
        {
          addressSelected = false;
          address = new Address__c();
        }
    
        return null;
      }

    public PageReference save() {
	    PageReference pg;
        Id prevAcctId = mainAccount.Id;
        Id prevAcctAddId = accountAddress.Id;
        Id prevAcctAddAcctId = accountAddress.Account__c;
        Id prevOrigAddId = originalAddress.Id;
        Id prevAddId = address.Id;
        Savepoint sp = Database.setSavepoint();
        
        try{ 
		    recordSaved = false;

            upsert mainAccount;
            
            if(addressSelected == false) originalAddress = null;
            if(accountAddress.Account__c == null) accountAddress.Account__c = mainAccount.Id;

            AddressHelper.saveAccountAddress(  new list<AccountAddressDetail.ContactAddressWrapper>()
                                               , new list<AccountAddressDetail.AssetAddressWrapper>()
                                               , originalAddress
                                               , address
                                               , accountAddress
                                               , addressSelected);

            pg= new ApexPages.StandardController(mainAccount).view();
            pg.setRedirect(true);
            recordSaved = true;
        }
        catch(Exception e)
        {
            System.Debug('ACCOUNT ADDRESS ERROR::::::::::>'+e);
            ApexPages.addMessages(e);
            Database.rollback(sp);
            mainAccount.Id = prevAcctId;
            accountAddress.Id = prevAcctAddId;
            accountAddress.Account__c = prevAcctAddAcctId;
            address.Id = prevAddId;
            originalAddress.Id = prevOrigAddId;
            pg = null;
        }
        
        return redirectPage? pg : null;
    }
    
    public PageReference saveAndNew() {
        PageReference pr =  Page.NewAccountPageWithAddress;
        pr.setRedirect(true);
        return save() == null ? null : pr;
    }
}