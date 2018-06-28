@isTest(seeAllData=true)
private class uploadPhoto_test {

    static testMethod void myUnitTest() {
    	
    	uploadPhoto photo = new uploadPhoto();
    	photo.blobValue = blob.valueOf('test');
    	photo.userId = userinfo.getUserId();
    	photo.contentType = 'jpeg';
    	photo.filename = 'test';
    	photo.getLargePhotoUrl();
    	photo.removePhoto();
    	photo.upload();

    }
}