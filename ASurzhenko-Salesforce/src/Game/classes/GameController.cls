/**
 * This is a custom controller of the VF Page Game
*/

public class GameController {

    public Unit__c winner1{get;set;}
    public Unit__c winner2{get;set;}
    public Unit__c unit {get;set;}
    
    public Unit unit1{get;set;}
    public Unit unit2{get;set;}
    
    public Integer damage{get;set;}
    public Integer forRandomHitTest{get;set;}
    public Integer round{get;set;}
    public String log{get;set;}
    public String whereHit{get;set;}
    public String hit{get;set;}
    public String block{get;set;}
    public String message{get;set;}
    
    public List<String>logList{get;set;}    
    public List<Wrapper> unitsList{get;set;} 
    public List<Unit__c> fightersList {get;set;}
    public boolean isNotVisible {get;set;}
    
    public boolean addNewFighter {get;set;}
    public boolean choseFighters {get;set;}
    public boolean isFight {get;set;}
           
    public GameController()
    {
        unitsList = getUnits();
        unit = new Unit__c();
        choseFighters = true;
        message = 'Select 2 fighters';
    }
    
    /**
     * This is list type SelectOption for radiobuttons
    */
    public List<SelectOption> getPlace() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Head','Head')); 
        options.add(new SelectOption('Chest','Chest')); 
        options.add(new SelectOption('Groin','Groin'));
        options.add(new SelectOption('Legs','Legs'));
        return options; 
    }          

    /**
     * This method takes information from DB and creates Wrapper class objects
     * Wrapper class can also define the activity of the checkbox depending on its stamina (Stamina__c)
    */
    @TestVisible
    private List<wrapper> getUnits()
    {
        List<Wrapper> unitsList = new List<Wrapper>();
        for(Unit__c u : [SELECT Name, HP__c, Min_Damage__c, Max_Damage__c, 
                                Lose_Date__c, Ressurection_Date__c, Victory_Quantity__c, Games_Quantity__c, 
                                Top_Position__c, Stamina__c FROM Unit__c])
        {
            unitsList.add(new Wrapper(u, false));
        }
        return unitsList;
    }

    public class Wrapper
    {
        public Unit__c unit {get; set;}
        public boolean isSelected {get; set;}
        public boolean isNotActive {get; set;}
        
        public Wrapper(Unit__c unit, boolean isSelected) 
        {
        // this is an old logic, not actual now    
        /*  Date today = Date.today();    
            if(unit.Lose_Date__c != NULL)
            {
                unit.Ressurection_Date__c = unit.Lose_Date__c.addDays(1);
                if(unit.Lose_Date__c.daysBetween(today) <= 1)
                {
                    //isNotActive = true;
                }
                else
                {
                    unit.Ressurection_Date__c = NULL;    
                }
            }   */
           
            if(unit.Stamina__c <= 0)
            {
                isNotActive = true;    
            }
            
            this.unit = unit;
            this.isSelected = isSelected;
        } 
    }

    /**
     * This method allows users create and add new fighter in game
    */
    public PageReference addFighter()
    {
        fightersList = new List<Unit__c>();
        unitsList = getUnits();
        choseFighters = false;
        isNotVisible = true;
        addNewFighter = true;
        return null;
    }

    /**
     * This method adds new record
    */
    public PageReference newFighter()
    {
        insert unit; 
        unit = new Unit__c();
        fightersList = new List<Unit__c>();
        unitsList = getUnits();
        choseFighters = true;
        addNewFighter = false;
        isNotVisible = false;
                         
        return null;
    }
    
    /**
     * This method starts the game.
     * It checks the correct number of fighters (it can be only 2) and returns an error if there are more or less
     * then 2 fighters checked 
    */
    public PageReference goFight()
    {
        fightersList = new List<Unit__c>();
        for(Wrapper wrap : unitsList)
        {
            if(wrap.isSelected)
                {  
                    fightersList.add(wrap.unit);  
                }  
        }
        if(fightersList.size() == 2)
        {
            round = 1;
            logList = new List<String>();
            isNotVisible = true;
            isFight = true;
            createUnits(fightersList.get(0), fightersList.get(1));
            winner1 = fightersList.get(0);
            winner2 = fightersList.get(1);
            message = unit1.getName() + ' VS ' + unit2.getNAme();
            choseFighters = false;
            addNewFighter = false;
            update fightersList;
            fightersList = new List<Unit__c>();
            unitsList = getUnits();
            log = 'Round ' + round + ' ' + unit1.getName() + ' HP left: ' + unit1.getHp() + ' ' +
                  unit2.getName() + ' HP left: ' + unit2.getHp();
        }
        else 
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'You have to chose 2 fighters!'));
            choseFighters = true;
            addNewFighter = false;
        }
        return null;
    }
    
    /**
     * This method creates units
    */
    public void createUnits(Unit__c fighter1, Unit__c fighter2)
    {
        unit1 = new Unit();
        unit1.setName(fighter1.name);
        unit1.setHp((Integer)fighter1.Hp__c); 
        unit1.setDmgMin((Integer)fighter1.Min_Damage__c);
        unit1.setDmgMax((Integer)fighter1.Max_Damage__c);
        unit2 = new Unit();
        unit2.setName(fighter2.name);
        unit2.setHp((Integer)fighter2.hp__c);
        unit2.setDmgMin((Integer)fighter2.Min_Damage__c);
        unit2.setDmgMax((Integer)fighter2.Max_Damage__c);
    }
    
    /**
     * This method starts fight method and returns an error if hit or block radiobutton
     * wasn't checked 
    */ 
    public PageReference makeHit() {
        
        if(hit == NULL || block == NULL)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, 'Please, make hit and block!'));
            return null;
        }
        logList = fight(unit1, unit2);
        log = 'Round ' + round + ' ' + unit1.getName() + ' HP left: ' + unit1.getHp() + ' ' +
              unit2.getName() + ' HP left: ' + unit2.getHp();
        return null;
    }
    
    /**
    * This method starts hitStrike method, calculate fighter's HP and returns log ot the current round
    * Also the method defines winner, changes stamina (Stamina__c) and game quantity (Game_Quantity__c)
    * of units 
    */
    public List<String> fight(Unit unit1, Unit unit2)
    {
        if (unit1.getHP() > 0 && unit2.getHP() > 0)
        {
            Integer hitPlacePC = Math.round((Math.floor(Math.random() * 3.5)));
            Integer blockPlacePC = Math.round((Math.floor(Math.random() * 3.5)));
            SelectOption PCHit = getPlace().get(hitPlacePC);
            SelectOption PCBlock = getPlace().get(blockPlacePC);
        
            if (hit != PCBlock.getValue() && block != PCHit.getValue()) // both fighters hit
            {
                forRandomHitTest = 1;
                                    
                whereHit = hit;            
                damage = hitStrike(unit1, unit2);
                unit2.setHp(unit2.getHp() - damage);
                
                whereHit = PCHit.getValue();            
                damage = hitStrike(unit2, unit1);
                unit1.setHp(unit1.getHp() - damage);
            }
            else if (hit != PCBlock.getValue() && block == PCHit.getValue()) // only unit 1 hits
            {
                forRandomHitTest = 2;
                            
                whereHit = hit;            
                damage = hitStrike(unit1, unit2);
                unit2.setHp(unit2.getHp() - damage);
                            
                logList.add(unit1.getName() + ' blocks the hit!');
            }     
            else if (hit == PCBlock.getValue() && block != PCHit.getValue()) // only unit 2 hits
            {
                forRandomHitTest = 3;
                                            
                whereHit = PCHit.getValue();            
                damage = hitStrike(unit2, unit1);
                unit1.setHp(unit1.getHp() - damage);
                            
                logList.add(unit2.getName() + ' blocks the hit!');
            }
            else // both units block
            {
                forRandomHitTest = 4;
                                      
                logList.add(unit1.getName() + ' blocks the hit!'); 
                logList.add(unit2.getName() + ' blocks the hit!');
            }
        }
        if (unit1.getHp() > 0 && unit2.getHp() <= 0)
        {
            winner1.Victory_Quantity__c ++;
            winner2.Stamina__c = 10;
            unitWins(unit1);
            return logList;
        }
        if(unit2.getHp() > 0 && unit1.getHp() <= 0)
        {
            winner2.Victory_Quantity__c ++;
            winner1.Stamina__c = 10;
            unitWins(unit2);
            return logList;
        }
        if(unit1.getHp() <= 0 && unit2.getHp() <= 0)
        {
            logList.add('It was a great fight! Both fighters were killed!');
            log = 'It was a great fight! Both fighters were killed!';
            winner1.Stamina__c = 10;
            winner2.Stamina__c = 10;
           
            unitUpdate();
        }
       
        round++;    
        return logList;    
    }
    
    /**
    * This method returns damage
    * unit 1 makes a hit
    * unit 2 defences
    * Also method defines if fighter misses, makes a crit or makes a normal hit
    * Fighter can miss the target in 25% cases and
    * make crit in 10% cases
    * crit = demage * 2
    */
    public Integer hitStrike(Unit unit1, Unit unit2)
    {
        Integer missOrCrit = (Integer)(Math.random() * 100);

        if(missOrCrit < 25)
        {
            damage = 0;
            logList.add(unit1.getName() + ' missed!');
        }
        else if(missOrCrit > 90) 
        {
            damage = ((Integer)(Math.random() * (unit1.getDmgMax() - unit1.getDmgMin() + 1) + unit1.getDmgMin())) * 2;
            logList.add(unit1.getName() + ' made CRIT! and kicked ' + unit2.getName() + ' in ' + whereHit + ' on ' + damage);
        }   
        else
        {
            damage = (Integer)(Math.random() * (unit1.getDmgMax() - unit1.getDmgMin() + 1) + unit1.getDmgMin());
            logList.add(unit1.getName() + ' kicked ' + unit2.getName() + ' in ' + whereHit + ' on ' + damage);
        }
            
        return damage;
    }
    
    public void unitWins(Unit unit)
    {
        logList.add(unit.getName() + ' wins');
        message = unit.getName() + ' wins';
        
        unitUpdate();
    }
    
    public void unitUpdate()
    {
        winner1.Stamina__c -= 10;
        winner2.Stamina__c -= 10;
        winner1.Games_Quantity__c ++;
        winner2.Games_Quantity__c ++;
        update winner1;
        update winner2;
        unitsList = getUnits();
        isNotVisible = false;
        choseFighters = true;
        isFight = false;
    }
}