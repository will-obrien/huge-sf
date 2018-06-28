@IsTest
public class footest {

    @IsTest public static void fooTest2(){
    
            for (integer x = 1; x == (2 | 3);true) { // Noncompliant 
            }
            for (;; 2 | 3) { // Noncompliant 
            }
            system.assert(false, 'false test');
    }
    
    public static testmethod void fooTest(){
            foo x = new foo();
            system.assertEquals(123, x.a);
    }
}