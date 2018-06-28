public class P_ModelDemoController
{
    public List<ModelDemo> models{get;set;}
    P_ModelDemoController()
    {
    models=new list<ModelDemo>();
    ModelDemo md = new ModelDemo();
        for(Contact con : [select id,firstname,lastname from Contact])
        {
            md.contacts=con;
            md.isCheck=false;
            models.add(md);
        }
    }
        public class ModelDemo
        {
            public Contact contacts{get;set;}
            public boolean isCheck{get;set;}
        }
}