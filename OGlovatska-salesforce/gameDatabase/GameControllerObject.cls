public class GameControllerObject {
      
    public List<UnitWrap> unitWrapList{get;set;}
    public Unit__c first{get;set;}
    public Unit__c second{get;set;}
    public Unit__c winner{get;set;}
    
    public GameObject game{get;set;}
    public List<String> gameLog{get;set;}
    
    /*
     * Constructor for the GameController class
     * It  assign a value to a variables  
     */      
    public GameControllerObject()
    {
        first = new Unit__c();
        second = new Unit__c();

        game = new GameObject();
        gameLog = new List<String>();
	}
    
    /*
     * Method used to fill wrapList with Units. 
     * If Unit's LoosDate__c less than 1 day before today it's not displayed in the choosinglist
     */
    public void selectUnitsFromDataBase()
    {
        unitWrapList = new List<UnitWrap>();
        for(Unit__c units: [SELECT Name, Health__c, MaxDamage__c, MinDamage__c, LoosDate__c, Winn__c, Position_in_top__c FROM Unit__c])
        {
            if((units.LoosDate__c == null) || ((units.LoosDate__c.Date().daysBetween(datetime.now().Date()))>=1))
            {
                unitWrapList.add(new UnitWrap(units, false));
            }
        }
	}
    
    /*
     * Method for coosing first player from Database
     */
    public void chooseFirstPlayer()
    {
        for(UnitWrap item: unitWrapList)
        {
            if(item.isSelected)
            {            
                first = item.player;
            } 
         }
     }
    
    /*
     * Method for coosing second player from Database
     */
    public void chooseSecondPlayer()
    {
        for(UnitWrap item: unitWrapList)
        {
            if(item.isSelected)
            {
                second = item.player;
            } 
        }
    }
    
    /*
     * Method to launch the fight and determine the winner
     */
    public void startGame()
    {     
    	winner = game.fight(first, second);
        gameLog = game.gameLog;
    }
    
    /*
     * Method for saving results of the game. If player was choosen from Database it updates it's fields.
     * If players were inserted by user it inserts them to database. For winner this method increment quantity
     * of winns, for looser it sets value for loos date - today.
     */
    public void savePlayers()
    {
        /*
         * If first player wasn't selected from database it inserts there
         */
        if(first.ID == null)
        {
            insert first;
        }
        /*
         * If first player's name match with winner's name field Winn__c of first player increment by 1
         * If it's not - value of field LoosDate__c set as Date.today() 
         */
        if(first.Name == winner.name)
        {
            if(first.Winn__c == null){
                first.Winn__c = 1;
            } else
            {
                first.Winn__c++;
            }
        } else
        {
            first.LoosDate__c = Date.today();
        }
        update first;
        
        /*
         * If second player wasn't selected from database it inserts there
         */
        if(second.ID == null)
        {
            insert second;
        }
        /*
         * If second player's name match with winner's name field Winn__c of second player increment by 1
         * If it's not - value of field LoosDate__c set as Date.today() 
         */
        if(winner.name == second.Name)
        {
            if(second.Winn__c == null)
            {
                second.Winn__c = 1;
            } else
            {
                second.Winn__c++;
            }
        } else
        {
            second.LoosDate__c = Date.today();
        }
        update second;        
    }
    
    /*
     * Wrapper class. Constructor takes as parameters Unit__c 
     * and boolean value to check if Unit was selected in checkbox
     */
    public class UnitWrap
    {
        public Unit__c player{get;set;}
        public Boolean isSelected{get;set;}  
        
        public UnitWrap(Unit__c player, Boolean isSelected)
        {
            this.player = player;
            this.isSelected = isSelected;
        }
    }
}
