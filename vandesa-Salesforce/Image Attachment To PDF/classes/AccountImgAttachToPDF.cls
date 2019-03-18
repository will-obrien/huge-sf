public with sharing class AccountImgAttachToPDF {
    @Future(callout=true)
    public static void addPDFAttach(string sessionId, String Title,Id ImgId,Id pId){
        AttImgToPDF.SessionHeader_element sessionIdElement= new AttImgToPDF.SessionHeader_element();
        sessionIdElement.sessionId = sessionId;
 
        AttImgToPDF.Att_Img_To_PDF stub= new AttImgToPDF.Att_Img_To_PDF();
        stub.SessionHeader= sessionIdElement;
        stub.Att_Img_To_PDF(Title, ImgId, pId);
			if(EX_Setting__c.getInstance().Delete_image_render__c)
			{
					attachment att =[select id from attachment where id=: ImgId];
					delete att;
			}        
    }
     
}