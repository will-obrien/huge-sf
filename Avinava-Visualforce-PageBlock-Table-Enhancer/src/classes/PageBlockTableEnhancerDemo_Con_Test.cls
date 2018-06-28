/*Quick test class for PageBlockTableEnhancerDemo_Con*/
@isTest
private class PageBlockTableEnhancerDemo_Con_Test{
    static testMethod void testPageBlockTableEnhancerDemo_Con(){
        PageBlockTableEnhancerDemo_Con con = new PageBlockTableEnhancerDemo_Con();
        System.assertNotEquals(null,con.getAccounts());
    }
}