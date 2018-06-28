public class GroupDAO {
    
    private static map<Id, Group> mapGroups;
    private static map<Id, Group> mapGroupsQueueType;
    private static List<Group> listGroups;
    private static List<Group> listGroupsQueueType;
    
    public static map<Id, Group> mapGroups(){
        
        if(mapGroups == null){
            mapGroups =new map<Id, Group>();
            for(Group g : [SELECT Id, Name FROM Group ]){
                mapGroups.put(g.Id, g);
            }
        }
        
        return mapGroups;
    }
    
    public static map<Id, Group> mapGroupsQueueType(){
        
        
        if(mapGroupsQueueType == null){
            mapGroupsQueueType = new map<Id, Group>();
            for(Group g : [SELECT Id, Name FROM Group WHERE Type = 'Queue']){
                mapGroupsQueueType.put(g.Id, g);
            }
        }
        
        return mapGroupsQueueType;
    }
    
    public static List<Group> listGroups(){
        
        if(listGroups == null){
            listGroups = [SELECT Id, Name FROM Group];
        }
        
        return listGroups;
    }    
    
    public static List<Group> listGroupsQueueType(){
        
        if(listGroupsQueueType == null){
            listGroupsQueueType = [SELECT Id, Name FROM Group WHERE Type = 'Queue'];
        }
        
        return listGroupsQueueType;
    }
    
    public static Group getGroupQueueByName(String Name){
        return [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name =: Name];
    }
    
}