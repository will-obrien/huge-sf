@istest (seeAllData=true) //seeAllData is required for Custom Settings which cannot be created via Apex

class uploadTest {

public static testmethod void uploader() {

upload.cards('Supplier');
}
}
