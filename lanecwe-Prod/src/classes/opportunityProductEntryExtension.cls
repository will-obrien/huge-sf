public with sharing class opportunityProductEntryExtension {
	public class CustomException extends Exception{}
    public Opportunity theOpp {get;set;}
    public String searchString {get;set;}
    public opportunityLineItem[] shoppingCart {get;set;}
    public priceBookEntry[] AvailableProducts {get;set;}
    public Pricebook2 theBook {get;set;}   
    
    public String toSelect {get; set;}
    public String rowIndex {get;set;}
    public Decimal Total {get;set;}
    
    public Boolean overLimit {get;set;}
    public Boolean error {get;set;}
    public Boolean multipleCurrencies {get; set;}
    public Boolean isCurrentUserAdmin {get;set;}
    private Boolean forcePricebookSelection = false;
    
    private opportunityLineItem[] forDeletion = new opportunityLineItem[]{};
	//public String query {get;set;}
    public opportunityProductEntryExtension(ApexPages.StandardController controller) {

        // Need to know if org has multiple currencies enabled
        multipleCurrencies = UserInfo.isMultiCurrencyOrganization();
        isCurrentUserAdmin = PGIAppConstants.ADMIN_PROFILES.contains(UserInfo.getProfileId());
	
        // Get information about the Opportunity being worked on
        if(multipleCurrencies)
            theOpp = database.query('select Id, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode from Opportunity where Id = \'' + controller.getRecord().Id + '\' limit 1');
        else
            theOpp = [select Id, Pricebook2Id, PriceBook2.Name from Opportunity where Id = :controller.getRecord().Id limit 1];
        
        // If products were previously selected need to put them in the "selected products" section to start with
        shoppingCart = [select Id, New_Quantity__c, Active_Host_NA_Only__c, Min_Commit__c, Existing_Service__c, New_Sales_Price__c, Unit_Type__c, Billing_Frequency__c, Contract_Term__c, TotalPrice, UnitPrice, Description, PriceBookEntryId, PriceBookEntry.Name, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id, Initial_Bill_Date__c, X100_Ramp_Date__c from opportunityLineItem where OpportunityId=:theOpp.Id order by PriceBookEntry.Product2.Name, Id];

        // Check if Opp has a pricebook associated yet
        if(theOpp.Pricebook2Id == null){
            Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }
        }
        else{
            theBook = theOpp.Pricebook2;
        }
        
        if(!forcePricebookSelection)
            updateAvailableList();
    }
    
    // this is the 'action' method on the page
    /*public PageReference priceBookCheck(){
        // if the user needs to select a pricebook before we proceed we send them to standard pricebook selection screen
        if(forcePricebookSelection){        
            return changePricebook();
        }
        else{
            //if there is only one active pricebook we go with it and save the opp
            if(theOpp.pricebook2Id != theBook.Id){
                try{
                    theOpp.Pricebook2Id = theBook.Id;
                    update(theOpp);
                }
                catch(Exception e){
                    ApexPages.addMessages(e);
                }
            }
            
            return null;
        }
    }*/
       
    public String getChosenCurrency(){
    
        if(multipleCurrencies)
            return (String)theOpp.get('CurrencyIsoCode');
        else
            return '';
    }

    public void updateAvailableList() {
    
        // We dynamically build a query string and exclude items already in the shopping cart
        String qString = 'select Id, Pricebook2Id, IsActive, Product2.Name, Product2.Family, Product2.IsActive, Product2.Description, UnitPrice from PricebookEntry where IsActive=true and Product2.Name != \'PGI Standard Product\' and Pricebook2Id = \'' + theBook.Id + '\'';
        if(multipleCurrencies)
            qstring += ' and CurrencyIsoCode = \'' + theOpp.get('currencyIsoCode') + '\'';
        
        // note that we are looking for the search string entered by the user in the name OR description
        // modify this to search other fields if desired
        if(searchString != null && searchString != ''){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\')';
        }
        
        // remove selected products from available list
        /*Set<Id> selectedEntries = new Set<Id>();
        for(opportunityLineItem d:shoppingCart){
            selectedEntries.add(d.PricebookEntryId);
        }
        
        if(selectedEntries.size()>0){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntries){
                tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            
            qString+= extraFilter;
        }*/
        
        Id currentProfileId = UserInfo.getProfileId();
        Boolean filterRegion = false; //include close bracket if region is filtered
        User currentUser = [SELECT Region__c, Channel__c FROM User WHERE Id =: UserInfo.getUserId()];
        if(!PGIAppConstants.ADMIN_PROFILES.contains(currentProfileId) && !PGIAppConstants.GCS_DIAMOND_PROFILES.contains(currentProfileId)){
        	if(currentUser.Region__c != null && currentUser.Region__c != '' && currentUser.Region__c != 'None'){
        		qString += ' and (Product2.Region__c = \'ALL\' or Product2.Region__c includes (\'' + currentUser.Region__c + '\')';
        		filterRegion = true;
        	}
        	if(currentUser.Channel__c != null && currentUser.Channel__c != '' && currentUser.Channel__c != 'None'){
        		if(currentUser.Channel__c.contains('GCS')){
        			qString += ' or Product2.Channel_to_Include__c = \'GCS\')';
        		}
        		else if (filterRegion){
        			qString += ')';
        		}
        		qString += ' and Product2.Channel_to_Exclude__c !=\'' + currentUser.Channel__c + '\'';
        	}
        	else if (filterRegion){
        		qString += ')';
        	}
        }
        
        qString+= ' order by Product2.Name';
        qString+= ' limit 101';
        
        error = false;
        
        try{        
	        AvailableProducts = database.query(qString);
	        //query = qString + '; size='+AvailableProducts.size();
	        	        
	        // We only display up to 100 results... if there are more than we let the user know (see vf page)
	        if(AvailableProducts.size()==101){
	            AvailableProducts.remove(100);
	            overLimit = true;
	        }
	        else{
	            overLimit=false;
	        }
        }
        catch(Exception ex){
        	error = true;
        }
    }
    
    public void addToShoppingCart(){
    
        // This function runs when a user hits "select" button next to a product
    
        for(PricebookEntry d : AvailableProducts){
            if((String)d.Id==toSelect){
                shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice));
                break;
            }
        }
        
        updateAvailableList();  
    }
    

    public PageReference removeFromShoppingCart(){
    
        // This function runs when a user hits "remove" on an item in the "Selected Products" section
 		Integer selectedRowIndex = Integer.valueOf(rowIndex);
 		OpportunityLineItem oli = shoppingCart[selectedRowIndex];
 		if(oli != null && oli.Id != null){
 			forDeletion.add(oli);
 		}
 		shoppingCart.remove(selectedRowIndex);
        updateAvailableList();
        
        return null;
    }
    
    public PageReference onSave(){
        
        // Validate required fields
        Boolean isError = false;
        for(opportunityLineItem d : shoppingCart){
                if(d.New_Quantity__c == null){
                d.New_Quantity__c.addError('You must enter a value');
                isError = true;
            }
            if(d.New_Sales_Price__c == null){
                d.New_Sales_Price__c.addError('You must enter a value');
                isError = true;
            }
            if(d.Unit_Type__c == null){
                d.Unit_Type__c.addError('You must enter a value');
                isError = true;
            }
            if(d.Billing_Frequency__c == null){
                d.Billing_Frequency__c.addError('You must enter a value');
                isError = true;
            }
            if(d.Contract_Term__c == null){
                d.Contract_Term__c.addError('You must enter a value');
                isError = true;
            }
        }
        
        if(isError)
                return null;
        
        // If previously selected products are now removed, we need to delete them
        try{
        if(forDeletion.size()>0)
            delete(forDeletion);
            forDeletion.clear();
	        // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
	        try{
	            if(shoppingCart.size()>0)
	                upsert(shoppingCart);
	        }
	        catch(Exception e){
	            ApexPages.addMessages(e);
	            return null;
	        }  
        }
         catch(Exception e){
       	    ApexPages.addMessages(e);
            return null;
        }
   
        // After save return the user to the Opportunity
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference onCancel(){
 
        // If user hits cancel we commit no changes and return them to the Opportunity   
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    /*public PageReference changePricebook(){
    
        // This simply returns a PageReference to the standard Pricebook selection screen
        // Note that is uses retURL parameter to make sure the user is sent back after they choose
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',theOpp.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + theOpp.Id);
        
        return ref;
    }*/
}