@IsTest
public class WaveDashBoardControllerTest {

    @IsTest
    public static void testGetDomainURL(){ 
    
        String communityUrl = WaveDashBoardController.getDomainURL(null);
        System.assert(communityUrl==System.URL.getSalesforceBaseUrl().getHost());
        
        communityUrl = WaveDashBoardController.getDomainURL('test');
        System.assert(communityUrl==System.URL.getSalesforceBaseUrl().getHost()+'test');
         
    }
    
    
}