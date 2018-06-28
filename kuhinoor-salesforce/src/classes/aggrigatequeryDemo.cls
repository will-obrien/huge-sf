public class aggrigatequeryDemo{
    public List<modelClass> models{get;set;}
    public List<AggregateResult> record{get;set;}
    public aggrigatequeryDemo(){
        models = new List<modelClass>();
        record = [ select count(id) scount from contact];
        for( AggregateResult c : record){
                modelClass md = new modelClass ();
                md.count=(integer)c.get('scount'); 
                models.add(md);              
          }
         
    }
    public class modelClass{
        public Integer count{get;set;}
    }
}