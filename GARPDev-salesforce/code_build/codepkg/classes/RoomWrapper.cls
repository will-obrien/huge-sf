global class RoomWrapper implements Comparable {

    public Room__c room;
    
    // Constructor 
    
    public RoomWrapper(Room__c m) {
        room = m;
    }
    
    // Compare room items based on the room capacity. 
    
    global Integer compareTo(Object compareTo) {
        // Cast argument to RoomWrapper 
    
        RoomWrapper compareToMerch = (RoomWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal. 
    
        Integer returnValue = 0;
        if (room.Capacity__c > compareToMerch.room.Capacity__c) {
            // Set return value to a positive value. 
    
            returnValue = 1;
        } else if (room.Capacity__c < compareToMerch.room.Capacity__c) {
            // Set return value to a negative value. 
    
            returnValue = -1;
        }
        
        return returnValue;       
    }
}