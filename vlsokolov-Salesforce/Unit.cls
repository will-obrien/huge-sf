public class Unit {
    String hitPlace = null;
    String blockPlace = null;
    Integer roundNumber = 1;
    String firstName = null;
    String secondName = null;
	String firstimage = null;
    String secondimage = null;
    String out = '';
  	
    
    //Creating new Units    
    Hero Human = new Hero('Boromir', 700, 50, 40, 60, 40, 'https://s-media-cache-ak0.pinimg.com/236x/5a/5e/5a/5a5e5af1f3117407341623601720b513.jpg');
    Hero Ork = new Hero('Wu Tang', 1000, 100, 30, 40, 20, 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQpT_5jzxE-rFVs5yU23UO9Pki6UZ_lIoSUdyzmVj5qd_FFuEtvfA');
    Hero Dwarf = new Hero('Dwalin', 800, 80, 40, 50, 30, 'http://pre14.deviantart.net/b30c/th/pre/f/2013/146/a/a/dwarven_paladin___algadon_by_seraph777-d66p38y.jpg');
	Hero Elven = new Hero('Legolas', 500, 60, 50, 70, 45, 'https://s-media-cache-ak0.pinimg.com/736x/3c/0e/a5/3c0ea5bd7e1ecb183fd6c79b92628713.jpg');        
    List<Hero> heroes = new List<Hero>{Human, Ork, Dwarf, Elven};   
            
    public List<Integer> randomFighters()
    {
        List<Integer> numbers = new List<Integer>();
        Integer randomFirstFighter = Math.round(Math.floor(Math.random()*3.5));        
        Integer randomSecondFighter = Math.round(Math.floor(Math.random()*3.5));
        if (randomFirstFighter == randomSecondFighter) 
        {
           while (randomFirstFighter == randomSecondFighter)
           {
               randomSecondFighter = Math.round(Math.floor(Math.random()*3.5));
           }
        } 
        numbers.add(randomSecondFighter);
        numbers.add(randomFirstFighter);
        return numbers;
    }
    
    List<Integer> numbers = randomfighters();
	Hero first = heroes.get(numbers.get(1));
    Hero second = heroes.get(numbers.get(0));     
    
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Head','Head')); 
        options.add(new SelectOption('UpperBody','UpperBody')); 
        options.add(new SelectOption('LowerBody','LowerBody'));
        options.add(new SelectOption('Legs','Legs'));
        return options; 
    }          
    
    public String getHitPlace() {return hitPlace;}                    
    public void setHitPlace(String hitPlace) { this.hitPlace = hitPlace; }
    
    public String getBlockPlace() {return BlockPlace;}                    
    public void setBlockPlace(String BlockPlace) { this.blockPlace = BlockPlace; }
    
    public Integer getRoundNumber()  {return roundNumber;}  
    public void setRoundNumber(Integer roundNumber) {this.roundNumber = roundNumber;}
    
  	public String getFirstName() {return first.Name;}
    public String getSecondName() {return second.Name;}
    public Integer getFirstHP() {return first.HP;}
    public Integer getSecondHP() {return second.HP;}
    public String getFirstImage() {return first.imageURL;}
    public String getSecondImage() {return second.imageURL;}
    public String getOut() {return out;}
    
    
    public PageReference test() {
        
        if (first.getHP() > 0 & second.getHP() > 0){
        Integer hitPlacePC = Math.round((Math.floor(Math.random() * 3.5)));
        Integer blockPlacePC = Math.round((Math.floor(Math.random() * 3.5)));
        SelectOption placePCHit = getItems().get(hitPlacePC);
        SelectOption placePCblock = getItems().get(blockPlacePC);
               
        if (hitPlace != placePCBlock.getValue() & blockPlace != placePCHit.getValue())
        {
        List<Integer> damages = hero.fighting(first,second, true, true);
            if (damages.get(0) != 0 & damages.get(1) != 0)
            {
              out = 'Round ' + getRoundNumber() + ' - ' + first.getName() + ' hit ' + second.getName() + ' in the '+
              hitPlace + '\n' + second.getName() + ' hit ' + first.getName() + ' in the ' +  placePCHit.getValue() + '\n';
            } else if (damages.get(0) != 0 & damages.get(1) == 0)
            {
              out = 'Round ' + getRoundNumber() + ' - ' + first.getName() + ' hit ' + second.getName() + ' in the ' +
              hitPlace + '\n' + second.getName() + ' missed'+ '\n';
            } else if (damages.get(0) == 0 & damages.get(1) != 0)
            {
                out = 'Round ' + getRoundNumber() + ' - ' + first.getName() + ' missed ' + '\n' + 
                second.getName() + ' hit ' + first.getName() + ' in the ' +  placePCHit.getValue() + '\n';
            } else {out = 'Round ' + getRoundNumber() + ' - ' + first.getName() + ' missed '+
              '\n' + second.getName() + ' missed ' + '\n';}
        } else {
            if (hitPlace == placePCBlock.getValue() & blockPlace != placePCHit.getValue())
            {
              List<Integer> damages = hero.fighting(first,second, false, true);
                if (damages.get(1) !=0)
                {
              		out = 'Round ' + getRoundNumber() + ' - the hit from ' + first.getName() + ' was blocked' +
            		'\n' + second.getName() + ' hit ' + first.getName() + ' in the ' +  placePCHit.getValue() + '\n';
            	} else 
                {
                    out = 'Round ' + getRoundNumber() + ' - the hit from ' + first.getName() + ' was blocked' +
            		'\n' + second.getName() + ' missed' + '\n';}
                }
            else
            {
                List<Integer> damages = hero.fighting(first,second, true, false);
                if (damages.get(0) != 0)
                {
                out = 'Round ' + getRoundNumber() + ' - ' + first.getName() + ' hit ' + second.getName() + ' in the ' 
                + hitPlace + '\n' + ' the hit from ' + second.getName() + ' was blocked' + '\n';
                } else {
                 out = 'Round ' + getRoundNumber() + ' - ' + first.getName() + ' missed ' + '\n' + ' the hit from '
                 + second.getName() + ' was blocked' + '\n';   
                }
            }
        }
     
        if (first.getHP() <= 0 & second.getHP() >= 0)
        {
            out = second.getName() + ' Win!'; 
            first.setHP(0);            
        } else {
            if (first.getHP() >= 0 & second.getHP() <= 0)
            {
                out = first.getName() + ' Win!';
				second.setHP(0);   
                
            } else {
                if (first.getHP() <= 0 & second.getHP() <= 0)
                {
                    out = 'Both heroes are death, nobody win)'; 
                    first.setHP(0);
                    second.setHP(0);                   
                }
            }
        }
        }
        roundNumber++;
        return null;    
        
    }
}