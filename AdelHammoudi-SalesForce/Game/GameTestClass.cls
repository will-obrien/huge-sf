/**
* Test Class for Game
*
* @Author Adel Hammoudi
* @Date   06/27/2016
*/
@isTest
private class GameTestClass 
{
	/**
     * Create Unit object.
     * 
     * @return unit object Unit
     */
    static Unit createUnit()
    {
        Unit unit = new Unit(new Unit__c(Name = 'Fighter', Hp__c = 100, Min_Damage__c = 50, Max_Damage__c = 70));
        return unit;
    }

  	/**
    * Test Method.
    * Create Game object and start fight method with criterias.
    *
    * Units are given.
    * Testing after create.
    *
    * unit1 should be a winner in first variant.
    * unit2 should be a winner in second variant.
    * gameDescriptionList size must be more than 0 after finishing game.
    */
	@isTest(SeeAllData=false)
	static void fight()
	{
		Unit unit1 = createUnit();
		Unit unit2 = createUnit();
		
		Game game = new Game();

		while(game.getWinner() == null)
		{
			unit1.setKickType(KickBlockTypes.HEAD);
			unit1.setBlockType(KickBlockTypes.HEAD);
			unit2.setKickType(KickBlockTypes.HEAD);
			unit2.setBlockType(KickBlockTypes.LEGS);
			game.fight(unit1, unit2);
		}
		System.assertEquals(unit1, game.getWinner(), 'fight error, unit1 must win');

		unit1 = createUnit();
		unit2 = createUnit();
		game = new Game();

		while(game.getWinner() == null)
		{
			unit1.setKickType(KickBlockTypes.HEAD);
		    unit1.setBlockType(KickBlockTypes.LEGS);
		    unit2.setKickType(KickBlockTypes.HEAD);
		    unit2.setBlockType(KickBlockTypes.HEAD);
			game.fight(unit1, unit2);
		}
		System.assertEquals(unit2, game.getWinner(), 'fight error, unit2 must win');

		Integer getGameDescriptionListSize = game.getGameDescriptionList().size();
		boolean isTrue;
		if(game.getGameDescriptionList().size() > 0)
		{
			isTrue = true;
		}
		System.assertEquals(true, isTrue, 'gameDescriptionList error');
	}
}