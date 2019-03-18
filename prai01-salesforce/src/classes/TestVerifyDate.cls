@isTest
private class TestVerifyDate {
    @isTest static void testDate(){
        Date d1 = date.parse('01/01/2016');
		Date d2 = date.parse('01/15/2016');                             
        Date rslt = VerifyDate.CheckDates(d1, d2);
        System.assertEquals(d2, rslt,'Expected result is date2 of value 2016-01-15' );
        
        d1 = date.parse('01/01/2016');
        d2 = date.parse('02/02/2016');
        rslt = VerifyDate.CheckDates(d1, d2);
        System.assertEquals(date.parse('01/31/2016'), rslt,'Expected result is date2 of value 2016-01-31' );
    }
}