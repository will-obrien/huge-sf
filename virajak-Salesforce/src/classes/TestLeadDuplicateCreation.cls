@isTest(SeeAllData=true) 
private class TestLeadDuplicateCreation {
    @isTest static void testDuplicateLead(){
        List<Lead> oldLeadList = new List<Lead>();
        Lead oldLead = new Lead();
        Lead newLead;
        oldLeadList = [Select Id,Email,Phone,LastName from Lead limit 1];
         Database.SaveResult result=null;
       // oldLead = [Select Id,Email,Phone from Lead limit 1];
        newLead = new Lead(Company ='ExtraP',
                            LastName=oldLeadList[0].LastName,
                            Phone=oldLeadList[0].Phone,
                            Email=oldLeadList[0].Email
                          );
        Test.startTest();
        
        try{
            result =  Database.insert(newLead,false);	 
        } catch(Exception e){
            System.assertEquals(true,e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Duplicate Lead:'));
        }    
        Test.stopTest();
        
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size()>0);
        System.assertEquals('Duplicate Lead:'+newLead.LastName,result.getErrors()[0].getMessage());
    }

}