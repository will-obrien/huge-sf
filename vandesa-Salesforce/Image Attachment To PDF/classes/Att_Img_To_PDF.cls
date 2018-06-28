global class Att_Img_To_PDF 
{
    static webservice void Att_Img_To_PDF(String Title,Id ImgId,Id pId)
    {
	            PageReference p = Page.Attach_Img_2_PDF;
				p.getParameters().put('Fileid',ImgId);
                Blob pdfBlob = p.getContent();
                Attachment attPdf = new Attachment();            
                attPdf.ParentId = pId;
                attPdf.Name = Title.left(Title.length()-4)+'.pdf';
                attPdf.Body = pdfBlob;
                insert attPdf;
    }
    
    public static boolean ImageConvertable(String Title,Id ImgId,Id pId){
    	if(Title.right(3)!='jpg' && Title.right(3)!='png' && title.right(4)!='jpeg')
    	{
    		return false;
    	}
    	if (EX_Setting__c.getInstance().Image_attachment_PDF_render_object__c == '')
    	{
    		return false;
    	}
    	if (EX_Setting__c.getInstance().Image_attachment_PDF_render_object__c.ContainsNone(pId.getSObjectType().getDescribe().getName()) && EX_Setting__c.getInstance().Image_attachment_PDF_render_object__c != 'All')
    	{
    		return false;
    	}    	
    	return true;
    }
    
    
}