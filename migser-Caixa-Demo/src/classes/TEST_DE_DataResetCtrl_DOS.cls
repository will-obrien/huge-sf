@isTest
public class TEST_DE_DataResetCtrl_DOS {
    static testMethod void DE_CtrlTest_DOS() {
        DE_DataResetCtrl_DOS drc = new DE_DataResetCtrl_DOS();
        drc.dataAccountSize = 1;
        drc.dataAccount = new Account();
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact());
        contacts.add(new Contact());
        drc.resetAccountFields();
        drc.resetContacts();
     }
}