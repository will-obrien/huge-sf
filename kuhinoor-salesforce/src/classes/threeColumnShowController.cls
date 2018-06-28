public class threeColumnShowController{
    public List<modelClass> models{get;set;}
   
   
    
    public threeColumnShowController(){
        
        
       
        models = new List<modelclass>();
         Integer i=0;
         modelClass md ;
        List<contact> record = [select lastname from contact];
        for(Contact m : record){
         if(math.mod(i,3)==0)     
             md = new modelClass();
         if(m.lastname!=null){
          
           if(math.mod(i,3)==1){
           
               md.con1=m;
               
           }
          
           if(math.mod(i,3)==2){
                 md.con2=m;
                 
             }
          
             if(math.mod(i,3)==0){
                 md.con3=m;
                 
             }
             
               if(math.mod(i,3)==0){
         
                models.add(md);
             
               }
              i++;
             
         }
                System.debug('#####'+models);            
        }
      
    } 
    
    
    public class modelClass{
        public Integer no{get;set;}
        public contact con1{get;set;}
        public contact con2{get;set;}
        public contact con3{get;set;}
        
    }
}