//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Test Class for PlannedGivingTriggerHandler 
//  8 March 2014    Virendra (Appirio)     Original
//  Updated to call Trigger Handler methods to update the test coverage
//  So that we can deploy Inactive PlannedGivingTrigger I-114467
//**********************************************************************/
@isTest
private class PlannedGivingTriggerHandlerTest {
    
    @IsTest
    static void testCopyOpportunityOnPlannedGiving() {
        TestDataUtility testData = new TestDataUtility();
        testData.createOpportunityFieldSetting();
        Forecasting__c fcMapping = new Forecasting__c();
        fcMapping.Name = 'Mapping1';
        fcMapping.Beginning_Yr_Forecast_Final_Date__c = System.today();
        fcMapping.Year__c = '2014';
        insert fcMapping;
        
        for(Planned_Giving_Opportunity_Mapping__c gOp:[Select id,Opportunity_Field_Name__c ,
                                                       Planned_Giving_Field_Name__c from Planned_Giving_Opportunity_Mapping__c]){
          system.debug('::gOp:::'+gOp);                                                 
        }
        rC_Giving__Planned_Giving__c plannedGiving = testData.createNewPlannedGiving();
        List<rC_Giving__Planned_Giving__c> pgList = new List<rC_Giving__Planned_Giving__c>();
        pgList.add(plannedGiving);
        
        Map<Id, rC_Giving__Planned_Giving__c> pgMap = new Map<Id, rC_Giving__Planned_Giving__c>([Select Id, Beginning_Yr_Forecast__c, 
                    rC_Giving__Stage__c, Name, rC_Giving__Expected_Final_Distribution_Date__c From rC_Giving__Planned_Giving__c Where Id =:plannedGiving.Id ]);
        
        PlannedGivingTriggerHandler.onAfterInsert(pgList);
        plannedGiving.Revocable__c = 'Irrevoocable';
        update plannedGiving;
        pgList.clear();
        pgList.add(plannedGiving);
        PlannedGivingTriggerHandler.onAfterUpdate(pgList, pgMap);
    }

}