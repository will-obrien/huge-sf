@isTest (SeeAllData = true)
private class SGEmailservice_Test {
    static testMethod void SGEmailservice_Test() {

        SGLeadCreateREST.sendemail = true;
        
        Account accttest = PGITestUtilities.getAccountDetails();
		insert accttest;
        
        Opportunity opptytest = PGITestUtilities.getOpportunityDetails();
        opptytest.AccountId = accttest.id;
        insert opptytest;
        
        Contact cntcttest = PGITestUtilities.getContactDetails(accttest.id);
        insert cntcttest;

        conman_contract__c cntrcttest 	= new conman_contract__c();
        cntrcttest.Account_Name__c		=	accttest.id;
        cntrcttest.Opportunity__c 		= 	opptytest.id;
        cntrcttest.z_Source__c			=	'Salesgateway'; 

        Test.startTest();
        insert cntrcttest;
        cntrcttest.Contract_Status__c =	'Sent To Customer';
        Update cntrcttest;
        cntrcttest.Contract_Status__c =	'Customer Accepted';
        Update cntrcttest; 
		cntrcttest.Contract_Status__c =	'Customer Rejected';
        Update cntrcttest; 

        /*conman_contract__c loopcntrct = [select Account_Name__c,Opportunity__c,Contract_Status__c]
            new conman_contract__c();
        loopcntrct = cntrcttest;
        
        Test.startTest();
        for (conman_contract__c sendemail : loopcntrct){
        	SGEmailservice.sendsEmail(cntrcttest);
        }*/
        Test.stopTest();
        SGLeadCreateREST.sendemail = false;
    }
}