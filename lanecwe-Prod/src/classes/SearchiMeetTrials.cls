@RestResource(urlMapping='/SearchiMeetTrials/*')
global with sharing class SearchiMeetTrials {
    
    global class TrialSearchResponse{
       public  String leadId;
       public  String FirstName;
        public String LastName;
        public String Phone;
        public String Email;
        public String Company;
        public String Street;
        public String City;
        public String State;
        public String PostalCode;
        public String duplicates;
        public String noMatch;
    } 
	@HttpPost
    global static String findiMeetLeads(String email) {
        String noMatches;
        String duplicates;
        JSONGenerator generator = JSON.createGenerator(false);
        //Search for leads with email address that matches email in @POST
        List<Lead> leadList = [SELECT id, firstname, company, lastname, email, phone, street, city, state, PostalCode FROM Lead WHERE email = :email AND z_isIM_Trial__c = 'Yes'];
        SearchiMeetTrials.TrialSearchResponse resp = new SearchiMeetTrials.TrialSearchResponse();
        if (leadList.size()== 1) {
        for (Lead lead : leadList) {
            resp.leadId = lead.id;
            resp.FirstName = lead.firstname;
            resp.LastName = lead.lastname;
            resp.Company = lead.Company;
            resp.Phone = lead.Phone;
            resp.Email = lead.Email;
            resp.PostalCode = lead.PostalCode;
            resp.Street = lead.Street;
            resp.City = lead.City;
            resp.State = lead.State;
        }
        String respString = JSON.serialize(resp);
        //respString = JSON.serialize(respString);
        return respString;
        }
        else if (leadList.size()> 1) {
            //Create JSON response for Duplicates
        	generator.writeStartObject();
        	generator.writeStringField('response', 'Duplicates');
        	generator.writeEndObject(); 
        	duplicates = generator.getAsString();
            return duplicates;
        }
        else
            //Create JSON response for No Matches 
        	generator.writeStartObject();
        	generator.writeStringField('response', 'No Matches');
        	generator.writeEndObject(); 
        	noMatches = generator.getAsString();
 	        return noMatches;
    }
}