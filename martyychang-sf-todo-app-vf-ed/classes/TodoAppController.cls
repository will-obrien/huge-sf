/*
 * Master controller for the To-do app
 */
public class TodoAppController extends CustomController {
    
    /*
     * The known list of tasks for the current user
     * to present and manage in the app
     */
    private List<Task> tasks;
    
    /*
     * The new task that the user wishes to add
     * to his or her to-do list
     */
    public Task newTask { get; set; }
    
    /*
     * Default constructor
     */
    public TodoAppController() {
        tasks = null;
        newTask = TaskUtil.newTask();  // A blank task ready for editing
    }
    
    /*
     * @return the tasks property, refreshing the property first
     *         if the stored value is null
     */
    public List<Task> getTasks() {
        if (tasks == null) {
            refreshTasks();
        }
        
        return tasks;
    }
    
    /*
     * When a close "event" is generated from a TaskListItem
     * element, reset and refresh properties as appropriate
     * depending on whether the operation was successful
     */
    public PageReference handleTaskListItemClose() {
        
        // Prepare the next page to show the user
        PageReference nextPage = null;
        
        // If the closing of the task was successful, based
        // on the fact that there are no errors on the page
        if (!hasErrors()) {
            tasks = null;  // Force a refresh when rendered
        }
        
        // Return the next page to show the user
        return nextPage;
    }
    
    /*
     * When a delete "event" is generated from a TaskListItem
     * element, reset and refresh properties as appropriate
     * depending on whether the operation was successful
     */
    public PageReference handleTaskListItemDelete() {
        
        // Prepare the next page to show the user
        PageReference nextPage = null;
        
        // If deleting the task was successful, based
        // on the fact that there are no errors on the page
        if (!hasErrors()) {
            tasks = null;  // Force a refresh when rendered
        }
        
        // Return the next page to show the user
        return nextPage;
    }
    
    /*
     * When an open "event" is generated from a TaskListItem
     * element, reset and refresh properties as appropriate
     * depending on whether the operation was successful
     */
    public PageReference handleTaskListItemOpen() {
        
        // Prepare the next page to show the user
        PageReference nextPage = null;
        
        // If the opening of the task was successful, based
        // on the fact that there are no errors on the page
        if (!hasErrors()) {
            tasks = null;  // Force a refresh when rendered
        }
        
        // Return the next page to show the user
        return nextPage;
    }
    
    /*
     * When a save "event" is generated from a TaskListItem
     * element, reset and refresh properties as appropriate
     * depending on whether the operation was successful
     */
    public PageReference handleTaskListItemSave() {
        
        // Prepare the next page to show the user
        PageReference nextPage = null;
        
        // If the save was successful, witnessed by the
        // fact that newTask has no errors and also now
        // has a Salesforce ID, reset newTask and force
        // a refresh of the list of tasks
        if (newTask.Id != null) {
            newTask = TaskUtil.newTask();  // Reset the property
            tasks = null;  // Force a refresh when rendered
        }
        
        // Return the next page to show the user
        return nextPage;
    }
    
    /*
     * Query for Task records from Salesforce and store
     * the results in the tasks property
     */
    private void refreshTasks() {
        tasks = [
            SELECT Id,
            	ActivityDate, Description,
            	IsClosed, Subject
            FROM Task
            WHERE OwnerId = :UserInfo.getUserId()
            ORDER By ActivityDate ASC
        ];
    }
}