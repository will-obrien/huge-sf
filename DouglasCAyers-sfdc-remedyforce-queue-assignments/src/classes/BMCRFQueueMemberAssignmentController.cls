/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 @DouglasCAyers
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
 
/**
 * This controller provides basic user assignment to queues we use for Remedyforce.
 * Such queues have their developer names prefixed with 'BMCRF_'.
 * 
 * It also allows the help desk and authorized users to manage queue assignments
 * without needing to be granted system administrator access.
 */
public class BMCRFQueueMemberAssignmentController {

    // ID of the selected group we are adding/removing users to
    public ID selectedGroupId { get; set; }
    
    // Group record for visualforce to display name
    public Group selectedGroup {
        get {
            return [
				SELECT
                	id, name
                FROM
                	group
                WHERE
                	id = :selectedGroupId
            ];
        }
    }

    // For choosing a user to add to the selected group, we want to use
    // visualforce popup lookup picker. However, the <apex:inputField> tag
    // won't bind directly to a controller variable (e.g. if we used User field here),
    // so as a workaround we will bind to the nested 'userOrGroupId' property
    // on the GroupMember object.
    public GroupMember memberToAdd { get; set; }

    // ID of the user to remove from selected group
    public ID userIdToRemove { get; set; }

    // List of users currently assigned to selected group
    public List<User> groupUsers {
        get {
            return new List<User>([
                SELECT
                    id, firstName, lastName, username, email, isActive
                FROM
                    user
                WHERE
                    id IN ( SELECT userOrGroupId FROM groupmember WHERE groupId = :selectedGroupId )
                	AND
                	isActive = true
                ORDER BY
                    firstName
            ]);
        }
    }

    // Constructor
    public BMCRFQueueMemberAssignmentController() {
        selectedGroupId = ApexPages.currentPage().getParameters().get('selectedGroupId');
        memberToAdd = new GroupMember(); // avoid NPE when page binds user lookup
    }

    // always helpful to have a simple method that
    // action support tags can invoke from page
    // when need to refresh the page
    public PageReference refresh() {
        return null;
    }

    public PageReference addUserToGroup() {

        if ( String.isBlank( selectedGroupId ) ) {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Please choose a queue' ) );
            return null;
        }

        if ( memberToAdd == null || String.isBlank( memberToAdd.userOrGroupId ) ) {
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Please choose a user' ) );
            return null;
        }

        // create a new entity to insert into database
        // use the selected group id and user
        GroupMember gm = new GroupMember(
            groupId = selectedGroupId,
            userOrGroupId = memberToAdd.userOrGroupId
        );

        insert gm;

        // get user name for more better confirmation message
        User user = getUserById( memberToAdd.userOrGroupId );
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.CONFIRM, user.name + ' added to queue!' ) );

        // reset form field for next request
        memberToAdd = new GroupMember();

        return null; // just refresh page
    }

    public PageReference removeUserFromGroup() {

        if ( String.isBlank( selectedGroupId ) ) {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Please choose a queue' ) );
            return null;
        }

        if ( String.isBlank( userIdToRemove ) ) {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Please choose a user' ) );
            return null;
        }

        // Query into a list even though we know it will either return 0 or 1 records.
        // However, if query would return 0 records then it throws DML exception.
        // I'd rather check for empty list than add verbose try..catch code.
        List<GroupMember> members = new List<GroupMember>([
            SELECT
            	id
            FROM
            	groupmember
           	WHERE
            	groupId = :selectedGroupId
            	AND
            	userOrGroupId = :userIdToRemove
        ]);

        if ( !members.isEmpty() ) {
            delete members;
        }

        // get user name for more better confirmation message
        User user = getUserById( userIdToRemove );
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.CONFIRM, user.name + ' removed from queue!' ) );

        // reset form field for next request
        userIdToRemove = null;

        return null; // just refresh page
    }

    public List<SelectOption> getGroupOptions() {

        List<SelectOption> options = new List<SelectOption>();

        options.add( new SelectOption( '', '- Select -' ) );
        for ( Group grp : [
            SELECT
            	id, name
            FROM
            	group
           	WHERE
            	type = 'Queue'
            	AND
            	( developerName LIKE 'BMCRF_%' )
            	AND
            	( NOT name LIKE '%(inactive)%' )
           	ORDER BY
            	name
        ] ) {
            options.add( new SelectOption( grp.id, grp.name ) );
        }

        return options;
    }

    public User getUserById( ID userId ) {
        return [ SELECT id, name FROM user WHERE id = :userId ];
    }
    
}