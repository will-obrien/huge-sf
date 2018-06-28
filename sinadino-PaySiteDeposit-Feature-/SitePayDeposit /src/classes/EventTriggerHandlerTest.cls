@isTest
private class EventTriggerHandlerTest {
    
    @isTest static void test_method_one() {
        Lead lead = new Lead(FirstName = 'Joey',
                             LastName = 'Chan',
                             Email = 'Test@email.com',
                             Company = 'CloudJedi');
        insert lead;

        DateTime dt = DateTime.newInstance(2014, 5, 8);

        Event evt2 = new Event(Subject = 'EMG JV Meeting',
                              WhoId = lead.Id,
                              StartDateTime = dt,
                              DurationInMinutes = 30);
        insert evt2;

        Event evt = new Event(Subject = 'EMG Event Evaluation',
                              WhoId = lead.Id,
                              StartDateTime = dt,
                              DurationInMinutes = 30);
        insert evt;
        update evt;

        Lead l = [Select Event_Evaluation_Appointment__c From Lead Where Id = :lead.Id];
        System.assertEquals(dt, l.Event_Evaluation_Appointment__c);

    }

    @isTest static void test_method_two() {
        Contact con = new Contact(FirstName = 'Joey',
                             LastName = 'Chan',
                             Email = 'Test@email.com');
        insert con;

        DateTime dt = DateTime.newInstance(2014, 5, 8);
        Event evt = new Event(Subject = 'EMG JVP Meeting',
                              WhoId = con.Id,
                              StartDateTime = dt,
                              DurationInMinutes = 30);
        insert evt;


    }
}