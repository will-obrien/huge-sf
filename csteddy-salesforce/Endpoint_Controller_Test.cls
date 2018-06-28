@istest
public class Endpoint_Controller_Test {
static testMethod void Endpoint_Controller_test() {
 
// Set the page reference and pass through some parameters
PageReference thePage = Page.debugEndpoint;
thePage.getParameters().put('param1','1');
thePage.getParameters().put('param2','2');
Test.setCurrentPage(thePage);
 
// Run the init function to have it handle the web to lead submission
Endpoint_Controller ep = new Endpoint_Controller();
ep.init();
}
}
