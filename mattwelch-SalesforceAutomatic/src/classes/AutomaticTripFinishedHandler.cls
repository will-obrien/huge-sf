/***************************************
* AutomaticTripFinishedHandler.cls
* Handles the trip:finished automatic
* webhook callout type
***************************************/
public with sharing class AutomaticTripFinishedHandler implements IAutomaticHandler {
	public Boolean handleWebhook(Map<String, Object> webhookRequestBody) {
    	Map<String, Object> vehicle=(Map<String, Object>)webhookRequestBody.get('vehicle');
    	Map<String, Object> trip=(Map<String, Object>)webhookRequestBody.get('trip');
    	Map<String, Object> autoUser=(Map<String, Object>)webhookRequestBody.get('user');

    	String vehicleId=(String)vehicle.get('id');
    	String autoUserId=(String)autoUser.get('id');
    	Vehicle__c v;
    	// Let's see if we have an existing vehicle with the request body's vehicle's automatic id (which
    	// we've set as a unique, external id in salesforce)
    	try {
			v=[select id, name, automatic_id__c, year__c, make__c, model__c, color__c from Vehicle__c where automatic_id__c = :vehicleId];
    	}
    	Catch (Exception e) {
    		// If not, create a new vehicle
    		v=new Vehicle__c();
    		v.Automatic_Id__c=(String)vehicle.get('id');
    		v.name=(String)vehicle.get('display_name');
    		v.year__c=String.valueOf((Integer)vehicle.get('year'));
    		v.make__c=(String)vehicle.get('make');
    		v.model__c=(String)vehicle.get('model');
    		v.color__c=(String)vehicle.get('color');
    		insert v;
    	}

    	// Now let's get the driver of the vehicle, found by matching the request body user id with an authentication custom setting
    	// for thenAutomatic user id we saved. We're querying our hierarchiical custom object using SOQL here, rather than the
    	// regular getInstance method
    	String userId;
    	try {
    		AutomaticAPI__c aAPI= [select id, SetupOwnerId from AutomaticAPI__c where Automatic_Id__c = :autoUserId];
    		userId=aAPI.SetupOwnerId;
    	}

    	// For our purposes, we won't handle the case where we can't find a user, and will just leave this info blank in our
    	// final saved record
    	Catch (Exception e) {
    	}

    	// Now let'e create a new trip, populating it with information from the request body. (Note all the casting we
    	// have to do.)
    	Trip__c t=new Trip__c();
    	t.Driver__c = userId;
    	t.uri__c=(String)trip.get('uri');
    	t.Automatic_Id__c=(String)trip.get('id');
    	t.Start_Time__c=Datetime.newInstance((Long)trip.get('start_time'));
    	t.Start_Time_Zone__c=(String)trip.get('start_time_zone');
    	t.End_Time__c=Datetime.newInstance((Long)trip.get('end_time'));
    	t.End_Time_Zone__c=(String)trip.get('end_time_zone');
    	t.Path__c=(String)trip.get('path');
    	t.Vehicle__c=v.id;
    	t.MPG__c=(Double)trip.get('average_mpg');
    	t.Distance_Meters__c=(Double)trip.get('distance_m');

    	Map<String, Object> startLocation=(Map<String, Object>)trip.get('start_location');
    	t.Start_Location_Name__c=(String)startLocation.get('name');
    	t.Start_Location__Latitude__s = (Double)startLocation.get('lat');
    	t.Start_Location__Longitude__s = (Double)startLocation.get('lon');

    	Map<String, Object> endLocation=(Map<String, Object>)trip.get('end_location');
    	t.End_Location_Name__c=(String)endLocation.get('name');
    	t.End_Location__Latitude__s = (Double)endLocation.get('lat');
    	t.End_Location__Longitude__s = (Double)endLocation.get('lon');

    	try {
    		insert t;
    	}
    	Catch (Exception e) {
    		return false;
    	}
		return true;
	}
}
