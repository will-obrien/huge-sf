public class QueueMembersController {

    // selected queue whose members to view
    public ID queueId { get; set; }
    
    // provide queue name to show on page
    public Group selectedQueue {
        get {
            return [
				SELECT
                	id, name
                FROM
                	group
                WHERE
                	id = :queueId
            ];
        }
    }
    
    // list of all active queue members
    public List<User> queueMembers {
        get {
            return [
            	SELECT
                	id, firstName, lastName, alias, username, email, userRole.name, profile.name
                FROM
                	user
                WHERE
                	id IN ( SELECT userOrGroupId FROM groupmember WHERE groupId = :queueId )
                	AND
                	isActive = true
            ];
        }
    }
    
    /**
     * Controller
     */
    public QueueMembersController() {
        queueId = ApexPages.currentPage().getParameters().get('queueId');
    }
    
    public PageReference refresh() {
        return null;
    }
    
    // picklist of queues whose members to view
    public List<SelectOption> getQueueOptions() {
        
        List<SelectOption> options = new List<SelectOption>();

        options.add( new SelectOption( '', '- Select -' ) );
        for ( Group grp : [
            SELECT
            	id, name
            FROM
            	group
           	WHERE
            	type = 'Queue'
           	ORDER BY
            	name
        ] ) {
            options.add( new SelectOption( grp.id, grp.name ) );
        }
        
        return options;
    }
    
}