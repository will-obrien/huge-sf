/**
 * GameController is a controller of VF page TheGame . 
 * Before using this class need to create castom object as follow:
 * API Name: Unit__c 
 * Custom Fields:
 * 1. API Name: Hp__c, Data Type: Number
 * 2. API Name: Min_Damage__c, Data Type: Number
 * 3. API Name: Max_Damage__c, Data Type: Number
 * 4. API Name: Last_Loss_Date__c Data Type: Date
 * If game was lost, you can't use record during 1 day
 * You can delete any record any time using button delete
 * 
 * @author  Adel Hammoudi
 * @version 1.0, June 2016
 */
public class GameController 
{
    public Unit__c unit {get;set;}
    public List<GameWrapper> unit1List {get;set;}
    public List<GameWrapper> unit2List {get;set;}   
    public List<String> gameDescriptionList {get;set;}
    public String gameType {get;set;}
    public String kickType {get; set;}
    public String blockType {get; set;}
    public boolean mainMenu {get;set;}
    public boolean newGame {get;set;}
    public boolean newPlayer {get;set;}
    public boolean deletePlayers {get;set;}
    public boolean gameDescription {get;set;}
    public boolean playerVsComputer {get;set;}

    private List<Unit__c> selectedUnitList;
    private Unit unit1;
    private Unit unit2;

    private Game game;
    
    public GameController()
    {
        unit = new Unit__c();
        mainMenu = true;
    }

    /**
    * This is the method which select records from database and create wrapper class objects
    * @see GameController#GameWrapper
    * @return List<GameWrapper>.
    */
   
    private List<GameWrapper> getData()
    {
        List<GameWrapper> unitList = new List<GameWrapper>();
        List<Unit__c> unitListTemp = new List<Unit__c>([SELECT Name, Hp__c, Min_Damage__c, Max_Damage__c, 
                                Last_Loss_Date__C, Win__c, Loss__c, Position__c FROM Unit__c ORDER BY Name]);
        for(Unit__c unitTemp : unitListTemp)
        {
            unitList.add(new GameWrapper(unitTemp, false));
        }
        return unitList;
    }

    /**
    * This is the wrapper class for display records as follow:
    * If record's last loss date is less than 1 day you can't select this record but 
    * you can delete it by using delete button
    * @see GameController#getData()
    */
    public class GameWrapper
    {
        public Unit__c unit {get; set;}
        public boolean isSelected {get; set;}
        public boolean isDisabled {get; set;}
        
        public GameWrapper(Unit__c unit, boolean isSelected) 
        {
            Date today = Date.today();
            if(unit.Last_Loss_Date__c != null && unit.Last_Loss_Date__c.daysBetween(today) <= 1)
            {
                isDisabled = true;
            }
           
            this.unit = unit;
            this.isSelected = isSelected;
        } 
    }


    /**
    * This is the method which start game if selected 2 records.Else will display error mesage
    * @see Game
    * @return Null
    */
    public PageReference gameStart()
    {
        newGame = false;
        selectedUnitList = new List<Unit__c>();
        for(GameWrapper selectedUnit : unit1List)
        {
            if(selectedUnit.isSelected)
                {  
                    selectedUnitList.add(selectedUnit.unit);  
                } 
        }
        if(selectedUnitList.size() != 1)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                        'Please select 1 player from each side!'));
            newGame = true;
            return null;
        }
        for(GameWrapper selectedUnit : unit2List)
        {
            if(selectedUnit.isSelected)
                {  
                    selectedUnitList.add(selectedUnit.unit);  
                } 
        }
        if(selectedUnitList.size() != 2)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                        'Please select 1 player from each side!'));
            newGame = true;
            return null;
        }
        else
            if(selectedUnitList.get(0).id == selectedUnitList.get(1).id)
            {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                            'Please select 2 different players!')); 
               newGame = true;
               return null;
            }
        unit1 = new Unit(selectedUnitList.get(0));
        unit2 = new Unit(selectedUnitList.get(1));
        if(gameType == 'Computer vs Computer')
        {   
            game = new Game();
            while(game.getWinner() == null)
            {
                game.fight(unit1, unit2);
            }
            if(game.getWinner() == unit1)
            {
                //selectedUnitList.get(1).Last_Loss_Date__c = Date.today();
                selectedUnitList.get(1).Loss__c += 1;
                selectedUnitList.get(0).Win__c += 1;
            }
            else
            {
                //selectedUnitList.get(0).Last_Loss_Date__c = Date.today();
                selectedUnitList.get(0).Loss__c += 1;
                selectedUnitList.get(1).Win__c += 1;
            }
            update selectedUnitList;
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,
                                                            game.getWinner().getName() + ' win!!!')); 
            selectedUnitList = new List<Unit__c>();
            unit1List = getData();
            unit2List = getData();
            gameDescriptionList = game.getGameDescriptionList();
            gameDescription = true;
        }
        else
            if(gameType == 'Player vs Computer')
            {   
                game = new Game();
                playerVsComputer = true;
            }
        return null;
    }

    public PageReference kick()
    {
        if(kickType == null || blockType == null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                            'Please select type of block or type of kick!')); 
            return null;
        }
        else
        {
            if(kickType == 'HEAD')
            {
                unit1.setKickType(KickBlockTypes.HEAD);
            }
            else
                if(kickType == 'CHEST')
                {
                    unit1.setKickType(KickBlockTypes.CHEST);
                }
                else
                    if(kickType == 'ARMS')
                    {
                        unit1.setKickType(KickBlockTypes.ARMS);
                    }
                    else
                        if(kickType == 'LEGS')
                        {
                            unit1.setKickType(KickBlockTypes.LEGS);
                        }
            if(blockType == 'HEAD')
            {
                unit1.setBlockType(KickBlockTypes.HEAD);
            }
            else
                if(blockType == 'CHEST')
                {
                    unit1.setBlockType(KickBlockTypes.CHEST);
                }
                else
                    if(blockType == 'ARMS')
                    {
                        unit1.setBlockType(KickBlockTypes.ARMS);
                    }
                    else
                        if(blockType == 'LEGS')
                        {
                            unit1.setBlockType(KickBlockTypes.LEGS);
                        }
        }
        
        game.fight(unit1, unit2);
        gameDescriptionList = game.getGameDescriptionList();
        gameDescription = true;
        kickType = null;
        blockType = null;
        
        if(game.getWinner() != null)
        {
            if(game.getWinner() == unit1)
            {
                selectedUnitList.get(1).Last_Loss_Date__c = Date.today();
                selectedUnitList.get(1).Loss__c++;
                selectedUnitList.get(0).Win__c++;

                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,
                                                            'You win!!!')); 
            }
            else
            {
                selectedUnitList.get(0).Last_Loss_Date__c = Date.today();
                selectedUnitList.get(0).Loss__c++;
                selectedUnitList.get(1).Win__c++;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,
                                                            'You lose!!!')); 
            }
            update selectedUnitList;
            selectedUnitList = new List<Unit__c>();
            playerVsComputer = false;
            gameType = null;
            unit1List = getData();
            unit2List = getData();
        }
        return null;
    }

    /**
     * Retrieve all existing records of Unit__c
     * @return List<Unit__c>
     */
    public List<Unit__c> getExistingUnitsList()
    {
        List<Unit__c> existingUnitsList = new List<Unit__c>([SELECT Name, Hp__c, Min_Damage__c, Max_Damage__c, 
                                                            Last_Loss_Date__C, Win__c, Loss__c, Position__c 
                                                            FROM Unit__c ORDER BY Position__c]);
        return existingUnitsList;
    }

    public List<SelectOption> getGameTypes() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Computer vs Computer','Computer vs Computer'));
        options.add(new SelectOption('Player vs Computer','Player vs Computer'));
        options.add(new SelectOption('Player vs Player','Player vs Player'));
        return options;
    }

    public List<SelectOption> getKickBlockTypes() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('HEAD','HEAD'));
        options.add(new SelectOption('CHEST','CHEST'));
        options.add(new SelectOption('ARMS','ARMS'));
        options.add(new SelectOption('LEGS','LEGS'));
        return options;
    }


    /**
    * This is the method which enabled panel for adding new player.
    * @return null.
    */
    public PageReference addPlayer()
    {
        unit = new Unit__c();
        newGame = false;
        deletePlayers = false;
        gameDescription = false;
        newPlayer = true;
        return null;
    }

    /**
    * This is the method which enabled panel for deleting players.
    * @return null.
    */
    public PageReference deletePlayers()
    {
        unit1List = getData();
        newGame = false;
        deletePlayers = true;
        newPlayer = false;
        gameDescription = false;
        return null;
    }


    /**
     * Rerendered new game panel
     * @return null
     */
    public PageReference newGame()
    {
        unit1List = getData();
        unit2List = getData();
        mainMenu = false;
        newGame = true;
        newPlayer = false;
        deletePlayers = false;
        gameDescription = false;
        playerVsComputer = false;
        gameType = null;
        kickType = null;
        blockType = null;

        return null;
    }

    /**
    * This is the method which add a new record.
    * Input values must be according to bellow:
    * Name not blank
    * Hp > 0
    * Min Damage > 0
    * Max Damage > 0
    * Input values will be checked and in case if will be found discrepancy
    * with above mentioned criterias , error message wil display on VF page
    * @return Null
    */
    public PageReference addNewPlayer()
    {
        if(unit.name != null)
        {
            if(unit.hp__c > 0)
            {
                if(unit.Min_Damage__c >= 0)
                {
                    if(unit.Max_Damage__c >= unit.Min_Damage__c)
                    {
                        unit.Win__c = 0;
                        unit.Loss__c = 0;
                        insert unit; 
                        unit = new Unit__c();
                        newGame = false;
                        newPlayer = false;
                        gameDescription = false; 
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                            'Max Damage must be more than Min Damage!'));
                    }
                    
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                            'Min Damage must be more than 0!'));
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                            'Player Hp must be more than 0!'));
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                        'Please enter player name!'));
        }
        return null;
    }

    /**
    * This is the method which delete selected records.
    * Input values must be according to bellow:
    * @return Null
    */
    public PageReference deleteSelectedPlayers()
    {
        selectedUnitList = new List<Unit__c>();
        for(GameWrapper wrap : unit1List)
        {
            if(wrap.isSelected)
                {  
                    selectedUnitList.add(wrap.unit);  
                }  
        }
        delete selectedUnitList;
        unit1List = getData();
        newGame = false;
        newPlayer = false;
        deletePlayers = false;
        gameDescription = false;
        return null;
    }

    /**
    * This is the method which close delete/add_new_record panels and display record's panel.
    * @return Null
    */
    public PageReference cancel()
    {
        unit = new Unit__c();
        newGame = false;
        newPlayer = false;
        deletePlayers = false;
        gameDescription = false;
        return null;
    }


    /**
     * Rerendered Main menu panel
     * @return null
     */
    public PageReference mainMenu()
    {
        mainMenu = true;
        newGame = false;
        gameDescription = false;
        playerVsComputer = false;
        return null;
    }
    
}