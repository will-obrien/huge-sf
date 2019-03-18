public class TreeViewRoleHierarchyController {
	 public Boolean selectable {get; set;}
    
    public String selectNodeKeys {get; set;}
    {
        selectable = false;
        selectNodeKeys = 'No value selected';
    }
    
    public String JsonData {get; set;}
    
    public String roleOrUserId {get; set;}
    
    public String getJsonString() 
    {
        if (JsonData == null){
            JsonData = TreeViewRoleUtil.getTreeJSON(roleOrUserId);
        }
        //System.Debug('getJsonString : '+JsonData);
        return JsonData;
    }
     
}