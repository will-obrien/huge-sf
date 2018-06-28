@isTest
private  class venue2TestSite_test {
    
    static  Site__c  s;
	static Venue__c v;
    
    static testMethod void unit_test()
    {
        //testdata();
        test.startTest();
        s = new Site__c(Name = 'USA, FL, Tampa',Display_Address__c='USA, FL, Tampa', Site_Code__c = '111',RPT_Venue_Address__c = '');
        insert s;
       
        v = new Venue__c(Name='Nov 2015 USA, FL, Tampa', Active__c = True, Site__c = s.id, Building_Name__c = 'Tampa Marriott Westshore',Address1__c='1001 N. Westshore Boulevard',Address2__c='Salon A',City__c='Tampa',State__c='FL',Zipcode__c='33174',Country__c='USA');
        insert v;
        test.stopTest();
        
    }
}