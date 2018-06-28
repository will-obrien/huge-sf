public with sharing class ExpenseType {
	
	private static Set<Type> MOVEMENT = new Set<Type>{ Type.Flight, Type.TrainRide, Type.PrivateVehicleRide, Type.CompanyVehicleRide, Type.SeaTravel };
	private static Map<Type, Id> rtIdByType;
	private static Map<Id, Type> rtTypeById;
	
	static {
		rtIdByType = new Map<Type, Id>();
		rtTypeById = new Map<Id, Type>();
		
		for(RecordType rt : [SELECT Id, DeveloperName
						 	 FROM RecordType
						 	 WHERE SobjectType = 'UP2GO_ITE__Expense__c']) {
			for(Type type : Type.values()) {
				
				if(type.name() == rt.DeveloperName) {
					rtIdByType.put(type, rt.Id);
					rtTypeById.put(rt.Id, type);
				}	 	 	
	 	 	}		 	 	
		}
	}
	
	
	// PUBLIC METHDOS
	
	public static Boolean isMovement(Expense__c record) {
		Boolean result = is(MOVEMENT, record);
		
		return result;
	}
	
	
	public static Boolean isFlight(Expense__c record) {
		Boolean result = is(Type.Flight,record);
		
		return result;
	}
	
	
	public static Boolean isTrainRide(Expense__c record) {
		Boolean result = is(Type.TrainRide,record);
		
		return result;
	}
	
	
	public static Boolean isSeaTravel(Expense__c record) {
		Boolean result = is(Type.SeaTravel,record);
		
		return result;
	}	
	
	
	public static Boolean isPrivateVehicle(Expense__c record) {
		Boolean result = is(Type.PrivateVehicleRide, record);
		
		return result;
	}
	
	
	public static Boolean isCompanyVehicle(Expense__c record) {
		Boolean result = is(Type.CompanyVehicleRide, record);
		
		return result;
	}	
	
	
	public static Boolean isRentalVehicle(Expense__c record) {
		Boolean result = is(Type.RentalVehicle, record);
		
		return result;
	}
	
	
	public static Boolean isAccommodation(Expense__c record) {
		Boolean result = is(Type.Accommodation, record);
		
		return result;
	}
	
	
	public static Boolean isEntertainment(Expense__c record) {
		Boolean result = is(Type.Entertainment, record);
		
		return result;
	}	
		
		
	public static Boolean isMiscellaneous(Expense__c record) {
		Boolean result = is(Type.Miscellaneous, record);
		
		return result;
	}				
	
	
	public static Boolean isPerDiem(Expense__c record) {
		Boolean result = is(Type.perDiem, record);
		
		return result;
	}		
	
	
	public static Set<Id> getMovementRecordTypeIds() {
		Set<Id> results = new Set<Id>();
		
		for(Type t : MOVEMENT) {
			results.add(rtIdByType.get(t));
		}
		
		return results;
	}
	
	
	public static Id getFlightRecordTypeId() {
		Id result = rtIdByType.get(Type.Flight);
		
		return result; 
	}
	
	
	public static Id getPrivateVehicleRecordTypeId() {
		Id result = rtIdByType.get(Type.PrivateVehicleRide);
		
		return result; 
	}
	
	
	public static Id getCompanyVehicleRecordTypeId() {
		Id result = rtIdByType.get(Type.CompanyVehicleRide);
		
		return result; 		
	}
	
	
	public static Id getSeaTravelRecordTypeId() {
		Id result = rtIdByType.get(Type.SeaTravel);
		
		return result;
	}
	
	
	public static Id getTrainRideRecordTypeId() {
		Id result = rtIdByType.get(Type.TrainRide);
		
		return result; 			
	}
		
	
	public static Id getRentalVehicleRecordTypeId() {
		Id result = rtIdByType.get(Type.RentalVehicle);
		
		return result; 
	}
	
	
	public static Id getAccommodationRecordTypeId() {
		Id result = rtIdByType.get(Type.Accommodation);
		
		return result; 
	}
	
	
	public static Id getEntertainmentRecordTypeId() {
		Id result = rtIdByType.get(Type.Entertainment);
		
		return result; 			
	}
	
	
	public static Id getMiscellaneousRecordTypeId() {
		Id result = rtIdByType.get(Type.Miscellaneous);
		
		return result; 			
	}
	
	
	public static Id getPerDiemRecordTypeId() {
		Id result = rtIdByType.get(Type.perDiem);
		
		return result; 			
	}	
	
		
	public static String getRecordTypeName(Id recordTypeId) {
		String result = rtTypeById.get(recordTypeId)!= null ? rtTypeById.get(recordTypeId).name() : null;
		
		return result;
	}
	
	
	// PRIVATE METHODS
	
	private static Boolean is(Type type,Expense__c record) {
		Boolean result = (rtTypeById.get(record.RecordTypeId).name() == type.name());
		
		return result;
	}
	
	
	private static Boolean is(Set<Type> types, Expense__c record) {
		Boolean result = false;
		String name = rtTypeById.get(record.RecordTypeId).name();

		for(Type t : types) {
			if(name == t.name()) {
				result = true;
			}
		}

		return result;
	}
	
	
	// ENUM
	
	public enum Type {
		// Note: enum values must match RecordType names. Therefore not UPPERCASE
		Flight, TrainRide, PrivateVehicleRide, CompanyVehicleRide, SeaTravel, Accommodation, RentalVehicle, Miscellaneous, Entertainment, perDiem
	}
}