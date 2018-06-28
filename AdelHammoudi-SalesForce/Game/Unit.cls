/**
 * Unit class represents a players of game. 
 * 
 * @author  Adel Hammoudi
 * @version 1.0, June 2016
 */
public class Unit {
	
    private String name;
    private Integer hp;
    private Integer dmgMin;
    private Integer dmgMax;
    private KickBlockTypes kickType;
    private KickBlockTypes blockType;

    public Unit(Unit__c unit)
    {
        name = unit.name;
        hp = Integer.valueOf(unit.Hp__c);
        dmgMin = Integer.valueOf(unit.Min_Damage__c);
        dmgMax = Integer.valueOf(unit.Max_Damage__c);
    }

    public String getName()
    {
        return name;
    }

    public Integer getHp()
    {
        return hp;
    }

    public void setHp(Integer hp)
    {
        this.hp = hp;
    }
    
    public Integer getDmgMin()
    {
        return dmgMin;
    }

    public Integer getDmgMax()
    {
        return dmgMax;
    }

    public KickBlockTypes getKickType()
    {
        return kickType;
    }

    public void setKickType(KickBlockTypes kickType)
    {
        this.kickType = kickType;
    }

    public KickBlockTypes getBlockType()
    {
        return blockType;
    }

    public void setBlockType(KickBlockTypes blockType)
    {
        this.blockType = blockType;
    }

    /**
     * Return integer which depend on type of the block and type of the kick.
     * 
     * @param Unit unit will be kicked
     * @see  #getKickBlockType()
     */
    public Integer getKick(Unit unit)
    {
        if(kickType == null || unit.getBlockType() == null)
        {
            kickType = getKickBlockType();
            unit.setBlockType(getKickBlockType());
        }
        Integer kick;
        if (kickType != unit.getBlockType())
        {
            kick = (Integer)(Math.floor(Math.random() * (this.dmgMax - this.dmgMin + 1) + this.dmgMin));
        }
        else
        {
             kick = 0;
        }
    	return kick;
    }

    /**
     * Return random KickBlockTypes enum with probability: HEAD - 25%, CHEST - 25%, ARMS - 25%, LEGS - 25%.
     */
    public KickBlockTypes getKickBlockType()
    {
        KickBlockTypes kickBlockType;
        Integer i = (Integer)(Math.random()*4);
        if (i == 0)
        {
            kickBlockType = KickBlockTypes.HEAD;
            
        }
        else 
            if (i == 1)
            {
                kickBlockType = KickBlockTypes.CHEST;
            }
            else 
                if (i == 2)
                {
                    kickBlockType = KickBlockTypes.ARMS;
                }
                else
                {
                    kickBlockType = KickBlockTypes.LEGS;
                }
        return kickBlockType;
    }

    /**
     * Return true if player's hp more then 0.
     */
    public boolean isLive()
    {
    	boolean isLive  = true;
    	if (this.hp <= 0)
        {
    		isLive = false;
        }
    	return isLive;
    }
}