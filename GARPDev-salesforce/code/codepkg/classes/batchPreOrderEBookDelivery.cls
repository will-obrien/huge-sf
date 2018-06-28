global class batchPreOrderEBookDelivery implements Database.Batchable<sObject>,Database.StateFul{
    
    public String startDate; 
    public String endDate; 
    public String mode; 
    
    global batchPreOrderEBookDelivery (String startDate, String endDate, String mode){
        this.startDate = startDate;
        this.endDate = endDate;
        this.mode = mode;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        String stage = 'Closed';
        DateTime sd = DateTime.parse(this.startDate);
        DateTime ed = DateTime.parse(this.endDate); 
        
        return Database.getQueryLocator('SELECT Id, Name, StageName, Amount, Shipping_E_mail__c, (SELECT Id,Description,ProductCode FROM OpportunityLineItems) FROM Opportunity where Pre_Order_eBook_Delivery__c != true and StageName = :stage and CreatedDate >= :sd and CreatedDate <= :ed');
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        Map < Id, Opportunity > eBookFRM1ProvisionOpps = new Map < Id, Opportunity > ();    
        Map < Id, Opportunity > eBookFRM2ProvisionOpps = new Map < Id, Opportunity > ();    
        Map < Id, Opportunity > eBookERP1ProvisionOpps = new Map < Id, Opportunity > ();    
        Map < Id, Opportunity > eBookERP2ProvisionOpps = new Map < Id, Opportunity > ();    
        
        system.Debug('Scope:' + scope.size());
        
        for(Opportunity opp :scope) {
            Boolean foundERP = false;
            Boolean foundFRM = false;
            for(OpportunityLineItem oppLine :opp.OpportunityLineItems){
                if (oppLine.ProductCode == 'FRM1X') {
                    eBookFRM1ProvisionOpps.put(opp.Id, opp);
                    foundFRM=true;
                } else if (oppLine.ProductCode == 'FRM2X') {
                    eBookFRM2ProvisionOpps.put(opp.Id, opp);
                    foundFRM=true;
                } else if (oppLine.ProductCode == 'ENC1X') {
                    eBookERP1ProvisionOpps.put(opp.Id, opp);
                    foundERP=true;
                } else if (oppLine.ProductCode == 'ENC2X') {
                    eBookERP2ProvisionOpps.put(opp.Id, opp);
                    foundERP=true;
                }                    
            }
            if((this.mode == 'ERP' && foundERP == true) || (this.mode == 'FRM' && foundFRM == true) || (foundFRM == false && foundERP == false))
            	opp.Pre_Order_eBook_Delivery__c = true;
        }
        update scope;
        
        if(this.mode == 'FRM') {
            system.debug('eBookFRM1ProvisionOpps:' + eBookFRM1ProvisionOpps);
            if (eBookFRM1ProvisionOpps.size() > 0) {
                opportunityTriggerUtils.provisionEBook(eBookFRM1ProvisionOpps,'FRM Exam Part I');
            }
    
            system.debug('eBookFRM2ProvisionOpps:' + eBookFRM2ProvisionOpps);
            if (eBookFRM2ProvisionOpps.size() > 0) {
                opportunityTriggerUtils.provisionEBook(eBookFRM2ProvisionOpps,'FRM Exam Part II');
            }
        }
        
        if(this.mode == 'ERP') {
            system.debug('eBookERP1ProvisionOpps:' + eBookERP1ProvisionOpps);
            if (eBookERP1ProvisionOpps.size() > 0) {
                opportunityTriggerUtils.provisionEBook(eBookERP1ProvisionOpps,'ERP Exam Part I');
            }
            
            system.debug('eBookERP2ProvisionOpps:' + eBookERP2ProvisionOpps);
            if (eBookERP2ProvisionOpps.size() > 0) {
                opportunityTriggerUtils.provisionEBook(eBookERP2ProvisionOpps,'ERP Exam Part II');
            }
        }
        
    }
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}