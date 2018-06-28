//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Test Class for UpdateMemberInfoController 
//  8 March 2014    Virendra (Appirio)     Original
//**********************************************************************/
@isTest
private class  UpdateMemberInfoWebServiceTest {
    
    public static User newUser;
    
    static{
         SignUpWebService2.SignUpResult result = SignUpWebService2.createuser('Tim','Parker','tparker+test100@appirio.com','555-555-1212','Dr.','Jr.','pwd123321',null,'websysId1','AddUP','714ZSCAU00','Appirio','760 Market St',
                                       null,'San Francisco', 'CA', '94102', 'US', 'Yes');
         list<User> listusr = [SELECT ID From User Where Email = 'tparker+test100@appirio.com'];
         newUser = listusr[0];                                  
    }
    
    @IsTest
    static void testUpdateMemberInfoWebService() {
        //assert contact first name is updated
        test.startTest();
        system.debug('::::New User ::'+newUser);   
       
        //call webservice for current user field changes
        UpdateMemberInfoWebService.updateUserContact('Tim1','Parker1','tparker+testNew@appirio.com','555-555-1234','Dr.','Jr.',
                                     'ciitdc#123', newUser.Id,'760 Market St',null,'San Francisco', 'CA', '94102', null);
                                     
        //call webservice for current user field changes
        UpdateMemberInfoWebService.updateUserContact('Tim1','Parker1','tparker+testNew@appirio.com','NULL','Dr.','Jr.',
                                     'ciitdc#123', newUser.Id,'760 Market St',null,'San Francisco', 'CA', '94102', 'US');
        test.stopTest();                               
    }

}