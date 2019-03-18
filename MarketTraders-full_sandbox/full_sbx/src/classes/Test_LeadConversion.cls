@isTest 
private class Test_LeadConversion {

    private static testMethod void unitTest(){
        
        Webinar__c webinar = new Webinar__c();
        webinar.Name = 'test';
        webinar.Description__c = 'test';
        webinar.Event_Date_Time__c = DateTime.now().addDays(-5);
        webinar.Webinar_Type__c = 'UTP OnDemand';
        webinar.Webinar_ID__c = '102556';
        webinar.Platform__c = 'Talkpoint';
        Database.insert(webinar);
        
        Lead lead = new Lead();
        lead.FirstName = 'Clark';
        lead.LastName = 'Kent';
        lead.leadSource = 'Newspaper';
        lead.Email = 'clark.kent@smallville.com';
        Database.insert(lead);
        
        Lead lead2 = new Lead();
        lead2.FirstName = 'Bruce';
        lead2.LastName = 'Wayne';
        lead2.leadSource = 'Newspaper';
        lead2.Email = 'bruce.wayne@gotham.com';
        Database.insert(lead2);
        
        Referral__c referral = new Referral__c();
        referral.Referred_By_Lead__c = lead.id;
        referral.referred_To_Lead__c = lead2.id;
        referral.Personal_Message__c = 'test';
        Database.insert(referral);
        
        Webinar_Attendance__c webinarAttendance = new Webinar_Attendance__c();
        webinarAttendance.Lead__c = lead.id;
        webinarAttendance.Attended__c = true;
        webinarAttendance.Duration__c = 55;
        webinarAttendance.OnDemand_Attendance_Date__c = Date.today();
        webinarAttendance.OnDemand_Views__c = 1;
        webinarAttendance.Stamp_Type__c = 'OnDemand';
        webinarAttendance.Source_Other__c = 'test';
        webinarAttendance.Registration_Date__c = Date.today().addDays(-7);
        webinarAttendance.Raised_Hands__c = 'Free';
        webinarAttendance.Webinar__c = webinar.Id;
        Database.insert(webinarAttendance);
        
        Lead_Sources__c leadSource = new Lead_Sources__c();
        leadSource.Lead__c = lead.id;
        leadSource.Do_Not_Update_Parent__c = false;
        leadSource.Lead_Source__c = 'test';
        leadSource.Lead_Source_Detail__c = 'test';
        leadSource.Offer__c = 'test';
        leadSource.Offer_Type__c = 'test';
        Database.insert(leadSource);
        
        test.startTest(); 
        //aac 4.15.15 added autoconverter for leads so checking to see if any have not been converted yet
        
        List<Lead> templeadslist = new List<Lead>();
        templeadslist = [Select id, isconverted from Lead where isconverted = false];
        if(templeadslist.size() > 0){
            list<Database.LeadConvert> leadconversions = new list<Database.LeadConvert>();
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            Database.LeadConvert lc = new Database.LeadConvert();            
            lc.setLeadId(templeadslist[0].id);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            leadconversions.add(lc);
            list<Database.LeadConvertResult> lcr = Database.convertLead(leadconversions,false);
            String accountId = lcr[0].getAccountId();
        }
        test.stopTest();
        
    }

}