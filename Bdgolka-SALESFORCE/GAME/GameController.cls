/**
 * Class Controller that provides control
 * for all the game process
 * 
 * @author Julia Pulova
**/
public class GameController {
    
    //Wrapper for personages that use could choose from saving in DataBase
    public List<WrapPlayer> players {get;set;}
    
    //An instance of Game_unit object from DataBase
    public Game_Unit__c newPlayer {get;set;}
   
    //An enemy of the users hero that choosen automatically
    public Game_Unit__c enemy {get;set;}
    
    //The Flag controls page block appearance for creating new personage
    public boolean showCreatingPage {get;set;}
    
    //The Flag controls page block appearance for choosing personage
    public boolean showChoosingPage {get;set;}
    
     //The Flag controls battle page block appearance 
    public boolean showBattlePage {get;set;}
    
     //The Flag controls winner page block appearance 
    public boolean showWinner {get;set;}
    
    //Attack will keep a collection of players body parts which could be attacked by enemy 
    public List<String> attack {get;set;}
      
    //Block will keep a collection of players body parts which could be blocked by player 
    public List<String> block {get;set;}
    
    //WinnerMessage shows information about in the end of the game
    public String winnerMessage {get;set;}
        
    //Class Contructor
    public GameController(){
    
		 attack = new List<String>{'head', 'waist', 'hand', 'chest'};
      	 block = new List<String>{'head', 'waist', 'hand', 'chest'};        
        
        /*In the biginning of the game user can see 
        only choosing and creating personage page blocks*/
        showCreatingPage = true;
        showChoosingPage = true;
        showBattlePage = false;
        showWinner = false;
        
        //Variable intialization        
        newPlayer = new Game_Unit__c();
        enemy = new Game_Unit__c();
        players = new List<WrapPlayer>();
            
        for(Game_Unit__c hero :[SELECT name, Death_Date__c FROM Game_Unit__c]){
           WrapPlayer wrPlay = new WrapPlayer();
           wrPlay.unit = hero; 
           wrPlay.isSelected = false;
                 
            //Check whether the personage was killed less than 24 hoursago
            if((hero.Death_Date__c == null)|| ((Decimal.valueOf((datetime.now().getTime() - hero.Death_Date__c.getTime())/(60*60*1000)))>24))
            players.add(wrPlay); 
        }
    }
    
    //The method add to the DataBase intered by user personage
    public void AddNewPersonage(){
       //Checking Data correctness before adding to DataBase
        
        if(newPlayer.name<>'' && newPlayer.HP__c<>0 && newPlayer.Min_damage__c<>0 && newPlayer.Max_damage__c<>0){
        insert newPlayer;
        
        //Hiding CreatingPage and showChoosingPage
        showCreatingPage = false;
        showChoosingPage = false;
        
        //And show BattlePage
        showBattlePage = true;
            
        //Choose Enemy for the battle
        chooseEnemy();    
        }
    }
    
    //The method add to the DataBase intered by user personage
    public void ChoosePersonage(){
     //counter checked if the personage was selected
     integer counter = 0;
        for (WrapPlayer item : players){
            if(item.isSelected){
                newPlayer=[SELECT name, HP__c, Min_damage__c, Max_damage__c, Attack__c, Block__C 
                           FROM Game_unit__c 
                           WHERE name =:item.unit.name 
                           LIMIT 1];
                counter++;
            }
            if (counter>1)
                return;
        }
        
        if(counter<>0){
        //Hiding CreatingPage and showChoosingPage
        showCreatingPage = false;
        showChoosingPage = false;
        //And show BattlePage
        showBattlePage = true;
            
     	//Choose Enemy for the battle
        chooseEnemy();
        }

    }
    
    //Method Choose an enemy for users personage from DataBase
    private void chooseEnemy(){
        List<Game_unit__c> allHeroes = new List<Game_unit__c>([SELECT id, name,HP__c, Min_damage__c, Max_damage__c,Attack__c, Block__C 
                                                               FROM Game_unit__c]);
        
        //Determine quantity of the heroes in the list
        Integer count = allHeroes.size();
        
        //Randomly determined index of the personage in the list
        Integer index = Randomizer(0, count-1);
                      
        do{            
            enemy = allHeroes[index];              
        }while(enemy.name == newPlayer.name);
    }
    
    //Method controlls the Battle prosses
    public void Battle()
    {        
                //User's player attacks and Enemy Blocks
        		if(!(newPlayer.attack__c==block[Randomizer(0,3)]))        		
        			enemy.HP__c -= Randomizer((integer)newPlayer.Min_damage__c, (integer)newPlayer.Max_damage__c);
        
                //Enemy attacks and User's Player Blocks
        		if(!(attack[Randomizer(0,3)]== newPlayer.block__c))        		
        			newPlayer.HP__c -= Randomizer((integer)enemy.Min_damage__c, (integer)enemy.Max_damage__c);
        
        		//We continue to play until the HP of both players is greater than zero
        		if(newPlayer.HP__c<= 0 || enemy.HP__c <=0){
                    
                    //Looser name
                    String looserName = null;
                    
                    //Looser name
                    String winnerName = null;
                    
                    //Determine who is the winner and return appropriete message
                    if (newPlayer.HP__c > 0){
                        looserName = enemy.name; 
                        winnerName = newPlayer.name;
                        winnerMessage = 'Congratulation! You are the winner! Left Health Point is ' + newPlayer.HP__c;
                    }
        		     
                    else if (enemy.HP__c > 0){
                        looserName = newPlayer.name;
                        winnerName = enemy.name;
                        winnerMessage = 'Game over! You loose ! The winner is '+ enemy.name;
                    }
            	        
        	       else
                    winnerMessage = 'No Winners...It was equal Game!';
                    
                    //Assing Date of death to loser
                     Game_Unit__c looser = [SELECT id, name, Death_Date__c
                                           FROM Game_Unit__c 
                                           WHERE name=:looserName 
                                           LIMIT 1]; 
                        looser.Death_date__C = datetime.now();
                        update looser;
                    
                    //Adding Win to Winner
                    Game_Unit__c winner =[SELECT id, name, Death_Date__c, Wins__c
                                          FROM Game_Unit__c 
                                          WHERE name=:winnerName 
                                          LIMIT 1]; 
                    
                    if(winner.Wins__c == null)
                        winner.Wins__c = 1;
                    else
                    winner.Wins__c++;
                    
                    update winner;
                    
                    showWinner = true;
            
        }
    }
    
    //This method returns random number in provided range 
    private integer Randomizer(integer min, integer max)
    {
        return (integer)(Math.floor(Math.random() * (max - min + 1) + min));
    }
    
    /**
     * Wrapper class that provides possibility to choose
     * personage from DataBase
     * */
    public class WrapPlayer{
        public Game_unit__c unit {get;set;}
        //The field indicate whether the personage was chosen
        public boolean isSelected {get;set;}           
    }  
    
}