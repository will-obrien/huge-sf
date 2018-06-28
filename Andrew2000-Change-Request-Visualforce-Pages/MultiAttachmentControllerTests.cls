@istest
public class MultiAttachmentControllerTests {
public static final Integer NUM_ATTACHMENTS_TO_ADD=5;
/******************************************************
	 *
	 * Unit Tests
	 *
	 ******************************************************/
	 
	private static testMethod void testController()
	{
		Account acc=new Account(Name='Unit Test');
		insert acc;
		MultiAttachmentController controller=new MultiAttachmentController();
		controller.sobjId=acc.id;
		
		System.assertEquals(0, controller.getAttachments().size());
		
		System.assertEquals(6, controller.newAttachments.size());
		
		controller.addMore();
		
		System.assertEquals(6 + NUM_ATTACHMENTS_TO_ADD, controller.newAttachments.size());
		
		// populate the first and third new attachments
		List<Attachment> newAtts=controller.newAttachments;
		newAtts[0].Name='Unit Test 1';
		newAtts[0].Description='Unit Test 1';
		newAtts[0].Body=Blob.valueOf('Unit Test 1');

		newAtts[2].Name='Unit Test 2';
		newAtts[2].Description='Unit Test 2';
		newAtts[2].Body=Blob.valueOf('Unit Test 2');
		
		controller.save();
		
		System.assertEquals(2, controller.getAttachments().size());
		System.assertNotEquals(null, controller.done());
	}
}
