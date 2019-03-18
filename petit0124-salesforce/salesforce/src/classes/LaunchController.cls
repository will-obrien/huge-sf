/*******************************************************************
 * Custom controller for the "Launch Page" recipe.
 * Determines if a user has access to a page.
 *******************************************************************/
public with sharing class LaunchController
{
    // action method executed before the page is rendered - attempts
    // to retrieve the contents of the protected page and if successful
    // redirects the user to the protected page
    public PageReference allowAccess()
    {
        PageReference pr=Page.Protected;
        try
        {
            //pr.getContent();
            pr=null;
        }
        catch (Exception e)
        {
            pr=null;
        }
        
        return pr;
    }
}