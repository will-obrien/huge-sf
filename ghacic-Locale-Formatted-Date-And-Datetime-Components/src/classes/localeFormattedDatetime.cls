/*
    Created by: Greg Hacic
    Last Update: 17 August 2015 by Greg Hacic
    Questions?: greg@interactiveties.com
    
    Notes:
        - controller for the localeFormattedDatetime Visualforce component
        - tests located at localeFormattedDatetimeTest.class
*/
public class localeFormattedDatetime {
    
    public DateTime datetimeValue { get; set; } //property that reads the datetime value from the component attribute tag
    
    //returns the properly formatted datetime value
    public String getFormattedDatetime() {
        String datetimeFormatted; //variable for the datetime value we will be returning
        if( datetimeValue != null ) { //if the datetimeValue variable is not null
            datetimeFormatted = datetimeValue.format(); //the datetimeValue as a string using the locale of the User
        }
        return datetimeFormatted; //return the string
    }

}