/*
--> CreatedBy       :Ratan Paul
--> CreadtedDate    :06/Sep/2015
*/
public with sharing class RN_GenericTableCtrl 
{
	public String stringQuery {get;set;}
	
	public String getstrRecordJson()
	{
		return JSON.serialize(Database.query(stringQuery));
	}
}