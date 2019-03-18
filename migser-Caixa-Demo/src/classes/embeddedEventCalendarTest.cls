@isTest
public class embeddedEventCalendarTest {
	static testMethod void test() {
        Account acct = new Account(Name='My Account');
        insert acct;
        embeddedEventCalendarController.getEvents(acct.Id);
        String selDate = '8/25/2015';
        embeddedEventCalendarController.dayEvent(selDate, acct.Id);
    }
}