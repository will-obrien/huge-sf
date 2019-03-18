public class studentdemoController
{
    public list<modelclass> models{get;set;}
    public studentdemoController()
    { 
    integer i= 1;
    for(Contact con : [select id,firstname from contact])
    {
        modelclass md = new modelclass();
        md.sno=i;
        i++;
        models.add(md);
    }
    
    }
       public class modelclass
       {
           
           public integer sno{get;set;}
          // public Stirng classname{get;set;}
       }
}