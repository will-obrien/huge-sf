@isTest
public class GameTest 
{ 
    @isTest
    static void TestFight()
    {
        Unit__c FirstFighter = new Unit__c(Name = 'First Fighter', 
                                           HP__c = 100, 
                                           DmgMin__c = 10, 
                                           DmgMax__c = 20, 
                                           Stamina__c = 7,
                                           Activation_Date__c = null,
                                           Amount_of_losses__c = 0,
                                           Count_of_wins__c = 0,
                                           Is_Active__c = true,
                                           Rating__c = 0);
        
        Unit__c SecondFighter = new Unit__c(Name = 'Second Fighter', 
                                            HP__c = 100, DmgMin__c = 10, 
                                            DmgMax__c = 20, 
                                            Stamina__c = 7,
                                            Activation_Date__c = null,
                                            Amount_of_losses__c = 1,
                                            Count_of_wins__c = 0,
                                            Is_Active__c = true,
                                            Rating__c = 0);
        insert FirstFighter;
        insert SecondFighter;
        Game game = new  Game();
        
        Test.startTest();
        for(Integer i = 0; i < 3; i++)
        {
            game.Fight(FirstFighter, SecondFighter);
        }
        Test.stopTest();
    }
    
	@isTest
    static void TestRandomInteger()
    {
        Unit__c unit = new Unit__c(Name = 'Боец', HP__c = 100, DmgMin__c = 10, DmgMax__c = 20, Stamina__c = 7);
        Game game = new  Game();
        try
        {
            Integer i = game.RandomInteger(unit);
            System.assert(CheckTheResult(unit, i), 'It is a wrong number');
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }
    
    /**
     * This method checks the result
     * @param Unit__c u selected fighter, Integer num randomly generated number
     * @returns true if range of numbers in DmgMin__c and DmgMax__c equals to num from parameter, otherwise false
	*/
    static Boolean CheckTheResult(Unit__c u, Integer num)
    {
        if( num >= u.DmgMin__c && num <= u.DmgMax__c) { return true;}
        else { return false;}
    }
}