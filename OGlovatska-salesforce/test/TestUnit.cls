@isTest
public class TestUnit 
{

    @isTest
    private static void testUnit()
    {
    	/*
    	 * Create Unit using constructor with parameters
    	 */
        Unit orc = new Unit('Orc', 100, 50, 30);
        
        /*
    	 * Create Unit using constructor without parameters 
    	 * and set fields values' usinr setters
    	 */
        Unit elf = new Unit();
        elf.name = 'Elf';
        elf.health = 100;
        elf.maxDamage = 70;
        elf.minDamage = 40;
        
        /*
         * Call method averageDamage() on created Units 
         */      
        System.debug(orc.averageDamage());
        System.debug(elf.averageDamage());
        
        /*
         * Call methods attack() and  deffence() in loop to get 
         * different values of attacked and deffenced bodyparts  
         */ 
        for(Integer i = 0; i <= 500; i++)
        {
        	orc.attack();
        	elf.deffence();
        
        	elf.attack();
        	orc.deffence();
        }
        
        /*
         * Set healt more and less than 0. If it less than 0 method sets 0 ass health value
         * because health can't have negative value
         */
        orc.setHealth(-5);
        elf.setHealth(50);
    }
}