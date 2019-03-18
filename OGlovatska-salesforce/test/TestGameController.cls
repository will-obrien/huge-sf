@isTest
public class TestGameController 
{     
    @isTest
	private static void testGameController()
    {
        PageReference reference = Page.Game;
        Test.setCurrentPage(reference);
        
        GameController gameContr = new GameController();
        gameContr.firstUnit = new Unit('Hulk', 200, 100, 70);
        gameContr.secondUnit = new Unit('Deadpool', 100, 50, 20);
        
        Test.startTest();
        gameContr.startGame();
        Test.stopTest();
        
        String winner = gameContr.winner.name;
        
        System.assertEquals(winner, 'Hulk');
    }
}