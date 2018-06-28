/**
 * company: Provectus
 * course: Salesforce
 * @author: Stepan Filyk
 * Date create: 11/06/2016
**/

public with sharing class Unit {
    public String unitName {get; set;}
    public Integer unitHP {get; set;}
    public Integer unitDamageMin {get; set;}
    public Integer unitDamageMax {get; set;}
    public Boolean lossState {get; set;}
    
    public Unit(String unitName, Integer unitHP, Integer unitDamageMin, Integer unitDamageMax) {
        this.unitName = unitName;
        this.unitHP = unitHP;
        this.unitDamageMin = unitDamageMin;
        this.unitDamageMax = unitDamageMax;
        lossState = false;
    }
    
    /**
    * Method implements the generation of random values level damage power
    **/ 
    public Integer hitWithForce() {
        Integer damageMin = unitDamageMin;
        Integer damageMax = unitDamageMax;
	Integer damage = (Integer)(Math.floor(Math.random() * (damageMax - damageMin + 1) + damageMin));;
        
        return damage; 
    }
    
    /**
    *	Method implements randomly calculates target for hit
    **/    
    public String randomHit() {
        String targetToHit;
        Integer rundomTargetToHit = (Integer)Math.floor(Math.random() * 100);
        
        if(rundomTargetToHit < 30) {
	    targetToHit = 'head';
        } else if (rundomTargetToHit >= 30 && rundomTargetToHit < 70) {
	    targetToHit = 'body';
        } else if (rundomTargetToHit >= 70 && rundomTargetToHit < 100) {
            targetToHit = 'legs';
        }
    	return targetToHit;
    }
    
    /**
	* 	Method implements randomly calculates block from hit
	**/
    public String randomBlock() {
        String blockFromHit;
        
        Integer randomBlockFromHit = (Integer)Math.floor(Math.random() * 100);
        
        if(randomBlockFromHit < 30) {
            blockFromHit = 'head';
        } else if (randomBlockFromHit >= 30 && randomBlockFromHit < 70) {
            blockFromHit = 'body';
        } else if (randomBlockFromHit >= 70 && randomBlockFromHit <= 100) {
            blockFromHit = 'legs';
        }
        return blockFromHit;
    }
    
}
