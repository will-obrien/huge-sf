@isTest(seeAllData=true)
public class PDEPictureCtrlTest {

        static testMethod void myTestMethod() {
        
        Account acc = new Account(name='Test Account');
        insert acc;
        
        String PicId = PDEPictureCtrl.getPictureId(acc.Id, 'Name', 'Account');
                    
    }
    
    
}