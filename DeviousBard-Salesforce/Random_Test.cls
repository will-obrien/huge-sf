@isTest
class Random_Test {
    
    // Test the Random.nextUniform() method
    @isTest
    static void test_nextUniform() {
        Test.startTest();
        Random rng = new Random();
        for (Integer i = 0; i < 1000; i++) {
            Double randomNum = rng.nextUniform();
            System.assert(randomNum >= 0.0D && randomNum < 1.0D);
        }
        Test.stopTest();
    }
    
    // Test the Random.nextBoolean() method
    @isTest
    static void test_nextBoolean() {
        Test.startTest();
        Random rng = new Random();
        Set<Boolean> booleanSet = new Set<Boolean>();
        for (Integer i = 0; i < 100; i++) {
            booleanSet.add(rng.nextBoolean());
        }
        System.assert(booleanSet.size() == 2);
        Test.stopTest();
    }
    
    // Test the Random.nextInteger(Integer upperLimit) method
    @isTest
    static void test_nextInteger() {
        Test.startTest();
        Random rng = new Random();
        Integer upperLimit = 5;
        for (Integer i = 0; i < 1000; i++) {
            Integer randomNum = rng.nextInteger(upperLimit);
            System.assert(randomNum >= 0 && randomNum < upperLimit);
        }
        Test.stopTest();
    }
    
    // Test the Random.nextIntegerInRange(Integer lowerLimit, Integer upperLimit) method
    @isTest
    static void test_nextIntegerInRange() {
        Test.startTest();
        Random rng = new Random();
        Integer lowerLimit = -5;
        Integer upperLimit = 5;
        for (Integer i = 0; i < 1000; i++) {
            Integer randomNum = rng.nextIntegerInRange(lowerLimit, upperLimit);
            System.assert(randomNum >= lowerLimit && randomNum <= upperLimit);
        }
        Test.stopTest();
    }

    // Test the Random.nextLong(Long upperLimit) method
    @isTest
    static void test_nextLong() {
        Test.startTest();
        Random rng = new Random();
        Integer upperLimit = 5;
        for (Integer i = 0; i < 1000; i++) {
            Long randomNum = rng.nextLong(upperLimit);
            System.assert(randomNum >= 0 && randomNum < upperLimit);
        }
        Test.stopTest();
    }
    
    // Test the Random.nextLongInRange(Long lowerLimit, Long upperLimit) method
    @isTest
    static void test_nextLongInRange() {
        Test.startTest();
        Random rng = new Random();
        Long lowerLimit = -5;
        Long upperLimit = 5;
        for (Integer i = 0; i < 1000; i++) {
            Long randomNum = rng.nextLongInRange(lowerLimit, upperLimit);
            System.assert(randomNum >= lowerLimit && randomNum <= upperLimit);
        }
        Test.stopTest();
    }

    // Test the Random.nextDouble(Double upperLimit) method
    @isTest
    static void test_nextDouble() {
        Test.startTest();
        Random rng = new Random();
        Double upperLimit = 2.71828;
        for (Integer i = 0; i < 1000; i++) {
            Double randomNum = rng.nextDouble(upperLimit);
            System.assert(randomNum >= 0 && randomNum < upperLimit);
        }
        Test.stopTest();
    }
    
    // Test the Random.nextDoubleInRange(Double lowerLimit, Double upperLimit) method
    @isTest
    static void test_nextDoubleInRange() {
        Test.startTest();
        Random rng = new Random();
        Double lowerLimit = -3.14159265;
        Double upperLimit = 3.14159265;
        for (Integer i = 0; i < 1000; i++) {
            Double randomNum = rng.nextDoubleInRange(lowerLimit, upperLimit);
            System.assert(randomNum >= lowerLimit && randomNum <= upperLimit);
        }
        Test.stopTest();
    }
    
    // Test the Random.shuffle(List<Object> objectList) method
    @isTest
    static void test_shuffle() {
        Test.startTest();
        Random rng = new Random();
        List<Integer> integerList = new List<Integer>();
        for (Integer i = 0; i < 1000; i++) {
            integerList.add(i);
        }
        rng.shuffle(integerList);
        // To see if they're shuffled, check 5 positions in the array to ensure that at least one of them is different from its starting value.
        // NOTE: It is possible, although highly-improbable, that over the entire array of 1000 numbers all 5 of those positions remain unchanged 
        // during the shuffle process.  So, this is not a COMPLETELY valid test.
        System.assert(integerList[0] != 0 || integerList[250] != 250 || integerList[500] != 500 || integerList[750] != 750 || integerList[999] != 999);
        
        // The list was shuffled correctly. Now we need to ensure that ALL of the objects are in the list (i.e. there are no duplicates)
        // By adding all of the objects from the list to a set, the duplicates will be removed.  So, we can test that all of the
        // objects were included in the shuffled list by asserting that the Set size equals the original list size.
        Set<Integer> integerSet = new Set<Integer>(integerList);
        System.assert(integerSet.size() == integerList.size());
        Test.stopTest();
    }

    // Test the Random.shuffleWithCopy(List<Object> objectList) method
    @isTest
    static void test_shuffleWithCopy() {
        Test.startTest();
        Random rng = new Random();
        List<Integer> integerList = new List<Integer>();
        for (Integer i = 0; i < 1000; i++) {
            integerList.add(i);
        }
        
        List<Object> shuffledIntegerList = rng.shuffleWithCopy(integerList);
        
        // Ensure that the original list order was preserved
        System.assert(integerList[0] == 0 || integerList[250] == 250 || integerList[500] == 500 || integerList[750] == 750 || integerList[999] == 999);
        
        // To see if they're shuffled, check 5 positions in the array to ensure that at least one of them is different from its starting value.
        // NOTE: It is possible, though highly-improbable, that over the entire array of 1000 numbers all 5 of those positions remain unchanged 
        // during the shuffle process.  So, this is not a COMPLETELY valid test.
        System.assert(shuffledIntegerList[0] != 0 || shuffledIntegerList[250] != 250 || shuffledIntegerList[500] != 500 || shuffledIntegerList[750] != 750 || shuffledIntegerList[999] != 999);
        
        // The list was shuffled correctly. Now we need to ensure that ALL of the objects are in the list (i.e. there are no duplicates)
        // By adding all of the objects from the list to a set, the duplicates will be removed.  So, we can test that all of the
        // objects were included in the shuffled list by asserting that the Set size equals the original list size.
        Set<Object> integerSet = new Set<Object>(shuffledIntegerList);
        System.assert(integerSet.size() == shuffledIntegerList.size());
        Test.stopTest();
    }

    // Test that the List of Objects returned from the Random.shuffleWithCopy(List<Object> objectList) method are able to cast to their original type.
    @isTest
    static void test_shuffleWithCopy_ObjectsCanBeCast() {
        Test.startTest();
        Random rng = new Random();
        List<Integer> integerList = new List<Integer>();
        for (Integer i = 0; i < 10; i++) {
            integerList.add(i);
        }
        
        List<Object> shuffledIntegerList = rng.shuffleWithCopy(integerList);
        for (Object obj : shuffledIntegerList) {
            System.assert(obj instanceOf Integer);
        }
        Test.stopTest();
    }
    
    // Test that different seeds produce different random results
    @isTest
    static void test_differentResults() {
        Test.startTest();
        Random rng1 = new Random(1234567);
        List<Integer> intList1 = new List<Integer>();
        for (Integer i = 0; i < 5; i++) {
            intList1.add(rng1.nextInteger(1000000));
        }
        Random rng2 = new Random(7654321);
        List<Integer> intList2 = new List<Integer>();
        for (Integer i = 0; i < 5; i++) {
            intList2.add(rng2.nextInteger(1000000));
        }
        Boolean different = false;
        for (Integer i = 0; i < 5; i++) {
            if (intList1[i] != intList2[i]) {
                different = true;
                break;
            }
        }
        System.assert(different);
        Test.stopTest();
    }

    // Test that the same seed produces a random repeatable set of results
    @isTest
    static void test_sameResults() {
        Test.startTest();
        Random rng1 = new Random(1234567);
        List<Integer> intList1 = new List<Integer>();
        for (Integer i = 0; i < 5; i++) {
            intList1.add(rng1.nextInteger(1000000));
        }
        Random rng2 = new Random(1234567);
        List<Integer> intList2 = new List<Integer>();
        for (Integer i = 0; i < 5; i++) {
            intList2.add(rng2.nextInteger(1000000));
        }
        Boolean same = true;
        for (Integer i = 0; i < 5; i++) {
            if (intList1[i] != intList2[i]) {
               same = false;
               break;
            }
        }
        System.assert(same);
        Test.stopTest();
    }
    
    // Test the random distribution of the numbers generated by simulating a die roll 100,000 times.
    @isTest
    static void test_distributionOfRandomNumbers() {
        Test.startTest();
        Random rng = new Random();
        List<Integer> rollCounts = new List<Integer> {0,0,0,0,0,0};
        for (Integer i = 0; i < 100000; i++) {
            rollCounts[rng.nextInteger(6)]++;
        }
        for (Integer i = 0; i < 6; i++) {
            // Ensure that the distibution of the rolls is within 2% of the actual probability (which should be 16.67%) 
            Double marginOfError = (Double)rollCounts[i]/16666.67D;
            System.assert(marginOfError >= 0.98 && marginOfError <= 1.02);
        }
        Test.stopTest();
    }
}
