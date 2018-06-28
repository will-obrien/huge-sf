public class MultipleCounterPageController
{
    private class ComponentListener1 implements CounterComponentListener
    {
        private Boolean overTwo;
 
        public void onChange(Integer newValue)
        {
            overTwo = (newValue > 2);
        }
    }
     
    private class ComponentListener2 implements CounterComponentListener
    {
        private Boolean equalsOne;
         
        public void onChange(Integer newValue)
        {
            equalsOne = (newValue == 1);
        }
    }
     
    private ComponentListener1 listener1;
    private ComponentListener2 listener2;
 
    public MultipleCounterPageController()
    {
        listener1 = new ComponentListener1();
        listener2 = new ComponentListener2();
    }
     
    public Boolean getShowAlert1()
    {
        return listener1.overTwo;
    }
     
    public Boolean getShowAlert2()
    {
        return listener2.equalsOne;
    }
     
    public CounterComponentListener getComponentListener1() 
    {
        return listener1;
    }
     
    public CounterComponentListener getComponentListener2() 
    {
        return listener2;
    }
}