public class Game 
{
    
    public Unit winner{get;set;}
    
    /**
     * Method used to start fight between two Units and 
     * get the winner. It tooks as parameter two Units.
     */      
    public Unit fight(Unit firstUnit, Unit secondUnit)
    {  
        HitBlockType firstAttack;
        HitBlockType secondAttack;
        HitBlockType firstDeffence;
        HitBlockType secondDeffence;
        
    	while(true)
    	{
    		
            /** 
             * Check if both Units' health higher then 0. 
             * If it does second Unit strikes first Unit
             */
    		if (firstUnit.health > 0 && secondUnit.health > 0)
    		 {
                 firstDeffence = firstUnit.deffence();
                 secondAttack = secondUnit.attack();
                 if(!(firstDeffence.equals(secondAttack)))
                     
               /** 
             	* Check if first Unit blocked kicks of second. 
             	* If he does - he doesn't losse health. 
	        * If he doesn't - health of first Unit getting lower on value 
		* of average damage of second Unit
             	*/
                 {
                    firstUnit.setHealth(firstUnit.health - secondUnit.averageDamage());
                    System.debug(secondUnit.name + ' attacked bodypart: ' + secondAttack + ' of ' + 
                                 firstUnit.name + '. ' + firstUnit.name + ' tried to block this hit but blocked bodypart: ' + 
                                 firstDeffence + '. ' + firstUnit.name + '\'s health is ' + firstUnit.health);
                 } else if(firstDeffence.equals(secondAttack))
                 {
                     System.debug(secondUnit.name + ' attacked bodypart ' + secondAttack + ' of ' + 
                                 firstUnit.name + '. ' + firstUnit.name + ' blocked this hit: ' + firstDeffence + '. ' + 
                                 firstUnit.name + '\'s health is ' + firstUnit.health);
                 }
                    
             } 
             else break;

            /** 
             * Check if both Units' health higher then 0. 
             * If it does first Unit kicks second Unit
             */
            if (secondUnit.health > 0 && firstUnit.health > 0)
             {
                 secondDeffence = secondUnit.deffence();
                 firstAttack = firstUnit.attack();
                  
               /** 
             	* Check if second Unit blocked kicks of first. 
             	* If he does - he doesn't losse his health. 
		* If he doesn't - health of second Unit getting lower on value 
		* of average damage of first Unit
             	*/
                 if(!(secondDeffence.equals(firstAttack)))
                 {
                     secondUnit.setHealth(secondUnit.health - firstUnit.averageDamage());
                     System.debug(firstUnit.name + ' attacked bodypart: ' + firstAttack + ' of ' + 
                                 secondUnit.name + '. ' + secondUnit.name + ' tried to block this hit but blocked bodypart: ' + 
                                 secondDeffence + '. ' + secondUnit.name + '\'s health is ' + secondUnit.health);
                 } else if(secondDeffence.equals(firstAttack))
                 {
                     System.debug(firstUnit.name + ' attacked bodypart: ' + firstAttack + ' of ' + 
                                  secondUnit.name + '. ' + secondUnit.name + ' blocked this hit: ' + secondDeffence + '. ' + 
                                  secondUnit.name + '\'s health is ' + secondUnit.health);
                 }
                    
             } 
             else break;
				
        }
        
        /** 
         * Сheck who still alive after the fight and
         * assign a value to a variable "winner"
         */ 
		  if (firstUnit.health > secondUnit.health) 
		  {
            	winner = firstUnit;
          } 
          else if (secondUnit.health > firstUnit.health)
          {
            	winner = secondUnit;
          } 
           
        System.debug(winner.name + ' has won!');
        
        return winner;
    }
}
