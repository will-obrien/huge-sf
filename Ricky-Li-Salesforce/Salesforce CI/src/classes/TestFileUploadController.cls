@isTest(SeeAllData=true)
Public Class TestFileUploadController{
    static testmethod void TestFileUpload(){
         //Instantiate the controller
         FileUploadController ctl = new FileUploadController();
    
        //Grab the reference to the document and populate it
        Document doc = ctl.document;
        doc.Name = 'TESTDOC123456789';
        doc.body = Blob.valueOf('I am a test');
        doc.Description = 'Test Description';
        
        //Run the upload method
        ctl.upload();
        
        //Make sure it worked by querying for the 
        //document that was just created.
        List<Document> docs = [SELECT ID 
                FROM Document 
                WHERE NAME = 'TESTDOC123456789'];
        System.assertEquals(1, docs.size()); 
    }
}