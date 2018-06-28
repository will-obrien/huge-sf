@isTest(SeeAllData=true)
public class ContactDirectoryTest {
    static testMethod void ProjectReportOutControllerTest1() {
            ContactDirectoryController c1=new ContactDirectoryController();
            c1.initAction();
            c1.authenticate();
            c1.getFromJSON('{"email": "test@gmail.com"}', 'email');
        
        	c1.EmpSearchName='Test';
        	c1.SearchEmp();
        
        	c1.ContractSearchName='Test';
        	c1.SearchContract();
    }
}