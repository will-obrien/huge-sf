/**
 * company: Provectus
 * course: Salesforce
 * @author: Stepan Filyk
 * Date create: 11/06/2016
**/

public class GameLaunch {
    		
    public String nameNewFighter{get; set;}
    public Integer hitpointNewFighter{get; set;}
    public Integer minDamageNewFighter{get; set;}
    public Integer maxDamageNewFighter{get; set;}
    
    public List<Unit__c> listUnitsForBattle {get; set;}   
    public String selectedUnit {get; set;}
    public Unit__c manualSelectedFighter;
    public Unit__c randomSelectedFighter;
    
    public List<String> logFighting {get; set;}    
    public String resultFight {get; set;}
    
    
    public PageReference test() {
        return null;
    }
    
    /**
     * Method implements initializes instanse class and application launches 
    **/
    public void startGame() {
    	gettingListUnit();
	manualSelectionFighter(selectedUnit);
	randomSelectionFighter();        
    	Unit fighterOne = new Unit(manualSelectedFighter.Name, manualSelectedFighter.Hitpoint__c, 
                                   manualSelectedFighter.minDamage__c, manualSelectedFighter.maxDamage__c);
    	
        Unit fighterTwo = new Unit(randomSelectedFighter.Name, randomSelectedFighter.Hitpoint__c, 
                                   randomSelectedFighter.minDamage__c, randomSelectedFighter.maxDamage__c);
    	Game game = new Game();
        game.fighting(fighterOne, fighterTwo);
    	logFighting = game.logFighting;
   	resultFight = game.printBattleResult(fighterOne, fighterTwo);
    }
    
    /**
    * Method implements getting list of all fighters to select
    **/
    public List<Unit__c> gettingListUnit() {
        listUnitsForBattle= new List<Unit__c>();
        
        for (Unit__c units : [SELECT Name, Hitpoint__c, minDamage__c, maxDamage__c FROM Unit__c]) {
            listUnitsForBattle.add(units);
        }
        return listUnitsForBattle;
    }
        
    /**
    * Method implements gets items of List for print to VisualForce page
    **/
    public List<SelectOption> getItems() {
        List<SelectOption> itemsList = new List<SelectOption>();
        
        for (Integer i = 0; i < listUnitsForBattle.size(); i++) {
            String unitToSelect = listUnitsForBattle[i].Name;
            itemsList.add(new SelectOption(unitToSelect, unitToSelect));
        }
    return itemsList;
    }
    
    /**
    *  Method implements getting selected Unit from List units
    **/
    public void manualSelectionFighter(String selectedUnit) {
    	for(Integer i = 0; i < listUnitsForBattle.size(); i++) {
            if(selectedUnit.equals(listUnitsForBattle[i].Name)) {
                manualSelectedFighter = listUnitsForBattle[i];
            }
        }
    }
    
    /**
    *	Method implements random selection fighter  
    * 
    **/
    public void randomSelectionFighter() {
	Double randomNumber = Math.random();
	Integer listSize = listUnitsForBattle.size();
	Integer randomIndex = (randomNumber * (listSize - 1)).intValue();
		
	for (Unit__c units : listUnitsForBattle) {
            if(listUnitsForBattle[randomIndex].Name != manualSelectedFighter.Name && randomIndex == 0) {
        	randomSelectedFighter = listUnitsForBattle[randomIndex];
        	break;
	     }
    	randomIndex--;
	}
    }
    
    /**
    * Method implements creation and inserts new Unit 
    **/
    public void creationNewUnit() {
        Unit__c newUnit = new Unit__c();
        newUnit.Name = nameNewFighter;
        newUnit.Hitpoint__c = hitpointNewFighter;
        newUnit.minDamage__c = minDamageNewFighter;
        newUnit.maxDamage__c = maxDamageNewFighter;
        insert newUnit;
    }
}
