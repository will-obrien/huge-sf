@isTest (SeeAllData = true)
private class SGLockContactFields_Test {

    static testMethod void SGLockContactFields_Test() {

        Test.startTest();
        
        Account accttest = PGITestUtilities.getAccountDetails();
		accttest.z_source__c	= 'Salesgateway';
        insert accttest;
        
        Contact cntcttest = PGITestUtilities.getContactDetails(accttest.id);
        cntcttest.accountid	=  accttest.Id;
        cntcttest.z_source__c	=  'Salesgateway';
        insert cntcttest;

        conman_contract__c cntrcttest1 = new conman_contract__c(Account_Name__c		=	accttest.id
                                                              ,Contract_Status__c	=	'Sent To Customer');
        insert cntrcttest1;

        cntcttest.FirstName	= 'skiptest';
        update cntcttest;

        cntcttest.phone	= '123456';
        update cntcttest;

        cntcttest.MailingCity	= 'kadapa';
        update cntcttest;

        cntcttest.MailingState	= 'AP';
        update cntcttest;

        cntcttest.MailingStreet	= 'AP';
        update cntcttest;

        cntcttest.MailingCountry	= 'India';
        update cntcttest;

        cntcttest.MailingPostalCode	= '123';
        update cntcttest;

        cntcttest.Email	= 'test@123.com';
        update cntcttest;
 
        Test.stopTest();
    }

}