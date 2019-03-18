@isTest
private class TestGame 
{
	@isTest
    private static void testFight()
    {
        Unit human = new Unit('Human', 500, 50, 10);
        Unit elf = new Unit('Elf', 500, 60, 20);
        
        Game game = new Game();
        game.fight(human, elf);
        
    }
    
}