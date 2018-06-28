/*
 * Controller for the TaskListItem component created
 * specifically for the To-do app
 */
public class TodoTaskListItemController {
    
    /*
     * The Task record to be manipulated within
     * the component
     */
    public Task record { get; set; }
    
    /*
     * Default constructor
     */
    public TodoTaskListItemController() {
        record = TaskUtil.newTask();
    }
    
    /*
     * @return a PageReference to the current page
     *         after attempting to close the Task record
     */
    public PageReference close() {
        PageReference nextPage = null;
        TaskUtil.close(record);
        return nextPage;
    }
    
    /*
     * @return a PageReference to the current page
     *         after attempting to reopen the Task record
     */
    public PageReference reopen() {
        PageReference nextPage = null;
        TaskUtil.reopen(record);
        return nextPage;
    }
    
    /*
     * @return a PageReference to the current page
     *         after attempting to save the Task record
     */
    public PageReference save() {
        PageReference nextPage = null;
        upsert record;
        return nextPage;
    }
    
    /*
     * @return a PageReference to the current page
     *         after attempting to delete the Task record
     */
    public PageReference trash() {
        PageReference nextPage = null;
        delete record;
        return nextPage;
    }
}