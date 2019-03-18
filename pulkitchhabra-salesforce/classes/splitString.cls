public class splitString{
	public static void main(){
		String s = 'These are the emails in the field: abc@abc.com, xyz@xyz.com and/or lmn@lmn.co.in';
        Matcher m = Pattern.compile('\\.+').Matcher(s);
        System.debug(m.group());
	}
}