public class StringArrayTest {
    
//    Public StringArrayTest(){}   
    
	public static list<string> generateStringArray(integer testno)
    {
        List<String> stringval;
          if (testno!=Null) {
              for (integer i=1;i<testno;i++) {
                      system.debug('Test No'+ i);
					  stringval.add('Test No'+ i) ;                 
            }
      	    
        }
       return stringval; 
    }
}