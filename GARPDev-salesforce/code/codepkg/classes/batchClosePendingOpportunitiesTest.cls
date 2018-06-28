@isTest
public class batchClosePendingOpportunitiesTest {
   
   private static final String OLD_OPP = 'Old Opp';

   public static testmethod void test() {

     Opportunity oldOpp = new Opportunity(Name = OLD_OPP, StageName = 'New Lead', CloseDate = Date.today().addDays(1), LEGACY_Purchase_Date__c = DateTime.now().addmonths(-7));
      insert oldOpp;
       
        Test.startTest();
        batchClosePendingOpportunities c = new batchClosePendingOpportunities();
        Database.executeBatch(c);
        Test.stopTest();

    }}