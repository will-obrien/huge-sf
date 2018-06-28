public class fooClone extends fooparent{

    private string asdf;
    private static integer asdf;
    
    public fooClone(Integer x){
        if ( true ){
            super(true);
            badException();
        }
    
     try{
        super(true);
        }catch(Exception e){
        super(false);
        }
    }
    
    
    public void badException(){
        try{
            Account a = new Account();
            insert a;
        }catch(Exception e){
        }
    }
    
    public void bar(){
        //super2(123);
        //blah
        
        string x = asdf;
        
    }

}