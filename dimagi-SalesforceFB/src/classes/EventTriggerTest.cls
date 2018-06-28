@isTest
public class EventTriggerTest {
    static testmethod void testbatch() {

        Account theAccount = new Account(
            Name ='Test Account'
        );
        insert theAccount;

        Contact theContact = new Contact(
            LastName = 'Test Contact 1',
            AccountId = theAccount.Id
        );
        insert theContact;

        Opportunity theOpp1 = new Opportunity(
            Name = 'Test Opp',
            CloseDate = date.today()+ 1,
            StageName = 'Stage 2 - Talking'
        );
        insert theOpp1;
        Opportunity theOpp2 = new Opportunity(
            Name = 'Test Opp2',
            CloseDate = date.today()+ 1,
            StageName = 'Stage 2 - Talking'
        );
        insert theOpp2;

        OpportunityContactRole contactRole1 = new OpportunityContactRole(
            OpportunityId = theOpp1.id,
            ContactId = theContact.Id
        );
        insert contactRole1;
        
        OpportunityContactRole contactRole2 = new OpportunityContactRole(
            OpportunityId = theOpp2.id,
            ContactId = theContact.Id
        );
        insert contactRole2;
        
        Event theEvent = new Event(
            Subject = 'Call',
            WhoId = theContact.Id,
            StartDateTime = date.Today(),
            EndDateTime = date.Today() + 1

        );
        insert theEvent;
        
        List<Event> eventList = [Select Id from Event where WhatId = :theOpp1.Id];
        system.assertNotEquals(eventList, null);
    

    }    
}