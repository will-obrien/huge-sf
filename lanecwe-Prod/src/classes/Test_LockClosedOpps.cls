@isTest
public class Test_LockClosedOpps{
    static testMethod void testLockClosedOpps(){
        Date d = date.today();
    	Account a = new Account();
        a.OwnerId = '005300000062EqW';
        a.Name = 'Test Account';
        insert a;
        
        Opportunity o = new Opportunity();
        o.Name = 'Test Opportunity';
        o.OwnerId = '005300000062EqW';
        o.StageName = 'Negotiating';
        o.CloseDate = d;
        o.AccountId = a.Id;
        insert o;
        
        try
        {
        	o.StageName = 'Closed Lost';
         	update o;
        }
        catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('This opportunity has been closed. No updates are permitted.') ? true : false;
            System.assertEquals(expectedExceptionThrown, true);
        }
    }
}