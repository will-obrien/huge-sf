/**
 * Game class represents the game between two units and choose winner. 
 * 
 * @author  Adel Hammoudi
 * @version 1.0, June 2016
 */
public with sharing class Game
{
	private List<String> gameDescriptionList;
    private Unit winner;
    
    public Game() 
	{
		gameDescriptionList = new List<String>();
	}

    /**
     * Return List<String> with description of game.
     */
    public List<String> getGameDescriptionList()
    {
        return gameDescriptionList;
    }

    /**
	* Return Unit is a winner of the game.
	*/
    public Unit getWinner()
    {
    	return winner;
    }

    /**
     * Make for one kick from one side.
     * Check is unit.hp more than 0, if no - game will be stopped.
     * Add description to List<String> gameDescriptionList
     * Assigned winner unit to winner
     * 
     * @param Unit unit1, Unit unit2 units which will play game.
     * @see #Unit
     */
	public void fight(Unit unit1, Unit unit2)
	{
		Integer kick;
		kick = unit1.getKick(unit2);
		if (kick == 0)
		{
			gameDescriptionList.add(unit1.getName() + '\'s kick was blocked!');
		}
		else
		{
			unit2.setHp(unit2.getHp() - kick);
			gameDescriptionList.add(unit1.getName() + ' kicked on ' + kick + ' hp');
		}    		
		gameDescriptionList.add('Balance Hp: ' + unit1.getName() + ': ' + unit1.getHp() + '; ' 
								+ unit2.getName() + ': ' + unit2.getHp());
		if(!unit2.isLive())
	    {
	    	gameDescriptionList.add(unit1.getName() + ' win!');
	    	gameDescriptionList.add('Game over!');
            winner = unit1;
	    }	
	    else
	    {
	    	kick = unit2.getKick(unit1);
			if (kick == 0)
			{
				gameDescriptionList.add(unit2.getName() + '\'s kick was blocked!');
			}
			else
			{
				unit1.setHp(unit1.getHp() - kick);
				gameDescriptionList.add(unit2.getName() + ' kicked on ' + kick + ' hp');	
			}    		
			gameDescriptionList.add('Balance Hp: ' + unit1.getName() + ': ' + unit1.getHp() + '; '
									 + unit2.getName() + ': ' + unit2.getHp());
			if(!unit1.isLive())
		    {
		    	gameDescriptionList.add(unit2.getName() + ' win!');
		    	gameDescriptionList.add('Game over!');
	            winner = unit2;
		    }
	    }
        unit1.setKickType(null);
    	unit1.setBlockType(null);
    	unit2.setKickType(null);
    	unit2.setBlockType(null);
	}
}