@isTest
public class scheduleUpdateCpeClaims_Test {

        Public static testMethod void MyUnitTest()
        {
        test.starttest();
        scheduleUpdateCpeClaims s1= new scheduleUpdateCpeClaims();
        system.schedule('Test Schedule','0 0 0 * * ?',s1);
        Test.stoptest();
        }

    
}