public class myControllerExtension {

    private final Case c;
    
    // The extension constructor initializes the private member
    // variable c by using the getRecord method from the standard
    // controller.
    public myControllerExtension(ApexPages.StandardController stdController) {
        this.c = (Case)stdController.getRecord();
        
        // TODO: I suppose I could do a lookup here by name...
        c.RecordTypeId = '012f00000000MEA'; // Staff Record Type
        
        // Default in some values I don't want to put on the page.
        c.Status = 'New';
        c.Priority = 'Medium';
        c.Origin = 'Web';
        
    }

    public String getGreeting() {
        return 'Hello ' + c.Subject + ' (' + c.id + ')';
    }
}