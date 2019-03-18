public class Fridge {
 private String model;
 private integer stock;
     public static integer threshold=5; 

    public void setmodel(String mdl){
        model=mdl;
    }
    public String getmodel(){
        return model;
    }
    public void setstock(Integer stk){
        stock=stk;
    }
    public integer getstock(){
        return stock;
    }
     public fridge(String mdl, Integer stk){
        model=mdl;
        stock=stk;
    }
       public void updatestock(integer sold){
        stock=stock-sold;
    }
    public static void main(fridge aFridge){
     system.debug('Model: '+ aFridge.model);
     system.debug('Stock: '+ aFridge.stock);
     aFridge.updatestock(17);
     system.debug('New Stock: '+ aFridge.stock);
     system.debug(Fridge.threshold);
    }
}