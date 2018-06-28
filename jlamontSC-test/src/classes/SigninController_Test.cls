//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Test Class for SigninController 
//  16 June 2014    Virendra (Appirio)     Original
//**********************************************************************/
@isTest
private class  SigninController_Test {
    @IsTest
    static void testSignIn () {  
        
		// VB: 2/9/15: Why is this doing the below code?  
		//		the usr object is never used, is it?
		//		Commenting out the below 'update usr role section'      
		//
        //update current user role
        //list<UserRole> usrRole = [SELECT ID FROM UserRole];
        //User usr = new User(Id = UserInfo.getUserId());
        //system.runas(usr){
        //    if(usrRole.size()>0){
        //        usr.UserRoleId = usrRole.get(0).Id;
        //    }
        //    update usr;
        //}
        
        SigninController  sController = new SigninController();
        sController.login();
        sController.siteURL = '/testSite';
        System.assert(sController.getEncodedSiteUrl() != null);
        System.assert(sController.getEncodedStartUrl() != null);
    }
}