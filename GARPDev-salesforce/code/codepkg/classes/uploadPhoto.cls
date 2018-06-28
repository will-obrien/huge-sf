public class uploadPhoto {
    
    public transient Blob blobValue { get; set; }
    public transient String contentType { get; set; }
    public transient String filename { get; set; }
    public Id userId { get; set; }
    public String uploadError { get; set; }
    
    public class customException extends Exception {}
    
    public String getLargePhotoUrl() {
        return ConnectApi.ChatterUsers.getPhoto(
            Network.getNetworkId(), userId).largePhotoUrl;
    }
    
  
    public PageReference removePhoto() {        
        ConnectApi.ChatterUsers.deletePhoto(Network.getNetworkId(), userId);   
        PageReference pageRef = new PageReference('/apex/uploadPhotoWait');        
        pageRef.setRedirect(true);
        return pageRef;
    }

  
    public PageReference upload() {       
        
        PageReference pageRef = Apexpages.currentPage();
        try {        
            ConnectApi.BinaryInput photoFileInput = new ConnectApi.BinaryInput(blobValue, contentType, filename);
            ConnectApi.ChatterUsers.setPhoto(Network.getNetworkId(), userId, photoFileInput);
            pageRef = new PageReference('/apex/uploadPhotoWait');        
            pageRef.setRedirect(true);
        } catch(Exception e) {
            uploadError = 'There was an error uploading your photo, it may be too large.';
    	}
        return pageRef;
    }
}