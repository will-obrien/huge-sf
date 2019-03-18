@isTest(SeeAllData=true)
public class SOSCreateCaseTest {
    static testMethod void myTest() {
		SOSSession sess = new SOSSession();
        sess.AppVersion = 'lauren@example.com';
        insert sess;
    }
}