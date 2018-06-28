global class EXConfigController {
	public string ParentObject{get; set;}
	public EXConfigController(){
		Attachment att = [select ParentId from attachment where id =:ApexPages.currentPage().getParameters().get('fileid') limit 1];
		ParentObject = att.parentid.getSobjectType().getDescribe().Name;
		
	}
}