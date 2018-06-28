/**
 * Handles requests sent by FogBugz to the Force.com site
 *
 * @author  Antonio Grassi
 * @date    11/20/2012
 */
public without sharing class FogBugzEndpoint {

    public void processRequest() {
    }
    
    /*
    private final static String SF_TOKEN = 'Yiquee9TEpho4fihahwuS4qu';
    
    // This is the user NAME, not user mail
    // sbox
    // private final static String DEFAULT_OWNER = 'nnestle@dimagi.com.dsandbox';
    // prod
    private final static String DEFAULT_OWNER = 'nnestle@dimagi.com';
    
    public void processRequest() {

        Map<String, String> params = System.currentPageReference().getParameters();
        
        if (params.containsKey('token') && params.get('token').equals(SF_TOKEN)) {
        	
        	if (params.containsKey('caseId')) {
        		
        		FogBugzAPI api = new FogBugzAPI();
        		FogBugzCase fbCase = api.getCase(params.get('caseId'));
        		
        		if (fbCase != null) {
        			Map<String, Opportunity> ops = FogBugzUtils.fetchOpportunitiesByFBId(new Set<String>{params.get('caseId')});
        			
        			Opportunity o = ops.size() > 0 ? ops.values()[0] : new Opportunity();
        			
        			if (o.Id == null) {
        				String userMail = api.getPersonEmail(fbCase.ixPersonOpenedBy);
        				
        				if (userMail != null) {
        					User[] us = [select Id from User where Email = :userMail];
        					
        					if (!us.isEmpty()) {
        						o.OwnerId = us[0].Id;
        					}
        					else {
        						System.debug(LoggingLevel.INFO, 'FogBugzEndpoint::processRequest() - User ' + userMail + 'does not exist in SF');
        						
        						us = [select Id from User where Username = :DEFAULT_OWNER];
        						
        						if (!us.isEmpty()) {
        							o.OwnerId = us[0].Id;
        						}
        						else {
        							System.debug(LoggingLevel.WARN, 'FogBugzEndpoint::processRequest() - Cannot find default owner: ' + DEFAULT_OWNER);
        						}
        					}
        				}
        				else {
        					System.debug(LoggingLevel.WARN,
        					             'FogBugzEndpoint::processRequest() - Could not retrieve user email for ' + fbCase.ixPersonOpenedBy);
        				}
        			}
        			
	                o.StageName = fbCase.area;
	                o.Fogbugz_Assigned_To__c = fbCase.assignedTo;
	                // @fixme - Client field?
	                // o.Fogbugz_Client__c = ???
	                o.Fogbugz_Ticket_Number__c = fbCase.caseId;
	                o.Name = fbCase.title;
	                o.Amount = fbCase.dealSize;
	                o.Fogbugz_Probability__c = fbCase.probability;
	    
	                if (fbCase.lastModifiedDate != null) {
	                    o.Fogbugz_Last_Updated_Date__c = fbCase.lastModifiedDate.date();
	                }
	                
	                if (fbCase.latestEvent != null) {
	                    o.Description = fbCase.latestEvent;
	                }

                    Boolean newOp = o.Id == null;
                    
	                if (o.Id == null) {
	                    o.CloseDate = Date.today();
	                }
        			
        			upsert o;
        			
        			if (newOp) {
        				updateFBExternalId(o.Id);
        			}
        		}
        		else {
        			System.debug(LoggingLevel.WARN, 'FogBugzEndpoint::processRequest() - Could not retrieve case ' + params.get('caseId'));
        		}
        	}
        	else {
        		System.debug(LoggingLevel.WARN, 'FogBugzEndpoint::processRequest() - Missing case Id parameter');
        	}
        }
        else {
        	System.debug(LoggingLevel.WARN, 'FogBugzEndpoint::processRequest() - Missing or missmatching token parameter');
        }
    }
    
    @future(callout=true)
    public static void updateFBExternalId(Id opId) {
    	
    	Opportunity o = FogBugzUtils.fetchOpportunity(opId);
    	
    	if (o != null) {

            FogBugzCase fbCase = FogBugzUtils.createFBCaseFromOpportunity(o);
            
            FogBugzAPI api = new FogBugzAPI();
            String res = api.updateCase(fbCase);
            
            if (res == null) {
                System.debug(LoggingLevel.ERROR, 'FogBugzEndpoint::updateFBExternalId() - Error while updating FB case #' + fbCase.caseId);
            }
    	}
    }
    */
}