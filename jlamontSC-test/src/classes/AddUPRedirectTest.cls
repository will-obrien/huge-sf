//
// (c) 2014 Appirio, Inc.
//
//  Test Class for AddUPRedirect 
//  1 July 2014    Parul Gupta     Original
//
@isTest
private class AddUPRedirectTest {

    static testMethod void testAddUPRedirect() {
    	AddUPRedirect addUpObj = new AddUPRedirect();
        PageReference pageRef = addUpObj.redirect();
        system.assert(pageRef != null);
    }
}