/**
 * This code contains methods that serve for determining the winner
 */
public class Game 
{
    private Unit__c winner;
    public List<String> gameLog {get; set;}
    private Unit__c hitter;
    private Unit__c victim;

    public Game() 
    {
        winner = new Unit__c();
        gameLog = new List<String>();      
    }
    /**
    * This method returns the type of hit/bock. The type depends of randomly ganerated number
    */
    public String getBlockKickType(Integer partOfBody) {
        
        String BlockKick; 
        if (partOfBody == 0)
        {
            BlockKick = 'Head';
        } 
        else if (partOfBody == 1)
        {
            BlockKick = 'Chest';
        }
        else if (partOfBody == 2)
        {
            BlockKick = 'Belly';
        }
        else if (partOfBody == 3)
        {
            BlockKick = 'Groin';
        }
        return BlockKick;
    }
    /**
    * This method will server for decreasing the unit's stamina during the fight
    * it depends on the strength of the hit
    */
    public Decimal spentStaminaPoints (Integer damage)
    {
        return damage/10;
    }
    /**
    * This method returns the damage to harm the unit
    */
    public Integer generateDamage(Unit__c unit)
    {
        return (Integer)(Math.floor(Math.random() * (unit.maxDMG__c - unit.minDMG__c + 1) + unit.minDMG__c));
    }
    public Integer hit(Unit__c hitter, Unit__c victim) 
    {
        Integer damage = 0;
        if (hitter.Stamina__c > 0)
        {              
            Decimal spentStaminaPoints;
            String typeOfBlock, typeOfKick;
            /**
             * Getting random blosk and hit
             */
            typeOfBlock = getBlockKickType((Integer)Math.floor(Math.random() * 4));
            typeOfKick = getBlockKickType((Integer)Math.floor(Math.random() * 4));
            /**
            * calculating the damage that based on unit's maxDMG and minDMX characteristics
            * assigning the to the spentStaminaPointsm which unit will lost in any case
            */
            spentStaminaPoints = spentStaminaPoints(damage = generateDamage(hitter));
            /**
             * there's 20 % possibility that player will fail at hitting his enemy
             */
            if ((Integer)Math.floor(Math.random() * 100) < 20) 
            {
                damage = 0;
                gameLog.add(hitter.Name + ' has missed.');
            }
            else if (typeOfBlock == typeOfKick)
            {
                damage = 0;
                gameLog.add(victim.Name + ' used proper block.');
            }    
            else 
            {
                gameLog.add(victim.Name + ' is blocking his ' + typeOfBlock + ', '
                           + hitter.Name + ' beats in ' +  typeOfKick + '.');    
            }
            gameLog.add(victim.Name + ' gets ' +damage + ' points of damage, ' + hitter.Name + ' lost ' +spentStaminaPoints + ' points of stamina.');
            //Hitting unit wastes his stamina even if he didn't harm his opponent (missed or opponent used the right block)
            hitter.Stamina__c -= hitter.Stamina__c > spentStaminaPoints ? spentStaminaPoints : hitter.Stamina__c;           
        } 
        else
        {
            gameLog.add(hitter.Name + ' has no more strength left.');
            hitter.HP__c = 0;
        }
        return damage;
    }
    
    /**
    * This method determins which unit will hit next
    */
    private void setHitterVictim (Unit__c Unit1, Unit__c Unit2)
    {
        if ((Integer)Math.floor(Math.random() * 100) < 50)
        {
            hitter = Unit1;
            victim = Unit2;
        } else
        {
            hitter = Unit2;
            victim = Unit1;
        }
    }
    /**
    * The main method which determins the winner
    */
    public Unit__c Fight (Unit__c Unit1, Unit__c Unit2) 
    {
        if (Unit1 != null && Unit2 !=null)
        {
            Decimal Unit1_HP = Unit1.HP__c;
            Decimal Unit2_HP = Unit2.HP__c;
            hitter = new Unit__c();
            victim = new Unit__c();
            for (Integer i = 1; ; i++) 
            {
                gameLog.add('Round '+ i + ': ' + Unit1.Name + ' HP = ' + Unit1.HP__c + ', ' + Unit2.Name + ' HP = ' + Unit2.HP__c + '.');
                setHitterVictim(Unit1, Unit2);
                victim.HP__c -= Hit(hitter, victim);
                if (victim.HP__c <= 0) break;
                hitter.HP__c -= Hit(victim, hitter);
                if (hitter.HP__c <= 0) break;

            }
            winner = Unit1.HP__c > Unit2.HP__c ? Unit1 : Unit2;
            Unit1.HP__c = Unit1_HP;
            Unit2.HP__c = Unit2_HP;
            gameLog.add(winner.Name + ' has won!');
            return winner;
        } else
        {
            throw new GameException('Unit cannot be null.');
        }        
    }
}