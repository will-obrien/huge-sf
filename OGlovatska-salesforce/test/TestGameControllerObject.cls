@isTest
public class TestGameControllerObject 
{
	@isTest
    private static void testGameObjectCreateUnit()
    {
        /*
		 * Create instance of GameControllerObject class
		 */
        GameControllerObject gameContr1 = new GameControllerObject();

        /*
		 * Create a new personages and assigne values to GameControllerObject class variables first and second
		 */        
        gameContr1.first = new Unit__c(Name='Hulk', Health__c = 200, MaxDamage__c = 100, MinDamage__c = 70);
        gameContr1.second = new Unit__c(Name='Deadpool', Health__c = 100, MaxDamage__c = 50, MinDamage__c = 20);

        /*
		 * Calling method startGame() of GameControllerObject class
		 */
        gameContr1.startGame();
        
        String winner1 = gameContr1.winner.name;

        /*
		 * Calling method savePlayers() of GameControllerObject class
		 */        
        gameContr1.savePlayers();
        
        /*
		 * Check if this fight won personage that we expected
		 */          
        System.assertEquals(winner1, 'Hulk');
    }
    
    @isTest
    private static void testGameObjectSelectUnit()
    {      
        /*
		 * Create instance of GameControllerObject class
		 */
        GameControllerObject gameContr2 = new GameControllerObject();
        
        /*
		 * Calling method selectUnitsFromDataBase() of GameControllerObject class
		 */
        gameContr2.selectUnitsFromDataBase();
        
        /*
		 * Create list of GameControllerObject.UnitWrap objects and assigne to it value of 
		 * GameControllerObject class variable unitWrapList using getUnitWrapList()
		 */
        List<GameControllerObject.UnitWrap> wrapUnit = gameContr2.getUnitWrapList();

        /*
		 * Create two variable firstWrap and secondWrap which are instances of
		 * UnitWrap - inner class of GameControllerObject
		 */
        GameControllerObject.UnitWrap firstWrap;
        GameControllerObject.UnitWrap secondWrap;
        
        /*
		 * Check if wrapUnit list not empty and if it's not - firstWrap and secondWrap
		 * first and second elements of this list and set for this parameters value of field isSelected = true
		 */        
        if(!(wrapUnit.isEmpty()))
        {
            firstWrap = wrapUnit.get(0);
            firstWrap.isSelected = true;
            secondWrap = wrapUnit.get(1);
            secondWrap.isSelected = true;
        }  

        /*
		 * If firstWrap and secondWrap not null = assigne to variables first and second of GameControllerObject class
		 * values
		 */          
        if(firstWrap !=null && secondWrap != null)
        {
            gameContr2.first = firstWrap.player;
        	gameContr2.second = firstWrap.player;
        }
        
        /*
		 * Calling method startGame() of GameControllerObject class
		 */        
        gameContr2.startGame();
    }
}