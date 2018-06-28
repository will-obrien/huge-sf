/*********************************************************************
Name : Test_DuplicateLeadDeleteScheduler 
Created On : dec 20 , 2011  
Created By : Lalit Bohra
Description : test class for providing test coverage to DuplicateLeadDeleteScheduler Scheduler
**********************************************************************/
@isTest
private class Test_DuplicateLeadDeleteScheduler {

    static testMethod void testDuplicateLeadDeleteScheduler() {
        // TO DO: implement unit test
         createData();     
        String sch = '0 0 0 * * ?';
        DuplicateLeadDeleteScheduler testInstance = new DuplicateLeadDeleteScheduler(); 
        test.startTest();
        system.schedule('Schedule Job', sch, testInstance);
        test.stopTest();
    }
    
    // Creating the test data for leads    
    public static void createData() {
        list<Lead> LeadList = new list<Lead>();
        for(Integer iCount=0;iCount<10;iCount++){
            Lead objLead= new Lead();
            objLead.Company='Test Company1';
            objLead.LastName='Test Lead1';
            objLead.Status='Open';
            objLead.CurrencyIsoCode='USD';
            objLead.IM_USER_ID__c='TestUser Id12345'+iCount;
            ObjLead.Email='Test@testsite.com';    
            ObjLead.To_be_Deleted__c=true;
            LeadList.add(ObjLead);
        }       
        insert LeadList;     
    }
}