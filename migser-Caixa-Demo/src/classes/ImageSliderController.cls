public with sharing class ImageSliderController {
    @AuraEnabled
    public static List<string> getImages(string recordId, string childObj, string childImgField, string childLookup) {
		List<string> imageUrls = new List<string>();
        string query = 'SELECT ' + childImgField + ' FROM ' + childObj
            + ' WHERE ' + childLookup + ' = \'' + recordId + '\' AND ' + childImgField + ' != null';
        system.debug(query);
        List<sObject> objs = Database.query(query);
        for (sObject obj : objs) {
            string imageUrl = (string)obj.get(childImgField);
            imageUrls.add(imageUrl);
        }
        return imageUrls;
    }
}