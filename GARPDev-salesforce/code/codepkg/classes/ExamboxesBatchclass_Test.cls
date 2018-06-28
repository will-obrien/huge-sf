@isTest
public class ExamboxesBatchclass_Test {

    Static Shipping_Boxes__c sb;
    Static Shipping_Boxes__c sb1;
    Static Shipping_Boxes__c sb2;
    
    Static void testData()
    {
        sb = new Shipping_Boxes__c(Proctor_Boxes__c = True,Weight__c='4',Ship_to_last_name__c='Zhao',Shiptofirst_name__c='Jing',SiteName__c = 'Australia, Melbourne',ShipToAddress1__c = 'La Trobe University',ShipToAddress2__c ='La Trobe Business School',Pre_Test_Box_UPS_Stage__c='New Order',Pre_Test_Box_Country_Code_for_UPS__c = 'AU');
        insert sb;
        sb1 = new Shipping_Boxes__c(Proctor_Boxes__c = True,Weight__c='4',Ship_to_last_name__c='Zhao',Shiptofirst_name__c='Jing',SiteName__c = 'Australia, Melbourne',ShipToAddress1__c = 'La Trobe University',ShipToAddress2__c ='La Trobe Business School',Pre_Test_Box_UPS_Stage__c='New Order',Pre_Test_Box_Country_Code_for_UPS__c = 'US');
        insert sb1;
        sb2 = new Shipping_Boxes__c(Proctor_Boxes__c = True,Weight__c='4',Ship_to_last_name__c='Zhao',Shiptofirst_name__c='Jing',SiteName__c = 'Australia, Melbourne',ShipToAddress1__c = 'La Trobe University',ShipToAddress2__c ='La Trobe Business School',Pre_Test_Box_UPS_Stage__c='New Order');
        insert sb2;
    }
    
    
    static testMethod void unit_test()
    {
        testData();
        test.startTest();
        ExamboxesBatchclass b = new ExamboxesBatchclass();
        database.executeBatch(b);
        test.stopTest();
        
        
    }
}