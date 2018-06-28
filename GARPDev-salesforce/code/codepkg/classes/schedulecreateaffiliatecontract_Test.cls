@isTest
Public class schedulecreateaffiliatecontract_Test
{
Public static testMethod void MyUnitTest()
{
test.starttest();

schedulecreateaffiliatecontract s1= new schedulecreateaffiliatecontract();
system.schedule('Test Schedule','0 0 0 * * ?',s1);
Test.stoptest();
}

}