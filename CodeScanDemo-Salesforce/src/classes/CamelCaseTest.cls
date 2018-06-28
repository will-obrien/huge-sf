public class CamelCaseTest {  //all wrong
    
    private integer NOT_CONSTANT = 2;
    
    private final integer snake_constant = 3;
    
    public void camelCaseTest(){
        NOT_CONSTANT++;
    }
    
    private void UPPERCASE(){
        //method empty on purpose
        NOT_CONSTANT++;
    }
    
    private void lowercasemethod(){
        //method empty on purpose
        NOT_CONSTANT += snake_constant;
    }
    
    private void snake_case(){
        //method empty on purpose
    }
    
    public void BadCase(){
       UPPERCASE();
    
    	lowercasemethod();
    
   	 	snake_case(); 
    }
    
    
    
 
    
	
}