@isTest
public class MainProjectPageControllerTest {

	@isTest
	public static void testInsertSchedule() {
		TestSetup testSetup = new TestSetup();
		testSetup.addAttachment();
		testSetup.addShedule();
		Test.startTest();
			testSetup.controller.UploadFileAttachmentSchedule();
		Test.stopTest();
		List<Schedule__c> expectedSchedule = [SELECT Id FROM Schedule__c WHERE ScheduleDate__c = TODAY];
		System.assertEquals(1, expectedSchedule.size(), 'Schedules list must be empty');
	}

	@isTest
	public static void testInsertMaterial() {
		TestSetup testSetup = new TestSetup();
		testSetup.addAttachment();
		testSetup.addMaterial();
		Test.startTest();
			testSetup.controller.UploadFileAttachmentMaterial();
		Test.stopTest();
		List<Material__c> expectedMaterial = [SELECT Id FROM Material__c WHERE Name = 'TestMaterial' AND Theme__c = 'Web'];
		System.assertEquals(1, expectedMaterial.size(), 'Schedules list must be empty');

	}

	@isTest
	public static void testGetPicklistValues() {
		MainProjectPageController controller = new MainProjectPageController();
		List<SelectOption> statusOptions;
		controller.getPicklistValues();
		System.assertEquals(4, controller.statusOptions.size(), 'Size of list of select options not expected!');
	}

	@isTest
	public static void testDeleteNotation() {
		TestSetup testSetup = new TestSetup();
		testSetup.insertNotation();


		Test.startTest();
			DeleteNotation m = new DeleteNotation();
			String sch = '0 0 1 * * ?';
			String jobID = system.schedule('Clear Notation', sch, m);
		Test.stopTest();

 		CronTrigger ct = [	SELECT Id, CronExpression, TimesTriggered, NextFireTime
         					FROM CronTrigger 
         					WHERE id = :jobID];

        System.assertEquals(sch, ct.CronExpression);
		List<Notation__c> expectedNotation = [SELECT Id, Note__c FROM Notation__c];
		System.assertEquals(1, expectedNotation.size(), 'Size of list of notations not expected!');
		System.assertEquals(null, expectedNotation[0].Note__c, 'Note not cleared!');


	}

	@isTest
	public static void mainButtonActionTest() {
		TestSetup testSetup = new TestSetup();

		Test.startTest();
			testSetup.controller.mainButtonAction();
		Test.stopTest();

		System.assertEquals(true,testSetup.controller.mainButtonFlag,'The flags are not set correctly');
		System.assertEquals(false,testSetup.controller.scheduleButtonFlag,'The flags are not set correctly');
		System.assertEquals(false,testSetup.controller.materialsButtonFlag,'The flags are not set correctly');
	}

	@isTest
	public static void scheduleButtonAction() {
		TestSetup testSetup = new TestSetup();

		Test.startTest();
			testSetup.controller.scheduleButtonAction();
		Test.stopTest();

		System.assertEquals(false,testSetup.controller.mainButtonFlag,'The flags are not set correctly');
		System.assertEquals(true,testSetup.controller.scheduleButtonFlag,'The flags are not set correctly');
		System.assertEquals(false,testSetup.controller.materialsButtonFlag,'The flags are not set correctly');
	}

	@isTest
	public static void materialsButtonActionTest() {
		TestSetup testSetup = new TestSetup();

		Test.startTest();
			testSetup.controller.materialsButtonAction();
		Test.stopTest();

		System.assertEquals(false,testSetup.controller.mainButtonFlag,'The flags are not set correctly');
		System.assertEquals(false,testSetup.controller.scheduleButtonFlag,'The flags are not set correctly');
		System.assertEquals(true,testSetup.controller.materialsButtonFlag,'The flags are not set correctly');
	}

	@isTest
	public static void addAttachmentTest() {
		TestSetup testSetup = new TestSetup();

		Test.startTest();
			testSetup.controller.addAttachment();
		Test.stopTest();

		System.assertEquals(false,testSetup.controller.addAttachmentFlag,'The flags are not set correctly');
		System.assertEquals(false,testSetup.controller.scheduleShow,'The flags are not set correctly');
	}

	private class TestSetup {
		public MainProjectPageController controller;
		public Schedule__c schedule;
		public Notation__c notation;
		public Attachment attachedFile;
		public Material__c material;

		public TestSetup() {
			controller = new MainProjectPageController();
			schedule = new Schedule__c();
			attachedFile = new Attachment();
			notation = new Notation__c();
			material = new Material__c();
		}

		public void insertNotation() {
			notation.Note__c = 'This is notation';	
			insert notation;
		}

		public void addShedule() {
			controller.schedule.ScheduleDate__c = Date.today();	
		}

		public void addAttachment() {
			controller.attachedFile.Name = 'TestAttachment';
			controller.attachedFile.Body = Blob.valueOf('TestBODY');
		}

		public void addMaterial() {
			controller.material.Name = 'TestMaterial';	
			controller.material.Theme__c = 'Web';	
		}
	}
}
