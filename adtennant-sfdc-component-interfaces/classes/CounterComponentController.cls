public class CounterComponentController
{    
    public CounterComponentListener listener { get; set; }
     
    private Integer count;
     
    public CounterComponentController()
    {
        count = 0;
    }
     
    public Integer getCount()
    {
        return count;
    }
     
    public PageReference increment()
    {
        count++;
         
        if(listener != null)
        {
            listener.onChange(count);
        }
         
        return null;
    }
}