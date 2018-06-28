public class StringArrayTest {
	
	public static List<String> generateStringArray(Integer n ){
		List<String> lst = new List<String>();
		for (Integer i = 0; i < n; i++ ){
			lst.add('Test '+ i);
		}
		return lst;
	}
}