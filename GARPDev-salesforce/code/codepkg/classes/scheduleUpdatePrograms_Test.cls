@isTest
public class scheduleUpdatePrograms_Test {

    Public static testMethod void MyUnitTest()
    {
    test.starttest();
    scheduleUpdatePrograms s1= new scheduleUpdatePrograms();
    system.schedule('Test Schedule','0 0 0 * * ?',s1);
    Test.stoptest();
    }

    
}