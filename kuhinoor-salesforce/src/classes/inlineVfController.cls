public class inlineVfController{
    public contact con{get;set;}
    public Attachment att{get;set;}
    public String image{get;set;}
    public inlineVfController(Apexpages.standardController obj){
        contact condetails=(contact)obj.getrecord();
        con=[select id,firstname,lastname from contact where id=:condetails.id];
        //att=[select id from Attachment  where parentId =:con.id ]; 
    }
}