@IsTest
public class footest {
    private static void fooTest3Stack(){
                    system.assert(false, 'false test');
	}
    @IsTest public static void fooTest3(){
        fooTest3Stack();
    }
    @IsTest public static void fooTest2(){
    
            for (integer x = 1; x == (2 | 3);true) { // Noncompliant 
            }
            for (;; 2 | 3) { // Noncompliant 
            }
            system.assert(false, 'false test');
            
            
            account a = new account(name= 'rere');
            insert ((a));
            
    }
    
    public static testmethod void fooTest(){
            foo x = new foo();
            system.assertEquals(123, x.a);
    }
}