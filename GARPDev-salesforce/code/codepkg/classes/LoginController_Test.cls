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
        
        Account acc = new Account(name='Test Account');
        insert acc;
        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Contact','Member');
        Contact ct = new Contact(firstName='Fname',LastName='LName',KPI_FRM_Certified__c=true,accountId = acc.Id,Email='Test@Test.com',recordTypeId=recordTypeID);
        insert ct;
                
        ApexPages.currentPage().getParameters().put('action', null);
        ApexPages.currentPage().getParameters().put('id',  null);

        //controller2.createMember(lc);
        LoginController controller3 = new LoginController();  
        controller3.username = 'Test@Test.com';
        controller3.register();

    }
}