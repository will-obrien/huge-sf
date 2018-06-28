public class InnerClassCounterPageController
{   
    private Boolean showAlert;
 
    public InnerClassCounterPageController()
    {
        showAlert = false;
    }
     
    public Boolean getShowAlert()
    {
        return showAlert;
    }
     
    public CounterComponentListener getComponentListener() 
    {
        return new InnerClassComponentListener(this);
    }
 
    private class InnerClassComponentListener implements CounterComponentListener
    {
        private InnerClassCounterPageController controller;
         
        public InnerClassComponentListener(InnerClassCounterPageController controller)
        {
            this.controller = controller;
        }
         
        public void onChange(Integer newValue)
        {
            controller.showAlert = (newValue > 2);
        }
    }
}