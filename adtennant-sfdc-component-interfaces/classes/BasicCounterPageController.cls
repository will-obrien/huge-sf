public class BasicCounterPageController implements CounterComponentListener
{
    private Boolean showAlert;
 
    public BasicCounterPageController()
    {
        showAlert = false;
    }
 
    public Boolean getShowAlert()
    {
        return showAlert;
    }
     
    public CounterComponentListener getComponentListener() 
    {
        return this;
    }
     
    public void onChange(Integer newValue)
    {
        showAlert = (newValue > 2);
    }
}