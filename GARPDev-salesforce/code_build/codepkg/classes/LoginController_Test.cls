@isTest
public class LoginController_Test{
    static testMethod void testLogin(){
        ApexPages.currentPage().getParameters().put('action', 'jobtarget');
        LoginController controller1 = new LoginController();        
        controller1.login();
        ApexPages.currentPage().getParameters().put('action', 'meeting');
        ApexPages.currentPage().getParameters().put('id', 'testid');
        LoginController controller2 = new LoginController();        
        controller2.login();
        controller2.resetPassword();
        controller2.register();
    }
}