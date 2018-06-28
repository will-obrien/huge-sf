@isTest
Public class schedulecancelExamAttempt_test
{
Public static testMethod void MyUnitTest()
{
test.starttest();

schedulecancelExamAttempt s1= new schedulecancelExamAttempt();
system.schedule('Test Schedule','0 0 0 * * ?',s1);
Test.stoptest();
}

}