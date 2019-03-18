public class Unit 
{
    
    public String name{get;set;}
    public Double health{get;set;}
    public Integer maxDamage{get;set;}
    public Integer minDamage{get;set;}
    
    /**
     * Constructor without parameters
     */
    public Unit ()
    {
    	
    }
    
    /** 
     * Constructor for Unit class. It takes as parameters
     * name of the Unit, it's start health, max and min Unit's damage
     */
    public Unit(String name, Double health, Integer maxDamage, Integer minDamage)
    {
    	this.name = name;
    	this.health = health;
    	this.maxDamage = maxDamage;
    	this.minDamage = minDamage;
    }

	/**
	 * Method set healt durring the fight. If it less than
	 * 0, it set 0 as a health value
	 */ 
    public void setHealth(Double health)
    {
        if(health >= 0)
        {
            this.health = health;
        } 
        else 
        {
            this.health = 0; 
        }
    }
  
  	/**
  	 * Method to determine average damage of Unit
  	 */
    public Double averageDamage()
    {
		Double averageDamage;
		averageDamage = Math.floor(Math.random() * (this.maxDamage - this.minDamage + 1) + this.minDamage);
		return averageDamage;
	}
    
	 /**
  	 * Method returns a value of body part which was attacked by Unit
  	 */
    public HitBlockType attack()
    {
        HitBlockType hitPlace;
        Integer hit = Math.round(1 + Math.random() * 4);
        if(hit == 1)
        {
        	hitPlace = HitBlockType.HEAD;
        } else if(hit == 2)
        {
            hitPlace = HitBlockType.CHEST;
        } else if(hit == 3)
        {
            hitplace = HitBlockType.HAND;
        } else if(hit == 4)
        {
            hitPlace = HitBlockType.LEG;
        }
        return hitPlace;
    }

    	/**
  	 * Method returns a value of body part which was deffended by Unit
  	 */    
    public HitBlockType deffence()
    {
        HitBlockType deffencePlace;
        Integer deffence = Math.round(1 + Math.random() * 4);
        if(deffence == 1)
        {
        	deffencePlace = HitBlockType.HEAD;
        } else if(deffence == 2)
        {
            deffencePlace = HitBlockType.CHEST;
        } else if(deffence == 3)
        {
            deffencePlace = HitBlockType.HAND;
        } else if(deffence == 4)
        {
            deffencePlace = HitBlockType.LEG;
        }
        return deffencePlace;
    }
}
