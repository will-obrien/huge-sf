@SuppressWarnings('Unchecked')
public class foo extends fooparent{

    private string asdf;
    private list<string> viewStateCrap = new list<string>();
    private static integer asdf;
    
    public foo(){
        for ( integer i=0;i<10;i++ )
            viewStateCrap.add('blah'.leftPad(1404800));
    }
    public foo(Integer x){
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
    
    public String getBlah(){
        return '<script>alert("HI");</script>';
    }
    
    public String getLabel(){
        return label.test123;
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
        
        
        list<string> l = new string[1];
        string[] a = new list<string>();
        
    }

}