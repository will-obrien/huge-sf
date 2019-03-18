/**
* in GameControllerTest unit test we test our Controller
*/
@isTest
public class GameControllerTest
{
    //creating data
    private static testMethod void setData() 
    {
        Unit__c firstUnit = new Unit__c(Name = 'first',
                                        HP__c = 200,
                                        minDMG__c = 10, 
                                        maxDMG__c = 10, 
                                        Stamina__c = 100,
                                        Active__c = true);
        Unit__c secondUnit = new Unit__c(Name = 'second', 
                                         HP__c = 200, 
                                         minDMG__c = 10, 
                                         maxDMG__c = 10, 
                                         Stamina__c = 100,
                                         Active__c = true);
        Unit__c thirdUnit = new Unit__c(Name = 'third', 
                                        HP__c = 200, 
                                        minDMG__c = 10, 
                                        maxDMG__c = 29, 
                                        Stamina__c = 100,
                                        Active__c = true);
        Unit__c fourthUnit = new Unit__c(Name = 'fourth', 
                                         HP__c = 200, 
                                         minDMG__c = 30, 
                                         maxDMG__c = 49, 
                                         Stamina__c = 100,
                                         Active__c = false,
                                         Deactivation_Time__c = DateTime.now());
        Unit__c fifthUnit = new Unit__c(Name = 'fifth', 
                                         HP__c = 200, 
                                         minDMG__c = 30, 
                                         maxDMG__c = 49, 
                                         Stamina__c = 100,
                                         Active__c = false,
                                         Deactivation_Time__c = DateTime.now().addDays(-2));
        List<Unit__c> testUnitsList = new List<Unit__c>();
        testUnitsList.add(firstUnit);
        testUnitsList.add(secondUnit);
        testUnitsList.add(thirdUnit);
        testUnitsList.add(fourthUnit);
        testUnitsList.add(fifthUnit);
        insert testUnitsList;
    }
    /**
    *testing the initialization of data in controller, 
    *gameInitialization() method calls inside of it the checkUnitsActivity() getActiveUnits() getAllUnits() methods so they are testing here
    */
    static testMethod void gameInitializationTest() 
    {
        GameControllerTest.setData();
        List <Unit__c> activeUnits  = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c, Active__c
                                        FROM Unit__c
                                        WHERE Active__c = true];
        List <Unit__c> inActiveUnits  = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c, Active__c
                                         FROM Unit__c
                                         WHERE Active__c = false];
        List <Unit__c> allUnits  = new List<Unit__c>();
        allUnits.addAll(activeUnits);
        allUnits.addAll(inActiveUnits);

        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.gameInitialization();
        Test.stopTest();
        
        inActiveUnits  = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c, Active__c
                          FROM Unit__c
                          WHERE Active__c = false];
        
        system.assertEquals(4, gameCtrl.activeUnits.size(), 'Error: wrong list size');
        system.assertEquals(5, gameCtrl.allUnits.size(), 'Error: wrong list size');
        system.assertEquals(1, inActiveUnits.size(), 'Error: wrong list size');
    }
    //testing the activation of all units
    static testMethod void activateAllUnitsTest() 
    {
        GameControllerTest.setData();
        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.activateAllUnits();
        Test.stopTest();
        
        system.assertEquals(gameCtrl.allUnits.size(), gameCtrl.activeUnits.size(), 'Error: wrong list size');
    }
    //testing the method that get data from active units and sets in into options of page's menu 
    static testMethod void getUnitSelectListTest() 
    {
        GameControllerTest.setData();
        GameController gameCtrl = new GameController();
        gameCtrl.gameInitialization();
        List<SelectOption> options = gameCtrl.getUnitSelectList();
        gameCtrl.getUnitSelectList();
        
        System.assertEquals(gameCtrl.activeUnits.size() + 1, options.size(), 'Error: options size and activeUnits not match');
        
        gameCtrl.activeUnits.clear();
        gameCtrl.getUnitSelectList();
        options = gameCtrl.getUnitSelectList();
        
        System.assertEquals(1, options.size(), 'Error: options size is not 1');     
    }
    //testing the choosing of menu's options
    static testMethod void chooseUnitTest() 
    {
        GameControllerTest.setData();
        List<Unit__c> activeUnits = [SELECT ID, Name 
                                     FROM Unit__c
                                     WHERE Active__c = true];
        
        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.gameInitialization();
            gameCtrl.firstUnit = activeUnits[0];
            gameCtrl.secondUnit = activeUnits[1];
            gameCtrl.firstChosedUnit = activeUnits[1].ID;
            gameCtrl.secondChosedUnit = activeUnits[2].ID;
            gameCtrl.chooseFirstUnit();
            gameCtrl.chooseSecondUnit();
        Test.stopTest();
        
        System.assertEquals(gameCtrl.firstUnit.ID, activeUnits[1].ID, 'Error: IDs doesn\'t match');     
        System.assertEquals(gameCtrl.secondUnit.ID, activeUnits[2].ID, 'Error: IDs doesn\'t match'); 
    }
    //testing the fight sending the NULL values as parameters
    static testMethod void fightWithNULLUnitTest() 
    {
        GameControllerTest.setData();
        Unit__c firstUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Stamina__c, Number_of_Victories__c, Number_of_Games__c FROM Unit__c][0];
        
        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.firstUnit = firstUnit;
            gameCtrl.fight();
        Test.stopTest();
        
        System.assertEquals(true, ApexPages.getMessages().get(0).getDetail().contains('Unit can\'t be NULL.'), 
                            						'Error: Apex Message was not added.');
        System.assertEquals(NULL, gameCtrl.winner, 'Error: winner should be NULL');
        System.assertEquals(NULL, gameCtrl.looser, 'Error: looser should be NULL');       
    }
    //testing the fight
    static testMethod void fightTest()
    {
        GameControllerTest.setData();
        Unit__c firstUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Stamina__c, Number_of_Victories__c, Number_of_Games__c FROM Unit__c][0];
        Unit__c secondUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Stamina__c, Number_of_Victories__c, Number_of_Games__c FROM Unit__c][1];
        firstUnit.HP__c = 9999;
        
        Test.startTest();
        GameController gameCtrl = new GameController();
            gameCtrl.firstUnit = firstUnit;
            gameCtrl.secondUnit = secondUnit;
            gameCtrl.fight();
            system.assert(gameCtrl.winner == firstUnit && gameCtrl.looser == secondUnit, 'Error: wrong fight results');
            gameCtrl.firstUnit = secondUnit;
            gameCtrl.secondUnit = firstUnit;
            gameCtrl.fight();
            system.assert(gameCtrl.winner == firstUnit && gameCtrl.looser == secondUnit, 'Error: wrong fight results');
        Test.stopTest();
    }
    //testing the deactivation of units
    static testMethod void deactivateUnitsTest() 
    {
        GameControllerTest.setData();
        Unit__c firstUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c, Deactivation_Time__c, Active__c FROM Unit__c][0];
        Unit__c secondUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c, Deactivation_Time__c, Active__c FROM Unit__c][1];
        firstUnit.Stamina__c = 0;
        
        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.deactivateUnits(firstUnit, secondUnit);
        Test.stopTest();
        
        firstUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c, Deactivation_Time__c, Active__c FROM Unit__c][0];
        secondUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Stamina__c, Deactivation_Time__c, Active__c FROM Unit__c][1];
        
        system.assertEquals(false, firstUnit.Active__c, 'Error: Unit must be inactive');
        system.assertEquals(false, secondUnit.Active__c, 'Error: Unit must be inactive');
        system.assertEquals(DateTime.now(), secondUnit.Deactivation_Time__c, 'Error: wrong deactivation time');
    }
    // testing the saving ofgameresults  
    static testMethod void saveGameResultTest() 
    {
        GameControllerTest.setData();
        Unit__c firstUnit = [SELECT Id, Name, Number_of_Victories__c, Number_of_Games__c FROM Unit__c][0];
        Unit__c secondUnit = [SELECT Id, Name, Number_of_Victories__c, Number_of_Games__c FROM Unit__c][1];

        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.game = new Game();
            gameCtrl.saveGameResult(firstUnit, secondUnit);
        Test.stopTest();
        
        firstUnit = [SELECT Id, Name, Number_of_Victories__c, Number_of_Games__c FROM Unit__c][0];
        secondUnit = [SELECT Id, Name, Number_of_Victories__c, Number_of_Games__c FROM Unit__c][1];
        
        Fight__c testFight = [SELECT Id, Name, Winner__c, Looser__c FROM Fight__c WHERE Winner__c = :firstUnit.ID];
        
        system.assertEquals(testFight.Winner__c, firstUnit.ID, 'Error: Unit must be inactive');
        system.assertEquals(testFight.Looser__c, secondUnit.ID, 'Error: Unit must be inactive');
        system.assertEquals(1, firstUnit.Number_of_Victories__c, 'Error: Wrong number of victories');
        system.assertEquals(1, firstUnit.Number_of_Games__c, 'Error: Wrong number of games');
        system.assertEquals(0, secondUnit.Number_of_Victories__c, 'Error: Wrong number of victories');
        system.assertEquals(1, secondUnit.Number_of_Games__c, 'Error: Wrong number of games');
    } 
    /**
    * the code below is testing the unit management logic of controller 
    * the next method are tested : createEditUnit(), saveUnit(), editUnit(), updateUnit(), deleteUnit(), closeCreationEditing()
    */  
    static testMethod void editUnitTest() 
    {
        GameControllerTest.setData();
        PageReference pageRef = Page.updateContactPage;
        Unit__c testUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c FROM Unit__c][0];
        pageRef.getParameters().put('unitID', testUnit.Id);
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.editUnit();
            gameCtrl.newUnit.Name = 'Edited Name';
            gameCtrl.updateUnit();
        Test.stopTest();
        
        testUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c FROM Unit__c WHERE ID = :testUnit.ID];
        
        System.assertEquals('Edited Name', testUnit.Name, 'Error: Incorrect name');     
    }
    
    static testMethod void deleteUnitTest() 
    {
        GameControllerTest.setData();
        PageReference pageRef = Page.updateContactPage;
        Unit__c testUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c FROM Unit__c][0];
        pageRef.getParameters().put('unitID', testUnit.Id);
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.deleteUnit();
        Test.stopTest();

        List<Unit__c> testList = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c FROM Unit__c WHERE ID = :testUnit.ID];
        
        System.assertEquals(0, testList.size(), 'Error: Invalid List size, perhaps unit hasn\'t been deleted');     
    } 

    static testMethod void save_updateUnitNULLTest() 
    {
        Test.startTest();
            GameController gameCtrl = new GameController(); 	
            gameCtrl.saveUnit();
            gameCtrl.updateUnit();
        Test.stopTest();
        
        System.assertEquals(true, ApexPages.getMessages().get(0).getDetail().contains('Unit can\'t be NULL.'), 'Error: Apex Message was not added.');
        System.assertEquals(NULL, gameCtrl.newUnit, 'Error: Unit should be NULL');     
    }
    
    static testMethod void save_updateUnitWithWrongValuesTest() 
    {
        GameControllerTest.setData();
        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.createEditUnit();
            gameCtrl.saveUnit();
            gameCtrl.updateUnit();
        Test.stopTest();
        
        System.assertEquals(true, ApexPages.getMessages().get(0).getDetail().contains('Make sure that you have entered the proper values.'), 'Error: Apex Message was not added.');
        System.assertNotEquals(NULL, gameCtrl.newUnit, 'Error: Unit can\'t be NULL');     
    }
    
    static testMethod void save_updateUnitWithWrongDamageValuesTest() 
    {
        GameControllerTest.setData();
        Unit__c testUnit = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c FROM Unit__c][0];
        testUnit.minDMG__c = 15;
        
        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.createEditUnit();
            gameCtrl.newUnit = testUnit;
            gameCtrl.saveUnit();
            gameCtrl.updateUnit();
        Test.stopTest();

        System.assertEquals(true, ApexPages.getMessages().get(0).getDetail().contains('Minimum Damage cannot be less then Maximum Damage.'), 'Error: Apex Message was not added.');
        System.assertNotEquals(NULL, gameCtrl.newUnit, 'Error: Unit can\'t be NULL');     
    }
    
    static testMethod void save_updateUnitTest() 
    {
        GameControllerTest.setData();
        Unit__c testUnitToSave = new Unit__c(Name = 'testUnitToSave',
                                             HP__c = 200,
                                             minDMG__c = 10,
                                             maxDMG__c = 10,
                                             Stamina__c = 100,
                                             Active__c = true);
        Unit__c testUnitToUpdate = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c FROM Unit__c][0];

        Test.startTest();
        GameController gameCtrl = new GameController();
            gameCtrl.createEditUnit();
            gameCtrl.newUnit = testUnitToSave;
            gameCtrl.saveUnit();
            gameCtrl.newUnit = testUnitToUpdate;
            gameCtrl.updateUnit();
        Test.stopTest();
        
        Unit__c testUnitToSaveNew = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c FROM Unit__c WHERE ID = :testUnitToSave.ID];
        Unit__c testUnitToUpdateNew = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c FROM Unit__c WHERE ID = :testUnitToUpdate.ID];
        
        System.assertEquals(testUnitToSaveNew, testUnitToSave, 'Error: Unit hasn\'t been inserted .');
        System.assertEquals(testUnitToUpdateNew, testUnitToUpdate, 'Error: Unit hasn\'t been updated .');     
    }
    
    static testMethod void closeCreationEditingTest() 
    {
        GameControllerTest.setData();
        Test.startTest();
            GameController gameCtrl = new GameController();
            gameCtrl.createEditUnit();
            gameCtrl.closeCreationEditing();
        Test.stopTest();

        System.assertEquals(NULL, gameCtrl.newUnit, 'Error: Unit should be NULL');     
    }

}