/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_AccountStamp {

    static testMethod void testStamp() {
        AccountStamp as1 = new AccountStamp();
        as1.webinarId = 'test1';
		as1.attendanceDate = Date.today();
		as1.attendanceTime = Time.newInstance(1, 0, 0, 0);
		as1.joinTime = DateTime.newInstance(Date.today(), Time.newInstance(1,0,0,0));
		as1.webinarSourceOther = 'test1';
		as1.duration = 1;
		as1.sessions = 1;
		as1.presenter = 'test1';
		as1.isFirst = true;
		as1.creditName = 'test1';
		as1.creditId = 'test1';
		as1.attended = true;
		as1.stampType = 'test1';
		as1.status = 'test1';
		as1.sendNumber = 'test1';
        
        AccountStamp as2 = new AccountStamp();
       	as2.webinarId = 'test2';
		as2.attendanceDate = Date.today();
		as2.attendanceTime = Time.newInstance(1, 1, 0, 0);
		as2.joinTime = DateTime.newInstance(Date.today(), Time.newInstance(1,0,0,0));
		as2.webinarSourceOther = 'test2';
		as2.duration = 1;
		as2.sessions = 1;
		as2.presenter = 'test2';
		as2.isFirst = true;
		as2.creditName = 'test2';
		as2.creditId = 'test2';
		as2.attended = true;
		as2.stampType = 'test2';
		as2.status = 'test2';
		as2.sendNumber = 'test2';
		
		AccountStamp as3 = new AccountStamp();
       	as3.webinarId = 'test3';
		as3.attendanceDate = Date.today();
		as3.attendanceTime = Time.newInstance(1, 0, 0, 0);
		as3.joinTime = DateTime.newInstance(Date.today(), Time.newInstance(1,0,0,0));
		as3.webinarSourceOther = 'test3';
		as3.duration = 1;
		as3.sessions = 1;
		as3.presenter = 'test3';
		as3.isFirst = true;
		as3.creditName = 'test3';
		as3.creditId = 'test3';
		as3.attended = true;
		as3.stampType = 'test3';
		as3.status = 'test3';
		as3.sendNumber = 'test3';
		
		AccountStamp as4 = new AccountStamp();
       	as4.webinarId = 'test4';
		as4.attendanceDate = Date.today().addDays(-1);
		as4.attendanceTime = Time.newInstance(1, 0, 0, 0);
		as4.joinTime = DateTime.newInstance(Date.today(), Time.newInstance(1,0,0,0));
		as4.webinarSourceOther = 'test4';
		as4.duration = 1;
		as4.sessions = 1;
		as4.presenter = 'test4';
		as4.isFirst = true;
		as4.creditName = 'test4';
		as4.creditId = 'test4';
		as4.attended = true;
		as4.stampType = 'test4';
		as4.status = 'test4';
		as4.sendNumber = 'test4';
		
		List<AccountStamp> testList = new List<AccountStamp>();
		testList.add(as1);
		testList.add(as2);
		testList.add(as3);
		testList.add(as4);
		testList.sort();
		
		Test.startTest();
		System.assert(testList[0].presenter.equals('test4'));
		System.assert(testList[3].presenter.equals('test2'));
		Test.stopTest();
    }
}