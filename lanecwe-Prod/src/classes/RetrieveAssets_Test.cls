@isTest (seealldata=true)
private class RetrieveAssets_Test {
    static testMethod void testRetrieveAssets() {
        //User u2 = [SELECT Id FROM User WHERE Alias='vvall'];
        User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
        System.RunAs(u2){  
           Test.StartTest();
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
                    Street = '1500 Main Street',
                    City = 'SanJose',
                    State = 'CA',
                    PostalCode = '95802',
                    Country = 'USA',
                    Business_Type__c = 1,
                    DoNotSolicit__c = true,
               		Z_Source__c  ='eCommerce'
                );

            insert ld;
            LeadEventHandler.skipAfterEvent = false;
            OpportunityEventHandler.skipExecution = false;
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
            licSet.name                 = 'Lic Set -1';
            licSet.Z_Source__c  		='eCommerce';

            insert licSet;

            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;
            //Update lead for conversion
            ld.ECommerce_Convert__c= true;
            OpportunityEventHandler.skipExecution = false;
            update ld;
            
            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;
            
            Licenseset__c licsets = [select id,opportunity__c,opportunity__r.accountid  from licenseset__c where id= :licSet.id limit 1];
            
            Opportunity opporConv = new opportunity( id = licsets.opportunity__c);
            Opportunity oppor = opporConv.clone();
            oppor.name = 'Test oppor-1';
            oppor.stagename = 'Open';
            oppor.closeDate= system.today().addDays(100);
            oppor.ECommerce_Account_Number__c = 'Ecom-000000001';
            oppor.accountid = licsets.opportunity__r.accountid;
            oppor.Z_Source__c  		='eCommerce';
            insert oppor;
            
            OpportunityEventHandler.skipExecution = false;
            oppor.Opp_Stage__c = 'Closed Won';
            oppor.ECommerce_Convert__c = true;
            update oppor;
            
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;        
            
            licset.companyid__c = '201201';
            licset.hubid__c     = '301301';
            update licSet;
            /*
            RetrieveAssets.AssetsRequest astsReq = new RetrieveAssets.AssetsRequest();
            astsReq.accountId = licsets.opportunity__r.accountid;
            astsReq.transactionId = 'T-0000001';
            String jsonMsg = JSON.serialize(astsReq);*/

            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/RetrieveAssets/'+licsets.opportunity__r.accountid;  //Request URL
            req.httpMethod = 'GET';//HTTP Request Type
            //req.requestBody = Blob.valueof(jsonMsg);
            
            RestContext.request = req;
            RestContext.response= res;
            
            RetrieveAssets.retrieveRecord();
            Test.StopTest();
        }
            
    }
}