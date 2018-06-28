@isTest
public class NotationTriggerTest {
	public NotationTriggerTest() {}
	
	@isTest
	public static void insertNotationTest() {
		Notation__c testNotation = new Notation__c(Note__c = 'TestNote');
		Notation__c testNotation2 = new Notation__c(Note__c = 'TestNote2');
		insert testNotation;

		Test.startTest();
			try {
				insert testNotation2;
			} catch(Exception e) {
				
			}		
		Test.stopTest();

		List<Notation__c> selectedNotations = [SELECT Id, Note__c FROM Notation__c];
		System.assertEquals(1, selectedNotations.size(), 'Size of selected Notations must be 0');
		System.assertEquals('TestNote', selectedNotations[0].Note__c, 'Size of selected Notations must be 0');
	}
}
