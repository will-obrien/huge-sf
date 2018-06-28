/*
 * This is Test Class for Game app 
 * It covers such classes as:
 * GameBatch - 100%
 * GameScheduleBatch - 100%
 * ScheduleGameUpdate - 100%
 * GameController - 100%
 * GameTrigger - 100%
 * SortClass - 100%
 * Unit - 100%
*/
@isTest
private class GameTest {
    
    @isTest 
    private static void addFighterTest()
    {
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30);
        insert fighter1;
        GameController game = new GameController();
        game.addFighter();
        System.assertEquals(1, game.unitsList.size());
        System.assertEquals(false, game.choseFighters);
        System.assertEquals(true, game.addNewFighter);
    }
    
    @isTest 
    private static void CorrectNumbersOfFightersTest()    
    {
        GameController game = new GameController();
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 700, Min_Damage__c = 20, Max_Damage__c = 40);
        insert fighter1;
        insert fighter2;
        Gamecontroller.Wrapper gameWrap = new GameController.Wrapper(fighter1, true);
        Gamecontroller.Wrapper gameWrap1 = new GameController.Wrapper(fighter2, true);
        game.unitsList.add(gameWrap);
        game.unitsList.add(gameWrap1);
        game.goFight();
    } 

    @isTest 
    private static void notCorrectNumbersOfFightersTest()    
    {
        GameController game = new GameController();
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 700, Min_Damage__c = 20, Max_Damage__c = 40);
        insert fighter1;
        insert fighter2;
        Gamecontroller.Wrapper gameWrap = new GameController.Wrapper(fighter1, false);
        Gamecontroller.Wrapper gameWrap1 = new GameController.Wrapper(fighter2, true);
        game.unitsList.add(gameWrap);
        game.unitsList.add(gameWrap1);
        game.goFight();
    }
    
    @isTest 
    private static void makeHitErrorTest()
    {
        GameController game = new GameController();
        game.makeHit();
    }
    
    @isTest 
    private static void bothFightersMakeHitTest()
    {
        GameController game = new GameController();
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 700, Min_Damage__c = 20, Max_Damage__c = 40);
      	game.createUnits(fighter1, fighter2); 
        game.Hit = 'Head';
        game.Block = 'Head';
        game.logList = new List<String>();
        game.round = 1;
        while(game.forRandomHitTest != 1)
        {
        	game.makeHit();
        }
        
        System.assertEquals('Head', game.Block);
        System.assertEquals('Head', game.Hit);
    }
    
    @isTest 
    private static void onlySomeFighterMakesHitTest()
    {
        GameController game = new GameController();
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 700, Min_Damage__c = 20, Max_Damage__c = 40);
        insert fighter1;
        insert fighter2;
        game.winner1 = fighter1;
        game.winner2 = fighter2;
      	game.createUnits(fighter1, fighter2); 
        game.Hit = 'Head';
        game.Block = 'Head';
        game.logList = new List<String>();
        game.round = 1;
        while(game.forRandomHitTest != 2)
        {
        	game.makeHit();
        }
    }
    
    @isTest 
    private static void onlySomeAnotherFighterMakesHitTest()
    {
        GameController game = new GameController();
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 700, Min_Damage__c = 20, Max_Damage__c = 40);
        insert fighter1;
        insert fighter2;
        
        game.winner1 = fighter1;
        game.winner2 = fighter2;
       	game.createUnits(fighter1, fighter2); 
        game.Hit = 'Head';
        game.Block = 'Head';
        game.logList = new List<String>();
        game.round = 1;
        while(game.forRandomHitTest != 3)
        {
        	game.makeHit();
        }
    }   
    
    @isTest 
    private static void bothFightersBlockTheHitTest()
    {
        GameController game = new GameController();
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30,
                                      Victory_Quantity__c = 0, Stamina__c = 80, Games_Quantity__c = 0);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 700, Min_Damage__c = 20, Max_Damage__c = 40,
                                      Victory_Quantity__c = 0, Stamina__c = 60, Games_Quantity__c = 0);
        insert fighter1;
        insert fighter2;
        game.winner1 = fighter1;
        game.winner2 = fighter2;
      	game.createUnits(fighter1, fighter2); 
        game.Hit = 'Head';
        game.Block = 'Head';
        game.logList = new List<String>();
        game.round = 1;
        
        while(game.forRandomHitTest != 4)
        {
        	game.makeHit();
        }
    }
    
    @isTest 
    private static void winner1Test()
    {
    	GameController game = new GameController();
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30,
                                      Victory_Quantity__c = 12, Stamina__c = 80, Games_Quantity__c = 20);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 200, Min_Damage__c = 20, Max_Damage__c = 40,
                                      Victory_Quantity__c = 0, Stamina__c = 50, Games_Quantity__c = 0);
        Unit__c fighter3 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30,
                                      Victory_Quantity__c = 0, Stamina__c = 80, Games_Quantity__c = 0);
        insert fighter1;
        insert fighter2;
        insert fighter3;
        game.winner1 = fighter1;
        game.winner2 = fighter2;
        game.logList = new List<String>();
        game.round = 1;
        
        Unit unit1 = new Unit(fighter1.name, (Integer)fighter1.Hp__c, (Integer)fighter1.Min_Damage__c, 
                              (Integer)fighter1.Max_Damage__c);
        Unit unit2 = new Unit();
        unit2.setName(fighter2.name);
        unit2.setHp(-10);
        unit2.setDmgMin((Integer)fighter2.Min_Damage__c);
        unit2.setDmgMax((Integer)fighter2.Max_Damage__c);
        game.fight(unit1, unit2);
    }
    
    @isTest 
    private static void winner2Test()
    {
    	GameController game = new GameController();
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30,
                                      Victory_Quantity__c = 0, Stamina__c = 80, Games_Quantity__c = 0);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 200, Min_Damage__c = 20, Max_Damage__c = 40,
                                      Victory_Quantity__c = 12, Stamina__c = 50, Games_Quantity__c = 20);
        Unit__c fighter3 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30,
                                      Victory_Quantity__c = 1, Stamina__c = 80, Games_Quantity__c = 1);
        insert fighter1;
        insert fighter2;
        insert fighter3;
        game.winner1 = fighter1;
        game.winner2 = fighter2;
        game.logList = new List<String>();
        game.round = 1;
        
        Unit unit1 = new Unit();
        unit1.setName(fighter1.name);
        unit1.setHp(-10); 
        unit1.setDmgMin((Integer)fighter1.Min_Damage__c);
        unit1.setDmgMax((Integer)fighter1.Max_Damage__c);
        Unit unit2 = new Unit();
        unit2.setName(fighter2.name);
        unit2.setHp((Integer)fighter2.Hp__c);
        unit2.setDmgMin((Integer)fighter2.Min_Damage__c);
        unit2.setDmgMax((Integer)fighter2.Max_Damage__c);
        game.fight(unit1, unit2);
    }
    
    @isTest 
    private static void nobodyWinsTest()
    {
    	GameController game = new GameController();
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30,
                                      Victory_Quantity__c = 0, Stamina__c = 80, Games_Quantity__c = 0);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 200, Min_Damage__c = 20, Max_Damage__c = 40,
                                      Victory_Quantity__c = 1, Stamina__c = 50, Games_Quantity__c = 13);
        insert fighter1;
        insert fighter2;
        game.winner1 = fighter1;
        game.winner2 = fighter2;
        game.logList = new List<String>();
        game.round = 1;
        
        Unit unit1 = new Unit();
        unit1.setName(fighter1.name);
        unit1.setHp(-10); 
        unit1.setDmgMin((Integer)fighter1.Min_Damage__c);
        unit1.setDmgMax((Integer)fighter1.Max_Damage__c);
        Unit unit2 = new Unit();
        unit2.setName(fighter2.name);
        unit2.setHp(-10);
        unit2.setDmgMin((Integer)fighter2.Min_Damage__c);
        unit2.setDmgMax((Integer)fighter2.Max_Damage__c);
        game.fight(unit1, unit2);
    }
    
    @isTest 
    private static void addNewRecordTest()
    {
    	GameController game = new GameController();
        game.unit = new Unit__c(Name = 'test unit1', HP__c = 1000, Min_Damage__c = 10, Max_Damage__c = 30);
        game.newFighter();
    }
    
    @isTest 
    private static void gameBatchTest()
    {
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30,
                                      Victory_Quantity__c = 0, Stamina__c = 80, Games_Quantity__c = 0);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 200, Min_Damage__c = 20, Max_Damage__c = 40,
                                      Victory_Quantity__c = 1, Stamina__c = 50, Games_Quantity__c = 13);
        insert fighter1;
        insert fighter2;
    	GameBatch batch = new Gamebatch();
        Database.executeBatch(batch);
    }
    
    @isTest 
    private static void GameScheduleBatchTest()
    {
        Unit__c fighter1 = new Unit__c(Name = 'test unit1', HP__c = 600, Min_Damage__c = 10, Max_Damage__c = 30,
                                      Victory_Quantity__c = 0, Stamina__c = 80, Games_Quantity__c = 0);
        Unit__c fighter2 = new Unit__c(Name = 'test unit2', HP__c = 200, Min_Damage__c = 20, Max_Damage__c = 40,
                                      Victory_Quantity__c = 1, Stamina__c = 50, Games_Quantity__c = 13);
        insert fighter1;
        insert fighter2;
    	System.schedule('Update unit stamina test', '0 0 0 * * ?', new ScheduleGameUpdate());
        
        GameScheduleBatch batch = new GameScheduleBatch(); 
        Database.executeBatch(batch);
    }
}
