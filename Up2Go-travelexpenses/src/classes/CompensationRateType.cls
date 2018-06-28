public with sharing class CompensationRateType {
	
	private static Map<Type, Id> rtIdByType;
	private static Map<Id, Type> rtTypeById;
	
	
	private CompensationRateType() {
		// Note: Enforce static nature of this class	
	}
	
	
	static {
		rtIdByType = new Map<Type, Id>();
		rtTypeById = new Map<Id, Type>();
		
		for(RecordType rt : [SELECT Id, Name, DeveloperName 
							 FROM RecordType 
							 WHERE SobjectType = 'UP2GO_ITE__CompensationRate__c']) {
							 	
			for(Type type : Type.values()) {
				if(type.name() == rt.DeveloperName) {
					rtIdByType.put(type, rt.Id);
					rtTypeById.put(rt.Id, type);
				}	 	 	
	 	 	}				 	
		}
	}
	
	
	// PUBLIC METHODS
	
	public static Id getLocationId() {
		Id result = rtIdByType.get(Type.Location);
		
		return result;
	}
	
	
	public static Id getVehicleId() {
		Id result = rtIdByType.get(Type.Vehicle);
		
		return result;
	}
	
	
	public static Id getMealId() {
		Id result = rtIdByType.get(Type.Meal);
		
		return result;
	}
	
	
	public static String getRecordTypeName(Id recordTypeId) {
		String result = (rtTypeById.get(recordTypeId) != null) ? rtTypeById.get(recordTypeId).name() : null;
		
		return result;
	}
	
	
	// ENUM
	
	public enum Type {
		Location, Vehicle, Meal
	}
}