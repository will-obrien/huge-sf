public class Hero {
    
    public String Name{set;get;}
    public Integer HP{set;get;}
    public Integer DMGmin{set;get;}
    public Integer DMGmax{set;get;}
    public Integer Accurancy{set;get;}
    public Integer Dexterity{set;get;}
    public String imageURL{set;get;}
    
    public String getName() {return this.name;}
    public Integer getHP() {return this.HP;}
    public void setHP(Integer HP) {this.HP = HP;}
    public Hero(String Name, Integer HP, Integer DMGmin, Integer DMGmax, Integer Accurancy, Integer Dexterity, String ImageURL)
    {
        this.Name = name;
        this.HP = HP;
        this.DMGmin = DMGmin;
        this.DMGmax = DMGmax;
        this.Accurancy = Accurancy;
        this.Dexterity = Dexterity;
        this.imageURL = ImageURL;
    }

    public static List<Integer> fighting(Hero first, Hero second, boolean firsthit, boolean secondhit)
    {	     
        
        Integer Damage1 = Math.round((Math.floor(Math.random() * (first.DMGmax - first.DMGmin + 1) + first.DMGmin)));
        Integer Damage2 = Math.round((Math.floor(Math.random() * (second.DMGmax - second.DMGmin + 1) + second.DMGmin)));
       	Integer Dexterity1 = Math.round((Math.floor(Math.random() * first.Dexterity)));
        Integer Dexterity2 = Math.round((Math.floor(Math.random() * second.Dexterity)));
        Integer Accurancy1 = Math.round((Math.floor(Math.random() * first.Accurancy)));
        Integer Accurancy2 = Math.round((Math.floor(Math.random() * second.Accurancy)));
        
        if (secondhit == true & Accurancy2 > Dexterity1) {first.HP -= Damage2;} else {Damage2 = 0;}
        if (firsthit == true & Accurancy1 > Dexterity2) {second.HP -= Damage1;} else {Damage1 = 0;}      
        List<Integer> damages = new List<Integer>{Damage1, Damage2};
        return damages;
    }
    
    
}