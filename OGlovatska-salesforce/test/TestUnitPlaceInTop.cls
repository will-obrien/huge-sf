@isTest
public class TestUnitPlaceInTop 
{
    @isTest
    private static void testTrigger()
    {
        Unit__c first = new Unit__c(Name='Magneto', Health__c = 200, MaxDamage__c = 150, MinDamage__c = 80);
        Unit__c second = new Unit__c(Name='Ghost Rider', Health__c = 200, MaxDamage__c = 140, MinDamage__c = 70);
        Unit__c third = new Unit__c(Name='Human Torch', Health__c = 200, MaxDamage__c = 130, MinDamage__c = 60);
        
        List<Unit__c> unitsList = new List<Unit__c>();
        unitsList.add(first);
        unitsList.add(second);
        unitsList.add(third);
        
        insert unitsList;
        
        first.Winn__c = 25;
        second.Winn__c = 20;
        third.Winn__c = 15;
        
        update unitsList;
  
    }
}