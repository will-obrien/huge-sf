public with sharing class OpportunityAddressDetailController{
    public Address__c address{get;set;}
    public Address__c originalAaddress{get;set;}
    public Opportunity opportunityAddress{get;set;}
    public String returnUrl{get;set;}
    public Boolean addressSelected{get;set;}
    public class opportunityAddressWrapper
    {
        public Boolean selected{get;set;}
        public Opportunity opportunityAddress{get;set;}
        
        public opportunityAddressWrapper(boolean sel, opportunity oA)
        {
            selected = sel;
            opportunityAddress = oA;
        }
    }
    
    public list<opportunityAddressWrapper> opportunityAddresses{get;set;}
    
    public OpportunityAddressDetailController(ApexPages.StandardController controller) {
        address = new Address__c();
        originalAaddress = new Address__c();
        returnUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        opportunityAddress = [Select  Id
                              , Name
                              , Job_Address__c 
                           from Opportunity 
                          where Id = :controller.getId()];
        
        //
        //Edit
        //
        if(opportunityAddress.Job_Address__c !=null)
        {
            addressSelected = false;
            opportunityAddresses =  new list<opportunityAddressWrapper>();
            for(opportunity oA : [ Select Id
                                  , Name
                                  , Job_Address__c
                                  , Job_Address__r.Address_Line_1__c
                                  , Job_Address__r.Address_Line_2__c
                                  , Job_Address__r.Address_Line_3__c
                                  , Job_Address__r.Address_Line_4__c
                                  , Job_Address__r.City__c
                                  , Job_Address__r.Country__c
                                  , Job_Address__r.State_Province__c
                                  , Job_Address__r.Postal_Code__c
                                  , Job_Address__r.Name
                                  , Job_Address__r.OwnerId
                                  , Job_Address__r.Address_Name__c
                                  , Job_Address__r.Id
                                  , Job_Address__r.DCW_ID__c
                                  , Job_Address__r.Warehouse_Id__c
                                  , Job_Address__r.IE_ID__c
                                  , Job_Address__r.State_Province_ISO_Code__c
                                  , Job_Address__r.Country_ISO_Code__c
                                  , Job_Address__r.LastModifiedBy.Name
                                  , Job_Address__r.LastModifiedDate
                             from Opportunity
                            where Id = :controller.getId()])
            {
                opportunityAddress = oA;
                address = oA.Job_Address__r;
                originalAaddress = new Address__c(  Address_Line_1__c = oA.Job_Address__r.Address_Line_1__c
                                                  , Address_Line_2__c = oA.Job_Address__r.Address_Line_2__c
                                                  , Address_Line_3__c = oA.Job_Address__r.Address_Line_3__c
                                                  , Address_Line_4__c = oA.Job_Address__r.Address_Line_4__c
                                                  , City__c             = oA.Job_Address__r.City__c
                                                  , Country__c          =  oA.Job_Address__r.Country__c
                                                  , State_Province__c   = oA.Job_Address__r.State_Province__c
                                                  , Postal_Code__c      = oA.Job_Address__r.Postal_Code__c
                                                  , Address_Name__c     = oA.Job_Address__r.Address_Name__c
                                                  , IE_ID__c            = oA.Job_Address__r.IE_ID__c
                                                  , State_Province_ISO_Code__c = oA.Job_Address__r.State_Province_ISO_Code__c
                                                  , Country_ISO_Code__c = oA.Job_Address__r.Country_ISO_Code__c
                                                  , Id                  = oA.Job_Address__r.Id
                                                  , DCW_ID__c           = oA.Job_Address__r.DCW_ID__c);
            }
             //opportunity Addresses
             //All Other opportunities related to the Address that’s being edited. 
             for(opportunity rO : [Select Id
                                  , Job_Address__r.Address_Line_1__c 
                                  , Job_Address__r.City__c 
                                  , Job_Address__r.Country__c 
                                  , Name
                                  , OwnerId
                                  
                                  , StageName
                               from Opportunity
                              where Job_Address__c = :address.Id
                               and Id != :controller.getId()]) 
             {
                opportunityAddresses.add(new opportunityAddressWrapper(false, rO));
             }      
        }
        else
        {
            //
            //NEW
            //
            addressSelected = false;
            string opportunityId = ApexPages.currentPage().getParameters().get('Id');//use a custom setting - opportunity Id
            
        }
        
    }
    
    public PageReference selectAddress()
    {
        if(opportunityAddress.Job_Address__c != null)
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
                       where Id = :opportunityAddress.Job_Address__c];
                       
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
                for(opportunityAddressWrapper c : opportunityAddresses)
                {
                    if(c.selected)
                    {
                        junctionExclusions.add(c.opportunityAddress.Id);
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
                opportunityAddress.Job_Address__c = address.Id;
                //update the opportunity address record
                update opportunityAddress;
                
                
                //update the selected opportunity addresses
                list<opportunity> opportunityAddr = new list<opportunity>();  
                for(opportunityAddressWrapper c : opportunityAddresses)
                {
                    if(c.selected)
                    {
                        c.opportunityAddress.Job_Address__c = opportunityAddress.Job_Address__c;
                        opportunityAddr.add(c.opportunityAddress);
                    }
                }
                if(opportunityAddr.size() > 0)
                    update opportunityAddr;
            }
            else
            {
                //if the user created a new address instead of selecting one, insert the new address
                if(addressSelected == false)
                {
                    insert address;
                }
                
                //populate the opportunityAddress lookup to the address record either selected or created by the user
                opportunityAddress.Job_Address__c = address.Id;
                update opportunityAddress;
            }
                
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,''+newMap + oldMap + junctionExclusions));
            ApexPages.addMessages(e);
            return null;
        }
        
        return new PageReference('/'+opportunityAddress.Id);
    }

}