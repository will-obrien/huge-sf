/*
// (c) 2014 Appirio, Inc.
//
//	Utility  Class for Test Data Creation 
//	7 March 2014   Virendra(Appirio) 
//  Updated: March 07, 2014  : KapiL Choudhary(Appirio India)
//			 March 21, 2014  : KapiL Choudhary(Appirio India) Rename field for the task T-264724
//           March 18, 2014  : Mark Maslow - Add campaignNumber field and append to Campaign Name
//                             to ensure uniqueness of Campaign Name (and therefore External Id)
*/

public with sharing class TestDataUtility {
   private static Integer campaignNumber=0;

   public Account createNewAccount(Boolean isInsert,String actName,String recordTypeName){
   	 Account act = new Account(Name = actName);
   	 if(recordTypeName != null && recordTypeName != ''){
   	 	act.RecordTypeId = getAccountRecordTypeId(recordTypeName);
   	 }
   	 if(isInsert){
   	 	insert act;
   	 }
     return act;
   }
  
   public Contact createNewContact(Boolean isInsert,String FirstName,String LastName, String recordTypeName , string accountId){
   	 Contact con = new Contact(FirstName = FirstName,LastName = LastName);
   	 if(recordTypeName != null && recordTypeName != ''){
   	 	con.RecordTypeId = getContactRecordTypeId(recordTypeName);
   	 }
   	 if(accountId != null && accountId != ''){
   	 	con.AccountId = accountId;
   	 }
   	 if(isInsert){
   	 	insert con;
   	 }
     return con;
   }
   
   public rC_Bios__Address__c createNewAddress(Boolean isInsert){
	  	rC_Bios__Address__c address = new rC_Bios__Address__c();
	  	address.rC_Bios__Street_Line_1__c = 'One Mountain St';
	  	address.rC_Bios__Street_Line_2__c = 'Street Line 2';
	  	address.rC_Bios__State__c = 'CA';
	  	address.rC_Bios__Country__c = 'USA';
	  	address.rC_Bios__City__c = 'rC_Bios__Address__c';
	  	address.rC_Bios__ZIP__c = '94105';
	  	if(isInsert){
	  		insert address;
	  	}
	  	return address;
   }
   
   public rC_Bios__Account_Address__c createNewValidAccountAddress(Boolean isInsert){
	  	rC_Bios__Account_Address__c actAddress = new rC_Bios__Account_Address__c();
	  	actAddress.rC_Bios__Original_Street_Line_1__c = 'One Mountain St';
	  	actAddress.rC_Bios__Original_Street_Line_2__c = 'Street Line 2';
	  	actAddress.rC_Bios__Original_State__c = 'CA';
	  	actAddress.rC_Bios__Original_Country__c = 'USA';
	  	actAddress.rC_Bios__Original_City__c = 'San Francisco';
	  	actAddress.rC_Bios__Original_Postal_Code__c = '94105';
	  	if(isInsert){
	  		insert actAddress;
	  	}
	  	return actAddress;
   }
   
   public rC_Bios__Contact_Address__c createNewValidContactAddress(Boolean isInsert){
	  	rC_Bios__Contact_Address__c cntAddress = new rC_Bios__Contact_Address__c();
	  	cntAddress.rC_Bios__Original_Street_Line_1__c = 'One Mountain St';
	  	cntAddress.rC_Bios__Original_Street_Line_2__c = 'Street Line 2';
	  	cntAddress.rC_Bios__Original_State__c = 'CA';
	  	cntAddress.rC_Bios__Original_Country__c = 'USA';
	  	cntAddress.rC_Bios__Original_City__c = 'San Francisco';
	  	cntAddress.rC_Bios__Original_Postal_Code__c = '94105';
	  	if(isInsert){
	  		insert cntAddress;
	  	}
	  	return cntAddress;
   }
   
   public rC_Bios__Account_Address__c createNewInvalidAccountAddress(Boolean isInsert){
	  	rC_Bios__Account_Address__c actAddress = new rC_Bios__Account_Address__c();
	  	actAddress.rC_Bios__Original_Street_Line_1__c = 'P11';
	  	actAddress.rC_Bios__Original_Street_Line_2__c = 'Street Line 2';
	  	actAddress.rC_Bios__Original_State__c = 'RJ';
	  	actAddress.rC_Bios__Original_Country__c = 'IN';
	  	actAddress.rC_Bios__Original_City__c = 'San Francisco';
	  	actAddress.rC_Bios__Original_Postal_Code__c = '12345';
	  	if(isInsert){
	  		insert actAddress;
	  	}
	  	return actAddress;
   }
   
   public rC_Bios__Contact_Address__c createNewInvalidContactAddress(Boolean isInsert){
	  	rC_Bios__Contact_Address__c cntAddress = new rC_Bios__Contact_Address__c();
	  	cntAddress.rC_Bios__Original_Street_Line_1__c = 'P11';
	  	cntAddress.rC_Bios__Original_Street_Line_2__c = 'Street Line 2';
	  	cntAddress.rC_Bios__Original_State__c = 'RJ';
	  	cntAddress.rC_Bios__Original_Country__c = 'IN';
	  	cntAddress.rC_Bios__Original_City__c = 'San Francisco';
	  	cntAddress.rC_Bios__Original_Postal_Code__c = '12345';
	  	if(isInsert){
	  		insert cntAddress;
	  	}
	  	return cntAddress;
   }
   
   public rC_Bios__Address__c createNewInvalidAddress(Boolean isInsert){
	  	rC_Bios__Address__c address = new rC_Bios__Address__c();
	  	address.rC_Bios__Street_Line_1__c = 'P11';
	  	address.rC_Bios__Street_Line_2__c = 'Street Line 2';
	  	address.rC_Bios__State__c = 'RJ';
	  	address.rC_Bios__Country__c = 'IN';
	  	address.rC_Bios__City__c = 'San Francisco';
	  	address.rC_Bios__ZIP__c = '94105';
	  	if(isInsert){
	  		insert address;
	  	}
	  	return address;
   }
   
   
   
   public rC_Bios__Address__c createNewValidAddress(Boolean isInsert){
	  	rC_Bios__Address__c address = new rC_Bios__Address__c();
	  	address.rC_Bios__Street_Line_1__c = 'One Mountain St';
	  	address.rC_Bios__Street_Line_2__c = 'Street Line 2';
	  	address.rC_Bios__State__c = 'CA';
	  	address.rC_Bios__Country__c = 'USA';
	  	address.rC_Bios__City__c = 'San Francisco';
	  	address.rC_Bios__ZIP__c = '94105';
	  	if(isInsert){
	  		insert address;
	  	}
	  	return address;
   }
   
   public Id getAccountRecordTypeId(String recordTypeName){
   	  return Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
   }
   
   public Id getContactRecordTypeId(String recordTypeName){
   	  return Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
   }
   
   public Id getOpportunityRecordTypeId(String recordTypeName){
   	  return Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
   }
   
   public rC_Giving__GAU__c createNewGivingGAU(){
   	  rC_Giving__GAU__c givingGAU = new rC_Giving__GAU__c();
   	  givingGAU.Name = 'Test Data GAU';
   	  givingGAU.GivingType__c = 'Donations';
   	  givingGAU.Recipient__c = 'Club';
   	  givingGAU.FundType__c = 'Chapter Funds';
   	  insert givingGAU;
   	  return givingGAU;
   }
   
   public Opportunity createNewGivingOpportunity(){
   	   Opportunity opp = new Opportunity();
   	   opp.name = 'Test Giving';
   	   opp.rC_Giving__GAU__c = createNewGivingGAU().Id;
   	   opp.AccountId = createNewAccount(true,'Test OPp','Household').Id;
   	   opp.CloseDate = system.today().addDays(3);
   	   opp.StageName = 'Completed';
   	   opp.rC_Giving__Projected_Amount__c = 1000;
   	   opp.Campaign = createNewCampaign();
         opp.rC_Giving__Giving_Amount__c = 1110;
   	   opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
         opp.rC_Giving__Giving_Years__c = 2;
         opp.rC_Giving__Giving_Frequency__c = 'Quarterly';
   	   return opp;
   }
   
   public Campaign createNewCampaign(){
   	  campaignNumber ++;
   	  Campaign cmp = new Campaign();
   	  cmp.Name = 'test opp camp' + campaignNumber;
   	  cmp.Type = 'Promotion';
   	  cmp.Status = 'Planned';
   	  insert cmp;
   	  return cmp;
   }
   
   public rC_Giving__Planned_Giving__c createNewPlannedGiving(){
   	  rC_Giving__Planned_Giving__c plannedGiving = new rC_Giving__Planned_Giving__c();
   	  plannedGiving.rC_Giving__Account__c =  createNewAccount(true,'Test plan Giving', 'Household').Id;
   	  plannedGiving.name = 'test planned Giving';
   	  plannedGiving.rC_Giving__Bequest_Type__c = 'Will';
   	  plannedGiving.rC_Giving__Expected_Final_Distribution_Date__c = system.today().addDays(3);
   	  plannedGiving.rC_Giving__Estimated_Giving_Amount__c = 1000;
   	  plannedGiving.rC_Giving__Stage__c = 'Intension';
   	  plannedGiving.Probability__c = 1;
   	  plannedGiving.rC_Giving__Campaign__c = createNewCampaign().id;
   	  plannedGiving.rC_Giving__Revocable__c = true;
   	  plannedGiving.Revocable__c = 'Revocable';
   	  plannedGiving.General_Accounting_Unit__c = createNewGivingGAU().Id;
   	  plannedGiving.Include_in_Forecast__c = true;
   	  insert plannedGiving;
   	  return plannedGiving;
   }
   
   public void createOpportunityFieldSetting(){
   	List<Planned_Giving_Opportunity_Mapping__c> settingMappings = new List<Planned_Giving_Opportunity_Mapping__c>();
   	Planned_Giving_Opportunity_Mapping__c pgOMapping1= new Planned_Giving_Opportunity_Mapping__c();
   	pgOMapping1.Opportunity_Field_Name__c = 'StageName';
   	pgOMapping1.Planned_Giving_Field_Name__c = 'rC_Giving__Stage__c';
   	pgOMapping1.Name = 'Mapping1';
   	settingMappings.add(pgOMapping1);
   	
   	Planned_Giving_Opportunity_Mapping__c pgOMapping2= new Planned_Giving_Opportunity_Mapping__c();
   	pgOMapping2.Opportunity_Field_Name__c = 'Name';
   	pgOMapping2.Planned_Giving_Field_Name__c = 'Name';
   	pgOMapping2.Name = 'Mapping2';
   	settingMappings.add(pgOMapping2);
   
   	Planned_Giving_Opportunity_Mapping__c pgOMapping3= new Planned_Giving_Opportunity_Mapping__c();
   	pgOMapping3.Planned_Giving_Field_Name__c = 'rC_Giving__Expected_Final_Distribution_Date__c';
   	pgOMapping3.Opportunity_Field_Name__c = 'closeDate';
   	pgOMapping3.Name = 'Mapping3';
   	settingMappings.add(pgOMapping3);
   	
   	insert settingMappings;
   }
   
   
   public static User createBDSUser() {
   	
   		// VB: 2/10/15 - Making this query explicit to pick up the 
        list<UserRole> usrRole = [SELECT ID FROM UserRole WHERE Name = 'Administrator'];
        
        Profile p = [select id from profile where name='BSD User' limit 1];
        
        User u1 = new User(
            FirstName='Ray',
            LastName='Test',
            Alias='Test',
            Username='rayinvalid@capgroup.com',
            email='rayinvalid@srclub.com',
            CommunityNickname='raytest',
            TimeZoneSidKey='America/Los_Angeles',
            localesidkey='en_US',
            profileId = p.Id,
            EmailEncodingKey='UTF-8',
            LanguageLocaleKey='en_US',
            UserRoleId = usrRole.get(0).Id
            );
        return u1;
    }
   
   //Select p.Planned_Giving_Field_Name__c, p.Opportunity_Field_Name__c, p.Name From Planned_Giving_Opportunity_Mapping__c p
}