@isTest

private class DailyLeadProcessorTest {
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testMethod void testScheduledJob() {
    List<Lead> leads = new List<Lead>();

    for (Integer i=0; i < 200; i++){
        Lead l = new Lead(
            FirstName = 'Lead First Name' + i,
            LastName = 'Lead Last Name ' + i,
            Status = 'Working - Contacted',
            Company = 'Test Company' + i
            );
        leads.add(l);
        }
    insert leads;
    
    //Get the IDs of the Lead we just inserted
    Map<Id, Lead> leadMap = new Map<Id, Lead>(leads);
    List<Id> leadIds = new List<Id>(leadMap.keySet());
    
        Test.startTest();
        //Schedule the test job
        String jobId = System.schedule('ScheduleApexTest', CRON_EXP, new DailyLeadProcessor());
        //Verify the scheduled job has not run yet
        List<Lead> ll = [SELECT Id FROM lead WHERE Id IN :leadIds AND Company = 'Fake Company'];
        System.assertEquals(0, ll.size(), 'Leads exists before job has run');
        Test.stopTest();
        
        //Now that the scheduled job has excecuted, check that our leads were created
        
        ll = [SELECT Id FROM Lead WHERE Id in :leadIds];
        System.assertEquals(leadIds.size(), ll.size(),'Leads were not created!');
    }
 }