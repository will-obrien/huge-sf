public class Sample extends OopsConcepts {
    Integer i=0;
    public Boolean primeNumber(Integer num) {
        for(i=2;i<num/2;i++)
            if(Math.mod(num, i)==0)
                return false;
        return true;
    }
    public Boolean isPalindrome(String word)
    {
    	String newWord = word.trim().deleteWhitespace();
        if(newWord.equalsIgnoreCase(newWord.reverse()))
            return true;
        return false;
    }
    public void replaceOccurance(String occurance, String[] word)
    {
        String s;
        for(String c : word)
        {
            s=c.toLowerCase().replace(occurance.toLowerCase(),'');
            System.debug(s);
        }
    }
    public Integer countLength(String word)
    {
        i=0;
        List<Integer> intList= word.getChars();
        for(Integer countMembers: intList)
            i++;
        return i;
    }
    public void uniqueNumbers(List<Integer> IntList)
    {
        Set<Integer> IntSet = new set<Integer>();
        IntSet.addAll(IntList);
        System.debug(IntSet);
    }
    public override void show()
    {
        System.debug(Date.today());
    }
}