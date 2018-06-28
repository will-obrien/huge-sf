public without sharing class AssetAddressDetail {
    
    public Address__c address{get;set;}
    public Address__c originalAaddress{get;set;}
    public Asset assetAddress{get;set;}
    public string returnUrl{get;set;}
    public boolean addressSelected{get;set;}
    public class AssetAddressWrapper
    {
        public boolean selected{get;set;}
        public Asset assetAddress{get;set;}
        
        public AssetAddressWrapper(boolean sel, Asset aa)
        {
            selected = sel;
            assetAddress = aa;
        }
    }
    
    public list<AssetAddressWrapper> assetAddresses{get;set;}
    
    public AssetAddressDetail(ApexPages.StandardController ctl)
    {
        address = new Address__c();
        originalAaddress = new Address__c();
        returnUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        assetAddress = [Select  Id
                              , Name
                              , Product2.Name
                              , Asset_Address__c 
                           from Asset 
                          where Id = :ctl.getId()];
        
        //
        //Edit
        //
        if(assetAddress.Asset_Address__c !=null)
        {
            addressSelected = false;
            assetAddresses =  new list<AssetAddressWrapper>();
            for(Asset aa : [ Select Id
                                  , Name
                                  , Asset_Address__c
                                  , Asset_Address__r.Address_Line_1__c
                                  , Asset_Address__r.Address_Line_2__c
                                  , Asset_Address__r.Address_Line_3__c
                                  , Asset_Address__r.Address_Line_4__c
                                  , Asset_Address__r.City__c
                                  , Asset_Address__r.Country__c
                                  , Asset_Address__r.State_Province__c
                                  , Asset_Address__r.Postal_Code__c
                                  , Asset_Address__r.Name
                                  , Asset_Address__r.OwnerId
                                  , Asset_Address__r.Address_Name__c
                                  , Asset_Address__r.Id
                                  , Asset_Address__r.DCW_ID__c
                                  , Asset_Address__r.Warehouse_Id__c
                                  , Asset_Address__r.IE_ID__c
                                  , Asset_Address__r.State_Province_ISO_Code__c
                                  , Asset_Address__r.Country_ISO_Code__c
                                  , Asset_Address__r.LastModifiedBy.Name
                                  , Asset_Address__r.LastModifiedDate
                             from Asset
                            where Id = :ctl.getId()])
            {
                assetAddress = aa;
                address = aa.Asset_Address__r;
                originalAaddress = new Address__c(  Address_Line_1__c = aa.Asset_Address__r.Address_Line_1__c
                                                  , Address_Line_2__c = aa.Asset_Address__r.Address_Line_2__c
                                                  , Address_Line_3__c = aa.Asset_Address__r.Address_Line_3__c
                                                  , Address_Line_4__c = aa.Asset_Address__r.Address_Line_4__c
                                                  , City__c             = aa.Asset_Address__r.City__c
                                                  , Country__c          =  aa.Asset_Address__r.Country__c
                                                  , State_Province__c   = aa.Asset_Address__r.State_Province__c
                                                  , Postal_Code__c      = aa.Asset_Address__r.Postal_Code__c
                                                  , Address_Name__c     = aa.Asset_Address__r.Address_Name__c
                                                  , IE_ID__c            = aa.Asset_Address__r.IE_ID__c
                                                  , State_Province_ISO_Code__c = aa.Asset_Address__r.State_Province_ISO_Code__c
                                                  , Country_ISO_Code__c = aa.Asset_Address__r.Country_ISO_Code__c
                                                  , Id                  = aa.Asset_Address__r.Id
                                                  , DCW_ID__c           = aa.Asset_Address__r.DCW_ID__c);
            }
             //Asset Addresses
             //All Other Assets related to the Address that’s being edited. 
             for(Asset ca : [Select Id
                                  , a.SerialNumber
                                  , a.SO_Number__c
                                  , a.Product2.ProductCode
                                  , a.Product2Id
                                  , a.Job_Name__c
                                  , Asset_Address__r.Address_Line_1__c 
                                  , Asset_Address__r.City__c 
                                  , Asset_Address__r.Country__c 
                                  , Name
                               from Asset a
                              where Asset_Address__c = :address.Id
                               and Id != :ctl.getId()]) 
             {
                assetAddresses.add(new AssetAddressWrapper(false, ca));
             }      
        }
        else
        {
            //
            //NEW
            //
            addressSelected = false;
            string assetId = ApexPages.currentPage().getParameters().get('Id');//use a custom setting - Asset Id
            
        }
        
    }
    
    public PageReference selectAddress()
    {
        if(assetAddress.Asset_Address__c != null)
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
                       where Id = :assetAddress.Asset_Address__c];
                       
            addressSelected = true;
        }
        else
        {
            addressSelected = false;
            address = new Address__c();
        }
        
        return null;
    }
    
    public PageReference save()
    {
        
        map<Id, Address__c> oldMap = new map<Id, Address__c>{originalAaddress.Id => originalAaddress};
        map<Id, Address__c> newMap = new map<Id, Address__c>{address.Id => address};
        set<Id> junctionExclusions = new set<Id>();
                
        try{
            if(originalAaddress.Id != null)
            {
                //(addressSelected == false && originalAaddress.Id == null) ||
                for(AssetAddressWrapper c : assetAddresses)
                {
                    if(c.selected)
                    {
                        junctionExclusions.add(c.assetAddress.Id);
                    }
                }
                
                //either insert or update the address based on rules defined in the validateAddressCanUpdate method
                string addressJunctionBehavior = AddressTriggerHandler.validateAddressCanUpdate(newMap, oldMap, junctionExclusions).get(address.Id);
                if(addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_INSERT_JUNCTION
                  || addressJunctionBehavior == AddressTriggerHandler.CREATE_ADDRESS_AND_UPDATE_JUNCTION )
                {
                    Address__c insAddr = address.clone();
                    insAddr.Warehouse_Id__c=null;
                    insert insAddr;
                    address = insAddr;
                }
                else
                {
                    update address;
                }
                
                //set the address Id. it may already exist in this form but may have changed by creating a new address
                assetAddress.Asset_Address__c = address.Id;
                //update the asset address record
                update assetAddress;
                
                
                //update the selected asset addresses
                list<Asset> assetAddr = new list<Asset>();  
                for(AssetAddressWrapper c : assetAddresses)
                {
                    if(c.selected)
                    {
                        c.assetAddress.Asset_Address__c = assetAddress.Asset_Address__c;
                        assetAddr.add(c.assetAddress);
                    }
                }
                if(assetAddr.size() > 0)
                    update assetAddr;
            }
            else
            {
                //if the user created a new address instead of selecting one, insert the new address
                if(addressSelected == false)
                {
                    insert address;
                }
                
                //populate the assetAddress lookup to the address record either selected or created by the user
                assetAddress.Asset_Address__c = address.Id;
                update assetAddress;
            }
                
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,''+newMap + oldMap + junctionExclusions));
            ApexPages.addMessages(e);
            return null;
        }
        
        return new PageReference('/'+assetAddress.Id);
    }

}