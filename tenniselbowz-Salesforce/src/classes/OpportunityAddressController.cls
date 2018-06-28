public with sharing class OpportunityAddressController {
    
    public Address__c address{get;set;}
    public Address__c originalAddress{get;set;}
    public Opportunity opportunityAddress{get;set;}
    public String returnUrl{get;set;}
    public Boolean addressSelected{get;set;}
    public OpportunityAddressController(ApexPages.StandardController controller) {

    }
    
    public PageReference selectAddress()
    {
        if(opportunityAddress.opportunity_Address__c != null)
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
                       where Id = :opportunityAddress.Opportunity_Address__c];
                       
            addressSelected = true;
        }
        else
        {
            addressSelected = false;
            address = new Address__c();
        }
        
        return null;
    }
    

}