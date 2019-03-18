//General Class with static methods
public class UtilClass
{
    //Method will take visualforce page name as parameter and returns the code written in it
    public static String VFPageCode(String PageName)
    {
        ApexPage testPage = new ApexPage();
        String PageText = '' ;
        
        if(PageName != '')
        {
            //Fetching visualforce page code
            testPage = [Select Id, Markup from ApexPage where name =: PageName];
            PageText = testPage.markup ;
        }
        return PageText ;
    }
}