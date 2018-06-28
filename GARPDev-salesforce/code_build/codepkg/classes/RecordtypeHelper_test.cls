@isTest
public class RecordtypeHelper_test {

    static testMethod void unitTest_1(){
        
        test.startTest();
        Recordtype Recordtype = RecordTypeHelper.GetRecordType('Contract', 'FRM Program');
        RecordTypeHelper.GetRecordTypeName(Recordtype.id);
        id id = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
        test.stopTest();
    }
}