trigger Generate_PDF_From_Img on Attachment (after insert) 
{
	String Title;
	Id pId;
	
	for(Attachment att: Trigger.new)
	{
		Title=att.Name;
		pId=att.ParentId;
		
		if (Att_Img_To_PDF.ImageConvertable(Title,att.id,pId))
		{
			AccountImgAttachToPDF.addPDFAttach(userInfo.getSessionId(),Title,att.id,pId);

		}
	}
}