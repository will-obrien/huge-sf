@isTest
public class LeadConversionControllerTest {

    public static testMethod void shouldConvertLeadAndSetFields() {
        Test.startTest();

        Lead testLead = new Lead(FirstName = 'Tom', LastName = 'Smith', Company = 'Smith IT Company');
        insert testLead;
        LeadConversionController convController = new LeadConversionController(testLead.Id);
        Business_Unit__c bu = new Business_Unit__c(Name = 'Inc');
        insert bu;

        PageReference contrPage = convController.doConversion();
    
        Contact newContact = [SELECT Id, Status__c FROM Contact WHERE Name = 'Tom Smith'];
        Opportunity newOpp = [SELECT Id, StageName, Probability, of_Execution_budget_for_GS__c, Channel_Response__c, Implementation_Type__c, Renewal_expected__c,
                                             Opportunity_Source__c, Duration_months__c, Opportunity_Owning_Entity__c, CloseDate FROM Opportunity WHERE Name = 'Smith IT Company'];

        System.assertEquals('1- Working - Active Opp Development', newContact.Status__c);
        System.assertEquals('Stage 3 - Prospect', newOpp.StageName);
        System.assertEquals(20, newOpp.Probability);
        System.assertEquals(0, newOpp.of_Execution_budget_for_GS__c);
        System.assertEquals('Inside Sales', newOpp.Channel_Response__c);
        System.assertEquals('Self Service', newOpp.Implementation_Type__c);
        System.assertEquals('Inbound', newOpp.Opportunity_Source__c);
        System.assertEquals(12, newOpp.Duration_months__c);
        System.assertEquals(Date.today().addMonths(2).toStartofMonth().addDays(-1), newOpp.CloseDate);
        System.assertEquals(true, newOpp.Renewal_expected__c);
        System.assertEquals(bu.Id, newOpp.Opportunity_Owning_Entity__c);

        Test.stopTest();
    }

    public static testMethod void shouldConvertLeadAndSetFieldsWhenAccountExist() {
        Test.startTest();

        Account acc = new Account(Name = 'Custom ACC');
        insert acc;
        Lead testLead = new Lead(FirstName = 'Tom', LastName = 'Smith', Company = 'Smith IT Company', account_name__c = acc.Id);
        insert testLead;
        LeadConversionController convController = new LeadConversionController(testLead.Id);
        Business_Unit__c bu = new Business_Unit__c(Name = 'Inc');
        insert bu;

        PageReference contrPage = convController.doConversion();

        Contact newContact = [SELECT Id, Status__c FROM Contact WHERE Name = 'Tom Smith'];
        Opportunity newOpp = [SELECT Id, StageName, Probability, of_Execution_budget_for_GS__c, Channel_Response__c, Implementation_Type__c, Renewal_expected__c,
                                             Opportunity_Source__c, Duration_months__c, Opportunity_Owning_Entity__c, CloseDate FROM Opportunity WHERE Name = 'Smith IT Company'];

        List<Account> accounts = [SELECT Id, Name FROM Account];
        System.assertEquals(1, accounts.size());
        System.assertEquals('Custom ACC', accounts.get(0).Name);
        System.assertEquals('1- Working - Active Opp Development', newContact.Status__c);
        System.assertEquals('Stage 3 - Prospect', newOpp.StageName);
        System.assertEquals(20, newOpp.Probability);
        System.assertEquals(0, newOpp.of_Execution_budget_for_GS__c);
        System.assertEquals('Inside Sales', newOpp.Channel_Response__c);
        System.assertEquals('Self Service', newOpp.Implementation_Type__c);
        System.assertEquals('Inbound', newOpp.Opportunity_Source__c);
        System.assertEquals(12, newOpp.Duration_months__c);
        System.assertEquals(Date.today().addMonths(2).toStartofMonth().addDays(-1), newOpp.CloseDate);
        System.assertEquals(true, newOpp.Renewal_expected__c);
        System.assertEquals(bu.Id, newOpp.Opportunity_Owning_Entity__c);

        Test.stopTest();
    }

    public static testMethod void shouldConvertLeadAndSetFieldsWhenAccountExist2() {
        Test.startTest();

        Account acc = new Account(Name = 'Smith IT Company');
        insert acc;
        Lead testLead = new Lead(FirstName = 'Tom', LastName = 'Smith', Company = 'Smith IT Company');
        insert testLead;
        LeadConversionController convController = new LeadConversionController(testLead.Id);
        Business_Unit__c bu = new Business_Unit__c(Name = 'Inc');
        insert bu;

        PageReference contrPage = convController.doConversion();

        Contact newContact = [SELECT Id, Status__c FROM Contact WHERE Name = 'Tom Smith'];
        Opportunity newOpp = [SELECT Id, StageName, Probability, of_Execution_budget_for_GS__c, Channel_Response__c, Implementation_Type__c, Renewal_expected__c,
                                             Opportunity_Source__c, Duration_months__c, Opportunity_Owning_Entity__c, CloseDate FROM Opportunity WHERE Name = 'Smith IT Company'];

        List<Account> accounts = [SELECT Id, Name FROM Account];
        System.assertEquals(1, accounts.size());
        System.assertEquals(acc.Id, accounts.get(0).Id);

        Test.stopTest();
    }

    public static testMethod void testLeadConversionTrigger() {
        Test.startTest();

        Lead testLead = new Lead(FirstName = 'Tom', LastName = 'Smith', Company = 'Smith IT Company');
        insert testLead;

        testLead.Status = 'Working - Talking';
        testLead.Lead_Status_Reason__c = 'Contacted - Sent Email #1';
        testLead.Response_Date__c = Date.today();
        // testLead.First_Call_Date__c  = Date.today();
        testLead.Follow_up_calls_held__c = 11;

        update testLead;

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(testLead.Id);
        lc.setConvertedStatus('Converted');
        Database.LeadConvertResult lcr = Database.convertLead(lc);

        Test.stopTest();

        Opportunity newOpp = [SELECT Lead_Status__c, Lead_Status_Reason__c, Lead_Ever_Responded__c, Lead_first_call_held__c, Lead_follow_up_calls_held__c
                              FROM Opportunity WHERE Name = 'Smith IT Company' LIMIT 1];

        System.assertEquals('Converted', newOpp.Lead_Status__c);
        System.assertEquals('Contacted - Sent Email #1', newOpp.Lead_Status_Reason__c);
        System.assertEquals(true, newOpp.Lead_Ever_Responded__c);
        System.assertEquals(false, newOpp.Lead_first_call_held__c);
        System.assertEquals(11, newOpp.Lead_follow_up_calls_held__c);
    }
}