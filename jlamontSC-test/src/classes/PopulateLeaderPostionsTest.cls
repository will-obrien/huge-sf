@isTest
private class PopulateLeaderPostionsTest {

    static testMethod void myUnitTest() {
    	List<Leader_Position__c> posList = new List<Leader_Position__c>();
    	posList.add(new Leader_Position__c(
    		Name='Records Manager',
    		Code__c='RECM'
    	));
    	posList.add(new Leader_Position__c(
    		Name='OARS Admin - Non-Outings',
    		Code__c='AMS'
    	));
    	posList.add(new Leader_Position__c(
    		Name='Chair',
    		Code__c='CHR'
    	));
    	posList.add(new Leader_Position__c(
    		Name='Secretary',
    		Code__c='SECY'
    	));
    	insert posList;
    	new PopulateLeaderPositions().populate();
    }
}