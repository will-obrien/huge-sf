public class test_Opportunityturnover{

  public static testMethod void test_Opportunityturnover() {
    
      Account acc=new Account(Name='Test Acount',Type = 'Customer',Account_Number__c='2345678',McQuay_Gear__c = 'NO',Industry = 'HealthCare');
      insert acc;
      Contact c=new Contact(FirstName='Sobia', LastName='Khan', Account=acc, Phone='3125551234');
      insert c;
      recordtype prjRecType=[select id from recordtype where sobjecttype='Project__c' and name='Hourly Recurring'];
      Project__c prj=new Project__c(recordtypeid=prjRecType.Id,Description__c='test', Account__c=acc.Id,Allocated_Resource__c=c.Id);
      insert prj;
      
      Opportunity opp=new Opportunity();
      
      opp.Name = 'TEST OPP';
      opp.AccountId = acc.Id;
      opp.Opp_City__c = 'ALPHARETTA';
      //opp.Opp_State__c = 'GA';
      opp.StageName = 'D-Proposal/Bid-Not Daikin Specified';
      opp.Probability = 1.00;
      opp.Amount = 10.00;
      opp.ForecastCategoryName = 'Pipeline';
      opp.CloseDate = Date.today();
      opp.Description = 'TEST OPP CREATED';
      opp.Type = 'Existing Business';
      opp.Region_Territory__c = 'Southeast';
      opp.Vertical_Market__c = 'Healthcare';
      insert opp;
      
    }
  
}