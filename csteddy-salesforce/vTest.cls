@istest 
public class vTest {

public static testmethod void vTest() {

String s, nullstring;
Integer i, nullint;
Decimal d, nullnumber;

s = v.of(nullstring);
s = v.of('non null');
i = v.of(nullint);
i = v.of(1);
d = v.of(nullnumber);
d = v.of(1.1);

}

}
