@isTest
public class SignUpController_Test{
    static testMethod void testSignUp(){
        String testEmail = 'test@test.com';
        ApexPages.currentPage().getParameters().put('action', 'meeting');
        ApexPages.currentPage().getParameters().put('id', 'fakeId');       
        SignUpController controller = new SignUpController();
        controller.firstName = 'Test';
        controller.lastName = 'Test';
        controller.email = testEmail;        
        controller.register();
        controller.goToLoginPage();      
    }
}