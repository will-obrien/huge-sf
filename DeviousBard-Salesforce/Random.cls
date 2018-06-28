/**
 * @description
 *   This class encapsulates a random number generation algorithm, and convenience
 *   methods for performing various random operations.  The class can be instantiated
 *   with a seed generated using the system time, or a seed may be supplied by the 
 *   client to allow for repeatable results by using the same seed.
 *   
 *   This class borrows extensively from the following sources:
 *      Java's Random class - Random.java: http://developer.classpath.org/doc/java/util/Random-source.html
 *      Java's Collections class - Collections.java: http://developer.classpath.org/doc/java/util/Collections-source.html
 *      Article - "Simple Random Number Generation": http://www.codeproject.com/Articles/25172/Simple-Random-Number-Generation
 */
public class Random {

    private long seed;

    /** 
     * @description
     *   Construct a new Random object using the system time as a seed
     */
    public Random() {
        setSeedFromSystemTime();
    }
    
    /** 
     * @description
     *   Construct a new Random object using the specified seed.  Using
     *   the same seed value will produce consistent random numbers every
     *   time. 
     * @param
     *   seed - a long representing the seed to use
     */
    public Random(Long seed) {
        setSeed(seed);
    }

    /**
     * @description 
     *   Return a random Boolean value of true or false.
     * @return
     *   A randomly selected Boolean value (true or false)
     */
    public Boolean nextBoolean() {
        return (getUniformRandomNumber() < 0.5);
    }
    
    /**
     * @description 
     *   Return a random Integer in the range zero (0) to the specified limit minus one (1).
     *   So a limit of 100 would return an Integer between 0 and 99 inclusive.
     * @param
     *   upperLimit - an Integer representing the upper limit of integers from which to select.
     * @return
     *   An Integer between zero (0) and the upper limit minus one (1) inclusive.
     */
    public Integer nextInteger(Integer upperLimit) {
        return (getUniformRandomNumber() * upperLimit).intValue();
    }
    
    /**
     * @description 
     *   Return a random Integer in the range of the specified lower limit to the specified 
     *   upper limit inclusive of both limits.
     *   So a lower and upper limit of one (1) and one hundred (100) would return an Integer between
     *   one (1) and one hundred (100) inclusive.
     * @param
     *   lowerLimit - an Integer representing the lower limit of integers from which to select.
     *   upperLimit - an Integer representing the upper limit of integers from which to select.
     * @return
     *   An Integer between the lower limit and the upper limit inclusive.
     */
    public Integer nextIntegerInRange(Integer lowerLimit, Integer upperLimit) {
        return ((getUniformRandomNumber() * (upperLimit + 1)) + lowerLimit).intValue();
    }
    
    /**
     * @description 
     *   Return a random Long in the range zero (0) to the specified limit minus one (1).
     *   So a limit of 100 would return a Long between 0 and 99 inclusive.
     * @param
     *   upperLimit - a Long representing the upper limit of Longs from which to select.
     * @return
     *   A Long between zero (0) and the upper limit minus one (1) inclusive.
     */
    public Long nextLong(Long upperLimit) {
        return (getUniformRandomNumber() * upperLimit).longValue();
    }
    
    /**
     * @description 
     *   Return a random Long in the range of the specified lower limit to the specified 
     *   upper limit inclusive of both limits.
     *   So a lower and upper limit of one (1) and one hundred (100) would return a Long between
     *   one (1) and one hundred (100) inclusive.
     * @param
     *   lowerLimit - a Long representing the lower limit of Longs from which to select.
     *   upperLimit - a Long representing the upper limit of Longs from which to select.
     * @return
     *   A Long between the lower limit and the upper limit inclusive.
     */
    public Long nextLongInRange(Long lowerLimit, Long upperLimit) {
        return ((getUniformRandomNumber() * (upperLimit + 1)) + lowerLimit).longValue();
    }
    
    /**
     * @description 
     *   Return a random Double in the range zero (0) to the specified limit minus one (1).
     *   So a limit of 100.543 would return a Double between 0.0 and 99.543 inclusive.
     * @param
     *   upperLimit - a Double representing the upper limit of Doubles from which to select.
     * @return
     *   A Double between zero (0) and the upper limit minus one (1) inclusive.
     */
    public Double nextDouble(Double upperLimit) {
        return getUniformRandomNumber() * upperLimit;
    }
    
    /**
     * @description 
     *   Return a random Double in the range of the specified lower limit to the specified 
     *   upper limit inclusive of both limits.
     *   So a lower and upper limit of 1.367 and 100.942 would return a Double between
     *   1.367 and 100.942 inclusive.
     * @param
     *   lowerLimit - a Double representing the lower limit of Doubles from which to select.
     *   upperLimit - a Double representing the upper limit of Doubles from which to select.
     * @return
     *   A Double between the lower limit and the upper limit inclusive.
     */
    public Double nextDoubleInRange(Double lowerLimit, Double upperLimit) {
        Double randomSelected = getUniformRandomNumber();
        return (randomSelected * (upperLimit + 1.0)) + lowerLimit;
    }
    
    /**
     * @description
     *   Randomly shuffle a List of Objects.  This is a shuffle on the actual
     *   List reference passed.  The original order of the List of Objects will 
     *   be destroyed after calling this method.
     * @param
     *   objectList - a List of Objects to shuffle. The original order of the List
     *      of Objects will be destroyed.
     */
    public void shuffle(List<Object> objectList) {
        Integer listSize = objectList.size();
        for (Integer i = listSize - 1; i > 0; --i) {
            Integer j = nextInteger(i + 1);
            Object hold = objectList[i];
            objectList[i] = objectList[j];
            objectList[j] = hold;
        }
    }

    /**
     * @description
     *   Return a randomly shuffled copy of the List of Objects passed.  The
     *   passed List of Objects is unchanged after calling this method.
     * @param
     *   objectList - a List of Objects to shuffle.
     * @return
     *   A shuffled copy of the List of Objects passed.
     */
    public List<Object> shuffleWithCopy(List<Object> objectList) {
        List<Object> copy = new List<Object>(objectList);
        shuffle(copy);
        return copy;
    }
    
    /**
     * @description
     *   Return the next uniform random number between 0.0 and 1.0
     *   inclusive of 0.0, but exclusive of 1.0 (e.g. The random number 
     *   will be >= 0.0 and < 1.0).
     * @return
     *   A Double representing the next uniform random number between 0.0
     *   and 1.0 inclusive of 0.0, but exclusive of 1.0.
     */
    public Double nextUniform() {
        return getUniformRandomNumber();
    }
    
    /**
     * @description
     *   Set the seed for this Random object
     * @param 
     *   seed - a Long representing the seed to be set
     */
    private void setSeed(Long seed) {
        this.seed = (seed ^ 25214903917L) & ((1L << 48) - 1L);
    }
    
    /**
     * @description
     *   Set the seed for this Random object using the system time
     */
    private void setSeedFromSystemTime() {
        setSeed(DateTime.now().getTime()); 
    }

    /**
     * @description
     *   Return a Long representing the next random value with the specified
     *   number of bits.
     * @param
     *   bits - an Integer representing the number of bits in length the next random
     *      value should be.
     * @return
     *   A Long representing the next random value.
     */
    private Long next(Integer bits) {
        seed = (seed * 25214903917L + 11L) & ((1L << 48) - 1L);
        return (Long) (seed >>> (48 - bits));
    }

    /**
     * @description
     *   Return a uniform random number that will be greater than or equal to 0.0
     *   and less than 1.0.
     * @return
     *   A Double representing the next uniform random number.
     */
    private Double getUniformRandomNumber() {
        Long uint = next(32);
        return (Double)(((Double)uint + 1.0D) * 0.0000000002328306435454494D);
    }
}
