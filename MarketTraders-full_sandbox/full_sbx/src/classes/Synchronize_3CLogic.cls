public class Synchronize_3CLogic Extends SynchronizeManager{
    
    private String key = 'OEolr-3e4v733OncgtbUnw7_G9trdFo5vWsF-o7g15SQrwBg362qv-5CX6hUf3DPfCVAXK3wVgzsxwpLkRoUsA';
    private Opportunity opp;
    private boolean userEnabled;
    private boolean previousUserEnabled;
    
    public Synchronize_3CLogic(Opportunity opp) {
        this.opp = opp;
        User currentOwner = [SELECT Id,X3CLogic_Active__c FROM User WHERE Id = :this.opp.OwnerId];
        if(currentOwner != null && currentOwner.X3CLogic_Active__c)
            this.userEnabled = true;
        else
            this.userEnabled = false;
        User previousOwner;
        try{
            previousOwner = [SELECT Id,X3CLogic_Active__c FROM User WHERE Id = :this.opp.X3CLogic_Previous_Owner__c];
        }catch(Exception ex){
             system.debug(ex);       
        }
        if(previousOwner != null && previousOwner.X3CLogic_Active__c)
            this.previousUserEnabled = true;
        else
            this.previousUserEnabled = false;
    }
    
    protected override void implement(SyncLogger logger,SynchronizeResult result) {
        if(this.opp.X3CLogic_Previous_Owner__c != null) { //An Ownership Change took place
            if(previousUserEnabled){
                Lead3CLogic previousLogicLead = new Lead3CLogic(this.opp);
                previousLogicLead.updateOwnerName(this.opp.X3CLogic_Previous_Owner__r.FirstName + ' ' +this.opp.X3CLogic_Previous_Owner__r.LastName);
                this.markLeadProcessed(previousLogicLead,logger);
            }
            if(this.userEnabled && this.opp.X3CLogic_Status__c == 'INSERT'){
                Lead3CLogic logicLead = new Lead3CLogic(this.opp);
                this.insertLead(logicLead,logger);
            }
        }else if(this.userEnabled){
            Lead3CLogic logicLead = new Lead3CLogic(this.opp);
            if(this.opp.X3CLogic_Status__c == 'INSERT'){
                this.insertLead(logicLead,logger);
            }else if(this.opp.X3CLogic_Status__c == 'REPLACE'){
                this.markLeadProcessed(logicLead,logger);
                this.insertLead(logicLead,logger);
            }else if(this.opp.X3CLogic_Status__c == 'REMOVE'){
                this.markLeadProcessed(logicLead,logger);
            }
        }
    }
    
    private void insertLead(Lead3CLogic logicLead,SyncLogger logger) {
        String URL = 'https://svr05.3ccloud.com/ms/portal/leadapi?q=addLead&key='+this.key;
        try{            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            URL += logicLead.getFirstNameParameter();
            URL += logicLead.getLastNameParameter();
            URL += logicLead.getHomePhoneParamter();
            URL += logicLead.getEmailParameter();
            URL += logicLead.getSFIDParameter();
            URL += logicLead.getHiddenParameter();
            URL += logicLead.getStageParameter();
            URL += logicLead.getStagePriorityParameter();
            URL += logicLead.getProjectParameter();
            System.debug('URL to 3Clogic ADD: ' + URL);
            req.setEndpoint(URL);
            req.setMethod('GET');          
            res=h.send(req);
            String responseString = res.getBody().toLowerCase();
            System.debug('URL ADD response: ' + responseString);
            if(!responseString.contains('"result":"success"')){
                system.debug( 'Unable to Insert lead via URL: ' + res.getBody() ); 
                logger.log('Unable to Insert lead via URL: ' + res.getBody()); 
                logger.log(logicLead);
            }
        }catch(Exception ex){
            system.debug(ex);
            logger.log('Unable to Insert Lead: ' + ex.getMessage()); 
            logger.log(logicLead);
        }
    }
    
    private void markLeadProcessed(Lead3CLogic logicLead,SyncLogger logger) {
        String URL = 'https://svr05.3ccloud.com/ms/portal/leadapi?q=markProcessed&key='+this.key;
        try{
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            URL += logicLead.getPhoneParameter();
            URL += logicLead.getProjectParameter();
            URL += logicLead.getResultCodeParameter();
            System.debug('URL to 3Clogic PROCESS: ' + URL);
            req.setEndpoint(URL);
            req.setMethod('GET');    
            res=h.send(req);
            String responseString = res.getBody().toLowerCase();
            System.debug('URL PROCESS response: ' + responseString);
            if(!responseString.contains('"result":"success"')){
                system.debug( 'Unable to Mark Lead Processed via URL: ' + res.getBody() ); 
                logger.log('Unable to Mark Lead Processed via URL: ' + res.getBody()); 
                logger.log(logicLead);
            }
        }catch(Exception ex){
            system.debug(ex);
            logger.log('Unable to Mark Lead Processed: '+ ex.getMessage()); 
            logger.log(logicLead);
        } 
    }
    
}