/**
 * company: Provectus
 * course: Salesforce
 * Date create: 11/06/2016
**/

public with sharing class Game {
    public List<String>logFighting {get; set;}
    
    /**
    * Method implements fighting logic app.
    **/
    public void fighting(Unit fighterOne, Unit fighterTwo) {
		logFighting = new List<String>();
        
        while(fighterOne.unitHP > 0 && fighterTwo.unitHP > 0) {
            logFighting.add(calculationHitAndBlock (fighterOne, fighterTwo));
            logFighting.add(calculationHitAndBlock (fighterTwo, fighterOne));
        } 
    }
    
    /**
    *  Method implements the logic block and hit
    **/
    public String calculationHitAndBlock (Unit fighterOne, Unit fighterTwo) {
        String intermediateResultFight;
        
        if(fighterOne.randomHit().equals(fighterTwo.randomBlock())) {
        	intermediateResultFight = fighterOne.unitName + ' нанес удар в ' + fighterOne.randomHit() 
        				+ fighterTwo.unitName + ' поставил блок!';
        } else {
        	calculationBalanceHP(fighterOne, fighterTwo);
            intermediateResultFight = (fighterOne.unitName + ' - ' + fighterOne.unitHP + ' --- ' 
            			       + fighterTwo.unitHP +  ' - ' + fighterTwo.unitName);
        } 
        return intermediateResultFight;
    }        
    
    /**
     * Method implements calculating and refresh balance units HP
    **/
    private void calculationBalanceHP(Unit fighterOne, Unit fighterTwo) {
        Integer balanceHP = fighterOne.unitHP - fighterTwo.hitWithForce();
        
        if(balanceHP > 0) {
           fighterOne.unitHP = balanceHP;
        } else {
           fighterOne.unitHP = 0;
        }
    }
	
    /**
    *  Method implements forms string with result of the battle and sets the state loss 
    **/
    public String printBattleResult(Unit fighterOne, Unit fighterTwo) {
        String resultButtle;
        
        if(fighterOne.unitHP > fighterTwo.unitHP && fighterOne.unitHP > 0) {
        	resultButtle = (fighterOne.unitName + ' [WIN]' + '  --  ' + '[DIE] ' + fighterTwo.unitName);
            fighterTwo.lossState = true;
        } else if (fighterTwo.unitHP > fighterOne.unitHP && fighterTwo.unitHP > 0){
        	resultButtle = (fighterOne.unitName + ' [DIE]' + '  --  ' + '[WIN] ' + fighterTwo.unitName);
            fighterOne.lossState = true;
        }
        return resultButtle;
    }
}
