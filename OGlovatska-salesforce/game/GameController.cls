public class GameController 
{
      
    public Unit firstUnit{get;set;}
    public Unit secondUnit{get;set;}
    public Game game{get;set;}
      
    public Unit winner{get;set;}
    
    /**
     * Constructor for the GameController class
     * It  assign a value to a variables "firstUnit" and "secondUnit"
     */
    public GameController()
    {
        firstUnit = new Unit();
        secondUnit = new Unit();
        winner = new Unit();
	}
    
    /**
     * Method to launch the fight and determine the winner
     */
    public void startGame()
    {
        
    game = new Game();
    winner = game.fight(firstUnit, secondUnit);
                               
    }
}