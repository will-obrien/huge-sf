/**
 * Logic for the different triggers defined on Opportunities
 *
 * @author  Antonio Grassi
 * @date    11/13/2012
 */
public with sharing class OpportunityTriggers {
    private static final Set<String> PRODUCTS_AS_TAGS = new Set<String>{'CommCare', 
                                                                        'CommConnect', 
                                                                        'CommTrack'};

    /**
     * We use @future here in order to perform HTTP callouts from within a trigger context
     */
    @future(callout=true)
    public static void createInFogbugz(Id opportunityId) {
        Opportunity o = FogBugzUtils.fetchOpportunity(opportunityId);

        if (o != null) {
            FogBugzCase fbCase = FogBugzUtils.createFBCaseFromOpportunity(o);
            FogBugzAPI fbAPI = new FogBugzAPI();

            Boolean close = o.IsClosed;
            String fbCaseId = fbAPI.createCase(fbCase, close);

            if (fbCaseId != null) {
                o.Fogbugz_Ticket_Number__c = fbCaseId;
                update o;
            } else {
                System.debug(LoggingLevel.ERROR, 'OpportunityTriggers::createInFogbugz() - Error while creating case');
            }
        } else {
            System.debug(LoggingLevel.WARN, 'OpportunityTriggers::createInFogbugz() - Could not find opportunity just created (???)');
        }
    }

     /**
     * We use @future here in order to perform HTTP callouts from within a trigger context
     */
    @future(callout=true)
    public static void closeFogbugzCase(String ticket_number) {
        if (ticket_number != null) {
            FogBugzAPI fbAPI = new FogBugzAPI();
            FogBugzCase fbCase = fbAPI.getCase(ticket_number);
            String fbCaseId = fbAPI.resolveCase(fbCase);
            if (fbCaseId != null) {
                fbCaseId = fbAPI.closeCase(fbCase);
            }
        }
    }

    public static void updateCaseInFogbugz(Opportunity oppNew, Opportunity oppOld) {
        if ((oppNew.Name != oppOld.Name) ||
            (oppNew.StageName != oppOld.StageName) ||
            (oppOld.Fogbugz_Probability__c != oppNew.Fogbugz_Probability__c) ||
            (oppOld.Product_Text__c != oppNew.Product_Text__c)) {

            if (!System.isBatch()) {
                FogBugzCase fbCase = FogBugzUtils.createFBCaseFromOpportunity(oppNew);
                String tags = null;
                Boolean editTags = (oppOld.Fogbugz_Probability__c != oppNew.Fogbugz_Probability__c) ||
                                       (oppNew.Product_Text__c != oppOld.Product_Text__c);
                updateCase(oppNew.Id, editTags, oppNew.Product_Text__c, oppOld.Product_Text__c, oppOld.StageName);
            }
        }
    }

    /**
     * We use @future here in order to perform HTTP callouts from within a trigger context
     */
    @future(callout=true)
    public static void updateCase(String opportunityId, boolean editTags, String oldProds, String newProds, String oldStage) {
        Opportunity o = FogBugzUtils.fetchOpportunity(opportunityId);

        if (o != null) {
            FogBugzCase fbCase = FogBugzUtils.createFBCaseFromOpportunity(o);
            FogBugzAPI fbAPI = new FogBugzAPI();

            if (o.Amount != null) {
                fbCase.dealSize = o.Amount.intValue();
            } else {
                fbCase.dealSize = 0;
            }

            if (fbCase.probability != null) {
                fbCase.probability = o.Fogbugz_Probability__c;
            } else {
                fbCase.probability = 0;
            }

            Set<String> tags = new Set<String>();

            if (((oldProds != null) && !oldProds.equals(newProds)) || ((newProds != null) && (!newProds.equals(oldProds)))) {
                Set<String> oldProducts = new Set<String>();
                if (oldProds != null) {
                    oldProducts.addAll(oldProds.split('; '));
                }

                Set<String> newProducts = new Set<String>();
                if (newProds != null) {
                    newProducts.addAll(newProds.split('; '));
                }

                if (newProducts.size() >= oldProducts.size()) {
                    for (String newProd : newProducts) {
                        if ((PRODUCTS_AS_TAGS.contains(newProd)) && (!oldProducts.contains(newProd))) {
                            tags.add(newProd);
                        }
                    }
                } else {
                    for (String oldProd : oldProducts) {
                        if ((PRODUCTS_AS_TAGS.contains(oldProd)) && (!newProducts.contains(oldProd))) {
                            tags.add(oldProd);
                        }
                    }
                }
            }

            Boolean close = o.IsClosed;
            Boolean reopen = FogBugzUtils.closedStages.contains(oldStage) && (!o.StageName.equals(oldStage));
            String fbCaseId = fbAPI.updateCaseTitleStageTag(fbCase, editTags, tags, close, reopen);
        } else {
            System.debug(LoggingLevel.WARN, 'OpportunityTriggers::updateCase() - Could not find opportunity just created (???)');
        }
    }
}