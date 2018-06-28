/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest (SeeAllData=true)
private class Test_ChatterAssassin {

    static testMethod void myUnitTest() {
    	Account a = new account();
    	a.name = 'bob';
    	insert a;
    	
    	EntitySubscription es = new EntitySubscription();
    	es.parentID = a.id;
    	es.subscriberID = userInfo.getUserID();
    	
    	insert es;
        FeedItem fi = new feedItem();
        fi.body = 'blachkaldsjfasd';
        fi.parentID = a.id;
        insert fi;
        FeedComment fc = new feedComment();
        fc.feedItemID = fi.id;
        fc.commentBody = 'bladfasf';
        insert fc;
        
        ChatterAssassin ca = new ChatterAssassin();
        ca.getTargets();
        
        for(ChatterAssassin.WrappedPost wp : ca.targetHolder){
        	if(wp.commentList != null && wp.commentList.size() > 0)
        	{
        		wp.commentList[0].deleteMe();
        	} 
        }
        
        
        
        fi = new feedItem();
        fi.body = 'blachkaldsjfasd';
        fi.parentID = a.id;
        insert fi;
        fc = new feedComment();
        fc.feedItemID = fi.id;
        fc.commentBody = 'bladfasf';
        insert fc;
        
        ca.getTargets();
        for(ChatterAssassin.WrappedPost wp : ca.targetHolder){
        	if(wp.commentList != null && wp.commentList.size() > 0)
        	{
        		wp.commentList[0].checked = true;
        	}
        }
        ca.targetHolder[0].checked = true;
        ca.deleteem();
        
    }
}