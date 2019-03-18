@isTest
public Class TestGutils{
    static testmethod void TestIsSandbox(){
        Test.startTest();
            if(Gutils.IsSandbox()){
                system.debug('test box');
            }else{
                system.debug('production');
            }
        Test.stopTest();
    }
    
    static testmethod void TestGetRecordTypeId(){
        Test.startTest();
            system.debug('recordTypeId: '+ Gutils.getRecordTypeId('account','traveller'));
        Test.stopTest();
    }
}