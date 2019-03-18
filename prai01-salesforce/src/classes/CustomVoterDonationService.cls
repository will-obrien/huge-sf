@RestResource(urlMapping='/VotersWithDonation/*')
global class CustomVoterDonationService {

    global class VoterDonation {

    String VoterName {get; set;}
    String VoterParty {get; set;}
    List<Voter_Donation__c> Donations {get; set;}
    }

    
    @HttpGet
    global static VoterDonation GetVoter()
    {
        //get voter ID from request
        RestRequest request = RestContext.Request;
        String voterId = request.requestURI.substring(request.RequestURI.lastIndexOf('/')+1);
        Voter__c voter = [SELECT ID, Name, Political_Party__c FROM Voter__c WHERE ID = :voterId];
        
        VoterDonation vdon = new VoterDonation();
        vdon.VoterName = voter.Name;
        vdon.VoterParty = voter.Political_Party__c;
        
        //donation list
        vdon.Donations = [SELECT Candidate_Name__c, Amount__c, Donation_Date__c FROM Voter_Donation__c WHERE Voter__r.ID = :voterId ];

        return vdon;
    }

}