@isTest
public class TestClass_RecalculateCtrl {
    
    static testmethod void testMyCode() {
        
        Account newAccount = new Account(	Name = 'New Test Account'	);
        insert newAccount;
        
        Opportunity newOppty = new Opportunity(	AccountId = newAccount.Id,
                                               	Amount = 1000,
                                              	Name = 'New Test Oppty',
                                              	StageName = '7. Design Win',
                                              	Production_Start_Date__c = Date.today(),
                                              	CloseDate = Date.today() + 30	);
        insert newOppty;
        
        Campaign__c newCampaign = new Campaign__c(	Name = 'Test Campaign'	);
        insert newCampaign;
        
        Campaign__c fetchCampaign = [	select	Id
                                    	from	Campaign__c];
        
        Campaign_Opportunity__c newCampOppty = new Campaign_Opportunity__c(	Campaign__c = newCampaign.Id,
                                                                          	Opportunity__c = newOppty.Id	); 
        insert newCampOppty;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(fetchCampaign);
        
        //ApexPages.currentPage().setParameters().set('Id') 
        
        RecalculateCtrl testInstance = new RecalculateCtrl(sc);
        testInstance.CampaignId = newCampaign.Id;
        testInstance.recalculate();
        
    }

}