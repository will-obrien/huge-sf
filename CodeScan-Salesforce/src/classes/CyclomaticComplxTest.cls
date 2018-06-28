public class CyclomaticComplxTest {
    
    Integer a, b, c, d, e, f, lt, h, a1, a2, b1, b2;
    
    public void fiddle(){}
    
    public void example() {
        
		if (a == b) {
            if (a1 == b1) {
                fiddle();
			} else if (a2 == b2) {
                fiddle();
            } else {
                fiddle();
            }
            } else if (c == d) {
                while (c == d) {
                    fiddle();
                }
            } else if (e == f) {
                for (Integer n = 0; n < h; n++) {
                    fiddle();
                }
            } else {
                if (a1 == b1) {
                	fiddle();
				} else if (a2 == b2) {
                	fiddle();
            	} else {
                	fiddle();
            	}
            }
    	}
}