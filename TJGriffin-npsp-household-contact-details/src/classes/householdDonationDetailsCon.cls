public class householdDonationDetailsCon {
    public List<Opportunity> opps;
    public List<Id> ids;
    private npo02__Household__c hshld; 
    // get household id from page
    public householdDonationDetailsCon(ApexPages.StandardController controller) {
        this.hshld = (npo02__Household__c)controller.getRecord();
    }
    public List<Opportunity> getOpps()
    {
        // get contacts associated with household and store them in a collection
        List<Contact> cons = [SELECT AccountId  FROM Contact WHERE Contact.npo02__Household__r.id = :hshld.id];
        //system.debug('size of contact collection from query on household name');
        //system.debug(cons.size());
         List<Id> ids = new List<Id>();
        for(Contact c : cons) {
            ids.add(c.AccountId);
        }      

        if (ids.isempty())
         return null;

        // retrieve opportunity data based on ids in list
        opps = [Select CloseDate, id, Amount, AccountId, Account.Name, StageName, Campaign.Name, Campaign.Id from Opportunity where Opportunity.Account.id in :ids Order By CloseDate DESC];

         if (opps.isempty())
         return null;
        // return opportunities to render on the page
        return opps;    
    
    
    }
    
      
    public static testMethod void testOppDetails()
    {

        npo02__Household__c h1 =  new npo02__Household__c(Name='Test');
                insert h1;
        npo02__Household__c myhshld = [SELECT ID FROM npo02__Household__c limit 1]; 
        
        Contact con1=new Contact(FirstName='UnitTest 1',LastName='Test',npo02__Household__c = myhshld.id);
        insert con1;
        Contact con = [SELECT Id, AccountId FROM Contact limit 1];  
        Opportunity opp1=new Opportunity(Name='Opp Test 1', AccountId = con.AccountId, Contact__c = con.Id, CloseDate = System.now().date(), StageName = 'Posted' );
        insert opp1;

        
        ApexPages.StandardController sc = new ApexPages.standardController(myhshld);
        // create an instance of the controller
        householdDonationDetailsCon ctrl = new householdDonationDetailsCon(sc);

        
        // check that there is one household
        Integer oppSize=ctrl.getOpps().size();
        System.assert(oppSize>=1);

    }
}