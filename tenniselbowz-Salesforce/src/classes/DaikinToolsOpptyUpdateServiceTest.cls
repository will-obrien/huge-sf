@isTest
private class DaikinToolsOpptyUpdateServiceTest
{
        static testMethod void testDoPost()
    {
        PreventDeleteHandler.byPassTrigger = true;
        final Integer NUM_OPPTIES = 10;
        final String DT_STATUS = 'Test Status';
        final String DAIKIN_TOOLS_SOURCE = 'Daikin Tools';
        final Integer SALES_ORDER_NUMBER = 12345;
        final String PURCHASE_ORDER_NUM = 'TestPO Num';
        final String PAR_NUMBER = '54321';

        Account testAccount = TestingUtils.createAccounts( 1, 'Test Account', true )[0];

        DaikinToolsOpptyUpdateService.OpportunityUpdateRequest testRequest = new DaikinToolsOpptyUpdateService.OpportunityUpdateRequest();
        testRequest.Source = DAIKIN_TOOLS_SOURCE;
        testRequest.Opportunities = new List<DaikinToolsOpptyUpdateService.Request_Opportunity>();

        List<Opportunity> testOpportunities = TestingUtils.createOpportunities( NUM_OPPTIES, testAccount.Id, false );
        Long counter = System.now().getTime();

        for( Opportunity anOpportunity : testOpportunities )
        {
            anOpportunity.DST_ID__c = '' + counter++;
            anOpportunity.Bypass__c = TRUE;
            anOpportunity.PriceBook2Id = null;
        }
        insert testOpportunities;

        for( Opportunity anOpportunity : testOpportunities )
        {
            DaikinToolsOpptyUpdateService.Request_Opportunity newOpportunity = new DaikinToolsOpptyUpdateService.Request_Opportunity();
            newOpportunity.CustomerPurchaseOrderNumber = PURCHASE_ORDER_NUM;
            newOpportunity.JobGuid = anOpportunity.DST_ID__c;
            newOpportunity.SFDCID = anOpportunity.Id;
            newOpportunity.OrderStatus = DT_STATUS;
            newOpportunity.SalesOrderNumber = SALES_ORDER_NUMBER;
            newOpportunity.PARNumber = PAR_NUMBER;
            newOpportunity.Addresses = new List<DaikinToolsOpptyUpdateService.Request_OpportunityAddress>{ DaikinToolsTestingUtils.createTestAddress( DaikinToolsTestingUtils.TEST_ADDRESS_TYPE_END ) };
            newOpportunity.SalesPeople = new List<DaikinToolsOpptyUpdateService.Request_OpportunitySalesPerson>{ DaikinToolsTestingUtils.createTestSalesPerson( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_TYPE ), DaikinToolsTestingUtils.createTestSalesPerson( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_TYPE )  };
            newOpportunity.Items = new List<DaikinToolsOpptyUpdateService.Request_OpportunityItem>{ DaikinToolsTestingUtils.createTestOLI(counter) };
            testRequest.Opportunities.add( newOpportunity );
            counter++;
        }

        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );

        Test.startTest();

            DaikinToolsOpptyUpdateService.DEFAULT_PRICEBOOK_ID = Test.getStandardPricebookId();
            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyUpdateService.doPost();

        Test.stopTest();

        List<Opportunity> updatedOpportunities = [ SELECT Id, PriceBook2Id, DST_ID__c, SO_Number__c, PAR_Number__c,
                                                   DT_Order_Status__c, DT_END_Address_Contact__c,
                                                   DT_END_Address_ID__c, DT_END_Address_Line_1__c, DT_END_Address_Line_2__c,
                                                   DT_END_Address_Line_3__c, DT_END_Address_Line_4__c, DT_END_Address_Name__c,
                                                   DT_END_Address_Phone__c, DT_END_Address_Special_Delivery_Comments__c,
                                                   DT_END_Address_Validated__c, DT_END_City__c, DT_END_Contact_Email_Address__c,
                                                   DT_END_Country__c, DT_END_County__c, DT_END_Fax__c, DT_END_Hours_Before__c, DT_END_Postal_Code__c,
                                                   DT_END_State__c, DT_IS_First_Name__c, DT_IS_Last_Name__c, DT_IS_ID__c, DT_OSP_First_Name__c,
                                                   DT_OSP_Last_Name__c, DT_OSP_ID__c, CustomerPurchaseOrderNumber__c,
                                                    (SELECT DST_ID__c, OpportunityId, IsAlternate__c, DT_Parent_ID__c, Quantity, TotalPrice, List_Price__c,
                                                            TAG__c, DT_App_Key__c, DT_Format_Number__c, DT_Item_Status__c, Custom_Description__c,
                                                            Discount__c, NetPrice__c, UnitPrice, PricebookEntryId, DT_Code_Item__c, DT_InputsAndOutputs__c,
                                                            Item_Number__c, DT_PCL__c, Multiplier_PAR__c, Is_Priced__c, Is_Stock__c,
                                                            Is_Quick_Ship__c, Is_Not_Found__c, Is_Outside_Vendor__c, Requested_Ship_Date__c
                                                            FROM OpportunityLineItems )
                                                   FROM Opportunity ];

        //System.assert(false, [SELECT Id, OpportunityId FROM OpportunityLineItem ]);

        System.assertEquals( NUM_OPPTIES, updatedOpportunities.size(), 'There should be as many opportunities retrieved as were created' );

        for( Opportunity anOpportunity : updatedOpportunities )
        {
            System.assertNotEquals( null, anOpportunity.DST_ID__c, 'When passed through a post call the external id should still exist' );
            System.assertEquals( DT_STATUS, anOpportunity.DT_Order_Status__c, 'When passed through a Post call the Order Status should be updated' );
            System.assertEquals( SALES_ORDER_NUMBER, anOpportunity.SO_Number__c, 'When passed through a Post call the SO Number should be updated' );
            System.assertEquals( Decimal.valueOf(PAR_NUMBER), anOpportunity.PAR_Number__c, 'When passed through a Post call the PAR Number should be updated' );
            System.assertEquals( DaikinToolsOpptyUpdateService.DEFAULT_PRICEBOOK_ID, anOpportunity.PriceBook2Id, 'When passed through a Post call the PricebookID should be set if it is not' );
            System.assertEquals( PURCHASE_ORDER_NUM, anOpportunity.CustomerPurchaseOrderNumber__c, 'When passed through a post call the Customer Purchase Order Number should be updated');

            //Testing the address info
            System.assertEquals( DaikinToolsTestingUtils.TEST_CONTACT, anOpportunity.DT_END_Address_Contact__c, 'The address contact should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_ADDRESS_ID, anOpportunity.DT_END_Address_ID__c, 'The address id should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_ADDRESS_LINE_1, anOpportunity.DT_END_Address_Line_1__c, 'The address line 1 should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_ADDRESS_LINE_2, anOpportunity.DT_END_Address_Line_2__c, 'The address line2 should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_ADDRESS_LINE_3, anOpportunity.DT_END_Address_Line_3__c, 'The address line 3 should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_ADDRESS_LINE_4, anOpportunity.DT_END_Address_Line_4__c, 'The address line 4 should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_NAME, anOpportunity.DT_END_Address_Name__c, 'The address name should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_PHONE, anOpportunity.DT_END_Address_Phone__c, 'The address phone should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SPECIAL_DELIVERY_COMMENTS, anOpportunity.DT_END_Address_Special_Delivery_Comments__c, 'The address spec deliv should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_VALIDATED, anOpportunity.DT_END_Address_Validated__c, 'The address validated should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_CITY, anOpportunity.DT_END_City__c, 'The address city should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_EMAILADDRESS, anOpportunity.DT_END_Contact_Email_Address__c, 'The address email add should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_COUNTRY, anOpportunity.DT_END_Country__c, 'The address country should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_COUNTY, anOpportunity.DT_END_County__c, 'The address county should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_FAX, anOpportunity.DT_END_Fax__c, 'The address fax should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_HOURS_BEFORE, anOpportunity.DT_END_Hours_Before__c, 'The address hours before should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_POSTAL_CODE, anOpportunity.DT_END_Postal_Code__c, 'The address postal code should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_STATE, anOpportunity.DT_END_State__c, 'The address state should be correctly set' );

            //Testing the salesperson info
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_FNAME, anOpportunity.DT_IS_First_Name__c, 'The inside firstname should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_LNAME, anOpportunity.DT_IS_Last_Name__c, 'The inside lastname should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_ID, anOpportunity.DT_IS_ID__c, 'The inside Id should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_FNAME, anOpportunity.DT_OSP_First_Name__c, 'The outside firstname  should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_LNAME, anOpportunity.DT_OSP_Last_Name__c, 'The outside lastname should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_ID, anOpportunity.DT_OSP_ID__c, 'The outside Id should be correctly set' );

            //OLI assertions
            System.assertEquals( 1, anOpportunity.opportunityLineItems.size(), 'There should be one line item');

            for( OpportunityLineItem olifound : anOpportunity.opportunityLineItems )
            {
                System.assertNotEquals( null, olifound.DST_ID__c, 'The oli guid should be correctly set' );
                System.assertEquals( true, olifound.IsAlternate__c, 'The oli alternate flag should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_PARENT_GUID, olifound.DT_Parent_ID__c, 'The oli parent guid should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_QUANTITY, olifound.Quantity, 'The oli qty should be correctly set' );
               // System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_LIST_PRICE, olifound.TotalPrice, 'The oli total price should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_LIST_PRICE, olifound.List_Price__c, 'The oli list price should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_BASE_TAG, olifound.TAG__c, 'The oli tag should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_APP_KEY, olifound.DT_App_Key__c, 'The oli app key should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_FORMAT_NUMBER, olifound.DT_Format_Number__c, 'The oli format should be correctly set' );

                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_ITEM_NUMBER, olifound.Item_Number__c, 'The oli item number should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_DT_PCL, olifound.DT_PCL__c, 'The oli DT PCL should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_MULT_PAR, olifound.Multiplier_PAR__c, 'The oli Multiplier PAR should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_ALTERNATE, olifound.IsAlternate__c, 'The is Alternate checkbox should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_PRICED, olifound.Is_Priced__c, 'The is Priced checkbox should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_STOCK, olifound.Is_Stock__c, 'The is Stocked checkbox should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_QUICK_SHIP, olifound.Is_Quick_Ship__c, 'The is Quick Ship checkbox should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_NOT_FOUND, olifound.Is_Not_Found__c, 'The is Not Found checkbox should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_OUTSIDE_VENDOR, olifound.Is_Outside_Vendor__c, 'The is Outside Vendor checkbox should be correctly set' );
                System.assertEquals( DaikinToolsOpptyUpdateService.convertStringToDate(DaikinToolsTestingUtils.TEST_OLI_REQ_SHIP_DATE), olifound.Requested_Ship_Date__c, 'The is Requested Ship Date checkbox should be correctly set' );

                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_ITEM_STATUS, olifound.DT_Item_Status__c, 'The oli status should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_MODEL_DESC, olifound.Custom_Description__c, 'The oli desc should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_QTY_DISC_FACT, olifound.Discount__c, 'The oli discount factor should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_NET_PRICE, olifound.NetPrice__c, 'The oli net price should be correctly set' );
          //      System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_NET_PRICE, olifound.UnitPrice, 'The oli unit price should be correectly set as equal to net price' );
                System.assertNotEquals( null, olifound.PricebookEntryId, 'The oli guid should be correctly set' );

                System.assertNotEquals( null, olifound.DT_Code_Item__c, 'The code item cannot be null' );
                System.assert(olifound.DT_Code_Item__c.contains(String.valueOf(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_ITEM)), 'The code item is missing item');
                System.assert(olifound.DT_Code_Item__c.contains(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_DESCRIPTION), 'The code item is missing description');
                System.assert(olifound.DT_Code_Item__c.contains(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_VALUE), 'The code item is missing item value');
                System.assert(olifound.DT_Code_Item__c.contains(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_VAL_DESCRIP), 'The code item is missing item description');
                System.assert(olifound.DT_Code_Item__c.contains(String.valueOf(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_LIST_PRICE)), 'The code item is missing list price');
                System.assert(olifound.DT_Code_Item__c.contains(String.valueOf(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_IS_SPECIAL)), 'The code item is missing is special value');
                System.assert(olifound.DT_Code_Item__c.contains(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_SPECIAL_TEXT), 'The code item is missing special text');

                System.assertNotEquals( null, olifound.DT_InputsAndOutputs__c, 'The input and output item cannot be null' );
                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_REQ_OPP_PROPERTY_NAME), 'The inputs and outputs is missing the property name');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_REQ_OPP_PROPERTY_VALUE), 'The inputs and outputs is missing the property value');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_REQ_OPP_PROPERTY_DESCRIPTION), 'The inputs and outputs is missing the property description');

                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_OPP_COMPONENT_PROP_NAME), 'The inputs and outputs is missing the component property name');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_OPP_COMPONENT_PROP_VALUE), 'The inputs and outputs is missing the component property value');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_OPP_COMPONENT_PROP_DESCRIP), 'The inputs and outputs is missing the component property description');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(String.valueOf(DaikinToolsTestingUtils.TEST_OPP_COMPONENT_ID)), 'The inputs and outputs is missing the component property Id');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(String.valueOf(DaikinToolsTestingUtils.TEST_OPP_COMPONENT_TYPE)), 'The inputs and outputs is missing the component property type');

            }
        }
    }

    static testMethod void testDoPost_SourceOPS()
    {
        PreventDeleteHandler.byPassTrigger = true;
        final Integer NUM_OPPTIES = 10;
        final String DT_STATUS = 'Test Status';
        final String DAIKIN_TOOLS_SOURCE = 'OPS';
        final Integer SALES_ORDER_NUMBER = 12345;
        final String PURCHASE_ORDER_NUM = 'TestPO Num';

        Account testAccount = TestingUtils.createAccounts( 1, 'Test Account', true )[0];

        DaikinToolsOpptyUpdateService.OpportunityUpdateRequest testRequest = new DaikinToolsOpptyUpdateService.OpportunityUpdateRequest();
        testRequest.Source = DAIKIN_TOOLS_SOURCE;
        testRequest.Opportunities = new List<DaikinToolsOpptyUpdateService.Request_Opportunity>();

        List<Opportunity> testOpportunities = TestingUtils.createOpportunities( NUM_OPPTIES, testAccount.Id, false );
        Long counter = System.now().getTime();

        for( Opportunity anOpportunity : testOpportunities )
        {
            anOpportunity.DST_ID__c = '' + counter++;
            anOpportunity.Bypass__c = TRUE;
            anOpportunity.PriceBook2Id = null;
        }
        insert testOpportunities;

        for( Opportunity anOpportunity : testOpportunities )
        {
            DaikinToolsOpptyUpdateService.Request_Opportunity newOpportunity = new DaikinToolsOpptyUpdateService.Request_Opportunity();
            newOpportunity.CustomerPurchaseOrderNumber = PURCHASE_ORDER_NUM;
            newOpportunity.JobGuid = anOpportunity.DST_ID__c;
            newOpportunity.SFDCID = anOpportunity.Id;
            newOpportunity.OrderStatus = DT_STATUS;
            newOpportunity.SalesOrderNumber = SALES_ORDER_NUMBER;
            newOpportunity.Addresses = new List<DaikinToolsOpptyUpdateService.Request_OpportunityAddress>{ DaikinToolsTestingUtils.createTestAddress( DaikinToolsTestingUtils.TEST_ADDRESS_TYPE_END ) };
            newOpportunity.SalesPeople = new List<DaikinToolsOpptyUpdateService.Request_OpportunitySalesPerson>{ DaikinToolsTestingUtils.createTestSalesPerson( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_TYPE ), DaikinToolsTestingUtils.createTestSalesPerson( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_TYPE )  };
            newOpportunity.Items = new List<DaikinToolsOpptyUpdateService.Request_OpportunityItem>{ DaikinToolsTestingUtils.createTestOLI(counter) };
            
            testRequest.Opportunities.add( newOpportunity );
            
            
            counter++;
        }

        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );

        Test.startTest();

            DaikinToolsOpptyUpdateService.DEFAULT_PRICEBOOK_ID = Test.getStandardPricebookId();
            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyUpdateService.doPost();

        Test.stopTest();

        List<Opportunity> updatedOpportunities = [ SELECT Id, PriceBook2Id, DST_ID__c, SO_Number__c,
                                                   DT_Order_Status__c, DT_END_Address_Contact__c,
                                                   DT_END_Address_ID__c, DT_END_Address_Line_1__c, DT_END_Address_Line_2__c,
                                                   DT_END_Address_Line_3__c, DT_END_Address_Line_4__c, DT_END_Address_Name__c,
                                                   DT_END_Address_Phone__c, DT_END_Address_Special_Delivery_Comments__c,
                                                   DT_END_Address_Validated__c, DT_END_City__c, DT_END_Contact_Email_Address__c,
                                                   DT_END_Country__c, DT_END_County__c, DT_END_Fax__c, DT_END_Hours_Before__c, DT_END_Postal_Code__c,
                                                   DT_END_State__c, DT_IS_First_Name__c, DT_IS_Last_Name__c, DT_IS_ID__c, DT_OSP_First_Name__c,
                                                   DT_OSP_Last_Name__c, DT_OSP_ID__c, CustomerPurchaseOrderNumber__c,
                                                    (SELECT DST_ID__c, OpportunityId, IsAlternate__c, DT_Parent_ID__c, Quantity, TotalPrice, List_Price__c,
                                                            TAG__c, DT_App_Key__c, DT_Format_Number__c, DT_Item_Status__c, Custom_Description__c,
                                                            Discount__c, NetPrice__c, UnitPrice, PricebookEntryId, DT_Code_Item__c, DT_InputsAndOutputs__c,
                                                            Item_Number__c, DT_PCL__c, Multiplier_PAR__c, Is_Priced__c, Is_Stock__c,
                                                            Is_Quick_Ship__c, Is_Not_Found__c, Is_Outside_Vendor__c, Requested_Ship_Date__c
                                                            FROM OpportunityLineItems )
                                                   FROM Opportunity ];

        //System.assert(false, [SELECT Id, OpportunityId FROM OpportunityLineItem ]);

        System.assertEquals( NUM_OPPTIES, updatedOpportunities.size(), 'There should be as many opportunities retrieved as were created' );

        for( Opportunity anOpportunity : updatedOpportunities )
        {
            System.assertNotEquals( null, anOpportunity.DST_ID__c, 'When passed through a post call the external id should still exist' );
            System.assertEquals( DT_STATUS, anOpportunity.DT_Order_Status__c, 'When passed through a Post call the Order Status should be updated' );
            System.assertEquals( SALES_ORDER_NUMBER, anOpportunity.SO_Number__c, 'When passed through a Post call the SO Number should be updated' );
            System.assertEquals( DaikinToolsOpptyUpdateService.DEFAULT_PRICEBOOK_ID, anOpportunity.PriceBook2Id, 'When passed through a Post call the PricebookID should be set if it is not' );
            System.assertEquals( PURCHASE_ORDER_NUM, anOpportunity.CustomerPurchaseOrderNumber__c, 'When passed through a post call the Customer Purchase Order Number should be updated');

            //Testing the address info
            System.assertEquals( DaikinToolsTestingUtils.TEST_CONTACT, anOpportunity.DT_END_Address_Contact__c, 'The address contact should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_ADDRESS_ID, anOpportunity.DT_END_Address_ID__c, 'The address id should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_ADDRESS_LINE_1, anOpportunity.DT_END_Address_Line_1__c, 'The address line 1 should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_ADDRESS_LINE_2, anOpportunity.DT_END_Address_Line_2__c, 'The address line2 should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_ADDRESS_LINE_3, anOpportunity.DT_END_Address_Line_3__c, 'The address line 3 should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_ADDRESS_LINE_4, anOpportunity.DT_END_Address_Line_4__c, 'The address line 4 should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_NAME, anOpportunity.DT_END_Address_Name__c, 'The address name should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_PHONE, anOpportunity.DT_END_Address_Phone__c, 'The address phone should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SPECIAL_DELIVERY_COMMENTS, anOpportunity.DT_END_Address_Special_Delivery_Comments__c, 'The address spec deliv should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_VALIDATED, anOpportunity.DT_END_Address_Validated__c, 'The address validated should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_CITY, anOpportunity.DT_END_City__c, 'The address city should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_EMAILADDRESS, anOpportunity.DT_END_Contact_Email_Address__c, 'The address email add should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_COUNTRY, anOpportunity.DT_END_Country__c, 'The address country should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_COUNTY, anOpportunity.DT_END_County__c, 'The address county should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_FAX, anOpportunity.DT_END_Fax__c, 'The address fax should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_HOURS_BEFORE, anOpportunity.DT_END_Hours_Before__c, 'The address hours before should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_POSTAL_CODE, anOpportunity.DT_END_Postal_Code__c, 'The address postal code should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_STATE, anOpportunity.DT_END_State__c, 'The address state should be correctly set' );

            //Testing the salesperson info
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_FNAME, anOpportunity.DT_IS_First_Name__c, 'The inside firstname should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_LNAME, anOpportunity.DT_IS_Last_Name__c, 'The inside lastname should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_ID, anOpportunity.DT_IS_ID__c, 'The inside Id should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_FNAME, anOpportunity.DT_OSP_First_Name__c, 'The outside firstname  should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_LNAME, anOpportunity.DT_OSP_Last_Name__c, 'The outside lastname should be correctly set' );
            System.assertEquals( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_ID, anOpportunity.DT_OSP_ID__c, 'The outside Id should be correctly set' );

            //OLI assertions
            System.assertEquals( 1, anOpportunity.opportunityLineItems.size(), 'There should be one line item');

            for( OpportunityLineItem olifound : anOpportunity.opportunityLineItems )
            {
                System.assertNotEquals( null, olifound.DST_ID__c, 'The oli guid should be correctly set' );
                System.assertEquals( true, olifound.IsAlternate__c, 'The oli alternate flag should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_PARENT_GUID, olifound.DT_Parent_ID__c, 'The oli parent guid should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_QUANTITY, olifound.Quantity, 'The oli qty should be correctly set' );
                //System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_LIST_PRICE, olifound.TotalPrice, 'The oli total price should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_LIST_PRICE, olifound.List_Price__c, 'The oli list price should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_BASE_TAG, olifound.TAG__c, 'The oli tag should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_APP_KEY, olifound.DT_App_Key__c, 'The oli app key should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_FORMAT_NUMBER, olifound.DT_Format_Number__c, 'The oli format should be correctly set' );

                //added
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_ITEM_NUMBER, olifound.Item_Number__c, 'The oli item number should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_DT_PCL, olifound.DT_PCL__c, 'The oli DT PCL should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_MULT_PAR, olifound.Multiplier_PAR__c, 'The oli Multiplier PAR should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_ALTERNATE, olifound.IsAlternate__c, 'The is Alternate checkbox should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_PRICED, olifound.Is_Priced__c, 'The is Priced checkbox should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_STOCK, olifound.Is_Stock__c, 'The is Stocked checkbox should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_QUICK_SHIP, olifound.Is_Quick_Ship__c, 'The is Quick Ship checkbox should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_NOT_FOUND, olifound.Is_Not_Found__c, 'The is Not Found checkbox should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_IS_OUTSIDE_VENDOR, olifound.Is_Outside_Vendor__c, 'The is Outside Vendor checkbox should be correctly set' );
                System.assertEquals( DaikinToolsOpptyUpdateService.convertStringToDate(DaikinToolsTestingUtils.TEST_OLI_REQ_SHIP_DATE), olifound.Requested_Ship_Date__c, 'The is Requested Ship Date checkbox should be correctly set' );

                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_ITEM_STATUS, olifound.DT_Item_Status__c, 'The oli status should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_MODEL_DESC, olifound.Custom_Description__c, 'The oli desc should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_QTY_DISC_FACT, olifound.Discount__c, 'The oli discount factor should be correctly set' );
                System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_NET_PRICE, olifound.NetPrice__c, 'The oli net price should be correctly set' );
             //   System.assertEquals( DaikinToolsTestingUtils.TEST_OLI_NET_PRICE, olifound.UnitPrice, 'The oli unit price should be correectly set as equal to net price' );
                System.assertNotEquals( null, olifound.PricebookEntryId, 'The oli guid should be correctly set' );

                System.assertNotEquals( null, olifound.DT_Code_Item__c, 'The code item cannot be null' );
                System.assert(olifound.DT_Code_Item__c.contains(String.valueOf(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_ITEM)), 'The code item is missing item');
                System.assert(olifound.DT_Code_Item__c.contains(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_DESCRIPTION), 'The code item is missing description');
                System.assert(olifound.DT_Code_Item__c.contains(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_VALUE), 'The code item is missing item value');
                System.assert(olifound.DT_Code_Item__c.contains(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_VAL_DESCRIP), 'The code item is missing item description');
                System.assert(olifound.DT_Code_Item__c.contains(String.valueOf(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_LIST_PRICE)), 'The code item is missing list price');
                System.assert(olifound.DT_Code_Item__c.contains(String.valueOf(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_IS_SPECIAL)), 'The code item is missing is special value');
                System.assert(olifound.DT_Code_Item__c.contains(DaikinToolsTestingUtils.TEST_OLI_CODE_ITEMS_SPECIAL_TEXT), 'The code item is missing special text');

                System.assertNotEquals( null, olifound.DT_InputsAndOutputs__c, 'The input and output item cannot be null' );
                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_REQ_OPP_PROPERTY_NAME), 'The inputs and outputs is missing the property name');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_REQ_OPP_PROPERTY_VALUE), 'The inputs and outputs is missing the property value');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_REQ_OPP_PROPERTY_DESCRIPTION), 'The inputs and outputs is missing the property description');

                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_OPP_COMPONENT_PROP_NAME), 'The inputs and outputs is missing the component property name');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_OPP_COMPONENT_PROP_VALUE), 'The inputs and outputs is missing the component property value');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(DaikinToolsTestingUtils.TEST_OPP_COMPONENT_PROP_DESCRIP), 'The inputs and outputs is missing the component property description');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(String.valueOf(DaikinToolsTestingUtils.TEST_OPP_COMPONENT_ID)), 'The inputs and outputs is missing the component property Id');
                System.assert(olifound.DT_InputsAndOutputs__c.contains(String.valueOf(DaikinToolsTestingUtils.TEST_OPP_COMPONENT_TYPE)), 'The inputs and outputs is missing the component property type');

            }
        }
    }

    static testMethod void testDoPostMissingModelNumber()
    {
        final Integer NUM_OPPTIES = 10;
        final String DT_STATUS = 'Test Status';
        final String DAIKIN_TOOLS_SOURCE = 'Daikin Tools';
        final Integer SALES_ORDER_NUMBER = 12345;

        Account testAccount = TestingUtils.createAccounts( 1, 'Test Account', true )[0];

        DaikinToolsOpptyUpdateService.OpportunityUpdateRequest testRequest = new DaikinToolsOpptyUpdateService.OpportunityUpdateRequest();
        testRequest.Source = DAIKIN_TOOLS_SOURCE;
        testRequest.Opportunities = new List<DaikinToolsOpptyUpdateService.Request_Opportunity>();

        List<Opportunity> testOpportunities = TestingUtils.createOpportunities( NUM_OPPTIES, testAccount.Id, false );
        Long counter = System.now().getTime();

        for( Opportunity anOpportunity : testOpportunities )
        {
            anOpportunity.DST_ID__c = '' + counter++;
            anOpportunity.Bypass__c = TRUE;
            anOpportunity.PriceBook2Id = null;
        }
        insert testOpportunities;

        for( Opportunity anOpportunity : testOpportunities )
        {
            DaikinToolsOpptyUpdateService.Request_Opportunity newOpportunity = new DaikinToolsOpptyUpdateService.Request_Opportunity();
            newOpportunity.JobGuid = anOpportunity.DST_ID__c;
            newOpportunity.SFDCID = anOpportunity.Id;
            newOpportunity.OrderStatus = DT_STATUS;
            newOpportunity.SalesOrderNumber = SALES_ORDER_NUMBER;
            newOpportunity.Addresses = new List<DaikinToolsOpptyUpdateService.Request_OpportunityAddress>{ DaikinToolsTestingUtils.createTestAddress( DaikinToolsTestingUtils.TEST_ADDRESS_TYPE_END ) };
            newOpportunity.SalesPeople = new List<DaikinToolsOpptyUpdateService.Request_OpportunitySalesPerson>{ DaikinToolsTestingUtils.createTestSalesPerson( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_TYPE ), DaikinToolsTestingUtils.createTestSalesPerson( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_TYPE )  };

            DaikinToolsOpptyUpdateService.Request_OpportunityItem opItem = DaikinToolsTestingUtils.createTestOLI(counter);
            opItem.ModelNumber = '';

            newOpportunity.Items = new List<DaikinToolsOpptyUpdateService.Request_OpportunityItem>{ opItem };
            testRequest.Opportunities.add( newOpportunity );
            counter++;
        }

        RestContext.request = new System.RestRequest();
        String totalRequest = JSON.serialize(testRequest);
        RestContext.request.requestBody = Blob.valueOf( totalRequest );

        Test.startTest();

            DaikinToolsOpptyUpdateService.DEFAULT_PRICEBOOK_ID = Test.getStandardPricebookId();
            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyUpdateService.doPost();

        Test.stopTest();


        List<Integration_Error__c> errors = [SELECT Id, Direction__c, Error_Description__c,
                                                    Integration_Object__c, Integration_Point__c,
                                                    Request_Data__c
                                            FROM Integration_Error__c ];

        //We expect an error for the pricebook, the product and the 10 olis - total 12
        System.assertEquals( NUM_OPPTIES + 2, errors.size(), 'Missing model numbers should cause an error on oli creation and product and pricebook creation');

        for( Integration_Error__c err : errors )
        {
            System.assertEquals( DaikinToolsOpptyUpdateService.ERROR_DIRECTION, err.Direction__c, 'The error direction should be correctly captured');
            System.assertEquals( DAIKIN_TOOLS_SOURCE, err.Integration_Point__c, 'The error integration point should be correctly captured');
            //System.assertEquals( totalRequest, err.Request_Data__c, 'The error request should be correctly captured');
        }

        List<Opportunity> updatedOpportunities = [ SELECT Id,
                                                    (SELECT DST_ID__c
                                                            FROM OpportunityLineItems )
                                                   FROM Opportunity ];

        System.assertEquals( NUM_OPPTIES, updatedOpportunities.size(), 'There should be as many opportunities retrieved as were created' );

        for( Opportunity anOpportunity : updatedOpportunities )
        {
            //OLI assertions
            System.assertEquals( 0, anOpportunity.opportunityLineItems.size(), 'There should not be any line items');
        }
    }

    static testMethod void testDoPostDeleteMissingLineItems()
    {
        final Integer NUM_OPPTIES = 10;
        final Integer NUM_OLIS_PER = 7;
        final String DAIKIN_TOOLS_SOURCE = 'Daikin Tools';
        final String DT_STATUS = 'Test Status';
        final Integer SALES_ORDER_NUMBER = 12345;

        Account testAccount = TestingUtils.createAccounts( 1, 'Test Account', true )[0];

        DaikinToolsOpptyUpdateService.OpportunityUpdateRequest testRequest = new DaikinToolsOpptyUpdateService.OpportunityUpdateRequest();
        testRequest.Source = DAIKIN_TOOLS_SOURCE;
        testRequest.Opportunities = new List<DaikinToolsOpptyUpdateService.Request_Opportunity>();

        List<Opportunity> testOpportunities = TestingUtils.createOpportunities( NUM_OPPTIES, testAccount.Id, false );
        Long counter = System.now().getTime();

        Product2 testProd = new Product2( Name = 'Test Prod' );
        insert testProd;

        for( Opportunity anOpportunity : testOpportunities )
        {
            anOpportunity.DST_ID__c = '' + counter++;
            anOpportunity.Bypass__c = TRUE;
            anOpportunity.PriceBook2Id = Test.getStandardPricebookId();
        }
        insert testOpportunities;

        Pricebookentry testPbe = new Pricebookentry();

        testPbe.Product2Id = testProd.Id;
        testPbe.Pricebook2Id = Test.getStandardPricebookId();
        testPbe.UnitPrice = 1;
        testPbe.IsActive = TRUE;

        insert testPbe;

        List<OpportunityLineItem> testOlis = new List<OpportunityLineItem>();
        Set<String> olisGuidsToRemain = new Set<String>();

        for( Opportunity anOpportunity : testOpportunities )
        {
            DaikinToolsOpptyUpdateService.Request_Opportunity newOpportunity = new DaikinToolsOpptyUpdateService.Request_Opportunity();
            newOpportunity.JobGuid = anOpportunity.DST_ID__c;
            newOpportunity.SFDCID = anOpportunity.Id;
            newOpportunity.OrderStatus = DT_STATUS;
            newOpportunity.SalesOrderNumber = SALES_ORDER_NUMBER;
            newOpportunity.Addresses = new List<DaikinToolsOpptyUpdateService.Request_OpportunityAddress>{ DaikinToolsTestingUtils.createTestAddress( DaikinToolsTestingUtils.TEST_ADDRESS_TYPE_END ) };
            newOpportunity.SalesPeople = new List<DaikinToolsOpptyUpdateService.Request_OpportunitySalesPerson>{ DaikinToolsTestingUtils.createTestSalesPerson( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_TYPE ), DaikinToolsTestingUtils.createTestSalesPerson( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_TYPE )  };
            newOpportunity.Items = new List<DaikinToolsOpptyUpdateService.Request_OpportunityItem>{ DaikinToolsTestingUtils.createTestOLI(counter), DaikinToolsTestingUtils.createTestOLI(++counter) };

            List<OpportunityLineItem>olisForOppty = Testingutils.createOpportunityLineItems (NUM_OLIS_PER, anOpportunity.Id, testPbe.Id, false);
            for(OpportunityLineItem oli : olisForOppty){
                oli.DST_ID__c = ''+ (counter-1); 
            }

            olisForOppty[0].DST_ID__c = '' + counter;
            olisGuidsToRemain.add( '' + (counter - 1) );
            olisGuidsToRemain.add( '' + counter );

            testOlis.addAll( olisForOppty );

            testRequest.Opportunities.add( newOpportunity );
            counter++;
        }
        insert testOlis;

        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );

        Test.startTest();

            DaikinToolsOpptyUpdateService.DEFAULT_PRICEBOOK_ID = Test.getStandardPricebookId();
            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyUpdateService.doPost();

        Test.stopTest();

        List<Opportunity> updatedOpportunities = [ SELECT Id,
                                                    (SELECT DST_ID__c, OpportunityId
                                                            FROM OpportunityLineItems )
                                                   FROM Opportunity ];

        System.assertEquals( NUM_OPPTIES, updatedOpportunities.size(), 'There should be as many opportunities retrieved as were created' );
        Set<String> actualOliIGUIDS = new Set<String>();

        for( Opportunity anOpportunity : updatedOpportunities )
        {
            System.assertEquals( 2, anOpportunity.opportunityLineItems.size(), 'There should be two line items');
            actualOliIGUIDS.add( anOpportunity.opportunityLineItems[0].DST_ID__c);
            actualOliIGUIDS.add( anOpportunity.opportunityLineItems[1].DST_ID__c);
        }

        System.assertEquals( olisGuidsToRemain, actualOliIGUIDS, 'The expected Olis should remain and all others should be deleted');

    }

    static testMethod void testDoPostDontDeleteMissingLineItems()
    {
        final Integer NUM_OPPTIES = 10;
        final Integer NUM_OLIS_PER = 7;
        final String DAIKIN_TOOLS_SOURCE = 'Daikin Tools';
        final String OPS_SOURCE = 'OPS';
        final String DT_STATUS = 'Test Status';
        final Integer SALES_ORDER_NUMBER = 12345;

        Account testAccount = TestingUtils.createAccounts( 1, 'Test Account', true )[0];

        DaikinToolsOpptyUpdateService.OpportunityUpdateRequest testRequest = new DaikinToolsOpptyUpdateService.OpportunityUpdateRequest();
        testRequest.Source = OPS_SOURCE;
        testRequest.Opportunities = new List<DaikinToolsOpptyUpdateService.Request_Opportunity>();

        List<Opportunity> testOpportunities = TestingUtils.createOpportunities( NUM_OPPTIES, testAccount.Id, false );
        Long counter = System.now().getTime();

        Product2 testProd = new Product2( Name = 'Test Prod' );
        insert testProd;

        for( Opportunity anOpportunity : testOpportunities )
        {
            anOpportunity.DST_ID__c = '' + counter++;
            anOpportunity.Bypass__c = TRUE;
            anOpportunity.PriceBook2Id = Test.getStandardPricebookId();
        }
        insert testOpportunities;

        Pricebookentry testPbe = new Pricebookentry();

        testPbe.Product2Id = testProd.Id;
        testPbe.Pricebook2Id = Test.getStandardPricebookId();
        testPbe.UnitPrice = 1;
        testPbe.IsActive = TRUE;

        insert testPbe;

        List<OpportunityLineItem> testOlis = new List<OpportunityLineItem>();

        for( Opportunity anOpportunity : testOpportunities )
        {
            DaikinToolsOpptyUpdateService.Request_Opportunity newOpportunity = new DaikinToolsOpptyUpdateService.Request_Opportunity();
            newOpportunity.JobGuid = anOpportunity.DST_ID__c;
            newOpportunity.SFDCID = anOpportunity.Id;
            newOpportunity.OrderStatus = DT_STATUS;
            newOpportunity.SalesOrderNumber = SALES_ORDER_NUMBER;
            newOpportunity.Addresses = new List<DaikinToolsOpptyUpdateService.Request_OpportunityAddress>{ DaikinToolsTestingUtils.createTestAddress( DaikinToolsTestingUtils.TEST_ADDRESS_TYPE_END ) };
            newOpportunity.SalesPeople = new List<DaikinToolsOpptyUpdateService.Request_OpportunitySalesPerson>{ DaikinToolsTestingUtils.createTestSalesPerson( DaikinToolsTestingUtils.TEST_SALESPERSON_INSIDE_TYPE ), DaikinToolsTestingUtils.createTestSalesPerson( DaikinToolsTestingUtils.TEST_SALESPERSON_OUTSIDE_TYPE )  };
            newOpportunity.Items = new List<DaikinToolsOpptyUpdateService.Request_OpportunityItem>{ DaikinToolsTestingUtils.createTestOLI(counter) };

            List<OpportunityLineItem>olisForOppty = Testingutils.createOpportunityLineItems (NUM_OLIS_PER, anOpportunity.Id, testPbe.Id, false);
            olisForOppty[0].DST_ID__c = '' + counter;

            testOlis.addAll( olisForOppty );

            testRequest.Opportunities.add( newOpportunity );
            counter++;
        }

        insert testOlis;

        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );

        Test.startTest();

            DaikinToolsOpptyUpdateService.DEFAULT_PRICEBOOK_ID = Test.getStandardPricebookId();
            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyUpdateService.doPost();

        Test.stopTest();

        List<Opportunity> updatedOpportunities = [ SELECT Id,
                                                    (SELECT DST_ID__c, OpportunityId
                                                            FROM OpportunityLineItems )
                                                   FROM Opportunity ];

        System.assertEquals( NUM_OPPTIES, updatedOpportunities.size(), 'There should be as many opportunities retrieved as were created' );

        for( Opportunity anOpportunity : updatedOpportunities )
        {
            System.assertEquals( NUM_OLIS_PER, anOpportunity.opportunityLineItems.size(), 'There should be one line item');
        }
    }

    /*
    *
    *
    *
    */
    static testMethod void testDoPostChangedModelNumber()
    {
        final String DAIKIN_TOOLS_SOURCE = 'Daikin Tools';
        final String DT_STATUS = 'Test Status';
        final Integer SALES_ORDER_NUMBER = 12345;
        final String OLD_PRODUCT_CODE = '56789';
        final String NEW_PRODUCT_CODE = '98765';
        final String TEST_OLI_DSTID = '000009';

        Account testAccount = TestingUtils.createAccounts( 1, 'Test Account', true )[0];

        DaikinToolsOpptyUpdateService.OpportunityUpdateRequest testRequest = new DaikinToolsOpptyUpdateService.OpportunityUpdateRequest();
        testRequest.Source = DAIKIN_TOOLS_SOURCE;
        testRequest.Opportunities = new List<DaikinToolsOpptyUpdateService.Request_Opportunity>();

        //insert old product code / model number
        Product2 testProd = TestingUtils.createProduct('Test Prod', new Map<String,Object>{'ProductCode' => OLD_PRODUCT_CODE} , true);
        Pricebookentry testPbe = TestingUtils.createPriceBookEntry(testProd.Id, 1, new Map<String, Object>{} ,true);

        Opportunity testOpportunity = TestingUtils.createOpportunities( 1, testAccount.Id, false )[0];
        Long counter = System.now().getTime();

        testOpportunity.DST_ID__c = '' + counter++;
        testOpportunity.Bypass__c = TRUE;
        testOpportunity.PriceBook2Id = Test.getStandardPricebookId();
        insert testOpportunity;

        OpportunityLineItem testOLI = TestingUtils.createOpportunityLineItems(1, testOpportunity.Id, testPbe.Id, false)[0];
        testOLI.DST_ID__c = TEST_OLI_DSTID;
        insert testOLI;

        // lets build the request
        DaikinToolsOpptyUpdateService.Request_Opportunity newOpportunity = new DaikinToolsOpptyUpdateService.Request_Opportunity();
        newOpportunity.JobGuid = testOpportunity.DST_ID__c;
        newOpportunity.SFDCID = testOpportunity.Id;

        DaikinToolsOpptyUpdateService.Request_OpportunityItem newOLI = DaikinToolsTestingUtils.createTestOLI(counter);
        newOLI.Guid = TEST_OLI_DSTID;
        newOLI.ModelNumber = NEW_PRODUCT_CODE;

        newOpportunity.Items = new List<DaikinToolsOpptyUpdateService.Request_OpportunityItem>{ newOLI };
        testRequest.Opportunities.add(newOpportunity);

        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );

        Test.startTest();
            DaikinToolsOpptyUpdateService.DEFAULT_PRICEBOOK_ID = Test.getStandardPricebookId();
            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyUpdateService.doPost();
        Test.stopTest();

        System.assert(ApexPages.getMessages().isEmpty(), 'Errors: '+ApexPages.getMessages());
        List<OpportunityLineItem> updatedOLI = [SELECT Id, DST_ID__c, PricebookEntry.Product2.ProductCode FROM OpportunityLineItem ];

       // List<Product2> allProducts = [SELECT Id, ProductCode FROM Product2];
       // System.debug('all products --> '+ allProducts);

        List<Product2> updatedProduct = [SELECT Id, ProductCode FROM Product2 WHERE Id != : testProd.Id];
        List<PricebookEntry> updatedPBE = [SELECT Id FROM PricebookEntry WHERE Id != : testPbe.Id AND Product2Id = : updatedProduct[0].ID];



        System.assertEquals(1, updatedOLI.size(), 'We should expect 1 OLI to have been created');
        System.assertEquals(TEST_OLI_DSTID, updatedOLI[0].DST_ID__c, 'The DST_ID__c should not change after the request is sent');
        System.assertEquals(NEW_PRODUCT_CODE, updatedOLI[0].PricebookEntry.Product2.ProductCode, 'The product code should have been updated to the new model number');

        System.assertEquals(1, updatedProduct.size(), 'We should expect 1 Product to have been created');
        System.assertEquals(NEW_PRODUCT_CODE, updatedProduct[0].ProductCode, 'The Product Code should have been updated to the new model number');

        System.assertEquals(1, updatedPBE.size(), 'We should expect 1 PBE to have been created');

    }

    static testMethod void testDoDelete()
    { /*
        final Integer NUM_OPPTIES = 10;
        final Integer NUM_OLIS_PER = 1;

        Account testAccount = TestingUtils.createAccounts( 1, 'Test Account', true )[0];

        DaikinToolsOpptyUpdateService.OpportunityUpdateRequest testRequest = new DaikinToolsOpptyUpdateService.OpportunityUpdateRequest();
        testRequest.Opportunities = new List<DaikinToolsOpptyUpdateService.Request_Opportunity>();

        //add fields to delete to the field set
        DaikinToolsOpptyUpdateService.fieldsToDeleteFromOppty.add('DST_ID__c');
        DaikinToolsOpptyUpdateService.fieldsToDeleteFromOppty.add('CustomerPurchaseOrderNumber__c');

        List<Opportunity> testOpportunities = TestingUtils.createOpportunities( NUM_OPPTIES, testAccount.Id, false );
        Long counter = System.now().getTime();

        Product2 testProd = new Product2( Name = 'Test Prod' );
        insert testProd;

        Pricebookentry testPbe = new Pricebookentry();

        testPbe.Product2Id = testProd.Id;
        testPbe.Pricebook2Id = Test.getStandardPricebookId();
        testPbe.UnitPrice = 1;
        testPbe.IsActive = TRUE;

        insert testPbe;

        List<OpportunityLineItem> testOlis = new List<OpportunityLineItem>();

        for( Opportunity anOpportunity : testOpportunities )
        {
            anOpportunity.DST_ID__c = '' + counter++;
            anOpportunity.Bypass__c = TRUE;
            anOpportunity.CustomerPurchaseOrderNumber__c = 'Test PO Num';
        }

        insert testOpportunities;


        for( Opportunity anOpportunity : testOpportunities )
        {
            DaikinToolsOpptyUpdateService.Request_Opportunity newOpportunity = new DaikinToolsOpptyUpdateService.Request_Opportunity();
            newOpportunity.JobGuid = anOpportunity.DST_ID__c;
            newOpportunity.SFDCID = anOpportunity.Id;
            testRequest.Opportunities.add( newOpportunity );

            List<OpportunityLineItem> olisForOppty = Testingutils.createOpportunityLineItems (NUM_OLIS_PER, anOpportunity.Id, testPbe.Id, false);
            testOlis.addAll( olisForOppty );
        }

        insert testOlis;

        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );

        Test.startTest();

            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyUpdateService.doDelete();

        Test.stopTest();

        List<Opportunity> updatedOpportunities = [ SELECT Id, DST_ID__c, CustomerPurchaseOrderNumber__c FROM Opportunity ];
        System.assertEquals( NUM_OPPTIES, updatedOpportunities.size(), 'There should be as many opportunities retrieved as were created' );
        for( Opportunity anOpportunity : updatedOpportunities )
        {
            System.assertEquals( null, anOpportunity.DST_ID__c, 'When passed through a Delete call the external id should have been deleted' );
            System.assertEquals( null, anOpportunity.CustomerPurchaseOrderNumber__c, 'When passed through a Delete call, all fields in Fields To Delete Field Set should be cleared out.');
        }

        List<OpportunityLineItem> updatedOLIs = [ SELECT Id, DST_ID__c FROM OpportunityLineItem ];
        System.assertEquals( NUM_OPPTIES * NUM_OLIS_PER, updatedOLIs.size(), 'There should be as many olis retrieved as were created' );
        for( OpportunityLineItem anOLI : updatedOLIs )
        {
            System.assertEquals( null, anOLI.DST_ID__c, 'When passed through a Delete call the external id should have been deleted' );
        } */
    }

    static testMethod void testDoDelete_SyncedQuoteFound()
    {
        final Integer NUM_OPPTIES = 1;
        final Integer NUM_OLIS_PER = 1;

        Account testAccount = TestingUtils.createAccounts( 1, 'Test Account', true )[0];

        DaikinToolsOpptyUpdateService.OpportunityUpdateRequest testRequest = new DaikinToolsOpptyUpdateService.OpportunityUpdateRequest();
        testRequest.Opportunities = new List<DaikinToolsOpptyUpdateService.Request_Opportunity>();

        //add fields to delete to the field set
        DaikinToolsOpptyUpdateService.fieldsToDeleteFromOppty.add('DST_ID__c');
        DaikinToolsOpptyUpdateService.fieldsToDeleteFromOppty.add('CustomerPurchaseOrderNumber__c');

        List<Opportunity> testOpportunities = TestingUtils.createOpportunities( NUM_OPPTIES, testAccount.Id, false );
        Long counter = System.now().getTime();

        Product2 testProd = new Product2( Name = 'Test Prod' );
        insert testProd;

        Pricebookentry testPbe = new Pricebookentry();

        testPbe.Product2Id = testProd.Id;
        testPbe.Pricebook2Id = Test.getStandardPricebookId();
        testPbe.UnitPrice = 1;
        testPbe.IsActive = TRUE;

        insert testPbe;

        List<OpportunityLineItem> testOlis = new List<OpportunityLineItem>();
        Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c();
        insert prop;
        
        for( Opportunity anOpportunity : testOpportunities )
        {
            anOpportunity.DST_ID__c = '' + counter++;
            anOpportunity.Bypass__c = TRUE;
            anOpportunity.CustomerPurchaseOrderNumber__c = 'Test PO Num';
            anOpportunity.Synced_Quote_Proposal__c = prop.id;
        }

        insert testOpportunities;

        for( Opportunity anOpportunity : testOpportunities )
        {
            DaikinToolsOpptyUpdateService.Request_Opportunity newOpportunity = new DaikinToolsOpptyUpdateService.Request_Opportunity();
            newOpportunity.JobGuid = anOpportunity.DST_ID__c;
            newOpportunity.SFDCID = anOpportunity.Id;
            testRequest.Opportunities.add( newOpportunity );

            List<OpportunityLineItem> olisForOppty = Testingutils.createOpportunityLineItems (NUM_OLIS_PER, anOpportunity.Id, testPbe.Id, false);
            for(OpportunityLineItem oli : olisForOppty){
                oli.DST_ID__c = ''+ counter++;
            }
            testOlis.addAll( olisForOppty );
        }

        insert testOlis;

        RestContext.request = new System.RestRequest();
        RestContext.request.requestBody = Blob.valueOf( JSON.serialize(testRequest) );

        Test.startTest();

            RestContext.response = new System.RestResponse();
            DaikinToolsOpptyUpdateService.doDelete();

        Test.stopTest();

        List<Opportunity> updatedOpportunities = [ SELECT Id, DST_ID__c, CustomerPurchaseOrderNumber__c FROM Opportunity ];
        System.assertEquals( NUM_OPPTIES, updatedOpportunities.size(), 'There should be as many opportunities retrieved as were created' );
        for( Opportunity anOpportunity : updatedOpportunities )
        {
            System.assertNotEquals( null, anOpportunity.DST_ID__c, 'When passed through a Delete call, but the Opp is synced to a quote, the external id should have not be deleted' );
            System.assertNotEquals( null, anOpportunity.CustomerPurchaseOrderNumber__c, 'When passed through a Delete call, but the Opp is synced to a quote, all fields in Fields To Delete Field Set should not be cleared out.');
        }

        List<OpportunityLineItem> updatedOLIs = [ SELECT Id, DST_ID__c FROM OpportunityLineItem ];
        System.assertEquals( NUM_OPPTIES * NUM_OLIS_PER, updatedOLIs.size(), 'There should be as many olis retrieved as were created' );
        for( OpportunityLineItem anOLI : updatedOLIs )
        {
            System.assertNotEquals( null, anOLI.DST_ID__c, 'When passed through a Delete call, but the Opp is synced with a quote, the external id should not have been deleted' );
        }
    }

}