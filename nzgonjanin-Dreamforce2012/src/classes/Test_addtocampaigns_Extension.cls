@isTest
private class Test_addtocampaigns_Extension {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
    	list<Campaign> InsertCampaigns=new list<Campaign>();   
        Campaign myCampaign = new Campaign (
        			Name='Test Tour Registration',
   					Type='Tour',
   					Status='In Progress',
   					StartDate=date.today().addDays(1),
   					IsActive=true,
   					EndDate=date.today().addDays(365)
        );
        InsertCampaigns.Add(myCampaign);
        Campaign myCampaign1 = new Campaign (
        			Name='Test Tour Registration',
   					Type='Tour',
   					Status='In Progress',
   					StartDate=date.today().addDays(2),
   					IsActive=true,
   					EndDate=date.today().addDays(365)
        );
        InsertCampaigns.Add(myCampaign1);
        Campaign myCampaign2 = new Campaign (
        			Name='Test Tour Registration',
   					Type='CIP',
   					Status='In Progress',
   					StartDate=date.today().addDays(1),
   					IsActive=true,
   					EndDate=date.today().addDays(365)
        );
        InsertCampaigns.Add(myCampaign2);
        Campaign myCampaign3 = new Campaign (
        			Name='Web Request',
   					Type='CIP',
   					Status='In Progress',
   					StartDate=date.today().addDays(-2),
   					IsActive=true,
   					EndDate=date.today().addDays(365)
        );
        InsertCampaigns.Add(myCampaign3);
        insert (InsertCampaigns);
        
        //Test participant Lead
		Lead myLead=new Lead( FirstName='Nebojsa',
        					  LastName='Zgonjaniny',
        					  Company='Test Co',
        					  Status='Applied',
        					  LeadSource='Other', 
        					  Email='nzgonjaniny@rogers.com',
        					  Country='Canada'
        );
        insert myLead;
      
        CampaignMember LeadCM = new CampaignMember(CampaignId=myCAmpaign3.Id,
        											LeadId=myLead.Id);
        insert LeadCM;
        PageReference pageRef = new PageReference('/apex/addtocampaigns?pid='+myLead.Id);
        Test.setCurrentPage(pageRef);
        
		addtocampaigns_Extension controller = new addtocampaigns_Extension(new ApexPages.StandardController(myCampaign3));
		//test empty selection
		controller.Submit();
		//select something
		controller.SelectAll();
		controller.Submit();
		controller.GoToParticipant();
		
		//assert processed records for lead
		controller = new addtocampaigns_Extension(new ApexPages.StandardController(myCampaign3));
		boolean AllSelected=true;
		for (addtocampaigns_Wrapper Camp :controller.Campaign_List){
			if (Camp.disabled==false){
				AllSelected=false;
			}
		}
		System.assert(AllSelected);
		
		
		//Test participant Contact
		Contact myContact=new Contact( FirstName='Nebojsa',
        					  LastName='Zgonjanin',
        					  Email='nzgonjaniny@rogers.com'
        );
        insert myContact;
        CampaignMember ContactCM = new CampaignMember(CampaignId=myCampaign3.Id,
        											ContactId=myContact.Id);
        insert ContactCM;
      	pageRef = new PageReference('/apex/addtocampaigns?pid='+myContact.Id);
        Test.setCurrentPage(pageRef);
        
		controller = new addtocampaigns_Extension(new ApexPages.StandardController(myCampaign3));
		//test empty selection
		controller.Submit();
		//select something
		controller.SelectAll();
		controller.Submit();
		controller.GoToParticipant();
		controller.FilterSetting();
		
		//test DMLException 
		delete myCampaign3;
		controller.Submit();
		
		//assert processed records for contact
		controller = new addtocampaigns_Extension(new ApexPages.StandardController(myCampaign3));
		AllSelected=true;
		for (addtocampaigns_Wrapper Camp :controller.Campaign_List){
			if (Camp.disabled==false){
				AllSelected=false;
			}
		}
		System.assert(AllSelected);
		
       }//end of myUnitTest()
}//end of test class