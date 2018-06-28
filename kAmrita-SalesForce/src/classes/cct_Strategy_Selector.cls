public with sharing class cct_Strategy_Selector extends fflib_SObjectSelector implements cct_iStrategy_Selector{
			public static cct_Strategy_Selector newInstance()
				{
					return (cct_Strategy_Selector) cct_Application.Selector.newInstance(Stratergy__c.SObjectType);
				}

			public List<Schema.SObjectField> getSObjectFieldList()
			{
				return new List<Schema.SObjectField> {
						Stratergy__c.Name,
						Stratergy__c.Name__c,
						Stratergy__c.Description__c
					};
			}
		
			public Schema.SObjectType getSObjectType()
			{
				return Stratergy__c.sObjectType;
			}
		
			public List<Stratergy__c> selectById(Set<ID> idSet)
			{
				return (List<Stratergy__c>) selectSObjectsById(idSet);
			}	
}