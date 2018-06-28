/*
 * Base controller for all Visualforce controllers, providing
 * auxiliary methods for conveniently implementing more complex logic
 * in controllers used in Visualforce pages and components
 * 
 * @author Slalom Consulting
 */
global virtual class CustomController {
    
    /*
     * @return a List<ApexPages.Message> object containing all of the
     *         messages given by ApexPages.getMessages() having
     *         severity set to ApexPages.Severity.ERROR
     */
    global static List<ApexPages.Message> getErrors() {
        
        // Initialize the list of error messages
        List<ApexPages.Message> errors = new List<ApexPages.Message>();
        
        // Check all of the messages on the page for errors
        for (ApexPages.Message eachMessage : ApexPages.getMessages()) {
            if (eachMessage.getSeverity() == ApexPages.Severity.ERROR) {
                errors.add(eachMessage);
            }
        }
        
        // Return the list of error messages
        return errors;
    }
	
    /*
     * @return whether there are any error messages (i.e., messages
     *         with severity set to ApexPages.Severity.ERROR)
     */
    global static Boolean hasErrors() {
        return getErrors().size() > 0;
    }
}