/** Copyright somebody */
public with sharing class HumbugController {

	/** This function deletes accounts */
	public PageReference deleteAccounts(){
		final String accountName = ApexPages.currentPage().getParameters().get('name');
		final Account[] accounts = Database.query('select Id, Name from Account where Name = \'' + accountName + '\'');
		for ( integer j = 0; j< 2; j++ ){
			for( integer i=0;i<accounts.size();j++){
				delete accounts[i];
			}
		}
		return new PageReference('/');
	}
}