trigger newCandidate on Candidate__c (before insert) {
    for (Candidate__c can : Trigger.new) {
        can.Email__c='San@gmail.com';
        }
    
}