/**
 * This class for creating units
*/
public class Unit 
{
    public String name{get;set;}
    public Integer hp{get;set;}
    public Integer dmgMin{get;set;}
    public Integer dmgMax{get;set;}

    public Unit() 
    {
        
    }
    
    public Unit(String name, Integer hp, Integer dmgMin, Integer dmgMax) 
    {
        this.name = name;
        this.hp = hp;
        this.dmgMin = dmgMin;
        this.dmgMax = dmgMax;
    }
    
    public String getName()
    {
        return name;
    }
    
    public void setName(String name)
    {
        this.name = name;
    }

    public Integer getHp()
    {
        return Hp;
    }
    
    public void setHp(Integer hp)
    {
        this.hp = hp;
    }
    
    public Integer getDmgMin()
    {
        return dmgMin;
    }
    
    public void setDmgMin(Integer dmgMin)
    {
        this.dmgMin = dmgMin;
    }
    
    public Integer getDmgMax()
    {
        return dmgMax;
    }
    
    public void setDmgMax(Integer dmgMax)
    {
        this.dmgMax = dmgMax;
    }
}