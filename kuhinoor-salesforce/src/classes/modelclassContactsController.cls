public class modelclassContactsController{
        public List<contact> updatelist;
        public List<modelClass> models{get;set;}
        public modelclassContactsController(){
        models = new List<modelClass>();
        
        Integer i=1;
        List<contact> con = [ select firstname,lastname from contact];
        for(Contact c : con){
            modelClass obj = new modelClass();
            obj.sno=i;
            obj.isCheck = false;
            obj.contacts=c;
            i++;
            models.add(obj);
            
        }
       
    }
    public void extra(){}
    public pageReference updatemethod(){
     updatelist = new List<contact>();
        for(modelClass m : models){
            if(m.isCheck==true){
               updatelist.add(m.contacts);
            }
            
        }
        update updatelist;
        pagereference pr = new pageReference('/apex/modelclassContactsControllerpage');
        pr.setRedirect(true);
        return pr;
    }
    public class modelClass{
       public Integer sno{get;set;}
       public Contact contacts{get;set;}
       public boolean isCheck{get;set;}
    }
}