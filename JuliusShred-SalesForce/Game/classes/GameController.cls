/**
* this is the GameController class for our game witch helps to interact with Game VF page
*/
public class GameController 
{
    public Boolean showCreateEditUnit {get; set;}
    public Boolean isCreating {get; set;}
    public Boolean isUpdating {get; set;}
    public Boolean showFirstChosenUnit {get; set;}
    public Boolean showSecondChosenUnit {get; set;}
    public Boolean showResult {get; set;}
    public Unit__c firstUnit {get; set;}
    public Unit__c secondUnit {get; set;}
    public Unit__c winner {get; set;}
    public Unit__c looser {get; set;}
    public Unit__c newUnit {get; set;}
    public List<Unit__c> activeUnits {get; set;}
    public List<Unit__c> allUnits {get; set;}
    public String firstChosedUnit {get; set;}
    public String secondChosedUnit {get; set;}
    public Game game {get; set;}
    
    //initializing the data
    public void gameInitialization () 
    {
        firstUnit = new Unit__c();
        secondUnit = new Unit__c();
        checkUnitsActivity();
        getActiveUnits();
        getAllUnits();
        showFirstChosenUnit = false;
        showSecondChosenUnit = false;
        showResult = false;
        showCreateEditUnit = false;
        isCreating = false;
        isUpdating = false;
    }
    //used for getting the list of current active units
    private void getActiveUnits() 
    {
        activeUnits = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Number_of_victories__c, Number_of_Games__c, Position_in_top__c, Percent_of_Victories__c, Stamina__c
                       FROM Unit__c 
                       WHERE Active__c = true];
    }
    //used for getting the list of all units
    private void getAllUnits() 
    {
        allUnits = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Number_of_victories__c, Number_of_Games__c, Position_in_top__c, Percent_of_Victories__c, Stamina__c
                    FROM Unit__c];
    }
    //used for checking the list of deactivating units and determins which of them are able to return to the game
    public void checkUnitsActivity() 
    {
        List<Unit__c> unitsToCheckList = [SELECT Active__c, Deactivation_Time__c, Stamina__c
                                          FROM Unit__c 
                                          WHERE Active__c = false];
        
        List<Unit__c> unitsToUpdateList = new List<Unit__c>();

        DateTime nowMinus24Hours = DateTime.now().addDays(-1);
        for (Unit__c unit: unitsToCheckList)
        {
            if ((unit.Deactivation_Time__c < nowMinus24Hours || unit.Deactivation_Time__c == NULL) && unit.Stamina__c > 0)
            {
                unit.Active__c = true;
                unitsToUpdateList.add(unit);
            }
        }
        if (!unitsToUpdateList.isEmpty())
        {
            update unitsToUpdateList;
        }
    } 
    //this is used when we want to activate all users
    public PageReference activateAllUnits ()
    {
        List<Unit__c> inActiveUnitsList = [SELECT  Active__c, Deactivation_Time__c
                                           FROM Unit__c];
        for (Unit__c unit: inActiveUnitsList) 
        {
            unit.Active__c = true;
            unit.Stamina__c = 100;
        }
        update inActiveUnitsList;
        getActiveUnits();
        getAllUnits();
        return null;
    }
    // this snippet does the generation of options in the menu so we can select the untis from it
    public List<SelectOption> getUnitSelectList() 
    {
        List<SelectOption> options = new List<SelectOption>();

        List<Unit__c> listOfUnits = new List<Unit__c>();
        for (Unit__c unit: activeUnits) 
        {
            if (unit != firstUnit && unit != secondUnit) 
            {   
                listOfUnits.add(unit);
            }
        }

        for (Unit__c unit : listOfUnits) 
        {
            String unitString = unit.Name + ': HP=' + unit.HP__c + ', Minimal damage = ' + unit.minDMG__c + ', Maximum damage = ' + unit.maxDMG__c ;
            options.add(new SelectOption(unit.Id, unitString));
        }

        if (options.size() > 0) 
        {
            options.add(0, new SelectOption('', 'Select Unit'));
        } 
        else 
        {
            options.add(new SelectOption('', 'Not available'));
        }
        return options;
    }
    //we use this method to get the unit that we need when selecting it in the select menu
    private Unit__c chooseUnit(Unit__c chosingUnit, String chosedUnit) 
    {
        if (chosedUnit!='' && chosedUnit!='Select Unit' && chosedUnit!='Not available') 
        {
            for (Unit__c unit: activeUnits) 
            {
                if (unit.Id.equals(chosedUnit)) 
                {
                    chosingUnit = unit;
                }
            }       
        } 
        return chosingUnit;
    }
    //methods below serve for calling the chooseUnit method to attach the proper values to both of our units
    public PageReference chooseFirstUnit() 
    {
        firstUnit = chooseUnit(firstUnit, firstChosedUnit);
        showFirstChosenUnit = true;
        return null;
    }
    
    public PageReference chooseSecondUnit() 
    {
        secondUnit = chooseUnit(secondUnit, secondChosedUnit);
        showSecondChosenUnit = true;
        return null;
    }    
    //this method calls the logic of the game and assings the winner anguser values to the appropriate fields
    public PageReference fight() 
    {
        if (firstUnit != NULL && secondUnit != NULL)
        {
            winner = new Unit__c();
            looser = new Unit__c();
            game = new Game();
            winner = game.fight(firstUnit, secondUnit);
            if (winner == firstUnit)
            {
                winner = firstUnit;
                looser = secondUnit;
                secondUnit = null;
                showSecondChosenUnit = false;
            }
            else
            {
                winner = secondUnit;
                looser = firstUnit;
                firstUnit = null;
                showFirstChosenUnit = false;           
            }
            showResult = true;
            deactivateUnits(winner, looser);
            saveGameResult(winner,  looser);
            getAllUnits();
            getActiveUnits();
        }
        else
        {
             ApexPages.addMessages(new GameException('Unit can\'t be NULL.'));
        }
        
        return null;
    }
    //this one serves for deactivating the loosers and unitsthat have lost all their stamina
    public void deactivateUnits(Unit__c winner, Unit__c looser) 
    {
        if (winner.Stamina__c == 0)
        {
            winner.Active__c = false;
            update winner;
        }
        looser.Active__c = false;
        looser.Deactivation_Time__c = DateTime.now();
        update looser;
    }
    //this method saves the results of the game to the Fight sObject 
    public void saveGameResult(Unit__c winner, Unit__c looser) 
    {
        String gameLogString = '';
        for (String str: game.gameLog) 
        {
            gameLogString = gameLogString + str + '\n';
        }
        Fight__c fight = new Fight__c(Name = winner.Name + ' vs. ' + looser.Name, 
                                      Winner__c = winner.Id, 
                                      Looser__c = looser.Id, 
                                      Date__c = DateTime.now(),
                                      Game_Log__c = gameLogString);
        
        insert fight;
        //increasing the counter of played games and won games
        winner.Number_of_Victories__c ++;
        winner.Number_of_Games__c ++;
        looser.Number_of_Games__c ++;
        update winner;
        update looser;
    }
    //delets the record from the database by taking the id parameter from the VF page
    public PageReference deleteUnit ()
    {
        String unitID = ApexPages.currentPage().getParameters().get('unitID');
        Unit__c unitToDelete =  new Unit__c(ID = unitID);
        delete unitToDelete;
        getAllUnits();
        return null;
    }
    //we need this method to show and hide panel for creating/editing the units when we need to
    public PageReference createEditUnit ()
    {
        newUnit = new Unit__c();
        showCreateEditUnit = true;
        isCreating = true;
        isUpdating = false;
        return null;
    }
    // this one serves for saving new unit to the DB
    public PageReference saveUnit ()
    {
        if(newUnit != NULL)
        {
            if (newUnit.name != '' && newUnit.HP__c > 0 && newUnit.minDMG__c > 0 && newUnit.maxDMG__c > 0 && newUnit.Stamina__c > 0)
            {
                if (newUnit.minDMG__c <= newUnit.maxDMG__c)
                {
                    insert newUnit;
                    newUnit = new Unit__c();
                } 
                else
                {
                    ApexPages.addMessages(new GameException('Minimum Damage cannot be less then Maximum Damage.'));
                }
            } 
            else 
            {
                ApexPages.addMessages(new GameException('Make sure that you have entered the proper values.'));
            }
        }
        else
        {
            ApexPages.addMessages(new GameException('New Unit can\'t be NULL.'));
        }
        
        getAllUnits();
        getActiveUnits();
        return null;
    }
    //provides the editing by taking the id parameter from the VF page
    public PageReference editUnit ()
    {
        String unitID = ApexPages.currentPage().getParameters().get('unitID');
        List <Unit__c> unitsToUpdate = [SELECT Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c 
                                        FROM Unit__c 
                                        WHERE ID = :unitID];
        newUnit = unitsToUpdate[0];
        showCreateEditUnit = true;
        isUpdating = true;
        isCreating = false;
        return null;
    }
    //updating the unit that we've changed 
    public PageReference updateUnit ()
    { 
        if(newUnit != NULL)
        {
            if (newUnit.name != '' && newUnit.HP__c > 0 && newUnit.minDMG__c > 0 && newUnit.maxDMG__c > 0 && newUnit.Stamina__c > 0)
            {
                if (newUnit.minDMG__c <= newUnit.maxDMG__c)
                {
                    update newUnit;
                    newUnit = new Unit__c();
                } 
                else
                {
                    ApexPages.addMessages(new GameException('Minimum Damage cannot be less then Maximum Damage.'));
                }
            } 
            else 
            {
                ApexPages.addMessages(new GameException('Make sure that you have entered the proper values.'));
            }
        }
        else
        {
            ApexPages.addMessages(new GameException('Unit can\'t be NULL.'));
        }

        getAllUnits();
        getActiveUnits();
        return null;
    }
    //if we changed our mind we can cancel the editing ot creation of unit
    public PageReference closeCreationEditing ()
    {
        newUnit = null;
        showCreateEditUnit = false;
        return null;
    }

}