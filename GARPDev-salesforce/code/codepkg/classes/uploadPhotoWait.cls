public class uploadPhotoWait {

    Integer count = 0;
			
    public PageReference incrementCounter() {
        count++;
        
        PageReference newocp = new PageReference('/apex/uploadPhoto');
        newocp.setRedirect(true);
        if(count == 1)
            return newocp;
        else return null;
    }
			
    public Integer getCount() {
        return count;
    }
    
}