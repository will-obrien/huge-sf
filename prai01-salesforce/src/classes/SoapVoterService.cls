global class SoapVoterService {
 webService static Voter__c getVoter(String  voterId) {
   Voter__c voter = [SELECT ID, Name FROM Voter__c WHERE ID = :voterId];
   return voter;
  }
}