@isTest
public class RandomizerTest {
    
	static testMethod void testRandomizer() {
          //Randomizer r = new Randomizer();
          test.startTest();
          Integer testInt = Randomizer.getRandomNumber(10);
          Boolean testBool = Randomizer.getRandomBoolean();
          List<String> testStringList = new List<String>();
          testStringList.add('one');
          testStringList.add('two');
          testStringList.add('three');
          String testString = Randomizer.getRandomString(testStringList);
          String testString2 = Randomizer.getRandomPickListValue(new Account(), 'Industry', true);
          String testString3 = Randomizer.getRandomPickListValue(new Account(), 'Industry', false);
          Map<String,List<String>> testMap = Randomizer.getPicVals(new Account());
          test.stopTest();
          String testString4 = Randomizer.getPlaceholderText(300);
     }
}