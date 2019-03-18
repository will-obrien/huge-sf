/*
 * Utility class with static methods used for streamlining
 * operations pertaining to the Task object
 */
global class TaskUtil {
    
    /*
     * The Status value representing a task that has already
     * been completed and no longer requires any action
     */
    global static final String COMPLETED_STATUS = 'Completed';
    
    /*
     * The Status value representing a task that has not yet
     * been completed and requires action from the Task Owner
     */
    global static final String OPEN_STATUS = 'Open';
    
    /*
     * Close a Task record by setting the Status to "Completed"
     */
    global static void close(Task record) {
        record.Status = COMPLETED_STATUS;
        update record;
    }
    
    /*
     * @return a new Task record initialized with default values
     */
    global static Task newTask() {
        return (Task)Task.SObjectType.newSObject(null, true);
    }
    
    /*
     * Open a Task record by setting the STatus to "Open"
     */
    global static void reopen(Task record) {
        record.Status = OPEN_STATUS;
        update record;
    }
}