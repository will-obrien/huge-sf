@isTest
public class scheduleUpdateExamAttempts_Test {

    Public static testMethod void MyUnitTest()
    {
    test.starttest();
    scheduleUpdateExamAttempts s1= new scheduleUpdateExamAttempts();
    system.schedule('Test Schedule','0 0 0 * * ?',s1);
    Test.stoptest();
    }

    
}