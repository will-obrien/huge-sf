/**************************************************
Class Name: OpenOpportunityReportController
Class Description: Opportunity Expert Controller 
Author: Fernando Rodriguez (frodriguez@adooxen.com)
Modified By: Fernando
Update Date: 2013-03-04
Additional Comments: This controller performs all Opportunity Related queries for all components on the OpenOpportunites Module.
                     It also fetches the org wide email as well as the opportunity column fields from the Custom Settings.
                     
Updated by Nick Nestle
Date 05/09/2013
Changed SOQL filter in getOpenOpportunitiesByUser to filter by BU also               
**************************************************/
public class OpenOpportunityReportController {

    private static OpenOpportunityReportController instance = null;
    private static Open_Opportunity_Fields__c[] selectedColumnFields = null; 

    private OpenOpportunityReportController() {}

    public static OpenOpportunityReportController getInstance() {

        if (instance == null) {
            instance = new OpenOpportunityReportController();
        }
        return instance;
    }

    public Opportunity[] getOpenOpportunitiesAllUsers() {
        String[] stages = new String[] {'Stage 1 - Connect','Stage 2 - Talking','Stage 3 - Prospect','Stage 4 - Proposal Development','Stage 5 - Submitted','Stage 6 - In Negotiations'};

        Opportunity[] result = new Opportunity[] {};

        String queryValues = this.getOpenOpportunitiesQueryValues();
        String sql = 'SELECT ' + queryValues + ' FROM Opportunity WHERE IsClosed = false AND StageName IN :stages';

        result = Database.query(sql);
        return result; 
    }

    private String getOpenOpportunitiesQueryValues() {
    	/**************************************************
        Comments: Filled in with default values
        **************************************************/          
        String queryValues = 'Id,Name,StageName,CreatedDate,Amount,AccountId,Total_Days_Not_Updated__c,Stage_Name_Updated_Date__c,Stage_Duration__c,Business_Unit_Owner__c,' +
                                'Business_Unit_Owner__r.Name,Account.Name,OwnerId,Owner.Name,Fogbugz_Link__c,Fogbugz_Probability__c,Fogbugz_Days_Not_Updated__c,' +                       
                                'Fogbugz_Ticket_Number__c,Fogbugz_Assigned_To__c,Fogbugz_Last_Updated_Date__c,long_wait__c';
                                // THIS STRING MUST NOT END WITH A COMMA.
        
        Open_Opportunity_Fields__c[] selectedFields = getOpportunityFields();                 
        
        
        /**************************************************
        Comments: WHEN CUSTOM COLUMNS ARE SELECTED, I ADD THOSE COLUMNS TO THE QUERY STRING
        **************************************************/                  
        if (!selectedFields.isEmpty()) {
            queryValues = 'Name,';
            for(Open_Opportunity_Fields__c selectedField :selectedFields) {
                
                if (selectedField.Name != 'Name') {                             
                    queryValues += selectedField.Name + ',';
                }
            }
            
            // THERE ARE SOME VALUES THAT NEED TO BE ADDED TO THE QUERY EVEN IF THEY WERE NOT SELECTED.
            queryValues+='Business_Unit_Owner__r.Name,Account.Name';
            
            if (!queryValues.contains('AccountId')) {
                queryValues += ',AccountId';
            }                       
            if (!queryValues.contains('Owner.Name')) {
                queryValues += ',Owner.Name';
            }           
            if (!queryValues.contains('Total_Days_Not_Updated__c')) {
                queryValues += ',Total_Days_Not_Updated__c';
            }
            if (!queryValues.contains('StageName')) {
                queryValues += ',StageName';
            }
            if(!queryValues.contains('long_wait__c')) {
                queryValues += ',long_wait__c';
            }
            
            if(!queryValues.contains('Stage_Duration__c')) {
                queryValues += ',Stage_Duration__c';
            }
            
            
            /**************************************************
            Comments: IF WE WANT TO ADD AN EXTRA FIELD THAT MUST BE USED AS A CONDITION PUT IT HERE.

            Expected Format:
            
                if (!queryValues.contains('FIELD_NAME__c')) {
                    queryValues += ',FIELD_NAME__c';
                }                      
            
            **************************************************/             
        }
        
        /**************************************************
        Comments: Perform the query on Opportunities based on the fields selected.
        **************************************************/
        
        return queryValues;     
    }
    
    public Opportunity[] getOpenOpportunitiesByUser(Id[] usersId) {
        
        String[] stages = new String[] {'Stage 1 - Connect','Stage 2 - Talking','Stage 3 - Prospect','Stage 4 - Proposal Development','Stage 5 - Submitted','Stage 6 - In Negotiations'};
        
        Opportunity[] result = new Opportunity[] {};

        String queryValues = this.getOpenOpportunitiesQueryValues();   
        
        /******
        /* Added in filter for Opportunity_Owning_Entity__c so can filter on business unit in the report
        /* Nick Nestle May 9, 2013
        *******/
        String sql = 'SELECT ' + queryValues + ' FROM Opportunity WHERE IsClosed = false AND (OwnerId IN :usersId OR Opportunity_Owning_Entity__c IN :usersId) AND StageName IN :stages';
             
        result = Database.query(sql);                                      
        return result;                               
    }


    public Map<String, Opportunity[]> getOpenOpportunitiesOrderByStage(Id userId) {
    	
    	return getOpenOpportunitiesOrderByStage(new Id[] {userId});
    }

    public Map<String, Opportunity[]> getOpenOpportunitiesOrderByStage(Id[] usersId) {
    	
    	Map<String, Opportunity[]> result = new Map<String, Opportunity[]>();
    	Opportunity[] opportunities = getOpenOpportunitiesByUser(usersId);    	
    	
    	for(Opportunity opportunity :opportunities) {
    		
    		String stageName = opportunity.StageName;
    		
    		if (result.containsKey(stageName)) {
    			
    			result.get(stageName).add(opportunity);    			
    		}
    		else {
    			
    			result.put(stageName, new Opportunity[] {opportunity});
    		}    		
    	}
    	
    	return result;
    }
    
    public Map<String, Opportunity[]> getOpenOpportunitiesAllUsersOrderByStage() {
        
        Map<String, Opportunity[]> result = new Map<String, Opportunity[]>();
        Opportunity[] opportunities = getOpenOpportunitiesAllUsers();      
        
        for(Opportunity opportunity :opportunities) {
            
            String stageName = opportunity.StageName;
            
            if (result.containsKey(stageName)) {
                
                result.get(stageName).add(opportunity);             
            }
            else {
                
                result.put(stageName, new Opportunity[] {opportunity});
            }           
        }
        
        return result;
    }

    public void updateStageDate(Id[] usersId) {
    	
        Opportunity[] result = new Opportunity[] {};
             
        result = [SELECT 
                       StageName,
                       CreatedDate, 
                       Stage_Name_Updated_Date__c,
                                              
                       (SELECT StageName, CreatedDate FROM OpportunityHistories)                       
                       
                   FROM Opportunity 
                   WHERE IsClosed = false
                   AND Stage_Name_Updated_Date__c = null
                   AND OwnerId IN :usersId];    	
    	
        Opportunity[] opportunities = new Opportunity[] {};
        
        for (Opportunity opp :result) {
            
            if (opp.Stage_Name_Updated_Date__c == null) {
                
                opp.Stage_Name_Updated_Date__c = Date.valueOf(opp.CreatedDate);
                for (OpportunityHistory oh :opp.OpportunityHistories) {                   
                    
                    String ohStageName = oh.StageName;
                    Date createdDate = Date.valueOf(oh.CreatedDate);
                                        
                    if (ohStageName != opp.StageName) {
                        
                        opp.Stage_Name_Updated_Date__c = createdDate;
                        break;
                    }                   
                }               
                opportunities.add(opp);
            }        
        }    
        
        if (!opportunities.isEmpty()) {         
            update opportunities;
        }      	
    	
    }    
    
    public static Open_Opportunity_Fields__c[] getOpportunityFields() {
 
        if (selectedColumnFields == null) {
        
	        selectedColumnFields = new Open_Opportunity_Fields__c[] {};      
	        selectedColumnFields = [SELECT 
					                       Id,
					                       Name,
					                       Label__c,
					                       Type__c,
					                       Order__c
					                   FROM Open_Opportunity_Fields__c
					                   Order By Order__c];
        }
                                
        return selectedColumnFields;      
    }    
    
    public static OrgWideEmailAddress getOrganizationWideAddressMail() {
    	
    	OrgWideEmailAddress[] addresses = new OrgWideEmailAddress[] {};
    	final String DIMAGI_WIDE_ADDRESS_NAME = 'Dimagi Salesforce';
    	
    	addresses = [SELECT Id, 
	    	               Address, 
	    	               DisplayName 
		               FROM OrgWideEmailAddress
		               WHERE DisplayName = :DIMAGI_WIDE_ADDRESS_NAME];
    	
    	if (!addresses.isEmpty()) {
    		return addresses[0]; 
    	}
    	return null;    	
    }

}