/*********************************************************************
Name : Test_CreateCampaignHistoryFromLead 
Created On : feb 10, 2012 
Created By : Lalit Bohra
Description :Test class for Lead Trigger CreateCampaignHistoryFromLead functionality.
Task :T-27664
**********************************************************************/
@isTest
private class Test_CreateCampaignHistoryFromLead {

    static testMethod void createCampaignHistoryFromLeadUnitTest() {
    	test.startTest();
    	list<Campaign> listCampaign = new list<Campaign>();    	
        Campaign objCampaign= new Campaign();
        objCampaign.Name='Test Campaign';
        objCampaign.CurrencyIsoCode='USD';
        listCampaign.add(objCampaign);
        Campaign objCampaign2= new Campaign();
        objCampaign2.Name='Test Campaign2';
        objCampaign2.CurrencyIsoCode='USD';
        listCampaign.add(objCampaign2);      
        insert listCampaign;
        
        list<Omniture_Campaign_Code__c> listCampaignCode = new list<Omniture_Campaign_Code__c>();
        
        Omniture_Campaign_Code__c objOmniture= new Omniture_Campaign_Code__c();
        objOmniture.Campaign__c=objCampaign.Id;        
        objOmniture.Omniture_Campaign_Code__c='AB:CD:';
        listCampaignCode.add(objOmniture);
        
        Omniture_Campaign_Code__c objOmniture1= new Omniture_Campaign_Code__c();
        objOmniture1.Campaign__c=objCampaign2.Id;
        
        objOmniture1.Omniture_Campaign_Code__c='EF:GH:';
        listCampaignCode.add(objOmniture1);
        insert listCampaignCode; 
         
        list<Lead> LeadList= new list<Lead>(); 
        Lead objLead1= new Lead();
        objLead1.Company='Test Company1';
        objLead1.LastName='Test Lead1';
        objLead1.Status='Open Working';
        objLead1.CurrencyIsoCode='USD';
        objLead1.Omniture_Campaign_Code__c='123';
        objLead1.IM_USER_ID__c='TestUser Id11';
        ObjLead1.Email='Testing@testsite.com';
        ObjLead1.IM_AVGATTENDEES__c=1.0;
        LeadList.add(ObjLead1);
        
        Lead objLead2= new Lead();
        objLead2.Company='Test Company2';
        objLead2.LastName='Test Lead2';
        objLead2.Status='Open Working';
        objLead2.Omniture_Campaign_Code__c='123';
        objLead2.CurrencyIsoCode='USD';
        objLead2.IM_USER_ID__c='TestUser Id12';
        ObjLead2.Email='Testing@testsite.com';
        ObjLead2.IM_AVGATTENDEES__c=1.0;
        LeadList.add(ObjLead2);
       
        insert LeadList;
        objLead1.Omniture_Campaign_Code__c='AB:CD:';
        objLead2.Omniture_Campaign_Code__c='EF:GH:';
        update LeadList;  
        // second blank update is for increasing code coverage.
        update LeadList;  
        test.stopTest();
        
        set<Id> LeadIdset= new set<Id>();
        LeadIdset.add(objLead1.Id);
        LeadIdset.add(objLead2.Id);
        list<CampaignMember> CampaignMemberList=[Select id from CampaignMember where LeadId in:LeadIdset];        
        list<Lead> NewLeadList=[Select id from Lead where id in:LeadIdset and Omniture_Campaign_Code__c= null and Omniture_Campaign_Code_Copy__c !=null];
        if(CampaignMemberList  != null && CampaignMemberList.size()>0 && NewLeadList != null && NewLeadList.size()>0){
        	system.assert(true);
        }
        else{
        	system.assert(false);
        }       
    }
}