public class p_modelContacts{
    
    public list<modelclass> models{get;set;}
    public List<List<modelclass>> mainModels{get;set;}
    integer i=1;
    public p_modelContacts(){
       mainModels = new List<List<modelclass>>();
        models = new list<modelclass>();
        for(contact con : [select firstname,lastname,email from contact]){
        modelclass md= new modelclass();
          if(math.mod(i,3)==1)
          {
              
              md.contacts=con;
          }
          else if(math.mod(i,3)==2)
          {
              md.con2=con;
          }
          else
          {
              md.con3=con;
              models.add(md);
              //md=null;
          }
       i++;
      if(math.mod(i,3)!=1)
       {
          models.add(md);
       }
       
    }
        
    }
    
        public class modelclass{
            public contact contacts{get;set;}
             public contact con2{get;set;}
              public contact con3{get;set;}
            public integer sno{get;set;}
            public String brk{get;set;}
        }
}