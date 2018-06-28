public class VisualforceCodeController
{
    //To display section which hold code as text of VF page
    public boolean showCodeSection {get; set;}
    
    //To hold VF Code as text
    public String PageText {get; set;}
    
    //Hold current page name
    public String CurrentPageName {get; set;}
    
    public VisualforceCodeController()
    {
        CurrentPageName = '' ;
        showCodeSection = false ;
    }
    
    public PageReference DisplayCode()
    {
        if(CurrentPageName != '')
        {
            //Fetching VF code
            PageText = UtilClass.VFPageCode(CurrentPageName) ;
            showCodeSection = true ;
        }
        return null ;
    }
}