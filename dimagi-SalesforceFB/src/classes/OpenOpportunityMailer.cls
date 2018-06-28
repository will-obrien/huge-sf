/**
 *
 * @author  Fernando Rodriguez (frodriguez@adooxen.com)
 * @date    01/11/2012
 *
 */
public class OpenOpportunityMailer {

    private static final String EMAIL_SUBJECT = '<Name of User> | <Date> | Biz Dev Report';
    private static final String GLOBAL_RED_EMAIL_SUBJECT = 'Dimagi Overdue Opportunities';
    private static final String RED_EMAIL_SUBJECT = 'Your Overdue Opportunities';
    private static final String[] earlyStages = new String[] {'Stage 1 - Connect','Stage 2 - Talking', 'Stage 5 - Submitted'};

    public static void sendOpenOpportunitiesBatchReport(User user, String[] recipients, Map<String, Opportunity[]> stagedOpportunities) {
        
        Map<String, String> stageComments = new Map<String, String>();
        for (String stageComment :stagedOpportunities.keySet()) {
            stageComments.put(stageComment, '');
        }

        String content = OpenOpportunityEmailUtils.buildEmailContent(stagedOpportunities, true, stageComments);
        sendEmail(content, recipients, EMAIL_SUBJECT, user.Name);
    }

    public static void sendOpenOpportunitiesDailyReport(User[] users, Map<String, Opportunity[]> stagedOpportunities) {
        Map<String, String> stageComments = new Map<String, String>();
        for (String stageComment :stagedOpportunities.keySet()) {
            stageComments.put(stageComment, '');
        }

        String content = OpenOpportunityEmailUtils.buildEmailContent(stagedOpportunities, true, stageComments);

        sendEmails(content, users, EMAIL_SUBJECT);
    }

    public static void sendOpenOpportunitiesSingleReport(User[] users, String[] recipients, Map<String, String> stageComments) {
        Id[] usersId = new Id[] {};
        String usersNameSubject = ' - ';
        for (User user :users) {
            usersId.add(user.Id);
            usersNameSubject += user.Name + ' - ';
        }

        Map<String, Opportunity[]> stagedOpportunities = OpenOpportunityReportController.getInstance().getOpenOpportunitiesOrderByStage(usersId);
        String content = OpenOpportunityEmailUtils.buildEmailContent(stagedOpportunities, true, stageComments);
        sendEmail(content, recipients, EMAIL_SUBJECT, usersNameSubject);
    }

    private static Map<String, Opportunity[]> getRedStagedOpportunities(Map<String, Opportunity[]> stagedOpportunities) {
        Map<String, Opportunity[]> redStagedOpportunities = new Map<String, Opportunity[]>();
        Integer daysNotUpdatedLimit = Open_Opportunity_Settings__c.getOrgDefaults().Days_Not_Updated_Limit__c != null 
                                       ? Open_Opportunity_Settings__c.getOrgDefaults().Days_Not_Updated_Limit__c.intValue()
                                       : 30;
        Integer daysNotUpdatedLimitEarlyStages = Open_Opportunity_Settings__c.getOrgDefaults().Days_Not_Updated_Limit_Early_Stages__c != null 
                                       ? Open_Opportunity_Settings__c.getOrgDefaults().Days_Not_Updated_Limit_Early_Stages__c.intValue()
                                       : 10;

        Set<String> earlyStagesSet = new Set<String>(earlyStages);

        // Remove fresh opportunities
        for (String stageName :stagedOpportunities.keySet()) {
            Opportunity[] opportunities = new Opportunity[] {};

            List<OpportunityContactRole> contactRoles = [SELECT ContactId, OpportunityId FROM OpportunityContactRole WHERE IsPrimary = true AND OpportunityId IN: stagedOpportunities.get(stageName)];
            Map<Id, Id> oppToContactMap = new Map<Id, Id>();
            for (OpportunityContactRole role : contactRoles) {
                oppToContactMap.put(role.OpportunityId, role.ContactId);
            }
            List<OpportunityContactRole> contactRolesNotPrim = [SELECT ContactId, OpportunityId FROM OpportunityContactRole WHERE IsPrimary = false AND OpportunityId IN: opportunities];
            for (OpportunityContactRole role : contactRolesNotPrim) {
                if (!oppToContactMap.containsKey(role.OpportunityId)) {
                    oppToContactMap.put(role.OpportunityId, role.ContactId);
                }
            }
            Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, Follow_up_Date__c FROM Contact WHERE Id IN: oppToContactMap.values()]);

            for(Opportunity opportunity : stagedOpportunities.get(stageName)) {
                Boolean isBlankORFromThePast = true;
                if (oppToContactMap.containsKey(opportunity.Id) && contacts.containsKey(oppToContactMap.get(opportunity.Id))) {
                    Contact con = contacts.get(oppToContactMap.get(opportunity.Id));
                    if (con.Follow_up_Date__c != null && con.Follow_up_Date__c >= Date.today()) {
                        isBlankORFromThePast = false;
                    }
                }
                if (earlyStagesSet.contains(opportunity.StageName)) {
                    if (opportunity.Total_Days_Not_Updated__c > daysNotUpdatedLimitEarlyStages && !opportunity.long_wait__c && isBlankORFromThePast) {
                        opportunities.add(opportunity);
                    }
                } else {
                    if (opportunity.Total_Days_Not_Updated__c > daysNotUpdatedLimit && !opportunity.long_wait__c && isBlankORFromThePast) {
                        opportunities.add(opportunity);
                    }
                }
            }

            if (!opportunities.isEmpty()) {
              redStagedOpportunities.put(stageName, opportunities);
            }
        } 

        return redStagedOpportunities;
    }

    public static void sendRedOpenOpportunitiesBatchReport(User user, String[] recipients, Map<String, Opportunity[]> stagedOpportunities) {
        
        Map<String, Opportunity[]> redStagedOpportunities = getRedStagedOpportunities(stagedOpportunities);
            
        // Only send Mail if there are opportunities    
        if (!redStagedOpportunities.isEmpty()) {
            
            Map<String, String> stageComments = new Map<String, String>();
            for (String stageComment :redStagedOpportunities.keySet()) {           
                stageComments.put(stageComment, '');
            }
            
            String content = OpenOpportunityEmailUtils.buildEmailContent(redStagedOpportunities, false, stageComments);
            
            sendEmail(content, recipients, RED_EMAIL_SUBJECT, user.Name);
        }
    }
    
    // Added by Nick to support sending this email globally to biz dev
    // If it's a global email the subject has to be different
    
        public static void sendRedOpenOpportunitiesUsers(User[] users, Map<String, Opportunity[]> stagedOpportunities) {
        
        	sendRedOpenOpportunitiesUsers(users, stagedOpportunities, 'individual');

    }

    public static void sendRedOpenOpportunitiesUsers(User[] users, Map<String, Opportunity[]> stagedOpportunities, String message_type) {
        
        Map<String, Opportunity[]> redStagedOpportunities = getRedStagedOpportunities(stagedOpportunities); 
    
        // Only send Mail if there are opportunities    
        if (!redStagedOpportunities.isEmpty()) {
            
            Map<String, String> stageComments = new Map<String, String>();
            for (String stageComment :redStagedOpportunities.keySet()) {           
                stageComments.put(stageComment, '');
            }
            
            String content = OpenOpportunityEmailUtils.buildEmailContent(redStagedOpportunities, false, stageComments);
            
            // Added by Nick to check if global or individual subject should be used
            if(message_type == 'global') {
            	sendEmails(content, users, GLOBAL_RED_EMAIL_SUBJECT );
            }
            else {
            	sendEmails(content, users, RED_EMAIL_SUBJECT);
            }
        }
    }

    public static void sendRedOpenOpportunitiesUsers(List<String> emails, Map<String, Opportunity[]> stagedOpportunities, String message_type) {
        Map<String, Opportunity[]> redStagedOpportunities = getRedStagedOpportunities(stagedOpportunities);

        // Only send Mail if there are opportunities
        if (!redStagedOpportunities.isEmpty()) {

            Map<String, String> stageComments = new Map<String, String>();
            for (String stageComment :redStagedOpportunities.keySet()) {
                stageComments.put(stageComment, '');
            }

            String content = OpenOpportunityEmailUtils.buildEmailContent(redStagedOpportunities, false, stageComments);

            if(message_type == 'global') {
                sendEmails(content, emails, GLOBAL_RED_EMAIL_SUBJECT);
            } else {
                sendEmails(content, emails, RED_EMAIL_SUBJECT);
            }
        }
    }

    private static void sendEmail(String content, String[] recipients, String subjectTemplate, String userName) {
        
        String subject = subjectTemplate.replace('<Name of User>', userName).replace('<Date>', Date.today().format());
        
        OrgWideEmailAddress wideAddress = OpenOpportunityReportController.getOrganizationWideAddressMail();
        
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        
        if (wideAddress != null) {
            mail.setOrgWideEmailAddressId(wideAddress.Id);
        }
        
        mail.setHtmlBody(content);
        mail.setSubject(subject);
        mail.setToAddresses(recipients);
        Messaging.sendEmail(new Messaging.Email[] {mail});
    }
    
    private static void sendEmails(String content, User[] users, String subjectTemplate) {
        
        Messaging.Email[] mails = new Messaging.Email[]{};
        OrgWideEmailAddress wideAddress = OpenOpportunityReportController.getOrganizationWideAddressMail();
        
        for (User user: users) { 
	        
	        String subject = subjectTemplate.replace('<Name of User>', user.Name).replace('<Date>', Date.today().format());
	        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
	        
	        if (wideAddress != null) {
	            mail.setOrgWideEmailAddressId(wideAddress.Id);
	        }
	        
	        mail.setHtmlBody(content);
	        mail.setSubject(subject);
	        mail.setTargetObjectId(user.Id);
	        mail.setSaveAsActivity(false);
	        mails.add(mail);
	        
        }
        Messaging.sendEmail(mails);
    }

    private static void sendEmails(String content, List<String> emails, String subject) {

        Messaging.Email[] mails = new Messaging.Email[]{};
        OrgWideEmailAddress wideAddress = OpenOpportunityReportController.getOrganizationWideAddressMail();

        for (String email: emails) {
            Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();

            if (wideAddress != null) {
                mail.setOrgWideEmailAddressId(wideAddress.Id);
            }

            mail.setToAddresses(new String[] {email});
            mail.setHtmlBody(content);
            mail.setSubject(subject);
            mail.setSaveAsActivity(false);
            mails.add(mail);
        }

        Messaging.sendEmail(mails);
    }
}