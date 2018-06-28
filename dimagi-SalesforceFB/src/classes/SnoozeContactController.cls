public class SnoozeContactController {
     
    // Code we will invoke on page load.
    public PageReference autoRun() {
 
        String theId = ApexPages.currentPage().getParameters().get('id');
        
        if (theId == null || theId == '') {
            // Display the Visualforce page's content if no Id is passed over
            return null;
        }

        Task theTask = new Task(
            Subject = 'Snoozed',
            WhoId = theId,
            Status = 'Completed',
            Priority = 'Normal',
            ActivityDate = date.today(),
            ActivitySubtype__c = null
        );
        
        try{
            insert theTask;
            update [Select Id from Contact Where Id = :theId];
        }catch (Exception ex) {
            
        }
         
        // Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
 
    }
 
}