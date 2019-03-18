public class BatchTest {
    public static void testBatch(){
        insert new Account[]{new Account(Name = 'for loop 11'), 
                     new Account(Name = 'for loop 21'), 
                     new Account(Name = 'for loop 31')};

    // The sObject list format executes the for loop once per returned batch
    // of records
    Integer i=0;
    Integer j=0;
    for (Account[] tmp : [SELECT Id FROM Account WHERE Name LIKE 'for loop _']) {
        j = tmp.size();
        i++;
    }
        
        System.debug('i:'+i);
           System.debug('j:'+j);
    System.assertEquals(3, j); // The list should have contained the three accounts
                           // named 'yyy'
    System.assertEquals(1, i); // Since a single batch can hold up to 200 records and,
                           // only three records should have been returned, the 
                           // loop should have executed only once

        }

}