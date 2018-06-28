@isTest
public class batchContentAnalyticsContact_test {

    Static Contact cont1;
    Static Contact cont2;
    
    Static Content__c c1;
    Static Content__c c2;
    
    
     static void testData()
     {
         
         //select Id, Name, Content_Types_Viewed__c, Content_Viewed__c, Content_Viewed_Count__c, Content_Topics_Viewed__c from Contact where Content_Viewed_Count__c > 0
        c1 = new Content__c(Name='Test1', Content_Other_Viewed__c=null, Content_Other_Viewed_Count__c=null);
        insert c1;

        c2 = new Content__c(Name='Test2', Content_Other_Viewed__c='a1Z40000000HxtxEAC', Content_Other_Viewed_Count__c=0);
        insert c2;
         
        //cont1 = new Contact(FirstName = 'Test', LastName = 'Contact1', do_not_fire__c=true, Content_Viewed__c=String.valueOf(c1.Id)+'a1Z40000000HxtxEAC~a1Z400000031NJfEAM~a1Z400000031M92EAE~a1Z400000031MtoEAE~a1Z40000002vT0WEAU~a1Z400000031QiSEAU',Content_Viewed_Count__c=7);
        cont1 = new Contact(FirstName = 'Test', LastName = 'Contact1', do_not_fire__c=true, Content_Viewed__c=String.valueOf(c1.Id),Content_Viewed_Count__c=1);
        insert cont1;

        //cont2 = new Contact(FirstName = 'Test', LastName = 'Contact2', do_not_fire__c=true, Content_Viewed__c=String.valueOf(c2.Id)+'a1Z400000031SvEEAU~a1Z400000031S27EAE~a1Z400000031SvTEAU~a1Z400000031SvSEAU',Content_Viewed_Count__c=5);
        cont2 = new Contact(FirstName = 'Test', LastName = 'Contact2', do_not_fire__c=true, Content_Viewed__c=String.valueOf(c2.Id),Content_Viewed_Count__c=1);
        insert cont2;
     }
     
     static testMethod void UnitTest_1()
    {
        testData();
        test.startTest();
        batchContentAnalyticsContact b = new batchContentAnalyticsContact('');
        database.executeBatch(b);
        test.stopTest();
    }

}