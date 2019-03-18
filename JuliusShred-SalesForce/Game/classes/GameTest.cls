/**
    * in GameTest unit test we are going to test the game logic
    */
@isTest
public class GameTest 
{
    //creating data
    private static testMethod  void setData() 
    {
        Unit__c firstUnit = new Unit__c(Name = 'first', 
                                        HP__c = 200, 
                                        minDMG__c = 10, 
                                        maxDMG__c = 29, 
                                        Stamina__c = 50);
        Unit__c secondUnit = new Unit__c(Name = 'second', 
                                         HP__c = 200, 
                                         minDMG__c = 30, 
                                         maxDMG__c = 49, 
                                         Stamina__c = 50);
        List<Unit__c> testUnitsList = new List<Unit__c>();
        testUnitsList.add(firstUnit);
        testUnitsList.add(secondUnit);
        insert testUnitsList;
    }
    //testing the values that getBlockKickType() method have to return
    static testMethod void getBlockKickTypeTest()
    {
        GameTest.setData();
        Game g = new Game();
        
        String  HeadType =  g.getBlockKickType(0);
        String  ChestType =  g.getBlockKickType(1);
        String  BellyType =  g.getBlockKickType(2);
        String  GroinType =  g.getBlockKickType(3);
        
        System.assertEquals('Head', HeadType, 'Wrong result');
        System.assertEquals('Chest', ChestType, 'Wrong result');
        System.assertEquals('Belly', BellyType, 'Wrong result');
        System.assertEquals('Groin', GroinType, 'Wrong result');
    }
    //spentStaminaPoints values testing for spentStaminaPoints() method
    static testMethod void spentStaminaPointsTest()
    {
        GameTest.setData();
        Game g = new Game();
        
        List <Decimal> spentStaminaPointsValuesList = new List <Decimal>();
        
        for(Integer i = 0; i < 20; i++)
        {
            spentStaminaPointsValuesList.add(g.spentStaminaPoints(i*10));
        }
        
        System.assertEquals(spentStaminaPointsValuesList.size(), 20);
        Integer counter = 0;
        for(Decimal i: spentStaminaPointsValuesList)
        {
            System.assertEquals(i, counter, 'invalid value');
            counter++;
            System.assertNotEquals(NULL, i, 'error NULL value');
            System.debug(i);
        }
    }
    //damage values testing for generateDamage() method
    static testMethod void generateDamageTest()
    {
        GameTest.setData();
        Unit__c firstUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c FROM Unit__c][0];
        Unit__c secondUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c FROM Unit__c][1];
        Game g = new Game();
        
        List <Integer> firstUnitDamageValuesList = new List <Integer>();
        List <Integer> secondUnitDamageValuesList = new List <Integer>();
        
        for(Integer i = 0; i < 20; i++)
        {
            firstUnitDamageValuesList.add(g.generateDamage(firstUnit));
            secondUnitDamageValuesList.add(g.generateDamage(secondUnit));
        }

        System.assertEquals(firstUnitDamageValuesList.size(), 20);
        System.assertEquals(secondUnitDamageValuesList.size(), 20);
        
        for(Integer i: firstUnitDamageValuesList)
        {
            System.assert(i >= 10 && i <= 29);
            System.assertNotEquals(0, i);
            System.assertNotEquals(NULL, i);
            System.debug(i);
        }
        for(Integer i: secondUnitDamageValuesList)
        {
            System.assert(i >= 30 && i <= 49);
            System.assertNotEquals(0, i);
            System.assertNotEquals(NULL, i);
            System.debug(i);
        }
    }
    //damage values testing for hit() method
    static testMethod void hitTest()
    {
        GameTest.setData();
        Unit__c firstUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c FROM Unit__c][0];
        Unit__c secondUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c FROM Unit__c][1];
        Game g = new Game();
        
        List <Integer> firstUnitHitValuesList = new List <Integer>();
        List <Integer> secondUnitHitValuesList = new List <Integer>();
        
        for(Integer i = 0; i < 40; i++)
        {
            firstUnitHitValuesList.add(g.hit(firstUnit, secondUnit));
            secondUnitHitValuesList.add(g.hit(secondUnit, firstUnit));
        }

        System.assertEquals(firstUnitHitValuesList.size(), 40);
        System.assertEquals(secondUnitHitValuesList.size(), 40);
        
        for(Integer i: firstUnitHitValuesList)
        {
            System.assert((i >= 10 && i <= 29) || i == 0);
            System.assertNotEquals(NULL, i);
            System.debug(i);
        }
        for(Integer i: secondUnitHitValuesList)
        {
            System.assert((i >= 30 && i <= 49) || i == 0);
            System.assertNotEquals(NULL, i);
            System.debug(i);
        }
    }
    //testing winner results for fight() method
    static testMethod void fightTest()
    {
        GameTest.setData();
        Unit__c firstUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c FROM Unit__c][0];
        Unit__c secondUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c FROM Unit__c][1];
        Game g = new Game();
        List <Unit__c> winnerList = new List <Unit__c>();
        
        for(Integer i = 0; i < 10; i++)
        {
            winnerList.add(g.fight(firstUnit, secondUnit));
        }
        
        System.assertEquals(winnerList.size(), 10);
        
        for(Unit__c unit: winnerList)
        {
            System.assert(unit == firstUnit || unit == secondUnit);
            System.debug(unit);
        }
    }
    //testing winner results for fight() method sending NULL as one of the parameters
    static testMethod void fightWithNULLUnitTest()
    {
        GameTest.setData();
        Unit__c firstUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c FROM Unit__c][0];
        Game g = new Game();  
        Unit__c winner = new Unit__c();
        String message;
        
        try
        {
            winner = g.fight(firstUnit, NULL);
        } 
        catch(GameException e)
        {
            message = e.getMessage();
        }
        
        System.assert(message == 'Unit cannot be null.');
    }
}