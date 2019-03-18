public with sharing class ContactFormsCont {
    public Contact_Address__c contactAddress{
    	get{
    		if(contactAddress == null){
    			contactAddress = new Contact_Address__c(Primary_Mail_To__c = true, Active__c = true);
    		}
    		return contactAddress;
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
    
    public boolean renderImmediately{get;private set;}

    public Boolean recordSaved {
    	get{
    		return recordSaved == null? false : recordSaved;
    	} set;
    }

	public ApexPages.StandardController sc{
		get{
			return new ApexPages.StandardController(new Contact());
		}
	}
	
	public Contact con{get;set;}
	public ContactFormsCont(ApexPages.StandardController sc){
	    con = new Contact();
	    
	    Map<String, String> parameters = ApexPages.currentPage().getParameters();
	    renderImmediately = parameters.containsKey('renderImmediately') && boolean.valueOf(parameters.get('renderImmediately'));
	}
	public ContactFormsCont(){
        con = new Contact();
    }

    public Contact mainContact{
    	get;
    	set{
	    	if(value != null && value.Id != null){
	    		if(mainContact != null && mainContact.Id == value.Id ) return;
                try{
    		    	mainContact = Database.query('SELECT ' + String.escapeSingleQuotes(queryFields) + ' FROM Contact WHERE Id = \''+value.Id+'\' LIMIT 1');
                } catch (QueryException e){return;}
		    	loadAddressData(mainContact.Id); 	
	    	} else if(value != null && value.Id == null){
                Boolean isChanged = mainContact != value;
	    		mainContact = value;
                if(isChanged){
                    contactAddress = null;
                    address = null;
                }
	    	} else {
	    		mainContact = value;
	    	}
        }
    }

    // Pulls primary contact address and it's corresponding address object from database
    public void loadAddressData(Id contactId){
    	List<Contact_Address__c> ctcAddrs = [SELECT Id, Name, Contact__c, Address__c, Active__c, Mail_To__c, Physical__c, Contact__r.AccountId, Primary_Mail_To__c, 
											    	Address__r.Address_Line_1__c, Address__r.Address_Line_2__c, Address__r.Address_Line_3__c, Address__r.Address_Line_4__c, 
											    	Address__r.City__c, Address__r.Country__c, Address__r.State_Province__c, Address__r.Postal_Code__c, Address__r.Name, 
											    	Address__r.OwnerId, Address__r.Address_Name__c, Address__r.Id, Address__r.DCW_ID__c, Address__r.Warehouse_Id__c, 
											    	Address__r.IE_ID__c, Address__r.State_Province_ISO_Code__c, Address__r.Country_ISO_Code__c, 
											    	Address__r.LastModifiedBy.Name, Address__r.LastModifiedDate, LastModifiedBy.Name, LastModifiedDate
											 FROM Contact_Address__c
											 WHERE Contact__c = :contactID AND Primary_Mail_To__c = true];
		if(ctcAddrs.size() == 1) contactAddress = ctcAddrs[0];
		else {contactAddress = null; return;}
		address = contactAddress.Address__r;
		addressSelected = true;
		originalAddress = new Address__c(  Address_Line_1__c = contactAddress.Address__r.Address_Line_1__c
										  , Address_Line_2__c = contactAddress.Address__r.Address_Line_2__c
										  , Address_Line_3__c = contactAddress.Address__r.Address_Line_3__c
										  , Address_Line_4__c = contactAddress.Address__r.Address_Line_4__c
										  , City__c = contactAddress.Address__r.City__c
										  , Country__c =  contactAddress.Address__r.Country__c
										  , State_Province__c = contactAddress.Address__r.State_Province__c
										  , Postal_Code__c = contactAddress.Address__r.Postal_Code__c
										  , Address_Name__c = contactAddress.Address__r.Address_Name__c
									  	  , IE_ID__c = contactAddress.Address__r.IE_ID__c
									  	  , DCW_ID__c = contactAddress.Address__r.DCW_ID__c
									  	  , Warehouse_Id__c = contactAddress.Address__r.Warehouse_Id__c
										  , State_Province_ISO_Code__c = contactAddress.Address__r.State_Province_ISO_Code__c
										  , Country_ISO_Code__c = contactAddress.Address__r.Country_ISO_Code__c
										  , Id = contactAddress.Address__r.Id
										  );


    }

    // Gets all fields used in the page for querying
    public String queryFields{
    	get{
    		if(queryFields == null){
    			queryFields = ''; // Fields not in fieldsets can be added here, separated by commas
    			List<Schema.FieldSetMember> allFieldSets = new List<Schema.FieldSetMember>();
    			allFieldSets.addAll(SObjectType.Contact.FieldSets.Contact_Information.getFields());
    			allFieldSets.addAll(SObjectType.Contact.FieldSets.Strategic_Account_Management.getFields());
    			allFieldSets.addAll(SObjectType.Contact.FieldSets.Additional_Information.getFields());
    			allFieldSets.addAll(SObjectType.Contact.FieldSets.DCW_Information.getFields());
    			allFieldSets.addAll(SObjectType.Contact.FieldSets.Intelligent_Equipment_User_Information.getFields());
    			allFieldSets.addAll(SObjectType.Contact.FieldSets.System_Information.getFields());
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
        if(contactAddress.Address__c != null)
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
                            , DCW_Id__c
                            , Warehouse_Id__c
                            , IE_ID__c
                            , State_Province_ISO_Code__c
                            , Country_ISO_Code__c
                            , LastModifiedBy.Name
                            , LastModifiedDate
                        from Address__c
                       where Id = :contactAddress.Address__c];
                       
            addressSelected = true;
            contactAddress.Active__c = true;
        }
        else
        {
            addressSelected = false;
            address = new Address__c();
            contactAddress = null;
        }
        
        return null;
    }
    
    public PageReference Save(){
	    PageReference pg;
        Id prevContId = mainContact.Id;
        Contact_Address__c prevContAdd = contactAddress.clone(true, true);
        Address__c prevOrigAdd = originalAddress.clone(true, true);
        Address__c prevAdd = address.clone(true, true);
        Savepoint sp = Database.setSavepoint();
        
        try{ 
		    recordSaved = false;

            upsert mainContact;

            if(addressSelected == false) originalAddress = null;
            if(contactAddress.Contact__c == null) contactAddress.Contact__c = mainContact.Id;

            AddressHelper.saveContactAddress(  new List<ContactAddressDetail.ContactAddressWrapper>()
                                               , new List<ContactAddressDetail.AccountAddressWrapper>()
                                               , originalAddress
                                               , address
                                               , contactAddress
                                               , addressSelected);

            pg= new ApexPages.StandardController(mainContact).view();
            pg.setRedirect(true);
            recordSaved = true;
        }
        catch(Exception e)
        {
            System.Debug('CONTACT ADDRESS ERROR::::::::::>'+e);
            ApexPages.addMessages(e);
            Database.rollback(sp);
            mainContact.Id = prevContId;
            contactAddress = prevContAdd;
            address = prevAdd;
            originalAddress = prevOrigAdd;
            pg = null;
        }
        
        return redirectPage? pg : null;
    }
    
    public PageReference saveAndNew() {
        PageReference pg =  Page.NewContactPageWithAddress;
        pg.setRedirect(true);
        return save() == null ? null : pg;
    }
}