@isTest (seealldata=true)
private class PGI_Utility_Test {
    static testMethod void testCreateOpporLicemseSet() {
            /*insert new BypassRules__C(  Disable_Triggers__c= true, 
                Disable_Validation_Rules__c = true,
                Disable_Workflow_Rules__c = true,https://cs23.salesforce.com/_ui/common/apex/debug/ApexCSIPage#
                trigger_Objects__c = 'Opportunity,Account,Lead,Contact',
                name = userinfo.getuserid()
            );*/
            //User u2 = [SELECT Id FROM User WHERE Alias='vvall'];
            User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
            System.RunAs(u2){
                Test.startTest();
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
            licSet.name                 = 'Lic Set -1';
            insert licSet;
            
            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;
            
            //Update lead for conversion
            ld.ECommerce_Convert__c= true;
            ld.LeadSource = 'ECommerce Customer';
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

            OpportunityEventHandler.skipExecution = false;
            oppor.Opp_Stage__c = 'Closed Won';
            oppor.ECommerce_Convert__c = true;
            update oppor;
            
            Test.StopTest();
        }
    }
    static testMethod void testCreateOpporAssets() {
        User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
        System.RunAs(u2){   
            Test.StartTest();
            
            Account act = new account(Name = 'Test Acc', Ecommerce_account_number__c = 'Ecomm-0001', Z_Source__c = 'eCommerce');
            insert act;
            
            System.assert(act.id <> null);
            
            Contact ct = new Contact();
            ct.FirstName = 'First ct';
            ct.LastName  = 'Last ct';
            ct.Phone     = '2002012011';
            ct.Email     = 'create@premierglobal.com';
            ct.accountId = act.id;
            ct.License_Profile__c = true;
            insert ct;
            
            Contact ct2 = new Contact();
            ct2.FirstName = 'First ct';
            ct2.LastName  = 'Last ct';
            ct2.Phone     = '2002012011';
            ct2.Email     = 'create@premierglobal.com';
            ct2.accountId = act.id;
            ct2.License_Profile__c = true;
            insert ct2;
               
            String JsonMsg = '';
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();            
            RestContext.request = req;
            RestContext.response= res;
            
            req.requestURI = '/services/apexrest/ContactsOperation/'+act.id;  //Request URL
            req.httpMethod = 'GET';//HTTP Request Type
            req.requestBody = Blob.valueof(JsonMsg);
            
            RestContext.request = req;
            RestContext.response= res;
            //try{
                ContactsOperation.retrieveContacts();           
            //}
            //catch(Exception e){}
            
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
            licSet.name                 = 'Lic Set -1';
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

            Opportunity opporConv = new opportunity( id = [select id,opportunity__c from licenseset__c where id= :licSet.id limit 1].opportunity__c);
            Opportunity oppor = opporConv.clone();
            oppor.name = 'Test oppor-1';
            oppor.stagename = 'Open';
            oppor.closeDate= system.today().addDays(100);
            oppor.ECommerce_Account_Number__c = 'Ecom-000000001';
            oppor.accountid = null;
            oppor.Z_Source__c = 'eCommerce';
            insert oppor;

            oppor.accountid = act.id;
            update oppor;
                        
            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;        
            
            licset.opportunity__c = oppor.id;            
            licset.companyid__c = '201201';
            licset.hubid__c     = '301301';
            update licset;

            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;

            oppor.Opp_Stage__c = 'Closed Won';
            oppor.ECommerce_Convert__c = true;
            update oppor;
                        
            Test.stopTest();
        }
    }
    static testMethod void testCreateOpporContracts() {
        User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
        System.RunAs(u2){   
            Test.startTest();
            Account act = new account(Name = 'Test Acc', Ecommerce_account_number__c = 'Ecomm-0001', Z_Source__c = 'eCommerce');
            insert act;
            System.assert(act.id <> null);
            
            Contact ct = new Contact();
            ct.FirstName = 'First ct';
            ct.LastName  = 'Last ct';
            ct.Phone     = '2002012011';
            ct.Email     = 'create@premierglobal.com';
            ct.accountId = act.id;
            ct.License_Profile__c = true;
            insert ct;
            
            Contact ct2 = new Contact();
            ct2.FirstName = 'First ct';
            ct2.LastName  = 'Last ct';
            ct2.Phone     = '2002012011';
            ct2.Email     = 'create@premierglobal.com';
            ct2.accountId = act.id;
            ct2.License_Profile__c = true;
            insert ct2;
               
            String JsonMsg = '';
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();            
            RestContext.request = req;
            RestContext.response= res;
            
            req.requestURI = '/services/apexrest/ContactsOperation/'+act.id;  //Request URL
            req.httpMethod = 'GET';//HTTP Request Type
            req.requestBody = Blob.valueof(JsonMsg);
            
            RestContext.request = req;
            RestContext.response= res;
          
            ContactsOperation.retrieveContacts();           
          
            
            Lead ld = new Lead(
                FirstName = 'Test Queue Lead',
                LastName = 'Owner Update',
                Phone = '2222012011',
                Email = 'LeadQueueOwner@pgi.com',
                ECommerce_Account_Number__c = 'Ecom-100000001',
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
            licSet.name                 = 'Lic Set -1';
            insert licSet;

            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;            

            //Update lead for conversion
            ld.ECommerce_Convert__c= true;
            
            update ld;
            
            lead convertedLead = [select id, name, isconverted, convertedOpportunityId from lead where id = :ld.id];
            system.assert(convertedLead.isConverted == true);
            
            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;
            
            licset.opportunity__c = convertedLead.convertedOpportunityId;
            licset.companyid__c = '201201';
            licset.hubid__c     = '301301';
            update licset;    

            LeadEventHandler.skipAfterEvent         = false;
            OpportunityEventHandler.skipExecution   = false;
            LicensesetEventHandler.skipAfterEvent   = false;

            Opportunity opporConv = new opportunity( id = convertedLead.convertedOpportunityId);
            
            opporConv.Opp_Stage__c = 'Closed Won';
            opporConv.ECommerce_Convert__c = true;
            update opporConv;
            
            Test.StopTest();
        }
    }   
}