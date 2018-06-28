public class countStudentController
{
    public list<DemoModel> models{get;set;}
    public integer total{get;set;}
     public countStudentController()
     {
         models = new list<DemoModel>();
        DemoModel md = new DemoModel();
         integer i=1;
         for(Contact con  : [select firstname,lastname from contact])
         {
             md.Contacts=con;
             md.sno=i;
             i++;
            models.add(md);
        
         }
         total=i-1;
     /*  DemoModel md1=new  DemoModel ();
       md1.count=i-1;
       models.add(md1);  */
     } 
       public class DemoModel
       {
          
           public integer sno{get;set;}
           public Contact contacts{get;set;}
       }
}