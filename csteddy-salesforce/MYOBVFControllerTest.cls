@istest (seeAllData=true)
public class MYOBVFControllerTest {
    public static testMethod void testMyController() {
        PageReference pageRef = Page.OAuth2; //replace with your VF page name
        Test.setCurrentPage(pageRef);
 
        // Instantiate a new controller with all parameters in the page      
        MYOBVFController controller = new MYOBVFController();
        String message = controller.getMessage();
        controller.service = 'MYOB';
        controller.doAuthorization();
      
        // Add parameters to page URL  
        ApexPages.currentPage().getParameters().put('code', 'blabla');
        ApexPages.currentPage().getParameters().put('state', 'nonce');
        controller.finalAuth();
        
        List<SelectOption> services = controller.getServiceNames();

        
    }
    }
