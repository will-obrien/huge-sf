@isTest
public class ProposalCloneWithLineItemsTest {
	Static testMethod void myUnitTest(){
    	Apttus_Proposal__Proposal__c qApttusProposal = TestDataFactory.createApttusProposal(1)[0];
        ProposalCloneWithLineItems newClone = new ProposalCloneWithLineItems(new ApexPages.StandardController(qApttusProposal));
        newClone.clones();
    }
}