public class DaikinToolsTestingUtils {
    
    //Address Constants
    @testvisible static final String TEST_ADDRESS_TYPE_END = 'END';
    @testvisible static final Integer TEST_ADDRESS_ID = 12345;
    @testvisible static final String TEST_ADDRESS_LINE_1 = 'test add line 1';
    @testvisible static final String TEST_ADDRESS_LINE_2 = 'test add line 2';
    @testvisible static final String TEST_ADDRESS_LINE_3 = 'test add line 3';
    @testvisible static final String TEST_ADDRESS_LINE_4 = 'test add line 4';
    @testvisible static final String TEST_CITY = 'test city';
    @testvisible static final String TEST_CONTACT = 'test contact';
    @testvisible static final String TEST_COUNTRY = 'test country';
    @testvisible static final String TEST_COUNTRYISO = 'test country iso';
    @testvisible static final String TEST_COUNTY = 'test county';
    @testvisible static final String TEST_FAX = 'test fax';
    @testvisible static final String TEST_NAME = 'test name';
    @testvisible static final String TEST_EMAILADDRESS = 'test email address';
    @testvisible static final String TEST_PHONE = 'test phone';
    @testvisible static final String TEST_POSTAL_CODE = 'test postal code';
    @testvisible static final String TEST_STATE = 'test state';
    @testvisible static final String TEST_STATE_PROVINCE_ISO = 'test state province';
    @testvisible static final Boolean TEST_VALIDATED = true;
    @testvisible static final Integer TEST_HOURS_BEFORE = 2;
    @testvisible static final String TEST_SPECIAL_DELIVERY_COMMENTS = 'test spec deliv';
    @testvisible static final String TEST_SALESFORCE_ADDRESS_ID  = 'test sfId';
    
    //SalesPerson Constants
    @testvisible static final String TEST_SALESPERSON_INSIDE_FNAME  = 'test I fname';
    @testvisible static final String TEST_SALESPERSON_INSIDE_LNAME  = 'test I lname';
    @testvisible static final String TEST_SALESPERSON_INSIDE_ID  = 'test I spId';
    @testvisible static final String TEST_SALESPERSON_INSIDE_TYPE  = 'Inside';
    
    @testvisible static final String TEST_SALESPERSON_OUTSIDE_FNAME  = 'test O fname';
    @testvisible static final String TEST_SALESPERSON_OUTSIDE_LNAME  = 'test O lname';
    @testvisible static final String TEST_SALESPERSON_OUTSIDE_ID  = 'test O spId';
    @testvisible static final String TEST_SALESPERSON_OUTSIDE_TYPE  = 'Outside';
    
    //OLI Contstants
    @testvisible static final String TEST_OLI_GUID  = 'test oliGuid';
    @testvisible static final String TEST_OLI_PARENT_GUID  = 'test oli Parent Guid';
    @testvisible static final String TEST_OLI_APP_KEY  = 'test oli app key';
    @testvisible static final String TEST_OLI_FORMAT_NUMBER  = '133';
    @testvisible static final String TEST_OLI_ITEM_NUMBER  = 'num';
    @testvisible static final String TEST_OLI_BASE_TAG  = 'test oli base tag';
    @testvisible static final String TEST_OLI_MODEL_NUM  = 'test oli model num';
    @testvisible static final String TEST_OLI_MODEL_DESC  = 'test oli model desc';
    @testvisible static final String TEST_OLI_DT_PCL  = 'pcl';
    @testvisible static final Double TEST_OLI_LIST_PRICE  = 1;
    @testvisible static final Integer TEST_OLI_QUANTITY  = 1;
    @testvisible static final Double TEST_OLI_MULT_PAR  = 1;
    @testvisible static final Double TEST_OLI_QTY_DISC_FACT  = 1;
    @testvisible static final Double TEST_OLI_NET_PRICE  = 1;
    @testvisible static final Integer TEST_OLI_BASE_BID_OR_ALT  = 2;
    @testvisible static final Boolean TEST_OLI_IS_PRICED  = true;
    @testvisible static final Boolean TEST_OLI_IS_STOCK  = true;
    @testvisible static final Boolean TEST_OLI_IS_QUICK_SHIP  = true;
    @testvisible static final Boolean TEST_OLI_IS_NOT_FOUND  = false;
    @testvisible static final Boolean TEST_OLI_IS_OUTSIDE_VENDOR  = true;
    @testvisible static final String TEST_OLI_REQ_SHIP_DATE  = '04/25/2014 12:00:00 PM';
    @testvisible static final String TEST_OLI_ITEM_STATUS  = 'TEST status';
    @testvisible static final Integer TEST_OLI_CODE_ITEMS_QUANTITY  = 2;
    @testvisible static final Integer TEST_OLI_CODE_ITEMS_ITEM = 100;
    @testvisible static final String TEST_OLI_CODE_ITEMS_DESCRIPTION = 'Sample description of code item';
    @testvisible static final String TEST_OLI_CODE_ITEMS_VALUE = 'Code Item Value';
    @testvisible static final String TEST_OLI_CODE_ITEMS_VAL_DESCRIP = 'Sample description of value';
    @testvisible static final Double TEST_OLI_CODE_ITEMS_LIST_PRICE = 20.00;
    @testvisible static final Boolean TEST_OLI_CODE_ITEMS_IS_SPECIAL = false;
    @testvisible static final String TEST_OLI_CODE_ITEMS_SPECIAL_TEXT = 'Special text';
    
    @testvisible static final Boolean TEST_OLI_IS_ALTERNATE = true;
    @testvisible static final Integer TEST_REQ_OPP_PROPERTY_QUANTITY  = 2;
    @testvisible static final String TEST_REQ_OPP_PROPERTY_NAME = 'RequestOpp Name';
    @testvisible static final String TEST_REQ_OPP_PROPERTY_VALUE = 'RequestOpp Value';
    @testvisible static final String TEST_REQ_OPP_PROPERTY_DESCRIPTION = 'RequestOpp Description';
    
    @testvisible static final Integer TEST_OPP_COMPONENT_QUANTITY  = 2;
    @testvisible static final Integer TEST_OPP_COMPONENT_ID = 2;
    @testvisible static final Integer TEST_OPP_COMPONENT_TYPE = 99;
    
    @testvisible static final Integer TEST_OPP_COMPONENT_PROP_QUANTITY  = 2;
    @testvisible static final String TEST_OPP_COMPONENT_PROP_NAME = 'Component Property Name';
    @testvisible static final String TEST_OPP_COMPONENT_PROP_VALUE = 'Component Property Value';
    @testvisible static final String TEST_OPP_COMPONENT_PROP_DESCRIP = 'Component Property Description.';
    
    @testvisible static DaikinToolsOpptyUpdateService.Request_OpportunityItem createTestOLI(Long counter)
    {
        DaikinToolsOpptyUpdateService.Request_OpportunityItem sampleOLI = new DaikinToolsOpptyUpdateService.Request_OpportunityItem();
        
        sampleOLI.Guid = '' + counter;
        sampleOLI.ParentGuid = TEST_OLI_PARENT_GUID;
        sampleOLI.AppKey = TEST_OLI_APP_KEY;
        sampleOLI.FormatNumber = TEST_OLI_FORMAT_NUMBER;
        sampleOLI.ItemNumber = TEST_OLI_ITEM_NUMBER;
        sampleOLI.BaseTag = TEST_OLI_BASE_TAG;
        sampleOLI.ModelNumber = TEST_OLI_MODEL_NUM;
        sampleOLI.ModelDescription = TEST_OLI_MODEL_DESC;
        sampleOLI.PCL = TEST_OLI_DT_PCL;
        sampleOLI.ListPrice = TEST_OLI_LIST_PRICE;
        sampleOLI.Quantity = TEST_OLI_QUANTITY;
        // the actual multiplier will be mapped to multiplier PAr when in SF DB
        sampleOLI.ActualMultiplier = TEST_OLI_MULT_PAR;
        sampleOLI.QuantityDiscountFactor = TEST_OLI_QTY_DISC_FACT;
        sampleOLI.NetPrice = TEST_OLI_NET_PRICE;
        sampleOLI.BaseBidOrAlternate = TEST_OLI_BASE_BID_OR_ALT;
        sampleOLI.IsPriced = TEST_OLI_IS_PRICED;
        sampleOLI.IsStock = TEST_OLI_IS_STOCK;
        sampleOLI.IsQuickShip = TEST_OLI_IS_QUICK_SHIP;
        sampleOLI.IsNotFoundItem = TEST_OLI_IS_NOT_FOUND;
        sampleOLI.IsOutsideVendorItem = TEST_OLI_IS_OUTSIDE_VENDOR;
        sampleOLI.RequestedShipDate = TEST_OLI_REQ_SHIP_DATE;
        sampleOLI.ItemStatus = TEST_OLI_ITEM_STATUS;
        
        //added
        sampleOLI.IsAlternate = TEST_OLI_IS_ALTERNATE;
        
        sampleOLI.CodeItems = createTestCodeItems(TEST_OLI_CODE_ITEMS_QUANTITY);
        sampleOLI.Properties = createTestPropertyItems(TEST_REQ_OPP_PROPERTY_QUANTITY);
        sampleOLI.Components = createTestComponentItems(TEST_OPP_COMPONENT_QUANTITY, TEST_OPP_COMPONENT_PROP_QUANTITY);
        //sampleOLI.Accessories = TBD;
        
        return sampleOLI;
    }
    
    @testvisible static DaikinToolsOpptyUpdateService.Request_OpportunityAddress createTestAddress( String addType )
    {
        DaikinToolsOpptyUpdateService.Request_OpportunityAddress sampleAddress = new DaikinToolsOpptyUpdateService.Request_OpportunityAddress();
        
        
        sampleAddress.AddressType = addType;
        sampleAddress.AddressId = DaikinToolsTestingUtils.TEST_ADDRESS_ID;
        sampleAddress.AddressLine1 = DaikinToolsTestingUtils.TEST_ADDRESS_LINE_1;
        sampleAddress.AddressLine2 = DaikinToolsTestingUtils.TEST_ADDRESS_LINE_2;
        sampleAddress.AddressLine3 = DaikinToolsTestingUtils.TEST_ADDRESS_LINE_3;
        sampleAddress.AddressLine4 = DaikinToolsTestingUtils.TEST_ADDRESS_LINE_4;
        sampleAddress.City = DaikinToolsTestingUtils.TEST_CITY;
        sampleAddress.Contact = DaikinToolsTestingUtils.TEST_CONTACT;
        sampleAddress.Country = DaikinToolsTestingUtils.TEST_COUNTRY;
        sampleAddress.CountryISO = DaikinToolsTestingUtils.TEST_COUNTRYISO;
        sampleAddress.County = DaikinToolsTestingUtils.TEST_COUNTY;
        sampleAddress.Fax = DaikinToolsTestingUtils.TEST_FAX;
        sampleAddress.Name = DaikinToolsTestingUtils.TEST_NAME;
        sampleAddress.EmailAddress = DaikinToolsTestingUtils.TEST_EMAILADDRESS;
        sampleAddress.Phone = DaikinToolsTestingUtils.TEST_PHONE;
        sampleAddress.PostalCode = DaikinToolsTestingUtils.TEST_POSTAL_CODE;
        sampleAddress.State = DaikinToolsTestingUtils.TEST_STATE;
        sampleAddress.StateProvinceISO = DaikinToolsTestingUtils.TEST_STATE_PROVINCE_ISO;
        sampleAddress.Validated = DaikinToolsTestingUtils.TEST_VALIDATED;
        sampleAddress.HoursBefore = DaikinToolsTestingUtils.TEST_HOURS_BEFORE;
        sampleAddress.SpecialDeliveryComments = DaikinToolsTestingUtils.TEST_SPECIAL_DELIVERY_COMMENTS;
        sampleAddress.SalesForceAddressId = DaikinToolsTestingUtils.TEST_SALESFORCE_ADDRESS_ID;
        
        return sampleAddress;

    }
    
     @testvisible static DaikinToolsOpptyUpdateService.Request_OpportunitySalesPerson createTestSalesPerson( String spType )
    {
        DaikinToolsOpptyUpdateService.Request_OpportunitySalesPerson sampleSalesPerson = new DaikinToolsOpptyUpdateService.Request_OpportunitySalesPerson();
        
        sampleSalesPerson.Type = spType;
        sampleSalesPerson.FirstName = spType == DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_TYPE ? DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_FNAME : DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_FNAME;
        sampleSalesPerson.LastName = spType == DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_TYPE ? DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_LNAME : DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_LNAME;
        sampleSalesPerson.Id = spType == DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_TYPE ? DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_ID : DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_ID;
        
        return sampleSalesPerson;

    }
    
    @testvisible static List<DaikinToolsOpptyUpdateService.Request_OpportunityCodeItem> createTestCodeItems(Integer numOfItems)
    {
    
        List<DaikinToolsOpptyUpdateService.Request_OpportunityCodeItem> sampleCodeItems = new List<DaikinToolsOpptyUpdateService.Request_OpportunityCodeItem>();
    
        DaikinToolsOpptyUpdateService.Request_OpportunityCodeItem sampleCodeItem = new DaikinToolsOpptyUpdateService.Request_OpportunityCodeItem();
        for( Integer i = 0; i < numOfItems; i++)
        {
            sampleCodeItem.Item = DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_ITEM; 
            sampleCodeItem.Description = DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_DESCRIPTION;
            sampleCodeItem.Value = DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_VALUE;
            sampleCodeItem.ValueDescription = DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_VAL_DESCRIP;
            sampleCodeItem.ListPrice = DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_LIST_PRICE;
            sampleCodeItem.IsSpecial = DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_IS_SPECIAL;
            sampleCodeItem.SpecialText = DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_SPECIAL_TEXT;
            sampleCodeItems.add(sampleCodeItem);
        }
        // return a list containing the code items given number of items var passed
        return sampleCodeItems;
    }
    
    @testvisible static List<DaikinToolsOpptyUpdateService.Request_OpportunityProperty> createTestPropertyItems(Integer numOfItems)
    {
        List<DaikinToolsOpptyUpdateService.Request_OpportunityProperty> sampleOppProperties = new List<DaikinToolsOpptyUpdateService.Request_OpportunityProperty>();
        DaikinToolsOpptyUpdateService.Request_OpportunityProperty sampleOppProperty = new DaikinToolsOpptyUpdateService.Request_OpportunityProperty();
        
        for( Integer i = 0; i < numOfItems; i++)
        {
            sampleOppProperty.Name = DaikinToolsTestingUtils.TEST_REQ_OPP_PROPERTY_NAME; 
            sampleOppProperty.Value = DaikinToolsTestingUtils.TEST_REQ_OPP_PROPERTY_VALUE; 
            sampleOppProperty.Description = DaikinToolsTestingUtils.TEST_REQ_OPP_PROPERTY_DESCRIPTION; 
            sampleOppProperties.add(sampleOppProperty);
        }
        // return a list containing the opp properties given number of items var passed
        return sampleOppProperties;
    }
    
    @testvisible static List<DaikinToolsOpptyUpdateService.Request_OpportunityComponent> createTestComponentItems(Integer numOfItems, Integer numOfItemProps)
    {
        // This method will make both the components as well as the component prperties given the values passed in
        Integer i = 0;
        DaikinToolsOpptyUpdateService.Request_OpportunityComponent sampleOppComponent = new DaikinToolsOpptyUpdateService.Request_OpportunityComponent();
        List<DaikinToolsOpptyUpdateService.Request_OpportunityComponent> sampleOppComponents = new List<DaikinToolsOpptyUpdateService.Request_OpportunityComponent>();
        
        DaikinToolsOpptyUpdateService.Request_OpportunityComponentProperty sampleOppComponentProperty = new DaikinToolsOpptyUpdateService.Request_OpportunityComponentProperty();
        List<DaikinToolsOpptyUpdateService.Request_OpportunityComponentProperty> sampleOppComponentProperties = new List<DaikinToolsOpptyUpdateService.Request_OpportunityComponentProperty>();

        for( i = 0; i < numOfItemProps; i++)
        {
            sampleOppComponentProperty.Name = DaikinToolsTestingUtils.TEST_OPP_COMPONENT_PROP_NAME;
            sampleOppComponentProperty.Value = DaikinToolsTestingUtils.TEST_OPP_COMPONENT_PROP_VALUE;
            sampleOppComponentProperty.Description = DaikinToolsTestingUtils.TEST_OPP_COMPONENT_PROP_DESCRIP;
            sampleOppComponentProperties.add(sampleOppComponentProperty);
        }
        
        for( i = 0; i < numOfItems; i++)
        {
            sampleOppComponent.Id = DaikinToolsTestingUtils.TEST_OPP_COMPONENT_ID; 
            sampleOppComponent.Type = DaikinToolsTestingUtils.TEST_OPP_COMPONENT_TYPE;
            sampleOppComponent.Properties = sampleOppComponentProperties;
            sampleOppComponents.add(sampleOppComponent);
        }
        // return a list containing the opp properties given number of items var passed
        return sampleOppComponents; 
    }

}