/* Modified By : Subodh Bahl
 * Date : December 3rd 2012
 * Brochure Request Controller
 */

public with sharing class Brochure_Request_Controller {
    public Brochure_Request__c brochureRequest {get; set;}
    
    private List<wBrochure> listBrochures = new List<wBrochure>(); 
    
    public Brochure_Request_Controller(ApexPages.StandardController controller) {
        this.brochureRequest = (Brochure_Request__c)controller.getRecord();
        this.brochureRequest.Requested_Date__c = Date.today();
    } 
    
    public string getRequestorCountry()
    {
            string requestorCountry = '';
            string ISOCountry;
            
            //Traveller
            if(this.brochureRequest.Account__c != null)
            {
                List<Account> travellers = [select BrochureCountry__c, ISOCountry__pc from Account where Id = : this.brochureRequest.Account__c];
                if(travellers.size() > 0){
                   ISOCountry = travellers[0].ISOCountry__pc;
                   if(ISOCountry != null)
                      requestorCountry = ISOCountry;
                   else
                      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check the Billing or the shipping country on the Traveller record!'));  
                }
                else{
                    requestorCountry = '';
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check the Billing or the shipping country on the Traveller record!'));
                }    
            } 
            //Agent
            else {
                
                if(this.brochureRequest.Agent__c != null)
                {
                    List<Contact> travellers = [select BrochureCountry__c, ISOCountry__c from Contact where Id = : this.brochureRequest.Agent__c];
                    if(travellers.size() > 0){
                       ISOCountry = travellers[0].ISOCountry__c;
                       if(ISOCountry != null)
                          requestorCountry = ISOCountry;
                       else
                          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check the Billing or the shipping country on the Agent record!'));  
                    }
                    else
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check the Billing or the shipping country on the Agent record!'));
                } 
                
                //Agency
                else {
                    if(this.brochureRequest.AgencyAccount__c != null)
                    {
                        List<Account> travellers = [select BrochureCountry__c, ISOCountry__c from Account where Id = : this.brochureRequest.AgencyAccount__c];
                        if(travellers.size() > 0){
                           ISOCountry = travellers[0].ISOCountry__c;
                           if(ISOCountry != null)
                              requestorCountry = ISOCountry;
                           else
                              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check the Billing or the Shipping Country on the Agency record!'));  
                        }
                        else
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check the Billing or the Shipping Country on the Agency record!'));
                     }
                         //Leads
                         else {
                        if(this.brochureRequest.Lead__c != null)
                        {
                            List<Lead> travellers = [select Country from Lead where Id = : this.brochureRequest.Lead__c];
                            if(travellers.size() > 0)
                                requestorCountry = travellers[0].Country;
                            else
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please check the Country on the Lead record!'));    
                        }
                    }
                }
            }   
            System.Debug(requestorCountry);
            return requestorCountry;
    }
    
    public List<wBrochure> getBrochures() {
      string requestorCountry = getRequestorCountry();
      System.Debug(requestorCountry);
      if(requestorCountry.length() == 2){ 
        for(Brochure__c b : [select Id, Name, Description__c, Image_URL__c, Internal_Description__c
                    , Countries_Not_Eligible__c  
                    from Brochure__c 
                                where Inactive__c != true Order by Web_Display_Order__c])
        {
            if(b.Countries_Not_Eligible__c==null || !b.Countries_Not_Eligible__c.contains(requestorCountry)) {
                listBrochures.add(new wBrochure(b));
            }    
        } 
        return listBrochures;
      }
      else{
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please verify the Mailing or Location Country on the Record. We are unable to return the list of Brochures for this specific record.'));
         return null;   
      }     
    }
    
    public PageReference processBrochureRequest() {
        try
        {
            integer totalQty = 0;
            
            for(wBrochure b: ListBrochures)
            {
                if(b.Qty > 0) totalQty++;
            }
            
            string infoMessage = '';
            If(brochureRequest.Agent__c != null)
            {
                brochureRequest.AgencyAccount__c = brochureRequest.Agent__r.AccountId;
            }
            
            if(totalQty > 0)
            {
                upsert brochureRequest;
                System.debug('brochureRequest.Id: ' + brochureRequest.Id);
                List<Brochure_Request_Item__c> listBRI = new List<Brochure_Request_Item__c>();
                
                for(wBrochure b: ListBrochures)
                {
                    if(b.Qty > 0)
                    {
                        brochure_Request_Item__c bri = new Brochure_Request_Item__c();
                        bri.Qty__c = b.Qty;
                        bri.Brochure_Request__c = this.brochureRequest.Id;
                        bri.Brochure__c = b.Brochure.Id;
                        listBri.add(bri);
                    }
                            
                }
                
                insert ListBri;
                System.debug('brochureRequestItem.size(): ' + ListBri.size());
            
                
                
                PageReference brochureRequestPage = new ApexPages.StandardController(brochureRequest).view();
                brochureRequestPage.setRedirect(true);
                return brochureRequestPage;
            }
            else
            {
                infoMessage = 'You need to request at least one Brochure';
            }
            
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 
                                                                    infoMessage);
            ApexPages.addMessage(myMsg);
            return null;
            
        }
        
        
        catch(DMLException e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;

        }
        
          
    }
    
    public static testMethod void testMe ()
    {
       try{
            Account traveller = TestData.createTraveller();
            Account agency = TestData.createAgency();
            Contact agent = TestData.createAgent(agency);
            
            
            Lead testLead = TestData.createLead();
            Brochure__c sampleBrochure = TestData.createBrochure();
            Brochure__c sampleRestrictedBrochure = TestData.createRestrictedBrochure();
            
            
            //1) Traveller Brochure Request
            Brochure_Request__c brochureRequestSample = new Brochure_Request__c(Account__c = traveller.Id, Requested_Date__c = Date.today());
            insert brochureRequestSample;
            brochureRequestSample = [select Id, Account__c, Lead__c, AgencyAccount__c, Agent__c, Name 
                                        from Brochure_Request__c where Id = : brochureRequestSample.Id];
                                        
            PageReference pageRef = Page.BrochureRequest;
            Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController sc = new ApexPages.standardController(brochureRequestSample);
            Brochure_Request_Controller brochureRequestController = new Brochure_Request_Controller(sc);
            System.AssertEquals(traveller.ISOCountry__pc ,brochureRequestController.getRequestorCountry());
            List<wBrochure> listBrochures = brochureRequestController.getBrochures();
            listBrochures[0].sQty = '5';
            System.assertEquals(5, listBrochures[0].Qty);
            
            PageReference nextpage = brochureRequestController.processBrochureRequest();
            system.assertEquals(nextpage.getUrl(), new ApexPages.StandardController(brochureRequestSample).view().getUrl());
            List<Brochure_Request_Item__c> listBRI = [select Id, Name from Brochure_Request_Item__c where Brochure__c = : brochureRequestSample.Id];
            
            //2) Agency Brochure Request
            brochureRequestSample = new Brochure_Request__c(AgencyAccount__c = agency.Id, Requested_Date__c = Date.today());
            insert brochureRequestSample;
            brochureRequestSample = [select Id, Account__c, Lead__c, AgencyAccount__c, Agent__c, Name 
                                        from Brochure_Request__c where Id = : brochureRequestSample.Id];
                                        
            sc = new ApexPages.standardController(brochureRequestSample);
            brochureRequestController = new Brochure_Request_Controller(sc);
            System.AssertEquals(agency.BillingCountry ,brochureRequestController.getRequestorCountry());
            nextpage = brochureRequestController.processBrochureRequest();
            system.assertEquals(nextpage.getUrl(), new ApexPages.StandardController(brochureRequestSample).view().getUrl());
            
            //3) Agent Brochure Request
            brochureRequestSample = new Brochure_Request__c(Agent__c = agent.Id, Requested_Date__c = Date.today());
            insert brochureRequestSample;
            brochureRequestSample = [select Id, Agent__c, Name, Agent__r.AccountId 
                                        from Brochure_Request__c where Id = : brochureRequestSample.Id];
                                        
            sc = new ApexPages.standardController(brochureRequestSample);
            brochureRequestController = new Brochure_Request_Controller(sc);
            System.AssertEquals(agent.BrochureCountry__c ,brochureRequestController.getRequestorCountry());
            nextpage = brochureRequestController.processBrochureRequest();
            system.assertEquals(nextpage.getUrl(), new ApexPages.StandardController(brochureRequestSample).view().getUrl());
            
            //3) Lead Brochure Request
            brochureRequestSample = new Brochure_Request__c(Lead__c = testLead.Id, Requested_Date__c = Date.today());
            insert brochureRequestSample;
            brochureRequestSample = [select Lead__c, Name 
                                        from Brochure_Request__c where Id = : brochureRequestSample.Id];
            sc = new ApexPages.standardController(brochureRequestSample);
            brochureRequestController = new Brochure_Request_Controller(sc);
            System.AssertEquals(testLead.Country ,brochureRequestController.getRequestorCountry());
            nextpage = brochureRequestController.processBrochureRequest();
            system.assertEquals(nextpage.getUrl(), new ApexPages.StandardController(brochureRequestSample).view().getUrl());
       }
       
       catch(Exception e)
       {
            System.Debug('Error Brochure_Request_Controller - testMe: ' + e);
       }
       
    }

}