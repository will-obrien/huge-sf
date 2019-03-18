public with sharing class CyclicalNumberManager {
	
	public class CyclicalNumberManagerException extends Exception {}
	
	public static void generateValue(List<Account> acctList, Integer upperBound) {
		Map<String, Cyclical_Number_Generator__c> cycNumGensMap = Cyclical_Number_Generator__c.getAll();
		List<Cyclical_Number_Generator__c> numGens = cycNumGensMap.values();
		
		if (numGens.size() == 1) {
			Cyclical_Number_Generator__c gen = numGens[0];
			Integer currNum = 0;
			currNum = Integer.valueOf(gen.Account_100_Counter__c);
			for (Account updateAcct : acctList) {
				if (updateAcct.Random_1_100__c == null) {
					currNum++;
					if (currNum >= upperBound) {
						currNum = 1;
					}
					updateAcct.Random_1_100__c = currNum;
				}
			}
			gen.Account_100_Counter__c = Decimal.valueOf(currNum);
			update gen;
		}
	}
	
	public static void generateValue(Account updateAcct, Integer upperBound) {
		Map<String, Cyclical_Number_Generator__c> cycNumGensMap = Cyclical_Number_Generator__c.getAll();
		List<Cyclical_Number_Generator__c> numGens = cycNumGensMap.values();
		if ((numGens.size() == 1) && (updateAcct.Random_1_100__c == null)) {
			Cyclical_Number_Generator__c gen = numGens[0];
			Integer currNum = 0;
			currNum = Integer.valueOf(gen.Account_100_Counter__c);
			currNum++;
			if (currNum >= upperBound) {
				currNum = 1;
			}
			updateAcct.Random_1_100__c = currNum;
			gen.Account_100_Counter__c = Decimal.valueOf(currNum);
			update gen;
		}
		else if (numGens.size() != 1) {
			throw new CyclicalNumberManagerException('Error occurred. ' + numGens.size() + ' instances of the Cyclical Number Generator exist.  There should only be a single instance.  Please notify the MTI Salesforce Dev Team.');
		}
	}
	
	public static void generateValue(Lead updateLead, Integer upperBound) {
		Map<String, Cyclical_Number_Generator__c> cycNumGensMap = Cyclical_Number_Generator__c.getAll();
		List<Cyclical_Number_Generator__c> numGens = cycNumGensMap.values();
		if ((numGens.size() == 1) && (updateLead.Random_1_100__c == null)) {
			Cyclical_Number_Generator__c gen = numGens[0];
			Integer currNum = 0;
			currNum = Integer.valueOf(gen.Lead_100_Counter__c);
			currNum++;
			if (currNum >= upperBound) {
				currNum = 1;
			}
			updateLead.Random_1_100__c = currNum;
			gen.Lead_100_Counter__c = Decimal.valueOf(currNum);
			update gen;
		}
		else if (numGens.size() != 1) {
			throw new CyclicalNumberManagerException('Error occurred. ' + numGens.size() + ' instances of the Cyclical Number Generator exist.  There should only be a single instance.  Please notify the MTI Salesforce Dev Team.');
		}
	}
	
	public static void generateValue(List<Lead> acctList, Integer upperBound) {
		Map<String, Cyclical_Number_Generator__c> cycNumGensMap = Cyclical_Number_Generator__c.getAll();
		List<Cyclical_Number_Generator__c> numGens = cycNumGensMap.values();
		
		if (numGens.size() == 1) {
			Cyclical_Number_Generator__c gen = numGens[0];
			Integer currNum = 0;
			currNum = Integer.valueOf(gen.Lead_100_Counter__c);
			for (Lead updateLead : acctList) {
				if (updateLead.Random_1_100__c == null) {
					currNum++;
					if (currNum >= upperBound) {
						currNum = 1;
					}
					updateLead.Random_1_100__c = currNum;
				}
			}
			gen.Lead_100_Counter__c = Decimal.valueOf(currNum);
			update gen;
		}
	}
}