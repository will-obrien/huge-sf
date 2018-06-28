@isTest
public class RatingTriggerTest 
{
    private static testMethod void RatingTriggerTest ()
    {
        //creating data
        Unit__c unit1 = new Unit__c(Name = 'Unit1', HP__c = 100, minDMG__c = 5, maxDMG__c = 10, Number_of_Victories__c = 0);
        Unit__c unit2 = new Unit__c(Name = 'Unit2', HP__c = 100, minDMG__c = 5, maxDMG__c = 10, Number_of_Victories__c = 0);
        Unit__c unit3 = new Unit__c(Name = 'Unit3', HP__c = 100, minDMG__c = 5, maxDMG__c = 10, Number_of_Victories__c = 0);

        List<Unit__c> units = new List<Unit__c>();
        units.add(unit1);
        units.add(unit2);
        units.add(unit3);
        
        insert units;
        // units to update    
        unit1.Number_of_Victories__c = 1;
        unit2.Number_of_Victories__c = 2;
        unit3.Number_of_Victories__c = 3;
        unit1.Number_of_Games__c = 4;
        unit2.Number_of_Games__c = 4;
        unit3.Number_of_Games__c = 3;
        update units;
        
        List<Unit__c> unitsAfterTest = [SELECT Id, Name, Position_in_Top__c, Number_of_Victories__c, Percent_of_Victories__c, Number_of_Games__c
                                        FROM Unit__c
                                        WHERE Id IN (:unit1.Id, :unit2.Id, :unit3.Id)
                                        ORDER BY Id];
        
        System.assertEquals(3, unitsAfterTest.get(0).Position_in_Top__c);
        System.assertEquals(2, unitsAfterTest.get(1).Position_in_Top__c);
        System.assertEquals(1, unitsAfterTest.get(2).Position_in_Top__c);
        System.assertEquals(25, unitsAfterTest.get(0).Percent_of_Victories__c);
        System.assertEquals(50, unitsAfterTest.get(1).Percent_of_Victories__c);
        System.assertEquals(100, unitsAfterTest.get(2).Percent_of_Victories__c);

    }
}