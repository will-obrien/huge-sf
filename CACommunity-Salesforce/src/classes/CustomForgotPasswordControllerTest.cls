@IsTest public with sharing class CustomForgotPasswordControllerTest {
     @IsTest(SeeAllData=true) public static void testCustomForgotPasswordController() {
      // Instantiate a new controller with all parameters in the page
      CustomForgotPasswordController controller = new CustomForgotPasswordController();
      controller.username = 'test@salesforce.com';       
    
      System.assertEquals(controller.forgotPassword(),null);
      controller.username = '';       
        controller.forgotPassword();   
    }
}