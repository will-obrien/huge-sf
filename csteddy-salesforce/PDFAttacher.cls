Global with sharing class PDFAttacher {

    Public Inspection__c inspect;
    
    public PDFAttacher(ApexPages.StandardController controller) {
   
    this.inspect=(Inspection__c)Controller.getRecord();
   
    }
    
    public PageReference attachPDF() {
       Boolean pdfCreate=False;
       String returnPage;
         returnPage=('https://ap1.salesforce.com/'+inspect.id);  
        /* Get the page definition */
        PageReference pdfPage = Page.Green;
         
        /* set the inspect id on the page definition */
        pdfPage.getParameters().put('id',inspect.id);
         
        /* generate the pdf blob */
       // Blob pdfBlob = pdfPage.getContent();
        Blob pdfBlob;
        try{
                 pdfBlob = pdfPage.getContent();
                 pdfCreate=True;
        }
        catch(Exception e){}
        
        
        
        
        /* create the attachment against the PDF */         
        if(pdfCreate==True){
        Attachment a = new Attachment(parentId = inspect.id, name=inspect.name + '.pdf', body = pdfBlob);
         insert a;}
         //return Null;
        
        if(pdfCreate==False){
       String myString = 'StringToBlob';
Blob myBlob = Blob.valueof(myString);
        Attachment b = new Attachment(parentId = inspect.id, name=inspect.name + '.pdf', body = myBlob );
         insert b;
         }
               
        return new PageReference(returnPage);
        /* insert the attachment */         
        
         
        
       /* send the user back to the quote detail page */
       //return controller.view();
    }


}
