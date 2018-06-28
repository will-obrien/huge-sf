public class QuickUpsertPopupCont {
    public List<Schema.fieldSetMember> fields {get;set;}
    public Sobject obj {get;set;}
    public String cssId {get; set;}
    public Boolean recordSaved {get{return recordSaved == null? false : recordSaved;} set;}

    public PageReference saveRecord(){
    	try {
            recordSaved = false;
    		upsert obj;
            recordSaved = true;
    	} catch (DmlException e){
    		ApexPages.addMessages(e);
    	}
    	return null;
    }
}