public class GameObject 
{
    public Unit__c winner{get;set;}
    public List<String> gameLog{get;set;}
    
    /**
     * Method used to start fight between two Units and 
     * get the winner. It tooks as parameter two Units.
     */      
    public Unit__c fight(Unit__c first, Unit__c secon)
    {  
        Unit firstUnit = new Unit();
        firstUnit.name = first.Name;
        firstUnit.health = (Integer)first.Health__c;
        firstUnit.maxDamage = (Integer)first.MaxDamage__c;
        firstUnit.minDamage = (Integer)first.MinDamage__c;

        Unit secondUnit = new Unit();
        secondUnit.name = first.Name;
        secondUnit.health = (Integer)first.Health__c;
        secondUnit.maxDamage = (Integer)first.MaxDamage__c;
        secondUnit.minDamage = (Integer)first.MinDamage__c;
        
	gameLog = new List<String>();
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
                 if(!(firstDeffence == (secondAttack)))
                     
             	/** 
             	* Check if first Unit blocked kicks of second. 
             	* If he does - he doesn't losse his health. 
		* If he doesn't - health of first Unit getting lower on value 
		* of average damage of second Unit
             	*/
                 {
                    firstUnit.setHealth(firstUnit.health - secondUnit.averageDamage());
                    gameLog.add((secondUnit.name + ' attacked bodypart: ' + secondAttack + ' of ' + 
                                 firstUnit.name + '. ' + firstUnit.name + ' tried to block this hit but blocked bodypart: ' + 
                                 firstDeffence + '. ' + firstUnit.name + '\'s health is ' + firstUnit.health));
                 } else if(firstDeffence == (secondAttack))
                 {
                     gameLog.add((secondUnit.name + ' attacked bodypart ' + secondAttack + ' of ' + 
                                 firstUnit.name + '. ' + firstUnit.name + ' blocked this hit: ' + firstDeffence + '. ' + 
                                 firstUnit.name + '\'s health is ' + firstUnit.health));
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
                 if(!(secondDeffence == (firstAttack)))
                 {
                     secondUnit.setHealth(secondUnit.health - firstUnit.averageDamage());
                     gameLog.add((firstUnit.name + ' attacked bodypart: ' + firstAttack + ' of ' + 
                                 secondUnit.name + '. ' + secondUnit.name + ' tried to block this hit but blocked bodypart: ' + 
                                 secondDeffence + '. ' + secondUnit.name + '\'s health is ' + secondUnit.health));
                 } else if(secondDeffence ==(firstAttack))
                 {
                     gameLog.add((firstUnit.name + ' attacked bodypart: ' + firstAttack + ' of ' + 
                                  secondUnit.name + '. ' + secondUnit.name + ' blocked this hit: ' + secondDeffence + '. ' + 
                                  secondUnit.name + '\'s health is ' + secondUnit.health));
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
              winner = new Unit__c();
              winner.Name = firstUnit.name;
              winner.Health__c = firstUnit.health;
              winner.MaxDamage__c = firstUnit.maxDamage;
              winner.MinDamage__c = firstUnit.minDamage;
          } 
          else if (secondUnit.health > firstUnit.health)
          {
              winner = new Unit__c();
              winner.Name = secondUnit.name;
              winner.Health__c = secondUnit.health;
              winner.MaxDamage__c = secondUnit.maxDamage;
              winner.MinDamage__c = secondUnit.minDamage;
          } 
                   
        return winner;
    }      
}
