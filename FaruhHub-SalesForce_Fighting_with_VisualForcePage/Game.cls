public class Game
{
    //-- This list will contain description of fighting process
    public List<String> GameFlow {get;set;}
    
    /*
     * This method controls all logic of the game. Additionally it calls also other auxiliary methods,
     * such as DoAttack(), ShowStats(), CalculateRating(), RandomInteger()
     * @param Unit__c aggressor, Unit__c victim our fighetrs
	*/
    //-- 
    public void Fight(Unit__c fighter1, Unit__c fighter2)
    {
        /*
         * in this local variables will be saved initial values of Health Power and Stamina of both fighters.
         * This is done in order to enter after the game the correct data, not changed during the game
         */  
        Decimal staminaOfFighter1 = fighter1.Stamina__c;
        Decimal staminaOfFighter2 = fighter2.Stamina__c;
        Decimal hpOfFighter1 = fighter1.HP__c;
        Decimal hpOfFighter2 = fighter1.HP__c;
        //-----------------------------------------------------
        
        GameFlow = new List<String>();
        Integer round = 1;
        Boolean isFinished = false;
        
        GameFlow.Add('******** ' + fighter1.Name +' VS '+ fighter2.Name + ' ********'  + '\n');
        do
        { 
            GameFlow.Add('|~~~~~~~    Раунд № '+ round +'   ~~~~~~~|');
            
            /**
             * This cycle has been created to make four attempts to attack during one round
			*/
            for(Integer i = 0; i < 4; i++)
            {   
                /**
				 * Method Randomizer.getRandomNumber(2) will generate two numbers 0 and 1.
				 * If it's zero fighter1 makes attack, otherwise fighter2 will do an attack  
				 */
                if( Randomizer.getRandomNumber(2) == 0) //first attack will be done by fighter1
                {
                    DoAttack(Randomizer.getRandomNumber(7), fighter1, fighter2);                                
                    if(fighter2.HP__c <= 0 || fighter2.Stamina__c <= 0)
                    {
                        GameFlow.Add('Победитель ' + '\"' + fighter1.name + '\"');
                        
                        fighter1.HP__c = hpOfFighter1;
                        fighter1.Stamina__c = staminaOfFighter1;
                        fighter2.HP__c = hpOfFighter2;
                        fighter2.Stamina__c = staminaOfFighter2;
                        
                        fighter1.Count_of_wins__c++;
                        fighter2.Amount_of_losses__c++;
                        fighter2.Is_Active__c = false;
                        fighter2.Activation_Date__c = DateTime.now()+1;
                        
                        update fighter1;
                        update fighter2;
                        
                        isFinished = true;
                        break;
                    }  
                }
                else  // first attack will be done by fighter2
                {
                    DoAttack(Randomizer.getRandomNumber(7), fighter2, fighter1);                
                    if(fighter1.HP__c <= 0 || fighter1.Stamina__c <= 0)
                    {
                        GameFlow.Add('Победитель ' + '\"' + fighter2.Name + '\"');
                        
                        fighter2.HP__c = hpOfFighter2;
                        fighter2.Stamina__c = staminaOfFighter2;
                        fighter1.HP__c = hpOfFighter1;
                        fighter1.Stamina__c = staminaOfFighter1;
                        
                        fighter2.Count_of_wins__c++;
                        fighter1.Amount_of_losses__c++;
                        fighter1.Is_Active__c = false;
                        fighter1.Activation_Date__c = DateTime.now()+1;
                        
                        update fighter2;
                        update fighter1;
                        
                        isFinished = true;
                        break;
                    }
                }
            }
            GameFlow.Add('\n');
            round++;
        }
        while(!isFinished);
    }
    
    /*
     * This method invokes by method Fight() to determine type of attack.
     * @param Integer kindOfAttack a randomly generated number of the attack
     * @param Unit__c aggressor, Unit__c victim our fighetrs
	*/
    @TestVisible
    private void DoAttack(Integer kindOfAttack, Unit__c aggressor, Unit__c victim)
    {
        Integer dmg = RandomInteger(aggressor);        
        
        if(kindOfAttack == 0) 
        { 
            GameFlow.Add(aggressor.Name + ' нанес удар рукой');
            if(DoBlock(Randomizer.getRandomNumber(3), victim) >= 2){
                victim.HP__c -= dmg;
                GameFlow.Add(victim.Name + ' получил '+ dmg +' процент урона ');
                victim.Stamina__c--;
                GameFlow.Add(ShowStats(aggressor, victim));
            }      
        }            
        
        if(kindOfAttack == 1)
        {        
            GameFlow.Add(aggressor.Name + ' нанес двойной удар рукой');
            if(DoBlock(Randomizer.getRandomNumber(3), victim) >= 2){
                victim.HP__c -= dmg;
                GameFlow.Add(victim.Name + ' получил '+ dmg +' процент урона ');
                victim.Stamina__c--;
                GameFlow.Add(ShowStats(aggressor, victim));
            }    
        }   
        
        if(kindOfAttack == 2)
        { 
            GameFlow.Add(aggressor.Name + ' нанес тройной удар рукой');
            if(DoBlock(Randomizer.getRandomNumber(3), victim) >= 2){
                victim.HP__c -= dmg;
                GameFlow.Add(victim.Name + ' получил '+ dmg +' процент урона ');
                victim.Stamina__c--;
                GameFlow.Add(ShowStats(aggressor, victim));
            }
        }
        
        if(kindOfAttack == 3)
        {
            GameFlow.Add(aggressor.Name + ' нанес один удар рукой и затем ногой');
            if(DoBlock(Randomizer.getRandomNumber(3), victim) >= 2){
                victim.HP__c -= dmg;
                GameFlow.Add(victim.Name + ' получил '+ dmg +' процент урона ');
                victim.Stamina__c--;
                GameFlow.Add(ShowStats(aggressor, victim));
            }    
        } 
        
        if(kindOfAttack == 4)
        {
            GameFlow.Add(aggressor.Name + ' дважды атаковал рукой и ногой');
            if(DoBlock(Randomizer.getRandomNumber(3), victim) >= 2){
                victim.HP__c -= dmg;
                GameFlow.Add(victim.Name + ' получил '+ dmg +' процент урона ');
                victim.Stamina__c--;
                GameFlow.Add(ShowStats(aggressor, victim));
            }      
        }
        
        if(kindOfAttack >= 5)
        {
            GameFlow.Add(aggressor.Name + ' нанес серию мощных ударов');
            if(DoBlock(Randomizer.getRandomNumber(3), victim) >= 2){
                victim.HP__c -= dmg;
                GameFlow.Add(victim.Name + ' получил '+ dmg +' процент урона ');
                victim.Stamina__c--;
                GameFlow.Add(ShowStats(aggressor, victim));
            }      
        }    
    }
    
    /*
     * This method invokes by method DoAttack() to determine could victim block or dodge from attack.
     * @param Integer kindOfBlock a randomly generated number of the block
     * @param Unit__c victim fighter taking attack
     * @return a number that will be a sign that he could block the strike or not
	*/
    @TestVisible
    private Integer DoBlock(Integer kindOfBlock, Unit__c victim)
    {
        if(kindOfBlock == 0){
            GameFlow.Add('Но ' + victim.Name + ' смог увернуться от удара.');
            return kindOfBlock;
        }
        else if(kindOfBlock == 1){
            GameFlow.Add('Но ' + victim.Name + ' смог блокировать удар.');
            return kindOfBlock;
        }
        else {
            GameFlow.Add(victim.Name + ' не сумел защититься и увернуться от атаки.');
            return kindOfBlock;
        }
    }
    
    /*
     * This method invokes by method Fight() to show statistics of the fighters.
     * @param Unit__c fighter1, Unit__c fighter2 our fighters
     * @returns a string which will be inserted to GameFlow list
	*/
    @TestVisible
    private String ShowStats(Unit__c fighter1, Unit__c fighter2)
    {
        return 'Уровень жизни -  ' + fighter1.Name + ':  ' + fighter1.HP__c +'  Выносливости:  '+ fighter1.Stamina__c + ' | ' + 
                                     fighter2.Name + ':  ' + fighter2.HP__c +'  Выносливости:  '+ fighter2.Stamina__c;
    }
    
    /*
     * This method invokes by method Fight() to determine average damage of the fighter.
     * @param Unit__c u selected fighter
     * @returns an average damage based on min damage and max damage
	*/
    @TestVisible
    private Integer RandomInteger(Unit__c u) 
    {
        Integer num = Math.floor(Math.random() * (u.DmgMax__c - u.DmgMin__c + 1) + u.DmgMin__c).intValue();
        return num;
    }
       
}