@isTest
private class QueueMembersControllerTest {
 
    @isTest
    static void test_refresh() {

        QueueMembersController controller = new QueueMembersController();
        
        Test.startTest();
        
        PageReference ref = controller.refresh();
        
        Test.stopTest();
        
        System.assert( ref == null );
        
    }
    
    @isTest
    static void test_get_queue_info() {
     
        Group queue = null;
        GroupMember groupMember = null;

        // avoid DML mixed operation exception
        // http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects
        System.runAs( new User( Id = UserInfo.getUserId() ) ) {

            queue = new Group();
            queue.name = 'Test Queue 1';
            queue.developerName = 'Test_Queue_1';
            queue.type = 'Queue';

            insert queue;
            
            groupMember = new GroupMember();
            groupMember.userOrGroupId = UserInfo.getUserId();
            groupMember.groupId = queue.id;
            
            insert groupMember;
            
        }
        
        PageReference pageRef = Page.QueueMembersListPage;

        Test.setCurrentPage( pageRef );
        
        ApexPages.currentPage().getParameters().put( 'queueId', queue.id );
        
        QueueMembersController controller = new QueueMembersController();
        
        Test.startTest();
        
		List<SelectOption> options = controller.getQueueOptions();
        
        List<User> queueMembers = controller.queueMembers;
        
        Group selectedQueue = controller.selectedQueue;
        
        Test.stopTest();
            
        System.assert( options.size() > 0 );
        
        Boolean isFound = false;
        for ( SelectOption option : options ) {
            if ( option.getLabel() == 'Test Queue 1' ) {
                isFound = true;
            }
        }
        System.assert( isFound );
        
        System.assert( selectedQueue != null );
        System.assertEquals( queue.id, controller.queueId );
        System.assertEquals( queue.id, selectedQueue.id );
        
        System.assert( queueMembers.size() > 0 );
        
        isFound = false;
        for ( User usr : queueMembers ) {
            if ( usr.id == groupMember.userOrGroupId ) {
                isFound = true;
            }
        }
        System.assert( isFound );
        
    }
    
}