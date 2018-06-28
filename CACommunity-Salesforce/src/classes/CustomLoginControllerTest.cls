@IsTest global with sharing class CustomLoginControllerTest {
    @IsTest(SeeAllData=true) 
    global static void testCustomLoginController () {
       CustomLoginController controller = new CustomLoginController ();
       controller.login();
       controller.forwardToCustomAuthPage();
              
    }    
}