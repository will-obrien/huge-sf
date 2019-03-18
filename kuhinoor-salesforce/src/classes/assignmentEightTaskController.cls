public class assignmentEightTaskController{
   public list<ModelDemo> taskes{get;set;}
   public list<task> temp{get;set;}
   public string uid{get;set;}
   public String searchvalue{get;set;}
   public list<selectoption> selectdate{get;set;}

  
   public  Date today = date.today();
   public  integer month = date.today().month(); 
   public  integer year = date.today().year();
  
         
         // public  integer dy = date.day();
         public  integer mon = date.today().month();
    public assignmentEightTaskController(){
            selectdate = new list<selectoption>();
         
            selectdate.add(new selectoption('','----selecct---'));
            selectdate.add(new selectoption('today','today'));
             selectdate.add(new selectoption('this_week','this week'));
            selectdate.add(new selectoption('this_month','this month'));
         
           
       taskes = new list<ModelDemo>();
       temp = new list<task>();
          for(Task tk : [Select Subject,Status,Id,ActivityDate From Task ]){
              ModelDemo md = new ModelDemo();
              md.taskmodel = tk;
              md.isCheck =false;
              taskes.add(md);
          }
   }    
   public void extra(){
   }
   public pageReference search(){
     String query='Select Subject,Status,Id,ActivityDate From Task where ActivityDate='+searchvalue;
     list<task> tt=database.query(query);
     taskes.clear();
      for(Task tk : tt){
              ModelDemo md = new ModelDemo();
              md.taskmodel = tk;
              md.isCheck =false;
              taskes.add(md);
          }
   return new pageReference('/apex/assignmentEightTask');
   }
   public pageReference updatedata(){
       for(modeldemo m : taskes){
           if(m.isCheck == true){
               m.ischeck  =false;
               temp.add(m.taskmodel);
           }
          
       }update temp;
       return new pageReference ('/apex/assignmentEightTask'); 
   }
   public void extra2(){
   
   }
    public class ModelDemo{
            public Task taskmodel{get;set;}
            public Boolean isCheck{get;set;}
        }
}