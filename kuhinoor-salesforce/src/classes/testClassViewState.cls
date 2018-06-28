public class testClassViewState{
    public List<Attachment> attachmentList {get;set;}
    public testClassViewState(){
        attachmentList  = [SELECT id,name,body FROM attachment];
    }
}