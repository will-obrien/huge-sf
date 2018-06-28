/* Developer    : keerthi Chandra
   Date         : 5-30-2016
   Status       : Developed
   Description  : Displaying page visit count on the vf page without storing in database.
*/
public class CookieController {

    ///OBJECTIVE>
    /// create cookie and get page visit count value using cookie
    ///<OBJECTIVE>
    public CookieController() {
        Cookie counter = ApexPages.currentPage().getCookies().get('counter');
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'false'. 
        if (counter == null) {
            counter = new Cookie('counter','1',null,-1,false);
        } else {
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
            Integer count = Integer.valueOf(counter.getValue());
            counter = new Cookie('counter', String.valueOf(count+1),null,-1,false);
        }
    
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
    }
    
    ///<OBJECTIVE>
    // This method is used by the Visualforce action {!count} to display the current 
    // value of the number of times a user had displayed a page. 
    // This value is stored in the cookie.
    ///<OBJECTIVE>
    public String getCount() {
        Cookie counter = ApexPages.currentPage().getCookies().get('counter');
        if(counter == null) {
            return '0';
        }
        return counter.getValue();
    }
}