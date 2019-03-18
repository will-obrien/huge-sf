public class mobileconfig_installer {
    public String uuid {get; set;}
    
    public mobileconfig_installer(ApexPages.StandardController controller) {
        uuid = GuidUtil.NewGuid();
    }
    
    public String getNewUUID(){
        uuid = GuidUtil.NewGuid();
        return uuid;
    }
}