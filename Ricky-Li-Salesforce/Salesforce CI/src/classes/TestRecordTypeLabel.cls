@isTest
private class TestRecordTypeLabel
{
    /*
     *  This method will test the record load
     */
    static testmethod void RecordTypeTestPositive1()
    {
     Test.startTest(); 
        Label_By_RecordType__c lbr=new Label_By_RecordType__c();
        lbr.Name='AccountUnique';
        lbr.New_Label__c='Phone';
        lbr.Old_Label__c='Mobile';
        lbr.Record_Type_Id__c='012a000000187d6';
        lbr.Object_API_Name__c='Account';
        insert lbr;
        Account acc=new Account(name='test_account__1', BillingState='ON', BillingCountry='Canada', RecordTypeId='012a000000187d6');
        insert acc;
        string acc15digit=acc.id;
        System.debug(acc15digit);
        acc15digit=acc15digit.substring(0,15);
        list<string> strlist=LabelChange_RecordType.ChangeLabel('https://'+URL.getSalesforceBaseUrl().getHost()+'/'+acc15digit);
        System.Debug('List String'+ strlist);
        boolean stringFound=false;
        for(integer i=0;i<strlist.size();i++)
        {
        if(strlist[i]=='Mobile:Phone')
        stringFound=true;
        }
      Test.stopTest();  
        
        system.assertEquals(stringFound,true);
    }
    
    /*
     * This method will test the Record Creation
     */
    static testmethod void RecordTypeTestPositive2()
    {
        Label_By_RecordType__c lbr=new Label_By_RecordType__c();
        lbr.Name='AccountUnique';
        lbr.New_Label__c='Phone';
        lbr.Old_Label__c='Mobile';
        lbr.Record_Type_Id__c='012a000000187d6';
        lbr.Object_API_Name__c='Account';
        insert lbr;
        Account acc=new Account(name='test_account__1', BillingState='ON', BillingCountry = 'Canada', RecordTypeId='012a000000187d6');
        insert acc;
        string acc3digit=acc.id;
        acc3digit=acc3digit.substring(0,3);
        System.Debug('First 3 letters of the Id'+acc3digit);
        list<string> strlist=LabelChange_RecordType.ChangeLabel('https://'+URL.getSalesforceBaseUrl().getHost()+'/'+acc3digit+'/e?retURL=%2F001%2Fo&RecordType=012a000000187d6&ent=Account');
        boolean stringFound=false;
        for(integer i=0;i<strlist.size();i++){
            if(strlist[i]=='Mobile:Phone')
            stringFound=true;
        }
        system.assertEquals(stringFound,true);
    }
    
    /*
     * This method tests the false positive scenario
     */
     
    static testmethod void RecordTypeTestNegative()
    {
      Test.startTest();
        Label_By_RecordType__c lbr=new Label_By_RecordType__c();
        lbr.Name='AccountUnique';
        lbr.New_Label__c='Phone';
        lbr.Old_Label__c='Mobile';
        lbr.Record_Type_Id__c='012U0000000TiE7';
        lbr.Object_API_Name__c='Account';
        insert lbr;
        Account acc=new Account(name='test_account__1', BillingState='ON', BillingCountry='Canada');
        insert acc;
        string acc3digit=acc.id;
        acc3digit=acc3digit.substring(0,3);
        list<string> strlist=LabelChange_RecordType.ChangeLabel('https://'+URL.getSalesforceBaseUrl().getHost()+'/apex/SomeDummyPage');
        boolean stringFound=false;
        if(strlist != null){
            for(integer i=0;i<strlist.size();i++){
                if(strlist[i]=='Mobile:Phone')
                stringFound=true;
            }
        }
      Test.stopTest();
      
        system.assertEquals(stringFound,false);
    }
}