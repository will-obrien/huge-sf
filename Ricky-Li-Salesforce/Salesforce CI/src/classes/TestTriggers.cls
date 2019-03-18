@isTest(SEEALLDATA=TRUE)
private class TestTriggers { 


    static testMethod void testCreateCaseComment(){
    Test.startTest();
        Account agency = TestCreateData.createAgency();
        
        Contact agent = TestCreateData.createAgent(agency);
        
        Booking__c booking1 = TestCreateData.createBooking(agent);
    
        // create base service    
        Service__c s1 = TestCreateData.createService(booking1);
        
        // create base case
        
        Case c = new Case(Subject='case subject', 
        				Reporting_Method__c = 'Incident Report',
        				Type = 'Transportation',
        				Sub_Type__c = 'Local Transportation',
        				Severity_of_Incident__c = '1 - Client Suggestions for service improvements',
        				Date_and_Time_Reported__c = Date.today() - 10,
        				Description = 'test description',
        				Case_Comments__c = 'test comments',
        				Service_Number__c = s1.Id);
        insert c;
        
        // refund due to complaint

        Service__c s2 = new Service__c(Name = 'Refund Due to Complaint (Post-travel)',
                              Service_Type__c = 'Fee',
                              Number_Of_Days__c = 6, Add_ons__c = false,
                              Service_Status__c = 'Confirmed',
                              Supplier_Style__c = 'Canada Goose',
                              Service_Level__c = 'Basic',
                              Gross__c = -1500,
                              Confirmation_Date_Exchange_Rate__c = 0.8,
                              CurrencyISOCode = 'USD',
                              Booking__c = booking1.Id,
                              Service_ID_2__c = 'A10000001',
                              Related_service_ID_2__c = s1.Id
                            );
        insert s2;
        
        // confirm that case comment exists.
        Set<String> serviceIds = new Set<String>();
        serviceIds.add(s2.Related_service_ID_2__c);
        
        Set<String> caseIds = new Set<String>();
        caseIds.add(c.Id);
        
        List <CaseComment> caseComments = [select CommentBody from CaseComment where ParentId in : caseIds];
        
        for (CaseComment cc: caseComments) {
            System.assertEquals(cc.CommentBody, 'Note: Refund was successfully issued!');
            
        }
        
        //System.assertEquals(c.Refund_Amount__c, -1500);
        //System.assertEquals(c.Refund_Currency__c, 'USD');
    
    // refund as per operations dept
    
    // refund to missed service
   Test.stopTest(); 
    }



    static testMethod void testBrochureRequest(){
    Test.startTest();
        Account agency = TestCreateData.createAgency();
        Contact agent = TestCreateData.createAgent(agency);
        
        System.assertEquals(agency.Id, agent.AccountId);
        Brochure_Request__c br = new Brochure_Request__c(Agent__c = agent.Id);
        
        insert br;
        br = [select Id, Name, AgencyAccount__c from Brochure_Request__c where Id = :br.Id];
        System.assertEquals(agency.Id, br.AgencyAccount__c);
        
        //test negative
        agent.Home_Based_Contact__c = TRUE;
        agent.MailingStreet = null;
        update agent;
        try{
        	update br;
        }catch(DmlException e){
        	System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
        }
        
        Account traveller = TestCreateData.createTraveller();
        Brochure_Request__c br2 = new Brochure_Request__c(Account__c = traveller.Id);
        insert br2;
        
        Lead ld = new Lead(FirstName='test', LastName='lead');
        insert ld;
        Brochure_Request__c br3 = new Brochure_Request__c(Lead__c = ld.Id);
        try{
        	insert br3;
        }catch(DmlException e){
        	System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
        }
        
 	Test.stopTest();       
    }


   
    static testMethod void testCampaignUpsert(){
    Test.startTest();
        Campaign c1 = new Campaign(Name = 'Test Campaign1', Campaign_Id__c = '238990',
                                    IsActive = true, 
                                    StartDate = Date.Today().addDays(-1), 
                                    EndDate = Date.today().addDays(30));
        insert c1;
        
        Campaign c2 = new Campaign(Name = 'Test Campaign2', Campaign_Id__c = '234',
                                    IsActive = true, 
                                    StartDate = Date.Today().addDays(-1), 
                                    EndDate = Date.today().addDays(30));
        insert c2;
        
        Account traveller = TestCreateData.createTraveller();
        Contact travellerContact = [select Id, AccountId from Contact where AccountId = : traveller.Id];
        
        System.debug('====>GAdv - TravellerContactId = ' + travellerContact.Id);
        CampaignMember cm1 = new CampaignMember(CampaignId = c1.Id, ContactId = travellerContact.Id);   
        insert cm1;
        
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Valid_Promotion__c from Account where Id = :traveller.Id];
        System.assertEquals(true, traveller.Valid_Promotion__c);
        
        CampaignMember cm2 = new CampaignMember(CampaignId = c2.Id, ContactId = travellerContact.Id);   
        insert cm2;
        
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Valid_Promotion__c from Account where Id = :traveller.Id];
        System.assertEquals(true, traveller.Valid_Promotion__c);
        
        c1 = [select Name, IsActive, StartDate, EndDate from Campaign where Id = :c1.Id];
        c1.IsActive = false;
        update c1;
        
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Valid_Promotion__c from Account where Id = :traveller.Id];
        System.assertEquals(true, traveller.Valid_Promotion__c);
        
        c2 = [select Name, IsActive, StartDate, EndDate from Campaign where Id = :c2.Id];
        c2.IsActive = false;
        update c2;
        
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Valid_Promotion__c from Account where Id = :traveller.Id];
        System.assertEquals(false, traveller.Valid_Promotion__c);
        
        c1.IsActive = true;
        update c1;
        
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Valid_Promotion__c from Account where Id = :traveller.Id];
        System.assertEquals(true, traveller.Valid_Promotion__c);
        
        c2.IsActive = true;
        update c2;
        
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Valid_Promotion__c from Account where Id = :traveller.Id];
        System.assertEquals(true, traveller.Valid_Promotion__c);
        
        delete c1;
        
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Valid_Promotion__c from Account where Id = :traveller.Id];
        System.assertEquals(true, traveller.Valid_Promotion__c);
        
        delete cm2;
        
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Valid_Promotion__c from Account where Id = :traveller.Id];
        System.assertEquals(false, traveller.Valid_Promotion__c);
    Test.StopTest();
    }
    
    
    /*
    --------------------------------------------------------------------------------------------------
     * This is to test the requirements to populate Traveller's summary fields
     * 1. Add_ons_c = if at least one Service__c.Add_ons__c
     * 2. Average_Tour_Price__c = (Sum of Gross_per_PAX_CAD__c / Number of Tours) of Confirmed "Tour" Services
     * 3. Average_Tour_Length__c = (Num_Of_Days__s / Number of Tours) of Confirmed "Tour" Services
     * 4. Booked_Air_In_the_Past__c = At least one Confirmed "Air" Service
     * 5. Lifetime_Value__c = Sum of Gross_per_PAX_CAD__c of Confirmed Services
     * 6. Number_of_Tours_c = Sum of Confirmed "Tour" Services
     * 7. Preferred_Comfort_Level_c = The highest occurences of Service_Level__c of Confirmed Services
     * 8. Preferred_Trip_Style_c = The highest occurences of Supplier_Style__c of Confirmed Services
    --------------------------------------------------------------------------------------------------
    */
    
    static testMethod void testServiceUpsert() {
    Test.StartTest();    
        RecordType rt = [select Id, Name from RecordType where Name = 'Traveller' limit 1];
        
        //1) Setup - Traveller, Agency, Agent, 3 Bookings, 
        Account traveller = new Account(RecordTypeId = rt.Id, 
                                            FirstName='John',          
                                            LastName = 'Doe',
                                            Salutation = 'Mr'                       
                                          );
        insert traveller;  
        traveller = [select Id, IsPersonAccount, Name, RecordTypeId, Add_ons__c
                         from Account where Id = :traveller.Id];
        
        rt = [select Id, Name from RecordType where Name = 'Agency' limit 1];
        
        Account agency = new Account(RecordTypeId = rt.Id,
                                            Name='SellOfVacation',          
                                          ShippingStreet = 'Hamilton Ave',
                                          ShippingCountry = 'US',
                                          ShippingState = 'NY',
                                          ShippingPostalCode = '10606',
                                          ShippingCity = 'White Plains',
                                          BillingCountry = 'US');
        insert agency;
        
        Contact agent = new Contact(FirstName = 'Lily', LastName = 'Smith', AccountId = agency.Id);
        insert agent;
        
        Booking__c booking1 = new Booking__c(Name = 'Test Booking #1', Agent__c = agent.Id);
        insert booking1;
        
        Booking__c booking2 = new Booking__c(Name = 'Test Booking #2', Agent__c = agent.Id);
        insert booking2;
        
        Booking__c booking3 = new Booking__c(Name = 'Test Booking #3',Agent__c = agent.Id);
        insert booking3;
        
        //Setup - Add 3 Services/TravellerServices to Traveller 
        //Add_Ons = all false, Trip Style = 2 Canada Goose, 1 Expedia
        List<Service__c> listServices = new List<Service__c>();
        List<TravellerServices__c> listTravellerServices = new List<TravellerServices__c>();
        
        Service__c s1 = new Service__c(Name = 'Test Service #1',
                                      Service_Type__c = 'Tour',
                                      Number_Of_Days__c = 6, Add_ons__c = false, 
                                      Service_Status__c = 'Confirmed',
                                      Supplier_Style__c = 'Canada Goose',
                                      Service_Level__c = 'Basic',
                                      Gross__c = 2000,
                                      Confirmation_Date_Exchange_Rate__c = 0.8,
                                      CurrencyISOCode = 'USD',
                                      Booking__c = booking1.Id
                                      );
        insert s1;
        
        Service__c s2 = new Service__c(Name = 'Test Service #2',
                              Service_Type__c = 'Tour',
                              Number_Of_Days__c = 6, Add_ons__c = false,
                              Service_Status__c = 'Confirmed',
                              Supplier_Style__c = 'Canada Goose',
                              Service_Level__c = 'Basic',
                              Gross__c = 1500,
                              Confirmation_Date_Exchange_Rate__c = 0.8,
                              CurrencyISOCode = 'USD',
                              Booking__c = booking2.Id
                            );
        insert s2;
        /*
        Service__c s3 = new Service__c(Name = 'Test Service #3',
                              Service_Type__c = 'Tour',
                              Number_Of_Days__c = 6, Add_ons__c = false,
                              Service_Status__c = 'Confirmed',
                              Supplier_Style__c = 'Expedia',
                              Service_Level__c = 'Basic',
                              Gross__c = 2500,
                              Confirmation_Date_Exchange_Rate__c = 1.1,
                              CurrencyISOCode = 'AUD',
                              Booking__c = booking3.Id
                            );
         
        insert s3;
        */
        
        TravellerServices__c ts1 = new TravellerServices__c(Service__c = s1.Id, 
                                                            Account__c = traveller.Id, Unique_Id__c = 'Z123456');
                                                            
        insert ts1;
        
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Preferred_Trip_Style__c, Lifetime_Value__c
                        , Preferred_Comfort_Level__c, Average_Tour_Price__c, Booked_Air_In_The_Past__c
                        from Account where Id = :traveller.Id];
        
        s1 = [select Id, CreatedDate, Number_Of_Days__c, Add_ons__c, Supplier_Style__c, Service_Level__c
                ,  Gross_CAD__c, Gross_per_PAX__c, Gross_per_PAX_CAD__c, 
                Gross__c, Confirmation_Date_Exchange_Rate__c   
                from Service__c where Id = : s1.Id];
        
            
        /*System.AssertEquals(s1.Add_Ons__c, traveller.Add_Ons__c);
        System.AssertEquals(s1.Gross_per_PAX_CAD__c, traveller.Average_Tour_Price__c);
        System.AssertEquals(s1.Number_Of_Days__c, traveller.Average_Tour_Length__c);
        System.AssertEquals(false, traveller.Booked_Air_in_the_Past__c);
        System.AssertEquals(s1.Gross_per_PAX_CAD__c, traveller.Lifetime_Value__c);
        System.AssertEquals(s1.Service_Level__c, traveller.Preferred_Comfort_Level__c);
        System.AssertEquals(s1.Supplier_Style__c, traveller.Preferred_Trip_Style__c);
        */
        
        TravellerServices__c ts2 = new TravellerServices__c(Service__c = s2.Id, 
                                                            Account__c = traveller.Id, Unique_Id__c = 'X123456');
                                                            
        insert ts2;
        
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Preferred_Trip_Style__c,Lifetime_Value__c
                        , Preferred_Comfort_Level__c, Average_Tour_Price__c 
                        from Account where Id = :traveller.Id];
        
        s2 = [select Id, CreatedDate, Number_Of_Days__c, Add_ons__c, Supplier_Style__c, Service_Level__c, Gross_CAD__c, Gross_per_PAX_CAD__c, 
                        Gross__c, Confirmation_Date_Exchange_Rate__c  
                        from Service__c where Id = : s2.Id];
                         
        /*
        System.AssertEquals(s1.Add_Ons__c, traveller.Add_Ons__c);
        System.AssertEquals(s1.Number_Of_Days__c, traveller.Average_Tour_Length__c);
        System.AssertEquals((s1.Gross_per_PAX_CAD__c + s2.Gross_per_PAX_CAD__c)/2, traveller.Average_Tour_Price__c);
        System.AssertEquals(s1.Gross_per_PAX_CAD__c + s2.Gross_per_PAX_CAD__c, traveller.Lifetime_Value__c);
        System.AssertEquals(s1.Service_Level__c, traveller.Preferred_Comfort_Level__c);
        System.AssertEquals(s1.Supplier_Style__c, traveller.Preferred_Trip_Style__c);
        */
        
        /*TravellerServices__c ts3 = new TravellerServices__c(Service__c = s3.Id, 
                                                            Account__c = traveller.Id, Unique_Id__c = 'Y123456');
        */                                                    
        //insert ts3;
        
        // ----- test insert triggers
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Preferred_Trip_Style__c, Preferred_Comfort_Level__c , Lifetime_Value__c
                        from Account where Id = :traveller.Id];
        
        /*s3 = [select Id, CreatedDate, Number_Of_Days__c, Add_ons__c , Supplier_Style__c, Service_Level__c
                    ,  Gross_CAD__c, Gross_per_PAX_CAD__c, Gross_per_PAX__c, Gross__c, Confirmation_Date_Exchange_Rate__c   
                from Service__c where Id = : s3.Id];
        */
        /*          
        System.AssertEquals((s1.Number_Of_Days__c + s2.Number_Of_Days__c + s3.Number_of_Days__c) / 3, traveller.Average_Tour_Length__c);
        System.AssertEquals(false, traveller.Add_ons__c);  
        System.AssertEquals((s1.Gross_per_PAX_CAD__c + s2.Gross_per_PAX_CAD__c + s3.Gross_per_PAX_CAD__c).round(), traveller.Lifetime_Value__c.round());
        
        System.assertEquals('Canada Goose', traveller.Preferred_Trip_Style__c);
        System.assertEquals('Basic', traveller.Preferred_Comfort_Level__c);
        */
        
        // ----- test update triggers
        s1.Number_of_Days__c = 3;
        s1.Service_Level__c = 'Comfort';
        s1.Supplier_Style__c = 'Expedia';
        update s1;
        
        
        s2.Add_ons__c = true;
        s2.Service_Level__c = 'Comfort';
        update s2;
        
        s1 = [select Id, Number_Of_Days__c, Add_ons__c from Service__c where Id = : s1.Id];
        s2 = [select Id, Number_Of_Days__c, Add_ons__c from Service__c where Id = : s2.Id];
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c, Preferred_Trip_Style__c, Preferred_Comfort_Level__c , Lifetime_Value__c
                        from Account where Id = :traveller.Id];
        
        
        /*
        System.AssertEquals((s1.Number_Of_Days__c + s2.Number_Of_Days__c + s3.Number_of_Days__c) / 3, traveller.Average_Tour_Length__c);
        System.AssertEquals(traveller.Add_ons__c, true); //false
        System.assertEquals('Expedia', traveller.Preferred_Trip_Style__c);
        System.assertEquals('Comfort', traveller.Preferred_Comfort_Level__c);
        */
        
        s1.Service_Type__c = 'Air';
        update s1;
        s1 = [select Id, Number_Of_Days__c, Add_ons__c from Service__c where Id = : s1.Id];
        traveller = [select Id, Booked_Air_in_the_Past__c, Average_Tour_Length__c, Add_ons__c, Preferred_Trip_Style__c, Preferred_Comfort_Level__c , Lifetime_Value__c
                        from Account where Id = :traveller.Id];
        
        System.AssertEquals(false, traveller.Booked_Air_in_the_Past__c);
        // changed to false after removing trigger.
        
        // ----- test delete triggers
        delete ts2;
        delete s2;
        traveller = [select Id, Average_Tour_Length__c, Add_ons__c from Account where Id = :traveller.Id];
        System.AssertEquals(traveller.Add_ons__c, false); //false
        
    Test.stopTest();                             
    }
    
   
   
    /*
    --------------------------------------------------------------------------------------
     * This is to test the requirement to populate Account.Working_With_Since_c for Agency
     * 10. Account.Working_With_Since_c = the oldest Booking__c.CreatedDate
    --------------------------------------------------------------------------------------
    */
    static testMethod void testBookingInsert() {
    Test.StartTest();     
        //Booking OnAfterInsert
        
        RecordType rt = [select Id, Name from RecordType where Name = 'Agency' limit 1];
        Account agency = new Account(RecordTypeId = rt.Id,
                                            Name='SellOfVacation',          
                                          ShippingStreet = 'Hamilton Ave',
                                          ShippingCountry = 'US',
                                          ShippingState = 'NY',
                                          ShippingPostalCode = '10606',
                                          ShippingCity = 'White Plains', BillingCountry = 'US');
        insert agency;
        
        Contact agent = new Contact(FirstName = 'Lily', LastName = 'Smith', AccountId = agency.Id);
        insert agent;
        
        Booking__c booking1 = new Booking__c(Name = 'Test Booking #1',
                                            Agent__c = agent.Id);
        insert booking1;
        
        booking1 = [select Id, createdDate from Booking__c where Id = : booking1.Id];
        
        agency = [select Id, Working_with_Since__c from Account where Id = : agency.Id];
        //System.AssertEquals(agency.Working_with_Since__c, booking1.createddate);
                    
        Booking__c booking2 = new Booking__c(Name = 'Test Booking #2',
                                            Agent__c = agent.Id); 
        insert booking2;
        booking2 = [select Id, createdDate from Booking__c where Id = : booking2.Id];
        
        agency = [select Id, Working_with_Since__c from Account where Id = : agency.Id];
        //System.AssertEquals(agency.Working_with_Since__c, booking1.createddate);
   
   Test.stopTest();
    }
    
    static testMethod void testTFN_BeforeInsertUpdate() {
        Test.StartTest();
        TFN_Carrier__c tfnCarrier = new TFN_Carrier__c(name='ATMTEST', Email__c = 'servicetest@atms.at', First_Name__c='test', Last_Name__c='carier', Phone_Number__c= ' +43 1 2145123-0');
        insert tfnCarrier;
        Toll_Free_Number__c tfn = new Toll_Free_Number__c(TFN_Carrier__c = tfnCarrier.Id, name = '18001231234', Local_Number__c = '6471231234', Phone_Number__c = '18001231234');
        insert tfn;
        Toll_Free_Number__c tfn2 = new Toll_Free_Number__c(TFN_Carrier__c = tfnCarrier.Id, name = '18001231235', Local_Number__c = '6471231234', Phone_Number__c = '18001231235');
        insert tfn2;
        
        //negative test
        Toll_Free_Number__c tfn3 = new Toll_Free_Number__c(TFN_Carrier__c = tfnCarrier.Id, name = '18001231234', Local_Number__c = '6471231234', Phone_Number__c = '18001231234');
        try{
        	insert tfn3;
        }catch(DmlException e){
        }
        
        Test.stopTest();        
    }
    
    static testMethod void testCampaign_BeforeInsertUpdate() {
        Test.StartTest();
        TFN_Carrier__c tfnCarrier = new TFN_Carrier__c(name='ATMTEST', Email__c = 'servicetest@atms.at', First_Name__c='test', Last_Name__c='carier', Phone_Number__c= ' +43 1 2145123-0');
        insert tfnCarrier;
        Toll_Free_Number__c tfn = new Toll_Free_Number__c(TFN_Carrier__c = tfnCarrier.Id, name = '18001231234', Local_Number__c = '6471231234', Phone_Number__c = '18001231234');
        insert tfn;
        Date myDate = date.newinstance(2013, 2, 17);
        Campaign c = new Campaign(isActive = true, name = 'test campaign', campaign_id__c = '1234567', Toll_Free_Number__c = tfn.Id, StartDate = mydate - 1, EndDate = mydate +1, Wind_down_Days__c = null);        
        insert c;        
        
        Campaign c1 = new Campaign(name = 'test campaign 1', campaign_id__c = '1234568');
        insert c1;
        
        Campaign c2 = new Campaign(name = 'test campaign', campaign_id__c = '1234569', Toll_Free_Number__c = tfn.Id, StartDate = mydate - 1, EndDate = mydate +1, Wind_down_Days__c = null);
        try{
        	insert c2;
        }catch(DmlException e){
        	System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));        	
        }
        
        Test.stopTest();
    }
 
    static testMethod void testFeedItemAfterInsert() {
        Test.StartTest();
        GNationLive__c GNationLive = new GNationLive__c(Name='GStock13 Test1',Group_Id__c='0F9a0000000CyzO',refresh_time__c=5);       
        insert GNationLive;
        FeedItem newFi = new FeedItem(Body='Body Testing',ParentId='0F9a0000000CyzO');
        insert newFi;
        Test.stopTest();        
    }     
    
    static testMethod void testFeedCommentAfterInsert() {
        Test.StartTest();
        GNationLive__c GNationLive = new GNationLive__c(Name='GStock13 Test2',Group_Id__c='0F9a0000000CyzO',refresh_time__c=5);       
        insert GNationLive;
        FeedItem newFi = new FeedItem(Body='Body Testing',ParentId='0F9a0000000CyzO');
        insert newFi;      
        FeedComment newFc = new FeedComment(CommentBody='Comment Body ' + TwitterClient.hashTag + 'Gnation', FeedItemId=newFi.Id);
        insert newFc;
        
        FeedItem newFi1 = new FeedItem(Type = 'LinkPost', LinkUrl = 'test.com', Body='Body Testing 2',ParentId='0F9a0000000CyzO');
        insert newFi1;      
        FeedComment newFc1 = new FeedComment(CommentBody='Comment Link Post', FeedItemId=newFi1.Id);
        insert newFc1;

		FeedItem newFi2 = new FeedItem(Type = 'LinkPost', LinkUrl = 'test.com', Body='Body Testing ' + TwitterClient.hashTag + 'Gnation',ParentId='0F9a0000000CyzO');
        insert newFi2;
        
        FeedItem newFi3 = new FeedItem(Type = 'LinkPost', LinkUrl = 'test.com' + TwitterClient.hashTag + 'Gnation', Body= TwitterClient.hashTag,ParentId='0F9a0000000CyzO');
        insert newFi3;
        
        FeedItem newFi4 = new FeedItem(Type = 'ContentPost', ContentFileName='test.jpg', ContentData=EncodingUtil.base64Decode('testtest'), Body='Body Testing ' + TwitterClient.hashTag + 'Gnation',ParentId='0F9a0000000CyzO');
        insert newFi4;
        
        FeedItem newFi5 = new FeedItem(Type = 'ContentPost', ContentFileName='test.txt', ContentData=EncodingUtil.base64Decode('testtest'), Body= TwitterClient.hashTag,ParentId='0F9a0000000CyzO');
        insert newFi5;
		
        Test.stopTest();        
    }   
    
    static testMethod void testUpdateTEHS_AfterAccountInsertUpdate() {
        Test.StartTest();
        RecordType rt = [select Id, Name from RecordType where Name = 'Traveller' limit 1];
        Account traveller = new Account(RecordTypeId = rt.Id, 
                                            FirstName='John',          
                                            LastName = 'Doe',
                                            Salutation = 'Mr'                       
                                          );
        insert traveller;
        
        Account traveller2 = TestCreateData.createTraveller();
        traveller2.Evaluation_Email__c = 'test@gadventures.com';
        update traveller2;
        
        Tour_Evaluation__c te = new Tour_Evaluation__c(Account__c = traveller2.Id);
        insert te;
        Tour_Evaluation_Historical_Summary__c tehs = new Tour_Evaluation_Historical_Summary__c
        							(Tour_Evaluation__c = te.Id, Error__c = 'no evaluation email on file');
        insert tehs;
        update traveller2;
        
        Test.stopTest(); 
    }
    
    static testMethod void testAccountBeforeDelete() {
    	Test.startTest();
    	
    	Account agency = TestCreateData.createAgency();
    	Account agencyWinner = TestCreateData.createAgency();    	
    	
    	Contact agent = TestCreateData.createAgent(agencyWinner);
    	Booking__c booking = TestCreateData.createBooking(agent);
    	Service__c service = TestCreateData.createService(booking);
    	
    	Account travellerWinner = TestCreateData.createTraveller();
    	Account travellerLoser = TestCreateData.createTraveller();
    	
    	TravellerServices__c ts = new TravellerServices__c(Unique_ID__c = 'TS-'+service.Id, Service__c = service.Id, Account__c = travellerWinner.Id);
    	insert ts;
    	
    	update agencyWinner;
    	
    	Account agencyLose = TestCreateData.createAgency();
    	try{
    		merge agencyWinner agencyLose;
    	}catch(DmlException e){}
    	
    	try{
    		merge travellerWinner travellerLoser;
    	}catch(DmlException e){}
    	
    	Account agencyIndependent = TestCreateData.createAgency();
    	delete agencyIndependent;
    	
    	Test.stopTest();
    }
    
    static testMethod void testBrochureRequestAccountContact(){
    Test.startTest();
        Account agency = TestCreateData.createAgency();
        Contact agent = TestCreateData.createAgent(agency);
		
        Brochure_Request__c br = new Brochure_Request__c(agent__c = agent.Id);
                
        insert br;
        br = [select Id, Name, AgencyAccount__c from Brochure_Request__c where Id = :br.Id];
        agency.BillingCountry = 'Canada';
        update agency;
        update br;
        
        agency.BillingCountry = 'testNullCountry';
        update agency;
        update br;
        
        agency.BillingCountry = 'TT';
        update agency;
        update br;
        
        
        Account traveller = TestCreateData.createTraveller();
        Brochure_Request__c br2 = new Brochure_Request__c(Account__c = traveller.Id);
        insert br2;
        
        traveller.BillingCountry = 'testNullCountry';
        update traveller;
        update br2;
        
        traveller.BillingCountry = 'CA';
        update traveller;
        update br2;
        
        traveller.BillingCountry = 'TT';
        update traveller;
        update br2;
        
        /* Contact */
        agent.MailingCountry = 'Canada';
		update agent;
		
		agent.MailingCountry = 'testNullCountry';
		update agent;
		
		agent.MailingCountry = 'TT';
		update agent;
		
		agent.MailingCountry = 'CA';
		update agent;
		
		agent.OtherCountry = 'Canada';
		update agent;		
		
		agent.OtherCountry = 'testNullCountry';
		update agent;
		
		agent.OtherCountry = 'TT';
		update agent;
		
		agent.OtherCountry = 'CA';
		update agent; 
		
		agent.MailingCountry = null;
		agent.OtherCountry = null;
		agency.BillingCountry = 'Canada';
		update agency;
		update agent;
		
		agency.BillingCountry = 'testNullCountry';
		update agency;
		update agent;
		
		agency.BillingCountry = 'TT';
		update agency;
		update agent;		
   
 	Test.stopTest();       
    }
    
    static testMethod void testCopyValueAfterAccountUpdate(){
    Test.startTest();
    	Sub_Territory__c st = new Sub_Territory__c(Name = 'Canada - GTA');
    	insert st;
    	Account acct = TestCreateData.createTraveller();
    	acct.Workflow_Sub_Territory__c = st.Id;
    	update acct;
    	
    	Sub_Territory__c st1 = new Sub_Territory__c(Name = 'Canada - Toronto');    	
    	insert st1;
    	Account acct1 = TestCreateData.createAgency();
    	acct1.Sub_Territory__c = st1.Id;
    	update acct;
    	acct1.Sub_Territory__c = st.Id;
    	update acct;
    Test.stopTest();
    }
    
    static testMethod void testCreateUser(){
    Test.startTest();
    	User mike = new User();
		mike.Username= 'amike.white@company.com';
		mike.Email = 'rickyl@gadventures.com';
		mike.Lastname = 'mike';
		mike.Firstname = 'white';
		mike.Alias = 'amwhite';
		mike.CommunityNickname = 'amwhite01';
		mike.ProfileId = '00e30000001oqfR';
		
		mike.CurrencyIsoCode = 'USD';
		mike.TimeZoneSidKey = 'GMT';
		mike.LocaleSidKey = 'en_US';
		mike.EmailEncodingKey = 'ISO-8859-1';
		mike.LanguageLocaleKey = 'en_US';
		mike.UserPermissionsMobileUser = false;

		insert mike;
    Test.stopTest();
    }
    
}