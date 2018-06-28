@isTest (SeeAllData = true)
//@isTest
private class OpportunityEventHandler_Test {
    static testMethod void testOpporAccountIdUpdate() {
            //User u2 = [SELECT Id FROM User WHERE Alias='vvall'];
        User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
        System.RunAs(u2){  
                Test.startTest();
            map<id, PriceBookEntry> usdPriceBookEntryMap = new map<id, PriceBookEntry>(
                            [select id, name, currencyisocode from pricebookentry where currencyisocode='USD']);
            
            list<Product_Mappings__c> prodMappingLst = [Select  Source_Product_Name__c, 
                                                         SFDC_Product_Name__c, SFDC_Product_ID__c, 
                                                         SFDC_PB_Entry_ID__c, Name, Id 
                                                        From Product_Mappings__c where SFDC_PB_Entry_Id__c in : usdPriceBookEntryMap.keySet() limit 10];
                                                        
            system.assert(prodMappingLst <> null && prodMappingLst.size() >0);                
                
                Lead ld = new Lead(
                    FirstName = 'Test Queue Lead',
                    LastName = 'Owner Update',
                    Phone = '2222012011',
                    Email = 'LeadQueueOwner@pgi.com',
                    ECommerce_Account_Number__c = 'Ecom-000000001',
                    ECommerce_Convert__c = false,
                    LeadSource = 'ECommerce Customer',
                    Company = 'Pfiz I',
                    ChannelType__c = 'Direct',
                    Status = 'Qualifying',
                    Product_Interest__c = 'Web:iMeet',
                    Street = '1500 Main Street',
                    City = 'SanJose',
                    State = 'CA',
                    PostalCode = '95802',
                    Country = 'USA',
                    Business_Type__c = 1,
                    DoNotSolicit__c = true,
                    Z_Source__c = 'eCommerce'
                );

            insert ld;

            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;
            
           // Load the test Offerings from the static resource
            List<sObject> ls = Test.loadData(Offerings__c.sObjectType, 'TestDataOfferings');
            // Verify that all 3 test accounts were created
            System.assert(ls.size() > 0);

            // Get first test Offerings
            Offerings__c ofrngs = (Offerings__c)ls[0];
        
            // Insert offerings
            Licenseset__c licSet        = new Licenseset__c();
            licSet.Description__c       = 'Lic Set - 1';
            licSet.End_Date__c          = system.today().adddays(100);
            licSet.Enterprise_Name__c   = ofrngs.id;
            licSet.Lead__c              = ld.id;
            licSet.Line_Number__c       = 1;
            licSet.Number_of_Licensed_Named_Users__c = 1;
            licSet.Order_Number__c      = 1;
            licSet.Price__c             = 12.22;
            licSet.SKU__c               = 'SKU-000000001';
            licSet.Start_Date__c        = system.today();
            licSet.Subscription_License_Term_Months__c = 12;
            licSet.name                 = prodMappingLst[0].Source_Product_Name__c;
            licSet.Z_Source__c 			= 'eCommerce';
            
            insert licSet;
                        
            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;
            
            //Update lead for conversion
            ld.ECommerce_Convert__c= true;
            update ld;
            
            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;

            Opportunity opporConv = new opportunity( id = [select id,opportunity__c from licenseset__c where id= :licSet.id limit 1].opportunity__c);
            Opportunity oppor = opporConv.clone();
            oppor.name = 'Test oppor-1';
            oppor.stagename = 'Open';
            oppor.closeDate= system.today().addDays(100);
            oppor.ECommerce_Account_Number__c = 'Ecom-000000001';
            oppor.accountid = null;
            oppor.Z_Source__c = 'eCommerce';
            insert oppor;
            
            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;
            
            licset.Opportunity__c       = oppor.id;
            update licSet;
            
            oppor.Opp_Stage__c = 'Closed Won';
            oppor.ECommerce_Convert__c = true;
            update oppor;

            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;
            system.assert(oppor.Id <> null);
            delete oppor;
        }
    }
    
    static testMethod void testOpporCreationOnLeadConversion() {
        
        User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
        System.RunAs(u2){  
            Test.StartTest();

            map<id, PriceBookEntry> usdPriceBookEntryMap = new map<id, PriceBookEntry>(
                            [select id, name, currencyisocode from pricebookentry where currencyisocode='USD']);
            
            list<Product_Mappings__c> prodMappingLst = [Select  Source_Product_Name__c, 
                                                         SFDC_Product_Name__c, SFDC_Product_ID__c, 
                                                         SFDC_PB_Entry_ID__c, Name, Id 
                                                        From Product_Mappings__c where SFDC_PB_Entry_Id__c in : usdPriceBookEntryMap.keySet() limit 10];
                                                        
            system.assert(prodMappingLst <> null && prodMappingLst.size() >0);
                        
            Lead ld = new Lead(
                    FirstName = 'Test Queue Lead',
                    LastName = 'Owner Update',
                    Phone = '2222012011',
                    Email = 'LeadQueueOwner@pgi.com',
                    ECommerce_Account_Number__c = 'Ecom-000000001',
                    ECommerce_Convert__c = false,
                    LeadSource = 'ECommerce Customer',
                    Product_Interest__c = 'Web:iMeet',
                    Company = 'Pfiz I',
                    ChannelType__c = 'Direct',
                    Status = 'Qualifying',
                    Street = '1500 Main Street',
                    City = 'SanJose',
                    State = 'CA',
                    PostalCode = '95802',
                    Country = 'USA',
                    Business_Type__c = 1,
                    DoNotSolicit__c = true,
                    Z_Source__c = 'eCommerce'
                );

            insert ld;
            
            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;

           // Load the test Offerings from the static resource
            List<sObject> ls = Test.loadData(Offerings__c.sObjectType, 'TestDataOfferings');
            // Verify that all 3 test accounts were created
            System.assert(ls.size() > 0);

            // Get first test Offerings
            Offerings__c ofrngs = (Offerings__c)ls[0];

            // Insert offerings
            Licenseset__c licSet        = new Licenseset__c();
            licSet.Description__c       = 'Lic Set - 1';
            licSet.End_Date__c          = system.today().adddays(100);
            licSet.Enterprise_Name__c   = ofrngs.id;
            licSet.Lead__c              = ld.id;
            licSet.Line_Number__c       = 1;
            licSet.Number_of_Licensed_Named_Users__c = 1;
            licSet.Order_Number__c      = 1;
            licSet.Price__c             = 12.22;
            licSet.SKU__c               = 'SKU-000000001';
            licSet.Start_Date__c        = system.today();
            licSet.Subscription_License_Term_Months__c = 12;
            licSet.name                 = prodMappingLst[0].Source_Product_Name__c;
            licSet.Z_Source__c 			= 'eCommerce';
            insert licSet;
            
            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;

            //Update lead for conversion
            ld.ECommerce_Convert__c= true;
            update ld;

            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;

            String opporId = [select id,opportunity__c from licenseset__c where id= :licSet.id limit 1].opportunity__c;
            system.assert(opporId <> null);
            delete (new opportunity(id=opporId));
            Test.StopTest();
        }
    }
    
    static testMethod void testSetOpportunityScorecardFields(){
    	Test.startTest();
    	User testUser = PGITestUtilities.getTestUser();
    	insert testUser;
    	Opportunity testOpp = PGITestUtilities.getOpportunityDetails();
    	insert testOpp;
    	GCS_Acq_Opportunity_Scorecard__c testOppScorecard = PGITestUtilities.getOpportunityScorecardDetails(testOpp);
    	insert testOppScorecard;
    	
    	testOpp.OwnerId = testUser.Id;
    	update testOpp;
    	Test.stopTest();
    	
    	GCS_Acq_Opportunity_Scorecard__c result = [SELECT OwnerId FROM GCS_Acq_Opportunity_Scorecard__c WHERE Id =: testOppScorecard.Id];
    	system.assertEquals(result.OwnerId, testOpp.OwnerId);
    }
    
    static testMethod void testValidateRampDates(){
    	Test.startTest();
    	User testGCSuser = PGITestUtilities.getTestUser();
    	insert testGCSuser;
    	PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Label = 'GCS: Read-Write Fields'];
    	PermissionSetAssignment permissionSetA = new PermissionSetAssignment(PermissionSetId = permissionSet.Id, AssigneeId = testGCSuser.Id);
    	insert permissionSetA;
    	System.runAs(testGCSuser){
	    	Opportunity testOpp = PGITestUtilities.getOpportunityDetails();
	    	insert testOpp;
	    	Product2 testProd = PGITestUtilities.getStdProduct();
	    	insert testProd;
	    	PricebookEntry testPbe = PGITestUtilities.CreatePriceBookEntryForProduct(testProd);
	    	insert testPbe;
	    	OpportunityLineItem testOpli = PGITestUtilities.getOpportunityLineItemDetails(testOpp.Id, testPbe.Id);
	    	insert testOpli;
	    	try{
		    	testOpp.Prob_Input__c = '90';
		    	update testOpp;
		    	system.assert(false);
	    	}
	    	catch(Exception ex){
	    		system.assert(true);
	    	}
	    	
	    	testOpli.Initial_Bill_Date__c = system.today();
	    	testOpli.X100_Ramp_Date__c = system.today();
	    	update testOpli;
	    	testOpp.Prob_Input__c = '90';
	    	testOpp.Opp_Stage__c = 'Closed Won';
	    	testOpp.Primary_Won_Reason__c = 'Budget Available';
	    	testOpp.Competitor_s__c = 'PGi';
	    	testOpp.Incumbent__c = 'PGi';
	    	update testOpp;
    	}
    	Test.stopTest();
    }
}