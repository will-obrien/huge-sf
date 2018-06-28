public class GameController 
{
    //-- fields, props and lists scope
    
    //-- This list will contain all description of fighting process
    //-- and finally will be displayed on the VisualForce page
    public List<String> GameFlow {get;set;}
    public Boolean showCreateUnit {get; set;}
    public Boolean showFirstChosenUnit {get; set;}
    public Boolean showSecondChosenUnit {get; set;}
    public Boolean showResult {get; set;}
    public Unit__c firstUnit {get; set;} 
    public Unit__c secondUnit {get; set;}
    public Unit__c newUnit {get; set;}
    public List<Unit__c> activeUnits {get; set;}
    public List<Unit__c> allUnits {get; set;}
    public String firstChosedUnit {get; set;}
    public String secondChosedUnit {get; set;}
    //-- end of fields, props and lists scope
    
    //-- This method will be invoked by VF page. In its turn it calls the method Fight() from the class Game
    public void FightLauncher()
    {
        Game game = new Game();
        game.Fight(firstUnit, secondUnit);
        GameFlow = game.GameFlow;
        showResult = true;
    }
    
    //-- scope of methods used to interact with the page
    public void GameLauncher() 
    {
        newUnit = new Unit__c();
        firstUnit = new Unit__c();
        secondUnit = new Unit__c();
        checkUnitsActivity();
        getActiveUnits();
        getAllUnits();
        checkUnitsActivity();
        showFirstChosenUnit = false;
        showSecondChosenUnit = false;
        showResult = false;
        showCreateUnit = false;
    }
    
    private void getActiveUnits() 
    {
        activeUnits = [SELECT Id, Name, HP__c, DmgMin__c, DmgMax__c, Is_Active__c, Activation_Date__c, 
                       Count_of_wins__c, Amount_of_losses__c, Rating__c, Stamina__c
                       FROM Unit__c WHERE Is_Active__c = true];
    }
    
    private void getAllUnits() 
    {
        allUnits = [SELECT Id, Name, HP__c, DmgMin__c, DmgMax__c, Is_Active__c, Activation_Date__c, 
                           Count_of_wins__c, Amount_of_losses__c, Rating__c, Stamina__c FROM Unit__c];
    }
    
    private void checkUnitsActivity() 
    {
        List<Unit__c> unitsToCheckList = [SELECT Is_Active__c, Activation_Date__c 
                                          FROM Unit__c 
                                          WHERE Is_Active__c = false];
        
        List<Unit__c> unitsToUpdateList = new List<Unit__c>();
        for (Unit__c unit: unitsToCheckList)
        {
            if (unit.Activation_Date__c <= DateTime.now()) 
            {
                unit.Is_Active__c = true;
                unit.Activation_Date__c = NULL;
                unitsToUpdateList.add(unit);
            }
        }
        if (!unitsToUpdateList.isEmpty())
        {
            update unitsToUpdateList;
        }
    }
    
    public void createUnit ()
    {
        showCreateUnit = true;
    }
    public PageReference cancelCreation()
    {
        showCreateUnit = false;
        return null;
    }
    public void saveUnit ()
    {
        if (newUnit.Name != null && newUnit.HP__c > 0 && newUnit.DmgMax__c > 0 && (newUnit.DmgMin__c > 0 && newUnit.DmgMin__c < newUnit.DmgMax__c))
        {
            insert newUnit;
        }
        else 
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Fill the fields with valid data'));
        }
        showCreateUnit = false;
        getAllUnits();
        getActiveUnits();
    }
    
    public void chooseFirstUnit() 
    {
        firstUnit = chooseUnit(firstUnit, firstChosedUnit);
        showFirstChosenUnit = true;
    }
    
    public void chooseSecondUnit() 
    {
        secondUnit = chooseUnit(secondUnit, secondChosedUnit);
        showSecondChosenUnit = true;
    }
    
    private Unit__c chooseUnit(Unit__c chosingUnit, String chosedUnit) 
    {
        if ( !String.isEmpty(chosedUnit) ) 
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
            options.add(new SelectOption(unit.Id, unit.Name));
        }
        
        if (options.size() > 0) 
        {
            options.add(0, new SelectOption('', 'Choose fighter'));
        } else 
        {
            options.add(new SelectOption('', 'Empty'));
        }
        return options;
    }
    
    public void activateAllUnits ()
    {
        List<Unit__c> inActiveUnitsList = [SELECT  Is_Active__c, Activation_Date__c
                                           FROM Unit__c WHERE Is_Active__c = false];
        for (Unit__c unit: inActiveUnitsList) 
        {
            unit.Is_Active__c = true;
            unit.Activation_Date__c = null;
        }
        update inActiveUnitsList;
        getActiveUnits();
        getAllUnits();
        showFirstChosenUnit = false;
        showSecondChosenUnit = false;
    }  
    //-- end of scope of methods used to interact with the page
}