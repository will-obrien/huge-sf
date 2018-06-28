@isTest
public class HqIntegrationTests {

    @testSetup
    static void setupCustomSetting() {
        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
        insert settings;

        CommcareToSalesforceSettings__c testCustomSetting = new CommcareToSalesforceSettings__c();
        testCustomSetting.CommCare_User_Name__c = 'CommCareUserName@gmail.com';
        testCustomSetting.CommCare_Password__c = 'CommCarePassword';
        testCustomSetting.Server_URL__c = 'https://www.commcarehq.org/hq/admin/api/global/';
        testCustomSetting.Skip_in_batch_job__c = false;
        testCustomSetting.API_Limit_Parameter__c = 10;
        testCustomSetting.Name = 'CommCare HQ';
        insert testCustomSetting;
    }

    /*@isTest
    static void shouldDeactivateDoubleSubscriptions() {
        Domain__c domain1 = new Domain__c(Name = 'Sample 1', Server_Name__c = 'CommCare HQ', is_test__c = 'false', cpIsActive__c = true,
                                          Wam__c = 15, cpActiveMobileUsers__c = 20, cpAllForms__c = 325);
        Domain__c domain2 = new Domain__c(Name = 'Sample 2', Server_Name__c = 'CommCare HQ', is_test__c = 'false', cpIsActive__c = true,
                                          Wam__c = 30, cpActiveMobileUsers__c = 35, cpAllForms__c = 340);
        insert domain1;
        insert domain2;

        Accounting_Subscription__c subscription1 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2015, 11, 2), date_end__c = Date.newInstance(2016, 2 ,1), is_active__c = true,
                                                          Accounting_subscriber_domain__c = domain1.Id, Server_Name__c = 'CommCare HQ',
                                                          is_trial__c = false, service_type__c = 'Self_service');
        insert subscription1;
        Accounting_Subscription__c subscription2 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 2 ,1), is_active__c = true,
                                                          Accounting_subscriber_domain__c = domain1.Id, Server_Name__c = 'CommCare HQ',
                                                          is_trial__c = false, service_type__c = 'Product');

        Accounting_Subscription__c subscription3 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2014, 1, 1), date_end__c = Date.newInstance(2014, 3 ,4), is_active__c = true,
                                                          Accounting_subscriber_domain__c = domain2.Id, Server_Name__c = 'CommCare HQ',
                                                          is_trial__c = false, service_type__c = 'Self_service');

        Accounting_Subscription__c subscription4 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 2 ,1), is_active__c = true,
                                                          Accounting_subscriber_domain__c = domain2.Id, Server_Name__c = 'CommCare HQ',
                                                          is_trial__c = false, service_type__c = 'Self_service');
        insert subscription4;
        Accounting_Subscription__c subscription5 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 2 ,1), is_active__c = true,
                                                          Accounting_subscriber_domain__c = domain2.Id, Server_Name__c = 'CommCare HQ',
                                                          is_trial__c = false, service_type__c = 'Product');
        insert subscription5;

        Integer start = System.Now().millisecond();
        while(System.Now().millisecond() < start + 100){
        }
        // We must fake modification time for test so we must add those 2 subscriptions after some delay
        insert subscription2;
        insert subscription3;

        Test.setCreatedDate(subscription1.Id, DateTime.newInstance(2017, 5, 9, 10, 10, 0)); // This should be deactivated
        Test.setCreatedDate(subscription2.Id, DateTime.newInstance(2017, 5, 10, 10, 10, 0));
        Test.setCreatedDate(subscription3.Id, DateTime.newInstance(2017, 5, 11, 10, 10, 0));
        Test.setCreatedDate(subscription4.Id, DateTime.newInstance(2017, 5, 9, 11, 10, 0)); // This should be deactivated
        Test.setCreatedDate(subscription5.Id, DateTime.newInstance(2017, 5, 9, 10, 10, 0)); // This should be deactivated

        Test.startTest();
        Database.executeBatch(new DeactivateDuplicatedSubscriptionsBatch());
        Test.stopTest();

        Accounting_Subscription__c sub1 = [SELECT Id, is_active__c FROM Accounting_Subscription__c WHERE Id =: subscription1.Id LIMIT 1];
        System.assertEquals(false, sub1.is_active__c);
        Accounting_Subscription__c sub2 = [SELECT Id, is_active__c FROM Accounting_Subscription__c WHERE Id =: subscription2.Id LIMIT 1];
        System.assertEquals(true, sub2.is_active__c);
        Accounting_Subscription__c sub3 = [SELECT Id, is_active__c FROM Accounting_Subscription__c WHERE Id =: subscription3.Id LIMIT 1];
        System.assertEquals(true, sub3.is_active__c);
        Accounting_Subscription__c sub4 = [SELECT Id, is_active__c FROM Accounting_Subscription__c WHERE Id =: subscription4.Id LIMIT 1];
        System.assertEquals(false, sub4.is_active__c);
        Accounting_Subscription__c sub5 = [SELECT Id, is_active__c FROM Accounting_Subscription__c WHERE Id =: subscription5.Id LIMIT 1];
        System.assertEquals(false, sub5.is_active__c);
    }*/

    @isTest
    static void shouldCreateDomainMonthlySnapshotFromHistory() {
        generateDataForDomainSnapshot();

        Test.startTest();
        /**Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        Date current = Date.newInstance(2017, 3, 1);
        List<String> servers = HqBatchJobHelper.getCommcareServers(false);
        if (servers.size() > 0 && current != null) {
            String serverCode = servers.get(0);
            servers.remove(0);
            Database.executeBatch(new HqMaltTablesBatch(serverCode, servers, current, false), 1);
        }*/
        Date current = Date.newInstance(2017, 3, 1);
        Database.executeBatch(new DomainSnapshotFromHistoryBatch(current));
        Test.stopTest();

        // Community => subscription1 AND subscription4 => Wam = 15 + 60 = 75, Mobile Users = 20 + 65 = 85, Forms = 325 + 370 = 695 - last (250) = 445
        // Standard => subscription1 AND subscription4 => Wam = 30 + 75 = 105, Mobile Users = 35 + 80 = 115, Forms = 340 + 385 = 725 - last (25) = 700
        // Pro => subscription1 AND subscription4 => Wam = 45, Mobile Users = 50, Forms = 355
        Domain_Monthly_Snapshot__c domainSn = [SELECT Active_Mobile_Users__c, Forms__c, Wam__c, Scale_of_Programs__c, Forms_for_Period__c
                                               FROM Domain_Monthly_Snapshot__c WHERE Software_Plan_Edition__c = 'Community' ORDER BY Snapshot_Date__c DESC LIMIT 1];
        System.assertEquals(0, domainSn.Wam__c);
        System.assertEquals(85, domainSn.Active_Mobile_Users__c);
        System.assertEquals(0, domainSn.Forms_for_Period__c);
        System.assertEquals(695, domainSn.Forms__c);
        System.assertEquals(2, domainSn.Scale_of_Programs__c);

        domainSn = [SELECT Active_Mobile_Users__c, Forms__c, Wam__c, Scale_of_Programs__c, Forms_for_Period__c
                                               FROM Domain_Monthly_Snapshot__c WHERE Software_Plan_Edition__c = 'Standard' ORDER BY Snapshot_Date__c DESC LIMIT 1];
        System.assertEquals(0, domainSn.Wam__c);
        System.assertEquals(115, domainSn.Active_Mobile_Users__c);
        System.assertEquals(0, domainSn.Forms_for_Period__c);
        System.assertEquals(725, domainSn.Forms__c);
        System.assertEquals(2, domainSn.Scale_of_Programs__c);

        domainSn = [SELECT Active_Mobile_Users__c, Forms__c, Wam__c, Scale_of_Programs__c, Forms_for_Period__c
                                               FROM Domain_Monthly_Snapshot__c WHERE Software_Plan_Edition__c = 'Pro' ORDER BY Snapshot_Date__c DESC LIMIT 1];
        System.assertEquals(0, domainSn.Wam__c);
        System.assertEquals(50, domainSn.Active_Mobile_Users__c);
        System.assertEquals(0, domainSn.Forms_for_Period__c);
        System.assertEquals(355, domainSn.Forms__c);
        System.assertEquals(1, domainSn.Scale_of_Programs__c);
    }

    @isTest
    static void shouldCalculateWAM() {
        hqInt_Model_DomainClass d1 = new hqInt_Model_DomainClass();
        d1.x_id = 'sample_external_id';
        d1.Name = 'domain_1';
        d1.tags = new List<String> { ' ' };
        Domain__c domainFromDb1 = d1.createDbObject(null, 'CommCare HQ');
        insert domainFromDb1;

        hqInt_Model_DomainClass d2 = new hqInt_Model_DomainClass();
        d2.x_id = 'test-external-2';
        d2.Name = 'domain_2';
        d2.tags = new List<String> { ' ' };
        Domain__c domainFromDb2 = d2.createDbObject(null, 'CommCare HQ');
        insert domainFromDb2;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        Date current = Date.today();
        List<String> servers = HqBatchJobHelper.getCommcareServers(false);
        if (servers.size() > 0 && current != null) {
            String serverCode = servers.get(0);
            servers.remove(0);
            Database.executeBatch(new HqMaltTablesBatch(serverCode, servers, current, true), 1);
        }
        Test.stopTest();

        Domain__c assertDomain = [SELECT Id, Wam__c, Forms_For_Period__c FROM Domain__c WHERE Id =: domainFromDb1.Id];
        System.assertEquals(52, assertDomain.Forms_For_Period__c);
        System.assertEquals(2, assertDomain.Wam__c);
        assertDomain = [SELECT Id, Wam__c, Forms_For_Period__c FROM Domain__c WHERE Id =: domainFromDb2.Id];
        System.assertEquals(39, assertDomain.Forms_For_Period__c);
        System.assertEquals(3, assertDomain.Wam__c);
    }

    @isTest
    static void shouldSetPrimaryContactOnDomain() {
        Business_Unit__c bunit = new Business_Unit__c();
        bunit.Name = 'Test';
        insert bunit; 

        Opportunity opp1 = new Opportunity(Name = 'opp1', StageName = 'Stage 1 - Connect', CloseDate = Date.today().addDays(50),
                                          Implementing_Business_Unit__c = bunit.Id);
        insert opp1;
        Opportunity opp2 = new Opportunity(Name = 'opp2', StageName = 'Stage 1 - Connect', CloseDate = Date.today().addDays(50),
                                          Implementing_Business_Unit__c = bunit.Id);
        insert opp2;
        Opportunity opp3 = new Opportunity(Name = 'opp3', StageName = 'Stage 1 - Connect', CloseDate = Date.today().addDays(50),
                                          Implementing_Business_Unit__c = bunit.Id);
        insert opp3;

        Contact c1 = new Contact(Title = 'Test Contact 1', Department = 'Account', Email = 'test2@test.com', FirstName = 'Test 1', LastName = 'Contact');
        Contact c2 = new Contact(Title = 'Test Contact 2', Department = 'Account', Email = 'test1@test.com', FirstName = 'Test 2', LastName = 'Contact');
        insert c1;
        insert c2;

        OpportunityContactRole ocr1 = new OpportunityContactRole(ContactId = c1.Id, OpportunityId = opp1.Id, IsPrimary = true);
        OpportunityContactRole ocr2 = new OpportunityContactRole(ContactId = c2.Id, OpportunityId = opp2.Id, IsPrimary = true);
        insert ocr1;
        insert ocr2;

        hqInt_Model_DomainClass d1 = new hqInt_Model_DomainClass();
        d1.x_id = 'sample_external_id_1';
        d1.Name = 'd1';
        d1.tags = new List<String> { ' ' };
        Domain__c domainFromDb1 = d1.createDbObject(null, 'CommCare HQ');
        domainFromDb1.Opportunity__c = opp3.Id;
        insert domainFromDb1;
        hqInt_Model_DomainClass d2 = new hqInt_Model_DomainClass();
        d2.x_id = 'sample_external_id_2';
        d2.Name = 'd2';
        d2.tags = new List<String> { ' ' };
        Domain__c domainFromDb2 = d2.createDbObject(null, 'CommCare HQ');
        insert domainFromDb2;
        hqInt_Model_DomainClass d3 = new hqInt_Model_DomainClass();
        d3.x_id = 'sample_external_id_3';
        d3.Name = 'd3';
        d3.tags = new List<String> { ' ' };
        Domain__c domainFromDb3 = d3.createDbObject(null, 'CommCare HQ');
        domainFromDb3.Opportunity__c = opp1.Id;
        insert domainFromDb3;

        Test.startTest();
        domainFromDb1.Opportunity__c = opp1.Id;
        domainFromDb2.Opportunity__c = opp2.Id;
        domainFromDb3.Opportunity__c = opp3.Id;
        List<Domain__c> toUpdate = new List<Domain__c>();
        toUpdate.add(domainFromDb1);
        toUpdate.add(domainFromDb2);
        toUpdate.add(domainFromDb3);
        update toUpdate;
        Test.stopTest();

        Domain__c assertDomain = [SELECT Id, Primary_Contact__c FROM Domain__c WHERE Id =: domainFromDb1.Id];
        System.assertEquals(c1.Id, assertDomain.Primary_Contact__c);
        assertDomain = [SELECT Id, Primary_Contact__c FROM Domain__c WHERE Id =: domainFromDb2.Id];
        System.assertEquals(c2.Id, assertDomain.Primary_Contact__c);
        assertDomain = [SELECT Id, Primary_Contact__c FROM Domain__c WHERE Id =: domainFromDb3.Id];
        System.assertEquals(null, assertDomain.Primary_Contact__c);
    }

    @isTest
    static void shouldCreateDomains() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock('{"meta":{"limit":2,"next":"/hq/admin/api/global/project_space_metadata/?limit=2&offset=7058","offset":3,"previous":"/hq/admin/api/global/project_space_metadata/?limit=2&offset=7054","total_count":12},"objects":[{"billing_properties":{"date_end":null,"date_start":"2016-01-01","plan_version":"CommCare Advanced Edition (v2)"},"calculated_properties":{"cp_first_form":"2013-02-25T21:31:21.000000Z", "cp_300th_form": "2015-03-27T22:50:29Z","cp_has_app":true,"cp_is_active":true,"cp_j2me_90_d_bool":1,"cp_last_form":"2016-03-24T18:18:57.726780Z","cp_last_updated":"2016-03-24T22:58:24.567926Z","cp_n_30_day_cases":469,"cp_n_60_day_cases":580,"cp_n_90_day_cases":650,"cp_n_active_cases":722,"cp_n_active_cc_users":92,"cp_n_cases":15682,"cp_n_cc_users":1227,"cp_n_forms":28339,"cp_n_forms_30_d":2745,"cp_n_forms_60_d":2871,"cp_n_forms_90_d":2956,"cp_n_in_sms":0,"cp_n_inactive_cases":7794,"cp_n_j2me_30_d":2745,"cp_n_j2me_60_d":2871,"cp_n_j2me_90_d":2956,"cp_n_out_sms":0,"cp_n_sms_30_d":6,"cp_n_sms_60_d":6,"cp_n_sms_90_d":6,"cp_n_sms_ever":499,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":486,"cp_n_web_users":8,"cp_sms_30_d":1,"cp_sms_ever":1},"domain_properties":{"_id":"sample_external_id","_rev":"123","allow_domain_requests":false,"area":null,"attribution_notes":null,"author":null,"billable_client":null,"billing_address":{"address":[],"city":"LA","country":"USA","doc_type":"HQBillingAddress","name":"test","postal_code":"123","state_province":"TEST"},"billing_number":null,"cached_properties":{"languages":["en","luo"]},"call_center_config":{"case_owner_id":null,"case_type":null,"doc_type":"CallCenterProperties","enabled":false,"use_fixtures":true,"use_user_location_as_owner":false,"user_location_ancestor_level":0},"case_display":{"case_details":{},"doc_type":"CaseDisplaySettings","form_details":{}},"case_sharing":false,"cda":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null,"version":null},"chat_message_count_threshold":null,"city":"","cloudcare_releases":"nostars","commconnect_enabled":false,"commtrack_enabled":false,"copy_history":[],"count_messages_as_read_by_anyone":false,"country":"Uganda","cp_first_form":"2013-02-25T21:31:21.000000Z","cp_has_app":true,"cp_is_active":true,"cp_j2me_90_d_bool":1,"cp_last_form":"2016-03-24T18:18:57.726780Z","cp_last_updated":"2016-03-24T22:58:24.567926Z","cp_n_30_day_cases":469,"cp_n_60_day_cases":580,"cp_n_90_day_cases":650,"cp_n_active_cases":722,"cp_n_active_cc_users":92,"cp_n_cases":15682,"cp_n_cc_users":1227,"cp_n_forms":28339,"cp_n_forms_30_d":2745,"cp_n_forms_60_d":2871,"cp_n_forms_90_d":2956,"cp_n_in_sms":0,"cp_n_inactive_cases":7794,"cp_n_j2me_30_d":2745,"cp_n_j2me_60_d":2871,"cp_n_j2me_90_d":2956,"cp_n_out_sms":0,"cp_n_sms_30_d":6,"cp_n_sms_60_d":6,"cp_n_sms_90_d":6,"cp_n_sms_ever":499,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":486,"cp_n_web_users":8,"cp_sms_30_d":1,"cp_sms_ever":1,"creating_user":null,"currency_code":"USD","custom_case_username":null,"custom_chat_template":null,"customer_type":"plus","date_created":"2013-02-25T12:41:09.000000Z","default_mobile_worker_redirect":null,"default_sms_backend_id":null,"default_sms_response":null,"default_timezone":"Africa/Nairobi","deployment":{"city":"","countries":["UGANDA"],"country":"Uganda","date":"2014-06-04T00:00:00.000000Z","description":"Test desc","doc_type":"Deployment","public":false,"region":"Africa"},"description":null,"doc_type":"Domain","downloads":0,"dynamic_reports":[],"enable_registration_welcome_sms_for_case":false,"enable_registration_welcome_sms_for_mobile_worker":false,"eula":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null},"filter_surveys_from_chat":false,"full_downloads":0,"has_careplan":false,"hipaa_compliant":false,"hr_name":null,"image_path":null,"image_type":null,"internal":{"area":"Health","business_unit":"DSA","can_use_data":true,"commcare_edition":"enterprise","commconnect_domain":null,"commtrack_domain":false,"custom_eula":false,"doc_type":"InternalProperties","goal_followup_rate":null,"goal_time_period":null,"initiative":[],"notes":"Test notes ","organization_name":"World Vision","phone_model":"Nokia Test","platform":["java"],"project_manager":"sshah@dimagi.com","project_state":"transition","real_space":null,"self_started":false,"services":"plus","sf_account_id":"001b000000ItF8U","sf_contract_id":"001b000000ItF8U","sub_area":"Child Health","using_adm":false,"using_call_center":false,"workshop_region":null},"is_active":true,"is_approved":false,"is_public":false,"is_shared":false,"is_sms_billable":null,"is_snapshot":false,"is_test":"false","last_modified":"2016-03-23T20:12:45.441697Z","license":"cc","location_restriction_for_users":false,"locations_enabled":false,"migrations":{"doc_type":"DomainMigrations","has_migrated_permissions":true},"multimedia_included":true,"name":"test-1","obsolete_location_types":[],"organization":null,"ota_restore_caching":false,"phone_model":null,"project_type":"MCH","published":false,"publisher":"user","region":"","restrict_superusers":false,"restricted_sms_times":[],"secure_sessions":false,"secure_submissions":false,"send_to_duplicated_case_numbers":false,"short_description":null,"show_invalid_survey_responses_in_chat":false,"slug":null,"sms_case_registration_enabled":false,"sms_case_registration_owner_id":null,"sms_case_registration_type":null,"sms_case_registration_user_id":null,"sms_conversation_length":10,"sms_conversation_times":[],"sms_mobile_worker_registration_enabled":false,"snapshot_time":null,"sub_area":null,"subscription":"Advanced","survey_management_enabled":false,"tags":[],"title":null,"two_factor_auth":false,"use_default_sms_response":false,"usercase_enabled":false,"yt_id":null},"resource_uri":"/hq/admin/api/global/project_space_metadata/asdf233w/"},{"billing_properties":{"date_end":null,"date_start":"2016-01-01","plan_version":"CommCare Pro Edition (v2)"},"calculated_properties":{"cp_first_form":"2013-03-27T17:01:01.000000Z","cp_has_app":null,"cp_is_active":false,"cp_j2me_90_d_bool":0,"cp_last_form":"2014-10-22T14:28:14.000000Z","cp_last_updated":"2016-03-25T00:43:36.613916Z","cp_n_30_day_cases":0,"cp_n_60_day_cases":0,"cp_n_90_day_cases":0,"cp_n_active_cases":0,"cp_n_active_cc_users":0,"cp_n_cases":1457,"cp_n_cc_users":103,"cp_n_forms":1800,"cp_n_forms_30_d":0,"cp_n_forms_60_d":0,"cp_n_forms_90_d":0,"cp_n_in_sms":0,"cp_n_inactive_cases":1163,"cp_n_j2me_30_d":0,"cp_n_j2me_60_d":0,"cp_n_j2me_90_d":0,"cp_n_out_sms":0,"cp_n_sms_30_d":0,"cp_n_sms_60_d":0,"cp_n_sms_90_d":0,"cp_n_sms_ever":3,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":17,"cp_n_web_users":7,"cp_sms_30_d":0,"cp_sms_ever":1},"domain_properties":{"_id":"test-external-2","_rev":"30-89csss6f0","allow_domain_requests":false,"area":null,"attribution_notes":null,"author":null,"billable_client":null,"billing_address":{"address":[],"city":"London","country":"England","doc_type":"HQBillingAddress","name":"test-name-2","postal_code":"234","state_province":"CA"},"billing_number":null,"cached_properties":{"languages":["en","tog","tha"]},"call_center_config":{"case_owner_id":null,"case_type":null,"doc_type":"CallCenterProperties","enabled":false,"use_fixtures":true,"use_user_location_as_owner":false,"user_location_ancestor_level":0},"case_display":{"case_details":{},"doc_type":"CaseDisplaySettings","form_details":{}},"case_sharing":false,"cda":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null,"version":null},"chat_message_count_threshold":null,"city":"","cloudcare_releases":"nostars","commconnect_enabled":false,"commtrack_enabled":false,"copy_history":[],"count_messages_as_read_by_anyone":false,"country":"Zambia","cp_first_form":"2013-03-27T17:01:01.000000Z","cp_has_app":true,"cp_is_active":false,"cp_j2me_90_d_bool":0,"cp_last_form":"2014-10-22T14:28:14.000000Z","cp_last_updated":"2016-03-25T00:43:36.613916Z","cp_n_30_day_cases":0,"cp_n_60_day_cases":0,"cp_n_90_day_cases":0,"cp_n_active_cases":0,"cp_n_active_cc_users":0,"cp_n_cases":1457,"cp_n_cc_users":103,"cp_n_forms":1800,"cp_n_forms_30_d":0,"cp_n_forms_60_d":0,"cp_n_forms_90_d":0,"cp_n_in_sms":0,"cp_n_inactive_cases":1163,"cp_n_j2me_30_d":0,"cp_n_j2me_60_d":0,"cp_n_j2me_90_d":0,"cp_n_out_sms":0,"cp_n_sms_30_d":0,"cp_n_sms_60_d":0,"cp_n_sms_90_d":0,"cp_n_sms_ever":3,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":17,"cp_n_web_users":7,"cp_sms_30_d":0,"cp_sms_ever":1,"creating_user":"test@dimagi.com","currency_code":"USD","custom_case_username":null,"custom_chat_template":null,"customer_type":"plus","date_created":"2013-03-26T10:28:09.000000Z","default_mobile_worker_redirect":null,"default_sms_backend_id":"","default_sms_response":null,"default_timezone":"UTC","deployment":{"city":"sinazongwe","countries":["ZAMBIA"],"country":"Zambia","date":"2013-06-19T00:00:00.000000Z","description":"New notest for domain","doc_type":"Deployment","public":false,"region":"Africa"},"description":null,"doc_type":"Domain","downloads":0,"dynamic_reports":[],"enable_registration_welcome_sms_for_case":false,"enable_registration_welcome_sms_for_mobile_worker":false,"eula":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null},"filter_surveys_from_chat":false,"full_downloads":0,"has_careplan":false,"hipaa_compliant":false,"hr_name":null,"image_path":null,"image_type":null,"internal":{"area":"","business_unit":"DSA","can_use_data":true,"commcare_edition":"","commconnect_domain":null,"commtrack_domain":false,"custom_eula":null,"doc_type":"InternalProperties","goal_followup_rate":null,"goal_time_period":null,"initiative":[],"notes":"","organization_name":"","phone_model":"","platform":[],"project_manager":null,"project_state":"","real_space":null,"self_started":false,"services":"","sf_account_id":"","sf_contract_id":"","sub_area":null,"using_adm":null,"using_call_center":null,"workshop_region":null},"is_active":true,"is_approved":false,"is_public":false,"is_shared":false,"is_sms_billable":null,"is_snapshot":false,"is_test":"false","last_modified":"2016-03-23T20:13:14.903640Z","license":"cc","location_restriction_for_users":false,"locations_enabled":false,"migrations":{"doc_type":"DomainMigrations","has_migrated_permissions":true},"multimedia_included":true,"name":"test-2","obsolete_location_types":[],"organization":null,"ota_restore_caching":false,"phone_model":null,"project_type":"MCH","published":false,"publisher":"user","region":"","restrict_superusers":false,"restricted_sms_times":[],"secure_sessions":false,"secure_submissions":false,"send_to_duplicated_case_numbers":false,"short_description":null,"show_invalid_survey_responses_in_chat":false,"sms_case_registration_enabled":false,"sms_case_registration_owner_id":"0206df14238b0e56a11ee1237fe16476","sms_case_registration_type":"","sms_case_registration_user_id":"c6cad554c776b45f3d375c874ec92d23","sms_conversation_length":10,"sms_conversation_times":[],"sms_mobile_worker_registration_enabled":false,"snapshot_time":null,"sub_area":null,"subscription":"Pro","survey_management_enabled":false,"tags":[],"title":null,"two_factor_auth":false,"use_default_sms_response":false,"usercase_enabled":false,"yt_id":null},"resource_uri":"/hq/admin/api/global/project_space_metadata/205ds2da/"}]}'));
        HqBatchJobHelper.startDomainJob();
        Test.stopTest();

        List<Domain__c> domains = [SELECT id__c FROM Domain__c];
        System.assertEquals(2, domains.size());

        Domain__c testDomain = [SELECT id__c, cp300thFormSubmission__c, InternalProp_Business_Unit__c, Deployment_country__c, Deployment_city__c, Deployment_region__c, billing_address_country__c, billing_address_city__c,
                                    Server_Name__c FROM Domain__c WHERE id__c ='sample_external_id'];
        System.assertEquals('DSA', testDomain.InternalProp_Business_Unit__c);
        System.assertEquals('Uganda', testDomain.Deployment_country__c);
        System.assertEquals(null, testDomain.Deployment_city__c);
        System.assertEquals('Africa', testDomain.Deployment_region__c);
        System.assertEquals('USA', testDomain.billing_address_country__c);
        System.assertEquals('LA', testDomain.billing_address_city__c);
        System.assertEquals(2015, testDomain.cp300thFormSubmission__c.year());
        System.assertEquals(3, testDomain.cp300thFormSubmission__c.month());
        System.assertEquals(27, testDomain.cp300thFormSubmission__c.day());
        System.assertEquals('CommCare HQ', testDomain.Server_Name__c);

        testDomain = [SELECT id__c, InternalProp_Business_Unit__c, Deployment_country__c, Deployment_city__c, Deployment_region__c, billing_address_country__c, billing_address_city__c, Server_Name__c
                                    FROM Domain__c WHERE id__c ='test-external-2'];
        System.assertEquals('DSA', testDomain.InternalProp_Business_Unit__c);
        System.assertEquals('Zambia', testDomain.Deployment_country__c);
        System.assertEquals('sinazongwe', testDomain.Deployment_city__c);
        System.assertEquals('Africa', testDomain.Deployment_region__c);
        System.assertEquals('England', testDomain.billing_address_country__c);
        System.assertEquals('London', testDomain.billing_address_city__c);
        System.assertEquals('CommCare HQ', testDomain.Server_Name__c);

        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
        System.assertEquals(false, settings.Is_Domain_Job_Running__c);
    }

    @isTest
    static void shouldUpdateDomains() {
        hqInt_Model_DomainClass d1 = new hqInt_Model_DomainClass();
        d1.x_id = 'sample_external_id';
        d1.Name = 'd1';
        d1.tags = new List<String> { ' ' };
        Domain__c domainFromDb1 = d1.createDbObject(null, 'CommCare HQ');
        insert domainFromDb1;

        hqInt_Model_DomainClass d2 = new hqInt_Model_DomainClass();
        d2.x_id = 'test-external-2';
        d2.Name = 'd2';
        d2.tags = new List<String> { ' ' };
        Domain__c domainFromDb2 = d2.createDbObject(null, 'CommCare HQ');
        insert domainFromDb2;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock('{"meta":{"limit":2,"next":"/hq/admin/api/global/project_space_metadata/?limit=2&offset=7058","offset":3,"previous":"/hq/admin/api/global/project_space_metadata/?limit=2&offset=7054","total_count":12},"objects":[{"billing_properties":{"date_end":null,"date_start":"2016-01-01","plan_version":"CommCare Advanced Edition (v2)"},"calculated_properties":{"cp_first_form":"2013-02-25T21:31:21.000000Z", "cp_300th_form": "2015-03-27T22:50:29Z","cp_has_app":true,"cp_is_active":true,"cp_j2me_90_d_bool":1,"cp_last_form":"2016-03-24T18:18:57.726780Z","cp_last_updated":"2016-03-24T22:58:24.567926Z","cp_n_30_day_cases":469,"cp_n_60_day_cases":580,"cp_n_90_day_cases":650,"cp_n_active_cases":722,"cp_n_active_cc_users":92,"cp_n_cases":15682,"cp_n_cc_users":1227,"cp_n_forms":28339,"cp_n_forms_30_d":2745,"cp_n_forms_60_d":2871,"cp_n_forms_90_d":2956,"cp_n_in_sms":0,"cp_n_inactive_cases":7794,"cp_n_j2me_30_d":2745,"cp_n_j2me_60_d":2871,"cp_n_j2me_90_d":2956,"cp_n_out_sms":0,"cp_n_sms_30_d":6,"cp_n_sms_60_d":6,"cp_n_sms_90_d":6,"cp_n_sms_ever":499,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":486,"cp_n_web_users":8,"cp_sms_30_d":1,"cp_sms_ever":1},"domain_properties":{"_id":"sample_external_id","_rev":"123","allow_domain_requests":false,"area":null,"attribution_notes":null,"author":null,"billable_client":null,"billing_address":{"address":[],"city":"LA","country":"USA","doc_type":"HQBillingAddress","name":"test","postal_code":"123","state_province":"TEST"},"billing_number":null,"cached_properties":{"languages":["en","luo"]},"call_center_config":{"case_owner_id":null,"case_type":null,"doc_type":"CallCenterProperties","enabled":false,"use_fixtures":true,"use_user_location_as_owner":false,"user_location_ancestor_level":0},"case_display":{"case_details":{},"doc_type":"CaseDisplaySettings","form_details":{}},"case_sharing":false,"cda":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null,"version":null},"chat_message_count_threshold":null,"city":"","cloudcare_releases":"nostars","commconnect_enabled":false,"commtrack_enabled":false,"copy_history":[],"count_messages_as_read_by_anyone":false,"country":"Uganda","cp_first_form":"2013-02-25T21:31:21.000000Z","cp_has_app":true,"cp_is_active":true,"cp_j2me_90_d_bool":1,"cp_last_form":"2016-03-24T18:18:57.726780Z","cp_last_updated":"2016-03-24T22:58:24.567926Z","cp_n_30_day_cases":469,"cp_n_60_day_cases":580,"cp_n_90_day_cases":650,"cp_n_active_cases":722,"cp_n_active_cc_users":92,"cp_n_cases":15682,"cp_n_cc_users":1227,"cp_n_forms":28339,"cp_n_forms_30_d":2745,"cp_n_forms_60_d":2871,"cp_n_forms_90_d":2956,"cp_n_in_sms":0,"cp_n_inactive_cases":7794,"cp_n_j2me_30_d":2745,"cp_n_j2me_60_d":2871,"cp_n_j2me_90_d":2956,"cp_n_out_sms":0,"cp_n_sms_30_d":6,"cp_n_sms_60_d":6,"cp_n_sms_90_d":6,"cp_n_sms_ever":499,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":486,"cp_n_web_users":8,"cp_sms_30_d":1,"cp_sms_ever":1,"creating_user":null,"currency_code":"USD","custom_case_username":null,"custom_chat_template":null,"customer_type":"plus","date_created":"2013-02-25T12:41:09.000000Z","default_mobile_worker_redirect":null,"default_sms_backend_id":null,"default_sms_response":null,"default_timezone":"Africa/Nairobi","deployment":{"city":"","countries":["UGANDA"],"country":"Uganda","date":"2014-06-04T00:00:00.000000Z","description":"Test desc","doc_type":"Deployment","public":false,"region":"Africa"},"description":null,"doc_type":"Domain","downloads":0,"dynamic_reports":[],"enable_registration_welcome_sms_for_case":false,"enable_registration_welcome_sms_for_mobile_worker":false,"eula":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null},"filter_surveys_from_chat":false,"full_downloads":0,"has_careplan":false,"hipaa_compliant":false,"hr_name":null,"image_path":null,"image_type":null,"internal":{"area":"Health","business_unit":"DSA","can_use_data":true,"commcare_edition":"enterprise","commconnect_domain":null,"commtrack_domain":false,"custom_eula":false,"doc_type":"InternalProperties","goal_followup_rate":null,"goal_time_period":null,"initiative":[],"notes":"Test notes ","organization_name":"World Vision","phone_model":"Nokia Test","platform":["java"],"project_manager":"sshah@dimagi.com","project_state":"transition","real_space":null,"self_started":false,"services":"plus","sf_account_id":"001b000000ItF8U","sf_contract_id":"001b000000ItF8U","sub_area":"Child Health","using_adm":false,"using_call_center":false,"workshop_region":null},"is_active":true,"is_approved":false,"is_public":false,"is_shared":false,"is_sms_billable":null,"is_snapshot":false,"is_test":"false","last_modified":"2016-03-23T20:12:45.441697Z","license":"cc","location_restriction_for_users":false,"locations_enabled":false,"migrations":{"doc_type":"DomainMigrations","has_migrated_permissions":true},"multimedia_included":true,"name":"test-1","obsolete_location_types":[],"organization":null,"ota_restore_caching":false,"phone_model":null,"project_type":"MCH","published":false,"publisher":"user","region":"","restrict_superusers":false,"restricted_sms_times":[],"secure_sessions":false,"secure_submissions":false,"send_to_duplicated_case_numbers":false,"short_description":null,"show_invalid_survey_responses_in_chat":false,"slug":null,"sms_case_registration_enabled":false,"sms_case_registration_owner_id":null,"sms_case_registration_type":null,"sms_case_registration_user_id":null,"sms_conversation_length":10,"sms_conversation_times":[],"sms_mobile_worker_registration_enabled":false,"snapshot_time":null,"sub_area":null,"subscription":"Advanced","survey_management_enabled":false,"tags":[],"title":null,"two_factor_auth":false,"use_default_sms_response":false,"usercase_enabled":false,"yt_id":null},"resource_uri":"/hq/admin/api/global/project_space_metadata/asdf233w/"},{"billing_properties":{"date_end":null,"date_start":"2016-01-01","plan_version":"CommCare Pro Edition (v2)"},"calculated_properties":{"cp_first_form":"2013-03-27T17:01:01.000000Z","cp_has_app":null,"cp_is_active":false,"cp_j2me_90_d_bool":0,"cp_last_form":"2014-10-22T14:28:14.000000Z","cp_last_updated":"2016-03-25T00:43:36.613916Z","cp_n_30_day_cases":0,"cp_n_60_day_cases":0,"cp_n_90_day_cases":0,"cp_n_active_cases":0,"cp_n_active_cc_users":0,"cp_n_cases":1457,"cp_n_cc_users":103,"cp_n_forms":1800,"cp_n_forms_30_d":0,"cp_n_forms_60_d":0,"cp_n_forms_90_d":0,"cp_n_in_sms":0,"cp_n_inactive_cases":1163,"cp_n_j2me_30_d":0,"cp_n_j2me_60_d":0,"cp_n_j2me_90_d":0,"cp_n_out_sms":0,"cp_n_sms_30_d":0,"cp_n_sms_60_d":0,"cp_n_sms_90_d":0,"cp_n_sms_ever":3,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":17,"cp_n_web_users":7,"cp_sms_30_d":0,"cp_sms_ever":1},"domain_properties":{"_id":"test-external-2","_rev":"30-89csss6f0","allow_domain_requests":false,"area":null,"attribution_notes":null,"author":null,"billable_client":null,"billing_address":{"address":[],"city":"London","country":"England","doc_type":"HQBillingAddress","name":"test-name-2","postal_code":"234","state_province":"CA"},"billing_number":null,"cached_properties":{"languages":["en","tog","tha"]},"call_center_config":{"case_owner_id":null,"case_type":null,"doc_type":"CallCenterProperties","enabled":false,"use_fixtures":true,"use_user_location_as_owner":false,"user_location_ancestor_level":0},"case_display":{"case_details":{},"doc_type":"CaseDisplaySettings","form_details":{}},"case_sharing":false,"cda":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null,"version":null},"chat_message_count_threshold":null,"city":"","cloudcare_releases":"nostars","commconnect_enabled":false,"commtrack_enabled":false,"copy_history":[],"count_messages_as_read_by_anyone":false,"country":"Zambia","cp_first_form":"2013-03-27T17:01:01.000000Z","cp_has_app":true,"cp_is_active":false,"cp_j2me_90_d_bool":0,"cp_last_form":"2014-10-22T14:28:14.000000Z","cp_last_updated":"2016-03-25T00:43:36.613916Z","cp_n_30_day_cases":0,"cp_n_60_day_cases":0,"cp_n_90_day_cases":0,"cp_n_active_cases":0,"cp_n_active_cc_users":0,"cp_n_cases":1457,"cp_n_cc_users":103,"cp_n_forms":1800,"cp_n_forms_30_d":0,"cp_n_forms_60_d":0,"cp_n_forms_90_d":0,"cp_n_in_sms":0,"cp_n_inactive_cases":1163,"cp_n_j2me_30_d":0,"cp_n_j2me_60_d":0,"cp_n_j2me_90_d":0,"cp_n_out_sms":0,"cp_n_sms_30_d":0,"cp_n_sms_60_d":0,"cp_n_sms_90_d":0,"cp_n_sms_ever":3,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":17,"cp_n_web_users":7,"cp_sms_30_d":0,"cp_sms_ever":1,"creating_user":"test@dimagi.com","currency_code":"USD","custom_case_username":null,"custom_chat_template":null,"customer_type":"plus","date_created":"2013-03-26T10:28:09.000000Z","default_mobile_worker_redirect":null,"default_sms_backend_id":"","default_sms_response":null,"default_timezone":"UTC","deployment":{"city":"sinazongwe","countries":["ZAMBIA"],"country":"Zambia","date":"2013-06-19T00:00:00.000000Z","description":"New notest for domain","doc_type":"Deployment","public":false,"region":"Africa"},"description":null,"doc_type":"Domain","downloads":0,"dynamic_reports":[],"enable_registration_welcome_sms_for_case":false,"enable_registration_welcome_sms_for_mobile_worker":false,"eula":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null},"filter_surveys_from_chat":false,"full_downloads":0,"has_careplan":false,"hipaa_compliant":false,"hr_name":null,"image_path":null,"image_type":null,"internal":{"area":"","business_unit":"DSA","can_use_data":true,"commcare_edition":"","commconnect_domain":null,"commtrack_domain":false,"custom_eula":null,"doc_type":"InternalProperties","goal_followup_rate":null,"goal_time_period":null,"initiative":[],"notes":"","organization_name":"","phone_model":"","platform":[],"project_manager":null,"project_state":"","real_space":null,"self_started":false,"services":"","sf_account_id":"","sf_contract_id":"","sub_area":null,"using_adm":null,"using_call_center":null,"workshop_region":null},"is_active":true,"is_approved":false,"is_public":false,"is_shared":false,"is_sms_billable":null,"is_snapshot":false,"is_test":"false","last_modified":"2016-03-23T20:13:14.903640Z","license":"cc","location_restriction_for_users":false,"locations_enabled":false,"migrations":{"doc_type":"DomainMigrations","has_migrated_permissions":true},"multimedia_included":true,"name":"test-2","obsolete_location_types":[],"organization":null,"ota_restore_caching":false,"phone_model":null,"project_type":"MCH","published":false,"publisher":"user","region":"","restrict_superusers":false,"restricted_sms_times":[],"secure_sessions":false,"secure_submissions":false,"send_to_duplicated_case_numbers":false,"short_description":null,"show_invalid_survey_responses_in_chat":false,"sms_case_registration_enabled":false,"sms_case_registration_owner_id":"0206df14238b0e56a11ee1237fe16476","sms_case_registration_type":"","sms_case_registration_user_id":"c6cad554c776b45f3d375c874ec92d23","sms_conversation_length":10,"sms_conversation_times":[],"sms_mobile_worker_registration_enabled":false,"snapshot_time":null,"sub_area":null,"subscription":"Pro","survey_management_enabled":false,"tags":[],"title":null,"two_factor_auth":false,"use_default_sms_response":false,"usercase_enabled":false,"yt_id":null},"resource_uri":"/hq/admin/api/global/project_space_metadata/205ds2da/"}]}'));
        HqBatchJobHelper.startDomainJob();
        Test.stopTest();

        List<Domain__c> domains = [SELECT id__c FROM Domain__c];
        System.assertEquals(2, domains.size());

        Domain__c testDomain = [SELECT id__c, cp300thFormSubmission__c, InternalProp_Business_Unit__c, Deployment_country__c, Deployment_city__c, Deployment_region__c, billing_address_country__c, billing_address_city__c,
                                    Server_Name__c FROM Domain__c WHERE id__c ='sample_external_id'];
        System.assertEquals('DSA', testDomain.InternalProp_Business_Unit__c);
        System.assertEquals('Uganda', testDomain.Deployment_country__c);
        System.assertEquals(null, testDomain.Deployment_city__c);
        System.assertEquals('Africa', testDomain.Deployment_region__c);
        System.assertEquals('USA', testDomain.billing_address_country__c);
        System.assertEquals('LA', testDomain.billing_address_city__c);
        System.assertEquals(2015, testDomain.cp300thFormSubmission__c.year());
        System.assertEquals(3, testDomain.cp300thFormSubmission__c.month());
        System.assertEquals(27, testDomain.cp300thFormSubmission__c.day());
        System.assertEquals('CommCare HQ', testDomain.Server_Name__c);

        testDomain = [SELECT id__c, InternalProp_Business_Unit__c, Deployment_country__c, Deployment_city__c, Deployment_region__c, billing_address_country__c, billing_address_city__c, Server_Name__c
                                    FROM Domain__c WHERE id__c ='test-external-2'];
        System.assertEquals('DSA', testDomain.InternalProp_Business_Unit__c);
        System.assertEquals('Zambia', testDomain.Deployment_country__c);
        System.assertEquals('sinazongwe', testDomain.Deployment_city__c);
        System.assertEquals('Africa', testDomain.Deployment_region__c);
        System.assertEquals('England', testDomain.billing_address_country__c);
        System.assertEquals('London', testDomain.billing_address_city__c);
        System.assertEquals('CommCare HQ', testDomain.Server_Name__c);

        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
        System.assertEquals(false, settings.Is_Domain_Job_Running__c);
    }

    @isTest
    static void shouldCreateDomainsFromTwoServers() {
        // Additional Server for test
        CommcareToSalesforceSettings__c testCustomSetting = new CommcareToSalesforceSettings__c();
        testCustomSetting.CommCare_User_Name__c = 'CommCareUserName@gmail.com';
        testCustomSetting.CommCare_Password__c = 'CommCarePassword';
        testCustomSetting.Server_URL__c = 'https://test.commcarehq.org/hq/admin/api/global/';
        testCustomSetting.Skip_in_batch_job__c = false;
        testCustomSetting.API_Limit_Parameter__c = 10;
        testCustomSetting.Name = 'Test CommCare HQ';
        insert testCustomSetting;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock('{"meta":{"limit":2,"next":"/hq/admin/api/global/project_space_metadata/?limit=2&offset=7058","offset":3,"previous":"/hq/admin/api/global/project_space_metadata/?limit=2&offset=7054","total_count":12},"objects":[{"billing_properties":{"date_end":null,"date_start":"2016-01-01","plan_version":"CommCare Advanced Edition (v2)"},"calculated_properties":{"cp_first_form":"2013-02-25T21:31:21.000000Z", "cp_300th_form": "2015-03-27T22:50:29Z","cp_has_app":true,"cp_is_active":true,"cp_j2me_90_d_bool":1,"cp_last_form":"2016-03-24T18:18:57.726780Z","cp_last_updated":"2016-03-24T22:58:24.567926Z","cp_n_30_day_cases":469,"cp_n_60_day_cases":580,"cp_n_90_day_cases":650,"cp_n_active_cases":722,"cp_n_active_cc_users":92,"cp_n_cases":15682,"cp_n_cc_users":1227,"cp_n_forms":28339,"cp_n_forms_30_d":2745,"cp_n_forms_60_d":2871,"cp_n_forms_90_d":2956,"cp_n_in_sms":0,"cp_n_inactive_cases":7794,"cp_n_j2me_30_d":2745,"cp_n_j2me_60_d":2871,"cp_n_j2me_90_d":2956,"cp_n_out_sms":0,"cp_n_sms_30_d":6,"cp_n_sms_60_d":6,"cp_n_sms_90_d":6,"cp_n_sms_ever":499,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":486,"cp_n_web_users":8,"cp_sms_30_d":1,"cp_sms_ever":1},"domain_properties":{"_id":"sample_external_id","_rev":"123","allow_domain_requests":false,"area":null,"attribution_notes":null,"author":null,"billable_client":null,"billing_address":{"address":[],"city":"LA","country":"USA","doc_type":"HQBillingAddress","name":"test","postal_code":"123","state_province":"TEST"},"billing_number":null,"cached_properties":{"languages":["en","luo"]},"call_center_config":{"case_owner_id":null,"case_type":null,"doc_type":"CallCenterProperties","enabled":false,"use_fixtures":true,"use_user_location_as_owner":false,"user_location_ancestor_level":0},"case_display":{"case_details":{},"doc_type":"CaseDisplaySettings","form_details":{}},"case_sharing":false,"cda":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null,"version":null},"chat_message_count_threshold":null,"city":"","cloudcare_releases":"nostars","commconnect_enabled":false,"commtrack_enabled":false,"copy_history":[],"count_messages_as_read_by_anyone":false,"country":"Uganda","cp_first_form":"2013-02-25T21:31:21.000000Z","cp_has_app":true,"cp_is_active":true,"cp_j2me_90_d_bool":1,"cp_last_form":"2016-03-24T18:18:57.726780Z","cp_last_updated":"2016-03-24T22:58:24.567926Z","cp_n_30_day_cases":469,"cp_n_60_day_cases":580,"cp_n_90_day_cases":650,"cp_n_active_cases":722,"cp_n_active_cc_users":92,"cp_n_cases":15682,"cp_n_cc_users":1227,"cp_n_forms":28339,"cp_n_forms_30_d":2745,"cp_n_forms_60_d":2871,"cp_n_forms_90_d":2956,"cp_n_in_sms":0,"cp_n_inactive_cases":7794,"cp_n_j2me_30_d":2745,"cp_n_j2me_60_d":2871,"cp_n_j2me_90_d":2956,"cp_n_out_sms":0,"cp_n_sms_30_d":6,"cp_n_sms_60_d":6,"cp_n_sms_90_d":6,"cp_n_sms_ever":499,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":486,"cp_n_web_users":8,"cp_sms_30_d":1,"cp_sms_ever":1,"creating_user":null,"currency_code":"USD","custom_case_username":null,"custom_chat_template":null,"customer_type":"plus","date_created":"2013-02-25T12:41:09.000000Z","default_mobile_worker_redirect":null,"default_sms_backend_id":null,"default_sms_response":null,"default_timezone":"Africa/Nairobi","deployment":{"city":"","countries":["UGANDA"],"country":"Uganda","date":"2014-06-04T00:00:00.000000Z","description":"Test desc","doc_type":"Deployment","public":false,"region":"Africa"},"description":null,"doc_type":"Domain","downloads":0,"dynamic_reports":[],"enable_registration_welcome_sms_for_case":false,"enable_registration_welcome_sms_for_mobile_worker":false,"eula":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null},"filter_surveys_from_chat":false,"full_downloads":0,"has_careplan":false,"hipaa_compliant":false,"hr_name":null,"image_path":null,"image_type":null,"internal":{"area":"Health","business_unit":"DSA","can_use_data":true,"commcare_edition":"enterprise","commconnect_domain":null,"commtrack_domain":false,"custom_eula":false,"doc_type":"InternalProperties","goal_followup_rate":null,"goal_time_period":null,"initiative":[],"notes":"Test notes ","organization_name":"World Vision","phone_model":"Nokia Test","platform":["java"],"project_manager":"sshah@dimagi.com","project_state":"transition","real_space":null,"self_started":false,"services":"plus","sf_account_id":"001b000000ItF8U","sf_contract_id":"001b000000ItF8U","sub_area":"Child Health","using_adm":false,"using_call_center":false,"workshop_region":null},"is_active":true,"is_approved":false,"is_public":false,"is_shared":false,"is_sms_billable":null,"is_snapshot":false,"is_test":"false","last_modified":"2016-03-23T20:12:45.441697Z","license":"cc","location_restriction_for_users":false,"locations_enabled":false,"migrations":{"doc_type":"DomainMigrations","has_migrated_permissions":true},"multimedia_included":true,"name":"test-1","obsolete_location_types":[],"organization":null,"ota_restore_caching":false,"phone_model":null,"project_type":"MCH","published":false,"publisher":"user","region":"","restrict_superusers":false,"restricted_sms_times":[],"secure_sessions":false,"secure_submissions":false,"send_to_duplicated_case_numbers":false,"short_description":null,"show_invalid_survey_responses_in_chat":false,"slug":null,"sms_case_registration_enabled":false,"sms_case_registration_owner_id":null,"sms_case_registration_type":null,"sms_case_registration_user_id":null,"sms_conversation_length":10,"sms_conversation_times":[],"sms_mobile_worker_registration_enabled":false,"snapshot_time":null,"sub_area":null,"subscription":"Advanced","survey_management_enabled":false,"tags":[],"title":null,"two_factor_auth":false,"use_default_sms_response":false,"usercase_enabled":false,"yt_id":null},"resource_uri":"/hq/admin/api/global/project_space_metadata/asdf233w/"},{"billing_properties":{"date_end":null,"date_start":"2016-01-01","plan_version":"CommCare Pro Edition (v2)"},"calculated_properties":{"cp_first_form":"2013-03-27T17:01:01.000000Z","cp_has_app":null,"cp_is_active":false,"cp_j2me_90_d_bool":0,"cp_last_form":"2014-10-22T14:28:14.000000Z","cp_last_updated":"2016-03-25T00:43:36.613916Z","cp_n_30_day_cases":0,"cp_n_60_day_cases":0,"cp_n_90_day_cases":0,"cp_n_active_cases":0,"cp_n_active_cc_users":0,"cp_n_cases":1457,"cp_n_cc_users":103,"cp_n_forms":1800,"cp_n_forms_30_d":0,"cp_n_forms_60_d":0,"cp_n_forms_90_d":0,"cp_n_in_sms":0,"cp_n_inactive_cases":1163,"cp_n_j2me_30_d":0,"cp_n_j2me_60_d":0,"cp_n_j2me_90_d":0,"cp_n_out_sms":0,"cp_n_sms_30_d":0,"cp_n_sms_60_d":0,"cp_n_sms_90_d":0,"cp_n_sms_ever":3,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":17,"cp_n_web_users":7,"cp_sms_30_d":0,"cp_sms_ever":1},"domain_properties":{"_id":"test-external-2","_rev":"30-89csss6f0","allow_domain_requests":false,"area":null,"attribution_notes":null,"author":null,"billable_client":null,"billing_address":{"address":[],"city":"London","country":"England","doc_type":"HQBillingAddress","name":"test-name-2","postal_code":"234","state_province":"CA"},"billing_number":null,"cached_properties":{"languages":["en","tog","tha"]},"call_center_config":{"case_owner_id":null,"case_type":null,"doc_type":"CallCenterProperties","enabled":false,"use_fixtures":true,"use_user_location_as_owner":false,"user_location_ancestor_level":0},"case_display":{"case_details":{},"doc_type":"CaseDisplaySettings","form_details":{}},"case_sharing":false,"cda":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null,"version":null},"chat_message_count_threshold":null,"city":"","cloudcare_releases":"nostars","commconnect_enabled":false,"commtrack_enabled":false,"copy_history":[],"count_messages_as_read_by_anyone":false,"country":"Zambia","cp_first_form":"2013-03-27T17:01:01.000000Z","cp_has_app":true,"cp_is_active":false,"cp_j2me_90_d_bool":0,"cp_last_form":"2014-10-22T14:28:14.000000Z","cp_last_updated":"2016-03-25T00:43:36.613916Z","cp_n_30_day_cases":0,"cp_n_60_day_cases":0,"cp_n_90_day_cases":0,"cp_n_active_cases":0,"cp_n_active_cc_users":0,"cp_n_cases":1457,"cp_n_cc_users":103,"cp_n_forms":1800,"cp_n_forms_30_d":0,"cp_n_forms_60_d":0,"cp_n_forms_90_d":0,"cp_n_in_sms":0,"cp_n_inactive_cases":1163,"cp_n_j2me_30_d":0,"cp_n_j2me_60_d":0,"cp_n_j2me_90_d":0,"cp_n_out_sms":0,"cp_n_sms_30_d":0,"cp_n_sms_60_d":0,"cp_n_sms_90_d":0,"cp_n_sms_ever":3,"cp_n_sms_in_30_d":0,"cp_n_sms_in_60_d":0,"cp_n_sms_in_90_d":0,"cp_n_sms_out_30_d":0,"cp_n_sms_out_60_d":0,"cp_n_sms_out_90_d":0,"cp_n_users_submitted_form":17,"cp_n_web_users":7,"cp_sms_30_d":0,"cp_sms_ever":1,"creating_user":"test@dimagi.com","currency_code":"USD","custom_case_username":null,"custom_chat_template":null,"customer_type":"plus","date_created":"2013-03-26T10:28:09.000000Z","default_mobile_worker_redirect":null,"default_sms_backend_id":"","default_sms_response":null,"default_timezone":"UTC","deployment":{"city":"sinazongwe","countries":["ZAMBIA"],"country":"Zambia","date":"2013-06-19T00:00:00.000000Z","description":"New notest for domain","doc_type":"Deployment","public":false,"region":"Africa"},"description":null,"doc_type":"Domain","downloads":0,"dynamic_reports":[],"enable_registration_welcome_sms_for_case":false,"enable_registration_welcome_sms_for_mobile_worker":false,"eula":{"date":null,"doc_type":"LicenseAgreement","signed":false,"type":null,"user_id":null,"user_ip":null},"filter_surveys_from_chat":false,"full_downloads":0,"has_careplan":false,"hipaa_compliant":false,"hr_name":null,"image_path":null,"image_type":null,"internal":{"area":"","business_unit":"DSA","can_use_data":true,"commcare_edition":"","commconnect_domain":null,"commtrack_domain":false,"custom_eula":null,"doc_type":"InternalProperties","goal_followup_rate":null,"goal_time_period":null,"initiative":[],"notes":"","organization_name":"","phone_model":"","platform":[],"project_manager":null,"project_state":"","real_space":null,"self_started":false,"services":"","sf_account_id":"","sf_contract_id":"","sub_area":null,"using_adm":null,"using_call_center":null,"workshop_region":null},"is_active":true,"is_approved":false,"is_public":false,"is_shared":false,"is_sms_billable":null,"is_snapshot":false,"is_test":"false","last_modified":"2016-03-23T20:13:14.903640Z","license":"cc","location_restriction_for_users":false,"locations_enabled":false,"migrations":{"doc_type":"DomainMigrations","has_migrated_permissions":true},"multimedia_included":true,"name":"test-2","obsolete_location_types":[],"organization":null,"ota_restore_caching":false,"phone_model":null,"project_type":"MCH","published":false,"publisher":"user","region":"","restrict_superusers":false,"restricted_sms_times":[],"secure_sessions":false,"secure_submissions":false,"send_to_duplicated_case_numbers":false,"short_description":null,"show_invalid_survey_responses_in_chat":false,"sms_case_registration_enabled":false,"sms_case_registration_owner_id":"0206df14238b0e56a11ee1237fe16476","sms_case_registration_type":"","sms_case_registration_user_id":"c6cad554c776b45f3d375c874ec92d23","sms_conversation_length":10,"sms_conversation_times":[],"sms_mobile_worker_registration_enabled":false,"snapshot_time":null,"sub_area":null,"subscription":"Pro","survey_management_enabled":false,"tags":[],"title":null,"two_factor_auth":false,"use_default_sms_response":false,"usercase_enabled":false,"yt_id":null},"resource_uri":"/hq/admin/api/global/project_space_metadata/205ds2da/"}]}'));
        HqBatchJobHelper.startDomainJob();
        Test.stopTest();

        Commcare_Job_Settings__c settings = Commcare_Job_Settings__c.getOrgDefaults();
        System.assertEquals(false, settings.Is_Domain_Job_Running__c);

        List<Domain__c> domains = [SELECT id__c FROM Domain__c];
        System.assertEquals(4, domains.size());

        Domain__c testDomain = [SELECT id__c, cp300thFormSubmission__c, InternalProp_Business_Unit__c, Deployment_country__c, Deployment_city__c, Deployment_region__c, billing_address_country__c, billing_address_city__c,
                                    Server_Name__c FROM Domain__c WHERE id__c ='sample_external_id' AND Server_Name__c = 'CommCare HQ'];
        System.assertEquals('DSA', testDomain.InternalProp_Business_Unit__c);
        System.assertEquals('Uganda', testDomain.Deployment_country__c);
        System.assertEquals(null, testDomain.Deployment_city__c);
        System.assertEquals('Africa', testDomain.Deployment_region__c);
        System.assertEquals('USA', testDomain.billing_address_country__c);
        System.assertEquals('LA', testDomain.billing_address_city__c);
        System.assertEquals(2015, testDomain.cp300thFormSubmission__c.year());
        System.assertEquals(3, testDomain.cp300thFormSubmission__c.month());
        System.assertEquals(27, testDomain.cp300thFormSubmission__c.day());
        System.assertEquals('CommCare HQ', testDomain.Server_Name__c);

        testDomain = [SELECT id__c, InternalProp_Business_Unit__c, Deployment_country__c, Deployment_city__c, Deployment_region__c, billing_address_country__c, billing_address_city__c, Server_Name__c
                                    FROM Domain__c WHERE id__c ='test-external-2' AND Server_Name__c = 'CommCare HQ'];
        System.assertEquals('DSA', testDomain.InternalProp_Business_Unit__c);
        System.assertEquals('Zambia', testDomain.Deployment_country__c);
        System.assertEquals('sinazongwe', testDomain.Deployment_city__c);
        System.assertEquals('Africa', testDomain.Deployment_region__c);
        System.assertEquals('England', testDomain.billing_address_country__c);
        System.assertEquals('London', testDomain.billing_address_city__c);
        System.assertEquals('CommCare HQ', testDomain.Server_Name__c);

        testDomain = [SELECT id__c, cp300thFormSubmission__c, InternalProp_Business_Unit__c, Deployment_country__c, Deployment_city__c, Deployment_region__c, billing_address_country__c, billing_address_city__c,
                                    Server_Name__c FROM Domain__c WHERE id__c ='sample_external_id' AND Server_Name__c = 'Test CommCare HQ'];
        System.assertEquals('DSA', testDomain.InternalProp_Business_Unit__c);
        System.assertEquals('Uganda', testDomain.Deployment_country__c);
        System.assertEquals(null, testDomain.Deployment_city__c);
        System.assertEquals('Africa', testDomain.Deployment_region__c);
        System.assertEquals('USA', testDomain.billing_address_country__c);
        System.assertEquals('LA', testDomain.billing_address_city__c);
        System.assertEquals(2015, testDomain.cp300thFormSubmission__c.year());
        System.assertEquals(3, testDomain.cp300thFormSubmission__c.month());
        System.assertEquals(27, testDomain.cp300thFormSubmission__c.day());
        System.assertEquals('Test CommCare HQ', testDomain.Server_Name__c);

        testDomain = [SELECT id__c, InternalProp_Business_Unit__c, Deployment_country__c, Deployment_city__c, Deployment_region__c, billing_address_country__c, billing_address_city__c, Server_Name__c
                                    FROM Domain__c WHERE id__c ='test-external-2' AND Server_Name__c = 'Test CommCare HQ'];
        System.assertEquals('DSA', testDomain.InternalProp_Business_Unit__c);
        System.assertEquals('Zambia', testDomain.Deployment_country__c);
        System.assertEquals('sinazongwe', testDomain.Deployment_city__c);
        System.assertEquals('Africa', testDomain.Deployment_region__c);
        System.assertEquals('England', testDomain.billing_address_country__c);
        System.assertEquals('London', testDomain.billing_address_city__c);
        System.assertEquals('Test CommCare HQ', testDomain.Server_Name__c);
    }

    @isTest
    static void shouldFillCalculationProperties() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.startDomainJob();
        Test.stopTest();

        Domain__c testDomain = [SELECT id__c, Server_Name__c, cpAllActiveCases__c, cpAllCases__c, cpAllForms__c, cpActiveMobileUsers__c, cpAllInactiveCases__c, cpAllIncomingSms__c, cpAllMobileUsers__c, cpAllOutgoingSms__c, cpAllSms__c,
                                    cpAllSmsIn30Days__c, cpAllSmsIn60Days__c, cpAllSmsIn90Days__c, cpAllWebUsers__c, cpCasesIn30Days__c, cpCasesIn90Days__c, cpCasesIn60Days__c, cpFirstFormSubmissionDate__c,
                                    cpFormsIn30Days__c, cpFormsIn60Days__c, cpFormsIn90Days__c, cpHasApp__c, cpIncomingSmsIn30Days__c, cpIncomingSmsIn60Days__c, cpIncomingSmsIn90Days__c, cpIsActive__c,
                                    cpLastFormSubmissionDate__c, cpOutgoingSmsIn30Days__c, cpOutgoingSmsIn60Days__c, cpOutgoingSmsIn90Days__c
                                    FROM Domain__c WHERE id__c ='542f59e04ca149f9a5ae0837529fb06d'];
        System.assertEquals('542f59e04ca149f9a5ae0837529fb06d', testDomain.id__c);
        System.assertEquals(testDomain.cpAllActiveCases__c, 2);
        System.assertEquals(testDomain.cpAllCases__c, 4);
        System.assertEquals(testDomain.cpAllForms__c, 6);
        System.assertEquals(testDomain.cpAllInactiveCases__c, 8);
        System.assertEquals(testDomain.cpAllIncomingSms__c, 7);
        System.assertEquals(testDomain.cpActiveMobileUsers__c, 3);
        System.assertEquals(testDomain.cpAllMobileUsers__c, 5);
        System.assertEquals(testDomain.cpAllOutgoingSms__c, 9);
        System.assertEquals(testDomain.cpAllSms__c, 11);
        System.assertEquals(testDomain.cpAllSmsIn30Days__c, 10);
        System.assertEquals(testDomain.cpAllSmsIn60Days__c, 16);
        System.assertEquals(testDomain.cpAllSmsIn90Days__c, 17);
        System.assertEquals(testDomain.cpAllWebUsers__c, 13);
        System.assertEquals(testDomain.cpCasesIn30Days__c, 24);
        System.assertEquals(testDomain.cpCasesIn90Days__c, 25);
        System.assertEquals(testDomain.cpCasesIn60Days__c, 1);
        System.assertEquals(testDomain.cpFirstFormSubmissionDate__c.day(), 20);
        System.assertEquals(testDomain.cpFirstFormSubmissionDate__c.month(), 3);
        System.assertEquals(testDomain.cpFormsIn30Days__c, 26);
        System.assertEquals(testDomain.cpFormsIn60Days__c, 27);
        System.assertEquals(testDomain.cpFormsIn90Days__c, 28);
        System.assertEquals(testDomain.cpHasApp__c, true);
        System.assertEquals(testDomain.cpIncomingSmsIn30Days__c, 18);
        System.assertEquals(testDomain.cpIncomingSmsIn60Days__c, 19);
        System.assertEquals(testDomain.cpIncomingSmsIn90Days__c, 20);
        System.assertEquals(testDomain.cpIsActive__c, false);
        System.assertEquals(testDomain.cpLastFormSubmissionDate__c.day(), 22);
        System.assertEquals(testDomain.cpLastFormSubmissionDate__c.month(), 3);
        System.assertEquals(testDomain.cpOutgoingSmsIn30Days__c, 21);
        System.assertEquals(testDomain.cpOutgoingSmsIn60Days__c, 22);
        System.assertEquals(testDomain.cpOutgoingSmsIn90Days__c, 23);
        System.assertEquals('CommCare HQ', testDomain.Server_Name__c);
    }

    @isTest
    static void hqIntTestLifetimeMRRCalculation() {
        Test.startTest();

        Accounting_SoftwareProductRate__c productRate1 = new Accounting_SoftwareProductRate__c(is_active__c = true,  monthly_fee__c = 150, Server_Name__c = 'CommCare HQ');
        Accounting_SoftwareProductRate__c productRate2 = new Accounting_SoftwareProductRate__c(is_active__c = true,  monthly_fee__c = 75, Server_Name__c = 'CommCare HQ');
        Accounting_SoftwareProductRate__c productRate3 = new Accounting_SoftwareProductRate__c(is_active__c = true,  monthly_fee__c = 25, Server_Name__c = 'CommCare HQ');

        insert productRate1;
        insert productRate2;
        insert productRate3;

        Accounting_Softwareplan__c softwarePlan1 = new Accounting_Softwareplan__c(Name = 'softwarePlan1', Server_Name__c = 'CommCare HQ');
        Accounting_Softwareplan__c softwarePlan2 = new Accounting_Softwareplan__c(Name = 'softwarePlan2', Server_Name__c = 'CommCare HQ');
        Accounting_Softwareplan__c softwarePlan3 = new Accounting_Softwareplan__c(Name = 'softwarePlan3', Server_Name__c = 'CommCare HQ');

        insert softwarePlan1;
        insert softwarePlan2;
        insert softwarePlan3;

        Accounting_SoftwarePlanVersion__c planVersion1 = new Accounting_SoftwarePlanVersion__c(is_active__c = true, Software_Product_Rate__c = productRate1.Id,
                                                                                               Accounting_SoftwarePlan__c = softwarePlan1.Id, Server_Name__c = 'CommCare HQ');
        Accounting_SoftwarePlanVersion__c planVersion2 = new Accounting_SoftwarePlanVersion__c(is_active__c = true, Software_Product_Rate__c = productRate2.Id,
                                                                                               Accounting_SoftwarePlan__c = softwarePlan2.Id, Server_Name__c = 'CommCare HQ');
        Accounting_SoftwarePlanVersion__c planVersion3 = new Accounting_SoftwarePlanVersion__c(is_active__c = true, Software_Product_Rate__c = productRate3.Id,
                                                                                               Accounting_SoftwarePlan__c = softwarePlan3.Id, Server_Name__c = 'CommCare HQ');

        insert planVersion1;
        insert planVersion2;
        insert planVersion3;

        Domain__c domain1 = new Domain__c(Name = 'Sample 1', Server_Name__c = 'CommCare HQ');
        Domain__c domain2 = new Domain__c(Name = 'Sample 2', Server_Name__c = 'CommCare HQ');
        Domain__c domain3 = new Domain__c(Name = 'Sample 3', Server_Name__c = 'CommCare HQ');

        insert domain1;
        insert domain2;
        insert domain3;

        Accounting_Subscription__c subscription1 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2015, 11, 2), date_end__c = Date.newInstance(2016, 2 ,1),
                                                                                  Accounting_subscriber_domain__c = domain1.Id, plan_version__c = planVersion1.Id, Server_Name__c = 'CommCare HQ');
        insert subscription1;
        Accounting_Subscription__c subscription2 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 2 ,1),
                                                                                  Accounting_subscriber_domain__c = domain1.Id, plan_version__c = planVersion2.Id, Server_Name__c = 'CommCare HQ');
        insert subscription2;
        Accounting_Subscription__c subscription3 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2014, 1, 1), date_end__c = Date.newInstance(2014, 3 ,4),
                                                                                  Accounting_subscriber_domain__c = domain1.Id, plan_version__c = planVersion3.Id, Server_Name__c = 'CommCare HQ');
        insert subscription3;
        Accounting_Subscription__c subscription4 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 2 ,1),
                                                                                  Accounting_subscriber_domain__c = domain2.Id, plan_version__c = planVersion1.Id, Server_Name__c = 'CommCare HQ');
        insert subscription4;
        Accounting_Subscription__c subscription5 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 2 ,1),
                                                                                  Accounting_subscriber_domain__c = domain2.Id, plan_version__c = planVersion2.Id, Server_Name__c = 'CommCare HQ');
        insert subscription5;
        Accounting_Subscription__c subscription6 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2013, 6, 6), date_end__c = Date.newInstance(2014, 5 ,5),
                                                                                  Accounting_subscriber_domain__c = domain2.Id, plan_version__c = planVersion3.Id, Server_Name__c = 'CommCare HQ');
        insert subscription6;
        Accounting_Subscription__c subscription7 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 2 ,1),
                                                                                  Accounting_subscriber_domain__c = domain2.Id, plan_version__c = planVersion1.Id, Server_Name__c = 'CommCare HQ');
        insert subscription7;
        Accounting_Subscription__c subscription8 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2016, 2, 1), date_end__c = Date.newInstance(2016, 4, 4),
                                                                                  Accounting_subscriber_domain__c = domain3.Id, plan_version__c = planVersion2.Id, Server_Name__c = 'CommCare HQ');
        insert subscription8;
        Accounting_Subscription__c subscription9 = new Accounting_Subscription__c(date_start__c = Date.newInstance(2016, 1, 14), date_end__c = Date.newInstance(2016, 2 ,10),
                                                                                  Accounting_subscriber_domain__c = domain3.Id, plan_version__c = planVersion3.Id, Server_Name__c = 'CommCare HQ');
        insert subscription9;

        Database.executeBatch(new CalculateDomainsLifeTimeMRRBatch(), 200);

        Test.stopTest();

        Domain__c domainFromDB1 = [SELECT Lifetime_MRR__c FROM Domain__c WHERE Name = 'Sample 1' LIMIT 1];
        System.assertEquals(calculateMRRForDomain(domain1.Id, 3), domainFromDB1.Lifetime_MRR__c);
        Domain__c domainFromDB2 = [SELECT Lifetime_MRR__c FROM Domain__c WHERE Name = 'Sample 2' LIMIT 1];
        System.assertEquals(calculateMRRForDomain(domain2.Id, 4), domainFromDB2.Lifetime_MRR__c);
        Domain__c domainFromDB3 = [SELECT Lifetime_MRR__c FROM Domain__c WHERE Name = 'Sample 3' LIMIT 1];
        System.assertEquals(calculateMRRForDomain(domain3.Id, 2), domainFromDB3.Lifetime_MRR__c);
        System.debug(domainFromDB1);
        System.debug(domainFromDB2);
        System.debug(domainFromDB3);
    }

    /**
     * Accounting Test
     */

    @isTest
    static void testAccountingFeature() {
        Accounting_feature__c af = new Accounting_feature__c(id__c = '2', Name = 'Wrong Name', feature_type__c = 'SMS', Server_Name__c = 'CommCare HQ');
        insert af;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(1, 'CommCare HQ', new List<String>());
        Test.stopTest();

        System.assertEquals(4, [SELECT Id FROM Accounting_feature__c].size());

        Accounting_feature__c sfFromDb = [SELECT Name, feature_type__c FROM Accounting_feature__c WHERE id__c = '2'];
        System.assertEquals('SMS', sfFromDb.feature_type__c);
        System.assertEquals('SMS Community', sfFromDb.Name);
    }

    @isTest
    static void testSoftwareplan() {
        Accounting_Softwareplan__c sfp = new Accounting_Softwareplan__c(id__c = '4', Name = 'Wrong Name', edition__c = 'Advanced', Server_Name__c = 'CommCare HQ');
        insert sfp;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(2, 'CommCare HQ', new List<String>());
        Test.stopTest();

        Accounting_Softwareplan__c sfpFromDb = [SELECT Name, edition__c FROM Accounting_Softwareplan__c WHERE id__c = '3'];
        System.assertEquals('Pro', sfpFromDb.edition__c);
        System.assertEquals('CommCare Pro Edition', sfpFromDb.Name);

        sfpFromDb = [SELECT Name, edition__c FROM Accounting_Softwareplan__c WHERE id__c = '4'];
        System.assertEquals('Advanced', sfpFromDb.edition__c);
        System.assertEquals('CommCare Advanced Edition', sfpFromDb.Name);
    }

    @isTest
    static void testSubscriber() {
        Accounting_Subscriber__c accountingSubscriberObj = new Accounting_Subscriber__c(id__c = '10', Server_Name__c = 'CommCare HQ');
        insert accountingSubscriberObj;
        hqInt_Model_DomainClass d1 = new hqInt_Model_DomainClass();
        d1.x_id = 'sample_external_id';
        d1.Name = '2014';
        d1.tags = new List<String> { ' ' };
        Domain__c domainFromDb1 = d1.createDbObject(null, 'CommCare HQ');
        insert domainFromDb1;
        hqInt_Model_DomainClass d2 = new hqInt_Model_DomainClass();
        d2.x_id = 'sample_external_id_2';
        d2.Name = 'test-2';
        d2.tags = new List<String> { ' ' };
        Domain__c domainFromDb2 = d2.createDbObject(null, 'CommCare HQ');
        insert domainFromDb2;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(3, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_Subscriber__c> subs = [SELECT id__c FROM Accounting_Subscriber__c];
        System.assertEquals(20, subs.size());

        Accounting_Subscriber__c sub = [SELECT id__c, domain__c, domain_lookup__c, Server_Name__c FROM Accounting_Subscriber__c WHERE id__c = '4'];
        System.assertEquals('test-2', sub.domain__c);
        System.assertEquals(domainFromDb2.Id, sub.domain_lookup__c);
        System.assertEquals('CommCare HQ', sub.Server_Name__c);

        sub = [SELECT id__c, domain__c, domain_lookup__c, Server_Name__c FROM Accounting_Subscriber__c WHERE id__c = '10'];
        System.assertEquals('2014', sub.domain__c);
        System.assertEquals(domainFromDb1.Id, sub.domain_lookup__c);
        System.assertEquals('CommCare HQ', sub.Server_Name__c);
    }


    @isTest
    static void testFeatureRate() {
        Accounting_feature__c af = new Accounting_feature__c(id__c = '2', Name = 'Wrong Name', feature_type__c = 'SMS', Server_Name__c = 'CommCare HQ');
        insert af;
        Accounting_Featurerate__c frate1 = new Accounting_Featurerate__c(id__c = '18', Server_Name__c = 'CommCare HQ');
        insert  frate1;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(4, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_Featurerate__c> frates = [SELECT id__c FROM Accounting_Featurerate__c];
        System.assertEquals(2, frates.size());

        Accounting_Featurerate__c frate = [SELECT id__c, monthly_limit__c, feature__c FROM Accounting_Featurerate__c WHERE id__c = '17'];
        System.assertEquals(50, frate.monthly_limit__c);
        System.assertEquals(null, frate.feature__c);

        frate = [SELECT id__c, monthly_limit__c, feature__c FROM Accounting_Featurerate__c WHERE id__c = '18'];
        System.assertEquals(0, frate.monthly_limit__c);
        System.assertEquals(af.Id, frate.feature__c);
    }

    @isTest
    static void testSoftwareProductRate() {
        Accounting_SoftwareProductRate__c softwareProductRate1 = new Accounting_SoftwareProductRate__c(id__c = '11', is_active__c = false, monthly_fee__c = 111, Server_Name__c = 'CommCare HQ');
        Accounting_SoftwareProductRate__c softwareProductRate2 = new Accounting_SoftwareProductRate__c(id__c = '12', is_active__c = false, monthly_fee__c = 33, Server_Name__c = 'CommCare HQ');
        insert softwareProductRate1;
        insert softwareProductRate2;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(5, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_SoftwareProductRate__c> productsRates = [SELECT id__c, monthly_fee__c FROM Accounting_SoftwareProductRate__c];
        System.assertEquals(5, productsRates.size());

        Accounting_SoftwareProductRate__c productRate = [SELECT id__c, monthly_fee__c FROM Accounting_SoftwareProductRate__c WHERE id__c = '9'];
        System.assertEquals(0.00, productRate.monthly_fee__c);
        productRate = [SELECT id__c, monthly_fee__c FROM Accounting_SoftwareProductRate__c WHERE id__c = '10'];
        System.assertEquals(100.00, productRate.monthly_fee__c);
        productRate = [SELECT id__c, monthly_fee__c FROM Accounting_SoftwareProductRate__c WHERE id__c = '11'];
        System.assertEquals(500.00, productRate.monthly_fee__c);
        productRate = [SELECT id__c, monthly_fee__c FROM Accounting_SoftwareProductRate__c WHERE id__c = '12'];
        System.assertEquals(1000.00, productRate.monthly_fee__c);
        productRate = [SELECT id__c, monthly_fee__c FROM Accounting_SoftwareProductRate__c WHERE id__c = '13'];
        System.assertEquals(0.00, productRate.monthly_fee__c);
    }

    @isTest
    static void testSoftPlanVer() {
        createSoftwarePlan('1');
        createSoftwarePlan('3');
        createSoftwarePlan('4');
        createSoftwarePlan('5');
        createSoftwarePlan('7');
        createProductRate('9');
        createProductRate('11');
        createProductRate('12');
        createProductRate('13');
        createProductRate('15');

        Accounting_SoftwarePlanVersion__c splv1 = new Accounting_SoftwarePlanVersion__c(id__c = '27', Server_Name__c = 'CommCare HQ', Accounting_SoftwarePlan__c = [SELECT Id FROM Accounting_Softwareplan__c LIMIT 1].Id,
                                                        Software_Product_Rate__c = [SELECT Id FROM Accounting_SoftwareProductRate__c LIMIT 1].Id);
        Accounting_SoftwarePlanVersion__c splv2 = new Accounting_SoftwarePlanVersion__c(id__c = '28', Server_Name__c = 'CommCare HQ', Accounting_SoftwarePlan__c = [SELECT Id FROM Accounting_Softwareplan__c LIMIT 1].Id,
                                                        Software_Product_Rate__c = [SELECT Id FROM Accounting_SoftwareProductRate__c LIMIT 1].Id);
        insert splv1;
        insert splv2;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(6, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_SoftwarePlanVersion__c> softwarePlans = [SELECT id__c FROM Accounting_SoftwarePlanVersion__c];
        System.debug('--softwarePlans--' + softwarePlans);
        System.assertEquals(5, softwarePlans.size());

        Accounting_SoftwarePlanVersion__c planVersion = [SELECT id__c, Software_Product_Rate__r.id__c, Accounting_SoftwarePlan__r.id__c, is_active__c, FeatureRates__c
                                                            FROM Accounting_SoftwarePlanVersion__c WHERE id__c = '25'];
        System.assertEquals(false, planVersion.is_active__c);
        System.assertEquals('17,18', planVersion.FeatureRates__c);
        System.assertEquals('9', planVersion.Software_Product_Rate__r.id__c);
        System.assertEquals('1', planVersion.Accounting_SoftwarePlan__r.id__c);

        planVersion = [SELECT id__c, Software_Product_Rate__r.id__c, Accounting_SoftwarePlan__r.id__c, is_active__c, FeatureRates__c
                        FROM Accounting_SoftwarePlanVersion__c WHERE id__c = '27'];
        System.assertEquals(true, planVersion.is_active__c);
        System.assertEquals('22,21', planVersion.FeatureRates__c);
        System.assertEquals('11', planVersion.Software_Product_Rate__r.id__c);
        System.assertEquals('3', planVersion.Accounting_SoftwarePlan__r.id__c);

        planVersion = [SELECT id__c, Software_Product_Rate__r.id__c, Accounting_SoftwarePlan__r.id__c, is_active__c, FeatureRates__c
                            FROM Accounting_SoftwarePlanVersion__c WHERE id__c = '28'];
        System.assertEquals(true, planVersion.is_active__c);
        System.assertEquals('24,23', planVersion.FeatureRates__c);
        System.assertEquals('12', planVersion.Software_Product_Rate__r.id__c);
        System.assertEquals('4', planVersion.Accounting_SoftwarePlan__r.id__c);

        planVersion = [SELECT id__c, Software_Product_Rate__r.id__c, Accounting_SoftwarePlan__r.id__c, is_active__c, FeatureRates__c
                            FROM Accounting_SoftwarePlanVersion__c WHERE id__c = '29'];
        System.assertEquals(true, planVersion.is_active__c);
        System.assertEquals('25,26', planVersion.FeatureRates__c);
        System.assertEquals('13', planVersion.Software_Product_Rate__r.id__c);
        System.assertEquals('5', planVersion.Accounting_SoftwarePlan__r.id__c);

        planVersion = [SELECT id__c, Software_Product_Rate__r.id__c, Accounting_SoftwarePlan__r.id__c, is_active__c, FeatureRates__c
                            FROM Accounting_SoftwarePlanVersion__c WHERE id__c = '31'];
        System.assertEquals(true, planVersion.is_active__c);
        System.assertEquals('29,30', planVersion.FeatureRates__c);
        System.assertEquals('15', planVersion.Software_Product_Rate__r.id__c);
        System.assertEquals('7', planVersion.Accounting_SoftwarePlan__r.id__c);
    }

    @isTest
    static void testPaymentMethod() {
        Accounting_BillingAccount__c accountingBillingAccount1 = new Accounting_BillingAccount__c(Name = 'tb1', id__c = '1', Server_Name__c = 'CommCare HQ');
        Accounting_BillingAccount__c accountingBillingAccount2 = new Accounting_BillingAccount__c(Name = 'tb2', id__c = '2', Server_Name__c = 'CommCare HQ');
        Accounting_BillingAccount__c accountingBillingAccount3 = new Accounting_BillingAccount__c(Name = 'tb3', id__c = '3', Server_Name__c = 'CommCare HQ');
        insert accountingBillingAccount1;
        insert accountingBillingAccount2;
        insert accountingBillingAccount3;
        Accounting_PaymentMethod__c pm1 = new Accounting_PaymentMethod__c(account__c = accountingBillingAccount3.Id, id__c = '2', customer_id__c = 'ww1', Server_Name__c = 'CommCare HQ');
        Accounting_PaymentMethod__c pm2 = new Accounting_PaymentMethod__c(id__c = '3', customer_id__c = 'ww2', Server_Name__c = 'CommCare HQ');
        insert pm1;
        insert pm2;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(7, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_PaymentMethod__c> pmethods = [SELECT id__c FROM Accounting_PaymentMethod__c];
        System.assertEquals(4, pmethods.size());

        Accounting_PaymentMethod__c pm = [SELECT id__c, customer_id__c, account__c FROM Accounting_PaymentMethod__c WHERE id__c = '1'];
        System.assertEquals('cus_1', pm.customer_id__c);
        System.assertEquals(accountingBillingAccount1.Id, pm.account__c);
        pm = [SELECT id__c, customer_id__c, account__c FROM Accounting_PaymentMethod__c WHERE id__c = '2'];
        System.assertEquals('cus_2', pm.customer_id__c);
        System.assertEquals(accountingBillingAccount2.Id, pm.account__c);
        pm = [SELECT id__c, customer_id__c, account__c FROM Accounting_PaymentMethod__c WHERE id__c = '3'];
        System.assertEquals(null, pm.customer_id__c);
        System.assertEquals(null, pm.customer_id__c);
        pm = [SELECT id__c, customer_id__c, account__c FROM Accounting_PaymentMethod__c WHERE id__c = '4'];
        System.assertEquals('cus_4', pm.customer_id__c);
        System.assertEquals(accountingBillingAccount3.Id, pm.account__c);
    }

    @isTest
    static void testBillingContact() {

        hqInt_ModelClass.Accounting_BillingContactInfo newContact = new hqInt_ModelClass.Accounting_BillingContactInfo();
        newContact.account = '1';
        newContact.emails = 'emails@old.com';

        insert newContact.createDbObject('CommCare HQ');

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(8, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_BillingContactInfo__c> billingContacts = [SELECT accountid__c FROM Accounting_BillingContactInfo__c];
        System.assertEquals(4, billingContacts.size());

        Accounting_BillingContactInfo__c contact = [SELECT accountid__c, city__c, company_name__c, country__c, emails__c, first_line__c, first_name__c,
                                                        last_name__c , phone_number__c, postal_code__c, second_line__c, state_province_region__c
                                                        FROM Accounting_BillingContactInfo__c WHERE accountid__c = '1'];
        System.assertEquals('1', contact.accountid__c);
        System.assertEquals('City_1', contact.city__c);
        System.assertEquals('Company_1', contact.company_name__c);
        System.assertEquals('US', contact.country__c);
        System.assertEquals('email_updated@gmail.com', contact.emails__c);
        System.assertEquals('first_line_1', contact.first_line__c);
        System.assertEquals('Name_1', contact.first_name__c);
        System.assertEquals('Last_name_1', contact.last_name__c);
        System.assertEquals('+48123123', contact.phone_number__c);
        System.assertEquals('123123', contact.postal_code__c);
        System.assertEquals('Second_1', contact.second_line__c);
        System.assertEquals('XD', contact.state_province_region__c);

        contact = [SELECT accountid__c, city__c, company_name__c, country__c, emails__c, first_line__c, first_name__c, last_name__c , phone_number__c,
                    postal_code__c, second_line__c, state_province_region__c FROM Accounting_BillingContactInfo__c WHERE accountid__c = '2'];
        System.assertEquals('2', contact.accountid__c);
        System.assertEquals('empty data', contact.city__c);
        System.assertEquals(null, contact.company_name__c);
        System.assertEquals(null, contact.country__c);
        System.assertEquals(null, contact.emails__c);
        System.assertEquals(null, contact.first_line__c);
        System.assertEquals(null, contact.first_name__c);
        System.assertEquals(null, contact.last_name__c);
        System.assertEquals(null, contact.phone_number__c);
        System.assertEquals('11', contact.postal_code__c);
        System.assertEquals(null, contact.second_line__c);
        System.assertEquals(null, contact.state_province_region__c);

        contact = [SELECT accountid__c, city__c, company_name__c, country__c, emails__c, first_line__c, first_name__c, last_name__c , phone_number__c,
                    postal_code__c, second_line__c, state_province_region__c FROM Accounting_BillingContactInfo__c WHERE accountid__c = '3'];
        System.assertEquals('3', contact.accountid__c);
        System.assertEquals('City_3', contact.city__c);
        System.assertEquals('Company_3', contact.company_name__c);
        System.assertEquals('US', contact.country__c);
        System.assertEquals('em31@gmail.com,em32@gmail.com', contact.emails__c);
        System.assertEquals('first_line_3', contact.first_line__c);
        System.assertEquals('Name_3', contact.first_name__c);
        System.assertEquals('Last_name_3', contact.last_name__c);
        System.assertEquals('+483123123', contact.phone_number__c);
        System.assertEquals('113', contact.postal_code__c);
        System.assertEquals('Second_3', contact.second_line__c);
        System.assertEquals('T_3', contact.state_province_region__c);

        contact = [SELECT accountid__c, city__c, company_name__c, country__c, emails__c, first_line__c, first_name__c, last_name__c , phone_number__c,
                    postal_code__c, second_line__c, state_province_region__c FROM Accounting_BillingContactInfo__c WHERE accountid__c = '4'];
        System.assertEquals('4', contact.accountid__c);
        System.assertEquals('City_4', contact.city__c);
        System.assertEquals('Company_4', contact.company_name__c);
        System.assertEquals('US', contact.country__c);
        System.assertEquals('qwe1@gmail.com', contact.emails__c);
        System.assertEquals('first_line_4', contact.first_line__c);
        System.assertEquals('Name_4', contact.first_name__c);
        System.assertEquals('Last_name_4', contact.last_name__c);
        System.assertEquals('+483444123', contact.phone_number__c);
        System.assertEquals('11443', contact.postal_code__c);
        System.assertEquals('Second_4', contact.second_line__c);
        System.assertEquals('T_4', contact.state_province_region__c);
    }

    @isTest
    static void testPaymentRecord() {
        Accounting_PaymentMethod__c pm1 = new Accounting_PaymentMethod__c(id__c = '1', customer_id__c = 'ww1', Server_Name__c = 'CommCare HQ');
        Accounting_PaymentMethod__c pm2 = new Accounting_PaymentMethod__c(id__c = '2', customer_id__c = 'ww2', Server_Name__c = 'CommCare HQ');
        insert pm1;
        insert pm2;

        Accounting_Paymentrecord__c pr = new Accounting_Paymentrecord__c(id__c = '3', payment_method__c = pm2.Id, Server_Name__c = 'CommCare HQ');
        insert pr;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(9, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_Paymentrecord__c> pRecords = [SELECT id__c FROM Accounting_Paymentrecord__c];
        System.assertEquals(3, pRecords.size());

        Accounting_Paymentrecord__c prec = [SELECT id__c, transaction_id__c, payment_method__c FROM Accounting_Paymentrecord__c WHERE id__c = '1'];
        System.assertEquals('ch_1', prec.transaction_id__c);
        System.assertEquals(pm1.Id, prec.payment_method__c);
        prec = [SELECT id__c, transaction_id__c, payment_method__c FROM Accounting_Paymentrecord__c WHERE id__c = '2'];
        System.assertEquals('ch_2', prec.transaction_id__c);
        System.assertEquals(pm2.Id, prec.payment_method__c);
        prec = [SELECT id__c, transaction_id__c, payment_method__c FROM Accounting_Paymentrecord__c WHERE id__c = '3'];
        System.assertEquals('ch_3', prec.transaction_id__c);
        System.assertEquals(null, prec.payment_method__c);
    }

    @isTest
    static void testBillingAccount() {
        Accounting_BillingAccount__c bacc = new Accounting_BillingAccount__c(id__c = '2', Server_Name__c = 'CommCare HQ');
        insert bacc;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(10, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_BillingAccount__c> billings = [SELECT id__c FROM Accounting_BillingAccount__c];
        System.assertEquals(3, billings.size());

        Accounting_BillingAccount__c billing = [SELECT id__c, last_payment_method__c, pre_or_post_pay__c FROM Accounting_BillingAccount__c
                                                 WHERE id__c = '1'];
        System.assertEquals('CC_ONE_TIME', billing.last_payment_method__c);
        System.assertEquals('PREPAY', billing.pre_or_post_pay__c);

        billing = [SELECT id__c, last_payment_method__c, pre_or_post_pay__c FROM Accounting_BillingAccount__c WHERE id__c = '2'];
        System.assertEquals('CC_AUTO', billing.last_payment_method__c);
        System.assertEquals('NOT_SET', billing.pre_or_post_pay__c);

        billing = [SELECT id__c, last_payment_method__c, pre_or_post_pay__c FROM Accounting_BillingAccount__c WHERE id__c = '3'];
        System.assertEquals('NONE', billing.last_payment_method__c);
        System.assertEquals('POSTPAY', billing.pre_or_post_pay__c);
    }

    @isTest
    static void testSubscription() {
        Accounting_Subscription__c sub = new Accounting_Subscription__c(id__c = '1', Server_Name__c = 'CommCare HQ');
        insert sub;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(11, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_Subscription__c> subscriptions = [SELECT id__c FROM Accounting_Subscription__c];
        System.assertEquals(4, subscriptions.size());

        Accounting_Subscription__c subscription = [SELECT id__c, service_type__c, pro_bono_status__c, funding_source__c
                                                        FROM Accounting_Subscription__c WHERE id__c = '1'];
        System.assertEquals('NOT_SET', subscription.service_type__c);
        System.assertEquals('NOT_SET', subscription.pro_bono_status__c);
        System.assertEquals('CLIENT', subscription.funding_source__c);

        subscription = [SELECT id__c, service_type__c, pro_bono_status__c, funding_source__c FROM Accounting_Subscription__c
                            WHERE id__c = '2'];
        System.assertEquals('NOT_SET', subscription.service_type__c);
        System.assertEquals('NOT_SET', subscription.pro_bono_status__c);
        System.assertEquals('CLIENT', subscription.funding_source__c);

        subscription = [SELECT id__c, service_type__c, pro_bono_status__c, funding_source__c FROM Accounting_Subscription__c
                            WHERE id__c = '3'];
        System.assertEquals('TRIAL', subscription.service_type__c);
        System.assertEquals('NOT_SET', subscription.pro_bono_status__c);
        System.assertEquals('CLIENT', subscription.funding_source__c);

        subscription = [SELECT id__c, service_type__c, pro_bono_status__c, funding_source__c FROM Accounting_Subscription__c
                            WHERE id__c = '4'];
        System.assertEquals('PRODUCT', subscription.service_type__c);
        System.assertEquals('FULL_PRICE', subscription.pro_bono_status__c);
        System.assertEquals('CLIENT', subscription.funding_source__c);
    }

    @isTest
    static void testInvoice() {
        Accounting_Subscription__c sub1 = new Accounting_Subscription__c(id__c = '277', Server_Name__c = 'CommCare HQ');
        insert sub1;
        Accounting_Subscription__c sub2 = new Accounting_Subscription__c(id__c = '325', Server_Name__c = 'CommCare HQ');
        insert sub2;

        Accounting_Invoice__c inv1 = new Accounting_Invoice__c(id__c = '3', Server_Name__c = 'CommCare HQ');
        insert inv1;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(12, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_Invoice__c> invs = [SELECT id__c FROM Accounting_Invoice__c];
        System.assertEquals(3, invs.size());

        Accounting_Invoice__c invoice = [SELECT id__c, Accounting_Subscription__c FROM Accounting_Invoice__c WHERE id__c = '1'];
        System.assertEquals(sub1.Id, invoice.Accounting_Subscription__c);

        invoice = [SELECT id__c, Accounting_Subscription__c FROM Accounting_Invoice__c WHERE id__c = '2'];
        System.assertEquals(null, invoice.Accounting_Subscription__c);

        invoice = [SELECT id__c, Accounting_Subscription__c FROM Accounting_Invoice__c WHERE id__c = '3'];
        System.assertEquals(sub2.Id, invoice.Accounting_Subscription__c);
    }

    @isTest
    static void testLineItem() {
        Accounting_Featurerate__c frate1 = new Accounting_Featurerate__c(id__c = '21', Server_Name__c = 'CommCare HQ');
        insert  frate1;
        Accounting_Featurerate__c frate2 = new Accounting_Featurerate__c(id__c = '22', Server_Name__c = 'CommCare HQ');
        insert  frate2;

        Accounting_Invoice__c inv1 = new Accounting_Invoice__c(id__c = '1', Server_Name__c = 'CommCare HQ');
        insert inv1;
        Accounting_Invoice__c inv2 = new Accounting_Invoice__c(id__c = '2', Server_Name__c = 'CommCare HQ');
        insert inv2;

        Accounting_LineItems__c lineItem1 = new Accounting_LineItems__c(id__c = '1', invoice__c = inv1.Id, Server_Name__c = 'CommCare HQ');
        insert lineItem1;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(13, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_LineItems__c> invs = [SELECT id__c FROM Accounting_LineItems__c];
        System.assertEquals(3, invs.size());

        Accounting_LineItems__c lineItem = [SELECT id__c, invoice__c, Accounting_FeatureRate__c FROM Accounting_LineItems__c WHERE id__c = '1'];
        System.assertEquals(null, lineItem.Accounting_FeatureRate__c);
        System.assertEquals(inv1.Id, lineItem.invoice__c);

        lineItem = [SELECT id__c, invoice__c, Accounting_FeatureRate__c FROM Accounting_LineItems__c WHERE id__c = '2'];
        System.assertEquals(frate1.Id, lineItem.Accounting_FeatureRate__c);
        System.assertEquals(inv1.Id, lineItem.invoice__c);

        lineItem = [SELECT id__c, invoice__c, Accounting_FeatureRate__c FROM Accounting_LineItems__c WHERE id__c = '3'];
        System.assertEquals(frate2.Id, lineItem.Accounting_FeatureRate__c);
        System.assertEquals(inv2.Id, lineItem.invoice__c);
    }

    @isTest
    static void testSubAdjust() {
        Accounting_Subscription__c sub1 = new Accounting_Subscription__c(id__c = '1', Server_Name__c = 'CommCare HQ');
        insert sub1;
        Accounting_Subscription__c sub2 = new Accounting_Subscription__c(id__c = '2', Server_Name__c = 'CommCare HQ');
        insert sub2;

        Accounting_SubscriptionAdjustment__c sadjust1 = new Accounting_SubscriptionAdjustment__c(id__c = '1', Server_Name__c = 'CommCare HQ');
        insert sadjust1;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(14, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_SubscriptionAdjustment__c> invs = [SELECT id__c, subscription__c FROM Accounting_SubscriptionAdjustment__c];
        System.assertEquals(2, invs.size());

        Accounting_SubscriptionAdjustment__c sadjust = [SELECT id__c, subscription__c FROM Accounting_SubscriptionAdjustment__c WHERE id__c = '1'];
        System.assertEquals(sub1.Id, sadjust.subscription__c);

        sadjust = [SELECT id__c, subscription__c FROM Accounting_SubscriptionAdjustment__c WHERE id__c = '2'];
        System.assertEquals(sub2.Id, sadjust.subscription__c);
    }

    @isTest
    static void testCreditLine() {
        Accounting_Subscription__c sub1 = new Accounting_Subscription__c(id__c = '1', Server_Name__c = 'CommCare HQ');
        insert sub1;
        Accounting_Subscription__c sub2 = new Accounting_Subscription__c(id__c = '2', Server_Name__c = 'CommCare HQ');
        insert sub2;

        Accounting_BillingAccount__c accountingBillingAccount1 = new Accounting_BillingAccount__c(Name = 'tb1', id__c = '1', Server_Name__c = 'CommCare HQ');
        Accounting_BillingAccount__c accountingBillingAccount2 = new Accounting_BillingAccount__c(Name = 'tb2', id__c = '3', Server_Name__c = 'CommCare HQ');

        Accounting_CreditLine__c cLine1 = new Accounting_CreditLine__c(id__c = '3', Server_Name__c = 'CommCare HQ');
        insert cLine1;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(15, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_CreditLine__c> invs = [SELECT id__c FROM Accounting_CreditLine__c];
        System.assertEquals(3, invs.size());

        Accounting_CreditLine__c cLine = [SELECT id__c, account__c, Subscription__c FROM Accounting_CreditLine__c WHERE id__c = '1'];
        System.assertEquals(sub1.Id, cLine.subscription__c);
        System.assertEquals(accountingBillingAccount1.Id, cLine.account__c);

        cLine = [SELECT id__c, account__c, Subscription__c FROM Accounting_CreditLine__c WHERE id__c = '2'];
        System.assertEquals(sub2.Id, cLine.subscription__c);
        System.assertEquals(null, cLine.account__c);

        cLine = [SELECT id__c, account__c, Subscription__c FROM Accounting_CreditLine__c WHERE id__c = '3'];
        System.assertEquals(null, cLine.subscription__c);
        System.assertEquals(accountingBillingAccount2.Id, cLine.account__c);
    }

    @isTest
    static void testCreditAdjust() {
        Accounting_CreditAdjustment__c cadj1 = new Accounting_CreditAdjustment__c(id__c = '2', Server_Name__c = 'CommCare HQ');
        insert cadj1;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new hqInt_HttpMock());
        HqBatchJobHelper.runNextBatchJob(16, 'CommCare HQ', new List<String>());
        Test.stopTest();

        List<Accounting_CreditAdjustment__c> invs = [SELECT id__c FROM Accounting_CreditAdjustment__c];
        System.assertEquals(3, invs.size());

        Accounting_CreditAdjustment__c cAdj = [SELECT id__c, amount__c FROM Accounting_CreditAdjustment__c WHERE id__c = '1'];
        System.assertEquals(12.00, cAdj.amount__c);

        cAdj = [SELECT id__c, amount__c FROM Accounting_CreditAdjustment__c WHERE id__c = '2'];
        System.assertEquals(500, cAdj.amount__c);

        cAdj = [SELECT id__c, amount__c FROM Accounting_CreditAdjustment__c WHERE id__c = '3'];
        System.assertEquals(-500, cAdj.amount__c);
    }

/**
    @isTest
    static void hqIntShouldUpdateMissingRelationsInSubscriberCustomObject() {
        Test.startTest();

        Domain__c d1 = buildDomain(1);
        Domain__c d2 = buildDomain(2);
        Domain__c d3 = buildDomain(3);
        buildSubscriber(1, null);
        buildSubscriber(2, null);
        buildSubscriber(3, d3.Id);   

        List<Accounting_Subscriber__c> subscribers = [SELECT id__c, domain__c, domain_lookup__c FROM Accounting_Subscriber__c];
        System.assertEquals(3, subscribers.size());

        hqInt_BatchFetchObjectSubscriber batchSubscriber = new hqInt_BatchFetchObjectSubscriber(1);
        batchSubscriber.finish(null);

        Accounting_Subscriber__c subscriber = [SELECT id__c, domain__c, domain_lookup__c FROM Accounting_Subscriber__c WHERE id__c = 'external_id_1'];
        System.assertEquals(d1.Id, subscriber.domain_lookup__c);
        subscriber = [SELECT id__c, domain__c, domain_lookup__c FROM Accounting_Subscriber__c WHERE id__c = 'external_id_2'];
        System.assertEquals(d2.Id, subscriber.domain_lookup__c);
        subscriber = [SELECT id__c, domain__c, domain_lookup__c FROM Accounting_Subscriber__c WHERE id__c = 'external_id_3'];
        System.assertEquals(d3.Id, subscriber.domain_lookup__c);
        Test.stopTest();
    }

    @isTest
    static void hqIntShouldUpdateMissingRelationsInAccountingCustomObject() {
        Test.startTest();

        Domain__c d1 = buildDomain(1);
        Domain__c d2 = buildDomain(2);
        Domain__c d3 = buildDomain(3);
        Accounting_Subscriber__c s1 = buildSubscriber(1, null);
        Accounting_Subscriber__c s2 = buildSubscriber(2, null);
        Accounting_Subscriber__c s3 = buildSubscriber(3, d3.Id);
        Accounting_Subscription__c sub1 = buildSubscription(1, s1.Id);
        Accounting_Subscription__c sub2 = buildSubscription(2, s2.Id);
        Accounting_Subscription__c sub3 = buildSubscription(3, s3.Id);
        buildInvoice(1, sub1.Id, null);
        buildInvoice(2, sub2.Id, null);
        buildInvoice(3, sub3.Id, d3.Id);

        List<Accounting_Invoice__c> invoiceList = [SELECT id__c, Project_Space__c FROM Accounting_Invoice__c];
        System.assertEquals(3, invoiceList.size());

        hqInt_BatchFetchObjectAcctingInvoice batchInvoice = new hqInt_BatchFetchObjectAcctingInvoice(1);
        batchInvoice.finish(null);

        Accounting_Invoice__c invoice = [SELECT id__c, Project_Space__c FROM Accounting_Invoice__c WHERE id__c = 'external_id_1'];
        System.assertEquals(d1.Id, invoice.Project_Space__c);
        invoice = [SELECT id__c, Project_Space__c FROM Accounting_Invoice__c WHERE id__c = 'external_id_2'];
        System.assertEquals(d2.Id, invoice.Project_Space__c);
        invoice = [SELECT id__c, Project_Space__c FROM Accounting_Invoice__c WHERE id__c = 'external_id_3'];
        System.assertEquals(d3.Id, invoice.Project_Space__c);
        Test.stopTest();
    }

*/
    static private Decimal calculateMRRForDomain(Id domainId, Integer expectedSize) {
        Decimal sumForDomain = 0;
        List<Accounting_Subscription__c> subsForDomain1 = [SELECT Lifetime_MRR__c, accounting_software_monthly_fee__c FROM Accounting_Subscription__c WHERE Accounting_subscriber_domain__c =: domainId];
        System.assertEquals(expectedSize, subsForDomain1.size());

        for (Accounting_Subscription__c s : subsForDomain1) {
            System.debug('For domain : ' + domainId + ' ' + s.Lifetime_MRR__c + ' calculated by : ' + s.accounting_software_monthly_fee__c);
            sumForDomain += s.Lifetime_MRR__c;
        }

        return sumForDomain;
    }

    static private void createSoftwarePlan(String planId) {
        hqInt_ModelClass.Accounting_SoftwarePlan plan = new hqInt_ModelClass.Accounting_SoftwarePlan();
        plan.id = planId;
        plan.name = 'sampleName' + planId;
        insert plan.createDbObject('CommCare HQ');
    }

    static private void createProductRate(String rateId) {
        hqInt_ModelClass.Accounting_SoftwareProductRate rate = new hqInt_ModelClass.Accounting_SoftwareProductRate();
        rate.id = rateId;
        rate.is_active = true;
        insert rate.createDbObject('CommCare HQ');
    }

    static private Accounting_Invoice__c buildInvoice(Integer i, Id subsciptionId, Id domainId) {
        hqInt_ModelClass.Accounting_Invoice a = new hqInt_ModelClass.Accounting_Invoice();
        a.id = 'external_id_' + i;
        a.is_hidden = false;
        a.is_hidden_to_ops = false;
        Accounting_Invoice__c aFromDB  = a.createDbObject(subsciptionId, domainId, 'Pro', 'CommCare HQ');
        insert aFromDb;
        return aFromDb;
    }

    static private Accounting_Subscription__c buildSubscription(Integer i, Id subscriberId) {
        hqInt_ModelClass.Accounting_Subscription a = new hqInt_ModelClass.Accounting_Subscription();
        a.id = 'external_id_' + i;
        a.is_active = true;
        a.do_not_invoice = true;
        a.auto_generate_credits = false;
        a.is_trial = true;
        a.is_hidden_to_ops = false;
        Accounting_Subscription__c aFromDB  = a.createDbObject(null, null, subscriberId, null, 'CommCare HQ');
        insert aFromDb;
        return aFromDb;
    }

    static private Accounting_Subscriber__c buildSubscriber(Integer i, Id domainId) {
        hqInt_ModelClass.Accounting_Subscriber a = new hqInt_ModelClass.Accounting_Subscriber();
        a.id = 'external_id_' + i;
        a.domain = 'domain_name_' + i;
        Accounting_Subscriber__c aFromDB  = a.createDbObject(domainId, 'CommCare HQ');
        insert aFromDb;
        return aFromDb;
    }

    static private Domain__c buildDomain(Integer i) {
        hqInt_Model_DomainClass d = new hqInt_Model_DomainClass();
        d.x_id = 'domain_' + i;
        d.Name = 'domain_name_' + i;
        d.tags = new List<String> { ' ' };
        Domain__c domainFromDb = d.createDbObject(null, 'CommCare HQ');
        insert domainFromDb;
        return domainFromDb;
    }

    static private void generateDataForDomainSnapshot() {
        Accounting_SoftwareProductRate__c productRate1 = new Accounting_SoftwareProductRate__c(is_active__c = true,  monthly_fee__c = 150, Server_Name__c = 'CommCare HQ');
        Accounting_SoftwareProductRate__c productRate2 = new Accounting_SoftwareProductRate__c(is_active__c = true,  monthly_fee__c = 75, Server_Name__c = 'CommCare HQ');
        Accounting_SoftwareProductRate__c productRate3 = new Accounting_SoftwareProductRate__c(is_active__c = true,  monthly_fee__c = 25, Server_Name__c = 'CommCare HQ');

        insert productRate1;
        insert productRate2;
        insert productRate3;

        Accounting_Softwareplan__c softwarePlan1 = new Accounting_Softwareplan__c(Name = 'softwarePlan1', edition__c = 'Community', Server_Name__c = 'CommCare HQ');
        Accounting_Softwareplan__c softwarePlan2 = new Accounting_Softwareplan__c(Name = 'softwarePlan2', edition__c = 'Standard', Server_Name__c = 'CommCare HQ');
        Accounting_Softwareplan__c softwarePlan3 = new Accounting_Softwareplan__c(Name = 'softwarePlan3', edition__c = 'Pro', Server_Name__c = 'CommCare HQ');

        insert softwarePlan1;
        insert softwarePlan2;
        insert softwarePlan3;

        Accounting_SoftwarePlanVersion__c planVersion1 = new Accounting_SoftwarePlanVersion__c(is_active__c = true, Software_Product_Rate__c = productRate1.Id,
                                                                                               Accounting_SoftwarePlan__c = softwarePlan1.Id, Server_Name__c = 'CommCare HQ');
        Accounting_SoftwarePlanVersion__c planVersion2 = new Accounting_SoftwarePlanVersion__c(is_active__c = true, Software_Product_Rate__c = productRate2.Id,
                                                                                               Accounting_SoftwarePlan__c = softwarePlan2.Id, Server_Name__c = 'CommCare HQ');
        Accounting_SoftwarePlanVersion__c planVersion3 = new Accounting_SoftwarePlanVersion__c(is_active__c = true, Software_Product_Rate__c = productRate3.Id,
                                                                                               Accounting_SoftwarePlan__c = softwarePlan3.Id, Server_Name__c = 'CommCare HQ');

        insert planVersion1;
        insert planVersion2;
        insert planVersion3;

        Internal_Properties__c InternalPropRec1 = new Internal_Properties__c(self_started__c = true, Server_Name__c = 'CommCare HQ');
        Internal_Properties__c InternalPropRec2 = new Internal_Properties__c(self_started__c = true, Server_Name__c = 'CommCare HQ');
        Internal_Properties__c InternalPropRec3 = new Internal_Properties__c(self_started__c = true, Server_Name__c = 'CommCare HQ');
        Internal_Properties__c InternalPropRec4 = new Internal_Properties__c(self_started__c = true, Server_Name__c = 'CommCare HQ');
        Internal_Properties__c InternalPropRec5 = new Internal_Properties__c(self_started__c = true, Server_Name__c = 'CommCare HQ');

        insert InternalPropRec1;
        insert InternalPropRec2;
        insert InternalPropRec3;
        insert InternalPropRec4;
        insert InternalPropRec5;

        Domain__c domain1 = new Domain__c(Name = 'domain_1', Server_Name__c = 'CommCare HQ', is_test__c = 'false', cpIsActive__c = true,
                                          Wam__c = 15, cpActiveMobileUsers__c = 20, cpAllForms__c = 325, Internal_Properties__c = InternalPropRec1.Id);
        Domain__c domain2 = new Domain__c(Name = 'domain_2', Server_Name__c = 'CommCare HQ', is_test__c = 'false', cpIsActive__c = true,
                                          Wam__c = 30, cpActiveMobileUsers__c = 35, cpAllForms__c = 340, Internal_Properties__c = InternalPropRec2.Id);
        Domain__c domain3 = new Domain__c(Name = 'domain_3', Server_Name__c = 'CommCare HQ', is_test__c = 'false', cpIsActive__c = true,
                                          Wam__c = 45, cpActiveMobileUsers__c = 50, cpAllForms__c = 355, Internal_Properties__c = InternalPropRec3.Id);
        Domain__c domain4 = new Domain__c(Name = 'domain_4', Server_Name__c = 'CommCare HQ', is_test__c = 'false', cpIsActive__c = true,
                                          Wam__c = 60, cpActiveMobileUsers__c = 65, cpAllForms__c = 370, Internal_Properties__c = InternalPropRec4.Id);
        Domain__c domain5 = new Domain__c(Name = 'domain_5', Server_Name__c = 'CommCare HQ', is_test__c = 'false', cpIsActive__c = true,
                                          Wam__c = 75, cpActiveMobileUsers__c = 80, cpAllForms__c = 385, Internal_Properties__c = InternalPropRec5.Id);

        insert domain1;
        insert domain2;
        insert domain3;
        insert domain4;
        insert domain5;

        Accounting_Subscription__c subscription1 = new Accounting_Subscription__c(Created_By__c = 'Sample 1', date_start__c = Date.newInstance(2015, 11, 2), date_end__c = Date.newInstance(2016, 2 ,1), is_active__c = true,
                                                          Accounting_subscriber_domain__c = domain1.Id, plan_version__c = planVersion1.Id, Server_Name__c = 'CommCare HQ',
                                                          is_trial__c = false, service_type__c = 'Self_service');
        insert subscription1;
        Accounting_Subscription__c subscription2 = new Accounting_Subscription__c(Created_By__c = 'Sample 2', date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 2 ,1), is_active__c = true,
                                                          Accounting_subscriber_domain__c = domain2.Id, plan_version__c = planVersion2.Id, Server_Name__c = 'CommCare HQ',
                                                          is_trial__c = false, service_type__c = 'Product');
        insert subscription2;
        Accounting_Subscription__c subscription3 = new Accounting_Subscription__c(Created_By__c = 'Sample 3', date_start__c = Date.newInstance(2014, 1, 1), date_end__c = Date.newInstance(2014, 3 ,4), is_active__c = true,
                                                          Accounting_subscriber_domain__c = domain3.Id, plan_version__c = planVersion3.Id, Server_Name__c = 'CommCare HQ',
                                                          is_trial__c = false, service_type__c = 'Self_service');
        insert subscription3;
        Accounting_Subscription__c subscription4 = new Accounting_Subscription__c(Created_By__c = 'Sample 4', date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 2 ,1), is_active__c = true,
                                                          Accounting_subscriber_domain__c = domain4.Id, plan_version__c = planVersion1.Id, Server_Name__c = 'CommCare HQ',
                                                          is_trial__c = false, service_type__c = 'Self_service');
        insert subscription4;
        Accounting_Subscription__c subscription5 = new Accounting_Subscription__c(Created_By__c = 'Sample 5', date_start__c = Date.newInstance(2016, 1, 1), date_end__c = Date.newInstance(2016, 2 ,1), is_active__c = true,
                                                          Accounting_subscriber_domain__c = domain5.Id, plan_version__c = planVersion2.Id, Server_Name__c = 'CommCare HQ',
                                                          is_trial__c = false, service_type__c = 'Product');
        insert subscription5;
    }

    public static Map<Id, Decimal> getTestDataForEndMonth(List<Accounting_Subscription__c> scope) {
        Map<Id, Decimal> result = new Map<Id, Decimal>();
        for (Accounting_Subscription__c sub : scope) {
            if (sub.Created_By__c == 'Sample 1') {
                result.put(sub.Accounting_subscriber_domain__c, 325); //325 - 200 = 125
            } else if (sub.Created_By__c == 'Sample 2') {
                result.put(sub.Accounting_subscriber_domain__c, 340); //340 - 100 = 240
            } else if (sub.Created_By__c == 'Sample 3') {
                result.put(sub.Accounting_subscriber_domain__c, 355); //355 - 150 = 205
            } else if (sub.Created_By__c == 'Sample 4') {
                result.put(sub.Accounting_subscriber_domain__c, 370); //370 - 170 = 200
            }
        }
        return result;
    }

    public static Map<Id, Decimal> getTestDataForStartMonth(List<Accounting_Subscription__c> scope) {
        Map<Id, Decimal> result = new Map<Id, Decimal>();
        for (Accounting_Subscription__c sub : scope) {
            if (sub.Created_By__c == 'Sample 1') {
                result.put(sub.Accounting_subscriber_domain__c, 200); //325 - 200 = 125
            } else if (sub.Created_By__c == 'Sample 2') {
                result.put(sub.Accounting_subscriber_domain__c, 100); //340 - 100 = 240
            } else if (sub.Created_By__c == 'Sample 3') {
                result.put(sub.Accounting_subscriber_domain__c, 150); //355 - 150 = 205
            } else if (sub.Created_By__c == 'Sample 4') {
                result.put(sub.Accounting_subscriber_domain__c, 170); //370 - 170 = 200
            }
        }
        return result;
    }
}