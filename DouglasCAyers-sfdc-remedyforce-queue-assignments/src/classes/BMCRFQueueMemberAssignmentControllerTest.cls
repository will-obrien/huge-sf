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
 
@isTest
private class BMCRFQueueMemberAssignmentControllerTest {

    @isTest
    static void test_can_add_user_to_group() {
    
        Group queue = null;

        // avoid DML mixed operation exception
        // http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects
        System.runAs( new User( Id = UserInfo.getUserId() ) ) {

            queue = new Group();
            queue.name = 'Test Queue 1';
            queue.type = 'Queue';

            insert queue;
            
        }
        
        BMCRFQueueMemberAssignmentController controller = new BMCRFQueueMemberAssignmentController();
        
        Test.startTest();
        
        controller.selectedGroupId = queue.id;
        controller.memberToAdd = new GroupMember(
            userOrGroupId = UserInfo.getUserId()
        );
        
        controller.addUserToGroup();
        
        Test.stopTest();
        
        List<User> members = controller.groupUsers;
        
        System.assert( members.size() == 1 );
        System.assert( members[0].id == UserInfo.getUserId() );
        
        System.assert( controller.selectedGroup.id == controller.selectedGroupId );
        System.assert( controller.selectedGroup.name == queue.name );
    
    }
    
    @isTest
    static void test_can_remove_user_from_group() {
    
        Group queue = null;

        // avoid DML mixed operation exception
        // http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects
        System.runAs( new User( Id = UserInfo.getUserId() ) ) {

            queue = new Group();
            queue.name = 'Test Queue 1';
            queue.type = 'Queue';

            insert queue;
            
        }
        
        BMCRFQueueMemberAssignmentController controller = new BMCRFQueueMemberAssignmentController();
        
        controller.selectedGroupId = queue.id;
        controller.memberToAdd = new GroupMember(
            userOrGroupId = UserInfo.getUserId()
        );
        
        controller.addUserToGroup();
        
        Test.startTest();
        
        controller.userIdToRemove = UserInfo.getUserId();
        
        controller.removeUserFromGroup();
        
        Test.stopTest();
        
        List<User> members = controller.groupUsers;
        
        System.assert( members.size() == 0 );
    
    }
    
    @isTest
    static void test_refresh() {

        BMCRFQueueMemberAssignmentController controller = new BMCRFQueueMemberAssignmentController();
        
        Test.startTest();
        
        PageReference ref = controller.refresh();
        
        Test.stopTest();
        
        System.assert( ref == null );
        
    }
    
    @isTest
    static void test_get_select_options() {
     
        Group queue = null;

        // avoid DML mixed operation exception
        // http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects
        System.runAs( new User( Id = UserInfo.getUserId() ) ) {

            queue = new Group();
            queue.name = 'Test Queue 1';
            queue.developerName = 'BMCRF_Test_Queue_1';
            queue.type = 'Queue';

            insert queue;
            
        }
        
        BMCRFQueueMemberAssignmentController controller = new BMCRFQueueMemberAssignmentController();
        
        Test.startTest();
        
		List<SelectOption> options = controller.getGroupOptions();
        
        Test.stopTest();
            
        System.assert( options.size() > 0 );
        
        Boolean isFound = false;
        for ( SelectOption option : options ) {
            if ( option.getLabel() == 'Test Queue 1' ) {
                isFound = true;
            }
        }
        System.assert( isFound );
        
    }

}