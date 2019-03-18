@isTest
private class LeadProcessorTest {

    @testSetup
    static void setup(){
        List<Lead> leads = new List<Lead>();
        
        //insert 200 leads
        for (Integer i = 1; i <= 200; i++){
            leads.add(new Lead(FirstName='Prakash'+1, LastName='Rai'+1, company='iSell', LeadSource = 'Dreamforce'));
        }
        insert leads;
      }
        
    static testmethod void test(){
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();
        
        //after the testing stops, assert records were updated properly
        System.assertEquals(200,[SELECT count() FROM lead WHERE LeadSource ='Dreamforce'],'Expected 200 records');
        //System.assertEquals('Dreamforce',(String) [SELECT LeadSource FROM Lead LIMIT 1].get(LeadSource),'Expected LeadSource is Dreamforce');
    }
}