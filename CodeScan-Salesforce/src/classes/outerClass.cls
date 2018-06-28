public class outerClass {

    abstract class abstractInner{
        private void test(){
        }
    }
    class innerClass extends abstractInner {
        public void doSomething(){
            this.test();
        }
    }

}